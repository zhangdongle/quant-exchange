package com.quant.core.strategy.impl;

import com.alibaba.fastjson.JSON;
import com.quant.common.config.RedisUtil;
import com.quant.common.constans.RobotRedisKeyConfig;
import com.quant.common.domain.entity.MarketOrder;
import com.quant.common.domain.response.OrdersDetail;
import com.quant.common.domain.vo.BaseInfoEntity;
import com.quant.common.domain.vo.ProfitMessage;
import com.quant.common.domain.vo.StrategyVo;
import com.quant.common.enums.HBOrderType;
import com.quant.common.enums.OrderType;
import com.quant.common.exception.ExchangeNetworkException;
import com.quant.common.exception.TradingApiException;
import com.quant.core.builder.StrategyBuilder;
import com.quant.core.config.StrategyConfig;
import com.quant.core.redisMq.OrderIdRedisMqServiceImpl;
import com.quant.core.redisMq.OrderProfitRedisMqServiceImpl;
import com.quant.core.redisMq.RobotLogsRedisMqServiceImpl;
import com.quant.core.strategy.AbstractStrategy;
import com.quant.core.strategy.StrategyException;
import com.quant.core.strategy.TradingStrategy;
import com.quant.core.strategy.handle.HuobiSteadyBuyPriceHandle;
import com.quant.core.strategy.handle.HuobiSteadySellPriceHandle;
import com.quant.core.strategy.handle.StrategyHandle;
import com.quant.core.trading.OpenOrder;
import com.quant.core.trading.TradingApi;
import lombok.extern.slf4j.Slf4j;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;
import java.util.Optional;

/**
 * 火币策略
 *
 * @author yangyangchu
 * @Date 19.4.15
 */
@Slf4j
public class HuoBiSteadyStrategyImpl extends AbstractStrategy implements TradingStrategy, StrategyDelegate {
    //精确到小数点的个数
    private static final int decimalPoint = 4;
    //市场买卖信息
    private MarketOrder marketOrder;
    //亏损次数
    private int profitTimes;
    private Weights weights;
    private StrategyVo.Setting1Entity setting1;
    private StrategyVo.Setting2Entity setting2;
    private StrategyVo.Setting3Entity setting3;
    private StrategyVo.Setting4Entity setting4;
    private StrategyVo.Setting5Entity setting5;
    private StrategyVo.Setting6Entity setting6;
    private long runTimes = 0;
    private String lastOrderState = "lastOrderState_";
    private String orderProfitIds = "order_Profit_Ids_";
    /**
     * 当前的最新购买价格
     */
    private BigDecimal currentNewBuyPrice;
    /**
     * 当前的最新出售价格
     */
    private BigDecimal currentNewSellPrice;
    /**
     * 是否到达了亏损次数
     */
    private volatile boolean profitArrive = false;
    private BaseInfoEntity baseInfo;

    public HuoBiSteadyStrategyImpl(RedisUtil redisUtil, Integer robotId) {
        this.redisUtil = redisUtil;
        this.robotId = robotId;
        this.startkey = RobotRedisKeyConfig.getRobotIsStartStateKey() + robotId;
        this.isRunKey = RobotRedisKeyConfig.getRobotIsRunStateKey() + robotId;
    }


    /**
     * 权重计算
     */
    private void weightsCalculation() {

        if ((this.orderState.getType() == OrderType.SELL || this.orderState.getType() == null)
                && this.baseInfo.getBuyAllWeights() != 0) {
            buyCalculation();
        }

        if (this.orderState.getType() == OrderType.BUY && this.baseInfo.getSellAllWeights() != 0) {
            sellCalculation();
        }

    }

    @Override
    public void init(StrategyBuilder builder) {
        log.info("===============初始化参数" + builder.toString());
        this.tradingApi = builder.getTradingApi();
        this.marketConfig = builder.getMarketConfig();
        this.accountConfig = builder.getAccountConfig();
        this.redisUtil = builder.getRedisUtil();
        this.robotId = builder.getRobotStrategyVo().getRobotId();
        final StrategyConfig config = builder.getStrategyConfig();
        initSetting(config);
        this.strategyConfig = config;
        this.orderState = new OrderState();
        this.weights = new Weights();
        this.redisMqService = new RobotLogsRedisMqServiceImpl(this.redisUtil, this.robotId,
                Integer.parseInt(this.accountConfig.getUserId()));
        this.orderMqService = new OrderIdRedisMqServiceImpl(this.redisUtil, accountConfig, robotId);
        this.orderProfitService = new OrderProfitRedisMqServiceImpl(this.redisUtil);
        //限价 市价方式 redis key
        this.lastOrderState = lastOrderState + "type_" + this.baseInfo.getIsLimitPrice() + "_";
        this.orderProfitIds = orderProfitIds + "type_" + this.baseInfo.getIsLimitPrice() + "_";
    }

    private void initSetting(StrategyConfig config) {
        this.baseInfo = config.getStrategyVo().getBaseInfo();
    }

    @Override
    public void execute() throws StrategyException {
        init();
        // 任务循环执行
        while (true) {
            try {
                //设置机器人的运行状态 在休眠+20s之后没响应 就认为该机器人已经死亡
                redisUtil.set(isRunKey, "running", (long) (baseInfo.getSleep() + 20));
                //重置权重
                weights.reSet();
                //获取市场订单 最大支持2000条
                this.marketOrder = this.tradingApi.getMarketOrders(this.marketConfig, "2000");
                if (this.marketOrder == null) {
                    log.info("获取市场订单数据失败。。。重试ing");
                    redisMqService.sendMsg("获取市场行情数据失败！重试.......");
                    Thread.sleep(100);
                    continue;
                }
                //设置当前买价和当前卖价 (价格设置的位数来自huobi获取的价格小数位)
                this.currentNewBuyPrice = this.marketOrder.getBuy().get(0).getPrice()
                        .setScale(pricePrecision, RoundingMode.DOWN);
                this.currentNewSellPrice = this.marketOrder.getSell().get(0).getPrice()
                        .setScale(pricePrecision, RoundingMode.DOWN);
                //计算设置买卖权重
                this.weightsCalculation();

                //判断买卖
                if (orderState.getType() == OrderType.BUY) {
                    //查看是否达到卖的信号
                    if (this.weights.getSellTotal() != 0 && this.weights.getSellTotal() >= this.baseInfo
                            .getSellAllWeights()) {
                        try {
                            createSellOrder();
                        } catch (Exception e) {
                            e.printStackTrace();
                            log.error("下单失败{},{}", this.orderState.toString(), e.getMessage());
                            redisMqService.sendMsg("当前下单信息【" + this.orderState.toString() + "】==下单失败 重新下单！");
                        }

                    } else {
                        redisMqService.sendMsg(this.weights.getSellTotal() == 0 ?
                                "当前策略设置不进行卖出操作!!!" :
                                "当前策略计算卖出权重:" + this.weights.getSellTotal() + ",未达到策略卖出总权重【" + baseInfo
                                        .getSellAllWeights() + "】不进行操作。。。");
                    }
                } else if (orderState.getType() == OrderType.SELL) {
                    //查看是否到达买的信号
                    if (this.weights.getBuyTotal() != 0 && this.weights.getBuyTotal() >= this.baseInfo
                            .getBuyAllWeights()) {
                        try {
                            createBuyOrder();
                        } catch (Exception e) {
                            redisMqService.sendMsg("当前下单信息【" + this.orderState.toString() + "】==下单失败 重新下单！");
                            e.printStackTrace();
                            log.error("下单失败{},{}", this.orderState.toString(), e.getMessage());
                        }
                    } else {
                        redisMqService.sendMsg(this.weights.getBuyTotal() == 0 ?
                                "当前策略设置不进行买入操作!!!" :
                                "当前策略计算买入权重:" + this.weights.getBuyTotal() + ",未达到策略买入总权重【" + baseInfo
                                        .getBuyAllWeights() + "】不进行操作。。。");
                    }

                } else if (orderState.getType() == null) {
                    //查看当前订单状态 订单不存在的情况下 首先要出现买的信号 有了买的信号 进行购买
                    if (this.weights.getBuyTotal() != 0 && this.weights.getBuyTotal() >= this.baseInfo
                            .getBuyAllWeights()) {
                        createBuyOrder();
                    } else {
                        redisMqService.sendMsg("当前策略计算购买权重:" + this.weights.getBuyTotal() + ",未达到策略购买总权重【" + baseInfo
                                .getBuyAllWeights() + "】不进行操作。。。");
                    }
                }

                try {
                    ++runTimes;
                    redisMqService.sendMsg("机器人已经运行了>>>" + runTimes + "次");
                    log.info("=========================================");
                    //休眠几秒
                    Thread.sleep((long) (baseInfo.getSleep() * 1000));
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }

                if (!checkRobotIsStop(startkey)) {
                    redisMqService.sendMsg("机器人被取消任务!!!退出ing");
                    checkAndSet();
                    break;
                }

            } catch (Exception e) {
                log.error("机器人{}运行中发生异常：异常信息{}", robotId, e.getMessage());
                log.error("机器人异常", e);
                redisMqService.sendMsg("机器人运行中发生异常：异常信息" + e.getMessage());
            } finally {
                //记录当前机器人的最后一次状态
                redisUtil.set(lastOrderState + robotId, JSON.toJSONString(this.orderState));
            }
        }

    }


    private void checkAndSet() {
        checkOrder(this.tradingApi);
        //记录当前机器人的最后一次状态
        redisUtil.set(lastOrderState + robotId, JSON.toJSONString(this.orderState));
    }

    /**
     * 检查订单 如果订单没有撮合成功 直接取消
     * 返回true 可以执行下单操作
     * 返回false 不可执行下单操作
     *
     * @param tradingApi
     */
    private boolean checkOrder(TradingApi tradingApi) {
        log.info("当前订单状态{}", this.orderState.toString());
        if (this.orderState.getId() == null) {
            log.info("当前账户{}没有任何订单,开始下单", accountConfig.accountId());
            return true;
        }
        try {
            List<OpenOrder> openOrders = tradingApi.getOpenOrders(this.marketConfig, this.accountConfig, "10");
            Optional<OpenOrder> first = openOrders.stream()
                    .filter(openOrder -> openOrder.getId().equals(String.valueOf(this.orderState.getId()))).findFirst();
            if (first.isPresent()) {
                redisMqService.sendMsg("当前订单状态:【" + this.orderState.getType().getStringValue() + "】======");
                //比较上次的下单价格和这次的价格 如果相同的话 说明购买或者卖出订单可以被吃 等待被吃
                if (this.orderState.getType() == OrderType.BUY
                        && this.orderState.getPrice().compareTo(this.currentNewBuyPrice) == 0) {
                    return false;
                }
                if (this.orderState.getType() == OrderType.SELL
                        && this.orderState.getPrice().compareTo(this.currentNewSellPrice) == 0) {
                    return false;
                }
                //取消刚刚下的订单
                boolean cancel = tradingApi.cancelOrder(first.get().getId(), first.get().getMarketId());
                if (cancel) {
                    redisMqService.sendMsg(
                            "查询到未成功的订单开始取消订单,orderId【" + first.get().getId() + "】, 取消【" + this.orderState.getType()
                                    .getStringValue() + "】订单成功!!!");
                    if (this.orderState.getType() == OrderType.BUY) {
                        //如果当前订单是购买订单  取消了 应该继续购买
                        this.orderState.setType(null);
                    }
                    if (this.orderState.getType() == OrderType.SELL) {
                        //如果是卖出 应该继续卖出
                        this.orderState.setType(OrderType.BUY);
                    }
                    this.orderState.setId(null);
                    return false;
                }
            } else {
                //将成功的订单信息传回admin
                return messageBackAdmin(this);
            }
        } catch (ExchangeNetworkException | TradingApiException e) {
            log.error("账户{}取消订单失败{}", this.accountConfig.accountId(), e.getMessage());
            e.printStackTrace();
            return false;
        }
        return false;
    }

    /**
     * 计算盈利
     */
    @Override
    public void CalculateProfit() {

        try {
            if (this.orderState.getType() == OrderType.SELL) {

                Object o = this.redisUtil.lPop(orderProfitIds + robotId);
                if (o == null) {
                    log.info("当前redis 订单id 队列 暂无数据============== ");
                    return;
                }
                log.info("当前订单id 队列取出来的值是{}", o.toString());
                String current = o.toString();
                String[] currentIdAndType = current.split("_");
                if (currentIdAndType.length != 2) {
                    log.error("redis订单id队列存储异常数据{}", current);
                    return;
                }
                if (currentIdAndType[1].equals(OrderType.BUY.getStringValue())) {
                    //如果当前的是购买订单 不计算盈利 重新将值赋值到redis
                    this.redisUtil.lPush(orderProfitIds + robotId, o);
                    return;
                }

                long buyOrderId, sellOrderId;
                BigDecimal diff, divide;
                //获取上一次的购买金额和数量
                final Object last = this.redisUtil.lPop(orderProfitIds + robotId);
                if (last == null) {
                    log.error("获取订单id队列上一次的购买记录错误");
                    return;
                }
                log.info("上一次订单id 队列取出来的值是{}", last.toString());

                final String[] lastIdAndType = last.toString().split("_");

                //如果当前的订单是市价单 计算盈亏 需要查询这个订单的详情信息
                buyOrderId = Long.parseLong(lastIdAndType[0]);
                sellOrderId = Long.parseLong(currentIdAndType[0]);
                log.info("当前出售订单id{},当前购买订单id{}", sellOrderId, buyOrderId);
                //订单详情
                OrdersDetail ordersBuyDetail, ordersSellDetail;
                //获取订单详情
                ordersBuyDetail = getOrderDetail(buyOrderId, 0);
                if (ordersBuyDetail == null) {
                    log.info("获取购买订单为null");
                    return;
                }
                if (new BigDecimal(ordersBuyDetail.getFieldCashAmount()).compareTo(BigDecimal.ZERO) == 0) {
                    return;
                }
                ordersSellDetail = getOrderDetail(sellOrderId, 0);
                if (ordersSellDetail == null) {
                    log.info("获取出售订单为null");
                    return;
                }
                if (new BigDecimal(ordersSellDetail.getFieldCashAmount()).compareTo(BigDecimal.ZERO) == 0) {
                    return;
                }
                //如果是市价的情况
                final Profit profit = new Profit(ordersBuyDetail, ordersSellDetail, orderState).invoke();

                //计算盈亏率 卖出总金额-买入总金额 除以 买入总金额
                diff = profit.getAllSellBalance().subtract(profit.getAllBuyBalance())
                        .setScale(pricePrecision, RoundingMode.DOWN);
                log.info("当前的订单状态{},计算后的差价{}", this.orderState.getType().getStringValue(), diff);
                divide = diff.divide(profit.getAllBuyBalance(), decimalPoint, RoundingMode.DOWN);
                log.info("盈亏率:{}", divide);
                if (diff.compareTo(BigDecimal.ZERO) < 0) {
                    profitTimes++;
                }
                final ProfitMessage profitMessage = getProfitMessage(buyOrderId, sellOrderId, diff, divide,
                        ordersBuyDetail, ordersSellDetail, profit);
                orderProfitService.sendMsg(profitMessage);
                if (profitTimes >= this.baseInfo.getProfit()) {
                    //如果亏损次数已经达到预设值 机器人退出线程
                    redisMqService.sendMsg("=======当前亏损次数【" + profitTimes + "】==已经达到预设值,机器人退出任务ing,请修改此策略重新来！！");
                    log.info("当前亏损次数达到了！结束任务。。。");
                    //记录当前机器人的最后一次状态
                    redisUtil.set(lastOrderState + robotId, JSON.toJSONString(this.orderState));
                    this.profitArrive = true;
                }
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            log.error("计算盈亏率发生异常{}", e.getMessage());
        }

    }

    private ProfitMessage getProfitMessage(long buyOrderId, long sellOrderId, BigDecimal diff, BigDecimal divide,
            OrdersDetail ordersBuyDetail, OrdersDetail ordersSellDetail, Profit profit) {
        ProfitMessage profitMessage = new ProfitMessage();
        profitMessage.setBuyOrderId(buyOrderId);
        profitMessage.setSellOrderId(sellOrderId);
        profitMessage.setRobot_id(robotId);
        profitMessage.setBuyAmount(profit.getBuyAmount());
        profitMessage.setSellAmount(profit.getSellAmount());
        profitMessage.setDiff(diff);
        profitMessage.setDivide(divide);
        profitMessage.setBuyPrice(profit.getBuyPrice());
        profitMessage.setSellPrice(profit.getSellPrice());
        profitMessage.setBuyCashAmount(
                new BigDecimal(ordersBuyDetail.getFieldCashAmount()).setScale(pricePrecision, RoundingMode.DOWN));
        profitMessage.setSellCashAmount(
                new BigDecimal(ordersSellDetail.getFieldCashAmount()).setScale(pricePrecision, RoundingMode.DOWN));
        return profitMessage;
    }


    /**
     * 创建购买订单
     */
    private void createBuyOrder() {
        if (!checkOrder(tradingApi)) {
            log.info("不创建订单");
            return;
        }
        if (profitArrive) {
            log.info("机器人退出");
            return;
        }
        //获取余额
        if (!getBalance()) {
            redisMqService.sendMsg("未获取账户【" + this.accountConfig.accountId() + "】的余额信息！！！");
            return;
        }
        if (this.quotaBalance.compareTo(BigDecimal.ZERO) < 0) {
            redisMqService.sendMsg("账户【" + this.accountConfig.accountId() + "】没有余额,请及时充值=======");
            return;
        }
        //是否是限价
        StrategyHandle strategyHandle = new HuobiSteadyBuyPriceHandle(null);
        StrategyHandle.HandleResult handleResult = strategyHandle
                .strategyRequest(tradingApi, marketConfig, strategyConfig, accountConfig, pricePrecision,
                        amountPrecision, baseBalance);
        setHandleResult(handleResult);
        handleResultForBuy(this);
    }

    /**
     * 创建卖出订单
     * 检查上一次的买入订单是否成功 如果不成功就取消订单
     */
    private void createSellOrder() {
        if (!checkOrder(tradingApi)) {
            return;
        }
        if (profitArrive) {
            return;
        }

        if (!getBalance()) {
            return;
        }
        if (this.baseBalance.compareTo(BigDecimal.ZERO) < 0) {
            log.info("账户{},{}没有余额 请及时充值", this.accountConfig.accountId(), this.baseCurrency);
            redisMqService
                    .sendMsg("账户id【" + this.accountConfig.accountId() + "】,【" + this.baseCurrency + "】没有余额 请及时充值");
            return;
        }
        //是否是限价
        final StrategyHandle strategyHandle = new HuobiSteadySellPriceHandle(new HuobiSteadySellPriceHandle(null));
        final StrategyHandle.HandleResult handleResult = strategyHandle
                .strategyRequest(tradingApi, marketConfig, strategyConfig, accountConfig, pricePrecision,
                        amountPrecision, baseBalance);
        //获取结果
        setHandleResult(handleResult);
        handleResultForSell(this);
    }

    /**
     * 记录订单状态和每次的交易额和数量
     *
     * @param tradingApi
     * @param sellAmount
     * @param sellPrice
     * @param HBOrderType
     * @param type
     */
    public void orderPlace(TradingApi tradingApi, BigDecimal sellAmount, BigDecimal sellPrice, HBOrderType HBOrderType,
            OrderType type) {

        this.orderState.setAmount(sellAmount);
        this.orderState.setPrice(sellPrice);
        this.orderState.setHBOrderType(HBOrderType);
        this.order(sellAmount, sellPrice, HBOrderType, tradingApi, type);
    }

    @Override
    protected void buyCalculation() {
        redisMqService.sendMsg("机器人当前状态>>>>>>【待买入】");
        redisMqService.sendMsg("当前市场最新买入价格:" + currentNewBuyPrice);
        if (currentNewBuyPrice.compareTo(this.baseInfo.getBuyPrice()) < 0) {
            weights.AddBuyTotal(100);
        }
    }

    @Override
    protected void sellCalculation() {
        redisMqService.sendMsg("机器人当前状态>>>>>>【待卖出】");
        redisMqService.sendMsg("当前市场最新卖出价格:" + currentNewSellPrice);
        if (currentNewBuyPrice.compareTo(this.baseInfo.getSellPrice()) > 0) {
            weights.AddSellTotal(100);
        }
    }


}

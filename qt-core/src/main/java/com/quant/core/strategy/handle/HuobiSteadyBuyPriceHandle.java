package com.quant.core.strategy.handle;

import com.quant.common.domain.entity.MarketOrder;
import com.quant.common.domain.vo.BaseInfoEntity;
import com.quant.common.enums.HBOrderType;
import com.quant.common.enums.PirceType;
import com.quant.common.enums.SellType;
import com.quant.core.config.AccountConfig;
import com.quant.core.config.MarketConfig;
import com.quant.core.config.StrategyConfig;
import com.quant.core.trading.TradingApi;
import lombok.extern.slf4j.Slf4j;

import java.math.BigDecimal;
import java.math.RoundingMode;

/**
 * 稳定币
 * Created by yang on 2019/8/23.
 */
@Slf4j
public class HuobiSteadyBuyPriceHandle extends StrategyHandle {


    public HuobiSteadyBuyPriceHandle(StrategyHandle handle) {
        super(handle);
    }

    @Override
    public HandleResult strategyRequest(TradingApi tradingApi, MarketConfig marketConfig, StrategyConfig config,
            AccountConfig accountConfig, int pricePrecision, int amountPrecision, BigDecimal baseBalance) {

        if (getHandle() == null) {
            return null;
        }

        final BaseInfoEntity baseInfo = config.getIndicatorStrategy().getBaseInfo();
        if (baseInfo.getIsLimitPrice() == PirceType.isLimit.getType()) {
            //从当前的20个卖出订单里找出最优的价格 （限价卖出）
            final MarketOrder marketOrder = tradingApi.getMarketOrders(marketConfig, "500");
            final BigDecimal currentBuyPrice = marketOrder.getBuy().get(0).getPrice();
            //计算买入的价格
            final BigDecimal buyPrice = currentBuyPrice;
            //计算购买的数量 是否全部卖出
            BigDecimal buyAmount = BigDecimal.ZERO;
            if (baseInfo.getIsAllSell() == SellType.sellAll.getType()) {
                //从用户api的表里查询到他的账户相应的base 火币的数量全部购买
                buyAmount = buyAmount.add(baseBalance).setScale(amountPrecision, RoundingMode.DOWN);
            } else {
                buyAmount = buyAmount.add(baseInfo.getSellAmount().setScale(amountPrecision, RoundingMode.DOWN));
            }
            HBOrderType hbOrderType = HBOrderType.BUY_LIMIT;
            return new HandleResult(hbOrderType, buyPrice, buyAmount);
        } else {
            return getHandle()
                    .strategyRequest(tradingApi, marketConfig, config, accountConfig, pricePrecision, amountPrecision,
                            baseBalance);

        }


    }
}

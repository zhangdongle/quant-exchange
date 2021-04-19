package com.quant.admin.service.impl;

import com.alibaba.fastjson.JSON;
import com.baomidou.mybatisplus.mapper.EntityWrapper;
import com.baomidou.mybatisplus.mapper.Wrapper;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;
import com.quant.admin.dao.RobotMapper;
import com.quant.common.domain.entity.Account;
import com.quant.common.domain.entity.Robot;
import com.quant.common.domain.entity.Strategy;
import com.quant.common.domain.bo.RobotBo;
import com.quant.admin.rest.RobotClientService;
import com.quant.admin.service.RobotService;
import com.quant.common.config.RedisUtil;
import com.quant.common.constans.RobotRedisKeyConfig;
import com.quant.common.domain.to.BuyAndSellIndicatorTo;
import com.quant.common.domain.to.llIndicatorTo;
import com.quant.common.domain.vo.*;
import com.quant.core.api.ApiResult;
import com.quant.common.enums.RobotState;
import com.quant.common.enums.Status;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.validation.constraints.NotBlank;
import java.util.Date;
import java.util.List;

/**
 * <p>
 * 服务实现类
 * </p>
 *
 * @author yang
 * @since 2019-04-17
 */
@Slf4j
@Service
public class RobotServiceImpl extends ServiceImpl<RobotMapper, Robot> implements RobotService {

    @Autowired
    RobotMapper robotMapper;

    @Autowired
    RedisUtil redisUtil;

    @Autowired
    RobotClientService robotClientService;

    @Override
    public ApiResult addOrUpdateRobot(RobotVo vo) {
        if (vo == null) {
            return new ApiResult(Status.ERROR);
        }
        try {
            Robot robot = new Robot();
            robot.setRobotName(vo.getRobotName());
            robot.setClientAddress(vo.getNodeAddress());
            robot.setStrategyId(vo.getStrategyId());
            robot.setAccountId(vo.getAccountId());
            robot.setCreateTime(new Date());
            robot.setUserId(vo.getUserId());
            robot.setSymbol(vo.getSymbol());
            if (vo.getId() != null) {
                robot.setId(vo.getId());
                boolean b = robot.updateById();
                if (b) {
                    return new ApiResult(Status.SUCCESS, "机器人更新成功");
                }
            } else {
                if (robot.insert()) {
                    return new ApiResult(Status.SUCCESS, "机器人添加成功");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            log.error("添加机器人发生异常{}" + e.getMessage());
        }
        return new ApiResult(Status.ERROR);
    }

    /**
     * 获取机器人列表
     * todo 这里检查机器人是否还在运行 不再用task来检测
     *
     * @param uid
     * @return
     */
    @Override
    public ApiResult list(String uid) {
        try {
            List<RobotBo> robotList = robotMapper.getRobotList(uid);
            //检测机器人的状态
            for (RobotBo r : robotList) {
                String key = RobotRedisKeyConfig.getRobotIsRunStateKey() + r.getId();
                Object o = redisUtil.get(key);
                if (o == null) {
                    //检测是否已经更新了
                    if (r.getIsRun() == 1) {
                        //更新数据库机器人状态
                        Robot robot = new Robot();
                        robot.setId(r.getId());
                        robot.setIsRun(0);
                        robot.updateById();
                    }
                    //已经取消了机器人的运行
                    r.setIsRun(0);
                } else {
                    r.setIsRun(1);
                }
            }
            return new ApiResult(Status.SUCCESS, robotList);
        } catch (Exception e) {
            e.printStackTrace();
            log.error("获取机器人列表发生异常{}", e.getMessage());
            return new ApiResult(Status.getRobotListError);
        }
    }

    /**
     * 启动或关闭机器人
     * 构造相关的参数传递给client服务 服务异步处理机器人的信息
     *
     * @param id
     * @param uid
     * @param state 1 启动 0停止
     * @return
     */
    @Override
    public ApiResult operatingRobot(Integer id, Integer state, String uid) {

        if (state == RobotState.stop.getStr()) {
            //关闭机器人
            String isStartKey = RobotRedisKeyConfig.getRobotIsStartStateKey() + id;
            boolean flag = redisUtil.set(isStartKey, false);
            if (flag) {
                //修改机器人的状态
                Robot robot = new Robot();
                robot.setId(id);
                robot.setIsRun(0);
                boolean byId = robot.updateById();
                if (byId) {
                    log.info("机器人{}状态被修改为关闭", id);
                }
            } else {
                log.info("机器人id{}关闭失败了", id);
            }
            return new ApiResult(Status.SUCCESS, "机器人已经关闭了");
        }

        //通过机器人id查询机器人的信息
        Wrapper<Robot> robotWrapper = new EntityWrapper<>();
        robotWrapper.eq("id", id);
        Robot robot = new Robot();
        Robot oneRobot = robot.selectOne(robotWrapper);

        //获取机器人的策略id 查询出策略信息
        int strategyId = oneRobot.getStrategyId();

        // //查询账户信息获取uid的appkey 和密钥
        Wrapper<Account> accountWrapper = new EntityWrapper<>();
        accountWrapper.eq("id", oneRobot.getAccountId());
        Account account = new Account();
        Account selectOne = account.selectOne(accountWrapper);

        //设置账户信息
        com.quant.common.domain.vo.Account accountConfig = new com.quant.common.domain.vo.Account();
        accountConfig.setId(String.valueOf(selectOne.getId()));
        accountConfig.setType(selectOne.getType());
        accountConfig.setState(selectOne.getState());
        accountConfig.setAccessKey(selectOne.getAccessKey());
        accountConfig.setSecretKey(selectOne.getSecretKey());
        accountConfig.setUserId(uid);

        Wrapper<Strategy> strategyWrapper = new EntityWrapper<>();
        strategyWrapper.eq("id", strategyId);

        Strategy strategy = new Strategy();
        Strategy strategyOne = strategy.selectOne(strategyWrapper);
        if (strategyOne != null) {
            //组装机器人基础信息
            if (strategyOne.getStrategyType() == 0) {
                StrategyVo strategyVo = new StrategyVo();
                BaseInfoEntity baseInfoEntity = new BaseInfoEntity();
                baseInfoEntity.setStrategyName(strategyOne.getStrategyName());
                baseInfoEntity.setBuyAllWeights(strategyOne.getBuyAllWeights());
                baseInfoEntity.setBuyAmount(strategyOne.getBuyAmount());
                baseInfoEntity.setBuyPrice(strategyOne.getBuyPrice());
                baseInfoEntity.setProfit(strategyOne.getProfit());
                baseInfoEntity.setSleep(strategyOne.getSleep());
                baseInfoEntity.setIsAllBuy(strategyOne.getIsAllBuy());
                baseInfoEntity.setIsLimitPrice(strategyOne.getIsLimitPrice());
                baseInfoEntity.setIsAllSell(strategyOne.getIsAllSell());
                baseInfoEntity.setSellAllWeights(strategyOne.getSellAllWeights());
                baseInfoEntity.setSellAmount(strategyOne.getSellAmount());
                baseInfoEntity.setSellPrice(strategyOne.getSellPrice());
                baseInfoEntity.setBuyQuotaPrice(strategyOne.getBuyQuotaPrice());
                strategyVo.setBaseInfo(baseInfoEntity);

                //组装机器人的策略1-5
                StrategyVo.Setting1Entity setting1Entity = JSON.parseObject(strategyOne.getSetting1(), StrategyVo.Setting1Entity.class);
                strategyVo.setSetting1(setting1Entity);

                StrategyVo.Setting2Entity setting2Entity = JSON.parseObject(strategyOne.getSetting2(), StrategyVo.Setting2Entity.class);
                strategyVo.setSetting2(setting2Entity);

                StrategyVo.Setting3Entity setting3Entity = JSON.parseObject(strategyOne.getSetting3(), StrategyVo.Setting3Entity.class);
                strategyVo.setSetting3(setting3Entity);

                StrategyVo.Setting4Entity setting4Entity = JSON.parseObject(strategyOne.getSetting4(), StrategyVo.Setting4Entity.class);
                strategyVo.setSetting4(setting4Entity);

                StrategyVo.Setting5Entity setting5Entity = JSON.parseObject(strategyOne.getSetting5(), StrategyVo.Setting5Entity.class);
                strategyVo.setSetting5(setting5Entity);

                StrategyVo.Setting6Entity setting6Entity = JSON.parseObject(strategyOne.getSetting6(), StrategyVo.Setting6Entity.class);
                strategyVo.setSetting6(setting6Entity);
                //组装整体机器人vo
                RobotStrategyVo robotStrategyVo = new RobotStrategyVo();
                robotStrategyVo.setRobotId(oneRobot.getId());
                robotStrategyVo.setSymbol(oneRobot.getSymbol());
                robotStrategyVo.setAppKey(selectOne.getAccessKey());
                robotStrategyVo.setAppSecret(selectOne.getSecretKey());
                robotStrategyVo.setAddress(oneRobot.getClientAddress());
                robotStrategyVo.setStrategyVo(strategyVo);
                robotStrategyVo.setAccountConfig(accountConfig);
                String url = "http://" + oneRobot.getClientAddress() + "/robot/operatingRobot";
                return robotClientService.operatingRobot(url, robotStrategyVo);
            } else {
                BuyAndSellIndicatorTo buyAndSellIndicatorTo = JSON.parseObject(strategyOne.getSetting1(), BuyAndSellIndicatorTo.class);

                BaseInfoEntity baseInfoEntity = new BaseInfoEntity();
                baseInfoEntity.setStrategyName(strategyOne.getStrategyName());
                baseInfoEntity.setBuyAllWeights(strategyOne.getBuyAllWeights());
                baseInfoEntity.setBuyAmount(strategyOne.getBuyAmount());
                baseInfoEntity.setBuyPrice(strategyOne.getBuyPrice());
                baseInfoEntity.setSleep(strategyOne.getSleep());
                baseInfoEntity.setIsAllBuy(strategyOne.getIsAllBuy());
                baseInfoEntity.setIsLimitPrice(strategyOne.getIsLimitPrice());
                baseInfoEntity.setIsAllSell(strategyOne.getIsAllSell());
                baseInfoEntity.setSellAllWeights(strategyOne.getSellAllWeights());
                baseInfoEntity.setSellAmount(strategyOne.getSellAmount());
                baseInfoEntity.setSellPrice(strategyOne.getSellPrice());
                baseInfoEntity.setBuyQuotaPrice(strategyOne.getBuyQuotaPrice());

                llIndicatorTo indicatorTo=new llIndicatorTo();
                indicatorTo.setBaseData(buyAndSellIndicatorTo);
                indicatorTo.setBaseInfo(baseInfoEntity);

                IndicatorStrategyVo indicatorStrategyVo = new IndicatorStrategyVo();
                indicatorStrategyVo.setIndicatorTo(indicatorTo);
                indicatorStrategyVo.setAccountConfig(accountConfig);

                //appkey he miyao
                indicatorStrategyVo.setRobotId(oneRobot.getId());
                indicatorStrategyVo.setSymbol(oneRobot.getSymbol());
                indicatorStrategyVo.setAppKey(selectOne.getAccessKey());
                indicatorStrategyVo.setAppSecret(selectOne.getSecretKey());
                indicatorStrategyVo.setAddress(oneRobot.getClientAddress());


                String url = "http://" + oneRobot.getClientAddress() + "/robot/operatingIndicatorRobot";
                return robotClientService.operatingIndicatorRobot(url, indicatorStrategyVo);
            }


        }
        return new ApiResult(Status.ERROR);
    }

    @Override
    public ApiResult deleteRobot(String uid, int id) {
        Wrapper<Robot> robotWrapper = new EntityWrapper<>();
        robotWrapper.eq("user_id", uid);
        robotWrapper.eq("id", id);
        Robot robot = new Robot();
        robot.setId(id);
        try {
            if (robot.delete(robotWrapper)) {
                return new ApiResult(Status.SUCCESS);
            }
        } catch (Exception e) {
            e.printStackTrace();
            log.error("删除机器人异常{}", e.getMessage());
        }
        return new ApiResult(Status.ERROR);
    }

    @Override
    public boolean editRobotRunState(int runState) {
        return false;
    }

    @Override
    public ApiResult getRobotById(@NotBlank int id) {
        Robot robot = new Robot();
        Robot byId = robot.selectById(id);
        return new ApiResult(Status.SUCCESS, byId);
    }
}

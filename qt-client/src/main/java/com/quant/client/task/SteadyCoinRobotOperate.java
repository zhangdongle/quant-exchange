package com.quant.client.task;

import com.quant.common.config.RedisUtil;
import com.quant.common.config.VpnProxyConfig;
import com.quant.common.domain.vo.RobotStrategyVo;
import com.quant.common.enums.StrategyType;
import com.quant.core.builder.StrategyBuilder;
import com.quant.core.strategy.StrategyException;
import com.quant.core.strategy.TradingStrategy;
import com.quant.core.strategy.impl.HuoBiSteadyStrategyImpl;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class SteadyCoinRobotOperate {

    private RedisUtil redisUtil;


    private VpnProxyConfig vpnProxyConfig;

    public SteadyCoinRobotOperate(RedisUtil redisUtil, VpnProxyConfig vpnProxyConfig) {
        this.redisUtil = redisUtil;
        this.vpnProxyConfig = vpnProxyConfig;
    }

    public void doRobotTask(RobotStrategyVo vo) {
        log.info("启动机器人{}>>>>>>", vo.getRobotId());
        TradingStrategy strategy = builderStrategy(vo);
        try {
            strategy.execute();
        } catch (StrategyException e) {
            e.printStackTrace();
        }

    }

    private TradingStrategy builderStrategy(RobotStrategyVo vo) {

        StrategyType simple = StrategyType.simple;
        StrategyBuilder builder = new StrategyBuilder().setRedisUtil(redisUtil).setStratrgyType(simple)
                .setRobotStrategyVo(vo).setVpnProxyConfig(vpnProxyConfig).buildApiClient().buildTradingApi()
                .buildMarketConfig().buildStrategyConfig().buildAccountConfig();

        TradingStrategy strategy = new HuoBiSteadyStrategyImpl(redisUtil, vo.getRobotId());

        log.info("加载稳定币机器人{}>>>>>>", vo.getRobotId());
        strategy.init(builder);
        return strategy;
    }

}

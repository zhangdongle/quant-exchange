package com.quant.core.config.imp;

import com.quant.core.config.MarketConfig;
import com.quant.common.domain.vo.Market;

public class HuoBiMarketConfigImpl implements MarketConfig {
    private Market market;

    public HuoBiMarketConfigImpl(Market market) {
        this.market = market;
    }


    @Override
    public String markName() {
        return market.getMarketName();
    }


}

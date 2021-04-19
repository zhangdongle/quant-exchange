package com.quant.core.config.imp;

import com.quant.core.config.KlineConfig;


public class HuoBiKlineConfigImpl implements KlineConfig {

    String size;
    String period;

    public HuoBiKlineConfigImpl(String size, String period) {
        this.size = size;
        this.period = period;
    }

    @Override
    public String size() {
        return size;
    }

    @Override
    public String period() {
        return period;
    }
}

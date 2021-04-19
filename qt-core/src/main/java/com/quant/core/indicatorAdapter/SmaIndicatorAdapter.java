package com.quant.core.indicatorAdapter;


import com.quant.common.domain.to.BuyAndSellIndicatorTo;
import org.ta4j.core.BarSeries;
import org.ta4j.core.Indicator;
import org.ta4j.core.indicators.SMAIndicator;


/**
 * sma指标计算
 */
public class SmaIndicatorAdapter extends IndicatorAdapter {


    public SmaIndicatorAdapter(BarSeries timeSeries, int barCount, BuyAndSellIndicatorTo.SourceBean sourceBean) {
        super(timeSeries, barCount, sourceBean);
    }

    /**
     * 计算并返回Indicator
     *
     * @return
     */
    @Override
    public Indicator indicatorCalculation() {
        final Indicator indicator = defaultIndicatorFromSource();
        return new SMAIndicator(indicator, barCount);
    }
}


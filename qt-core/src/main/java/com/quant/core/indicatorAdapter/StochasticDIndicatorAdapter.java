package com.quant.core.indicatorAdapter;

import org.ta4j.core.BarSeries;
import org.ta4j.core.Indicator;
import org.ta4j.core.indicators.SMAIndicator;
import org.ta4j.core.indicators.StochasticRSIIndicator;
import org.ta4j.core.num.Num;

/**
 * Created by yang on 2019/5/30.
 */
public class StochasticDIndicatorAdapter extends IndicatorAdapter {


    public StochasticDIndicatorAdapter(BarSeries timeSeries, int barCount) {
        super(timeSeries, barCount);
    }


    @Override
    public Indicator indicatorCalculation() {
        Indicator<Num> stochRSI = new StochasticRSIIndicator(timeSeries, 14);
        return new SMAIndicator(stochRSI, barCount);
    }
}

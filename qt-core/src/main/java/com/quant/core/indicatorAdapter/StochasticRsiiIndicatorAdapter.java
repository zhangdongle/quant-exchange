package com.quant.core.indicatorAdapter;

import com.quant.common.domain.to.BuyAndSellIndicatorTo;
import org.ta4j.core.BarSeries;
import org.ta4j.core.Indicator;
import org.ta4j.core.indicators.RSIIndicator;
import org.ta4j.core.indicators.StochasticRSIIndicator;

/**
 * Created by yang on 2019/5/30.
 */
public class StochasticRsiiIndicatorAdapter extends IndicatorAdapter {


    public StochasticRsiiIndicatorAdapter(BarSeries timeSeries, int barCount, int barCount2,
            BuyAndSellIndicatorTo.SourceBean sourceBean) {
        super(timeSeries, barCount, barCount2, sourceBean);
    }


    @Override
    public Indicator indicatorCalculation() {
        final Indicator indicator = defaultIndicatorFromSource();
        RSIIndicator r = new RSIIndicator(indicator, barCount);
        return new StochasticRSIIndicator(r, barCount2);
    }
}

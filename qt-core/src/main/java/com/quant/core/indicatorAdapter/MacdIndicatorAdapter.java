package com.quant.core.indicatorAdapter;

import com.quant.common.domain.to.BuyAndSellIndicatorTo;
import org.ta4j.core.BarSeries;
import org.ta4j.core.Indicator;
import org.ta4j.core.indicators.MACDIndicator;

/**
 * 计算madc指标
 * Created by yang on 2019/5/26.
 */
public class MacdIndicatorAdapter extends IndicatorAdapter {

    public MacdIndicatorAdapter(BarSeries timeSeries, Integer barCount, Integer barCount2,
            BuyAndSellIndicatorTo.SourceBean sourceBean) {
        super(timeSeries, barCount, barCount2, sourceBean);
    }

    @Override
    public Indicator indicatorCalculation() {
        final Indicator indicator = defaultIndicatorFromSource();
        if (barCount != null && barCount2 == null) {
            return new MACDIndicator(indicator, barCount, 26);
        }
        if (barCount != null && barCount2 != null) {
            return new MACDIndicator(indicator, barCount, barCount2);
        } else {
            return new MACDIndicator(indicator);
        }
    }
}

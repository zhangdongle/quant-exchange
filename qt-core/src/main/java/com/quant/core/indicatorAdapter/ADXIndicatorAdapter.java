package com.quant.core.indicatorAdapter;

import com.quant.common.domain.to.BuyAndSellIndicatorTo;
import org.ta4j.core.BarSeries;
import org.ta4j.core.Indicator;
import org.ta4j.core.indicators.adx.ADXIndicator;

/**
 * 计算adx指标
 * Created by yang on 2019/5/26.
 */
public class ADXIndicatorAdapter extends IndicatorAdapter {

    public ADXIndicatorAdapter(BarSeries timeSeries, int barCount, BuyAndSellIndicatorTo.SourceBean sourceBean) {
        super(timeSeries, barCount, sourceBean);
    }

    @Override
    public Indicator indicatorCalculation() {
        return new ADXIndicator(timeSeries, barCount);
    }
}

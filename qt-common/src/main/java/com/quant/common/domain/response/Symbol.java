package com.quant.common.domain.response;

import lombok.Data;

@Data
public class Symbol {

    private String baseCurrency;
    private String quoteCurrency;
    private String symbol;
    private Integer pricePrecision;
    private Integer amountPrecision;

}

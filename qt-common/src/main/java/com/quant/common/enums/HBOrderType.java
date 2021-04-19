package com.quant.common.enums;

public enum HBOrderType {
    /**
     * 限价买入
     */
    BUY_LIMIT("buy-limit"),
    /**
     * 限价卖出
     */
    SELL_LIMIT("sell-limit"),

    /**
     * 市价买入
     */
    BUY_MARKET("buy-market"),
    /**
     * 市价卖出
     */
    SELL_MARKET("sell-market");

    String tyoe;

    HBOrderType(String tyoe) {
        this.tyoe = tyoe;
    }

    public String getTyoe() {
        return tyoe;
    }
}

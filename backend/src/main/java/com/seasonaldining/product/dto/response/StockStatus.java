package com.seasonaldining.product.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

/** 재고 상태 — stockQuantity null=UNKNOWN, 0=SOLD_OUT, 1+=IN_STOCK. */
@Schema(description = "재고 상태: stockQuantity가 null이면 UNKNOWN, 0이면 SOLD_OUT, 1 이상이면 IN_STOCK")
public enum StockStatus {
    IN_STOCK, SOLD_OUT, UNKNOWN;

    public static StockStatus from(Integer stockQuantity) {
        if (stockQuantity == null) return UNKNOWN;
        return stockQuantity <= 0 ? SOLD_OUT : IN_STOCK;
    }
}

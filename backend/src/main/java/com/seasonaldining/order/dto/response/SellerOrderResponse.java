package com.seasonaldining.order.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.List;

/**
 * 판매자 대시보드의 받은 주문 1건.
 * items는 이 농가에 해당하는 항목만(다른 농가 항목은 제외). status/배송정보는 주문 단위.
 */
@Schema(description = "판매자 받은 주문 응답")
public record SellerOrderResponse(
        @Schema(description = "주문 ID") Long orderId,
        @Schema(description = "주문번호", example = "20260613-101530123-a1b2") String orderNumber,
        @Schema(description = "상태 PAID|PREPARING|SHIPPED|DELIVERED|CANCELLED", example = "PAID") String status,
        @Schema(description = "이 농가 항목 소계(상품가 합계)") BigDecimal producerSubtotal,
        @Schema(description = "택배사(SHIPPED부터)") String carrier,
        @Schema(description = "운송장 번호(SHIPPED부터)") String trackingNumber,
        @Schema(description = "발송 시각") OffsetDateTime shippedAt,
        @Schema(description = "배송완료 시각") OffsetDateTime deliveredAt,
        @Schema(description = "주문 시각(ISO 8601)") OffsetDateTime orderedAt,
        @Schema(description = "이 농가 주문 항목") List<Item> items
) {
    @Schema(description = "판매자 주문 항목")
    public record Item(
            @Schema(description = "상품명(스냅샷)") String title,
            @Schema(description = "식재료명") String ingredientName,
            @Schema(description = "수량") int qty,
            @Schema(description = "단위") String unit,
            @Schema(description = "단가") BigDecimal unitPrice
    ) {}
}

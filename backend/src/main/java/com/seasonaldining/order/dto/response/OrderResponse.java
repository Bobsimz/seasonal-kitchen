package com.seasonaldining.order.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.List;

@Schema(description = "주문 상세 응답 — 주문완료/주문상세 화면")
public record OrderResponse(
        @Schema(description = "주문 ID") Long id,
        @Schema(description = "주문번호", example = "2026-0609-0427") String orderNumber,
        @Schema(description = "상태", example = "PAID") String status,
        @Schema(description = "상품 합계") BigDecimal itemsTotal,
        @Schema(description = "배송비") BigDecimal shippingFee,
        @Schema(description = "결제 금액") BigDecimal totalAmount,
        @Schema(description = "적립 포인트") BigDecimal pointsEarned,
        @Schema(description = "주문 시각(ISO 8601)") OffsetDateTime orderedAt,
        @Schema(description = "주문 항목") List<Item> items
) {
    @Schema(description = "주문 항목")
    public record Item(
            @Schema(description = "농가 이름") String producerName,
            @Schema(description = "식재료명") String ingredientName,
            @Schema(description = "수량") int qty,
            @Schema(description = "단가") BigDecimal unitPrice
    ) {}
}

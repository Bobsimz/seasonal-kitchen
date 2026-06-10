package com.seasonaldining.order.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import java.math.BigDecimal;
import java.time.OffsetDateTime;

@Schema(description = "주문 요약 응답 — 주문 내역 목록")
public record OrderSummaryResponse(
        @Schema(description = "주문 ID") Long id,
        @Schema(description = "주문번호", example = "2026-0609-0427") String orderNumber,
        @Schema(description = "상태", example = "DELIVERED") String status,
        @Schema(description = "결제 금액") BigDecimal totalAmount,
        @Schema(description = "대표 상품 요약", example = "봄동 외 2건") String summary,
        @Schema(description = "주문 시각(ISO 8601)") OffsetDateTime orderedAt
) {}

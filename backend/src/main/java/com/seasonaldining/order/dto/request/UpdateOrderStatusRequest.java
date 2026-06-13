package com.seasonaldining.order.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

/**
 * 판매자 주문 상태 변경 요청.
 * SHIPPED로 변경할 때는 trackingNumber가 필수(서비스에서 검증). carrier는 선택.
 */
@Schema(description = "주문 상태 변경 요청 — 판매자")
public record UpdateOrderStatusRequest(
        @Schema(description = "변경할 상태 PREPARING|SHIPPED|DELIVERED|CANCELLED", example = "SHIPPED", requiredMode = Schema.RequiredMode.REQUIRED)
        @NotBlank String status,
        @Schema(description = "택배사(SHIPPED 시 권장)", example = "CJ대한통운")
        @Size(max = 50) String carrier,
        @Schema(description = "운송장 번호(SHIPPED 시 필수)", example = "1234567890")
        @Size(max = 60) String trackingNumber
) {}

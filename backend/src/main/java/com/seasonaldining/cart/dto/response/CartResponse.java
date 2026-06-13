package com.seasonaldining.cart.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import java.math.BigDecimal;
import java.util.List;

@Schema(description = "장바구니 응답 — 농가별 그룹 + 합계")
public record CartResponse(
        @Schema(description = "농가별 그룹") List<ProducerGroup> groups,
        @Schema(description = "상품 합계") BigDecimal itemsTotal,
        @Schema(description = "배송비 합계") BigDecimal shippingTotal,
        @Schema(description = "결제 예정 금액") BigDecimal payTotal
) {
    @Schema(description = "농가별 장바구니 그룹")
    public record ProducerGroup(
            @Schema(description = "농가 ID") Long producerId,
            @Schema(description = "농가 이름") String producerName,
            @Schema(description = "항목") List<Item> items,
            @Schema(description = "그룹 소계") BigDecimal subtotal,
            @Schema(description = "그룹 배송비") BigDecimal shipping
    ) {}

    @Schema(description = "장바구니 항목")
    public record Item(
            @Schema(description = "장바구니 항목 ID") Long cartItemId,
            @Schema(description = "식재료명") String ingredientName,
            @Schema(description = "수량") int qty,
            @Schema(description = "단가(옵션 선택 시 옵션 단가)") BigDecimal unitPrice,
            @Schema(description = "단위") String unit,
            @Schema(description = "선택 옵션 ID(없으면 null)", nullable = true) Long offerOptionId,
            @Schema(description = "옵션 라벨(예: 3kg, 없으면 null)", example = "3kg", nullable = true) String optionLabel
    ) {}
}

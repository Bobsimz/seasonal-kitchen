package com.seasonaldining.shopping.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

import java.math.BigDecimal;
import java.util.List;

@Schema(description = "스토어별 장보기 링크 응답")
public record ShoppingPlanStoreLinksResponse(
        @Schema(example = "2500") BigDecimal savingAmount,
        List<StoreGroupResponse> storeGroups
) {

    @Schema(description = "스토어별 묶음")
    public record StoreGroupResponse(
            @Schema(example = "마켓컬리") String storeName,
            @Schema(example = "ONLINE") String storeType,
            @Schema(example = "샛별배송") String deliveryLabel,
            @Schema(example = "12400") BigDecimal totalPrice,
            @Schema(example = "https://example.com/checkout") String externalCheckoutUrl,
            List<ShoppingPlanItemResponse> items
    ) {
    }
}

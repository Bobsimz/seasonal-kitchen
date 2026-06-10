package com.seasonaldining.cart.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Min;

@Schema(description = "장바구니 수량 변경 요청")
public record UpdateCartItemRequest(
        @Schema(description = "수량", example = "3") @Min(1) int qty
) {}

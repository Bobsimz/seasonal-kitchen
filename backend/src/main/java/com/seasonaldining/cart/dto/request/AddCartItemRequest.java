package com.seasonaldining.cart.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

/**
 * 장바구니 담기 요청.
 * offerId(농가 판매 상품 ID)와 qty만 받는다. producer/ingredient/price/unit 등은
 * 클라이언트 입력을 신뢰하지 않고 서버가 ProducerOffer에서 조회해 스냅샷으로 저장한다.
 */
@Schema(description = "장바구니 담기 요청")
public record AddCartItemRequest(
        @Schema(description = "농가 판매 상품(오퍼) ID", example = "10") @NotNull Long offerId,
        @Schema(description = "수량", example = "2") @Min(1) int qty,
        @Schema(description = "선택 옵션(규격) ID. 없으면 기본가로 담김. 같은 offer라도 옵션 다르면 별도 라인", example = "100", nullable = true) Long offerOptionId
) {
    /** 옵션 없이 담기(기존 호출 호환). */
    public AddCartItemRequest(Long offerId, int qty) {
        this(offerId, qty, null);
    }
}

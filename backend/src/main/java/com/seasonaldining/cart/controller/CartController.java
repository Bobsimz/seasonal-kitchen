package com.seasonaldining.cart.controller;

import com.seasonaldining.cart.dto.request.AddCartItemRequest;
import com.seasonaldining.cart.dto.request.UpdateCartItemRequest;
import com.seasonaldining.cart.dto.response.CartResponse;
import com.seasonaldining.cart.service.CartService;
import com.seasonaldining.common.response.ApiResponse;
import com.seasonaldining.common.security.CurrentUserProvider;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Positive;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/cart")
@Tag(name = "19. Cart & Orders", description = "장바구니/주문 API")
@Validated
public class CartController {

    private final CartService cartService;
    private final CurrentUserProvider currentUserProvider;

    public CartController(CartService cartService, CurrentUserProvider currentUserProvider) {
        this.cartService = cartService;
        this.currentUserProvider = currentUserProvider;
    }

    @GetMapping
    @Operation(summary = "장바구니 조회", description = "농가별 그룹과 배송비/결제예정금액을 반환합니다.")
    public ApiResponse<CartResponse> getCart() {
        return ApiResponse.success(cartService.getCart(currentUserProvider.getCurrentUserId()), null);
    }

    @PostMapping("/items")
    @Operation(summary = "장바구니 담기")
    public ApiResponse<CartResponse> addItem(@Valid @RequestBody AddCartItemRequest request) {
        return ApiResponse.success(cartService.addItem(currentUserProvider.getCurrentUserId(), request), null);
    }

    @PatchMapping("/items/{cartItemId}")
    @Operation(summary = "장바구니 수량 변경")
    public ApiResponse<CartResponse> updateItem(@PathVariable @Positive Long cartItemId,
                                                @Valid @RequestBody UpdateCartItemRequest request) {
        return ApiResponse.success(cartService.updateItem(currentUserProvider.getCurrentUserId(), cartItemId, request), null);
    }

    @DeleteMapping("/items/{cartItemId}")
    @Operation(summary = "장바구니 항목 삭제")
    public ApiResponse<Void> deleteItem(@PathVariable @Positive Long cartItemId) {
        cartService.deleteItem(currentUserProvider.getCurrentUserId(), cartItemId);
        return ApiResponse.success(null, null);
    }
}

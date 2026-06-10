package com.seasonaldining.order.controller;

import com.seasonaldining.common.response.ApiResponse;
import com.seasonaldining.common.security.CurrentUserProvider;
import com.seasonaldining.order.dto.response.OrderResponse;
import com.seasonaldining.order.dto.response.OrderSummaryResponse;
import com.seasonaldining.order.service.OrderService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.constraints.Positive;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/orders")
@Tag(name = "19. Cart & Orders", description = "장바구니/주문 API")
@Validated
public class OrderController {

    private final OrderService orderService;
    private final CurrentUserProvider currentUserProvider;

    public OrderController(OrderService orderService, CurrentUserProvider currentUserProvider) {
        this.orderService = orderService;
        this.currentUserProvider = currentUserProvider;
    }

    @PostMapping
    @Operation(summary = "주문 생성", description = "현재 장바구니를 주문으로 전환합니다(모의 결제).")
    public ApiResponse<OrderResponse> createOrder() {
        return ApiResponse.success(orderService.createOrder(currentUserProvider.getCurrentUserId()), null);
    }

    @GetMapping
    @Operation(summary = "주문 내역 조회")
    public ApiResponse<List<OrderSummaryResponse>> getOrders() {
        return ApiResponse.success(orderService.getOrders(currentUserProvider.getCurrentUserId()), null);
    }

    @GetMapping("/{orderId}")
    @Operation(summary = "주문 상세 조회")
    public ApiResponse<OrderResponse> getOrder(@PathVariable @Positive Long orderId) {
        return ApiResponse.success(orderService.getOrder(currentUserProvider.getCurrentUserId(), orderId), null);
    }
}

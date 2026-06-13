package com.seasonaldining.producer.controller;

import com.seasonaldining.common.response.ApiResponse;
import com.seasonaldining.common.security.CurrentUserProvider;
import com.seasonaldining.producer.dto.request.CreateOfferRequest;
import com.seasonaldining.producer.dto.request.RegisterProducerRequest;
import com.seasonaldining.producer.dto.request.UpdateOfferRequest;
import com.seasonaldining.producer.dto.response.ProducerDetailResponse;
import com.seasonaldining.producer.dto.response.ProducerOfferResponse;
import com.seasonaldining.producer.dto.response.SellerStatsResponse;
import com.seasonaldining.order.dto.request.UpdateOrderStatusRequest;
import com.seasonaldining.order.dto.response.SellerOrderResponse;
import com.seasonaldining.order.service.SellerOrderService;
import com.seasonaldining.producer.service.ProducerService;
import com.seasonaldining.producer.service.SellerStatsService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Positive;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 내 농가 (마이페이지 → 농가로 등록 / 내 농가 관리 / 상품 등록). 모두 인증 필요.
 */
@RestController
@RequestMapping("/api/v1/producers/me")
@Tag(name = "18. Producers", description = "농가(생산자) API")
@Validated
public class ProducerMeController {

    private final ProducerService producerService;
    private final SellerStatsService sellerStatsService;
    private final SellerOrderService sellerOrderService;
    private final CurrentUserProvider currentUserProvider;

    public ProducerMeController(ProducerService producerService,
                                SellerStatsService sellerStatsService,
                                SellerOrderService sellerOrderService,
                                CurrentUserProvider currentUserProvider) {
        this.producerService = producerService;
        this.sellerStatsService = sellerStatsService;
        this.sellerOrderService = sellerOrderService;
        this.currentUserProvider = currentUserProvider;
    }

    @PostMapping
    @Operation(summary = "농가로 등록", description = "로그인 사용자를 농가(생산자)로 등록합니다. 한 사용자당 1개.")
    public ApiResponse<ProducerDetailResponse> register(@Valid @RequestBody RegisterProducerRequest request) {
        return ApiResponse.success(
                producerService.registerMyProducer(currentUserProvider.getCurrentUserId(), request), null);
    }

    @GetMapping
    @Operation(summary = "내 농가 조회", description = "내가 등록한 농가 프로필을 조회합니다. 미등록이면 200 + data:null(프론트 등록 CTA 분기용).")
    public ApiResponse<ProducerDetailResponse> getMine() {
        return ApiResponse.success(
                producerService.getMyProducer(currentUserProvider.getCurrentUserId()), null);
    }

    @PostMapping("/offers")
    @Operation(summary = "내 농가 상품 등록", description = "내 농가에 판매 상품(식재료·가격·단위)을 등록합니다.")
    public ApiResponse<ProducerOfferResponse> addOffer(@Valid @RequestBody CreateOfferRequest request) {
        return ApiResponse.success(
                producerService.addMyOffer(currentUserProvider.getCurrentUserId(), request), null);
    }

    @GetMapping("/offers")
    @Operation(summary = "내 농가 상품 목록", description = "내가 등록한 판매 상품 목록(숨김 제외). 판매자 대시보드용. 미등록이면 PRODUCER_NOT_FOUND.")
    public ApiResponse<List<ProducerOfferResponse>> getMyOffers() {
        return ApiResponse.success(
                producerService.getMyOffers(currentUserProvider.getCurrentUserId()), null);
    }

    @PatchMapping("/offers/{offerId}")
    @Operation(summary = "내 농가 상품 수정", description = "부분 수정(null=미수정, 컬렉션은 제공 시 전체 교체). 타 농가/숨김 상품은 PRODUCER_OFFER_NOT_FOUND.")
    public ApiResponse<ProducerOfferResponse> updateOffer(@PathVariable @Positive Long offerId,
                                                          @Valid @RequestBody UpdateOfferRequest request) {
        return ApiResponse.success(
                producerService.updateMyOffer(currentUserProvider.getCurrentUserId(), offerId, request), null);
    }

    @DeleteMapping("/offers/{offerId}")
    @Operation(summary = "내 농가 상품 내리기(숨김)", description = "소프트 삭제(status=HIDDEN). 공개 목록/검색에서 제외됩니다. 타 농가/이미 숨김은 PRODUCER_OFFER_NOT_FOUND.")
    public ApiResponse<Void> deleteOffer(@PathVariable @Positive Long offerId) {
        producerService.deleteMyOffer(currentUserProvider.getCurrentUserId(), offerId);
        return ApiResponse.success(null, null);
    }

    @GetMapping("/stats")
    @Operation(summary = "내 농가 판매 통계", description = "매출·주문·인기상품·7일 매출추이·정산일을 집계합니다. 조회수·전환율은 후속(미수집 시 null).")
    public ApiResponse<SellerStatsResponse> getMyStats() {
        return ApiResponse.success(
                sellerStatsService.getMyStats(currentUserProvider.getCurrentUserId()), null);
    }

    @GetMapping("/orders")
    @Operation(summary = "내 농가 받은 주문", description = "내 농가 항목이 포함된 주문 목록(최신순). 항목은 내 농가 것만 노출. 미등록이면 PRODUCER_NOT_FOUND.")
    public ApiResponse<List<SellerOrderResponse>> getMyOrders() {
        return ApiResponse.success(
                sellerOrderService.getMyOrders(currentUserProvider.getCurrentUserId()), null);
    }

    @PatchMapping("/orders/{orderId}/status")
    @Operation(summary = "주문 상태 변경", description =
            "PAID→PREPARING→SHIPPED→DELIVERED(배송 전 CANCELLED 가능). SHIPPED는 운송장 필수(ORDER_TRACKING_REQUIRED). " +
            "불가능한 전이는 ORDER_INVALID_STATUS_TRANSITION, 내 농가 항목이 없는 주문은 ORDER_ACCESS_DENIED.")
    public ApiResponse<SellerOrderResponse> updateOrderStatus(@PathVariable @Positive Long orderId,
                                                              @Valid @RequestBody UpdateOrderStatusRequest request) {
        return ApiResponse.success(
                sellerOrderService.updateStatus(currentUserProvider.getCurrentUserId(), orderId, request), null);
    }
}

package com.seasonaldining.producer.controller;

import com.seasonaldining.common.response.ApiResponse;
import com.seasonaldining.common.security.CurrentUserProvider;
import com.seasonaldining.producer.dto.request.CreateOfferRequest;
import com.seasonaldining.producer.dto.request.RegisterProducerRequest;
import com.seasonaldining.producer.dto.response.ProducerDetailResponse;
import com.seasonaldining.producer.dto.response.ProducerOfferResponse;
import com.seasonaldining.producer.service.ProducerService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

/**
 * 내 농가 (마이페이지 → 농가로 등록 / 내 농가 관리 / 상품 등록). 모두 인증 필요.
 */
@RestController
@RequestMapping("/api/v1/producers/me")
@Tag(name = "18. Producers", description = "농가(생산자) API")
public class ProducerMeController {

    private final ProducerService producerService;
    private final CurrentUserProvider currentUserProvider;

    public ProducerMeController(ProducerService producerService, CurrentUserProvider currentUserProvider) {
        this.producerService = producerService;
        this.currentUserProvider = currentUserProvider;
    }

    @PostMapping
    @Operation(summary = "농가로 등록", description = "로그인 사용자를 농가(생산자)로 등록합니다. 한 사용자당 1개.")
    public ApiResponse<ProducerDetailResponse> register(@Valid @RequestBody RegisterProducerRequest request) {
        return ApiResponse.success(
                producerService.registerMyProducer(currentUserProvider.getCurrentUserId(), request), null);
    }

    @GetMapping
    @Operation(summary = "내 농가 조회", description = "내가 등록한 농가 프로필을 조회합니다. 미등록이면 PRODUCER_NOT_FOUND.")
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
}

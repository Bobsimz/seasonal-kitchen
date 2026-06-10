package com.seasonaldining.producer.controller;

import com.seasonaldining.common.response.ApiResponse;
import com.seasonaldining.common.response.ListResponse;
import com.seasonaldining.common.security.CurrentUserProvider;
import com.seasonaldining.producer.dto.request.CreateProducerReviewRequest;
import com.seasonaldining.producer.dto.response.*;
import com.seasonaldining.producer.service.ProducerService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Positive;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.data.web.SortDefault;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/producers")
@Tag(name = "18. Producers", description = "농가(생산자) API")
@Validated
public class ProducerController {

    private final ProducerService producerService;
    private final CurrentUserProvider currentUserProvider;

    public ProducerController(ProducerService producerService, CurrentUserProvider currentUserProvider) {
        this.producerService = producerService;
        this.currentUserProvider = currentUserProvider;
    }

    @GetMapping
    @Operation(summary = "농가 목록/검색 조회", description = "q(식재료명 검색), style, honorary 필터를 지원합니다.")
    public ApiResponse<ListResponse<ProducerCardResponse>> getProducers(
            @Parameter(description = "식재료명 검색어", example = "봄동") @RequestParam(required = false) String q,
            @Parameter(description = "스타일", example = "PREMIUM") @RequestParam(required = false) String style,
            @Parameter(description = "명예 농가만", example = "true") @RequestParam(required = false) Boolean honorary,
            @PageableDefault(size = 20) @SortDefault(sort = "rating", direction = Sort.Direction.DESC) Pageable pageable
    ) {
        return ApiResponse.success(producerService.getProducers(q, style, honorary, pageable), null);
    }

    @GetMapping("/{producerId}")
    @Operation(summary = "농가 상세 조회")
    public ApiResponse<ProducerDetailResponse> getProducerDetail(
            @PathVariable @Positive Long producerId) {
        return ApiResponse.success(producerService.getProducerDetail(producerId), null);
    }

    @GetMapping("/{producerId}/offers")
    @Operation(summary = "농가 판매 상품(식재료) 조회", description = "농가가 파는 식재료를 가격순으로 조회합니다.")
    public ApiResponse<List<ProducerOfferResponse>> getProducerOffers(
            @PathVariable @Positive Long producerId) {
        return ApiResponse.success(producerService.getProducerOffers(producerId), null);
    }

    @GetMapping("/{producerId}/reviews")
    @Operation(summary = "농가 리뷰 조회")
    public ApiResponse<List<ProducerReviewResponse>> getProducerReviews(
            @PathVariable @Positive Long producerId) {
        return ApiResponse.success(producerService.getProducerReviews(producerId), null);
    }

    @GetMapping("/{producerId}/news")
    @Operation(summary = "농가 스토어 소식 조회")
    public ApiResponse<List<ProducerNewsResponse>> getProducerNews(
            @PathVariable @Positive Long producerId) {
        return ApiResponse.success(producerService.getProducerNews(producerId), null);
    }

    @PostMapping("/{producerId}/reviews")
    @Operation(summary = "농가 리뷰 작성")
    public ApiResponse<ProducerReviewResponse> createReview(
            @PathVariable @Positive Long producerId,
            @Valid @RequestBody CreateProducerReviewRequest request) {
        return ApiResponse.success(
                producerService.createReview(currentUserProvider.getCurrentUserId(), producerId, request), null);
    }
}

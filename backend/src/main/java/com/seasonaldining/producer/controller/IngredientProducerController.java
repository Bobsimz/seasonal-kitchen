package com.seasonaldining.producer.controller;

import com.seasonaldining.common.response.ApiResponse;
import com.seasonaldining.producer.dto.response.ProducerOfferResponse;
import com.seasonaldining.producer.service.ProducerService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.constraints.Positive;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 식재료 → 농가 비교 (화면 15 "농가 비교").
 * IngredientController와 분리하여 producer 도메인 결합을 한쪽으로 유지한다.
 */
@RestController
@RequestMapping("/api/v1/ingredients")
@Tag(name = "18. Producers", description = "농가(생산자) API")
@Validated
public class IngredientProducerController {

    private final ProducerService producerService;

    public IngredientProducerController(ProducerService producerService) {
        this.producerService = producerService;
    }

    @GetMapping("/{ingredientId}/producers")
    @Operation(summary = "식재료별 농가 비교", description = "해당 식재료를 파는 농가들의 가격을 가격순으로 비교 조회합니다.")
    public ApiResponse<List<ProducerOfferResponse>> getProducersForIngredient(
            @Parameter(description = "식재료 ID", example = "12") @PathVariable @Positive Long ingredientId) {
        return ApiResponse.success(producerService.getOffersForIngredient(ingredientId), null);
    }
}

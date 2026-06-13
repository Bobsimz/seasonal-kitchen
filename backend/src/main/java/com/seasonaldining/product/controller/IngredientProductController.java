package com.seasonaldining.product.controller;

import com.seasonaldining.common.response.ApiResponse;
import com.seasonaldining.product.dto.response.ProductCardResponse;
import com.seasonaldining.product.service.ProductService;
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
 * 식재료 → 판매 상품 목록 (재료 상세 "이 재료를 파는 제품" 섹션).
 * ProductController와 분리하여 /ingredients 하위 경로로 노출한다 (IngredientProducerController와 동일 패턴).
 */
@RestController
@RequestMapping("/api/v1/ingredients")
@Tag(name = "19. Products", description = "상품 API (producer_offers facade)")
@Validated
public class IngredientProductController {

    private final ProductService productService;

    public IngredientProductController(ProductService productService) {
        this.productService = productService;
    }

    @GetMapping("/{ingredientId}/products")
    @Operation(summary = "식재료별 판매 상품", description = "해당 식재료를 파는 상품(농가 offer)을 가격 오름차순으로 조회합니다.")
    public ApiResponse<List<ProductCardResponse>> getProductsForIngredient(
            @Parameter(description = "식재료 ID", example = "12") @PathVariable @Positive Long ingredientId) {
        return ApiResponse.success(productService.getProductsByIngredient(ingredientId), null);
    }
}

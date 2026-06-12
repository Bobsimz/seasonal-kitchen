package com.seasonaldining.product.controller;

import com.seasonaldining.common.response.ApiResponse;
import com.seasonaldining.common.response.ListResponse;
import com.seasonaldining.product.dto.response.ProductCardResponse;
import com.seasonaldining.product.dto.response.ProductDetailResponse;
import com.seasonaldining.product.service.ProductService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Positive;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

/**
 * 상품(Product) API — producer_offers facade. 전용 product 테이블 없음.
 * 목록/상세 모두 공개(GET).
 */
@RestController
@RequestMapping("/api/v1/products")
@Tag(name = "19. Products", description = "상품 API (producer_offers facade)")
@Validated
public class ProductController {

    private final ProductService productService;

    public ProductController(ProductService productService) {
        this.productService = productService;
    }

    @GetMapping
    @Operation(summary = "상품 목록/검색", description = "producer_offers 기반 상품 목록. q·category·region·style 필터와 페이지네이션을 지원합니다.")
    public ApiResponse<ListResponse<ProductCardResponse>> getProducts(
            @Parameter(description = "검색어(상품명·식재료명·농가명)", example = "봄동") @RequestParam(required = false) String q,
            @Parameter(description = "카테고리", example = "잎채소") @RequestParam(required = false) String category,
            @Parameter(description = "지역(부분일치)", example = "영천") @RequestParam(required = false) String region,
            @Parameter(description = "농가 스타일", example = "ORGANIC") @RequestParam(required = false) String style,
            @Parameter(description = "페이지(0-base)", example = "0") @RequestParam(defaultValue = "0") @Min(0) int page,
            @Parameter(description = "페이지 크기", example = "20") @RequestParam(defaultValue = "20") @Min(1) @Max(100) int size
    ) {
        return ApiResponse.success(productService.getProducts(q, category, region, style, page, size), null);
    }

    @GetMapping("/{id}")
    @Operation(summary = "상품 상세", description = "id는 producer_offers.id. 이미지·옵션·인증·보관·관련 레시피를 포함합니다.")
    public ApiResponse<ProductDetailResponse> getProduct(@PathVariable @Positive Long id) {
        return ApiResponse.success(productService.getProduct(id), null);
    }
}

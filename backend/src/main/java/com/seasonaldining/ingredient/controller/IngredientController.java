package com.seasonaldining.ingredient.controller;

import com.seasonaldining.common.response.ApiResponse;
import com.seasonaldining.common.response.ListResponse;
import com.seasonaldining.ingredient.dto.response.IngredientCardResponse;
import com.seasonaldining.ingredient.dto.response.IngredientDetailResponse;
import com.seasonaldining.ingredient.dto.response.IngredientOfferResponse;
import com.seasonaldining.ingredient.dto.response.IngredientPriceHistoryResponse;
import com.seasonaldining.ingredient.dto.response.IngredientSubstituteResponse;
import com.seasonaldining.ingredient.service.IngredientService;
import com.seasonaldining.recipe.dto.response.RecipeCardResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.constraints.Positive;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/v1/ingredients")
@Tag(name = "05. Ingredients", description = "식재료 API")
@Validated
public class IngredientController {

    private final IngredientService ingredientService;

    public IngredientController(IngredientService ingredientService) {
        this.ingredientService = ingredientService;
    }

    @GetMapping
    @Operation(summary = "식재료 목록 조회", description = "활성 식재료. category 필터 + sort(price_asc|price_desc|name) 지원.")
    public ApiResponse<ListResponse<IngredientCardResponse>> getIngredients(
            @Parameter(description = "카테고리 필터", example = "엽채류") @RequestParam(required = false) String category,
            @Parameter(description = "정렬: price_asc|price_desc|name") @RequestParam(required = false) String sort,
            @Parameter(description = "페이지 정보(page/size)")
            @PageableDefault(size = 20) Pageable pageable
    ) {
        return ApiResponse.success(ingredientService.getIngredients(category, sort, pageable), null);
    }

    @GetMapping("/categories")
    @Operation(summary = "식재료 카테고리 목록", description = "필터 칩용 — 활성 식재료의 카테고리 목록.")
    public ApiResponse<List<String>> getCategories() {
        return ApiResponse.success(ingredientService.getCategories(), null);
    }

    @GetMapping("/{ingredientId}")
    @Operation(summary = "식재료 상세 조회", description = "활성(active=true) 식재료 상세 정보를 조회합니다.")
    public ApiResponse<IngredientDetailResponse> getIngredientDetail(
            @Parameter(description = "식재료 ID", example = "1")
            @PathVariable @Positive Long ingredientId
    ) {
        return ApiResponse.success(ingredientService.getIngredientDetail(ingredientId), null);
    }

    @GetMapping("/{ingredientId}/prices")
    @Operation(summary = "식재료 가격 이력 조회", description = "활성 식재료의 가격 스냅샷 이력을 조회합니다. from/to 파라미터는 선택입니다.")
    public ApiResponse<IngredientPriceHistoryResponse> getIngredientPriceHistory(
            @Parameter(description = "식재료 ID", example = "1")
            @PathVariable @Positive Long ingredientId,
            @Parameter(description = "조회 시작일(포함)", example = "2026-05-01")
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
            @Parameter(description = "조회 종료일(포함)", example = "2026-06-01")
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to
    ) {
        return ApiResponse.success(ingredientService.getPriceHistory(ingredientId, from, to), null);
    }

    @GetMapping("/{ingredientId}/substitutes")
    @Operation(summary = "대체 식재료 조회", description = "활성 식재료의 대체 식재료를 점수 내림차순으로 조회합니다.")
    public ApiResponse<List<IngredientSubstituteResponse>> getIngredientSubstitutes(
            @Parameter(description = "식재료 ID", example = "1")
            @PathVariable @Positive Long ingredientId
    ) {
        return ApiResponse.success(ingredientService.getSubstitutes(ingredientId), null);
    }

    @GetMapping("/{ingredientId}/offers")
    @Operation(summary = "식재료 구매처 가격 비교 조회", description = "활성 식재료의 온라인/오프라인 참고 가격을 가격순으로 조회합니다.")
    public ApiResponse<List<IngredientOfferResponse>> getIngredientOffers(
            @Parameter(description = "식재료 ID", example = "1")
            @PathVariable @Positive Long ingredientId
    ) {
        return ApiResponse.success(ingredientService.getOffers(ingredientId), null);
    }

    @GetMapping("/{ingredientId}/recipes")
    @Operation(summary = "식재료 관련 레시피 조회", description = "식재료를 사용하는 공개 레시피를 조회합니다.")
    public ApiResponse<List<RecipeCardResponse>> getIngredientRecipes(
            @Parameter(description = "식재료 ID", example = "1")
            @PathVariable @Positive Long ingredientId
    ) {
        return ApiResponse.success(ingredientService.getRelatedRecipes(ingredientId), null);
    }
}

package com.seasonaldining.recipe.controller;

import com.seasonaldining.common.response.ApiResponse;
import com.seasonaldining.common.response.ListResponse;
import com.seasonaldining.recipe.dto.response.RecipeCardResponse;
import com.seasonaldining.recipe.dto.response.RecipeDetailResponse;
import com.seasonaldining.recipe.dto.response.RecipeStepResponse;
import com.seasonaldining.recipe.service.RecipeService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/recipes")
@Tag(name = "08. Recipes", description = "레시피 API")
public class RecipeController {

    private final RecipeService recipeService;

    public RecipeController(RecipeService recipeService) {
        this.recipeService = recipeService;
    }

    @GetMapping
    @Operation(summary = "레시피 목록 조회", description = "공개 레시피 목록. tag 필터 + sort(likes|time_asc|title) 지원.")
    public ApiResponse<ListResponse<RecipeCardResponse>> getRecipes(
            @Parameter(description = "태그 필터(식재료 이름)", example = "당근") @RequestParam(required = false) String tag,
            @Parameter(description = "정렬: likes(기본)|time_asc|title") @RequestParam(required = false) String sort,
            @Parameter(description = "페이지 정보(page/size)")
            @PageableDefault(size = 20) Pageable pageable
    ) {
        return ApiResponse.success(recipeService.getRecipes(tag, sort, pageable), null);
    }

    @GetMapping("/tags")
    @Operation(summary = "레시피 태그 목록", description = "필터 칩용 — 사용 중인 태그 목록.")
    public ApiResponse<List<String>> getTags() {
        return ApiResponse.success(recipeService.getTags(), null);
    }

    @GetMapping("/{recipeId}")
    @Operation(summary = "레시피 상세 조회", description = "공개된 레시피의 상세 정보와 재료 목록을 조회합니다.")
    public ApiResponse<RecipeDetailResponse> getRecipeDetail(
            @Parameter(description = "레시피 ID", example = "1") @PathVariable Long recipeId
    ) {
        return ApiResponse.success(recipeService.getRecipeDetail(recipeId), null);
    }

    @GetMapping("/{recipeId}/steps")
    @Operation(summary = "레시피 조리 단계 조회", description = "공개된 레시피의 조리 단계를 순서대로 조회합니다.")
    public ApiResponse<List<RecipeStepResponse>> getRecipeSteps(
            @Parameter(description = "레시피 ID", example = "1") @PathVariable Long recipeId
    ) {
        return ApiResponse.success(recipeService.getRecipeSteps(recipeId), null);
    }
}

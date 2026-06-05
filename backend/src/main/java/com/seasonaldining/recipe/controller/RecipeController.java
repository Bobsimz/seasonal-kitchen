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
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
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
    @Operation(summary = "레시피 목록 조회", description = "공개된 레시피 목록을 페이지네이션으로 조회합니다.")
    public ApiResponse<ListResponse<RecipeCardResponse>> getRecipes(
            @Parameter(description = "페이지/정렬 정보")
            @PageableDefault(size = 20, sort = "id", direction = Sort.Direction.DESC) Pageable pageable
    ) {
        return ApiResponse.success(recipeService.getRecipes(pageable), null);
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

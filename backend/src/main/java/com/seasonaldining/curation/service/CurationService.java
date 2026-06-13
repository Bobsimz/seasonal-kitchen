package com.seasonaldining.curation.service;

import com.seasonaldining.common.exception.BusinessException;
import com.seasonaldining.common.exception.ErrorCode;
import com.seasonaldining.common.storage.MediaUrlResolver;
import com.seasonaldining.curation.dto.response.CurationCardResponse;
import com.seasonaldining.curation.dto.response.CurationDetailResponse;
import com.seasonaldining.curation.entity.Curation;
import com.seasonaldining.curation.repository.CurationIngredientRepository;
import com.seasonaldining.curation.repository.CurationRecipeRepository;
import com.seasonaldining.curation.repository.CurationRepository;
import com.seasonaldining.ingredient.dto.response.IngredientCardResponse;
import com.seasonaldining.ingredient.entity.Ingredient;
import com.seasonaldining.ingredient.repository.IngredientRepository;
import com.seasonaldining.ingredient.service.IngredientService;
import com.seasonaldining.recipe.dto.response.RecipeCardResponse;
import com.seasonaldining.recipe.entity.Recipe;
import com.seasonaldining.recipe.repository.RecipeRepository;
import com.seasonaldining.recipe.service.RecipeService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
@Transactional(readOnly = true)
public class CurationService {

    private static final String PUBLISHED = "PUBLISHED";

    private final CurationRepository curationRepository;
    private final CurationIngredientRepository curationIngredientRepository;
    private final CurationRecipeRepository curationRecipeRepository;
    private final IngredientRepository ingredientRepository;
    private final RecipeRepository recipeRepository;
    private final IngredientService ingredientService;
    private final RecipeService recipeService;
    private final MediaUrlResolver mediaUrls;

    public CurationService(CurationRepository curationRepository,
                           CurationIngredientRepository curationIngredientRepository,
                           CurationRecipeRepository curationRecipeRepository,
                           IngredientRepository ingredientRepository,
                           RecipeRepository recipeRepository,
                           IngredientService ingredientService,
                           RecipeService recipeService,
                           MediaUrlResolver mediaUrls) {
        this.curationRepository = curationRepository;
        this.curationIngredientRepository = curationIngredientRepository;
        this.curationRecipeRepository = curationRecipeRepository;
        this.ingredientRepository = ingredientRepository;
        this.recipeRepository = recipeRepository;
        this.ingredientService = ingredientService;
        this.recipeService = recipeService;
        this.mediaUrls = mediaUrls;
    }

    /** 홈 히어로용 큐레이션 카드 목록(노출 순서대로). */
    public List<CurationCardResponse> getCurationCards() {
        return curationRepository.findByActiveTrueOrderByDisplayOrderAscIdAsc().stream()
                .map(this::toCard)
                .toList();
    }

    /** 큐레이션 상세 — 본문 + 관련 식재료/레시피. */
    public CurationDetailResponse getCurationDetail(Long curationId) {
        Curation curation = curationRepository.findByIdAndActiveTrue(curationId)
                .orElseThrow(() -> new BusinessException(ErrorCode.CURATION_NOT_FOUND));

        return new CurationDetailResponse(
                curation.getId(),
                mediaUrls.resolve(curation.getMainImageUrl()),
                curation.getMainTitle(),
                curation.getSubtitle(),
                curation.getSeasonalStory(),
                relatedIngredients(curationId),
                relatedRecipes(curationId)
        );
    }

    private CurationCardResponse toCard(Curation c) {
        return new CurationCardResponse(
                c.getId(),
                mediaUrls.resolve(c.getMainImageUrl()),
                c.getMainTitle(),
                c.getSubtitle()
        );
    }

    // 조인 테이블 순서를 보존하며 카드로 매핑(비활성/삭제된 항목은 건너뜀).
    private List<IngredientCardResponse> relatedIngredients(Long curationId) {
        List<Long> ids = curationIngredientRepository.findByCurationIdOrderBySortOrderAscIdAsc(curationId).stream()
                .map(ci -> ci.getIngredientId())
                .toList();
        if (ids.isEmpty()) return List.of();
        Map<Long, Ingredient> byId = ingredientRepository.findByIdInAndActiveTrue(ids).stream()
                .collect(Collectors.toMap(Ingredient::getId, Function.identity()));
        return ids.stream()
                .map(byId::get)
                .filter(Objects::nonNull)
                .map(ingredientService::toCardResponse)
                .toList();
    }

    private List<RecipeCardResponse> relatedRecipes(Long curationId) {
        List<Long> ids = curationRecipeRepository.findByCurationIdOrderBySortOrderAscIdAsc(curationId).stream()
                .map(cr -> cr.getRecipeId())
                .toList();
        if (ids.isEmpty()) return List.of();
        Map<Long, Recipe> byId = recipeRepository.findByIdInAndStatus(ids, PUBLISHED).stream()
                .collect(Collectors.toMap(Recipe::getId, Function.identity()));
        return ids.stream()
                .map(byId::get)
                .filter(Objects::nonNull)
                .map(recipeService::toCardResponse)
                .toList();
    }
}

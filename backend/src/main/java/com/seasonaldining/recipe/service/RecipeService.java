package com.seasonaldining.recipe.service;

import com.seasonaldining.common.exception.BusinessException;
import com.seasonaldining.common.exception.ErrorCode;
import com.seasonaldining.common.response.ListResponse;
import com.seasonaldining.common.storage.MediaUrlResolver;
import com.seasonaldining.ingredient.entity.Ingredient;
import com.seasonaldining.ingredient.repository.IngredientRepository;
import com.seasonaldining.price.entity.PriceSnapshot;
import com.seasonaldining.price.repository.PriceSnapshotRepository;
import com.seasonaldining.recipe.dto.response.RecipeCardResponse;
import com.seasonaldining.recipe.dto.response.RecipeDetailResponse;
import com.seasonaldining.recipe.dto.response.RecipeIngredientResponse;
import com.seasonaldining.recipe.dto.response.RecipeStepResponse;
import com.seasonaldining.recipe.entity.Recipe;
import com.seasonaldining.recipe.entity.RecipeIngredient;
import com.seasonaldining.recipe.entity.RecipeStep;
import com.seasonaldining.recipe.repository.RecipeIngredientRepository;
import com.seasonaldining.recipe.repository.RecipeRepository;
import com.seasonaldining.recipe.repository.RecipeStepRepository;
import com.seasonaldining.reel.entity.ReelReaction;
import com.seasonaldining.reel.repository.CreatorRepository;
import com.seasonaldining.reel.repository.ReelReactionRepository;
import com.seasonaldining.reel.repository.ReelRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
@Transactional(readOnly = true)
public class RecipeService {

    private static final String PUBLISHED = "PUBLISHED";

    private final RecipeRepository recipeRepository;
    private final RecipeIngredientRepository recipeIngredientRepository;
    private final IngredientRepository ingredientRepository;
    private final RecipeStepRepository recipeStepRepository;
    private final PriceSnapshotRepository priceSnapshotRepository;
    private final ReelRepository reelRepository;
    private final CreatorRepository creatorRepository;
    private final ReelReactionRepository reelReactionRepository;
    private final MediaUrlResolver mediaUrls;

    public RecipeService(
            RecipeRepository recipeRepository,
            RecipeIngredientRepository recipeIngredientRepository,
            IngredientRepository ingredientRepository,
            RecipeStepRepository recipeStepRepository,
            PriceSnapshotRepository priceSnapshotRepository,
            ReelRepository reelRepository,
            CreatorRepository creatorRepository,
            ReelReactionRepository reelReactionRepository,
            MediaUrlResolver mediaUrls
    ) {
        this.recipeRepository = recipeRepository;
        this.recipeIngredientRepository = recipeIngredientRepository;
        this.ingredientRepository = ingredientRepository;
        this.recipeStepRepository = recipeStepRepository;
        this.priceSnapshotRepository = priceSnapshotRepository;
        this.reelRepository = reelRepository;
        this.creatorRepository = creatorRepository;
        this.reelReactionRepository = reelReactionRepository;
        this.mediaUrls = mediaUrls;
    }

    public List<RecipeStepResponse> getRecipeSteps(Long recipeId) {
        getPublishedRecipeOrThrow(recipeId);
        return recipeStepRepository.findByRecipeIdOrderByStepNumberAsc(recipeId).stream()
                .map(this::toStepResponse)
                .toList();
    }

    public RecipeDetailResponse getRecipeDetail(Long recipeId) {
        Recipe recipe = getPublishedRecipeOrThrow(recipeId);
        List<RecipeIngredient> recipeIngredients = recipeIngredientRepository.findByRecipeIdOrderByIdAsc(recipeId);
        Map<Long, Ingredient> ingredients = ingredientRepository.findAllById(
                        recipeIngredients.stream().map(RecipeIngredient::getIngredientId).filter(Objects::nonNull).toList()
                ).stream()
                .collect(Collectors.toMap(Ingredient::getId, Function.identity()));

        List<RecipeIngredientResponse> ingredientResponses = recipeIngredients.stream()
                .map(recipeIngredient -> toIngredientResponse(recipeIngredient, ingredients.get(recipeIngredient.getIngredientId())))
                .toList();

        List<RecipeDetailResponse.RelatedReelResponse> relatedReels = relatedReels(recipe.getId());
        return new RecipeDetailResponse(
                recipe.getId(),
                recipe.getTitle(),
                recipe.getDescription(),
                mediaUrls.resolve(recipe.getImageUrl()),
                recipe.getDifficulty(),
                recipe.getMinutes(),
                recipe.getServings(),
                ingredientResponses,
                ingredientResponses.stream()
                        .map(RecipeIngredientResponse::estimatedPrice)
                        .filter(Objects::nonNull)
                        .reduce(java.math.BigDecimal.ZERO, java.math.BigDecimal::add),
                List.of(recipe.getDifficulty(), recipe.getMinutes() + "분"),
                null,
                0,
                relatedReels.stream().map(RecipeDetailResponse.RelatedReelResponse::id).toList(),
                relatedReels
        );
    }

    private Recipe getPublishedRecipeOrThrow(Long recipeId) {
        return recipeRepository.findByIdAndStatus(recipeId, PUBLISHED)
                .orElseThrow(() -> new BusinessException(ErrorCode.RECIPE_NOT_FOUND));
    }

    private RecipeIngredientResponse toIngredientResponse(RecipeIngredient recipeIngredient, Ingredient ingredient) {
        // 카탈로그에 없는 비농산물 재료(계란·쌀 등)는 Ingredient 행이 없으므로 recipeIngredient.getName() 으로 폴백.
        String name = ingredient != null ? ingredient.getName() : recipeIngredient.getName();
        String imageUrl = ingredient == null ? null : ingredient.getImageUrl();
        java.math.BigDecimal price = ingredient == null ? null : latestPrice(recipeIngredient.getIngredientId());
        return new RecipeIngredientResponse(
                recipeIngredient.getIngredientId(),
                name,
                amountLabel(recipeIngredient.getQuantity(), recipeIngredient.getUnit()),
                imageUrl,
                price,
                name,
                recipeIngredient.getQuantity(),
                recipeIngredient.getUnit(),
                recipeIngredient.isOptional(),
                imageUrl,
                price,
                null
        );
    }

    /** 수량 라벨(표시용): "1 개" 형태. 수량 없으면 "적당량". */
    private String amountLabel(java.math.BigDecimal quantity, String unit) {
        if (quantity == null) {
            return "적당량";
        }
        String q = quantity.stripTrailingZeros().toPlainString();
        return (unit == null || unit.isBlank()) ? q : q + " " + unit;
    }

    private RecipeStepResponse toStepResponse(RecipeStep recipeStep) {
        return new RecipeStepResponse(
                recipeStep.getStepNumber(),
                recipeStep.getStepNumber(),
                recipeStep.getDescription(),
                recipeStep.getMinutes(),
                recipeStep.getImageUrl(),
                null,
                recipeStep.getMinutes()
        );
    }

    public ListResponse<RecipeCardResponse> getRecipes(Pageable pageable) {
        Page<Recipe> recipePage = recipeRepository.findByStatus(PUBLISHED, pageable);
        List<RecipeCardResponse> items = recipePage.getContent().stream()
                .map(this::toCardResponse)
                .toList();

        return new ListResponse<>(
                items,
                recipePage.getNumber(),
                recipePage.getSize(),
                recipePage.getTotalElements(),
                recipePage.hasNext()
        );
    }

    public RecipeCardResponse toCardResponse(Recipe recipe) {
        return new RecipeCardResponse(
                recipe.getId(),
                recipe.getTitle(),
                recipe.getDescription(),
                mediaUrls.resolve(recipe.getImageUrl()),
                recipe.getDifficulty(),
                recipe.getMinutes(),
                recipe.getServings(),
                0,
                0,
                null,
                List.of(recipe.getDifficulty(), recipe.getMinutes() + "분"),
                false,
                mainIngredientNames(recipe.getId())
        );
    }

    /** 레시피의 주요 재료명 목록(프론트 카드 mainIngredients용). */
    private List<String> mainIngredientNames(Long recipeId) {
        List<RecipeIngredient> recipeIngredients = recipeIngredientRepository.findByRecipeIdOrderByIdAsc(recipeId);
        if (recipeIngredients.isEmpty()) {
            return List.of();
        }
        Map<Long, Ingredient> ingredients = ingredientRepository.findAllById(
                        recipeIngredients.stream().map(RecipeIngredient::getIngredientId).toList()
                ).stream()
                .collect(Collectors.toMap(Ingredient::getId, Function.identity()));
        return recipeIngredients.stream()
                .map(ri -> ingredients.get(ri.getIngredientId()))
                .filter(Objects::nonNull)
                .map(Ingredient::getName)
                .toList();
    }

    private java.math.BigDecimal latestPrice(Long ingredientId) {
        List<PriceSnapshot> snapshots = priceSnapshotRepository.findByIngredientIdOrderByObservedDateAsc(ingredientId);
        return snapshots.isEmpty() ? null : snapshots.get(snapshots.size() - 1).getPrice();
    }

    private List<RecipeDetailResponse.RelatedReelResponse> relatedReels(Long recipeId) {
        return reelRepository.findTop3ByRecipeIdAndStatusOrderByPublishedAtDesc(recipeId, PUBLISHED).stream()
                .map(reel -> new RecipeDetailResponse.RelatedReelResponse(
                        reel.getId(),
                        reel.getTitle(),
                        mediaUrls.resolve(reel.getThumbnailUrl()),
                        creatorRepository.findById(reel.getCreatorId()).map(c -> c.getDisplayName()).orElse(null),
                        reelReactionRepository.countByReelIdAndReactionType(reel.getId(), ReelReaction.LIKE),
                        reel.getDurationSeconds(),
                        reel.getPublishedAt()
                ))
                .toList();
    }
}

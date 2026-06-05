package com.seasonaldining.ingredient.service;

import com.seasonaldining.common.exception.BusinessException;
import com.seasonaldining.common.exception.ErrorCode;
import com.seasonaldining.common.response.ListResponse;
import com.seasonaldining.ingredient.dto.response.IngredientCardResponse;
import com.seasonaldining.ingredient.dto.response.IngredientDetailResponse;
import com.seasonaldining.ingredient.dto.response.IngredientOfferResponse;
import com.seasonaldining.ingredient.dto.response.IngredientPriceHistoryResponse;
import com.seasonaldining.ingredient.dto.response.IngredientSubstituteResponse;
import com.seasonaldining.ingredient.entity.Ingredient;
import com.seasonaldining.ingredient.repository.IngredientRepository;
import com.seasonaldining.ingredient.repository.IngredientCareTipRepository;
import com.seasonaldining.ingredient.repository.IngredientNutritionRepository;
import com.seasonaldining.ingredient.repository.IngredientStorageTipRepository;
import com.seasonaldining.price.entity.PriceSnapshot;
import com.seasonaldining.price.repository.PriceSnapshotRepository;
import com.seasonaldining.recipe.dto.response.RecipeCardResponse;
import com.seasonaldining.recipe.entity.IngredientSubstitute;
import com.seasonaldining.recipe.entity.Recipe;
import com.seasonaldining.recipe.entity.RecipeIngredient;
import com.seasonaldining.recipe.repository.IngredientSubstituteRepository;
import com.seasonaldining.recipe.repository.RecipeIngredientRepository;
import com.seasonaldining.recipe.repository.RecipeRepository;
import com.seasonaldining.store.entity.Store;
import com.seasonaldining.store.entity.StoreOffer;
import com.seasonaldining.store.repository.StoreOfferRepository;
import com.seasonaldining.store.repository.StoreRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
@Transactional(readOnly = true)
public class IngredientService {

    private final IngredientRepository ingredientRepository;
    private final PriceSnapshotRepository priceSnapshotRepository;
    private final IngredientSubstituteRepository ingredientSubstituteRepository;
    private final IngredientNutritionRepository nutritionRepository;
    private final IngredientCareTipRepository careTipRepository;
    private final IngredientStorageTipRepository storageTipRepository;
    private final StoreOfferRepository storeOfferRepository;
    private final StoreRepository storeRepository;
    private final RecipeIngredientRepository recipeIngredientRepository;
    private final RecipeRepository recipeRepository;

    public IngredientService(
            IngredientRepository ingredientRepository,
            PriceSnapshotRepository priceSnapshotRepository,
            IngredientSubstituteRepository ingredientSubstituteRepository,
            IngredientNutritionRepository nutritionRepository,
            IngredientCareTipRepository careTipRepository,
            IngredientStorageTipRepository storageTipRepository,
            StoreOfferRepository storeOfferRepository,
            StoreRepository storeRepository,
            RecipeIngredientRepository recipeIngredientRepository,
            RecipeRepository recipeRepository
    ) {
        this.ingredientRepository = ingredientRepository;
        this.priceSnapshotRepository = priceSnapshotRepository;
        this.ingredientSubstituteRepository = ingredientSubstituteRepository;
        this.nutritionRepository = nutritionRepository;
        this.careTipRepository = careTipRepository;
        this.storageTipRepository = storageTipRepository;
        this.storeOfferRepository = storeOfferRepository;
        this.storeRepository = storeRepository;
        this.recipeIngredientRepository = recipeIngredientRepository;
        this.recipeRepository = recipeRepository;
    }

    public List<IngredientSubstituteResponse> getSubstitutes(Long ingredientId) {
        getActiveIngredientOrThrow(ingredientId);
        List<IngredientSubstitute> substitutes =
                ingredientSubstituteRepository.findByIngredientIdOrderByScoreDesc(ingredientId);
        Map<Long, Ingredient> ingredients = ingredientRepository.findAllById(
                        substitutes.stream().map(IngredientSubstitute::getSubstituteIngredientId).toList()
                ).stream()
                .collect(Collectors.toMap(Ingredient::getId, Function.identity()));

        return substitutes.stream()
                .map(substitute -> toSubstituteResponse(substitute, ingredients.get(substitute.getSubstituteIngredientId())))
                .toList();
    }

    public ListResponse<IngredientCardResponse> getIngredients(Pageable pageable) {
        Page<Ingredient> ingredientPage = ingredientRepository.findByActiveTrue(pageable);

        List<IngredientCardResponse> items = ingredientPage.getContent().stream()
                .map(this::toCardResponse)
                .toList();

        return new ListResponse<>(
                items,
                ingredientPage.getNumber(),
                ingredientPage.getSize(),
                ingredientPage.getTotalElements(),
                ingredientPage.hasNext()
        );
    }

    public IngredientDetailResponse getIngredientDetail(Long ingredientId) {
        Ingredient ingredient = getActiveIngredientOrThrow(ingredientId);

        return new IngredientDetailResponse(
                ingredient.getId(),
                ingredient.getName(),
                ingredient.getCategory(),
                ingredient.getImageUrl(),
                ingredient.getBaseUnit(),
                false,
                null,
                null,
                null,
                null,
                List.of(),
                nutritionRepository.findByIngredientId(ingredientId)
                        .map(n -> new IngredientDetailResponse.NutritionResponse(
                                n.getCalories(), n.getCarbohydrate(), n.getSugar(), n.getFiber(), n.getProtein(), n.getFat(),
                                java.util.stream.Stream.of(
                                        new IngredientDetailResponse.NutritionItemResponse("비타민C", n.getVitaminC()),
                                        new IngredientDetailResponse.NutritionItemResponse("칼륨", n.getPotassium()),
                                        new IngredientDetailResponse.NutritionItemResponse("엽산", n.getFolate())
                                ).filter(v -> v.value() != null).toList()
                        ))
                        .orElse(null),
                careTipRepository.findByIngredientIdOrderByTipOrderAsc(ingredientId).stream().map(t -> t.getContent()).toList(),
                storageTipRepository.findByIngredientId(ingredientId).stream()
                        .map(t -> new IngredientDetailResponse.StorageTipResponse(t.getStorageType(), t.getDescription(), t.getIcon()))
                        .toList(),
                storeOfferRepository.countByIngredientId(ingredientId)
        );
    }

    public List<IngredientOfferResponse> getOffers(Long ingredientId) {
        getActiveIngredientOrThrow(ingredientId);
        Map<Long, Store> stores = storeRepository.findAllById(storeOfferRepository.findByIngredientIdOrderByPriceAsc(ingredientId).stream().map(StoreOffer::getStoreId).toList())
                .stream().collect(Collectors.toMap(Store::getId, Function.identity()));
        return storeOfferRepository.findByIngredientIdOrderByPriceAsc(ingredientId).stream()
                .map(offer -> toOfferResponse(offer, stores.get(offer.getStoreId())))
                .toList();
    }

    public List<RecipeCardResponse> getRelatedRecipes(Long ingredientId) {
        getActiveIngredientOrThrow(ingredientId);
        List<Long> recipeIds = recipeIngredientRepository.findByIngredientIdOrderByIdAsc(ingredientId).stream()
                .map(RecipeIngredient::getRecipeId).distinct().toList();
        Map<Long, Recipe> recipes = recipeRepository.findAllById(recipeIds).stream()
                .filter(recipe -> "PUBLISHED".equals(recipe.getStatus()))
                .collect(Collectors.toMap(Recipe::getId, Function.identity()));
        return recipeIds.stream().map(recipes::get).filter(Objects::nonNull)
                .map(recipe -> new RecipeCardResponse(recipe.getId(), recipe.getTitle(), recipe.getDescription(), recipe.getImageUrl(), recipe.getDifficulty(), recipe.getMinutes(), recipe.getServings(), 0, 0, null, List.of(recipe.getDifficulty(), recipe.getMinutes() + "분"), false))
                .toList();
    }

    public IngredientPriceHistoryResponse getPriceHistory(Long ingredientId, LocalDate from, LocalDate to) {
        Ingredient ingredient = getActiveIngredientOrThrow(ingredientId);

        List<PriceSnapshot> snapshots = findSnapshots(ingredientId, from, to);
        List<IngredientPriceHistoryResponse.PriceHistoryItemResponse> items = snapshots.stream()
                .map(snapshot -> new IngredientPriceHistoryResponse.PriceHistoryItemResponse(
                        snapshot.getObservedDate(),
                        snapshot.getPrice()
                ))
                .toList();

        String unit = snapshots.isEmpty() ? null : snapshots.get(0).getUnit();
        String source = snapshots.isEmpty() ? null : snapshots.get(0).getSource();

        return new IngredientPriceHistoryResponse(
                ingredient.getId(),
                ingredient.getName(),
                unit,
                source,
                items
        );
    }

    private List<PriceSnapshot> findSnapshots(Long ingredientId, LocalDate from, LocalDate to) {
        if (from != null && to != null) {
            return priceSnapshotRepository.findByIngredientIdAndObservedDateBetweenOrderByObservedDateAsc(ingredientId, from, to);
        }
        if (from != null) {
            return priceSnapshotRepository.findByIngredientIdAndObservedDateGreaterThanEqualOrderByObservedDateAsc(ingredientId, from);
        }
        if (to != null) {
            return priceSnapshotRepository.findByIngredientIdAndObservedDateLessThanEqualOrderByObservedDateAsc(ingredientId, to);
        }
        return priceSnapshotRepository.findByIngredientIdOrderByObservedDateAsc(ingredientId);
    }

    private Ingredient getActiveIngredientOrThrow(Long ingredientId) {
        return ingredientRepository.findByIdAndActiveTrue(ingredientId)
                .orElseThrow(() -> new BusinessException(ErrorCode.INGREDIENT_NOT_FOUND));
    }

    private IngredientCardResponse toCardResponse(Ingredient ingredient) {
        return new IngredientCardResponse(
                ingredient.getId(),
                ingredient.getName(),
                ingredient.getImageUrl(),
                ingredient.getCategory(),
                null,
                false,
                null,
                List.of()
        );
    }

    private IngredientSubstituteResponse toSubstituteResponse(IngredientSubstitute substitute, Ingredient ingredient) {
        return new IngredientSubstituteResponse(
                substitute.getSubstituteIngredientId(),
                ingredient == null ? null : ingredient.getName(),
                substitute.getScore(),
                substitute.getReason(),
                ingredient == null ? null : ingredient.getImageUrl(),
                latestPrice(substitute.getSubstituteIngredientId()),
                latestPriceUnit(substitute.getSubstituteIngredientId()),
                null
        );
    }

    private java.math.BigDecimal latestPrice(Long ingredientId) {
        List<PriceSnapshot> snapshots = priceSnapshotRepository.findByIngredientIdOrderByObservedDateAsc(ingredientId);
        return snapshots.isEmpty() ? null : snapshots.get(snapshots.size() - 1).getPrice();
    }

    private String latestPriceUnit(Long ingredientId) {
        List<PriceSnapshot> snapshots = priceSnapshotRepository.findByIngredientIdOrderByObservedDateAsc(ingredientId);
        return snapshots.isEmpty() ? null : snapshots.get(snapshots.size() - 1).getUnit();
    }

    private IngredientOfferResponse toOfferResponse(StoreOffer offer, Store store) {
        return new IngredientOfferResponse(
                offer.getId(), offer.getStoreId(), store == null ? null : store.getName(), store == null ? null : store.getStoreType(),
                store == null ? null : store.getLogoUrl(), store == null ? null : store.getLogoText(), store == null ? null : store.getBrandColor(),
                offer.getPrice(), offer.getPriceRangeMin(), offer.getPriceRangeMax(), offer.getOriginalPrice(), offer.getDiscountRate(),
                offer.getUnit(), offer.getDeliveryLabel(), offer.getBadge(), offer.getProductUrl(), offer.getObservedAt()
        );
    }
}

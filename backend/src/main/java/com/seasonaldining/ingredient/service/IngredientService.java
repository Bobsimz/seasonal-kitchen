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
import com.seasonaldining.ingredient.entity.IngredientStorageTip;
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
        PriceInfo p = priceInfo(ingredientId);

        // 영양 정보: 프론트는 {label,value} 배열을 읽는다. 칼로리/비타민/칼륨/엽산을 표시용 항목으로 평탄화.
        List<IngredientDetailResponse.NutritionItemResponse> nutrition =
                nutritionRepository.findByIngredientId(ingredientId)
                        .map(n -> java.util.stream.Stream.of(
                                        new IngredientDetailResponse.NutritionItemResponse("칼로리", n.getCalories() == null ? null : n.getCalories() + "kcal"),
                                        new IngredientDetailResponse.NutritionItemResponse("비타민C", n.getVitaminC()),
                                        new IngredientDetailResponse.NutritionItemResponse("칼륨", n.getPotassium()),
                                        new IngredientDetailResponse.NutritionItemResponse("엽산", n.getFolate())
                                ).filter(v -> v.value() != null).toList())
                        .orElse(null);

        return new IngredientDetailResponse(
                ingredient.getId(),
                ingredient.getName(),
                ingredient.getCategory(),
                ingredient.getImageUrl(),
                ingredient.getBaseUnit(),
                false,
                p.hot,
                null,
                p.currentPrice,
                p.unit,
                p.priceChangePct,
                p.trendDirection,
                p.priceChangeLabel,
                null,
                p.buyingSignal,
                null,
                List.of(),
                nutrition,
                careTipRepository.findByIngredientIdOrderByTipOrderAsc(ingredientId).stream().map(t -> t.getContent()).toList(),
                // 보관 팁: 프론트는 string[] 을 읽으므로 설명 문자열만 내려준다.
                storageTipRepository.findByIngredientId(ingredientId).stream()
                        .map(IngredientStorageTip::getDescription)
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
                .map(recipe -> new RecipeCardResponse(recipe.getId(), recipe.getTitle(), recipe.getDescription(), recipe.getImageUrl(), recipe.getDifficulty(), recipe.getMinutes(), recipe.getServings(), 0, 0, null, List.of(recipe.getDifficulty(), recipe.getMinutes() + "분"), false, List.of()))
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

    public IngredientCardResponse toCardResponse(Ingredient ingredient) {
        PriceInfo p = priceInfo(ingredient.getId());
        return new IngredientCardResponse(
                ingredient.getId(),
                ingredient.getName(),
                ingredient.getImageUrl(),
                ingredient.getCategory(),
                p.currentPrice,
                p.unit,
                p.priceChangePct,
                p.trendDirection,
                p.priceChangeLabel,
                false,
                p.hot,
                List.of(),
                null,
                p.buyingSignal,
                List.of()
        );
    }

    /**
     * 식재료의 최신 가격 스냅샷과 직전(약 1주 전) 스냅샷을 비교해 표시용 가격 정보를 만든다.
     * 스냅샷이 없으면 currentPrice 는 null(프론트가 허용). hot 은 큰 폭의 가격 하락을 신호로 본다.
     */
    private PriceInfo priceInfo(Long ingredientId) {
        List<PriceSnapshot> snapshots = priceSnapshotRepository.findByIngredientIdOrderByObservedDateAsc(ingredientId);
        if (snapshots.isEmpty()) {
            return new PriceInfo(null, null, null, null, null, null, false);
        }
        PriceSnapshot latest = snapshots.get(snapshots.size() - 1);
        java.math.BigDecimal currentPrice = latest.getPrice();
        String unit = latest.getUnit();

        // 직전 비교 기준: 1주(7일) 전 또는 그보다 이른 가장 가까운 스냅샷, 없으면 바로 직전 스냅샷.
        PriceSnapshot prior = null;
        LocalDate weekAgo = latest.getObservedDate().minusDays(7);
        for (int i = snapshots.size() - 2; i >= 0; i--) {
            PriceSnapshot s = snapshots.get(i);
            prior = s; // 가장 최근 직전값(루프가 끝나면 가장 이른 값으로 갱신되므로 아래에서 보정)
            if (!s.getObservedDate().isAfter(weekAgo)) {
                break;
            }
        }
        if (snapshots.size() >= 2 && prior == null) {
            prior = snapshots.get(snapshots.size() - 2);
        }

        Integer priceChangePct = null;
        String trendDirection = null;
        String priceChangeLabel = null;
        boolean hot = false;
        if (prior != null && prior.getPrice().signum() != 0) {
            java.math.BigDecimal change = currentPrice.subtract(prior.getPrice())
                    .multiply(java.math.BigDecimal.valueOf(100))
                    .divide(prior.getPrice(), 0, java.math.RoundingMode.HALF_UP);
            int pct = change.intValue();
            priceChangePct = pct;
            trendDirection = pct > 1 ? "UP" : pct < -1 ? "DOWN" : "FLAT";
            priceChangeLabel = pct == 0 ? "보합" : (pct > 0 ? "+" : "") + pct + "%";
            hot = pct <= -10;
        } else {
            // 비교할 이전 시세가 없음(이력 1개) — 추정 %는 만들지 않되, 카드/히어로/상세의
            // 추세 배지가 비지 않도록 중립(보합) 표기를 채운다. priceChangePct 는 null 유지.
            trendDirection = "FLAT";
            priceChangeLabel = "보합";
        }

        String buyingSignal;
        if (priceChangePct != null) {
            buyingSignal = priceChangePct <= -10 ? "GOOD" : priceChangePct >= 5 ? "HIGH" : "HOLD";
        } else {
            // 변동 데이터 없음 → 평년 수준(HOLD)으로 표기.
            buyingSignal = "HOLD";
        }

        return new PriceInfo(currentPrice, unit, priceChangePct, trendDirection, priceChangeLabel, buyingSignal, hot);
    }

    /** 표시용 가격 정보 묶음(카드/상세 공용). */
    private record PriceInfo(
            java.math.BigDecimal currentPrice,
            String unit,
            Integer priceChangePct,
            String trendDirection,
            String priceChangeLabel,
            String buyingSignal,
            boolean hot
    ) {
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

package com.seasonaldining.recommendation.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.seasonaldining.common.exception.BusinessException;
import com.seasonaldining.common.exception.ErrorCode;
import com.seasonaldining.ingredient.entity.Ingredient;
import com.seasonaldining.ingredient.repository.IngredientRepository;
import com.seasonaldining.price.entity.PriceSnapshot;
import com.seasonaldining.price.repository.PriceSnapshotRepository;
import com.seasonaldining.recommendation.dto.request.CreateShoppingPlanRequest;
import com.seasonaldining.recommendation.entity.RecommendationSession;
import com.seasonaldining.recommendation.repository.RecommendationSessionRepository;
import com.seasonaldining.shopping.dto.response.ShoppingPlanItemResponse;
import com.seasonaldining.shopping.dto.response.ShoppingPlanResponse;
import com.seasonaldining.shopping.dto.response.ShoppingPlanStoreLinksResponse;
import com.seasonaldining.shopping.entity.ShoppingPlan;
import com.seasonaldining.shopping.entity.ShoppingPlanItem;
import com.seasonaldining.shopping.repository.ShoppingPlanItemRepository;
import com.seasonaldining.shopping.repository.ShoppingPlanRepository;
import com.seasonaldining.store.entity.Store;
import com.seasonaldining.store.entity.StoreOffer;
import com.seasonaldining.store.repository.StoreOfferRepository;
import com.seasonaldining.store.repository.StoreRepository;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
public class RecommendationPlanService {

    private final RecommendationSessionRepository sessions;
    private final ShoppingPlanRepository plans;
    private final ShoppingPlanItemRepository items;
    private final IngredientRepository ingredients;
    private final PriceSnapshotRepository prices;
    private final StoreOfferRepository storeOffers;
    private final StoreRepository stores;
    private final ObjectMapper mapper;

    public RecommendationPlanService(
            RecommendationSessionRepository sessions,
            ShoppingPlanRepository plans,
            ShoppingPlanItemRepository items,
            IngredientRepository ingredients,
            PriceSnapshotRepository prices,
            StoreOfferRepository storeOffers,
            StoreRepository stores,
            ObjectMapper mapper
    ) {
        this.sessions = sessions;
        this.plans = plans;
        this.items = items;
        this.ingredients = ingredients;
        this.prices = prices;
        this.storeOffers = storeOffers;
        this.stores = stores;
        this.mapper = mapper;
    }

    @Transactional
    public ShoppingPlanResponse create(Long userId, CreateShoppingPlanRequest request) {
        try {
            RecommendationSession session = sessions.save(new RecommendationSession(userId, mapper.writeValueAsString(request)));
            ShoppingPlan plan = plans.save(new ShoppingPlan(userId, session.getId(), request.days(), request.people(), request.budget()));
            List<ShoppingPlanItem> createdItems = createItemsFromDatabasePrices(plan);
            plan.setEstimatedTotal(sumEstimatedPrices(createdItems));
            return response(plan);
        } catch (JsonProcessingException e) {
            throw new IllegalStateException(e);
        }
    }

    @Transactional(readOnly = true)
    public ShoppingPlanResponse get(Long userId, Long planId) {
        return response(findOwnedPlan(userId, planId));
    }

    @Transactional(readOnly = true)
    public ShoppingPlanStoreLinksResponse getStoreLinks(Long userId, Long planId) {
        ShoppingPlan plan = findOwnedPlan(userId, planId);
        List<ShoppingPlanItem> selectedItems = items.findByPlanIdOrderByIdAsc(plan.getId()).stream()
                .filter(ShoppingPlanItem::isSelected)
                .toList();
        Map<Long, Ingredient> ingredientMap = ingredientMap(selectedItems);

        Map<String, StoreGroupAccumulator> groups = new LinkedHashMap<>();
        for (ShoppingPlanItem item : selectedItems) {
            StoreOffer offer = cheapestOffer(item.getIngredientId());
            Store store = offer == null ? null : stores.findById(offer.getStoreId()).orElse(null);
            String groupKey = store == null ? "NO_STORE" : String.valueOf(store.getId());
            StoreGroupAccumulator group = groups.computeIfAbsent(groupKey, key -> new StoreGroupAccumulator(store, offer));
            ShoppingPlanItemResponse itemResponse = toItemResponse(item, ingredientMap.get(item.getIngredientId()), offer, store);
            group.items().add(itemResponse);
            group.add(itemResponse.estimatedPrice());
        }

        List<ShoppingPlanStoreLinksResponse.StoreGroupResponse> storeGroups = groups.values().stream()
                .map(StoreGroupAccumulator::toResponse)
                .toList();
        return new ShoppingPlanStoreLinksResponse(expectedSavingAmount(plan), storeGroups);
    }

    private List<ShoppingPlanItem> createItemsFromDatabasePrices(ShoppingPlan plan) {
        int itemLimit = Math.max(3, Math.min(9, plan.getDays() * plan.getPeople()));
        List<Ingredient> candidates = ingredients.findByActiveTrue(PageRequest.of(0, itemLimit)).getContent();
        List<ShoppingPlanItem> created = candidates.stream()
                .map(ingredient -> new ShoppingPlanItem(
                        plan.getId(),
                        ingredient.getId(),
                        BigDecimal.ONE,
                        ingredient.getBaseUnit(),
                        latestPrice(ingredient.getId())
                ))
                .toList();
        return items.saveAll(created);
    }

    private ShoppingPlan findOwnedPlan(Long userId, Long planId) {
        return plans.findByIdAndUserId(planId, userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.SHOPPING_PLAN_NOT_FOUND));
    }

    private ShoppingPlanResponse response(ShoppingPlan plan) {
        List<ShoppingPlanItem> planItems = items.findByPlanIdOrderByIdAsc(plan.getId());
        Map<Long, Ingredient> ingredientMap = ingredientMap(planItems);
        List<ShoppingPlanItemResponse> itemResponses = planItems.stream()
                .map(item -> {
                    StoreOffer offer = cheapestOffer(item.getIngredientId());
                    Store store = offer == null ? null : stores.findById(offer.getStoreId()).orElse(null);
                    return toItemResponse(item, ingredientMap.get(item.getIngredientId()), offer, store);
                })
                .toList();
        return new ShoppingPlanResponse(
                plan.getId(),
                plan.getSessionId(),
                plan.getDays(),
                plan.getPeople(),
                plan.getBudget(),
                plan.getEstimatedTotal(),
                plan.getStatus(),
                plan.getDays() + "일치 제철 식재료 중심 장보기 계획입니다.",
                expectedSavingRate(plan),
                expectedSavingAmount(plan),
                defaultMeals(plan),
                itemResponses,
                List.of("가격 후보는 DB에 저장된 공개 평균가와 스토어 오퍼만 사용했습니다.", "선택 해제한 항목은 스토어 링크 합계에서 제외됩니다."),
                List.of("대체 식재료는 등록된 substitute 데이터가 있는 경우 상세 화면에서 확인할 수 있습니다.")
        );
    }

    private Map<Long, Ingredient> ingredientMap(List<ShoppingPlanItem> planItems) {
        return ingredients.findAllById(planItems.stream().map(ShoppingPlanItem::getIngredientId).toList()).stream()
                .collect(Collectors.toMap(Ingredient::getId, Function.identity()));
    }

    private ShoppingPlanItemResponse toItemResponse(ShoppingPlanItem item, Ingredient ingredient, StoreOffer offer, Store store) {
        BigDecimal price = offer == null ? item.getEstimatedPrice() : offer.getPrice();
        return new ShoppingPlanItemResponse(
                item.getId(),
                item.getIngredientId(),
                ingredient == null ? null : ingredient.getName(),
                item.getQuantity(),
                item.getUnit(),
                price,
                item.isSelected(),
                store == null ? "시장 평균" : store.getName(),
                offer == null ? "추천" : offer.getBadge()
        );
    }

    private List<ShoppingPlanResponse.MealResponse> defaultMeals(ShoppingPlan plan) {
        List<ShoppingPlanResponse.MealResponse> meals = new ArrayList<>();
        for (int day = 1; day <= Math.min(plan.getDays(), 3); day++) {
            meals.add(new ShoppingPlanResponse.MealResponse("추천 식단 " + day, "제철 식재료 기반 식단", day, "DINNER"));
        }
        return meals;
    }

    private BigDecimal latestPrice(Long ingredientId) {
        List<PriceSnapshot> snapshots = prices.findByIngredientIdOrderByObservedDateAsc(ingredientId);
        return snapshots.isEmpty() ? null : snapshots.get(snapshots.size() - 1).getPrice();
    }

    private StoreOffer cheapestOffer(Long ingredientId) {
        return storeOffers.findByIngredientIdOrderByPriceAsc(ingredientId).stream()
                .min(Comparator.comparing(StoreOffer::getPrice))
                .orElse(null);
    }

    private BigDecimal sumEstimatedPrices(List<ShoppingPlanItem> planItems) {
        return planItems.stream()
                .map(ShoppingPlanItem::getEstimatedPrice)
                .filter(price -> price != null)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    private Integer expectedSavingRate(ShoppingPlan plan) {
        if (plan.getBudget() == null || plan.getBudget().compareTo(BigDecimal.ZERO) <= 0 || plan.getEstimatedTotal() == null) {
            return 0;
        }
        BigDecimal saving = expectedSavingAmount(plan);
        return saving.multiply(BigDecimal.valueOf(100))
                .divide(plan.getBudget(), 0, RoundingMode.DOWN)
                .intValue();
    }

    private BigDecimal expectedSavingAmount(ShoppingPlan plan) {
        if (plan.getBudget() == null || plan.getEstimatedTotal() == null) {
            return BigDecimal.ZERO;
        }
        return plan.getBudget().subtract(plan.getEstimatedTotal()).max(BigDecimal.ZERO);
    }

    private record StoreGroupAccumulator(Store store, StoreOffer firstOffer, List<ShoppingPlanItemResponse> items, BigDecimal[] total) {
        StoreGroupAccumulator(Store store, StoreOffer firstOffer) {
            this(store, firstOffer, new ArrayList<>(), new BigDecimal[]{BigDecimal.ZERO});
        }

        void add(BigDecimal price) {
            if (price != null) {
                total[0] = total[0].add(price);
            }
        }

        ShoppingPlanStoreLinksResponse.StoreGroupResponse toResponse() {
            return new ShoppingPlanStoreLinksResponse.StoreGroupResponse(
                    store == null ? "시장 평균" : store.getName(),
                    store == null ? "PUBLIC_AVERAGE" : store.getStoreType(),
                    firstOffer == null ? null : firstOffer.getDeliveryLabel(),
                    total[0],
                    firstOffer == null ? null : firstOffer.getProductUrl(),
                    items
            );
        }
    }
}

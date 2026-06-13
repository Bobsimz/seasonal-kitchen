package com.seasonaldining.favorite.service;

import com.seasonaldining.common.exception.BusinessException;
import com.seasonaldining.common.exception.ErrorCode;
import com.seasonaldining.favorite.dto.request.CreateFavoriteRequest;
import com.seasonaldining.favorite.dto.response.FavoriteResponse;
import com.seasonaldining.favorite.entity.Favorite;
import com.seasonaldining.favorite.repository.FavoriteRepository;
import com.seasonaldining.ingredient.entity.Ingredient;
import com.seasonaldining.ingredient.repository.IngredientRepository;
import com.seasonaldining.producer.entity.OfferPhoto;
import com.seasonaldining.producer.entity.Producer;
import com.seasonaldining.producer.entity.ProducerOffer;
import com.seasonaldining.producer.repository.OfferPhotoRepository;
import com.seasonaldining.producer.repository.ProducerOfferRepository;
import com.seasonaldining.producer.repository.ProducerRepository;
import com.seasonaldining.producer.service.ProducerService;
import com.seasonaldining.recipe.entity.Recipe;
import com.seasonaldining.recipe.repository.RecipeRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class FavoriteService {
    private final FavoriteRepository favoriteRepository;
    private final IngredientRepository ingredientRepository;
    private final RecipeRepository recipeRepository;
    private final ProducerService producerService;
    private final ProducerRepository producerRepository;
    private final ProducerOfferRepository offerRepository;
    private final OfferPhotoRepository offerPhotoRepository;

    public FavoriteService(FavoriteRepository favoriteRepository, IngredientRepository ingredientRepository,
                           RecipeRepository recipeRepository, ProducerService producerService,
                           ProducerRepository producerRepository, ProducerOfferRepository offerRepository,
                           OfferPhotoRepository offerPhotoRepository) {
        this.favoriteRepository = favoriteRepository;
        this.ingredientRepository = ingredientRepository;
        this.recipeRepository = recipeRepository;
        this.producerService = producerService;
        this.producerRepository = producerRepository;
        this.offerRepository = offerRepository;
        this.offerPhotoRepository = offerPhotoRepository;
    }

    @Transactional(readOnly = true)
    public List<FavoriteResponse> getFavorites(Long userId) {
        List<Favorite> favorites = favoriteRepository.findByUserIdOrderByIdDesc(userId);
        if (favorites.isEmpty()) return List.of();

        // 타입별 대상 id를 모아 배치 조회 (N+1 회피).
        // 비활성/비공개 대상은 조회 대상에서 제외 → 요약 필드 null (식별 필드는 유지).
        List<Long> ingredientIds = idsOf(favorites, "INGREDIENT");
        Map<Long, Ingredient> ingredients = ingredientIds.isEmpty() ? Map.of()
                : byIds(ingredientRepository.findByIdInAndActiveTrue(ingredientIds), Ingredient::getId);
        List<Long> recipeIds = idsOf(favorites, "RECIPE");
        Map<Long, Recipe> recipes = recipeIds.isEmpty() ? Map.of()
                : byIds(recipeRepository.findByIdInAndStatus(recipeIds, "PUBLISHED"), Recipe::getId);
        Map<Long, Producer> producers = byIds(producerRepository.findAllById(idsOf(favorites, "PRODUCER")), Producer::getId);
        // 상품(offer)은 ACTIVE만 요약 (숨김 상품 제외)
        List<Long> offerIds = idsOf(favorites, "PRODUCT", "OFFER");
        Map<Long, ProducerOffer> offers = offerRepository.findAllById(offerIds).stream()
                .filter(o -> ProducerOffer.STATUS_ACTIVE.equals(o.getStatus()))
                .collect(Collectors.toMap(ProducerOffer::getId, o -> o, (a, b) -> a));
        Map<Long, String> firstPhotoByOffer = offers.isEmpty() ? Map.of()
                : offerPhotoRepository.findByOfferIdInOrderBySortOrderAsc(List.copyOf(offers.keySet())).stream()
                        .collect(Collectors.toMap(OfferPhoto::getOfferId, OfferPhoto::getUrl, (a, b) -> a));

        return favorites.stream()
                .map(f -> toResponse(f, ingredients, recipes, producers, offers, firstPhotoByOffer))
                .toList();
    }

    @Transactional
    public FavoriteResponse create(Long userId, CreateFavoriteRequest request) {
        validateTarget(request.targetType(), request.targetId());
        Favorite saved = favoriteRepository.save(new Favorite(userId, request.targetType(), request.targetId()));
        return enrichSingle(saved);
    }

    @Transactional
    public void delete(Long userId, Long favoriteId) {
        Favorite favorite = favoriteRepository.findByIdAndUserId(favoriteId, userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.FAVORITE_NOT_FOUND));
        favoriteRepository.delete(favorite);
    }

    private void validateTarget(String type, Long id) {
        if ("INGREDIENT".equals(type) && ingredientRepository.findByIdAndActiveTrue(id).isPresent()) return;
        if ("RECIPE".equals(type) && recipeRepository.findByIdAndStatus(id, "PUBLISHED").isPresent()) return;
        if ("PRODUCER".equals(type) && producerService.existsById(id)) return;
        // PRODUCT/OFFER(상품 상세 찜): ACTIVE 상태인 오퍼만 찜 가능 (숨김/삭제 제외)
        if (("PRODUCT".equals(type) || "OFFER".equals(type)) && offerRepository.findById(id)
                .filter(o -> ProducerOffer.STATUS_ACTIVE.equals(o.getStatus())).isPresent()) return;
        throw new BusinessException(switch (type == null ? "" : type) {
            case "RECIPE" -> ErrorCode.RECIPE_NOT_FOUND;
            case "PRODUCER" -> ErrorCode.PRODUCER_NOT_FOUND;
            case "PRODUCT", "OFFER" -> ErrorCode.PRODUCER_OFFER_NOT_FOUND;
            default -> ErrorCode.INGREDIENT_NOT_FOUND;
        });
    }

    // ── 매핑 ────────────────────────────────────────────────
    private FavoriteResponse toResponse(Favorite f, Map<Long, Ingredient> ingredients, Map<Long, Recipe> recipes,
                                        Map<Long, Producer> producers, Map<Long, ProducerOffer> offers,
                                        Map<Long, String> firstPhotoByOffer) {
        String type = f.getTargetType();
        Long tid = f.getTargetId();
        String title = null, imageUrl = null, subtitle = null;
        switch (type == null ? "" : type) {
            case "INGREDIENT" -> {
                Ingredient i = ingredients.get(tid);
                if (i != null) { title = i.getName(); imageUrl = i.getImageUrl(); subtitle = i.getCategory(); }
            }
            case "RECIPE" -> {
                Recipe r = recipes.get(tid);
                if (r != null) { title = r.getTitle(); imageUrl = r.getImageUrl(); subtitle = r.getDescription(); }
            }
            case "PRODUCER" -> {
                Producer p = producers.get(tid);
                if (p != null) {
                    title = p.getName(); imageUrl = p.getPhotoUrl();
                    subtitle = (p.getTagline() != null && !p.getTagline().isBlank()) ? p.getTagline() : p.getRegion();
                }
            }
            case "PRODUCT", "OFFER" -> {
                ProducerOffer o = offers.get(tid);
                if (o != null) {
                    title = (o.getTitle() != null && !o.getTitle().isBlank()) ? o.getTitle() : o.getIngredientName();
                    imageUrl = firstPhotoByOffer.get(tid);
                    subtitle = priceLabel(o.getPrice(), o.getUnit());
                }
            }
            default -> { /* 알 수 없는 타입 — 요약 없음 */ }
        }
        return new FavoriteResponse(f.getId(), type, tid, title, imageUrl, subtitle);
    }

    /** 단건(create) 요약 — 배치 없이 직접 조회. */
    private FavoriteResponse enrichSingle(Favorite f) {
        Map<Long, Ingredient> ing = Map.of();
        Map<Long, Recipe> rec = Map.of();
        Map<Long, Producer> prod = Map.of();
        Map<Long, ProducerOffer> off = Map.of();
        Map<Long, String> photo = Map.of();
        String type = f.getTargetType();
        Long tid = f.getTargetId();
        switch (type == null ? "" : type) {
            case "INGREDIENT" -> ing = singleMap(ingredientRepository.findById(tid).orElse(null), Ingredient::getId);
            case "RECIPE" -> rec = singleMap(recipeRepository.findById(tid).orElse(null), Recipe::getId);
            case "PRODUCER" -> prod = singleMap(producerRepository.findById(tid).orElse(null), Producer::getId);
            case "PRODUCT", "OFFER" -> {
                ProducerOffer o = offerRepository.findById(tid).orElse(null);
                off = singleMap(o, ProducerOffer::getId);
                if (o != null) {
                    photo = offerPhotoRepository.findByOfferIdOrderBySortOrderAsc(tid).stream()
                            .findFirst().map(p -> Map.of(tid, p.getUrl())).orElse(Map.of());
                }
            }
            default -> { }
        }
        return toResponse(f, ing, rec, prod, off, photo);
    }

    private String priceLabel(BigDecimal price, String unit) {
        if (price == null) return null;
        String p = String.format("%,d원", price.longValue());
        return (unit == null || unit.isBlank()) ? p : p + "/" + unit;
    }

    private List<Long> idsOf(List<Favorite> favorites, String... types) {
        List<String> wanted = List.of(types);
        return favorites.stream()
                .filter(f -> wanted.contains(f.getTargetType()))
                .map(Favorite::getTargetId).distinct().toList();
    }

    private <T> Map<Long, T> byIds(Iterable<T> entities, java.util.function.Function<T, Long> idFn) {
        Map<Long, T> map = new java.util.HashMap<>();
        for (T e : entities) map.put(idFn.apply(e), e);
        return map;
    }

    private <T> Map<Long, T> singleMap(T entity, java.util.function.Function<T, Long> idFn) {
        return entity == null ? Map.of() : Map.of(idFn.apply(entity), entity);
    }
}

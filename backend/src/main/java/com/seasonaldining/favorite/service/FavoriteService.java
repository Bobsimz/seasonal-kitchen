package com.seasonaldining.favorite.service;

import com.seasonaldining.common.exception.BusinessException;
import com.seasonaldining.common.exception.ErrorCode;
import com.seasonaldining.favorite.dto.request.CreateFavoriteRequest;
import com.seasonaldining.favorite.dto.response.FavoriteResponse;
import com.seasonaldining.favorite.entity.Favorite;
import com.seasonaldining.favorite.repository.FavoriteRepository;
import com.seasonaldining.ingredient.repository.IngredientRepository;
import com.seasonaldining.recipe.repository.RecipeRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
public class FavoriteService {
    private final FavoriteRepository favoriteRepository;
    private final IngredientRepository ingredientRepository;
    private final RecipeRepository recipeRepository;

    public FavoriteService(FavoriteRepository favoriteRepository, IngredientRepository ingredientRepository, RecipeRepository recipeRepository) {
        this.favoriteRepository = favoriteRepository;
        this.ingredientRepository = ingredientRepository;
        this.recipeRepository = recipeRepository;
    }

    @Transactional(readOnly = true)
    public List<FavoriteResponse> getFavorites(Long userId) {
        return favoriteRepository.findByUserIdOrderByIdDesc(userId).stream().map(this::toResponse).toList();
    }

    @Transactional
    public FavoriteResponse create(Long userId, CreateFavoriteRequest request) {
        validateTarget(request.targetType(), request.targetId());
        return toResponse(favoriteRepository.save(new Favorite(userId, request.targetType(), request.targetId())));
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
        throw new BusinessException("INGREDIENT".equals(type) ? ErrorCode.INGREDIENT_NOT_FOUND : ErrorCode.RECIPE_NOT_FOUND);
    }

    private FavoriteResponse toResponse(Favorite favorite) {
        return new FavoriteResponse(favorite.getId(), favorite.getTargetType(), favorite.getTargetId());
    }
}

package com.seasonaldining.shopping.service;

import com.seasonaldining.common.exception.BusinessException;
import com.seasonaldining.common.exception.ErrorCode;
import com.seasonaldining.ingredient.entity.Ingredient;
import com.seasonaldining.ingredient.repository.IngredientRepository;
import com.seasonaldining.shopping.dto.response.ShoppingPlanItemResponse;
import com.seasonaldining.shopping.entity.ShoppingPlanItem;
import com.seasonaldining.shopping.repository.ShoppingPlanItemRepository;
import com.seasonaldining.shopping.repository.ShoppingPlanRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ShoppingPlanItemService {

    private final ShoppingPlanRepository plans;
    private final ShoppingPlanItemRepository items;
    private final IngredientRepository ingredients;

    public ShoppingPlanItemService(
            ShoppingPlanRepository plans,
            ShoppingPlanItemRepository items,
            IngredientRepository ingredients
    ) {
        this.plans = plans;
        this.items = items;
        this.ingredients = ingredients;
    }

    @Transactional
    public ShoppingPlanItemResponse update(Long userId, Long planId, Long itemId, boolean selected) {
        plans.findByIdAndUserId(planId, userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.SHOPPING_PLAN_NOT_FOUND));
        ShoppingPlanItem item = items.findByIdAndPlanId(itemId, planId)
                .orElseThrow(() -> new BusinessException(ErrorCode.SHOPPING_PLAN_ITEM_NOT_FOUND));
        item.setSelected(selected);
        Ingredient ingredient = ingredients.findById(item.getIngredientId()).orElse(null);
        return new ShoppingPlanItemResponse(
                item.getId(),
                item.getIngredientId(),
                ingredient == null ? null : ingredient.getName(),
                item.getQuantity(),
                item.getUnit(),
                item.getEstimatedPrice(),
                item.isSelected(),
                null,
                null
        );
    }
}

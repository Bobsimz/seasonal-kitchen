package com.seasonaldining.user.service;

import com.seasonaldining.common.exception.BusinessException;
import com.seasonaldining.common.exception.ErrorCode;
import com.seasonaldining.ingredient.entity.Ingredient;
import com.seasonaldining.ingredient.repository.IngredientRepository;
import com.seasonaldining.user.dto.request.CreatePantryItemRequest;
import com.seasonaldining.user.dto.request.UpdatePantryItemRequest;
import com.seasonaldining.user.dto.response.PantryItemResponse;
import com.seasonaldining.user.entity.PantryItem;
import com.seasonaldining.user.repository.PantryItemRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class PantryService {

    private final PantryItemRepository pantryItemRepository;
    private final IngredientRepository ingredientRepository;

    public PantryService(PantryItemRepository pantryItemRepository, IngredientRepository ingredientRepository) {
        this.pantryItemRepository = pantryItemRepository;
        this.ingredientRepository = ingredientRepository;
    }

    @Transactional(readOnly = true)
    public List<PantryItemResponse> getItems(Long userId) {
        return pantryItemRepository.findByUserIdOrderByIdDesc(userId).stream().map(this::toResponse).toList();
    }

    @Transactional
    public PantryItemResponse create(Long userId, CreatePantryItemRequest request) {
        getActiveIngredientOrThrow(request.ingredientId());
        PantryItem item = new PantryItem(userId, request.ingredientId(), request.quantity(), request.unit(), request.expiresAt());
        return toResponse(pantryItemRepository.save(item));
    }

    @Transactional
    public PantryItemResponse update(Long userId, Long itemId, UpdatePantryItemRequest request) {
        PantryItem item = getItemOrThrow(itemId, userId);
        item.update(request.quantity(), request.unit(), request.expiresAt());
        return toResponse(item);
    }

    @Transactional
    public void delete(Long userId, Long itemId) {
        pantryItemRepository.delete(getItemOrThrow(itemId, userId));
    }

    private PantryItem getItemOrThrow(Long itemId, Long userId) {
        return pantryItemRepository.findByIdAndUserId(itemId, userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.PANTRY_ITEM_NOT_FOUND));
    }

    private Ingredient getActiveIngredientOrThrow(Long ingredientId) {
        return ingredientRepository.findByIdAndActiveTrue(ingredientId)
                .orElseThrow(() -> new BusinessException(ErrorCode.INGREDIENT_NOT_FOUND));
    }

    private PantryItemResponse toResponse(PantryItem item) {
        Ingredient ingredient = getActiveIngredientOrThrow(item.getIngredientId());
        return new PantryItemResponse(item.getId(), item.getIngredientId(), ingredient.getName(), item.getQuantity(), item.getUnit(), item.getExpiresAt());
    }
}

package com.seasonaldining.ingredient.repository;

import com.seasonaldining.ingredient.entity.IngredientStorageTip;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface IngredientStorageTipRepository extends JpaRepository<IngredientStorageTip, Long> {
    List<IngredientStorageTip> findByIngredientId(Long ingredientId);
}

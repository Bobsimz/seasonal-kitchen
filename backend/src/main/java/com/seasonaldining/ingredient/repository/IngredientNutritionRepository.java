package com.seasonaldining.ingredient.repository;

import com.seasonaldining.ingredient.entity.IngredientNutrition;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface IngredientNutritionRepository extends JpaRepository<IngredientNutrition, Long> {
    Optional<IngredientNutrition> findByIngredientId(Long ingredientId);
}

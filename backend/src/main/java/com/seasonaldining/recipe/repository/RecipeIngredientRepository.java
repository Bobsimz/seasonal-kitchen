package com.seasonaldining.recipe.repository;

import com.seasonaldining.recipe.entity.RecipeIngredient;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface RecipeIngredientRepository extends JpaRepository<RecipeIngredient, Long> {

    List<RecipeIngredient> findByRecipeIdOrderByIdAsc(Long recipeId);
    List<RecipeIngredient> findByIngredientIdOrderByIdAsc(Long ingredientId);
}

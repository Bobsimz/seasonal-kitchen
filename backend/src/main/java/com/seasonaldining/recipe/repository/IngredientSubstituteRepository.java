package com.seasonaldining.recipe.repository;

import com.seasonaldining.recipe.entity.IngredientSubstitute;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface IngredientSubstituteRepository extends JpaRepository<IngredientSubstitute, Long> {

    List<IngredientSubstitute> findByIngredientIdOrderByScoreDesc(Long ingredientId);
}

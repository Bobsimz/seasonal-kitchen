package com.seasonaldining.ingredient.repository;

import com.seasonaldining.ingredient.entity.IngredientCareTip;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface IngredientCareTipRepository extends JpaRepository<IngredientCareTip, Long> {
    List<IngredientCareTip> findByIngredientIdOrderByTipOrderAsc(Long ingredientId);
}

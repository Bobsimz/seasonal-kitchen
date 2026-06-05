package com.seasonaldining.ingredient.repository;

import com.seasonaldining.ingredient.entity.Ingredient;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.List;

public interface IngredientRepository extends JpaRepository<Ingredient, Long> {

    Page<Ingredient> findByActiveTrue(Pageable pageable);

    Optional<Ingredient> findByIdAndActiveTrue(Long id);
    List<Ingredient> findTop20ByActiveTrueAndNameContainingIgnoreCaseOrderByIdDesc(String name);
}

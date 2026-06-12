package com.seasonaldining.recipe.repository;

import com.seasonaldining.recipe.entity.Recipe;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.List;

public interface RecipeRepository extends JpaRepository<Recipe, Long> {

    Page<Recipe> findByStatus(String status, Pageable pageable);

    Optional<Recipe> findByIdAndStatus(Long id, String status);
    List<Recipe> findTop20ByStatusAndTitleContainingIgnoreCaseOrderByIdDesc(String status, String title);
    List<Recipe> findByIdInAndStatus(List<Long> ids, String status);
}

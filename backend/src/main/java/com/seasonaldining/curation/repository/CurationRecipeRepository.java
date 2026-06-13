package com.seasonaldining.curation.repository;

import com.seasonaldining.curation.entity.CurationRecipe;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CurationRecipeRepository extends JpaRepository<CurationRecipe, Long> {

    List<CurationRecipe> findByCurationIdOrderBySortOrderAscIdAsc(Long curationId);
}

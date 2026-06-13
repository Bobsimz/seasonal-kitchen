package com.seasonaldining.curation.repository;

import com.seasonaldining.curation.entity.CurationIngredient;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CurationIngredientRepository extends JpaRepository<CurationIngredient, Long> {

    List<CurationIngredient> findByCurationIdOrderBySortOrderAscIdAsc(Long curationId);
}

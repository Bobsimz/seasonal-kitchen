package com.seasonaldining.price.repository;

import com.seasonaldining.price.entity.PriceSnapshot;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;

public interface PriceSnapshotRepository extends JpaRepository<PriceSnapshot, Long> {

    List<PriceSnapshot> findByIngredientIdOrderByObservedDateAsc(Long ingredientId);

    List<PriceSnapshot> findByIngredientIdAndObservedDateGreaterThanEqualOrderByObservedDateAsc(
            Long ingredientId,
            LocalDate from
    );

    List<PriceSnapshot> findByIngredientIdAndObservedDateLessThanEqualOrderByObservedDateAsc(
            Long ingredientId,
            LocalDate to
    );

    List<PriceSnapshot> findByIngredientIdAndObservedDateBetweenOrderByObservedDateAsc(
            Long ingredientId,
            LocalDate from,
            LocalDate to
    );
}

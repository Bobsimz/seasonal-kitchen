package com.seasonaldining.price.repository;

import com.seasonaldining.price.entity.PriceSnapshot;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface PriceSnapshotRepository extends JpaRepository<PriceSnapshot, Long> {

    List<PriceSnapshot> findByIngredientIdOrderByObservedDateAsc(Long ingredientId);

    /** 식재료의 가장 최근 시세 스냅샷(관측일 내림차순, 동일 관측일이면 id 내림차순). */
    Optional<PriceSnapshot> findFirstByIngredientIdOrderByObservedDateDescIdDesc(Long ingredientId);

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

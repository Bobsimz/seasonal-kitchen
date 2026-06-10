package com.seasonaldining.producer.repository;

import com.seasonaldining.producer.entity.ProducerSpecialty;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ProducerSpecialtyRepository extends JpaRepository<ProducerSpecialty, Long> {
    List<ProducerSpecialty> findByProducerId(Long producerId);
    boolean existsByProducerIdAndIngredientName(Long producerId, String ingredientName);
    // 식재료명 부분 매칭(프론트 producersForIngredient 동작 보존) — skeleton: contains 검색
    List<ProducerSpecialty> findByIngredientNameContaining(String ingredientName);
}

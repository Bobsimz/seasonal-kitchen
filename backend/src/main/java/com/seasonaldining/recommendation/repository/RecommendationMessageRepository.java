package com.seasonaldining.recommendation.repository;

import com.seasonaldining.recommendation.entity.RecommendationMessage;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface RecommendationMessageRepository extends JpaRepository<RecommendationMessage, Long> {

    List<RecommendationMessage> findBySessionIdOrderByIdAsc(Long sessionId);
}

package com.seasonaldining.reel.repository;

import com.seasonaldining.reel.entity.Reel;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface ReelRepository extends JpaRepository<Reel, Long> {
    List<Reel> findByStatusOrderByPublishedAtDesc(String status, Pageable pageable);
    List<Reel> findTop3ByRecipeIdAndStatusOrderByPublishedAtDesc(Long recipeId, String status);
    Optional<Reel> findByIdAndStatus(Long id, String status);
}

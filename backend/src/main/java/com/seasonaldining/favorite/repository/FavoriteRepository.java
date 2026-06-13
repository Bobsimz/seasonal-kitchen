package com.seasonaldining.favorite.repository;

import com.seasonaldining.favorite.entity.Favorite;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface FavoriteRepository extends JpaRepository<Favorite, Long> {
    List<Favorite> findByUserIdOrderByIdDesc(Long userId);
    Optional<Favorite> findByIdAndUserId(Long id, Long userId);
    long countByUserId(Long userId);

    /** 특정 대상(레시피 등)의 찜 개수. */
    long countByTargetTypeAndTargetId(String targetType, Long targetId);
}

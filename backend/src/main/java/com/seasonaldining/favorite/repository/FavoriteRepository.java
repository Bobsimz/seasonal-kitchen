package com.seasonaldining.favorite.repository;

import com.seasonaldining.favorite.entity.Favorite;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface FavoriteRepository extends JpaRepository<Favorite, Long> {
    List<Favorite> findByUserIdOrderByIdDesc(Long userId);
    Optional<Favorite> findByIdAndUserId(Long id, Long userId);
    long countByUserId(Long userId);
}

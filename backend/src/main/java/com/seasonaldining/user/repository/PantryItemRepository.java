package com.seasonaldining.user.repository;

import com.seasonaldining.user.entity.PantryItem;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface PantryItemRepository extends JpaRepository<PantryItem, Long> {
    List<PantryItem> findByUserIdOrderByIdDesc(Long userId);
    Optional<PantryItem> findByIdAndUserId(Long id, Long userId);
    long countByUserId(Long userId);
}

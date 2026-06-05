package com.seasonaldining.shopping.repository;

import com.seasonaldining.shopping.entity.ShoppingPlanItem;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ShoppingPlanItemRepository extends JpaRepository<ShoppingPlanItem, Long> {

    Optional<ShoppingPlanItem> findByIdAndPlanId(Long id, Long planId);

    List<ShoppingPlanItem> findByPlanIdOrderByIdAsc(Long planId);
}

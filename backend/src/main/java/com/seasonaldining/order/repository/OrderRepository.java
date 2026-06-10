package com.seasonaldining.order.repository;

import com.seasonaldining.order.entity.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface OrderRepository extends JpaRepository<Order, Long> {
    List<Order> findByUserIdOrderByOrderedAtDesc(Long userId);
    Optional<Order> findByIdAndUserId(Long id, Long userId);
    boolean existsByOrderNumber(String orderNumber);
}

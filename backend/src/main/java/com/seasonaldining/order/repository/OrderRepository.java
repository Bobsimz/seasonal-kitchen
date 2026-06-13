package com.seasonaldining.order.repository;

import com.seasonaldining.order.entity.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;
import java.util.Optional;

public interface OrderRepository extends JpaRepository<Order, Long> {
    List<Order> findByUserIdOrderByOrderedAtDesc(Long userId);
    Optional<Order> findByIdAndUserId(Long id, Long userId);
    boolean existsByOrderNumber(String orderNumber);
    long countByUserId(Long userId);

    /** 판매자 대시보드 — 이 농가의 항목이 포함된 주문(최신순). */
    @Query("select distinct o from com.seasonaldining.order.entity.Order o, OrderItem oi " +
           "where oi.orderId = o.id and oi.producerId = :producerId " +
           "order by o.orderedAt desc")
    List<Order> findOrdersForProducer(@Param("producerId") Long producerId);
}

package com.seasonaldining.order.repository;

import com.seasonaldining.order.entity.OrderItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.List;

public interface OrderItemRepository extends JpaRepository<OrderItem, Long> {
    List<OrderItem> findByOrderId(Long orderId);

    /** 판매자 주문 처리 — 해당 주문에 이 농가의 항목이 있는지(권한 확인). */
    boolean existsByOrderIdAndProducerId(Long orderId, Long producerId);

    /** 판매자 대시보드 — 여러 주문 중 이 농가의 항목만. 주문별 그룹핑해서 사용. */
    List<OrderItem> findByOrderIdInAndProducerId(List<Long> orderIds, Long producerId);

    /** 판매자 통계용 — 특정 농가의 (취소 제외) 주문 항목을 주문일·상품 스냅샷과 함께 조회. */
    @Query("select o.orderedAt as orderedAt, o.id as orderId, oi.ingredientName as ingredientName, " +
           "oi.qty as qty, oi.unitPrice as unitPrice, oi.offerId as offerId, oi.offerTitle as offerTitle " +
           "from OrderItem oi, com.seasonaldining.order.entity.Order o " +
           "where oi.orderId = o.id and oi.producerId = :producerId and o.status <> 'CANCELLED'")
    List<SellerOrderRow> findSellerRows(@Param("producerId") Long producerId);

    /** findSellerRows 투영 */
    interface SellerOrderRow {
        OffsetDateTime getOrderedAt();
        Long getOrderId();
        String getIngredientName();
        int getQty();
        BigDecimal getUnitPrice();
        Long getOfferId();      // 과거 데이터는 null
        String getOfferTitle(); // 과거 데이터는 null
    }
}

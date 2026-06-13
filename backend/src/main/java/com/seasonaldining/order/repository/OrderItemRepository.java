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

    /**
     * 리뷰 작성가능(writable) 대상 — 사용자의 배송완료(DELIVERED) 주문에서 구매한 농가들을 농가 단위로 집계.
     * 대표 식재료명·배송완료(없으면 주문)시각 포함. 이미 작성한 농가 제외는 서비스에서 처리.
     */
    @Query("select oi.producerId as producerId, min(oi.producerName) as producerName, " +
           "min(oi.ingredientName) as ingredientName, max(coalesce(o.deliveredAt, o.orderedAt)) as deliveredAt " +
           "from OrderItem oi, com.seasonaldining.order.entity.Order o " +
           "where oi.orderId = o.id and o.userId = :userId and o.status = 'DELIVERED' " +
           "group by oi.producerId")
    List<WritableReviewRow> findWritableReviewTargets(@Param("userId") Long userId);

    /** findWritableReviewTargets 투영 */
    interface WritableReviewRow {
        Long getProducerId();
        String getProducerName();
        String getIngredientName();
        OffsetDateTime getDeliveredAt();
    }
}

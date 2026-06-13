package com.seasonaldining.order.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.OffsetDateTime;

@Entity
@Table(name = "orders")
public class Order {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "user_id", nullable = false)
    private Long userId;
    @Column(name = "order_number", nullable = false, unique = true, length = 40)
    private String orderNumber;
    @Column(name = "total_amount", nullable = false)
    private BigDecimal totalAmount;
    @Column(name = "shipping_fee", nullable = false)
    private BigDecimal shippingFee = BigDecimal.ZERO;
    @Column(name = "points_earned", nullable = false)
    private BigDecimal pointsEarned = BigDecimal.ZERO;
    @Column(nullable = false, length = 20)
    private String status = "PAID";        // PAID | PREPARING | SHIPPED | DELIVERED | CANCELLED
    @Column(name = "ordered_at", nullable = false)
    private OffsetDateTime orderedAt = OffsetDateTime.now();
    // 배송 추적(V30) — SHIPPED 전이 시 기록. 그 전에는 모두 null.
    @Column(length = 50)
    private String carrier;
    @Column(name = "tracking_number", length = 60)
    private String trackingNumber;
    @Column(name = "shipped_at")
    private OffsetDateTime shippedAt;
    @Column(name = "delivered_at")
    private OffsetDateTime deliveredAt;

    protected Order() {}
    public Order(Long userId, String orderNumber, BigDecimal totalAmount, BigDecimal shippingFee, BigDecimal pointsEarned) {
        this.userId = userId; this.orderNumber = orderNumber; this.totalAmount = totalAmount;
        this.shippingFee = shippingFee; this.pointsEarned = pointsEarned;
        this.status = "PAID"; this.orderedAt = OffsetDateTime.now();
    }
    public Long getId() { return id; }
    public Long getUserId() { return userId; }
    public String getOrderNumber() { return orderNumber; }
    public BigDecimal getTotalAmount() { return totalAmount; }
    public BigDecimal getShippingFee() { return shippingFee; }
    public BigDecimal getPointsEarned() { return pointsEarned; }
    public String getStatus() { return status; }
    public OffsetDateTime getOrderedAt() { return orderedAt; }
    public String getCarrier() { return carrier; }
    public String getTrackingNumber() { return trackingNumber; }
    public OffsetDateTime getShippedAt() { return shippedAt; }
    public OffsetDateTime getDeliveredAt() { return deliveredAt; }

    /** 현재 상태를 enum으로. 알 수 없는 값이면 null. */
    public OrderStatus statusEnum() { return OrderStatus.from(status); }

    /**
     * 검증된 전이를 적용한다(전이 가능 여부·운송장 필수 검증은 호출 측 책임).
     * SHIPPED 진입 시 운송장/택배사·발송시각을, DELIVERED 진입 시 배송완료 시각을 기록한다.
     */
    public void applyTransition(OrderStatus next, String carrier, String trackingNumber) {
        this.status = next.name();
        if (next == OrderStatus.SHIPPED) {
            this.carrier = (carrier != null && !carrier.isBlank()) ? carrier.trim() : null;
            this.trackingNumber = trackingNumber == null ? null : trackingNumber.trim();
            this.shippedAt = OffsetDateTime.now();
        } else if (next == OrderStatus.DELIVERED) {
            this.deliveredAt = OffsetDateTime.now();
        }
    }
}

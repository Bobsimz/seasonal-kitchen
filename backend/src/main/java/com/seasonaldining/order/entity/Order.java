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
    private String status = "PAID";        // PAID | SHIPPING | DELIVERED | CANCELLED
    @Column(name = "ordered_at", nullable = false)
    private OffsetDateTime orderedAt = OffsetDateTime.now();

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
}

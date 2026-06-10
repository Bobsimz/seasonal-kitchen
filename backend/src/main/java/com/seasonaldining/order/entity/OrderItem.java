package com.seasonaldining.order.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "order_items")
public class OrderItem {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "order_id", nullable = false)
    private Long orderId;
    @Column(name = "producer_id", nullable = false)
    private Long producerId;
    @Column(name = "producer_name", length = 100)
    private String producerName;
    @Column(name = "ingredient_name", nullable = false, length = 50)
    private String ingredientName;
    @Column(nullable = false)
    private int qty;
    @Column(name = "unit_price", nullable = false)
    private BigDecimal unitPrice;

    protected OrderItem() {}
    public OrderItem(Long orderId, Long producerId, String producerName, String ingredientName, int qty, BigDecimal unitPrice) {
        this.orderId = orderId; this.producerId = producerId; this.producerName = producerName;
        this.ingredientName = ingredientName; this.qty = qty; this.unitPrice = unitPrice;
    }
    public Long getId() { return id; }
    public Long getOrderId() { return orderId; }
    public Long getProducerId() { return producerId; }
    public String getProducerName() { return producerName; }
    public String getIngredientName() { return ingredientName; }
    public int getQty() { return qty; }
    public BigDecimal getUnitPrice() { return unitPrice; }
}

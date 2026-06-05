package com.seasonaldining.price.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity @Table(name = "price_alerts")
public class PriceAlert {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) private Long id;
    @Column(name = "user_id", nullable = false) private Long userId;
    @Column(name = "ingredient_id", nullable = false) private Long ingredientId;
    @Column(name = "target_price", nullable = false, precision = 12, scale = 2) private BigDecimal targetPrice;
    @Column(nullable = false) private boolean active;
    protected PriceAlert() {}
    public PriceAlert(Long userId, Long ingredientId, BigDecimal targetPrice, boolean active) {
        this.userId=userId; this.ingredientId=ingredientId; this.targetPrice=targetPrice; this.active=active;
    }
    public void update(BigDecimal targetPrice, boolean active) { this.targetPrice=targetPrice; this.active=active; }
    public Long getId(){return id;} public Long getUserId(){return userId;} public Long getIngredientId(){return ingredientId;}
    public BigDecimal getTargetPrice(){return targetPrice;} public boolean isActive(){return active;}
}

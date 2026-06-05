package com.seasonaldining.user.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "pantry_items")
public class PantryItem {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "user_id", nullable = false)
    private Long userId;
    @Column(name = "ingredient_id", nullable = false)
    private Long ingredientId;
    @Column(precision = 12, scale = 2)
    private BigDecimal quantity;
    @Column(length = 30)
    private String unit;
    @Column(name = "expires_at")
    private LocalDate expiresAt;

    protected PantryItem() {
    }

    public PantryItem(Long userId, Long ingredientId, BigDecimal quantity, String unit, LocalDate expiresAt) {
        this.userId = userId;
        this.ingredientId = ingredientId;
        update(quantity, unit, expiresAt);
    }

    public void update(BigDecimal quantity, String unit, LocalDate expiresAt) {
        this.quantity = quantity;
        this.unit = unit;
        this.expiresAt = expiresAt;
    }

    public Long getId() { return id; }
    public Long getUserId() { return userId; }
    public Long getIngredientId() { return ingredientId; }
    public BigDecimal getQuantity() { return quantity; }
    public String getUnit() { return unit; }
    public LocalDate getExpiresAt() { return expiresAt; }
}

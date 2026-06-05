package com.seasonaldining.shopping.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.math.BigDecimal;

@Entity
@Table(name = "shopping_plan_items")
public class ShoppingPlanItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "plan_id", nullable = false)
    private Long planId;

    @Column(name = "ingredient_id", nullable = false)
    private Long ingredientId;

    @Column(precision = 12, scale = 2)
    private BigDecimal quantity;

    @Column(length = 30)
    private String unit;

    @Column(name = "estimated_price", precision = 12, scale = 2)
    private BigDecimal estimatedPrice;

    @Column(nullable = false)
    private boolean selected;

    protected ShoppingPlanItem() {
    }

    public ShoppingPlanItem(Long planId, Long ingredientId) {
        this(planId, ingredientId, BigDecimal.ONE, null, null);
    }

    public ShoppingPlanItem(Long planId, Long ingredientId, BigDecimal quantity, String unit, BigDecimal estimatedPrice) {
        this.planId = planId;
        this.ingredientId = ingredientId;
        this.quantity = quantity;
        this.unit = unit;
        this.estimatedPrice = estimatedPrice;
        this.selected = true;
    }

    public void setSelected(boolean selected) {
        this.selected = selected;
    }

    public Long getId() {
        return id;
    }

    public Long getPlanId() {
        return planId;
    }

    public Long getIngredientId() {
        return ingredientId;
    }

    public BigDecimal getQuantity() {
        return quantity;
    }

    public String getUnit() {
        return unit;
    }

    public BigDecimal getEstimatedPrice() {
        return estimatedPrice;
    }

    public boolean isSelected() {
        return selected;
    }
}

package com.seasonaldining.ingredient.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "ingredient_care_tips")
public class IngredientCareTip {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) private Long id;
    @Column(name = "ingredient_id", nullable = false) private Long ingredientId;
    @Column(name = "tip_order", nullable = false) private int tipOrder;
    @Column(nullable = false, length = 1000) private String content;
    protected IngredientCareTip() {}
    public IngredientCareTip(Long ingredientId, int tipOrder, String content) { this.ingredientId = ingredientId; this.tipOrder = tipOrder; this.content = content; }
    public int getTipOrder() { return tipOrder; }
    public String getContent() { return content; }
}

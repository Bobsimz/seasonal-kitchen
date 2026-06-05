package com.seasonaldining.recipe.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.math.BigDecimal;

@Entity
@Table(name = "recipe_ingredients")
public class RecipeIngredient {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "recipe_id", nullable = false)
    private Long recipeId;

    @Column(name = "ingredient_id", nullable = false)
    private Long ingredientId;

    @Column(precision = 12, scale = 2)
    private BigDecimal quantity;

    @Column(length = 30)
    private String unit;

    @Column(nullable = false)
    private boolean optional;

    protected RecipeIngredient() {
    }

    public RecipeIngredient(Long recipeId, Long ingredientId, BigDecimal quantity, String unit, boolean optional) {
        this.recipeId = recipeId;
        this.ingredientId = ingredientId;
        this.quantity = quantity;
        this.unit = unit;
        this.optional = optional;
    }

    public Long getId() {
        return id;
    }

    public Long getRecipeId() {
        return recipeId;
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

    public boolean isOptional() {
        return optional;
    }
}

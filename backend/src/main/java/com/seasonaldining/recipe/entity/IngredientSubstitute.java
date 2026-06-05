package com.seasonaldining.recipe.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "ingredient_substitutes")
public class IngredientSubstitute {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "ingredient_id", nullable = false)
    private Long ingredientId;

    @Column(name = "substitute_ingredient_id", nullable = false)
    private Long substituteIngredientId;

    @Column(nullable = false)
    private int score;

    @Column(length = 500)
    private String reason;

    protected IngredientSubstitute() {
    }

    public IngredientSubstitute(Long ingredientId, Long substituteIngredientId, int score, String reason) {
        this.ingredientId = ingredientId;
        this.substituteIngredientId = substituteIngredientId;
        this.score = score;
        this.reason = reason;
    }

    public Long getId() {
        return id;
    }

    public Long getIngredientId() {
        return ingredientId;
    }

    public Long getSubstituteIngredientId() {
        return substituteIngredientId;
    }

    public int getScore() {
        return score;
    }

    public String getReason() {
        return reason;
    }
}

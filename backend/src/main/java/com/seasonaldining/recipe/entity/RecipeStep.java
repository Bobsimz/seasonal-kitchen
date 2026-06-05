package com.seasonaldining.recipe.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "recipe_steps")
public class RecipeStep {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "recipe_id", nullable = false)
    private Long recipeId;

    @Column(name = "step_number", nullable = false)
    private int stepNumber;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String description;

    private Integer minutes;

    @Column(name = "image_url", length = 500)
    private String imageUrl;

    protected RecipeStep() {
    }

    public RecipeStep(Long recipeId, int stepNumber, String description, Integer minutes, String imageUrl) {
        this.recipeId = recipeId;
        this.stepNumber = stepNumber;
        this.description = description;
        this.minutes = minutes;
        this.imageUrl = imageUrl;
    }

    public Long getId() {
        return id;
    }

    public Long getRecipeId() {
        return recipeId;
    }

    public int getStepNumber() {
        return stepNumber;
    }

    public String getDescription() {
        return description;
    }

    public Integer getMinutes() {
        return minutes;
    }

    public String getImageUrl() {
        return imageUrl;
    }
}

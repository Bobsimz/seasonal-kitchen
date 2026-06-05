package com.seasonaldining.recipe.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "recipes")
public class Recipe {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 200)
    private String title;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "image_url", length = 500)
    private String imageUrl;

    @Column(nullable = false, length = 50)
    private String difficulty;

    @Column(nullable = false)
    private int minutes;

    @Column(nullable = false)
    private int servings;

    @Column(nullable = false, length = 50)
    private String status;

    protected Recipe() {
    }

    public Recipe(
            String title,
            String description,
            String imageUrl,
            String difficulty,
            int minutes,
            int servings,
            String status
    ) {
        this.title = title;
        this.description = description;
        this.imageUrl = imageUrl;
        this.difficulty = difficulty;
        this.minutes = minutes;
        this.servings = servings;
        this.status = status;
    }

    public Long getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public String getDescription() {
        return description;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public String getDifficulty() {
        return difficulty;
    }

    public int getMinutes() {
        return minutes;
    }

    public int getServings() {
        return servings;
    }

    public String getStatus() {
        return status;
    }
}

package com.seasonaldining.ingredient.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "ingredients")
public class Ingredient {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(nullable = false, length = 50)
    private String category;

    @Column(name = "image_url", length = 500)
    private String imageUrl;

    @Column(name = "base_unit", nullable = false, length = 30)
    private String baseUnit;

    @Column(nullable = false)
    private boolean active;

    protected Ingredient() {
    }

    public Ingredient(String name, String category, String imageUrl, String baseUnit, boolean active) {
        this.name = name;
        this.category = category;
        this.imageUrl = imageUrl;
        this.baseUnit = baseUnit;
        this.active = active;
    }

    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getCategory() {
        return category;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public String getBaseUnit() {
        return baseUnit;
    }

    public boolean isActive() {
        return active;
    }
}

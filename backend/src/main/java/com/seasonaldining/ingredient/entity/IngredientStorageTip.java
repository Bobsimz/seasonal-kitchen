package com.seasonaldining.ingredient.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "ingredient_storage_tips")
public class IngredientStorageTip {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) private Long id;
    @Column(name = "ingredient_id", nullable = false) private Long ingredientId;
    @Column(name = "storage_type", nullable = false, length = 50) private String storageType;
    @Column(nullable = false, length = 1000) private String description;
    @Column(length = 50) private String icon;
    protected IngredientStorageTip() {}
    public IngredientStorageTip(Long ingredientId, String storageType, String description, String icon) { this.ingredientId = ingredientId; this.storageType = storageType; this.description = description; this.icon = icon; }
    public String getStorageType() { return storageType; }
    public String getDescription() { return description; }
    public String getIcon() { return icon; }
}

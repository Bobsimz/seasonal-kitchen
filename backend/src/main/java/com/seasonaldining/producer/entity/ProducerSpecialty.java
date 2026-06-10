package com.seasonaldining.producer.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "producer_specialties")
public class ProducerSpecialty {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "producer_id", nullable = false)
    private Long producerId;
    @Column(name = "ingredient_name", nullable = false, length = 50)
    private String ingredientName;
    @Column(name = "ingredient_id")
    private Long ingredientId;

    protected ProducerSpecialty() {}

    public static ProducerSpecialty of(Long producerId, String ingredientName, Long ingredientId) {
        ProducerSpecialty s = new ProducerSpecialty();
        s.producerId = producerId;
        s.ingredientName = ingredientName;
        s.ingredientId = ingredientId;
        return s;
    }

    public Long getId() { return id; }
    public Long getProducerId() { return producerId; }
    public String getIngredientName() { return ingredientName; }
    public Long getIngredientId() { return ingredientId; }
}

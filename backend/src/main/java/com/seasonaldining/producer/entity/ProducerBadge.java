package com.seasonaldining.producer.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "producer_badges")
public class ProducerBadge {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "producer_id", nullable = false)
    private Long producerId;
    @Column(nullable = false, length = 50)
    private String label;

    protected ProducerBadge() {}

    public Long getId() { return id; }
    public Long getProducerId() { return producerId; }
    public String getLabel() { return label; }
}

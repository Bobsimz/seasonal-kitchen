package com.seasonaldining.producer.entity;

import jakarta.persistence.*;
import java.time.OffsetDateTime;

@Entity
@Table(name = "producer_reviews")
public class ProducerReview {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "producer_id", nullable = false)
    private Long producerId;
    @Column(name = "user_id", nullable = false)
    private Long userId;
    @Column(name = "author_name", length = 50)
    private String authorName;
    @Column(nullable = false)
    private int rating;
    @Column(length = 50)
    private String item;
    @Column(nullable = false, length = 2000)
    private String body;
    @Column(name = "created_at", nullable = false)
    private OffsetDateTime createdAt = OffsetDateTime.now();

    protected ProducerReview() {}

    public ProducerReview(Long producerId, Long userId, int rating, String item, String body) {
        this.producerId = producerId;
        this.userId = userId;
        this.rating = rating;
        this.item = item;
        this.body = body;
        this.createdAt = OffsetDateTime.now();
    }

    public Long getId() { return id; }
    public Long getProducerId() { return producerId; }
    public Long getUserId() { return userId; }
    public String getAuthorName() { return authorName; }
    public int getRating() { return rating; }
    public String getItem() { return item; }
    public String getBody() { return body; }
    public OffsetDateTime getCreatedAt() { return createdAt; }
}

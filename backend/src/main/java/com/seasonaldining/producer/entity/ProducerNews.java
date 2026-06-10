package com.seasonaldining.producer.entity;

import jakarta.persistence.*;
import java.time.OffsetDateTime;

@Entity
@Table(name = "producer_news")
public class ProducerNews {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "producer_id", nullable = false)
    private Long producerId;
    @Column(name = "posted_at", nullable = false)
    private OffsetDateTime postedAt;
    @Column(nullable = false, length = 200)
    private String title;
    @Column(name = "image_ref", length = 100)
    private String imageRef;
    @Column(nullable = false, length = 2000)
    private String body;

    protected ProducerNews() {}

    public Long getId() { return id; }
    public Long getProducerId() { return producerId; }
    public OffsetDateTime getPostedAt() { return postedAt; }
    public String getTitle() { return title; }
    public String getImageRef() { return imageRef; }
    public String getBody() { return body; }
}

package com.seasonaldining.notification.entity;

import jakarta.persistence.*;
import java.time.OffsetDateTime;

@Entity
@Table(name = "notifications")
public class Notification {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) private Long id;
    @Column(name = "user_id", nullable = false) private Long userId;
    @Column(nullable = false, length = 50) private String type;
    @Column(nullable = false, length = 200) private String title;
    @Column(nullable = false) private String body;
    @Column(name = "read_at") private OffsetDateTime readAt;
    @Column(name = "created_at", nullable = false, insertable = false, updatable = false) private OffsetDateTime createdAt;

    protected Notification() {}

    public Notification(Long userId, String type, String title, String body) {
        this.userId = userId;
        this.type = type;
        this.title = title;
        this.body = body;
    }

    public void markRead() {
        if (readAt == null) readAt = OffsetDateTime.now();
    }

    public Long getId() { return id; }
    public Long getUserId() { return userId; }
    public String getType() { return type; }
    public String getTitle() { return title; }
    public String getBody() { return body; }
    public OffsetDateTime getReadAt() { return readAt; }
    public OffsetDateTime getCreatedAt() { return createdAt; }
}

package com.seasonaldining.reel.entity;

import jakarta.persistence.*;
import java.time.OffsetDateTime;

@Entity
@Table(name = "reel_comments")
public class ReelComment {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) private Long id;
    @Column(name = "reel_id", nullable = false) private Long reelId;
    @Column(name = "user_id", nullable = false) private Long userId;
    @Column(nullable = false, length = 1000) private String content;
    @Column(nullable = false, length = 50) private String status;
    @Column(name = "created_at", nullable = false, insertable = false, updatable = false) private OffsetDateTime createdAt;
    protected ReelComment() {}
    public ReelComment(Long reelId, Long userId, String content, String status) {
        this.reelId = reelId; this.userId = userId; this.content = content; this.status = status;
    }
    public Long getId() { return id; }
    public Long getReelId() { return reelId; }
    public Long getUserId() { return userId; }
    public String getContent() { return content; }
    public String getStatus() { return status; }
    public OffsetDateTime getCreatedAt() { return createdAt; }
}

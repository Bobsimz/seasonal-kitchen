package com.seasonaldining.reel.entity;

import jakarta.persistence.*;
import java.time.OffsetDateTime;

@Entity
@Table(name = "reels")
public class Reel {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) private Long id;
    @Column(name = "recipe_id") private Long recipeId;
    @Column(name = "creator_id", nullable = false) private Long creatorId;
    @Column(nullable = false, length = 200) private String title;
    @Column private String description;
    @Column(name = "video_url", nullable = false, length = 500) private String videoUrl;
    @Column(name = "thumbnail_url", nullable = false, length = 500) private String thumbnailUrl;
    @Column(name = "ingredient_tags", length = 500) private String ingredientTags;
    @Column(name = "duration_seconds") private Integer durationSeconds;
    @Column(nullable = false, length = 50) private String status;
    @Column(name = "published_at") private OffsetDateTime publishedAt;
    @Column(name = "view_count", nullable = false) private long viewCount;
    @Column(name = "like_count", nullable = false) private long likeCount;
    @Column(name = "comment_count", nullable = false) private long commentCount;
    @Column(name = "save_count", nullable = false) private long saveCount;
    protected Reel() {}
    public Reel(Long recipeId, Long creatorId, String title, String description, String videoUrl, String thumbnailUrl, String ingredientTags, Integer durationSeconds, String status, OffsetDateTime publishedAt) {
        this.recipeId = recipeId; this.creatorId = creatorId; this.title = title; this.description = description; this.videoUrl = videoUrl; this.thumbnailUrl = thumbnailUrl; this.ingredientTags = ingredientTags; this.durationSeconds = durationSeconds; this.status = status; this.publishedAt = publishedAt;
    }
    public void incrementViewCount() { this.viewCount++; }
    public Long getId() { return id; }
    public Long getRecipeId() { return recipeId; }
    public Long getCreatorId() { return creatorId; }
    public String getTitle() { return title; }
    public String getDescription() { return description; }
    public String getVideoUrl() { return videoUrl; }
    public String getThumbnailUrl() { return thumbnailUrl; }
    public String getIngredientTags() { return ingredientTags; }
    public Integer getDurationSeconds() { return durationSeconds; }
    public String getStatus() { return status; }
    public OffsetDateTime getPublishedAt() { return publishedAt; }
    public long getViewCount() { return viewCount; }
    public long getLikeCount() { return likeCount; }
    public long getCommentCount() { return commentCount; }
    public long getSaveCount() { return saveCount; }
}

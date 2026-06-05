package com.seasonaldining.analytics.entity;

import jakarta.persistence.*;
import java.time.OffsetDateTime;

@Entity
@Table(name = "user_events")
public class UserEvent {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) private Long id;
    @Column(name = "user_id") private Long userId;
    @Column(name = "event_type", nullable = false, length = 100) private String eventType;
    @Column(name = "target_type", length = 50) private String targetType;
    @Column(name = "target_id") private Long targetId;
    @Column(name = "metadata_json") private String metadataJson;
    @Column(name = "created_at", nullable = false, insertable = false, updatable = false) private OffsetDateTime createdAt;

    protected UserEvent() {}

    public UserEvent(Long userId, String eventType, String targetType, Long targetId, String metadataJson) {
        this.userId = userId;
        this.eventType = eventType;
        this.targetType = targetType;
        this.targetId = targetId;
        this.metadataJson = metadataJson;
    }

    public Long getId() { return id; }
    public Long getUserId() { return userId; }
    public String getEventType() { return eventType; }
    public String getTargetType() { return targetType; }
    public Long getTargetId() { return targetId; }
    public String getMetadataJson() { return metadataJson; }
    public OffsetDateTime getCreatedAt() { return createdAt; }
}

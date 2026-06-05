package com.seasonaldining.common.event;

import jakarta.persistence.*;
import java.time.OffsetDateTime;

@Entity
@Table(name = "outbox_events")
public class OutboxEvent {
    public static final String STATUS_PENDING = "PENDING";
    public static final String STATUS_PROCESSED = "PROCESSED";

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) private Long id;
    @Column(name = "event_type", nullable = false, length = 100) private String eventType;
    @Column(name = "payload_json", nullable = false) private String payloadJson;
    @Column(nullable = false, length = 50) private String status;
    @Column(name = "created_at", nullable = false, insertable = false, updatable = false) private OffsetDateTime createdAt;
    @Column(name = "processed_at") private OffsetDateTime processedAt;

    protected OutboxEvent() {}

    public OutboxEvent(String eventType, String payloadJson) {
        this.eventType = eventType;
        this.payloadJson = payloadJson;
        this.status = STATUS_PENDING;
    }

    public void markProcessed() {
        this.status = STATUS_PROCESSED;
        this.processedAt = OffsetDateTime.now();
    }

    public Long getId() { return id; }
    public String getEventType() { return eventType; }
    public String getPayloadJson() { return payloadJson; }
    public String getStatus() { return status; }
    public OffsetDateTime getCreatedAt() { return createdAt; }
    public OffsetDateTime getProcessedAt() { return processedAt; }
}

package com.seasonaldining.notification.service;

import com.seasonaldining.common.exception.BusinessException;
import com.seasonaldining.common.exception.ErrorCode;
import com.seasonaldining.notification.dto.response.NotificationListResponse;
import com.seasonaldining.notification.dto.response.NotificationResponse;
import com.seasonaldining.notification.entity.Notification;
import com.seasonaldining.notification.repository.NotificationRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.Duration;
import java.time.OffsetDateTime;
import java.util.List;

@Service
public class NotificationService {
    private final NotificationRepository repository;

    public NotificationService(NotificationRepository repository) {
        this.repository = repository;
    }

    @Transactional(readOnly = true)
    public NotificationListResponse getNotifications(Long userId) {
        List<NotificationResponse> items = repository.findByUserIdOrderByIdDesc(userId).stream()
                .map(this::toResponse)
                .toList();
        long price = items.stream().filter(item -> "PRICE".equals(item.type())).count();
        long order = items.stream().filter(item -> "ORDER".equals(item.type())).count();
        long community = items.stream().filter(item -> "COMMUNITY".equals(item.type())).count();
        return new NotificationListResponse(
                items,
                new NotificationListResponse.TabCountsResponse(items.size(), price, order, community)
        );
    }

    @Transactional
    public NotificationResponse markRead(Long userId, Long notificationId) {
        Notification notification = findOwned(notificationId, userId);
        notification.markRead();
        return toResponse(notification);
    }

    @Transactional
    public void markAllRead(Long userId) {
        repository.findByUserIdAndReadAtIsNull(userId).forEach(Notification::markRead);
    }

    private Notification findOwned(Long id, Long userId) {
        return repository.findByIdAndUserId(id, userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.NOTIFICATION_NOT_FOUND));
    }

    private NotificationResponse toResponse(Notification notification) {
        String bucket = bucket(notification.getType());
        return new NotificationResponse(
                notification.getId(),
                bucket,
                notification.getType(),
                bucket,
                notification.getTitle(),
                notification.getBody(),
                notification.getBody(),
                bucket.toLowerCase(),
                severity(notification.getType()),
                notification.getReadAt() != null,
                notification.getReadAt(),
                notification.getCreatedAt(),
                relativeTime(notification.getCreatedAt()),
                bucket,
                null
        );
    }

    /**
     * 원본 알림 유형 → FE 화면 버킷(PRICE/ORDER/COMMUNITY).
     * PRICE_DROP/SEASON_START → PRICE, ORDER_* → ORDER, 그 외(레시피/AI/프로모션/커뮤니티) → COMMUNITY.
     */
    private String bucket(String type) {
        if (type == null) {
            return "COMMUNITY";
        }
        if ("PRICE_DROP".equals(type) || "SEASON_START".equals(type)) {
            return "PRICE";
        }
        if (type.startsWith("ORDER")) {
            return "ORDER";
        }
        return "COMMUNITY";
    }

    private String severity(String type) {
        return "PRICE_DROP".equals(type) ? "SUCCESS" : "INFO";
    }

    private String relativeTime(OffsetDateTime createdAt) {
        if (createdAt == null) {
            return "방금 전";
        }
        long minutes = Duration.between(createdAt, OffsetDateTime.now()).toMinutes();
        if (minutes < 1) {
            return "방금 전";
        }
        if (minutes < 60) {
            return minutes + "분 전";
        }
        long hours = minutes / 60;
        if (hours < 24) {
            return hours + "시간 전";
        }
        return (hours / 24) + "일 전";
    }
}

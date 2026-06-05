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
        long recipeCount = items.stream().filter(item -> "RECIPE".equals(item.category())).count();
        long ingredientCount = items.stream().filter(item -> "INGREDIENT".equals(item.category())).count();
        return new NotificationListResponse(
                items,
                new NotificationListResponse.TabCountsResponse(items.size(), recipeCount, ingredientCount)
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
        String category = category(notification.getType());
        return new NotificationResponse(
                notification.getId(),
                notification.getType(),
                category,
                notification.getTitle(),
                notification.getBody(),
                notification.getBody(),
                icon(notification.getType()),
                severity(notification.getType()),
                notification.getReadAt(),
                notification.getCreatedAt(),
                relativeTime(notification.getCreatedAt()),
                category,
                null
        );
    }

    private String category(String type) {
        if (type != null && type.startsWith("RECIPE")) {
            return "RECIPE";
        }
        if ("AI_RESULT".equals(type)) {
            return "RECIPE";
        }
        return "INGREDIENT";
    }

    private String icon(String type) {
        return switch (type) {
            case "PRICE_DROP" -> "price-down";
            case "SEASON_START" -> "season";
            case "RECIPE_RECOMMENDATION" -> "recipe";
            case "AI_RESULT" -> "sparkles";
            case "PROMOTION" -> "tag";
            default -> "bell";
        };
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

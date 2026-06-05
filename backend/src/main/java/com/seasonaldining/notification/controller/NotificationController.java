package com.seasonaldining.notification.controller;

import com.seasonaldining.common.response.ApiResponse;
import com.seasonaldining.common.security.CurrentUserProvider;
import com.seasonaldining.notification.dto.response.NotificationListResponse;
import com.seasonaldining.notification.dto.response.NotificationResponse;
import com.seasonaldining.notification.service.NotificationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/notifications")
@Tag(name = "13. Notifications", description = "앱 내 알림 API")
public class NotificationController {
    private final NotificationService service;
    private final CurrentUserProvider currentUserProvider;

    public NotificationController(NotificationService service, CurrentUserProvider currentUserProvider) {
        this.service = service;
        this.currentUserProvider = currentUserProvider;
    }

    @GetMapping
    @Operation(summary = "내 알림 조회", description = "알림 화면 렌더링을 위한 items와 탭 카운트를 반환합니다.")
    public ApiResponse<NotificationListResponse> getNotifications() {
        return ApiResponse.success(service.getNotifications(currentUserProvider.getCurrentUserId()), null);
    }

    @PatchMapping("/{notificationId}/read")
    @Operation(summary = "알림 읽음 처리")
    public ApiResponse<NotificationResponse> markRead(@PathVariable Long notificationId) {
        return ApiResponse.success(service.markRead(currentUserProvider.getCurrentUserId(), notificationId), null);
    }

    @PatchMapping("/read-all")
    @Operation(summary = "모든 알림 읽음 처리")
    public ApiResponse<Void> markAllRead() {
        service.markAllRead(currentUserProvider.getCurrentUserId());
        return ApiResponse.success(null, null);
    }
}

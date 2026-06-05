package com.seasonaldining.notification.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import java.time.OffsetDateTime;

public record NotificationResponse(
        @Schema(description = "알림 ID", example = "1") Long id,
        @Schema(description = "알림 유형", example = "PRICE_DROP") String type,
        @Schema(description = "화면 탭 카테고리", example = "INGREDIENT") String category,
        @Schema(description = "제목", example = "가격이 내려갔습니다") String title,
        @Schema(description = "내용", example = "무 가격이 설정 가격 이하로 내려갔습니다.") String body,
        @Schema(description = "부제목", example = "무 가격이 설정 가격 이하로 내려갔습니다.") String subtitle,
        @Schema(description = "아이콘 키", example = "price-down") String icon,
        @Schema(description = "중요도", example = "INFO") String severity,
        @Schema(description = "읽은 시각", nullable = true) OffsetDateTime readAt,
        @Schema(description = "생성 시각") OffsetDateTime createdAt,
        @Schema(description = "상대 시간 라벨", example = "방금 전") String relativeTime,
        @Schema(description = "액션 대상 유형", nullable = true, example = "INGREDIENT") String actionTargetType,
        @Schema(description = "액션 대상 ID", nullable = true, example = "1") Long actionTargetId
) {}

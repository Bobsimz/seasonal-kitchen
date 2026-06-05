package com.seasonaldining.notification.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

import java.util.List;

@Schema(description = "알림 화면 목록 응답")
public record NotificationListResponse(
        List<NotificationResponse> items,
        TabCountsResponse tabCounts
) {

    public record TabCountsResponse(
            @Schema(example = "3") long total,
            @Schema(example = "1") long recipe,
            @Schema(example = "2") long ingredient
    ) {
    }
}

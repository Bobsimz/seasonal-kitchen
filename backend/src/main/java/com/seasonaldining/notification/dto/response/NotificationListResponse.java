package com.seasonaldining.notification.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import io.swagger.v3.oas.annotations.media.Schema;

import java.util.List;

@Schema(description = "알림 화면 목록 응답")
public record NotificationListResponse(
        List<NotificationResponse> items,
        TabCountsResponse tabCounts
) {

    /**
     * 탭별 카운트 — FE 알림 탭은 키 ALL/PRICE/ORDER/COMMUNITY 로 읽는다(대문자).
     * counts[tab.value] 접근이므로 JSON 키가 대문자여야 한다(@JsonProperty).
     */
    @Schema(description = "탭별 카운트 — 키 ALL/PRICE/ORDER/COMMUNITY")
    public record TabCountsResponse(
            @JsonProperty("ALL") @Schema(example = "4") long all,
            @JsonProperty("PRICE") @Schema(example = "2") long price,
            @JsonProperty("ORDER") @Schema(example = "1") long order,
            @JsonProperty("COMMUNITY") @Schema(example = "1") long community
    ) {
    }
}

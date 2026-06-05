package com.seasonaldining.analytics.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import java.time.OffsetDateTime;

public record UserEventResponse(
        @Schema(description = "이벤트 ID", example = "1") Long id,
        @Schema(description = "이벤트 유형", example = "INGREDIENT_VIEW") String eventType,
        @Schema(description = "대상 유형", example = "INGREDIENT", nullable = true) String targetType,
        @Schema(description = "대상 ID", example = "1", nullable = true) Long targetId,
        @Schema(description = "생성 시각") OffsetDateTime createdAt
) {}

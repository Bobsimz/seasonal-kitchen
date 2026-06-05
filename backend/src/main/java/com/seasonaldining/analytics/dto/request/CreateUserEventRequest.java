package com.seasonaldining.analytics.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;

public record CreateUserEventRequest(
        @NotBlank
        @Size(max = 100)
        @Schema(description = "이벤트 유형", example = "INGREDIENT_VIEW")
        String eventType,

        @Size(max = 50)
        @Schema(description = "대상 유형", example = "INGREDIENT", nullable = true)
        String targetType,

        @Positive
        @Schema(description = "대상 ID", example = "1", nullable = true)
        Long targetId,

        @Size(max = 2000)
        @Schema(description = "JSON 문자열 메타데이터", example = "{\"source\":\"home\"}", nullable = true)
        String metadataJson
) {}

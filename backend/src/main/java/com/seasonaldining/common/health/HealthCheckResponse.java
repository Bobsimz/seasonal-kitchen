package com.seasonaldining.common.health;

import io.swagger.v3.oas.annotations.media.Schema;

import java.time.OffsetDateTime;

public record HealthCheckResponse(
        @Schema(example = "UP")
        String status,
        @Schema(example = "2026-06-01T00:00:00Z")
        OffsetDateTime timestamp
) {
}


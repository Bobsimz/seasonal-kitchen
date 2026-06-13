package com.seasonaldining.reel.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

public record ReelSaveActionResponse(
        @Schema(description = "릴스 ID", example = "1") Long reelId,
        @Schema(description = "저장(찜) 여부", example = "true") boolean saved,
        @Schema(description = "저장 수", example = "30") long saveCount
) {}

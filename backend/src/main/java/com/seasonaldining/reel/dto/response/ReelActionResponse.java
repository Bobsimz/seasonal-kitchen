package com.seasonaldining.reel.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

public record ReelActionResponse(
        @Schema(description = "릴스 ID", example = "1") Long reelId,
        @Schema(description = "좋아요 여부", example = "true") boolean liked,
        @Schema(description = "좋아요 수", example = "1") long likeCount
) {}

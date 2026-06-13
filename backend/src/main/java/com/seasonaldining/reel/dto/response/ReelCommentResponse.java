package com.seasonaldining.reel.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import java.time.OffsetDateTime;

public record ReelCommentResponse(
        @Schema(description = "댓글 ID", example = "1") Long id,
        @Schema(description = "릴스 ID", example = "1") Long reelId,
        @Schema(description = "작성자 ID", example = "1") Long userId,
        @Schema(description = "작성자 닉네임", example = "제철러버") String nickname,
        @Schema(description = "작성자 프로필 이미지 URL", nullable = true) String profileImageUrl,
        @Schema(description = "댓글 내용", example = "맛있어 보여요") String content,
        @Schema(description = "생성 시각") OffsetDateTime createdAt
) {}

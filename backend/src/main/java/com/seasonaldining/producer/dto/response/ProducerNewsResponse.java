package com.seasonaldining.producer.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import java.time.OffsetDateTime;

@Schema(description = "농가 스토어 소식 응답")
public record ProducerNewsResponse(
        @Schema(description = "소식 ID", example = "200") Long id,
        @Schema(description = "게시 시각(ISO 8601)") OffsetDateTime postedAt,
        @Schema(description = "게시일(yyyy.MM.dd) — 프론트 표시용", example = "2026.05.28") String date,
        @Schema(description = "제목", example = "제철 봄동 5월 산지 소식입니다~") String title,
        @Schema(description = "이미지 URL(실제 URL이면 그대로, 키워드/photo 등이면 null)", example = "https://cdn/news.png", nullable = true) String imageUrl,
        @Schema(description = "본문") String body
) {}

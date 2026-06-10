package com.seasonaldining.producer.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import java.time.OffsetDateTime;

@Schema(description = "농가 스토어 소식 응답")
public record ProducerNewsResponse(
        @Schema(description = "소식 ID", example = "200") Long id,
        @Schema(description = "게시 시각(ISO 8601)") OffsetDateTime postedAt,
        @Schema(description = "제목", example = "제철 봄동 5월 산지 소식입니다~") String title,
        @Schema(description = "이미지 참조(식재료명 또는 photo)", example = "봄동") String imageRef,
        @Schema(description = "본문") String body
) {}

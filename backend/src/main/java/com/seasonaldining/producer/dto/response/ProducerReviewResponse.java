package com.seasonaldining.producer.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import java.time.OffsetDateTime;

@Schema(description = "농가 리뷰 응답")
public record ProducerReviewResponse(
        @Schema(description = "리뷰 ID", example = "100") Long id,
        @Schema(description = "작성자", example = "민지") String author,
        @Schema(description = "별점(1~5)", example = "5") int rating,
        @Schema(description = "구매 식재료", example = "봄동") String item,
        @Schema(description = "내용") String body,
        @Schema(description = "작성 시각(ISO 8601)") OffsetDateTime createdAt
) {}

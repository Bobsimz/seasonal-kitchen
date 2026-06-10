package com.seasonaldining.review.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import java.time.OffsetDateTime;

@Schema(description = "내 리뷰 응답 — 작성한/작성가능 공용. writable 항목은 reviewId/rating/body가 null이다.")
public record MyReviewResponse(
        @Schema(description = "리뷰 ID(작성한 경우)", nullable = true) Long reviewId,
        @Schema(description = "농가 ID") Long producerId,
        @Schema(description = "농가 이름") String producerName,
        @Schema(description = "식재료명") String item,
        @Schema(description = "별점(작성한 경우)", nullable = true) Integer rating,
        @Schema(description = "내용(작성한 경우)", nullable = true) String body,
        @Schema(description = "작성/배송 시각") OffsetDateTime date
) {}

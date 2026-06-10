package com.seasonaldining.producer.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

@Schema(description = "농가 리뷰 작성 요청")
public record CreateProducerReviewRequest(
        @Schema(description = "별점(1~5)", example = "5")
        @Min(1) @Max(5) int rating,
        @Schema(description = "구매 식재료", example = "봄동")
        @Size(max = 50) String item,
        @Schema(description = "리뷰 내용", example = "정말 싱싱해요. 재구매 의사 100%입니다!")
        @NotBlank @Size(max = 2000) String body
) {}

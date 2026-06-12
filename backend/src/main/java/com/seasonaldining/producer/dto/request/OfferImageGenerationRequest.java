package com.seasonaldining.producer.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;

import java.util.List;

@Schema(description = "상품 추가 이미지 생성 요청")
public record OfferImageGenerationRequest(
        @Schema(description = "식재료명", example = "무", requiredMode = Schema.RequiredMode.REQUIRED)
        String ingredientName,

        @Schema(description = "품종·산지를 포함한 상품명", example = "해남 무")
        String productName,

        @Schema(description = "카테고리", example = "뿌리채소")
        String category,

        @Schema(description = "소구포인트 키워드 목록 (checkpoints.keyword)", example = "[\"아삭함\", \"당도\", \"신선도\"]")
        List<String> keywords
) {}

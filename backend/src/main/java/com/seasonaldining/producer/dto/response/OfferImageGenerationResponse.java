package com.seasonaldining.producer.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "상품 추가 이미지 생성 결과")
public record OfferImageGenerationResponse(
        @Schema(description = "생성된 이미지 MIME 타입", example = "image/png")
        String mimeType,

        @Schema(description = "생성된 이미지 Base64 인코딩 데이터")
        String imageData
) {}

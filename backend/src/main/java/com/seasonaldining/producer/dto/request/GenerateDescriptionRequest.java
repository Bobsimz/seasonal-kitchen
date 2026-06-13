package com.seasonaldining.producer.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Size;

import java.util.List;

@Schema(description = "소구문장 생성 요청")
public record GenerateDescriptionRequest(
        @Schema(description = "식재료명", example = "봄동")
        @NotBlank @Size(max = 50) String ingredientName,

        @Schema(description = "농가명", example = "해남 송지농원")
        @NotBlank @Size(max = 100) String producerName,

        @Schema(description = "선택된 소구 키워드 목록 (1~3개)", example = "[\"아삭함\", \"당도\"]")
        @NotEmpty @Size(max = 3) List<@NotBlank @Size(max = 40) String> keywords
) {}

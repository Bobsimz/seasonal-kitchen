package com.seasonaldining.producer.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "소구문장 생성 결과")
public record GenerateDescriptionResponse(
        @Schema(description = "생성된 소구문장", example = "해남 송지농원에서 직접 키운 봄동, 갓 수확한 아삭한 식감과 달콤한 당도가 살아있습니다.")
        String description
) {}

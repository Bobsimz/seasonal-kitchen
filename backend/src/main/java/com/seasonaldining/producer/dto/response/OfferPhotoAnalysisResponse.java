package com.seasonaldining.producer.dto.response;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.v3.oas.annotations.media.Schema;

import java.util.List;

@JsonInclude(JsonInclude.Include.NON_NULL)
@Schema(description = "상품 사진 AI 분석 결과")
public record OfferPhotoAnalysisResponse(
        @Schema(description = "감지된 식재료명", example = "무", nullable = true)
        String ingredientName,

        @Schema(description = "품종을 포함한 상품명", example = "해남 무", nullable = true)
        String productName,

        @Schema(description = "카테고리", example = "뿌리채소", nullable = true)
        String category,

        @Schema(description = "보관 방법", example = "냉장 보관", nullable = true,
                allowableValues = {"냉장 보관", "냉동 보관", "실온 보관", "서늘한 그늘"})
        String storageMethod,

        @Schema(description = "보관 팁 (2문장)", example = "신문지에 싸서 냉장 보관하면 2주까지 신선해요. 흙은 털지 말고 보관하세요.", nullable = true)
        String storageTip,

        @Schema(description = "상품 소구포인트 3개", nullable = true)
        List<Checkpoint> checkpoints,

        @Schema(description = "이렇게 드세요! 추천 레시피", nullable = true)
        Recipe recipe
) {
    @Schema(description = "소구포인트 항목")
    public record Checkpoint(
            @Schema(description = "핵심 키워드 (단어 1개)", example = "아삭함")
            String keyword,

            @Schema(description = "소구 문장 (1문장)", example = "갓 수확한 아삭한 식감이 그대로 살아있어요.")
            String sentence
    ) {}

    @Schema(description = "추천 레시피")
    public record Recipe(
            @Schema(description = "레시피 제목", example = "봄동 겉절이")
            String title,

            @Schema(description = "조리 단계 (3~4 문장)", example = "[\"봄동을 씻어 물기를 제거합니다.\", \"양념장을 만들어 버무립니다.\"]")
            List<String> steps
    ) {}
}

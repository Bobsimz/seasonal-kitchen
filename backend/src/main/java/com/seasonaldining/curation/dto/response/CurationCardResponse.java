package com.seasonaldining.curation.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

/** 홈 히어로용 큐레이션 카드 — 메인 이미지/타이틀/서브타이틀만. 탭하면 /curation/{id} 로 이동. */
public record CurationCardResponse(
        @Schema(description = "큐레이션 ID", example = "1")
        Long id,

        @Schema(description = "메인 이미지 URL", nullable = true)
        String imageUrl,

        @Schema(description = "메인 타이틀", example = "봄동, 봄을 가장 먼저 알리는 채소")
        String title,

        @Schema(description = "서브타이틀", example = "겨우내 단맛을 머금은 봄의 첫 잎채소", nullable = true)
        String subtitle
) {
}

package com.seasonaldining.favorite.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

/**
 * 찜 응답. 기존 식별 필드(id/targetType/targetId)에 더해 찜 목록 화면 표시용 대상 요약(title/imageUrl/subtitle)을 포함한다.
 * 대상이 삭제/비활성이면 요약 필드는 null일 수 있다(기존 식별 필드는 유지).
 */
public record FavoriteResponse(
        @Schema(description = "찜 ID", example = "1") Long id,
        @Schema(description = "찜 대상 유형", example = "INGREDIENT") String targetType,
        @Schema(description = "찜 대상 ID", example = "1") Long targetId,
        @Schema(description = "대상 표시 제목", example = "봄동", nullable = true) String title,
        @Schema(description = "대상 이미지 URL", nullable = true) String imageUrl,
        @Schema(description = "대상 보조 설명(카테고리/지역/가격 등)", example = "잎채소", nullable = true) String subtitle
) {}

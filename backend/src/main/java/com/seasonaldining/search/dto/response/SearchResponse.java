package com.seasonaldining.search.dto.response;
import io.swagger.v3.oas.annotations.media.Schema; import java.util.List;
public record SearchResponse(
 @Schema(description="전체 검색 결과. 기존 호환용 flat list") List<SearchItemResponse> items,
 @Schema(description="식재료 검색 결과") List<SearchItemResponse> ingredients,
 @Schema(description="레시피 검색 결과") List<SearchItemResponse> recipes,
 @Schema(description="릴스 검색 결과. 릴스 도메인 미구현 시 빈 배열") List<SearchItemResponse> reels,
 @Schema(description="식재료 결과 수",example="1") int ingredientCount,
 @Schema(description="레시피 결과 수",example="1") int recipeCount,
 @Schema(description="릴스 결과 수",example="0") int reelCount,
 @Schema(description="상품 검색 결과(type=PRODUCT일 때 채워짐. producer_offers facade)") List<SearchItemResponse> products,
 @Schema(description="상품 결과 수",example="0") int productCount
){}

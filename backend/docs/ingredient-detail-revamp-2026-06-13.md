# 식재료 상세 개편 — 백엔드 신규 요청 (2026-06-13)

프론트 `ingredients/{id}` 상세 화면을 개편하면서 **새로 필요한 백엔드**를 정리합니다.
형식·규칙(공통 래퍼 `ApiResponse`, `/api/v1` prefix, 에러코드 UPPER_SNAKE)은 `frontend-api-guide.md` 를 따릅니다.

## 화면 변경 요약 (참고)

- 제거: 가격 추이(`/ingredients/{id}/prices`), 영양 정보, 리테일 시세 비교(`/ingredients/{id}/offers`) 섹션 — **API는 유지, 화면에서만 미사용**
- 추가: **"상품 리스트"** 섹션 — 이 식재료의 농가 직거래 상품을 `/products` 카드(`ProductCardResponse`) 형태로 2열 그리드 노출
- 추가: **재철 식재료 찜 하트** — 상세 + 식재료 카드. 기존 favorites 재사용(아래 §2)
- 유지: "농가 직거래 보기" 하단 바

## 1. ✅ 신규 필요 — 식재료별 상품 목록

현재 `GET /api/v1/products`(§13) 필터는 `q·category·region·style·page·size` 뿐이라 **`ingredientId` 로 좁힐 수단이 없습니다.** "이 식재료의 상품"을 정확히 받으려면 아래가 필요합니다.

### (권장) `GET /api/v1/ingredients/{ingredientId}/products`

식재료 상세의 "상품 리스트" 섹션에 사용. `/ingredients/{id}/recipes`, `/ingredients/{id}/producers` 와 동일한 하위리소스 패턴. **인증 불필요.**

- 응답: `ProductCardResponse[]` (§13의 상품 카드와 동일 DTO)
- 정렬: **가격 오름차순**
- 필터: `status = ACTIVE`(숨김 offer 제외), 해당 `ingredientId` 의 offer만
- 비어 있으면 빈 배열 `[]`

```jsonc
// GET /api/v1/ingredients/12/products
// 응답 data: ProductCardResponse[]  (가격 오름차순)
{
  "success": true,
  "data": [
    {
      "id": 10,                          // = producer_offers.id (= 담기용 offerId)
      "name": "햇 봄동 1.5kg 산지직송",   // title, 없으면 ingredientName
      "ingredientId": 12,
      "ingredientName": "봄동",
      "producerId": 1,
      "producerName": "권민성",
      "region": "경북영천",
      "price": 4500,
      "unit": "봉",
      "imageUrl": "https://img/1.png",   // 첫 photoUrl, 없으면 null
      "stockStatus": "IN_STOCK",         // null→UNKNOWN, 0→SOLD_OUT, 1+→IN_STOCK
      "category": "잎채소"
    }
  ],
  "error": null,
  "traceId": null
}
```

- 미존재/비활성 식재료: `INGREDIENT_NOT_FOUND`(404) — `/ingredients/{id}` 와 동일 정책
- `ingredientId` 백필 전 offer(=`producer_offers.ingredient_id` null)는 제외됩니다.

### (대안) `GET /api/v1/products?ingredientId={id}`

새 라우트 대신 기존 상품 목록에 `ingredientId` 쿼리 파라미터만 추가하는 방법. 응답은 `ListResponse<ProductCardResponse>`. 프론트는 둘 중 무엇이든 대응 가능하나, **하위리소스 방식(권장)** 이 기존 식재료 API들과 일관됩니다.

### 구현 힌트

- `ProducerOfferRepository` 에 `ingredientId + status=ACTIVE` 조회(가격 오름차순) 추가
- `ProductService` 에 `getProductsByIngredient(ingredientId)` → 기존 `toCards(...)` 재사용(N+1 회피 그대로)
- 컨트롤러는 `IngredientProducerController` 옆에 추가하거나 `ProductController` 에 메서드 추가

## 2. ✅ 이미 존재 — 변경 불필요

| 기능 | 사용 API | 비고 |
| --- | --- | --- |
| 식재료 찜 하트 | `GET/POST /api/v1/favorites`, `DELETE /api/v1/favorites/{id}` | `targetType` 에 **`INGREDIENT`** 이미 지원(§7). 프론트는 `GET /favorites` 목록에서 `targetType=INGREDIENT && targetId` 매칭으로 현재 찜 여부 판정 |
| 상품 카드 DTO | `ProductCardResponse` | §13 그대로 재사용 |
| 농가 비교(하단 바 이동) | `GET /api/v1/ingredients/{id}/producers` | 유지 |

## 3. (선택) 개선 제안 — 필수 아님

`GET /api/v1/ingredients/{ingredientId}` 응답에 아래를 더하면 하트 초기 상태를 별도 `GET /favorites` 전체 조회 없이 그릴 수 있습니다. **현재는 프론트가 favorites 목록으로 처리하므로 없어도 동작합니다.**

```jsonc
// IngredientDetailResponse 에 추가(선택)
{
  "favorited": false,       // 로그인 사용자의 찜 여부 (비로그인 시 false)
  "favoriteCount": 128      // 누적 찜 수 — "N명이 찜했어요" 표기용
}
```

## 4. 프론트 임시 대응 (백엔드 전까지)

`lib/endpoints.js` 의 `getIngredientProducts(id)` 가 `GET /ingredients/{id}/products` 를 호출하고, 연결/오류 시 `lib/mock/data.js` 의 `ingredientProducts(id)`(producer offer 기반 상품 카드)로 폴백합니다. **위 §1 엔드포인트가 생기면 프론트 수정 없이 그대로 전환**됩니다.

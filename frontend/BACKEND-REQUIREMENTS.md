# 백엔드 추가 개발 요청서 (프론트 연동 기준)

> 프론트엔드를 "동작하는 웹앱"으로 구현하면서, **현재 API로는 채울 수 없거나 임시 대응한 부분**을 정리했습니다.
> 기준 문서: `backend/docs/frontend-api-guide.md` (canonical). 프론트는 백엔드가 없을 때 mock 데이터로 폴백하도록 만들어 두었으니, 아래 API가 준비되면 폴백 없이 그대로 붙습니다.
>
> 우선순위: **P0** 핵심 커머스 동선 / **P1** 사용성·완성도 / **P2** 고도화.

---

## 1. 전용 상품(Product) 도메인 — P0

현재 "상품 탭/상품 상세"는 `GET /producers` + `GET /producers/{id}/offers` 조합으로 임시 구현했습니다. 전용 상품 도메인이 있으면 카드/검색/재고 표현이 정확해집니다.

| 메서드 | 경로 | 설명 | 응답 핵심 필드 |
| --- | --- | --- | --- |
| GET | `/api/v1/products` | 상품 목록(페이지네이션, 카테고리/지역/스타일 필터) | `id, name, ingredientId, ingredientName, producerId, producerName, region, price, unit, imageUrl, stockStatus, category` |
| GET | `/api/v1/products/{id}` | 상품 상세 | 위 + `images[], description, relatedRecipeIds[], freshnessLabel, stock` |
| GET | `/api/v1/search?type=PRODUCT` | 검색에 상품 타입 추가 | 현재 `ALL/INGREDIENT/RECIPE`만 존재 |

- 임시 대응: 프론트는 `/products`를 농가/오퍼로 구성하고, 상품 상세 라우트는 `/products/[producerId]?offer=<offerId>`로 동작합니다.

## 2. 판매자(농가) 상품 관리 — P0

현재 등록만 가능(`POST /producers/me/offers`). 판매자 센터(대시보드)를 완성하려면 조회·수정·삭제·통계가 필요합니다.

| 메서드 | 경로 | 설명 |
| --- | --- | --- |
| GET | `/api/v1/producers/me/offers` | 내 판매 상품 목록 (대시보드 리스트) |
| PATCH | `/api/v1/producers/me/offers/{offerId}` | 가격/단위/신선도 수정 |
| DELETE | `/api/v1/producers/me/offers/{offerId}` | 상품 내리기 |
| GET | `/api/v1/producers/me/stats` | 판매 통계: `viewCount, orderCount, salesAmount, favoriteCount, reviewCount, periodSeries[]` |

- 임시 대응: 판매 상품 목록·통계는 mock(데모)로 표시하고 "데모 통계" 라벨을 달았습니다.
- 참고: AI 가격추천/홍보문구 자동작성 기능은 커머스 피벗에서 **제외(retired)** 되어 프론트에서도 제거했습니다. 상품 등록 화면의 "권장가 안내"는 정적 안내 문구일 뿐 AI 호출이 아닙니다.

## 3. 찜(Favorites) 응답 보강 — P1

`GET /favorites`가 현재 `{id, targetType, targetId}`만 반환합니다. 찜 목록 화면에서 이름/이미지/가격을 보여주려면 대상 요약이 필요합니다.

```jsonc
// 권장 응답
{ "items": [
  { "id": 10, "targetType": "INGREDIENT", "targetId": 12,
    "title": "봄동", "imageUrl": "...", "subtitle": "4,500원/봉" }
]}
```

- 임시 대응: 찜 화면은 id만 있을 때 빈/단순 목록으로 처리합니다.

## 4. 주문/결제/배송 — P0~P1

| 항목 | 현재 | 필요 |
| --- | --- | --- |
| 결제 | `POST /orders`가 장바구니를 즉시 `PAID`로 전환(모의) | 실제 PG 연동 또는 결제수단/검증 (P2) |
| 배송지 | 프론트 mock 주소 | `GET/POST /api/v1/users/me/addresses` (기본 배송지) — P1 |
| 주문 상태 | 단일 `PAID` | 상태 흐름 `PAID→PREPARING→SHIPPED→DELIVERED` + 운송장/추적 — P1 |
| 주문 항목 이미지 | 없음 | `OrderItem.imageUrl` 있으면 주문/완료 화면 품질↑ — P2 |

## 5. 리뷰 — P1

| 메서드 | 경로 | 설명 |
| --- | --- | --- |
| GET | `/api/v1/users/me/reviews?status=writable\|written` | 마이 → 내 리뷰 탭. `writable`은 배송완료 주문 기반 (현재 빈 배열) |
| (정책) | `POST /producers/{id}/reviews` | 현재 자유 작성(MVP). 추후 배송완료 주문 검증 |

- 임시 대응: 내 리뷰 화면은 written 샘플/빈 상태로 처리.

## 6. 인증 고도화 — P1

UI에 카카오/Apple/구글 버튼이 있으나 비활성(준비 중)입니다.

| 메서드 | 경로 | 설명 |
| --- | --- | --- |
| POST | `/api/v1/auth/oauth/{provider}` | 소셜 로그인 |
| POST | `/api/v1/auth/refresh` | 토큰 갱신 |
| POST | `/api/v1/auth/logout` | 로그아웃 |

- 현재: email/password + access token만. 만료 시 재로그인.

## 7. 이미지 업로드 — P1

농가 등록/상품 등록/리뷰 작성 화면에 사진 첨부 UI가 있으나 업로드 엔드포인트가 없습니다.

| 메서드 | 경로 | 설명 |
| --- | --- | --- |
| POST | `/api/v1/uploads` (multipart) | 이미지 업로드 → `{ url }` 반환. 농가 `photoUrl`, 상품 `imageUrl`, 리뷰 사진에 사용 |

## 8. 응답 보강 (있으면 좋음) — P2

- `GET /home`: 명예 농가 캐러셀 데이터 포함(현재 `/producers` 별도 호출), `weeklySeason`(절기/주차 라벨), hero CTA 구조화.
- `GET /ingredients`, `/ingredients/{id}`: `trendDirection`(UP/DOWN/FLAT), `priceChangeLabel`, `seasonMonths`, `buyingSignal`을 실제 계산값으로.
- `GET /ingredients/{id}/substitutes`: `reason`(대체 이유) 필드.
- `GET /search/trending` & `GET /users/me/recent-searches`: 검색 화면에서 사용 중. 비로그인 최근검색은 클라이언트 보관도 가능.
- 알림 푸시: 디바이스 토큰 등록 `POST /api/v1/notifications/devices` (실시간/푸시) — P2.

---

## 부록 — 프론트가 사용하는 엔드포인트 매핑

`frontend/lib/endpoints.js`에 도메인별로 정리되어 있고, 각 함수는 `실제 API → 실패 시 mock` 순으로 동작합니다.
실제 백엔드만 쓰려면 `frontend/.env.local`에 다음을 설정하세요.

```
NEXT_PUBLIC_API_BASE_URL=http://localhost:8080
NEXT_PUBLIC_DEMO_FALLBACK=off
```

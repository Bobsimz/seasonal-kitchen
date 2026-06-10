# Frontend Gap Analysis (2026-06-10)

검수 대상: `../frontend` (Next.js 프로토타입, `components/app.jsx` 기준)
선행 문서: `frontend-screen-api-coverage.md` (2026-06-05)

## 0. 요약

`frontend-screen-api-coverage.md`(6/5) 작성 이후 프론트가 크게 진화했다. 핵심은 **리테일 시세 비교 → 농가(생산자) 직거래**로의 reframe이며, 여기에 **장바구니·주문·결제·리뷰** 화면이 통째로 추가됐다. 현재 백엔드는 `farm-direct-commerce` 골격과 핵심 조회/장바구니/모의주문 API를 추가한 상태다.

| 도메인 | 상태 | 비고 |
| --- | --- | --- |
| 농가(Producer) | 구현 중 | V12/V14 시드, 목록·검색·상세·offer·리뷰·소식 조회 구현 |
| 장바구니·주문(Cart/Order) | 구현 중 | offerId 기반 장바구니, 농가별 배송비, 장바구니→모의주문 전환 구현 |
| 리뷰(Review) | MVP 구현 | 농가 리뷰 조회/자유 작성(+평점 집계 갱신), 내 작성 리뷰 조회. 작성가능/주문자격/수정·삭제는 future |
| 찜 확장(Wishlist) | 부분 구현 | `Favorite.targetType=PRODUCER` 검증 분기 추가. 응답 enrich는 TODO |

추가 보강: 판매자 상품등록 DTO 필드 부족, AI 방향 정리.

## 1. 신규 프론트 화면 인벤토리 (6/5 이후)

`app.jsx` 기준, 6/5 coverage 문서에 없던 화면:

- `list-prod`, `list-prod-res` — 농가 리스트 / 농가 검색 (`ScreenProducerList`, `ScreenProducerListSearchResult`)
- `compare` — 기존 "가격 비교"가 **"농가 비교"** 로 재정의 (`ScreenCompare`)
- `producer-detail` — 농가 상세 (`ScreenProducerDetail`)
- `cart`, `purchase`, `order-complete` — 장바구니 / 구매하기 / 주문완료 (`screens-farm.jsx`)
- `farm-upload` — 농가 상품 등록 (`ScreenFarmUpload`)
- `orders`, `wishlist`, `reviews`, `write-review` — 주문내역 / 찜 / 리뷰관리 / 리뷰작성 (`screens-misc.jsx`)
- `ai-b`, `ai-result` — 소비자 AI 장보기 챗 (**삭제 예정 잔재, 무시**)

## 2. 데이터 모델 갭 — 농가(Producer)

`frontend/components/producers-data.js`가 사실상의 도메인 정의서다. 생산자 객체 shape:

```
{ id, name, region, tagline, photo, specialties[], style, priceLevel,
  freshnessLevel, rating, reviewCount, honorary, badges[] }
  style: 'value'(저렴이·실속형) | 'premium'(프리미엄·싱싱) | 'organic'(유기농·무농약)
```

파생 함수들이 추가 요구사항을 드러낸다:

- `producersForIngredient(name)` → **식재료별 농가 목록** API (specialties 매칭)
- `producerOffer(producer, name)` → 농가 × 식재료 → `{ price, unit, fresh }` → **식재료별 농가 가격 비교** ("농가 비교" 화면 15)
- `producerReviews(producer)` → 농가 리뷰 (author, rating, date, item, body)
- `producerNews(producer)` → 농가 스토어 소식 타임라인 (date, title, img, body)
- `HONORARY_PRODUCERS` → 명예/베스트 농가 (홈 캐러셀 / 베스트 섹션)

기존 `store_offers`(쿠팡·마켓컬리 등 리테일)는 **개념이 다르다**. 농가 직거래는 `producer_offers`로 분리하고, 화면 15(농가 비교)는 `/offers`가 아니라 농가 기준 응답을 사용해야 한다.

### 현재 API

```text
GET /api/v1/producers                               # 농가 리스트 (q/style/honorary + pageable)
GET /api/v1/producers?q=봄동&style=ORGANIC&honorary=true # 농가 검색 (specialty 매칭 + 필터 조합)
GET /api/v1/producers/{producerId}                  # 농가 상세
GET /api/v1/producers/{producerId}/offers           # 농가가 파는 상품(식재료별 가격/단위/신선도)
GET /api/v1/producers/{producerId}/reviews          # 농가 리뷰
GET /api/v1/producers/{producerId}/news             # 농가 스토어 소식
GET /api/v1/ingredients/{ingredientId}/producers    # 식재료별 농가 비교. ingredient_id 우선, 미백필 시 식재료명 fallback
```

홈/베스트 농가는 `GET /api/v1/home` 응답에 `honoraryProducers[]`를 추가하거나 `GET /api/v1/producers?honorary=true`로 처리.

## 3. 데이터 모델 갭 — 장바구니 · 주문

화면 23(장바구니)·24(구매하기)·24a(주문완료)·21a(주문내역). 장바구니는 **농가별 그룹핑 + 농가별 배송비** 구조이며, 3만원 이상 무료배송 룰이 보인다(`screens-farm.jsx`). 주문완료는 주문번호(`2026-0609-0427`), 결제금액, 배송비, 적립을 표시한다.

### 현재 API

```text
GET    /api/v1/cart                       # 장바구니 조회 (농가별 그룹, 배송비/합계 계산)
POST   /api/v1/cart/items                 # 담기: offerId + qty, 가격/단위는 서버가 offer에서 스냅샷
PATCH  /api/v1/cart/items/{cartItemId}    # 수량 변경
DELETE /api/v1/cart/items/{cartItemId}    # 삭제
POST   /api/v1/orders                     # 주문 생성 (장바구니 → 주문)
GET    /api/v1/orders                     # 주문 내역
GET    /api/v1/orders/{orderId}           # 주문 상세 / 주문완료 화면
```

현재 장바구니는 백엔드에 영속화한다. 주문은 PG 없이 장바구니를 주문/주문항목으로 전환하는 모의 결제 범위다. 배송비는 농가별 3,000원, 농가별 소계 30,000원 이상 무료 정책으로 구현되어 있다.

## 4. 데이터 모델 갭 — 리뷰

화면 21c(리뷰 관리: 작성한/작성가능 탭)·21d(리뷰 작성: 별점 + 상세후기). 리뷰는 농가(또는 주문) 기준이며, 마이페이지에 "작성 가능 2건" 카운트가 노출된다.

**MVP 리뷰 정책: 자유 작성.** 로그인 사용자는 존재하는 농가에 자유롭게 리뷰를 쓸 수 있고, 작성 시 `producer.rating`(평균)·`review_count`가 갱신된다. 배송완료 주문 기반 자격검증은 MVP 범위 밖(future).

```text
GET    /api/v1/producers/{producerId}/reviews      # 구현: 농가 리뷰 목록
POST   /api/v1/producers/{producerId}/reviews      # 구현: 자유 작성 + 평점 집계 갱신
GET    /api/v1/users/me/reviews?status=written     # 구현: 내가 작성한 농가 리뷰 (기본값)
GET    /api/v1/users/me/reviews?status=writable    # MVP 범위 밖: 빈 목록 반환 (future)
PATCH  /api/v1/reviews/{reviewId}                  # future
DELETE /api/v1/reviews/{reviewId}                  # future
```

## 5. 찜(Wishlist) 확장

화면 21b는 **농가 / 식재료 / 레시피 3종 토글**. 마이페이지는 "찜한 농가 8곳"을 별도 노출. 백엔드 `FavoriteService.validateTarget`에는 `PRODUCER` 분기가 추가되어 존재하는 농가만 찜할 수 있다. 응답에 카드 요약(이름/이미지/지역)을 채우는 타입별 enrich는 아직 TODO다.

## 6. 판매자 상품 등록(농가 상품 등록) — DTO 보강

`POST /api/v1/seller/products`는 `03-api-contract.md`에 있으나 컨트롤러 미구현. 화면 25(`ScreenFarmUpload`)의 실제 입력 필드:

- 상품 사진 (최대 10, 첫 장이 대표)
- 카테고리: 잎채소 / 뿌리채소 / 과일 / 곡류 / 버섯 / 기타
- 판매 가격 + 단위
- **재고 수량**
- **수확·배송 정보** (수확일 / 출고 / 포장)
- **신선도·원산지 소개** (최대 500자)

문서의 `ProductCardResponse`엔 재고·수확·배송·신선도 필드가 없다. 등록 요청 DTO와 상품 엔티티에 위 필드 추가 필요. (참고: 화면에 AI 가격추천/홍보글 버튼은 아직 없음 → seller AI 엔드포인트는 등록 폼 연동 시점에 노출 예정)

## 7. AI 방향 정리

**소비자용 AI(챗봇·AI 장보기)는 폐기 확정.** `chatbot/` 폴더, `frontend/components/screens-ai.jsx`(`ScreenAIChatB`/`ScreenAIResult`), `app.jsx`의 "04 · AI 장보기" 섹션은 삭제 예정 잔재이므로 백엔드 API 요구사항에서 제외한다. AI는 **판매자용만 유지**: `POST /api/v1/seller/products/price-recommendation`, `POST /api/v1/seller/products/promotional-copy` (OpenSpec `product-commerce-pivot` 참조).

## 8. 우선순위

1. **P0 — 농가(Producer)**: 리스트/상세/리뷰/소식/식재료별 비교는 구현됨. 남은 일은 실제 식재료 ID 백필/가격 재산출과 홈/검색 연동.
2. **P0 — 찜 PRODUCER 확장**: 검증 분기는 구현됨. 남은 일은 응답 enrich.
3. **P1 — 장바구니·주문**: 영속 장바구니와 모의 주문은 구현됨. 주문번호는 MVP 수준의 충돌 방어가 들어갔고, 남은 일은 PG 범위 결정과 운영급 sequence 전환 여부다.
4. **P1 — 리뷰**: MVP 자유 작성 정책으로 조회/작성/평점 집계까지 구현됨. 작성가능(writable)·주문 자격검증·수정/삭제는 future.
5. **P1 — 판매자 등록 DTO 보강**: product/seller 도메인 구현 시 함께.

상세 작업 목록은 OpenSpec change `farm-direct-commerce`(tasks.md) 참조.

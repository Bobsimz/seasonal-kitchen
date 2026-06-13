# 상품 탭: 농가 목록 → 상품(이커머스) 목록 전환

작성일: 2026-06-13

## 배경 / 목적

`상품` 탭(`app/(tabs)/products/page.jsx`)은 현재 **농가(ProducerRow) 목록**을 보여주고,
각 농가 행 하단에 대표 상품 2~3개를 칩으로 노출한다. 사용자는 쿠팡/이커머스처럼
**농가가 판매 중인 개별 상품들의 평탄한 목록**을 보길 원한다.

## 핵심 전제 (이미 존재하는 것)

- `components/domain/ProductCard.jsx` — 2열 그리드용 상품 카드(이미지/이름/농가/가격/담기). 이미 식재료 상세에서 사용 중.
- `ProductCardResponse` 형태 — `BACKEND-REQUIREMENTS.md`에 `GET /api/v1/products`로 문서화됨:
  `id, name, ingredientId, ingredientName, producerId, producerName, region, price, unit, imageUrl, stockStatus, category`
- `lib/mock/data.js`의 `ingredientProducts(id)` — 위 형태를 식재료 단위로 이미 생성.
- offer id가 결정적(`producerId*100+idx`) → `/products/[producerId]?offer=<offerId>` 딥링크가 정확히 동작하고 `store.findOffer`로 장바구니 담기 호환.

따라서 신규 작업은 **전역 상품 목록 생성 + 탭 재작성**으로 한정된다. 백엔드/검색/결제는 범위 밖.

## 변경 사항

### 1. 데이터 레이어 — 전역 상품 목록
- `lib/mock/data.js`: `export function products(params)` 추가.
  - 전체 `PRODUCERS` × 각 농가의 `producerOffers(pid)`를 평탄화해 `ProductCardResponse[]` 생성.
  - `ingredientProducts`와 **동일한 객체 형태**를 사용(이름 포맷 `"{region} {ingredientName} · {freshnessLabel}"` 포함).
  - 정렬용으로 `rating`, `reviewCount`(해당 농가 값) 필드를 추가로 포함.
  - 같은 품목을 여러 농가가 팔면 각각 별도 카드(멀티셀러) — 의도된 동작, dedup 없음.
  - `params.category`가 있으면 필터, `params.sort`가 있으면 정렬(아래 정렬 규칙) 적용. 없으면 전체+추천순.
- `lib/endpoints.js`: `listProducts: (params) => withFallback(() => api.get('/products', { params }), () => mock.products(params))`
- `lib/queries.js`: `qk.products = (params) => ['products', params || {}]` 추가, `useProducts(params)` 추가(`select: unwrapList`).

### 2. 카테고리 필터
- 농가 스타일 필터(유기농/프리미엄/실속) 제거.
- 칩은 **현재 상품 목록에 실제 존재하는 `category` 값**에서 동적 생성: `전체` + (잎채소/뿌리채소/열매채소/꽃채소/과일/양념채소 중 존재하는 것, 선호 순서 적용).
- 카테고리 누락으로 숨겨지는 상품이 없도록 보장(빈 카테고리는 칩 미생성, 미분류는 포함).

### 3. 정렬
- 옵션: `추천순`(기본, rating desc → reviewCount desc), `낮은가격순`(price asc), `리뷰많은순`(reviewCount desc).
- 우상단 정렬 라벨 탭 → `components/ui/Sheet` 바텀시트로 선택.

### 4. 상품 탭 페이지 재작성 (`app/(tabs)/products/page.jsx`)
- 유지: `AppHeader "상품"` + 장바구니 아이콘, 읽기전용 `SearchBar`(→ `/search`), `판매 등록` FAB.
- 농가 스타일 필터 → 동적 카테고리 `ChipTabs`(sticky).
- `ProducerRow` 목록 + `OffersFooter` 제거 → `grid grid-cols-2 gap-3 px-4`의 `ProductCard`.
- 카드 탭 → `/products/${producerId}?offer=${id}`.
- 카운트 "N개 상품", 로딩(`LoadingScreen`)/에러(`ErrorState`)/빈(`EmptyState`) 상태.
- 클라이언트에서 카테고리 필터 + 정렬 적용(데이터 소량).

### 5. `ProductCard` 보강 (격리)
- `href` prop 추가. 기본값 `/producers/${p.producerId}`(식재료 상세 동작 불변). 탭은 `/products/${p.producerId}?offer=${p.id}` 전달.
- `p.rating`이 있을 때만 `⭐ {rating} ({compact(reviewCount)})` 한 줄 조건부 표시. `ingredientProducts`엔 rating 없음 → 식재료 상세 영향 없음.

## 검증
- 테스트 하네스 없음 → `next build`와 `next lint`로 회귀 확인.
- 수동 확인: 상품 탭 그리드 렌더, 카테고리 필터, 정렬 바텀시트, 카드 탭→상품 상세(올바른 offer 포커스), 담기 동작, 식재료 상세 그리드 무변경.

## 비목표(범위 밖)
- 백엔드 `/products` 실제 구현(문서화된 계약 그대로 사용).
- 검색 페이지의 상품 타입, 결제/주문 흐름, 페이지네이션 무한스크롤(소량 mock이라 단일 렌더).

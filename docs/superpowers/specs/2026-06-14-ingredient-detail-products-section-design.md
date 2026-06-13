# 재료 상세 페이지 개편 + 식재료별 제품 API 설계

작성일: 2026-06-14

## 배경 / 목표

`ingredients/[id]` 재료 상세 페이지를 정리하고, "농가 직거래" 섹션을 "이 재료를 파는 제품"
섹션으로 교체한다. 제품 카드를 누르면 제품 상세(`/products/{producerId}?offer={offerId}`)로
이동한다. 백엔드에 식재료별 제품 조회 엔드포인트를 신설한다.

요청 4건:
1. 재료 상세 하단 "최저가 담기" 고정 바 제거
2. "관련 레시피" 섹션의 "더보기" 제거
3. 레시피 이미지(신규 DB 이미지) 표시 정상화
4. "농가 직거래" 섹션 → "이 재료를 파는 제품" 섹션 교체 (백엔드+프론트)

## 탐색에서 확인한 사실

- 재료 상세 페이지는 **탭이 아니라 세로 스크롤 섹션** 구조다("탭"은 섹션 제목).
- 레시피 이미지 데이터는 **이미 연결되어 있다**: 마이그레이션 V52가 `recipes.image_url`을
  옛 쇼츠 썸네일(`thumbnails/*.webp`)에서 실제 요리 사진(`dishes/{id}.jpg`)으로 교체했고,
  프론트는 전부 `recipe.imageUrl`을 읽는다. 별도 thumbnail 컬럼/필드는 없다.
  유일한 문제는 `RecipeCard.jsx` 세로카드의 `scale-[1.8]` 확대(옛 레터박스 썸네일 크롭용)뿐.
- 백엔드에 `GET /ingredients/{id}/producers`는 존재(`IngredientProducerController`)하지만
  `GET /ingredients/{id}/products`는 **어디에도 없다.** 그래서 프론트 `useIngredientProducts`는
  항상 mock(`mock.ingredientProducts`)로 폴백한다. 프론트 hook·mock·제품상세 라우트는 이미 준비됨.
- "Product"는 전용 테이블 없이 `producer_offers`를 상품으로 보는 facade. product id == offer id.

## 결정사항 (사용자 확정)

- 하단 바: **완전 제거** (제품 카드별 담기 + 본문 입고알림 카드로 충분)
- 제품 섹션 레이아웃: **가로 스크롤 카루셀** (기존 관련레시피/대체재료 섹션과 동일)
- 레시피 이미지: **`scale-[1.8]` 제거 → `object-cover`** (가로리스트/상세는 이미 정상)

## 백엔드 설계

### 신규 엔드포인트
`GET /api/v1/ingredients/{ingredientId}/products` → `ApiResponse<List<ProductCardResponse>>`
- 해당 식재료를 파는 ACTIVE `producer_offers`를 가격 오름차순으로 카드로 반환. HIDDEN 제외.
- 기존 `IngredientProducerController`(`/producers`) 패턴을 그대로 따라 `product` 패키지에
  `IngredientProductController` 신설(`@RequestMapping("/api/v1/ingredients")`), `ProductService`에 위임.

### ProductService.getProductsByIngredient(Long ingredientId)
`ProducerService.getOffersForIngredient`와 동일한 선택 전략(농가 비교와 같은 offer 집합 보장):
1. `findByIngredientIdAndStatusOrderByPriceAsc(id, ACTIVE)` — ingredient_id 링크 우선
2. 비어있으면 폴백: ingredient명으로 `findByIngredientNameAndStatusOrderByPriceAsc(name, ACTIVE)`
   (→ `IngredientRepository` 주입 필요)
3. 기존 private `toCards()`로 매핑(대표사진/농가 배치 로딩, N+1 회피)

### 테스트 (TDD)
`IngredientProductControllerTest` (`@SpringBootTest`/`MockMvc`, ProductControllerTest 패턴):
- ACTIVE offer들이 가격 오름차순으로 반환
- HIDDEN offer 제외(최저가여도)
- 다른 식재료 offer 제외
- 대표 imageUrl/producerName/region 매핑

## 프론트 설계

### `app/(stack)/ingredients/[id]/page.jsx`
- `useIngredientProducers` → `useIngredientProducts(id)`로 교체. 지역변수 `offers` → `products`.
- `hasOffers` → `hasProducts = products.length > 0` (현재가격 카드/구매신호 칩/빈상태/섹션순서 구동).
- (1) 하단 `<BottomBar>` 블록 + import 제거.
- (2) `recipesSection`의 `action`(더보기 Link) 제거.
- (4) "농가 직거래" `<Section>` + `FarmOfferRow` + 헬퍼(`bestScore/cheapest/best/ordered/detailRows`) 제거.
  그 자리에 "이 재료를 파는 제품" 섹션: 가로 스크롤 카루셀의 `<ProductCard>`,
  `href={'/products/${p.producerId}?offer=${p.id}'}`.
- 불필요해진 import 정리(`ProducerAvatar/StyleBadge/Star/Sprout/AddToCartButton/won/compact`).
  `FavoriteHeart/wonLabel`은 히어로·가격카드에서 계속 쓰여 유지.

### `components/domain/RecipeCard.jsx`
- (3) 18행 세로카드 이미지 `scale-[1.8] object-cover` → `object-cover`. 주석 갱신.
  세로카드 공용이므로 홈/정보/온보딩/재료상세 모든 사용처에 자동 반영. RecipeRow는 변경 없음.

## 데이터 흐름
재료상세 → `useIngredientProducts(id)` → `GET /ingredients/{id}/products`
→ `ProducerOffer(ACTIVE, 해당 식재료)` → `ProductCardResponse[]` → `ProductCard` 카루셀
→ 탭 시 `/products/{producerId}?offer={offerId}` 제품 상세.

## 범위 밖 (유지)
- `/ingredients/[id]/producers` 전체비교 서브페이지(상세에서 링크만 사라짐)
- 프론트 mock/hook/제품상세 라우트(이미 준비됨)

## 검증
- 백엔드: `./gradlew test` (신규 테스트 포함)
- 프론트: 빌드/린트
- diff 어드버서리얼 리뷰(누락 사용처/미사용 import/계약 일치 확인)

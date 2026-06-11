# 프론트 화면 ↔ 백엔드 분석

프론트는 현재 **디자인 프로토타입(React 목업)** 으로만 존재합니다(`frontend/components/screens-*.jsx`, 실데이터 연동 없음).
이 문서는 28개 화면을 하나씩 뜯어 **표시 데이터 → 필요한 API/데이터 → 백엔드 현황(구현됨/개선/미구현)** 으로 정리한 것입니다.

- 범례: ✅ 구현됨(바로 연동 가능) · 🟡 있으나 개선/보강 필요 · ❌ 미구현(새로 만들어야 함)
- 기준 코드: `backend/src/main/java/...` DTO·엔티티 / 필드 단위 상세는 Swagger(`/swagger-ui/index.html`)
- 함께 보기: `frontend-api-guide.md`(엔드포인트 지도), `producer-registration-fields.md`(입력값)

---

## 0. 핵심 결론 (먼저 읽기)

대부분의 소비자 화면(홈·식재료·레시피·릴스·장바구니·주문·마이·찜·알림·리뷰)은 **백엔드가 이미 충실히 갖춰져 있어 바로 연동 가능**합니다. 백엔드가 화면보다 데이터가 더 풍부한 곳도 많습니다(식재료 상세, 마이페이지 요약).

**진짜 갭은 "상품(판매) 도메인"에 몰려 있습니다.** 정리하면:

| # | 갭 | 영향 화면 | 권장 |
| --- | --- | --- | --- |
| G1 | **상품(Product) 개념 부재** — 농가 offer에 상품명·설명·사진·태그·옵션이 없음 | 16 상품리스트 / 17 상품상세 / 25 판매등록 | offer 확장 또는 product 도입 (아래 §9) |
| G2 | **판매자 AI**(상품명·설명·추천가격 자동작성) 미구현 | 25 판매등록 | MVP 제외 또는 후속. 화면은 "직접 작성" 우선 |
| G3 | **소셜 로그인**(카카오/애플/구글) 미구현 | 04 가입 | 화면을 이메일 우선으로 변경 (OAuth는 future) |
| G4 | **선호 소비유형(라이프스타일 다중 태그)** 모델 부재 | 05 가입 설문 | preferences에 `lifestyles[]` 추가 (농가 style 매칭용) |
| ~~G5~~ | ✅ **구현됨** — 상품 옵션(`offer_options`: 수량+단위+가격) 추가(V24). 장바구니 옵션선택은 후속 | 17 상품상세 | — |
| G6 | **검색 PRODUCT 타입** 미지원 | 16b 상품검색 | 상품 도메인 생기면 추가 |

나머지는 모두 ✅ 또는 소규모 🟡입니다. 상세는 아래 화면별 분석을 보세요.

---

## 1. 한눈에 보기 (섹션별 커버리지)

| 섹션 | 화면 | 상태 | 주 연동 API |
| --- | --- | --- | --- |
| 01 진입/온보딩 | 01 스플래시 | ✅ 정적 | – |
| | 02·03 온보딩(농가/트렌드) | 🟡 | 트렌드는 `/search/trending`·`/reels` 활용 |
| | 04 가입 | 🟡 G3 | `/auth/signup`(이메일). OAuth ❌ |
| | 05 가입 설문 | 🟡 G4 | `PUT /users/me/preferences` |
| 02 홈 | 07 홈 메인 | ✅ | `GET /home` |
| | 08 검색 전 / 09 검색 결과 | ✅ | `/search`, `/search/trending`, `/users/me/recent-searches` |
| 03 정보 | 10~13 리스트(식재료/레시피) | ✅ | `/ingredients`, `/recipes`, `/search` |
| | 14 식재료 상세 | ✅ | `/ingredients/{id}` (+`/prices`) |
| | 15 농가 비교 | ✅ | `/ingredients/{id}/producers` |
| | 15a 농가 상세 | ✅ | `/producers/{id}` (+`/offers`,`/reviews`,`/news`) |
| 04 상품 | 16 상품 리스트 / 16a 판매자뷰 | ❌ G1 | (상품 도메인 필요) |
| | 16b 상품 검색 | ❌ G1/G6 | – |
| | 17 상품 상세 | ❌ G1/G5 | – |
| 05 릴스 | 18 릴스 | ✅ | `/reels` (+likes/comments/view-events) |
| | 19 레시피 상세 / 20 조리순서 | ✅ | `/recipes/{id}`, `/recipes/{id}/steps` |
| 06 마이 | 21 마이페이지 | ✅ | `/users/me/summary` |
| | 21a 주문내역 | ✅ | `/orders` |
| | 21b 찜 | ✅ | `/favorites` |
| | 21c 리뷰관리 / 21d 리뷰작성 | ✅ | `/users/me/reviews`, `POST /producers/{id}/reviews` |
| 07 농가연결 | 23 장바구니 | ✅ | `/cart` |
| | 24 주문완료 | ✅ | `POST /orders`, `GET /orders/{id}` |
| | 25 판매등록 | 🟡 G1/G2 | `POST /producers/me/offers`(부분) |
| (공통) | 알림 | ✅ | `/notifications` |
| | 가격알림 | ✅ | `/price-alerts` |

---

## 2. 진입 & 온보딩 (01~05)

### 01 스플래시 — ✅
정적 화면. 백엔드 불필요.

### 02·03 온보딩(농가 소개 / 제철 트렌드) — 🟡
- **표시**: 농가 카드 스캐터(02), 트렌드 음식 카드(03: 제목·크리에이터·조회수·뱃지 HOT/트렌드/신상/인기).
- **현황**: 온보딩은 정적이어도 됨. 트렌드 데이터를 실제로 쓰려면 `GET /search/trending`(인기 검색어) + `GET /reels`(릴스 likeCount)로 대체 가능. ✅ 데이터 있음.
- **갭**: "조회수(124만)" 같은 릴스 view 집계는 `POST /reels/{id}/view-events`로 쌓이지만, 노출용 정렬 API는 단순. 온보딩은 정적 권장.

### 04 가입 — 🟡 (G3)
- **표시**: **카카오/Apple/구글 버튼이 1차**, 하단에 "이메일로 가입".
- **현황**: 백엔드는 **이메일/비밀번호만**(`POST /auth/signup`). OAuth는 future(스키마 `oauth_accounts`만 보존).
- **권장**: 화면을 **이메일 가입 우선**으로 재배치하거나, 소셜 버튼은 "준비 중" 처리. OAuth 구현은 별도 과제.

### 05 가입 설문 — 🟡 (G4)
- **표시**: ① 가구원 수(1~4인+) ② **선호 소비유형 다중선택**(신선한/저렴한/유기농/프리미엄/친환경/빠른배송) ③ 매운음식 비선호 토글 ④ 알레르기 다중선택(18종).
- **연동**: `PUT /users/me/preferences`.
- **현황**: `UserPreference` = `householdSize`, `spicyAvoid`, `priority`(단일, 예 LOW_PRICE), `allergyCodes[]`, `budget`. → ①③④는 ✅.
- **갭 G4**: ②"선호 소비유형"은 **다중 태그**인데 백엔드엔 `priority`(단일값)만 있음. 농가 `style`(VALUE/ORGANIC/PREMIUM) 매칭에 쓰려면 **`lifestyles[]`(또는 personas[]) 다중 필드 추가** 권장. 임시로는 priority 1개만 저장하고 나머지는 버려야 함.

---

## 3. 홈 (07~09) — ✅

### 07 홈 메인
- **표시**: 시즌 라벨("2월 셋째 주"), 히어로 제철 식재료(이름·평년대비 ▼22%), "지금이 제철" 캐러셀(이름·현재가·가격대 range·단위·평년대비 delta·태그[제철적기/과잉공급/인기↑]), 장바구니 배지 수, 트렌드 레시피, 농가 섹션.
- **연동**: `GET /home`.
- **현황**: `HomeResponse` = `seasonTitle/seasonSubtitle`, `hero`, `ingredients[]`(IngredientCard에 PriceSummary: `currentPrice`, `weekChangeRate`(주간), **`yearAverageChangeRate`(평년대비)**, `unit`, 출처 KAMIS), `recipes[]`, `reels[]`, `trendingKeywords[]`. → 화면 데이터 **전부 매핑됨**. ✅
- **소소한 갭 🟡**: 캐러셀 "태그(제철적기/과잉공급)"는 `seasonal`/`buyingSignal`/변동률로 프론트에서 라벨링 가능. 가격대 range(2,100~2,800)는 단일 currentPrice만 있어 프론트가 ± 표시하거나 백엔드가 min/max 추가 시 정확.

### 08 검색 전 / 09 검색 결과 — ✅
- **표시**: 인기검색어, 최근검색어, 통합 결과(식재료/레시피 더보기).
- **연동**: `GET /search/trending`, `GET /users/me/recent-searches`, `GET /search?q=&type=`. ✅
- **갭**: `type=PRODUCT` 없음(상품 도메인 부재, G6).

---

## 4. 정보: 식재료 & 레시피 & 농가 (10~15a) — ✅

### 10~13 리스트(식재료/레시피, 검색 결과) — ✅
- **표시**: 카테고리 필터(잎채소/뿌리/과일/곡류/육류/해산물 등), 카드 목록.
- **연동**: `GET /ingredients`, `GET /recipes`, `GET /search`. ✅
- **🟡**: 화면 카테고리(육류/해산물)와 실제 시드 데이터(KAMIS 곡류/채소/과일/기타 중심) 불일치 가능 → 데이터 보강 또는 필터 축소.

### 14 식재료 상세 — ✅ (백엔드가 더 풍부)
- **표시**: 이름/영문/카테고리, 상태칩(공급과잉·트렌드상승·**구매 적기**), 현재가+단위, 평년 -15%, KAMIS 출처, 가격 차트, 이번주 베스트 농가, (영양·보관팁 등).
- **연동**: `GET /ingredients/{id}` + `GET /ingredients/{id}/prices`(차트) + `GET /ingredients/{id}/producers`(베스트 농가).
- **현황**: `IngredientDetailResponse` = `seasonal`, `seasonScore`, **`buyingSignal`(BUY_NOW=구매적기)**, `description`, `seasonMonths[]`, `nutrition`(칼로리/탄단지·비타민), `careTips[]`, `storageTips[]`, `compareStoreCount`, `price`(평년대비 포함). 가격이력은 `IngredientPriceHistoryResponse`. → **화면보다 데이터가 많음.** ✅

### 15 농가 비교 — ✅
- **표시**: 특정 식재료를 파는 농가들 가격순, 최저가 태그.
- **연동**: `GET /ingredients/{id}/producers`(가격순 ProducerOffer 목록). ✅
- **🟡**: 정확한 비교를 위해 offer의 `ingredientId` 백필 필요(이름 매칭 의존 줄이기).

### 15a 농가 상세 — ✅
- **표시**: 농가 프로필(이름·지역·스타일·평점·리뷰수·명예·취급품목·배지), 판매 상품, 리뷰, 농가 소식.
- **연동**: `GET /producers/{id}` + `/offers` + `/reviews` + `/news`. ✅

---

## 5. 상품 (16~17) — ❌ 주요 갭 (G1/G5/G6)

이 섹션이 백엔드와 가장 안 맞습니다. 화면은 **"상품(판매 리스팅)"** 개념을 요구하는데 백엔드엔 `ProducerOffer`(식재료명+가격+단위+신선도)밖에 없습니다.

### 16 상품 리스트 / 16a 판매자뷰 / 16b 상품 검색
- **표시(화면 목 데이터 PRODUCTS)**: `상품명`("햇 봄동 1.5kg 산지직송"), `농가명`, `지역`, `상품 평점`(4.9), `가격`, `단위`(박스/단), **`태그[]`**(산지직송·무료배송·콜드체인·유기농·예약판매·대용량·흙무).
- **백엔드 offer 필드**: id, producerId, producerName, region, ingredientName, ingredientId, price, unit, freshnessLabel. → **상품명·상품설명·태그·상품평점·사진 없음.** ❌
- 판매자뷰 16a의 우하단 **＋ 버튼 → 판매 등록(25)** 동선만 backend 연동(아래 25 참고).

### 17 상품 상세 (구매하기)
- **표시**: 상품 사진, 농가 헤더, **옵션/규격 선택**(보통·대 +1,200·세척무 +800 등 variant별 가격), 수량, 장바구니/주문.
- **갭 G5**: offer엔 **옵션(variant)** 개념 없음. 보통/대/세척무는 별도 데이터 필요.

> **권장(§9 데이터 모델 참고)**: MVP라면 `producer_offers`에 `title`, `description`, `photos[]`, `tags[]`, (선택)`options[]`, `rating` 컬럼/연관을 추가해 offer를 "상품"으로 승격. 그러면 16/17/25가 모두 offer 기반으로 해결됨. 별도 `product` 테이블 신설은 cart의 `offerId` 연동과 중복되므로 비권장.

---

## 6. 릴스 & 레시피 (18~20) — ✅

### 18 릴스 — ✅
- **표시**: 세로 영상 피드, 좋아요/댓글/공유, 크리에이터, 관련 재료.
- **연동**: `GET /reels`, `GET /reels/{id}`, `/comments`, `POST /likes`·`/comments`·`/view-events`. ✅

### 19 레시피 상세 — ✅
- **표시**: 영상, 제목·태그(제철), 재료 목록(이름·수량·**가격·가격하락 표시**), "농가에서 살 수 있는 재료만 합산"한 예상비용, 좋아요수, 관련 릴스.
- **연동**: `GET /recipes/{id}`.
- **현황**: `RecipeDetailResponse` = title, description, difficulty, minutes, servings, `ingredients[]`(`ingredientId`, `estimatedPrice`, **`priceTrendDirection`(DOWN=하락)**, `optional`, 이미지), **`estimatedTotal`**(예상 총 재료비), tags, creatorName, likeCount, relatedReels. → ✅
- **🟡**: 화면의 "농가에서 살 수 있는 재료만 합산"은 재료별 농가 보유 여부 판단이 필요. `ingredientId`가 채워져 있으면 `/ingredients/{id}/producers`로 확인 가능. estimatedTotal 계산 기준(전체 vs 농가보유)을 프론트와 합의 필요.

### 20 조리 순서 — ✅
- **연동**: `GET /recipes/{id}/steps`. ✅

---

## 7. 마이페이지 (21~21d) — ✅

### 21 마이페이지 — ✅ (백엔드가 더 풍부)
- **표시**: 프로필(닉네임·아바타·가입N일·**누적 절약액 ₩67,800**), 메뉴(주문/찜/리뷰/알림/설정), 개인화 추천.
- **연동**: `GET /users/me/summary`.
- **현황**: `MyPageSummaryResponse` = profile(id/nickname/profileImageUrl), **stats(`monthlySaving`=절약, `favoriteCount`, `activeAlertCount`, `recentOrderCount`)**, preferences, allergyCodes, personalizedIngredients[], menuRows[]. → ✅ (가입N일만 가입일 가공 필요)

### 21a 주문 내역 — ✅
- **표시**: 주문일·주문번호(2026-0609-0427)·상태, 농가, 항목(이름·수량·단위·가격), 총결제, 완료시 "리뷰 쓰기".
- **연동**: `GET /orders`, `GET /orders/{id}`. 주문번호 포맷 일치. ✅

### 21b 찜 — ✅
- **표시**: 농가/식재료/레시피 3탭.
- **연동**: `GET /favorites`(targetType=PRODUCER/INGREDIENT/RECIPE), `POST`/`DELETE`. ✅

### 21c 리뷰 관리 / 21d 리뷰 작성 — ✅
- **표시**: 작성 대기/작성 완료, 별점+자유 텍스트.
- **연동**: `GET /users/me/reviews`, `POST /producers/{id}/reviews`(자유형). ✅
- **참고**: 리뷰 자격검증(REVIEW_NOT_ELIGIBLE)은 MVP에서 제거됨 — 누구나 작성 가능.

---

## 8. 농가 연결 & 주문 (23~25)

### 23 장바구니 — ✅
- **표시**: **농가별 그룹**, 항목(이름·수량·단위·단가·소계), 농가별 배송비, 상품금액/배송비/결제예정.
- **연동**: `GET /cart`(groups[producerId/producerName/items/subtotal/shipping] + itemsTotal/shippingTotal/payTotal), `POST /cart/items`(offerId+qty), `PATCH`/`DELETE`. ✅
- **참고**: 담기는 **offerId 기반**, 가격/이름은 offer 스냅샷.

### 24 주문 완료 — ✅
- **연동**: `POST /orders`(장바구니→주문), `GET /orders/{id}`. ✅

### 25 판매 등록 — 🟡 (G1/G2)
- **표시**: 상품 사진(최대 10장·대표), **"AI로 상품 정보 작성"**(AI 추천 ⇄ 직접 작성 토글: 상품명·설명·추천가격 자동), 카테고리, (이름·가격·단위 등).
- **연동(현재 가능)**: 농가 자가등록 `POST /producers/me` + 상품 등록 `POST /producers/me/offers`(ingredientName/price/unit/freshnessLabel).
- **갭**:
  - **G1**: 사진·상품명·상품설명·카테고리·태그를 offer가 못 받음 → §9 offer 확장 필요.
  - **G2 판매자 AI**: 상품명/설명/추천가격 자동 생성 백엔드 없음(기획상 future). 화면은 "직접 작성"으로 동작시키고 AI는 후속.

---

## 9. 데이터 모델 갭 정리 (백엔드 작업 후보)

우선순위 순.

1. **(높음·G1/G5) `producer_offers`를 "상품"으로 확장** — 화면 16/17/25 해결의 핵심.
   - 추가 컬럼(예): `title`(상품명), `description`, `category`, `photo_urls`(JSON/별도 테이블), `tags`(별도 테이블 또는 JSON), `rating`/`review_count`(상품 단위, 선택), `options`(규격·variant별 가격, 선택).
   - cart는 이미 `offerId` 참조이므로 offer 확장이 자연스러움(별도 product 테이블 신설보다 단순).
2. **(중간·G4) `user_preferences`에 라이프스타일 다중 태그** — `lifestyles[]`(신선/저렴/유기농/프리미엄/친환경/빠른배송). 농가 `style` 매칭·개인화에 사용.
3. **(중간) offer/specialty `ingredientId` 백필** — 식재료↔농가↔레시피 교차(15 비교, 19 농가구매)를 이름매칭이 아닌 ID로.
4. **(낮음·G3) OAuth** — 카카오/애플/구글. 화면 04 1차 노출. future.
5. **(낮음·G2) 판매자 AI** — 상품명/설명/추천가격 생성. 화면 25. future, 요청/응답 스펙 선확정 필요.
6. **(낮음·G6) 검색 `PRODUCT` 타입** — 1번(상품 확장) 완료 후 `/search?type=PRODUCT`.
7. **(낮음) 홈 가격대 range** — 캐러셀 "2,100~2,800" 표시용 min/max. 없으면 프론트가 currentPrice만 표시.

## 10. "이미 잘 돼 있어 손 안 대도 되는 것"
홈, 식재료 상세(+가격이력), 농가 비교/상세(+소식/리뷰), 레시피 상세(+조리순서·가격추세), 릴스(반응 포함), 장바구니/주문, 마이페이지 요약, 찜, 알림, 가격알림, 검색/인기·최근검색, 농가 자가등록(상품 외 프로필) — **DTO·엔티티가 화면 요구를 충족**합니다. 일부는 화면보다 데이터가 더 많습니다(식재료 상세, 마이 요약).

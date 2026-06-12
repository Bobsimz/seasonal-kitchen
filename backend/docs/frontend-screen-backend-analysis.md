# 프론트 화면 ↔ 백엔드 분석

프론트는 현재 **디자인 프로토타입(React 목업)** 으로만 존재합니다(`frontend/components/screens-*.jsx`, 실데이터 연동 없음).
이 문서는 28개 화면을 하나씩 뜯어 **표시 데이터 → 필요한 API/데이터 → 백엔드 현황(구현됨/개선/미구현)** 으로 정리한 것입니다.

- 범례: ✅ 구현됨(바로 연동 가능) · 🟡 있으나 개선/보강 필요 · ❌ 미구현(새로 만들어야 함)
- 기준 코드: `backend/src/main/java/...` DTO·엔티티 / 필드 단위 상세는 Swagger(`/swagger-ui/index.html`)
- 함께 보기: `frontend-api-guide.md`(엔드포인트 지도), `producer-registration-fields.md`(입력값)

---

## 0. 핵심 결론 (먼저 읽기)

대부분의 소비자 화면(홈·식재료·레시피·릴스·장바구니·주문·마이·찜·알림·리뷰)은 **백엔드가 이미 충실히 갖춰져 있어 바로 연동 가능**합니다. 백엔드가 화면보다 데이터가 더 풍부한 곳도 많습니다(식재료 상세, 마이페이지 요약).

**상품(판매) 도메인 갭(G1·G5)은 구현 완료됐습니다.** 현재 갭 현황:

| # | 갭 | 영향 화면 | 권장 |
| --- | --- | --- | --- |
| ~~G1~~ | ✅ **구현됨** — offer를 상품으로 확장(V23: title·description·category + `offer_photos`·`offer_tags`) | 16 상품리스트 / 17 상품상세 / 25 판매등록 | — |
| G2 | **판매자 AI**(상품명·설명·추천가격 자동작성) 미구현 | 25 판매등록 | MVP 제외 또는 후속. 화면은 "직접 작성" 우선 |
| G3 | **소셜 로그인**(카카오/애플/구글) 미구현 | 04 가입 | 화면을 이메일 우선으로 변경 (OAuth는 future) |
| G4 | **선호 소비유형(라이프스타일 다중 태그)** 모델 부재 | 05 가입 설문 | preferences에 `lifestyles[]` 추가 (농가 style 매칭용) |
| ~~G5~~ | ✅ **구현됨** — 상품 옵션(`offer_options`: 수량+단위+가격, V24). 장바구니 옵션선택은 후속 | 17 상품상세 | — |
| G6 | **검색 PRODUCT 타입** 미지원 | 16b 상품검색 | 상품 확장 끝났으니 `/search?type=PRODUCT` 추가만 하면 됨 |
| ~~G7~~ | ✅ **구현됨** — `GET /producers/me/stats`(매출·주문·인기상품·7일 매출추이·전월대비·정산일). 조회수·전환율은 이벤트 미수집이라 null(후속) | 21f 판매자 통계 / 21 마이(판매자 센터) | — |
| ~~G8~~ | ✅ **구현됨** — offer에 인증마크(`offer_certifications`)·재고(`stock_quantity`)·보관방법(`storage_method`/`storage_note`) 추가(V26) | 24 판매등록(`ScreenFarmUpload`) | — |

남은 갭: **G4**(라이프스타일 다중태그), **G6**(검색 PRODUCT 타입), **G2·G3**(판매자 AI·소셜로그인, future). 상세는 아래.
G7·G8은 2026-06-12 구현 완료.

> **2026-06-12 변경 반영**: 프론트 커밋 `58656da`로 화면 3건 변동 — ① 신규 **07 제철 큐레이션**(홈 배너 진입), ② 신규 **21f 판매자 통계**(판매자 센터 대시보드), ③ **24 판매등록**에 인증마크·재고·보관방법 필드 추가. 하단 탭이 5슬롯(홈·정보·**상품**·릴스·마이)으로 재정렬되며 기존 07 홈메인은 06으로 밀림. 상세는 §3a·§5b·§8·§12.

---

## 1. 한눈에 보기 (섹션별 커버리지)

| 섹션 | 화면 | 상태 | 주 연동 API |
| --- | --- | --- | --- |
| 01 진입/온보딩 | 01 스플래시 | ✅ 정적 | – |
| | 02·03 온보딩(농가/트렌드) | 🟡 | 트렌드는 `/search/trending`·`/reels` 활용 |
| | 04 가입 | 🟡 G3 | `/auth/signup`(이메일). OAuth ❌ |
| | 05 가입 설문 | 🟡 G4 | `PUT /users/me/preferences` |
| 02 홈 | 06 홈 메인 | ✅ | `GET /home` |
| | 07 제철 큐레이션 | ✅ 조합 가능 | `/home`+`/ingredients/{id}`+`/ingredients/{id}/producers`+`/recipes` |
| | 08 검색 전 / 09 검색 결과 | ✅ | `/search`, `/search/trending`, `/users/me/recent-searches` |
| 03 정보 | 10~13 리스트(식재료/레시피) | ✅ | `/ingredients`, `/recipes`, `/search` |
| | 14 식재료 상세 | ✅ | `/ingredients/{id}` (+`/prices`) |
| | 15 농가 비교 | ✅ | `/ingredients/{id}/producers` |
| | 15a 농가 상세 | ✅ | `/producers/{id}` (+`/offers`,`/reviews`,`/news`) |
| 04 상품 | 16 상품 리스트 / 16a 판매자뷰 | ✅ 백엔드 / 🟡 프론트연동 | `/producers/{id}/offers`(상품필드·태그·사진 포함) |
| | 16b 상품 검색 | 🟡 G6 | `/search`(아직 PRODUCT 타입 없음) |
| | 17 상품 상세 | ✅ 백엔드 | offer + `options[]`(규격/가격) 포함 |
| 05 릴스 | 18 릴스 | ✅ | `/reels` (+likes/comments/view-events) |
| | 19 레시피 상세 / 20 조리순서 | ✅ | `/recipes/{id}`, `/recipes/{id}/steps` |
| 06 마이 | 21 마이페이지 | ✅ | `/users/me/summary` |
| | 21a 주문내역 | ✅ | `/orders` |
| | 21b 찜 | ✅ | `/favorites` |
| | 21c 리뷰관리 / 21d 리뷰작성 | ✅ | `/users/me/reviews`, `POST /producers/{id}/reviews` |
| | 21e 판매자 등록 | ✅ | `POST /producers/me`(신원·연락·인증·약관) |
| | 21f 판매자 통계 | ✅ | `GET /producers/me/stats`(매출·주문·인기상품·7일추이·정산일. 조회수·전환율 후속) |
| 07 농가연결 | 22 장바구니 | ✅ | `/cart` |
| | 23 주문완료 | ✅ | `POST /orders`, `GET /orders/{id}` |
| | 24 판매등록 | ✅ / 🟡 AI | `POST /producers/me/offers`(상품필드·옵션·인증마크·재고·보관 ✅ V26). AI작성만 G2 future |
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

## 3. 홈 (06~09) — ✅

### 06 홈 메인
- **표시**: 시즌 라벨("2월 셋째 주"), 히어로 제철 식재료(이름·평년대비 ▼22%), "지금이 제철" 캐러셀(이름·현재가·가격대 range·단위·평년대비 delta·태그[제철적기/과잉공급/인기↑]), 장바구니 배지 수, 트렌드 레시피, 농가 섹션.
- **연동**: `GET /home`.
- **현황**: `HomeResponse` = `seasonTitle/seasonSubtitle`, `hero`, `ingredients[]`(IngredientCard에 PriceSummary: `currentPrice`, `weekChangeRate`(주간), **`yearAverageChangeRate`(평년대비)**, `unit`, 출처 KAMIS), `recipes[]`, `reels[]`, `trendingKeywords[]`. → 화면 데이터 **전부 매핑됨**. ✅
- **소소한 갭 🟡**: 캐러셀 "태그(제철적기/과잉공급)"는 `seasonal`/`buyingSignal`/변동률로 프론트에서 라벨링 가능. 가격대 range(2,100~2,800)는 단일 currentPrice만 있어 프론트가 ± 표시하거나 백엔드가 min/max 추가 시 정확.

### 07 제철 큐레이션 (신규) — ✅ 조합 가능
- **표시(`ScreenSeasonalCuration`)**: 홈 상단 배너 클릭 시 진입. 히어로(제철 식재료명·시즌 라벨·평년대비 ▼22%), "○○ 이야기" 카피, "왜 지금 ○○?" 포인트 3종(제철 적기/가격 매력/영양), 제철 레시피 3종(이름·소요시간·난이도), 해당 식재료 취급 농가 3곳.
- **연동(전용 API 없이 조합)**: 히어로/가격은 `GET /ingredients/{id}`(`seasonal`·`buyingSignal`·`price.yearAverageChangeRate`·`seasonMonths`·`careTips`), 농가는 `GET /ingredients/{id}/producers`, 레시피는 `GET /recipes?ingredientId=`(또는 `/search`). → 데이터 전부 존재. ✅
- **🟡 선택 사항**: "어떤 식재료를 큐레이션에 띄울지"를 백엔드가 정해주려면 `GET /home`의 hero/제철 식재료를 그대로 재사용하거나, 가벼운 `GET /curations/{ingredientId}`(위 3개를 한 번에 묶는 BFF성 엔드포인트)를 신설하면 프론트 호출이 1회로 줄어듦. **필수는 아님** — 기존 3개 API 조합으로 충분.

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

## 5. 상품 (16~17) — ✅ 백엔드 구현됨 (G1·G5 해소)

offer를 "상품"으로 확장 완료. 화면이 요구하던 상품명·설명·카테고리·사진·태그·옵션이 모두 들어갔습니다.

### 16 상품 리스트 / 16a 판매자뷰 / 16b 상품 검색
- **표시(화면 PRODUCTS)**: 상품명·농가명·지역·평점·가격·단위·태그[].
- **백엔드 `ProducerOfferResponse`(V23)**: 기존 필드 + `title`·`description`·`category`·`photoUrls[]`·`tags[]`. → 상품명·설명·사진·태그 ✅
  - 상품 평점은 별도 없음 — 농가 평점(`producer.rating`) 사용. (상품 단위 평점은 future)
  - 목록 조회는 배치(N+1 회피)로 사진·태그·옵션·농가를 묶어 반환.
- 16b 상품 검색: `/search`에 아직 `PRODUCT` 타입 없음(**G6**, 추가만 하면 됨).

### 17 상품 상세 (구매하기)
- **표시**: 상품 사진, 농가 헤더, **옵션/규격 선택**(보통/대/세척무 등 가격 상이), 수량, 장바구니/주문.
- **백엔드 `options[]`(V24)**: 각 옵션 = `{id, quantity, unit, price}`. 라벨을 열거하지 않고 수량+단위(자유)+가격으로 반-구조화. → ✅
- **남은 후속**: 장바구니에서 **선택한 옵션** 식별(`cart_items.option_id`)은 cart 변경이 필요해 future. 현재는 상품/옵션 등록·표시까지.

> 구현 방식: 별도 `product` 테이블 신설 대신 `producer_offers` 확장(cart가 이미 `offerId` 참조). 사진/태그/옵션은 정규화 테이블(`offer_photos`/`offer_tags`/`offer_options`).

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

### 21f 판매자 통계 (신규) — ✅ 구현됨 (G7 해소)
- **표시(`ScreenSellerDashboard`)**: 판매 권한 사용자만 진입. KPI 4종(**이번 달 매출**·**주문 건수**·**상품 조회수**·**전환율**, 각각 전월대비 증감률 ±%), **최근 7일 매출 막대차트**(일별 + 일 평균), **인기 상품 Top**(상품명·판매 건수·매출액), **다음 정산일**(2026.06.25). 마이페이지에는 "판매자 센터" 진입 카드(**오늘 매출·주문 건수**)도 노출.
- **구현**: `GET /api/v1/producers/me/stats` (`SellerStatsService`가 `orders`·`order_items`를 농가 기준 집계). 인증 필요.
  - `summary`: `monthlyRevenue`, `orderCount`, `monthlyRevenueChangeRate`·`orderCountChangeRate`(전월대비 %, 전월 0이면 null), `todayRevenue`, `todayOrderCount`(마이 카드용), `viewCount`·`conversionRate`(현재 **null** — 상품 조회 이벤트 미수집, 후속), `nextSettlementDate`.
  - `revenueSeries[]`: 최근 7일 `{date, amount}`(과거→오늘) + `dailyAverage`.
  - `topProducts[]`: `{offerId, title, ingredientName, soldCount, amount}` — **상품(offer) 단위** 집계(V27, 상위 5). 주문 시 `order_items.offer_id`·`offer_title` 스냅샷을 남겨 offer별로 묶음. 프론트는 `title` 우선·없으면 `ingredientName` fallback. 과거(offer_id null) 주문만 식재료명 기준 fallback.
  - 날짜 기준: `Asia/Seoul` 고정. `todayRevenue`/`todayOrderCount`, 이번 달·전월, 최근 7일 시리즈는 주문 시각을 한국 달력 날짜로 환산해 집계한다.
  - 정산일: 매월 25일 가정(MVP). 조회수·전환율 정확화는 `offer_view_events` 수집이 선행 과제(2차).

---

## 8. 농가 연결 & 주문 (22~24)

### 22 장바구니 — ✅
- **표시**: **농가별 그룹**, 항목(이름·수량·단위·단가·소계), 농가별 배송비, 상품금액/배송비/결제예정.
- **연동**: `GET /cart`(groups[producerId/producerName/items/subtotal/shipping] + itemsTotal/shippingTotal/payTotal), `POST /cart/items`(offerId+qty), `PATCH`/`DELETE`. ✅
- **참고**: 담기는 **offerId 기반**, 가격/이름은 offer 스냅샷.

### 23 주문 완료 — ✅
- **연동**: `POST /orders`(장바구니→주문), `GET /orders/{id}`. ✅

### 24 판매 등록(상품) — ✅ 구현됨 (G8 해소) / 🟡 AI
- **표시(`ScreenFarmUpload`, 2026-06-12 필드 추가)**: 상품 사진(최대 10·첫장 대표), **AI 자동완성**(사진 분석 → 상품명·설명·추천가격, AI추천⇄직접 토글), 상품명, 식재료 카테고리, **인증마크(필수, 1개+)**, 판매 가격·단위, **재고 수량(실시간 판매가능)**, 수확·배송 정보, **보관방법(필수, 선택+설명)**, 신선도·원산지 소개(0/500).
- **이미 ✅**: ingredientName/price/unit/freshnessLabel + title·description·category·photoUrls[]·tags[]·options[] (V23/V24). 신선도·원산지 소개 = `description`/`freshnessLabel`로 수용.
- **G8 신규 필드 3종 — ✅ 구현됨** (`CreateOfferRequest`·`ProducerOffer`·`ProducerOfferResponse` + **V26**):
  - **인증마크** `certifications[]`(무농약/유기농/GAP/친환경/지리적표시) — `offer_certifications` 정규화 테이블. 요청 `@NotEmpty`(**필수 ≥1**, 비면 400).
  - **재고 수량** `stockQuantity`(Integer, `@Min(0)`, 선택) — `producer_offers.stock_quantity`.
  - **보관방법** `storageMethod`(`@NotBlank` **필수**) + `storageNote`(설명, 선택) — `producer_offers.storage_method`/`storage_note`.
- **남은 갭 G2(판매자 AI)**: 사진 분석 기반 상품명/설명/추천가격 자동생성은 미구현(future). 화면 "직접 작성"으로 동작.
- **갭 G2(판매자 AI)**: 화면이 "사진 업로드 → 분석 → 상품명·설명·추천가격 자동 채움"으로 구체화됨. 이미지 분석 기반 생성 엔드포인트 필요(future). 미구현 시 "직접 작성"으로 동작.

### (신규) 21e 판매자 등록(신원/자격) — ✅
- 상품 등록과 별개의 농가 신원 등록 단계. 상세는 §11 참조. `POST /producers/me`.

---

## 9. 데이터 모델 갭 정리 (백엔드 작업 후보)

우선순위 순.

1. ~~**(높음·G1/G5) `producer_offers`를 "상품"으로 확장**~~ — ✅ **완료**(V23 title/description/category + `offer_photos`/`offer_tags`, V24 `offer_options`).
2. ~~**(높음·G8) offer 추가 필드 3종**~~ — ✅ **완료**(V26 `offer_certifications` + `stock_quantity`·`storage_method`·`storage_note`. 요청 `certifications` `@NotEmpty`·`storageMethod` `@NotBlank`).
3. ~~**(높음·G7) 판매자 통계 `GET /producers/me/stats`**~~ — ✅ **완료**(`SellerStatsService`: 매출·주문·인기상품·7일추이·전월대비·정산일). 인기상품은 **상품(offer) 단위**(V27 `order_items.offer_id`·`offer_title` 스냅샷, 과거 행만 식재료명 fallback). **조회수·전환율**은 `offer_view_events` 미수집이라 null(2차 잔여).
4. **(중간·G4) `user_preferences`에 라이프스타일 다중 태그** — `lifestyles[]`(신선/저렴/유기농/프리미엄/친환경/빠른배송). 농가 `style` 매칭·개인화에 사용.
5. **(중간) offer/specialty `ingredientId` 백필** — 식재료↔농가↔레시피 교차(15 비교, 19 농가구매)를 이름매칭이 아닌 ID로.
6. **(낮음·G3) OAuth** — 카카오/애플/구글. 화면 04 1차 노출. future.
7. **(낮음·G2) 판매자 AI** — 사진 분석 → 상품명/설명/추천가격 생성. 화면 24. future, 요청/응답 스펙 선확정 필요.
8. **(낮음·G6) 검색 `PRODUCT` 타입** — `/search` 정규식에 `PRODUCT` 추가 + offer 인덱싱(현재 `ALL|INGREDIENT|RECIPE`만).
9. **(낮음) 제철 큐레이션 BFF** — `GET /curations/{ingredientId}`(히어로+포인트+레시피+농가 묶음). 선택사항(기존 3 API 조합으로 대체 가능).
10. **(낮음) 홈 가격대 range** — 캐러셀 "2,100~2,800" 표시용 min/max. 없으면 프론트가 currentPrice만 표시.

## 10. "이미 잘 돼 있어 손 안 대도 되는 것"
홈, 식재료 상세(+가격이력), 농가 비교/상세(+소식/리뷰), 레시피 상세(+조리순서·가격추세), 릴스(반응 포함), 장바구니/주문, 마이페이지 요약, 찜, 알림, 가격알림, 검색/인기·최근검색, 농가 자가등록(상품 외 프로필) — **DTO·엔티티가 화면 요구를 충족**합니다. 일부는 화면보다 데이터가 더 많습니다(식재료 상세, 마이 요약).

---

## 11. 변경 반영 — 판매자 등록 화면(21e) (2026-06-11)

프론트 커밋 c3f7367로 **판매자 등록 화면(21e `ScreenSellerRegister`)** 이 추가됨(상품 등록과 별개의 신원/자격 등록 단계). 기존 농가연결 화면은 22 장바구니 / 23 주문완료 / 24 판매등록(상품·AI)으로 재번호됨.

**화면 입력 → 백엔드 정렬 완료** (`POST /api/v1/producers/me`, RegisterProducerRequest):

| 화면 입력 | 백엔드 | 처리 |
| --- | --- | --- |
| 농가/농장 이름 | `name` | ✅ |
| 대표자 이름 | `representativeName` | ✅ 추가(V25) |
| 대표 지역 | `region` | ✅ |
| 연락처 | `contact` | ✅ 추가(V25) |
| 주요 판매 품목 | `specialties[]` | ✅ |
| 농가 인증 업로드 | `certificationImageUrl` | ✅ 추가(**필수** — 화면 필수에 맞춤, 심사는 추후) |
| 약관 동의 | `agreedToTerms` | ✅ 추가(필수 true, 미동의 400) |

화면에 없는 기존 요청 필드(스타일/가격대/신선도/배지/한줄소개/대표사진)는 **요청에서 제거**, 자가등록 시 기본값(style=VALUE/3/4)으로 채움. 대표자명·연락처·인증서류는 비공개라 공개 농가상세 응답엔 미노출.
> 이 변경으로 G3 표의 "실서비스 판매자 정보 Out of Scope" 중 대표자명·연락처·인증·약관은 해소됨. 사업자등록번호·정산계좌는 여전히 범위 밖.

---

## 12. 변경 반영 — 프론트 커밋 58656da (2026-06-12)

`feat: 하단 탭 정렬, 제철 큐레이션, 판매자 통계 페이지 추가`. 화면 3건 변동 + 탭/번호 재정렬.

**바뀐 화면**

| 변경 | 화면 | 컴포넌트 | 백엔드 영향 |
| --- | --- | --- | --- |
| 신규 | **07 제철 큐레이션**(홈 배너 진입) | `ScreenSeasonalCuration` (screens-home) | ✅ 기존 API 조합(§3a). 전용 BFF는 선택 |
| 신규 | **21f 판매자 통계**(판매자 센터) | `ScreenSellerDashboard` (screens-misc) | ✅ **G7 구현됨** `GET /producers/me/stats`(§7) |
| 필드 추가 | **24 판매등록** | `ScreenFarmUpload` (screens-farm) | ✅ **G8 구현됨** 인증마크·재고·보관방법 + V26(§8) |
| UX | 하단 탭 5슬롯(홈·정보·**상품**·릴스·마이) | `phone.jsx` | 없음(정적) |
| 번호 | 07 홈메인 → **06**, 07=큐레이션, 21f=통계 | `app.jsx` | 문서 번호만 갱신 |

**백엔드 작업 결과**

1. ✅ **G8 — offer 필드 3종 + V26** 완료: `certifications[]`(`@NotEmpty` 필수≥1·`offer_certifications` 정규화), `stockQuantity`(`@Min(0)`), `storageMethod`(`@NotBlank` 필수)+`storageNote`. `CreateOfferRequest`·`ProducerOffer`·`ProducerOfferResponse`·`ProducerService` 반영.
2. ✅ **G7 — `GET /producers/me/stats`** 완료: `SellerStatsService`가 `orders`/`order_items`를 농가 기준 집계(매출·주문·인기상품·7일추이·전월대비·정산일). `todayRevenue`/`todayOrderCount` 동일 응답 포함. 인기상품은 **상품(offer) 단위**(V27 스냅샷, 과거 행만 식재료명 fallback). **조회수·전환율은 `offer_view_events` 미수집이라 null(2차 잔여)**.
3. 🟡 **G2**(future): AI 자동완성("사진 분석 → 상품명/설명/추천가격")은 미구현. 이미지 입력 기반 생성 스펙 선확정 필요.

> **남은 후속(2차)**: ① 상품 조회 이벤트(`offer_view_events`) 수집 → 통계 조회수·전환율 채우기, ~~② 주문 시 `order_items.offer_id`·`offer_title` 스냅샷 → 인기상품 offer 단위 집계~~ ✅ **완료(V27)**, ~~③ 통계 날짜 기준을 `Asia/Seoul`로 고정~~ ✅ **완료**(`SellerStatsService.BUSINESS_ZONE`), ④ 인증마크/보관방법 시드 백필.

> 07 제철 큐레이션은 **신규 백엔드 불필요** — `/ingredients/{id}`(+`/producers`)·`/recipes`·`/home`으로 조립. 호출 단순화가 필요하면 §9-9의 BFF 엔드포인트 검토.

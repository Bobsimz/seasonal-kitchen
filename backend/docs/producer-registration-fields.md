# 농가 등록 / 상품 등록 — 필드 값 참조 (프론트 연동용)

`POST /api/v1/producers/me` (농가 등록) · `POST /api/v1/producers/me/offers` (상품 등록)에서
프론트가 드롭다운/체크박스로 쓸 값 목록입니다.
요청/응답 예시와 화면별 호출 흐름은 canonical 문서인 `frontend-api-guide.md`를 기준으로 봅니다.

## 농가 등록 (RegisterProducerRequest) — `POST /api/v1/producers/me`

판매자 등록 화면(21e)에 맞춘 필드. **스타일/가격대/신선도/배지/한줄소개/대표사진은 등록 화면에서 받지 않으며**,
자가등록 시 기본값(style=VALUE, priceLevel=3, freshnessLevel=4)으로 채워진다(컬럼은 유지).

| 필드 | 타입 | 필수 | 비고 |
| --- | --- | --- | --- |
| `name` | string(≤100) | ✅ | 농가/농장 이름 |
| `representativeName` | string(≤50) | ✅ | 대표자 실명 |
| `region` | string(≤100) | ✅ | 대표 지역 |
| `contact` | string(≤30) | ✅ | 연락처 (예: 010-1234-5678) |
| `specialties` | string[] | — | 주요 판매 품목(식재료명). `GET /api/v1/ingredients`의 name 권장 |
| `certificationImageUrl` | string(≤500) | ✅ | 농가 인증 서류 이미지 URL(화면 필수). 심사는 추후 |
| `agreedToTerms` | boolean | ✅ (true) | 판매자 약관·정산정책 동의. false면 400 검증 오류 |

요청 예:
```jsonc
{ "name":"해남 송지농원", "representativeName":"김상도", "region":"전남 해남",
  "contact":"010-1234-5678", "specialties":["무","배추","봄동"],
  "certificationImageUrl":"https://cert/test.png", "agreedToTerms":true }
```
> 응답은 `ProducerDetailResponse`(기존 그대로). style/priceLevel/badges 등은 기본값으로 반환된다.
> 대표자명·연락처·인증서류는 판매자 비공개 정보라 공개 농가 상세 응답에는 노출하지 않고 저장만 한다.

## 상품 등록 (CreateOfferRequest)

| 필드 | 타입 | 필수 | 허용/권장 값 | 비고 |
| --- | --- | --- | --- | --- |
| `ingredientId` | long | — | 실제 식재료 ID | 주면 비교/검색 연동 정확. 잘못된 ID는 `INGREDIENT_NOT_FOUND`(404) |
| `ingredientName` | string(≤50) | ✅ | 식재료명 | ingredientId 없으면 이름으로 자동 연결 시도 |
| `price` | number ≥0 | ✅ | 원 | |
| `unit` | string(≤30) | ✅ | 아래 권장 단위 | |
| `freshnessLabel` | string(≤50) | — | 아래 권장 값 | |

### unit (권장 — 자유 텍스트)
`개`, `봉`, `포기`, `단`, `kg`, `100g`, `500g`, `접`, `망` 등 (KAMIS 단위는 품목마다 상이)

### freshnessLabel (권장)
`당일수확`, `수확 1일 이내`, `산지직송`

## 참고
- specialties / 상품의 ingredientName은 **`GET /api/v1/ingredients`** 응답의 `name`을 쓰면 식재료별 농가 비교(`GET /api/v1/ingredients/{id}/producers`)와 정확히 연동됩니다.
- 상품 등록 시 해당 ingredientName이 농가 specialty에 없으면 자동 추가(upsert)되어 농가 검색에도 노출됩니다.

## 상품 확장 필드 (V23, offer→상품) — `POST /api/v1/producers/me/offers`

기존 필드(ingredientName/price/unit/freshnessLabel)에 더해 아래 **상품 속성**을 선택적으로 보낼 수 있다(모두 optional, 없으면 기존처럼 동작).

| 필드 | 타입 | 허용/권장 | 비고 |
| --- | --- | --- | --- |
| `title` | string(≤150) | 자유 | 상품명. 예) "햇 봄동 1.5kg 산지직송". 없으면 식재료명 사용 |
| `description` | string(≤1000) | 자유 | 상품 설명 |
| `category` | string(≤30) | 잎채소/뿌리채소/과일/곡류/버섯/기타 | 상품 카테고리 |
| `photoUrls` | string[] | URL(각 ≤500) | **첫 번째가 대표 이미지** |
| `tags` | string[] | 산지직송/무료배송/콜드체인/유기농/예약판매/대용량 등(각 ≤40) | 자유 텍스트 자기신고 |

응답(`ProducerOfferResponse`)에도 `title/description/category/photoUrls/tags`가 포함된다(사진/태그 없으면 빈 배열).
이 필드들은 농가 상품 목록(`GET /producers/{id}/offers`)·식재료별 농가 비교(`GET /ingredients/{id}/producers`) 응답에도 함께 반환된다.
> 화면 16 상품리스트 / 17 상품상세 / 25 판매등록 근거. (상품 옵션/규격 variant는 별도 작업 G5)

## 상품 옵션(규격/variant) — V24, `options[]`

한 상품에 규격이 여러 개일 때(예: 보통 1.2kg / 대 1.8kg / 세척무 1.0kg) 옵션으로 받는다. 선택사항.
**라벨을 강제 열거하지 않고** 수량+단위(자유, 추천목록 UX 권장)+가격으로 반-구조화한다.

| 필드 | 타입 | 필수 | 비고 |
| --- | --- | --- | --- |
| `options[].quantity` | number | — | 수량(예: 1.5). 선택 |
| `options[].unit` | string(≤30) | — | 단위(예: kg/단/개). 추천목록+직접입력. 선택 |
| `options[].price` | number ≥0 | ✅ | 옵션 가격. **필수** — 없으면 400 검증 오류 |

요청 예:
```jsonc
"options": [
  { "quantity": 1.5, "unit": "kg", "price": 6900 },
  { "quantity": null, "unit": "단", "price": 4500 }
]
```
응답(`ProducerOfferResponse.options[]`)은 `{id, quantity, unit, price}`를 정렬 순서대로 반환(없으면 빈 배열).
> 입력 오류 대비: 가격/수량 같은 **숫자·연결값(ingredientId)은 엄격 검증**, 표시용 단위 라벨은 느슨(자유)하게. 가격비교/정렬은 ingredientId+price 기반이라 단위 라벨 오타에 영향 없음.
> 장바구니의 옵션 선택(option_id)은 후속 작업.

## 인증마크 · 재고 · 보관방법 — V26, `POST /api/v1/producers/me/offers`

판매등록 화면(24 `ScreenFarmUpload`, 2026-06-12)에 맞춰 추가된 필드. **`certifications`·`storageMethod`는 필수.**

| 필드 | 타입 | 필수 | 허용/권장 값 | 비고 |
| --- | --- | --- | --- | --- |
| `certifications` | string[] | ✅ **1개 이상** | 무농약 / 유기농(유기농산물) / GAP(우수관리) / 친환경 / 지리적표시 (각 ≤40) | 빈 배열·누락 시 400(`@NotEmpty`) |
| `stockQuantity` | int ≥0 | — | 실시간 판매 가능 수량 | 미설정 시 null |
| `storageMethod` | string(≤30) | ✅ | 냉장 보관 / 냉동 보관 / 실온 보관 / 서늘한 그늘 | 비면 400(`@NotBlank`) |
| `storageNote` | string(≤500) | — | 구매자 안내 설명 | 예) "신문지에 싸서 냉장 보관하면 2주까지 신선해요." |

요청 예:
```jsonc
"certifications": ["무농약", "유기농(유기농산물)"],
"stockQuantity": 120,
"storageMethod": "냉장 보관",
"storageNote": "신문지에 싸서 냉장 보관하면 2주까지 신선해요. 흙은 털지 말고 보관하세요."
```
응답(`ProducerOfferResponse`)에도 `certifications[]`(없으면 빈 배열)·`stockQuantity`·`storageMethod`·`storageNote`가 포함된다.
> ⚠️ V26부터 상품 등록 요청에 `certifications`(1개+)·`storageMethod`가 **필수**다. 기존 연동 코드가 이 두 필드를 안 보내면 400이 난다.

## 판매자 통계 — `GET /api/v1/producers/me/stats`

화면 21f(판매자 통계)·마이 판매자 센터 카드용. 응답 `SellerStatsResponse`:
`summary`(monthlyRevenue·orderCount·전월대비 changeRate·todayRevenue·todayOrderCount·viewCount/conversionRate(후속 null)·nextSettlementDate), `revenueSeries[]`(최근 7일 {date, amount}), `dailyAverage`, `topProducts[]`({offerId, title, ingredientName, soldCount, amount} 상위 5).
> **인기상품은 상품(offer) 단위 집계**(V27). 주문 시 `order_items.offer_id`·`offer_title` 스냅샷을 남겨 offer별로 묶는다. 프론트는 `title` 우선, 없으면 `ingredientName` fallback. V27 이전 과거 주문(offer_id null)만 식재료명 기준 fallback 집계되고 `offerId`·`title`은 null. 조회수·전환율은 상품 조회 이벤트 수집 후 제공(현재 null).
> 날짜 기준은 `Asia/Seoul`로 고정된다. `todayRevenue`/`todayOrderCount`, 이번 달·전월, 최근 7일 시리즈는 주문 시각을 한국 달력 날짜로 환산해 집계한다.

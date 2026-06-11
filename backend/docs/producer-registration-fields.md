# 농가 등록 / 상품 등록 — 필드 값 참조 (프론트 연동용)

`POST /api/v1/producers/me` (농가 등록) · `POST /api/v1/producers/me/offers` (상품 등록)에서
프론트가 드롭다운/체크박스로 쓸 값 목록입니다.
요청/응답 예시와 화면별 호출 흐름은 canonical 문서인 `frontend-api-guide.md`를 기준으로 봅니다.

## 농가 등록 (RegisterProducerRequest)

| 필드 | 타입 | 필수 | 허용/권장 값 | 비고 |
| --- | --- | --- | --- | --- |
| `name` | string(≤100) | ✅ | 자유 | 농가/생산자명 |
| `region` | string(≤100) | ✅ | 자유 | 시·군 단위 권장 ("경북 영천") |
| `tagline` | string(≤300) | — | 자유 | 한 줄 소개 |
| `photoUrl` | string(≤500) | — | URL | 대표 사진 |
| `style` | enum | ✅ | **`VALUE` / `ORGANIC` / `PREMIUM`** | 아래 표 참고 |
| `priceLevel` | int 1~5 | — | 1~5 (기본 3) | 가격대 자가표시 |
| `freshnessLevel` | int 1~5 | — | 1~5 (기본 4) | 신선도 자가표시 |
| `specialties` | string[] | — | 식재료명 | `GET /api/v1/ingredients`의 name 사용 권장 |
| `badges` | string[] | — | 아래 권장 목록 | 자유 텍스트(자기신고). enum 강제 아님 |

### style (enum, 고정)
| 코드 | 라벨(프론트 표시 예) |
| --- | --- |
| `VALUE` | 저렴이·실속형 |
| `ORGANIC` | 유기농·무농약 |
| `PREMIUM` | 프리미엄·싱싱 |

### badges (권장 목록 — 자유 텍스트라 강제는 아님)
시드/디자인에서 쓰인 값:

`산지직송`, `당일수확`, `유기농 인증`, `무농약`, `대량 할인`, `가성비`, `프리미엄`, `고랭지`, `새벽 출고`, `콜드체인`

> 프론트는 위 목록을 체크박스로 제공하고, 필요 시 자유 입력도 허용 가능.
> "유기농 인증" 등 검증이 필요한 배지도 현재는 자기신고(인증 심사는 future).

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

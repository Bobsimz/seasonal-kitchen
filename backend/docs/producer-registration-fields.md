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

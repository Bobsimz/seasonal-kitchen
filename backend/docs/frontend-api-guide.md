# Frontend API Guide

프론트엔드가 바로 붙일 수 있는 현재 구현 기준 API 정리입니다.
**이 문서가 프론트 연동의 단일 기준(canonical)** 입니다. 다른 `frontend-*.md`(gap-analysis, screen-api-coverage, required-fields 등)는 분석/이력용 배경자료이니 참고만 하세요.

> **필드 단위 계약서는 Swagger가 가장 정확합니다.** 모든 DTO에 필드 설명/예시가 붙어 있어요: `http://localhost:8080/swagger-ui/index.html` (JSON: `/v3/api-docs`). 이 문서는 "어떤 API가 있고 어떤 흐름인지" 지도 역할, Swagger는 "필드 상세" 역할.
> 인증 API는 가입/로그인 후 받은 `accessToken`을 Swagger 우상단 **Authorize**에 넣으면 호출됩니다.

## 1. 기본 규칙

- Base URL: `http://localhost:8080`
- API prefix: `/api/v1`
- 응답은 항상 공통 래퍼를 사용합니다.
- 날짜/시간은 ISO 8601 문자열입니다.
- 금액은 숫자입니다. 콤마/원 표시는 프론트에서 처리합니다.
- 현재 인증은 email/password 로그인 + JWT access token만 구현되어 있습니다.
- OAuth, refresh token, logout은 추후 고도화 항목입니다.

### Common response

```json
{
  "success": true,
  "data": {},
  "error": null,
  "traceId": null
}
```

### Common error

```json
{
  "success": false,
  "data": null,
  "error": {
    "code": "AUTH_INVALID_CREDENTIALS",
    "message": "이메일 또는 비밀번호가 올바르지 않습니다.",
    "fieldErrors": []
  },
  "traceId": null
}
```

### 인증 헤더

로그인/회원가입 응답의 `data.accessToken`을 저장한 뒤 인증 필요 API에 넣습니다.

```http
Authorization: Bearer <accessToken>
```

## 2. 인증 필요 여부

| API | 인증 |
| --- | --- |
| `POST /api/v1/auth/signup` | 불필요 |
| `POST /api/v1/auth/login` | 불필요 |
| `GET /api/v1/producers`, `/api/v1/producers/{id}`, `/api/v1/producers/{id}/offers`, `/api/v1/producers/{id}/reviews`, `/api/v1/producers/{id}/news` | 불필요 |
| `GET /api/v1/producers/me` | 필요 |
| `POST /api/v1/producers/me` | 필요 |
| `POST /api/v1/producers/me/offers` | 필요 |
| `GET /api/v1/ingredients/**` | 불필요 |
| `GET /api/v1/recipes/**` | 불필요 |
| `GET /api/v1/reels/**` | 불필요 |
| `GET /api/v1/search/**` | 불필요 |
| `GET /api/v1/home` | 불필요 |
| `GET /api/v1/cart` | 필요 |
| `POST /api/v1/cart/items` | 필요 |
| `PATCH /api/v1/cart/items/{cartItemId}` | 필요 |
| `DELETE /api/v1/cart/items/{cartItemId}` | 필요 |
| `POST /api/v1/orders` | 필요 |
| `GET /api/v1/orders` | 필요 |
| `GET /api/v1/orders/{orderId}` | 필요 |
| `POST /api/v1/producers/{producerId}/reviews` | 필요 |
| `GET /api/v1/favorites` | 필요 |
| `POST /api/v1/favorites` | 필요 |
| `DELETE /api/v1/favorites/{favoriteId}` | 필요 |
| `GET /api/v1/users/me` | 필요 |
| `GET /api/v1/users/me/summary` | 필요 |

## 3. 화면별 우선 연동

| 화면 | 호출 API | 비고 |
| --- | --- | --- |
| 회원가입 | `POST /api/v1/auth/signup` | 성공 시 바로 로그인 상태 처리 가능 |
| 로그인 | `POST /api/v1/auth/login` | `accessToken` 저장 |
| 상품 탭 | `GET /api/v1/producers` | 현재 상품 탭은 농가/오퍼 기반으로 연동 |
| 농가 상세 | `GET /api/v1/producers/{producerId}` | 기본 프로필 |
| 농가 상품 목록 | `GET /api/v1/producers/{producerId}/offers` | 장바구니에는 여기서 받은 `id`를 `offerId`로 사용 |
| 상품 상세 | `GET /api/v1/producers/{producerId}/offers` + `GET /api/v1/ingredients/{ingredientId}` | 전용 product detail API는 아직 없음 |
| 식재료 정보 | `GET /api/v1/ingredients/{ingredientId}` | 기존 식재료 & 레시피 탭 |
| 식재료 관련 레시피 | `GET /api/v1/ingredients/{ingredientId}/recipes` | 레시피 카드 목록 |
| 식재료 농가 비교 | `GET /api/v1/ingredients/{ingredientId}/producers` | 가격순 농가 비교 |
| 장바구니 | `GET /api/v1/cart` | 농가별 그룹/배송비 포함 |
| 주문 완료 | `POST /api/v1/orders` | 현재 장바구니를 모의 주문으로 전환 |
| 주문 내역 | `GET /api/v1/orders` | 마이페이지 주문 목록 |
| 검색 | `GET /api/v1/search?q=무&type=ALL` | 현재 type은 `ALL`, `INGREDIENT`, `RECIPE` |
| 마이페이지 | `GET /api/v1/users/me/summary` | 프로필/통계/메뉴 카운트 |

## 4. Auth

### POST `/api/v1/auth/signup`

Request:

```json
{
  "email": "user@example.com",
  "password": "password123",
  "nickname": "제철러버"
}
```

Response:

```json
{
  "success": true,
  "data": {
    "accessToken": "eyJhbGciOiJ...",
    "tokenType": "Bearer",
    "userId": 1,
    "nickname": "제철러버"
  },
  "error": null,
  "traceId": null
}
```

주요 오류:

| code | status | 의미 |
| --- | --- | --- |
| `AUTH_EMAIL_DUPLICATE` | 409 | 이미 가입된 이메일 |
| `AUTH_NICKNAME_DUPLICATE` | 409 | 이미 사용 중인 닉네임 |
| `COMMON_VALIDATION_FAILED` | 400 | 이메일 형식, 비밀번호 길이 등 검증 실패 |

### POST `/api/v1/auth/login`

Request:

```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

Response는 signup과 동일합니다.

주요 오류:

| code | status | 의미 |
| --- | --- | --- |
| `AUTH_INVALID_CREDENTIALS` | 401 | 이메일 또는 비밀번호 불일치 |

## 5. Producers and Offers

### GET `/api/v1/producers`

농가 목록/검색 API입니다. 상품 탭의 1차 목록으로 사용합니다.

Query:

| name | type | required | example | 설명 |
| --- | --- | --- | --- | --- |
| `q` | string | no | `봄동` | 식재료명/농가명 검색 |
| `style` | string | no | `ORGANIC` | `VALUE`, `ORGANIC`, `PREMIUM` |
| `honorary` | boolean | no | `true` | 명예 농가 필터 |
| `page` | number | no | `0` | 0부터 시작 |
| `size` | number | no | `20` | 페이지 크기 |

Response:

```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": 2,
        "name": "홍진이",
        "region": "경기오산",
        "tagline": "텃밭에서 갓 딴 유기농 봄동",
        "photoUrl": null,
        "style": "ORGANIC",
        "rating": 4.8,
        "reviewCount": 642,
        "honorary": true,
        "specialties": ["봄동", "배추", "시금치"],
        "badges": ["유기농 인증", "무농약"]
      }
    ],
    "page": 0,
    "size": 20,
    "totalElements": 1,
    "hasNext": false
  },
  "error": null,
  "traceId": null
}
```

### GET `/api/v1/producers/{producerId}`

농가 상세 상단 프로필에 사용합니다.

```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "권민성",
    "region": "경북영천",
    "tagline": "콩밭 매는 아낙네, 정성으로 키운 잡곡",
    "photoUrl": null,
    "style": "PREMIUM",
    "priceLevel": 5,
    "freshnessLevel": 5,
    "rating": 4.9,
    "reviewCount": 1280,
    "honorary": true,
    "specialties": ["콩", "봄동", "시금치", "무"],
    "badges": ["산지직송", "당일수확"]
  },
  "error": null,
  "traceId": null
}
```

### GET `/api/v1/producers/{producerId}/offers`

농가가 판매하는 상품 목록입니다. 응답의 `id`가 장바구니 담기용 `offerId`입니다.

```json
{
  "success": true,
  "data": [
    {
      "id": 10,
      "producerId": 1,
      "producerName": "권민성",
      "region": "경북영천",
      "ingredientName": "봄동",
      "ingredientId": 12,
      "price": 5310,
      "unit": "봉",
      "freshnessLabel": "당일수확",
      "title": "햇 봄동 1.5kg 산지직송",
      "description": "남도 텃밭에서 새벽 수확",
      "category": "잎채소",
      "photoUrls": ["https://img/1.png"],
      "tags": ["산지직송", "무료배송"],
      "options": [{ "id": 100, "quantity": 1.5, "unit": "kg", "price": 6900 }],
      "certifications": ["무농약", "유기농(유기농산물)"],
      "stockQuantity": 120,
      "storageMethod": "냉장 보관",
      "storageNote": "신문지에 싸서 냉장 보관하면 2주까지 신선해요."
    }
  ],
  "error": null,
  "traceId": null
}
```

### GET `/api/v1/ingredients/{ingredientId}/producers`

식재료 상세에서 농가별 가격 비교에 사용합니다.

```json
{
  "success": true,
  "data": [
    {
      "id": 31,
      "producerId": 3,
      "producerName": "김상도",
      "region": "전남해남",
      "ingredientName": "봄동",
      "ingredientId": 12,
      "price": 4090,
      "unit": "봉",
      "freshnessLabel": "수확 1일 이내"
    }
  ],
  "error": null,
  "traceId": null
}
```

`ingredientId`는 백필 전 데이터에서 `null`일 수 있습니다. 프론트는 상세 이동 시 가능하면 현재 화면의 `ingredientId`를 유지해서 넘깁니다.

## 6. Cart and Orders

### POST `/api/v1/cart/items`

농가 상품을 장바구니에 담습니다. 클라이언트는 가격/상품명을 보내지 않고 `offerId`, `qty`만 보냅니다.

Request:

```json
{
  "offerId": 10,
  "qty": 2
}
```

Response:

```json
{
  "success": true,
  "data": {
    "groups": [
      {
        "producerId": 1,
        "producerName": "권민성",
        "items": [
          {
            "cartItemId": 100,
            "ingredientName": "봄동",
            "qty": 2,
            "unitPrice": 5310,
            "unit": "봉"
          }
        ],
        "subtotal": 10620,
        "shipping": 3000
      }
    ],
    "itemsTotal": 10620,
    "shippingTotal": 3000,
    "payTotal": 13620
  },
  "error": null,
  "traceId": null
}
```

배송비 규칙: 농가별 3,000원, 농가별 소계 30,000원 이상이면 무료.

### GET `/api/v1/cart`

현재 로그인 사용자의 장바구니를 조회합니다. 응답 형태는 장바구니 담기와 동일합니다.

### PATCH `/api/v1/cart/items/{cartItemId}`

Request:

```json
{
  "qty": 3
}
```

Response는 갱신된 cart 전체입니다.

### DELETE `/api/v1/cart/items/{cartItemId}`

Response:

```json
{
  "success": true,
  "data": null,
  "error": null,
  "traceId": null
}
```

삭제 후 화면 갱신은 `GET /api/v1/cart`를 다시 호출하는 방식이 안전합니다.

### POST `/api/v1/orders`

현재 장바구니를 주문으로 전환합니다. 요청 본문은 없습니다.

```json
{
  "success": true,
  "data": {
    "id": 5001,
    "orderNumber": "20260610-142233456-3f9a",
    "status": "PAID",
    "itemsTotal": 10620,
    "shippingFee": 3000,
    "totalAmount": 13620,
    "pointsEarned": 106,
    "orderedAt": "2026-06-10T14:22:33+09:00",
    "items": [
      {
        "producerName": "권민성",
        "ingredientName": "봄동",
        "qty": 2,
        "unitPrice": 5310
      }
    ]
  },
  "error": null,
  "traceId": null
}
```

### GET `/api/v1/orders`

```json
{
  "success": true,
  "data": [
    {
      "id": 5001,
      "orderNumber": "20260610-142233456-3f9a",
      "status": "PAID",
      "totalAmount": 13620,
      "summary": "봄동 외 1건",
      "orderedAt": "2026-06-10T14:22:33+09:00"
    }
  ],
  "error": null,
  "traceId": null
}
```

### GET `/api/v1/orders/{orderId}`

주문 상세 화면에 사용합니다. 응답은 `POST /api/v1/orders`와 동일한 `OrderResponse`입니다.

## 7. Reviews and Favorites

### GET `/api/v1/producers/{producerId}/reviews`

공개 조회입니다.

```json
{
  "success": true,
  "data": [
    {
      "id": 100,
      "author": "민지",
      "rating": 5,
      "item": "콩",
      "body": "경북영천에서 바로 받아서 그런지 정말 싱싱해요.",
      "createdAt": "2026-05-30T10:00:00+09:00"
    }
  ],
  "error": null,
  "traceId": null
}
```

### POST `/api/v1/producers/{producerId}/reviews`

MVP에서는 배송완료 주문 검증 없이 로그인 사용자가 자유 작성합니다.

Request:

```json
{
  "rating": 5,
  "item": "봄동",
  "body": "정말 싱싱해요. 또 주문할게요!"
}
```

### POST `/api/v1/favorites`

현재 지원 대상은 `INGREDIENT`, `RECIPE`, `PRODUCER`입니다.

Request:

```json
{
  "targetType": "PRODUCER",
  "targetId": 1
}
```

Response:

```json
{
  "success": true,
  "data": {
    "id": 10,
    "targetType": "PRODUCER",
    "targetId": 1
  },
  "error": null,
  "traceId": null
}
```

## 8. Search

### GET `/api/v1/search?q=무&type=ALL`

현재 `type`은 `ALL`, `INGREDIENT`, `RECIPE`만 허용합니다.
기획상 상품 검색 카테고리는 필요하지만 아직 코드에는 `PRODUCT` 타입이 없습니다.

```json
{
  "success": true,
  "data": {
    "items": [
      {
        "type": "INGREDIENT",
        "id": 1,
        "title": "무",
        "description": "제철 식재료",
        "imageUrl": null
      }
    ],
    "ingredients": [],
    "recipes": [],
    "reels": [],
    "ingredientCount": 1,
    "recipeCount": 0,
    "reelCount": 0
  },
  "error": null,
  "traceId": null
}
```

### GET `/api/v1/search/trending`

```json
{
  "success": true,
  "data": [
    {
      "keyword": "무",
      "searchCount": 10
    }
  ],
  "error": null,
  "traceId": null
}
```

## 9. Ingredients and Recipes

### GET `/api/v1/ingredients`

식재료 목록입니다. 정보 탭의 식재료 목록에 사용합니다.

### GET `/api/v1/ingredients/{ingredientId}`

식재료 상세 정보입니다.

### GET `/api/v1/ingredients/{ingredientId}/recipes`

해당 식재료를 사용하는 레시피 카드 목록입니다.

### GET `/api/v1/recipes/{recipeId}`

레시피 상세입니다. 레시피에서 필요한 재료 목록은 이 상세 응답에 포함됩니다.

## 10. 현재 비어 있거나 추후 필요한 API

| 필요 기능 | 현재 상태 | 프론트 임시 대응 |
| --- | --- | --- |
| 전용 상품 목록 `GET /api/v1/products` | 미구현 | `GET /api/v1/producers`와 offers 조합 사용 |
| 전용 상품 상세 `GET /api/v1/products/{id}` | 미구현 | `GET /api/v1/producers/{producerId}/offers` + `GET /api/v1/ingredients/{ingredientId}` 조합 |
| 판매 등록 `POST /api/v1/seller/products` | 미구현 | 현재는 `POST /api/v1/producers/me/offers` 사용 |
| 판매자 AI 가격 추천/홍보글 | 미구현 | 화면/스펙만 future로 유지 |
| 검색 `PRODUCT` 타입 | 미구현 | 현재 `ALL`, `INGREDIENT`, `RECIPE`만 사용 |
| refresh token/logout/OAuth | 미구현 | access token 만료 시 재로그인 |

## 11. 농가 자가등록 / 내 농가 (마이페이지 → 농가로 등록)

로그인 사용자가 본인을 농가로 등록하고 상품을 올린다. 한 사용자당 농가 1개. **인증 필요.**
입력값(스타일 enum, 배지/단위/신선도 권장 목록)은 `producer-registration-fields.md` 참조.

| 메서드 | 경로 | 설명 |
| --- | --- | --- |
| `POST` | `/api/v1/producers/me` | 농가로 등록. 이미 등록 시 `PRODUCER_ALREADY_REGISTERED`(409) |
| `GET` | `/api/v1/producers/me` | 내 농가 조회. 미등록 시 `PRODUCER_NOT_FOUND`(404) → "농가 등록" 버튼 노출 판단에 사용 |
| `POST` | `/api/v1/producers/me/offers` | 내 농가 상품(offer) 등록. 미등록 상태면 404 |
| `GET` | `/api/v1/producers/me/stats` | 내 농가 판매 통계(21f 판매자 통계 / 마이 판매자 센터 카드) |

```jsonc
// POST /api/v1/producers/me  (요청)
{ "name":"권민성", "region":"경북 영천", "tagline":"고랭지 무농약", "photoUrl":null,
  "style":"ORGANIC", "priceLevel":4, "freshnessLevel":5,
  "specialties":["봄동","무"], "badges":["산지직송","당일수확"] }
// 응답 data: ProducerDetailResponse (id, name, region, tagline, photoUrl, style,
//   priceLevel, freshnessLevel, rating=0, reviewCount=0, honorary=false, specialties[], badges[])

// POST /api/v1/producers/me/offers  (요청) — V26 필드 포함
{ "ingredientId":12, "ingredientName":"봄동", "price":4500, "unit":"봉", "freshnessLabel":"당일수확",
  "title":"햇 봄동 1.5kg 산지직송", "description":"남도 텃밭에서 새벽 수확", "category":"잎채소",
  "photoUrls":["https://img/1.png"], "tags":["산지직송","무료배송"],
  "options":[{ "quantity":1.5, "unit":"kg", "price":6900 }],
  "certifications":["무농약","유기농(유기농산물)"],   // ★ 필수(1개 이상). 빈 배열/누락 시 400
  "stockQuantity":120,                                // 선택(>=0)
  "storageMethod":"냉장 보관",                         // ★ 필수(비면 400)
  "storageNote":"신문지에 싸서 냉장 보관하면 2주까지 신선해요." } // 선택
// 응답 data: ProducerOfferResponse (… 기존 필드 + certifications[], stockQuantity, storageMethod, storageNote)
```
- 상품 등록 시 해당 ingredientName이 specialty에 없으면 자동 추가 → 농가 검색에도 노출.
- `ingredientId`를 주면 활성 식재료 검증(없으면 `INGREDIENT_NOT_FOUND`), 안 주면 이름으로 자동 연결.
- **필수 필드 주의**: `certifications`(1개 이상)·`storageMethod`는 V26부터 필수. 누락 시 400(검증 실패).

```jsonc
// GET /api/v1/producers/me/stats  (응답 data: SellerStatsResponse)
{ "summary": {
    "monthlyRevenue":4820000, "orderCount":186,
    "monthlyRevenueChangeRate":12.0, "orderCountChangeRate":8.0,   // 전월대비 %(전월 0이면 null)
    "todayRevenue":184000, "todayOrderCount":7,                    // 마이 판매자 센터 카드
    "viewCount":null, "conversionRate":null,                       // 조회 이벤트 미수집 → 후속(null)
    "nextSettlementDate":"2026-06-25" },
  "revenueSeries":[ { "date":"2026-06-06", "amount":62000 }, … 7일(과거→오늘) ],
  "dailyAverage":689000,
  "topProducts":[ { "offerId":10, "title":"햇 봄동 1.5kg 산지직송", "ingredientName":"봄동", "soldCount":64, "amount":537600 }, … 상위 5 ] }
```
- **인기상품은 상품(offer) 단위로 집계**된다(V27). 주문 시 `order_items`에 `offer_id`·`offer_title` 스냅샷을 남기고, 통계는 `offer_id` 기준으로 묶는다.
- 표시: **`title` 우선**, `title`이 null이면 `ingredientName`을 fallback으로 사용. (`title`은 주문 시점 상품명 스냅샷)
- V27 이전 과거 주문(`offer_id` null)은 `offerId`·`title`이 `null`이고 **식재료명 기준으로 fallback** 집계된다.
- 조회수·전환율은 상품 조회 이벤트 수집 후 채워짐(후속, 현재 null).
- 날짜 기준은 `Asia/Seoul`로 고정되어 있다. `todayRevenue`/`todayOrderCount`, 이번 달·전월, 최근 7일 시리즈는 주문 시각을 한국 달력 날짜로 환산해 집계한다.

## 12. 전체 엔드포인트 인벤토리

아래가 **현재 구현된 전부**입니다. 위 섹션에 예시가 없는 것도 Swagger에서 요청/응답 필드를 볼 수 있어요.
인증: 🔓 불필요 / 🔒 필요.

### 인증 / 사용자
| | 메서드 | 경로 | 설명 |
|---|---|---|---|
| 🔓 | POST | `/api/v1/auth/signup` | 이메일 회원가입(+JWT) |
| 🔓 | POST | `/api/v1/auth/login` | 이메일 로그인(+JWT) |
| 🔒 | GET | `/api/v1/users/me` | 내 기본 정보 |
| 🔒 | PATCH | `/api/v1/users/me` | 프로필(닉네임/사진) 수정 |
| 🔒 | GET | `/api/v1/users/me/summary` | 마이페이지 요약(통계/메뉴 카운트) |
| 🔒 | PUT | `/api/v1/users/me/preferences` | 가입 설문/선호(가구수·매움회피·우선순위·알러지) 저장 |
| 🔒 | GET | `/api/v1/users/me/recent-searches` | 최근 검색어 |
| 🔒 | GET | `/api/v1/users/me/reviews?status=written` | 내가 쓴 리뷰(writable은 future, 빈 배열) |

### 홈 / 검색 (🔓)
| | 메서드 | 경로 | 설명 |
|---|---|---|---|
| 🔓 | GET | `/api/v1/home` | 홈 화면(시즌 추천·재료·레시피·릴스·인기검색어·미읽음알림수) |
| 🔓 | GET | `/api/v1/search?q=&type=ALL\|INGREDIENT\|RECIPE` | 통합 검색 |
| 🔓 | GET | `/api/v1/search/trending` | 인기 검색어 |

### 식재료 (🔓)
| | 메서드 | 경로 | 설명 |
|---|---|---|---|
| 🔓 | GET | `/api/v1/ingredients` | 목록(페이지네이션) |
| 🔓 | GET | `/api/v1/ingredients/{id}` | 상세(영양·손질/보관팁·제철 등) |
| 🔓 | GET | `/api/v1/ingredients/{id}/prices` | 가격 이력(상세 차트용) |
| 🔓 | GET | `/api/v1/ingredients/{id}/substitutes` | 대체 식재료 |
| 🔓 | GET | `/api/v1/ingredients/{id}/offers` | 리테일 구매처 가격(스토어 오퍼) |
| 🔓 | GET | `/api/v1/ingredients/{id}/recipes` | 관련 레시피 |
| 🔓 | GET | `/api/v1/ingredients/{id}/producers` | **식재료별 농가 비교**(가격순) |

### 레시피 (🔓)
| | 메서드 | 경로 | 설명 |
|---|---|---|---|
| 🔓 | GET | `/api/v1/recipes` | 레시피 목록 |
| 🔓 | GET | `/api/v1/recipes/{id}` | 상세(재료·예상비용·태그·관련릴스) |
| 🔓 | GET | `/api/v1/recipes/{id}/steps` | 조리 순서 |

### 릴스 (조회 🔓 / 반응 🔒)
| | 메서드 | 경로 | 설명 |
|---|---|---|---|
| 🔓 | GET | `/api/v1/reels` | 릴스 피드 |
| 🔓 | GET | `/api/v1/reels/{id}` | 릴스 상세 |
| 🔓 | GET | `/api/v1/reels/{id}/comments` | 댓글 목록 |
| 🔒 | POST | `/api/v1/reels/{id}/likes` | 좋아요 |
| 🔒 | DELETE | `/api/v1/reels/{id}/likes` | 좋아요 취소 |
| 🔒 | POST | `/api/v1/reels/{id}/comments` | 댓글 작성 |
| 🔒 | POST | `/api/v1/reels/{id}/view-events` | 조회 이벤트 기록 |

### 농가 (조회 🔓 / 내 농가 🔒)
| | 메서드 | 경로 | 설명 |
|---|---|---|---|
| 🔓 | GET | `/api/v1/producers?q=&style=&honorary=` | 농가 목록/검색 |
| 🔓 | GET | `/api/v1/producers/{id}` | 농가 상세 |
| 🔓 | GET | `/api/v1/producers/{id}/offers` | 농가 판매 상품 |
| 🔓 | GET | `/api/v1/producers/{id}/reviews` | 농가 리뷰 |
| 🔓 | GET | `/api/v1/producers/{id}/news` | 농가 스토어 소식 |
| 🔒 | POST | `/api/v1/producers/{id}/reviews` | 리뷰 작성(자유) |
| 🔒 | POST | `/api/v1/producers/me` | 농가 자가등록 (§11) |
| 🔒 | GET | `/api/v1/producers/me` | 내 농가 조회 (§11) |
| 🔒 | POST | `/api/v1/producers/me/offers` | 내 농가 상품 등록 (§11). 인증마크·보관방법 필수 |
| 🔒 | GET | `/api/v1/producers/me/stats` | 내 농가 판매 통계 (§11) |

### 장바구니 / 주문 (🔒)
| | 메서드 | 경로 | 설명 |
|---|---|---|---|
| 🔒 | GET | `/api/v1/cart` | 장바구니(농가별 그룹·배송비·합계) |
| 🔒 | POST | `/api/v1/cart/items` | 담기(`offerId`+`qty`) |
| 🔒 | PATCH | `/api/v1/cart/items/{id}` | 수량 변경 |
| 🔒 | DELETE | `/api/v1/cart/items/{id}` | 삭제 |
| 🔒 | POST | `/api/v1/orders` | 주문 생성(모의 결제) |
| 🔒 | GET | `/api/v1/orders` | 주문 내역 |
| 🔒 | GET | `/api/v1/orders/{id}` | 주문 상세/완료 |

### 찜 / 가격알림 / 알림 (🔒)
| | 메서드 | 경로 | 설명 |
|---|---|---|---|
| 🔒 | GET/POST | `/api/v1/favorites`, `/favorites/{id}`(DELETE) | 찜(targetType: INGREDIENT/RECIPE/PRODUCER) |
| 🔒 | GET/POST | `/api/v1/price-alerts` | 가격 하락 알림 |
| 🔒 | PATCH/DELETE | `/api/v1/price-alerts/{id}` | 알림 수정/삭제 |
| 🔒 | GET | `/api/v1/notifications` | 알림 목록(+탭 카운트) |
| 🔒 | PATCH | `/api/v1/notifications/{id}/read` · `/read-all` | 읽음 처리 |

### 기타
| | 메서드 | 경로 | 설명 |
|---|---|---|---|
| 🔒 | POST | `/api/v1/events` | 사용자 행동 분석 이벤트 |
| 🔓 | POST | `/api/v1/dev/auth/token` | (local/dev/test 전용) 개발 토큰 |

### 미구현(프론트 화면은 있으나 백엔드 없음)
- 전용 상품 도메인 `GET /api/v1/products`, `/products/{id}` → 농가/오퍼로 대체
- 판매자 AI(가격추천·홍보글), 검색 `PRODUCT` 타입, 보유 재료(pantry), refresh token → future 또는 범위 제외

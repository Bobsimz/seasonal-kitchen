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
| 상품 탭 | `GET /api/v1/products` | 상품 목록(producer_offers facade, §13). 농가 기반 `GET /api/v1/producers`도 병행 가능 |
| 농가 상세 | `GET /api/v1/producers/{producerId}` | 기본 프로필 |
| 농가 상품 목록 | `GET /api/v1/producers/{producerId}/offers` | 장바구니에는 여기서 받은 `id`를 `offerId`로 사용 |
| 상품 상세 | `GET /api/v1/products/{id}` | id=`producer_offers.id`. 이미지·옵션·인증·보관·관련레시피 포함(§13) |
| 식재료 정보 | `GET /api/v1/ingredients/{ingredientId}` | 기존 식재료 & 레시피 탭 |
| 식재료 관련 레시피 | `GET /api/v1/ingredients/{ingredientId}/recipes` | 레시피 카드 목록 |
| 식재료 농가 비교 | `GET /api/v1/ingredients/{ingredientId}/producers` | 가격순 농가 비교 |
| 장바구니 | `GET /api/v1/cart` | 농가별 그룹/배송비 포함 |
| 주문 완료 | `POST /api/v1/orders` | 현재 장바구니를 모의 주문으로 전환 |
| 주문 내역 | `GET /api/v1/orders` | 마이페이지 주문 목록 |
| 검색 | `GET /api/v1/search?q=무&type=ALL` | type: `ALL`, `INGREDIENT`, `RECIPE`, `PRODUCT`(상품 facade) |
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
    "refreshToken": "x9Qd...base64url...",
    "tokenType": "Bearer",
    "userId": 1,
    "nickname": "제철러버",
    "isProducer": false,
    "producerId": null
  },
  "error": null,
  "traceId": null
}
```

> **화면 분기(농가 vs 소비자)**: `isProducer`가 `true`면 그 사용자는 농가(판매자)입니다. `producerId`는 농가일 때만 값이 있고 소비자는 `null`입니다.
> 로그인/가입 응답에 포함되므로 로그인 직후 바로 분기할 수 있고, 새로고침·재접속 시에는 `GET /api/v1/users/me`(§2 사용자) 응답에도 같은 두 필드가 있으니 저장된 토큰으로 복원하면 됩니다.
> 판별 기준은 "그 사용자로 등록된 농가 행 존재 여부"입니다. 소비자가 마이페이지에서 농가로 등록(`POST /api/v1/producers/me`)하면 그 이후 응답부터 `isProducer=true`가 됩니다 — 등록 직후엔 프론트에서 세션 정보를 갱신(재로그인 또는 `/users/me` 재호출)하세요.

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

Response는 signup과 동일합니다(`accessToken` + `refreshToken` 포함).

주요 오류:

| code | status | 의미 |
| --- | --- | --- |
| `AUTH_INVALID_CREDENTIALS` | 401 | 이메일 또는 비밀번호 불일치 |

### POST `/api/v1/auth/refresh`

access token 만료 시 `refreshToken`으로 새 토큰을 발급합니다. **기존 refresh는 회전(폐기)되고 새 refresh가 내려오므로**, 응답의 `refreshToken`으로 교체 저장하세요.

```json
// 요청
{ "refreshToken": "x9Qd...base64url..." }
// 응답 data: 로그인과 동일(accessToken/refreshToken 새 값)
```

| code | status | 의미 |
| --- | --- | --- |
| `AUTH_INVALID_REFRESH_TOKEN` | 401 | refresh token 무효/만료/이미 폐기 → 재로그인 필요 |

### POST `/api/v1/auth/logout`

로그아웃 시 보유한 refresh token을 폐기합니다(멱등 — 이미 폐기/없어도 200). access token은 만료까지 유효하니 클라이언트에서도 폐기하세요.

```json
// 요청
{ "refreshToken": "x9Qd...base64url..." }
// 응답 data: null
```

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
`OrderResponse`에는 배송 추적 필드가 포함됩니다(V30): `status`, `carrier`, `trackingNumber`, `shippedAt`, `deliveredAt`. SHIPPED 전까지는 `carrier`/`trackingNumber`/`shippedAt`이 모두 null입니다.

### 주문 상태 흐름 (구매자 화면 표기용)

`PAID → PREPARING → SHIPPED → DELIVERED` (배송 시작 전에는 `CANCELLED` 가능). 종료 상태: `DELIVERED`, `CANCELLED`.
SHIPPED 상태부터 운송장(`carrier`+`trackingNumber`)이 채워지므로, 주문 상세/배송조회 UI에서 그대로 노출하면 됩니다. 상태 전이는 판매자(농가)가 수행합니다 — §11.1 참고.

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
    "targetId": 1,
    "title": "권민성",
    "imageUrl": "https://img/producer1.png",
    "subtitle": "고랭지 무농약"
  },
  "error": null,
  "traceId": null
}
```

### GET `/api/v1/favorites`

찜 목록. 기존 식별 필드(`id`/`targetType`/`targetId`)에 더해 **찜 목록 화면 표시용 대상 요약**(`title`/`imageUrl`/`subtitle`)을 함께 반환합니다. 대상이 삭제·비활성·비공개면 요약 필드는 `null`(식별 필드는 유지). 목록은 대상별 배치 조회로 N+1을 피합니다.

> "비활성·비공개" 기준: 식재료 `active=false`, 레시피 `status != PUBLISHED`, 상품(offer) `status = HIDDEN`, 또는 대상이 삭제된 경우 → 해당 찜은 요약 3필드가 `null`로 내려갑니다(프론트는 식별 필드로 폴백/숨김 처리).

targetType별 매핑:

| targetType | title | imageUrl | subtitle |
| --- | --- | --- | --- |
| `INGREDIENT` | 식재료명 | 식재료 이미지(없으면 null) | 카테고리(예: 잎채소) |
| `RECIPE` | 레시피 제목 | 레시피 이미지 | 레시피 설명 |
| `PRODUCER` | 농가명 | 농가 photoUrl | 한줄소개(tagline) 없으면 지역(region) |
| `PRODUCT`/`OFFER` | 상품명(없으면 식재료명) | 첫 상품 사진 | 가격/단위(예: `4,500원/봉`) |

> `PRODUCT`/`OFFER`는 찜 생성(create) 대상으로는 아직 허용되지 않지만(현재 INGREDIENT/RECIPE/PRODUCER), 추후 상품 찜이 추가되면 동일 응답으로 동작하도록 매핑돼 있습니다.

```jsonc
// GET /api/v1/favorites  (응답 data: FavoriteResponse[])
[
  { "id": 10, "targetType": "INGREDIENT", "targetId": 12,
    "title": "봄동", "imageUrl": "https://img/bomdong.png", "subtitle": "잎채소" },
  { "id": 9, "targetType": "PRODUCER", "targetId": 1,
    "title": "권민성", "imageUrl": "https://img/producer1.png", "subtitle": "고랭지 무농약" }
]
```

## 8. Search

### GET `/api/v1/search?q=무&type=ALL`

`type`은 `ALL`, `INGREDIENT`, `RECIPE`, **`PRODUCT`**를 허용합니다.
- `ALL`은 기존과 동일하게 **식재료+레시피**만 반환합니다(상품은 포함하지 않음 — 기존 동작 보존).
- **`PRODUCT`**는 producer_offers facade 기반 상품 검색입니다(상품명 `title`·식재료명·농가명 부분일치). 결과는 `products[]`/`productCount`에 담기고, `items`에도 동일하게 포함됩니다.

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
    "reelCount": 0,
    "products": [],
    "productCount": 0
  },
  "error": null,
  "traceId": null
}
```

`type=PRODUCT` 응답 예(상품 결과):

```jsonc
{ "data": {
  "items": [ { "type":"PRODUCT", "id":10, "title":"햇 봄동 1.5kg 산지직송", "description":"권민성", "imageUrl":"https://img/1.png" } ],
  "ingredients": [], "recipes": [], "reels": [],
  "ingredientCount": 0, "recipeCount": 0, "reelCount": 0,
  "products": [ { "type":"PRODUCT", "id":10, "title":"햇 봄동 1.5kg 산지직송", "description":"권민성", "imageUrl":"https://img/1.png" } ],
  "productCount": 1 } }
```
> PRODUCT 검색 항목의 `id`는 `producer_offers.id`(=상품 상세 `/products/{id}`의 id), `title`은 상품명(없으면 식재료명), `description`은 농가명.

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
| 전용 상품 목록 `GET /api/v1/products` | ✅ **구현됨**(producer_offers facade, §13) | — |
| 전용 상품 상세 `GET /api/v1/products/{id}` | ✅ **구현됨**(id=offer id, §13) | — |
| 판매 등록 `POST /api/v1/seller/products` | `POST /api/v1/producers/me/offers` 사용 | 동일 |
| 판매자 AI 가격 추천/홍보글 | 미구현 | 화면/스펙만 future로 유지 |
| 검색 `PRODUCT` 타입 | ✅ **구현됨**(§8) | — |
| refresh token/logout/OAuth | 미구현 | access token 만료 시 재로그인 |

## 11. 농가 자가등록 / 내 농가 (마이페이지 → 농가로 등록)

로그인 사용자가 본인을 농가로 등록하고 상품을 올린다. 한 사용자당 농가 1개. **인증 필요.**
입력값(스타일 enum, 배지/단위/신선도 권장 목록)은 `producer-registration-fields.md` 참조.

| 메서드 | 경로 | 설명 |
| --- | --- | --- |
| `POST` | `/api/v1/producers/me` | 농가로 등록. 이미 등록 시 `PRODUCER_ALREADY_REGISTERED`(409) |
| `GET` | `/api/v1/producers/me` | 내 농가 조회. 미등록 시 `PRODUCER_NOT_FOUND`(404) → "농가 등록" 버튼 노출 판단에 사용 |
| `POST` | `/api/v1/producers/me/offers` | 내 농가 상품(offer) 등록. 미등록 상태면 404 |
| `GET` | `/api/v1/producers/me/offers` | **내 판매 상품 목록**(숨김 제외). 판매자 대시보드 리스트 |
| `PATCH` | `/api/v1/producers/me/offers/{offerId}` | **내 상품 수정**(부분). 타 농가/숨김은 `PRODUCER_OFFER_NOT_FOUND`(404) |
| `DELETE` | `/api/v1/producers/me/offers/{offerId}` | **내 상품 내리기**(숨김/소프트 삭제). 공개 목록·검색·`/products`에서 제외 |
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

### 판매자 상품 관리 (대시보드) — GET/PATCH/DELETE

판매자 대시보드에서 **mock 제거** 후 그대로 붙일 수 있습니다. 모두 인증 필요, 본인 농가 상품만.

```jsonc
// GET /api/v1/producers/me/offers
// 응답 data: ProducerOfferResponse[] (숨김 제외, 가격 오름차순). 미등록 판매자는 PRODUCER_NOT_FOUND(404)
[ { "id":10, "producerId":1, "producerName":"권민성", "ingredientName":"봄동",
    "price":4500, "unit":"봉", "title":"햇 봄동 1.5kg 산지직송",
    "photoUrls":["https://img/1.png"], "tags":["산지직송"], "options":[],
    "certifications":["무농약"], "stockQuantity":120, "storageMethod":"냉장 보관" } ]

// PATCH /api/v1/producers/me/offers/10  (부분 수정)
// ── null 정책 ──
//  · scalar(price·unit·title·…): null=미수정. ("값 비우기"는 미지원)
//  · 컬렉션(photoUrls·tags·options·certifications): null=미수정 / list 제공=전체 교체(빈 배열=비우기)
{ "price":5200, "title":"햇 봄동 2kg 특가",
  "photoUrls":["https://img/new1.png","https://img/new2.png"],  // 기존 사진 전체 교체
  "certifications":["유기농(유기농산물)"],                        // 인증마크 전체 교체
  "stockQuantity":55 }
// 응답 data: ProducerOfferResponse(수정 반영). 타 농가/숨김 offerId → PRODUCER_OFFER_NOT_FOUND(404)

// DELETE /api/v1/producers/me/offers/10
// status=HIDDEN 소프트 삭제(물리 삭제 아님 — cart/order FK 보존). 응답 data: null
// 삭제 후 GET /me/offers, GET /products, GET /producers/{id}/offers, /search 에서 모두 제외됨
```
> **삭제 정책**: `producer_offers.status`(V28, ACTIVE/HIDDEN). cart_items·offer_photos 등이 FK로 참조하므로 물리 삭제 대신 HIDDEN 처리. 공개·판매자 목록 모두 ACTIVE만 반환.

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

### 판매자 주문 처리 (받은 주문 · 상태 변경) — GET/PATCH

판매자 대시보드의 "받은 주문/배송 관리"에 사용합니다. 모두 인증 필요, 본인 농가 항목이 있는 주문만.

```jsonc
// GET /api/v1/producers/me/orders
// 응답 data: SellerOrderResponse[] (최신순). items는 "내 농가 항목"만 포함. 미등록 판매자는 PRODUCER_NOT_FOUND(404)
[ { "orderId":5001, "orderNumber":"20260613-101530123-a1b2", "status":"PAID",
    "producerSubtotal":9000, "carrier":null, "trackingNumber":null,
    "shippedAt":null, "deliveredAt":null, "orderedAt":"2026-06-13T10:15:30+09:00",
    "items":[ { "title":"햇 봄동 1.5kg 산지직송", "ingredientName":"봄동",
                "qty":2, "unit":"봉", "unitPrice":4500 } ] } ]

// PATCH /api/v1/producers/me/orders/5001/status
// 상태 전이: PAID → PREPARING → SHIPPED → DELIVERED  (배송 전 PAID/PREPARING → CANCELLED 가능)
{ "status":"SHIPPED", "carrier":"CJ대한통운", "trackingNumber":"1234567890" }
// 응답 data: SellerOrderResponse(전이 반영, shippedAt 기록)
```

상태 전이 규칙과 에러:
- 허용 전이만 가능. 불가능한 전이(예: PAID→DELIVERED, DELIVERED→*) → `ORDER_INVALID_STATUS_TRANSITION`(409).
- `SHIPPED`로 변경할 때 `trackingNumber` 필수(미입력 시 `ORDER_TRACKING_REQUIRED`, 400). `carrier`는 선택.
- 알 수 없는 `status` 문자열 → `ORDER_INVALID_STATUS`(400).
- 내 농가 항목이 없는 주문을 변경하려 하면 `ORDER_ACCESS_DENIED`(403), 없는 주문은 `ORDER_NOT_FOUND`(404).
- `SHIPPED` 전이 시 `carrier`/`trackingNumber`/`shippedAt`, `DELIVERED` 전이 시 `deliveredAt`이 기록되어 구매자 `OrderResponse`(§6)에도 그대로 노출됩니다.
- 주문 단위로 status를 둡니다(MVP). 한 주문에 여러 농가 항목이 있으면 각 농가가 같은 주문 status를 변경할 수 있습니다 — 농가별 분리 배송 상태는 후속 과제.

## 13. 상품(Product) API — producer_offers facade

> **전용 product 테이블은 없습니다.** `/api/v1/products`는 기존 `producer_offers`를 "상품"으로 보는 **facade**입니다.
> 상품 `id` = `producer_offers.id`이고, 사진/태그/옵션/인증마크 정규화 테이블과 농가(region/style)를 묶어 상품으로 표현합니다.
> 따라서 상품 등록은 별도 API가 아니라 기존 `POST /api/v1/producers/me/offers`(§11)를 그대로 사용합니다.

| 메서드 | 경로 | 설명 |
| --- | --- | --- |
| GET | `/api/v1/products` | 상품 목록/검색. `q`(상품명·식재료명·농가명), `category`, `region`(부분일치), `style` 필터 + `page`/`size` |
| GET | `/api/v1/products/{id}` | 상품 상세. `id`는 `producer_offers.id` |

`stockStatus`는 `stockQuantity`로 계산: **null → `UNKNOWN`, 0 → `SOLD_OUT`, 1 이상 → `IN_STOCK`**.

```jsonc
// GET /api/v1/products?q=봄동&category=잎채소&region=영천&page=0&size=20
// 응답 data: ListResponse<ProductCardResponse>
{ "items": [ {
    "id": 10, "name": "햇 봄동 1.5kg 산지직송",   // name = title, 없으면 ingredientName
    "ingredientId": 12, "ingredientName": "봄동",
    "producerId": 1, "producerName": "권민성", "region": "경북영천",
    "price": 4500, "unit": "봉",
    "imageUrl": "https://img/1.png",            // 첫 photoUrl
    "stockStatus": "IN_STOCK", "category": "잎채소"
  } ],
  "page": 0, "size": 20, "totalElements": 1, "hasNext": false }

// GET /api/v1/products/10
// 응답 data: ProductDetailResponse (카드 필드 + 아래)
{ "id": 10, "name": "햇 봄동 1.5kg 산지직송", "ingredientId": 12, "ingredientName": "봄동",
  "producerId": 1, "producerName": "권민성", "region": "경북영천", "price": 4500, "unit": "봉",
  "imageUrl": "https://img/1.png", "stockStatus": "IN_STOCK", "category": "잎채소",
  "images": ["https://img/1.png","https://img/2.png"],
  "description": "남도 텃밭에서 새벽 수확", "freshnessLabel": "당일수확",
  "stockQuantity": 120, "certifications": ["무농약"],
  "storageMethod": "냉장 보관", "storageNote": "신문지에 싸서 냉장 보관…",
  "options": [ { "id":100, "quantity":1.5, "unit":"kg", "price":6900 } ],
  "tags": ["산지직송","무료배송"],
  "relatedRecipeIds": [3, 7] }   // ingredientId 있을 때 해당 식재료 레시피 id, 없으면 []
```
- 미존재 id는 `PRODUCT_NOT_FOUND`(404).
- `style` 필터는 대소문자 무시(`organic` → `ORGANIC`로 정규화). `category`는 정확일치, `region`은 부분일치.
- `relatedRecipeIds`는 `ingredientId`가 있을 때 `recipe_ingredients` 기준 레시피 id 목록, 없으면 빈 배열.
- 검색은 `GET /api/v1/search?type=PRODUCT`(§8)로도 가능(상품명/식재료명/농가명 부분일치).

## 14. 배송지(Addresses) API

마이페이지 기본 배송지 관리. 모두 **인증 필요**, 본인 배송지만 접근.

| 메서드 | 경로 | 설명 |
| --- | --- | --- |
| `GET` | `/api/v1/users/me/addresses` | 내 배송지 목록(기본 배송지 우선, 최신순) |
| `POST` | `/api/v1/users/me/addresses` | 배송지 등록. 첫 배송지는 자동 기본 |
| `PATCH` | `/api/v1/users/me/addresses/{id}` | 배송지 수정(부분). 없으면 `ADDRESS_NOT_FOUND`(404) |
| `DELETE` | `/api/v1/users/me/addresses/{id}` | 배송지 삭제. 없으면 `ADDRESS_NOT_FOUND`(404) |

```jsonc
// POST /api/v1/users/me/addresses  (요청)
{ "recipientName":"홍길동", "phone":"010-1234-5678",
  "zipCode":"06236",                 // 선택
  "address1":"서울 강남구 테헤란로 1", // 필수
  "address2":"3층 301호",            // 선택
  "isDefault":true }                  // 선택(첫 배송지는 자동 기본)
// 응답 data: AddressResponse
{ "id":1, "recipientName":"홍길동", "phone":"010-1234-5678", "zipCode":"06236",
  "address1":"서울 강남구 테헤란로 1", "address2":"3층 301호", "isDefault":true }

// PATCH /api/v1/users/me/addresses/1  (부분 수정 — null=미수정)
{ "address2":"2층", "isDefault":true }   // isDefault=true면 기존 기본 배송지 해제 후 지정
```
- **기본 배송지는 항상 정확히 1개**(주소가 1개 이상이면): 첫 배송지는 `isDefault` 미지정이어도 자동 기본. 등록/수정에서 `isDefault=true`를 주면 기존 기본은 자동 해제. **기본 배송지를 삭제하면 남은 주소 중 최신 것이 자동으로 기본 승격**된다.
- PATCH의 `isDefault`는 **`true`만 의미** — 단독 해제(false)는 동작하지 않는다(기본을 바꾸려면 다른 주소에 `true` 지정, 또는 삭제). 필수 문자열(`recipientName`/`phone`/`address1`)은 보낼 경우 공백 불가(빈 문자열로 비우기 불가).
- 필수(등록): `recipientName`·`phone`·`address1`. 선택: `zipCode`·`address2`·`isDefault`.

> **주문 연결(향후)**: 현재 `POST /orders`는 배송지와 연결하지 않는다(optional). 추후 주문 생성 시 선택한 배송지를 `order.shippingAddressSnapshot`(주문 시점 스냅샷: 수령인·연락처·주소)으로 복사해 붙일 수 있도록 설계해 둔다. 스냅샷이므로 이후 배송지가 수정/삭제돼도 과거 주문 정보는 보존된다.

## 15. 이미지 업로드(Uploads) API

이미지 파일을 업로드하고 접근 URL을 받습니다. **인증 필요.** 받은 URL을 다른 API의 이미지 필드에 그대로 넣으면 됩니다.

| 메서드 | 경로 | 설명 |
| --- | --- | --- |
| `POST` | `/api/v1/uploads` | `multipart/form-data`, 파트 이름 **`file`**. 이미지 업로드 → `{ url }` |

```jsonc
// POST /api/v1/uploads   (multipart/form-data; file=<이미지>)
// 응답 data: UploadResponse
{ "url": "/uploads/images/ab12cd34ef.png" }
```

**검증**
- content-type **whitelist**: `image/png`, `image/jpeg`, `image/webp`, `image/gif`만 허용 — 그 외(`image/svg+xml` 포함)는 `INVALID_FILE_TYPE`(400). (SVG는 스크립트/외부참조 위험으로 제외)
- 최대 크기 `app.uploads.max-bytes`(기본 5MB) 초과 시 `FILE_TOO_LARGE`(413). 멀티파트 한도(`spring.servlet.multipart.max-file-size`, 기본 10MB) 초과도 동일하게 `FILE_TOO_LARGE`(413)로 매핑된다.
- 빈 파일은 `EMPTY_FILE`(400).

**사용처** — 받은 `url`을 아래 필드에 넣습니다.
- 농가 등록 `POST /producers/me` → `certificationImageUrl`
- 상품 등록/수정 `POST|PATCH /producers/me/offers` → `photoUrls[]`
- 농가 프로필 `photoUrl`
- (향후) 리뷰 사진

**저장 방식 (S3 교체 가능)**
- 추상화: `FileStorage` 인터페이스. 기본 구현 `LocalFileStorage`(`app.uploads.storage=local`, 기본값).
- 로컬: `app.uploads.dir`(기본 `uploads/`)에 저장하고 `GET /uploads/**`로 정적 서빙. URL은 `app.uploads.public-base-url`(빈 값이면 상대경로 `/uploads/...`, CDN/호스트 지정 시 절대경로) + `/uploads/<key>`.
- S3 전환: `app.uploads.storage=s3`로 두고 `FileStorage`를 구현하는 S3 빈(`@ConditionalOnProperty(...havingValue="s3")`)을 추가하면 컨트롤러/서비스 변경 없이 교체된다(현재 S3 구현체는 후속).

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
| 🔒 | GET | `/api/v1/users/me/addresses` | 내 배송지 목록 (§14) |
| 🔒 | POST | `/api/v1/users/me/addresses` | 배송지 등록 (§14) |
| 🔒 | PATCH | `/api/v1/users/me/addresses/{id}` | 배송지 수정 (§14) |
| 🔒 | DELETE | `/api/v1/users/me/addresses/{id}` | 배송지 삭제 (§14) |
| 🔒 | POST | `/api/v1/uploads` | 이미지 업로드 → `{url}` (§15) |
| 🔓 | GET | `/uploads/**` | 업로드 이미지 정적 서빙(로컬 저장 시) |

### 홈 / 검색 (🔓)
| | 메서드 | 경로 | 설명 |
|---|---|---|---|
| 🔓 | GET | `/api/v1/home` | 홈 화면(시즌 추천·재료·레시피·릴스·인기검색어·미읽음알림수) |
| 🔓 | GET | `/api/v1/search?q=&type=ALL\|INGREDIENT\|RECIPE\|PRODUCT` | 통합 검색(PRODUCT=상품 facade) |

> **홈 히어로**: `GET /api/v1/home` 응답에 `hero`(단일, 하위 호환)와 **`heroes`(배열, 캐러셀용)** 둘 다 있습니다. `hero`는 `heroes[0]`과 동일하고, 식재료가 없으면 `hero=null`·`heroes=[]`입니다. 캐러셀 컴포넌트는 `heroes`를 그대로 `.map` 하면 됩니다(단일 객체 아님).
> 각 hero 필드: `title`(식재료명), `subtitle`, `imageUrl`, `ingredientId`, `primaryTargetType`/`primaryTargetId`, `priceLabel`(예: `"1,980원/1개"`, 가격 없으면 null), `trendLabel`(예: `"▼ 12.5%"`, 없으면 null).
| 🔓 | GET | `/api/v1/products` | 상품 목록/검색(producer_offers facade, §13) |
| 🔓 | GET | `/api/v1/products/{id}` | 상품 상세(id=offer id, §13) |
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
| 🔒 | GET | `/api/v1/producers/me/offers` | 내 판매 상품 목록(숨김 제외) (§11) |
| 🔒 | PATCH | `/api/v1/producers/me/offers/{offerId}` | 내 상품 수정(부분) (§11) |
| 🔒 | DELETE | `/api/v1/producers/me/offers/{offerId}` | 내 상품 내리기(숨김) (§11) |
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

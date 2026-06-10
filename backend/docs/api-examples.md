# API Examples

These examples are reference contracts for frontend/backend integration.
Actual DTOs should be kept synchronized with Swagger/OpenAPI.

## Common Success Response

```json
{
  "success": true,
  "data": {},
  "error": null,
  "traceId": "01J..."
}
```

## Common Error Response

```json
{
  "success": false,
  "data": null,
  "error": {
    "code": "INGREDIENT_NOT_FOUND",
    "message": "식재료를 찾을 수 없습니다.",
    "fieldErrors": []
  },
  "traceId": "01J..."
}
```

## GET `/api/v1/ingredients`

### Response

```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": 1,
        "name": "무",
        "imageUrl": "https://example.com/radish.png",
        "category": "채소",
        "price": {
          "currentPrice": 1980,
          "unit": "1개",
          "weekChangeRate": -12.5,
          "yearAverageChangeRate": -8.2,
          "observedDate": "2026-06-01",
          "source": "KAMIS"
        },
        "seasonal": true,
        "buyingSignal": "BUY_NOW",
        "tags": ["제철", "가격하락"]
      }
    ],
    "page": 0,
    "size": 20,
    "totalElements": 1,
    "hasNext": false
  },
  "error": null,
  "traceId": "01J..."
}
```

## GET `/api/v1/ingredients/{ingredientId}`

### Response

```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "무",
    "category": "채소",
    "imageUrl": "https://example.com/radish.png",
    "baseUnit": "1개",
    "seasonal": true,
    "seasonScore": 92,
    "price": {
      "currentPrice": 1980,
      "unit": "1개",
      "weekChangeRate": -12.5,
      "yearAverageChangeRate": -8.2,
      "observedDate": "2026-06-01",
      "source": "KAMIS"
    },
    "buyingSignal": "BUY_NOW",
    "description": "현재 가격 메리트가 높은 제철 식재료입니다."
  },
  "error": null,
  "traceId": "01J..."
}
```

## GET `/api/v1/ingredients/{ingredientId}/prices`

### Response

```json
{
  "success": true,
  "data": {
    "ingredientId": 1,
    "ingredientName": "무",
    "unit": "1개",
    "source": "KAMIS",
    "items": [
      {
        "observedDate": "2026-05-30",
        "price": 2250
      },
      {
        "observedDate": "2026-05-31",
        "price": 2100
      },
      {
        "observedDate": "2026-06-01",
        "price": 1980
      }
    ]
  },
  "error": null,
  "traceId": "01J..."
}
```

## GET `/api/v1/products/{productId}`

### Response

```json
{
  "success": true,
  "data": {
    "id": 10,
    "ingredientId": 1,
    "ingredientName": "무",
    "category": "채소",
    "title": "아삭한 제주 무 3kg",
    "description": "수확 직후 선별한 제주 무입니다.",
    "price": 8900,
    "unit": "3kg",
    "sellerName": "제주농장",
    "origin": "제주",
    "status": "PUBLISHED",
    "images": ["https://example.com/radish-product.png"],
    "relatedRecipes": [
      {
        "id": 100,
        "title": "무조림",
        "imageUrl": "https://example.com/radish-recipe.png"
      }
    ]
  },
  "error": null,
  "traceId": "01J..."
}
```

## POST `/api/v1/seller/products/price-recommendation`

### Response

```json
{
  "success": true,
  "data": {
    "recommendedPrice": 8900,
    "minPrice": 8200,
    "maxPrice": 9400,
    "explanation": "현재 시세, 투자금, 임금, 물가상승률을 반영한 판매 추천가입니다.",
    "assumptions": {
      "marketPriceObservedDate": "2026-06-01",
      "inflationRate": 2.8,
      "laborCost": 120000
    },
    "confidence": "MEDIUM"
  },
  "error": null,
  "traceId": "01J..."
}
```

## POST `/api/v1/cart/items` (farm-direct-commerce)

장바구니 담기는 `offerId`(농가 판매 상품 ID) + `qty`만 받는다.
producer/ingredient/price/unit은 서버가 ProducerOffer에서 조회해 스냅샷으로 저장하며,
클라이언트 입력을 신뢰하지 않는다. 같은 offerId를 다시 담으면 수량이 증가한다.

### Request

```json
{
  "offerId": 10,
  "qty": 2
}
```

### Response

```json
{
  "success": true,
  "data": {
    "groups": [
      {
        "producerId": 1,
        "producerName": "권민성",
        "items": [
          { "cartItemId": 100, "ingredientName": "봄동", "qty": 2, "unitPrice": 4500, "unit": "봉" }
        ],
        "subtotal": 9000,
        "shipping": 3000
      }
    ],
    "itemsTotal": 9000,
    "shippingTotal": 3000,
    "payTotal": 12000
  },
  "error": null,
  "traceId": "01J..."
}
```

존재하지 않는 `offerId`로 담으면 `PRODUCER_OFFER_NOT_FOUND` 오류를 반환하고 장바구니 항목을 만들지 않는다(0원 fallback 없음).

---

# Farm-Direct-Commerce API Examples

농가(producer) / 농가 비교(offer) / 장바구니 / 주문 / 리뷰. 프론트 연동용 request-response 예시.
모든 응답은 공통 래퍼(`success/data/error/traceId`)를 따른다. 아래는 `data` 중심으로 표기.

## GET `/api/v1/producers?q=봄동&style=ORGANIC&honorary=true&page=0&size=20`

농가 목록/검색. `q`(특산품명), `style`(VALUE|ORGANIC|PREMIUM), `honorary`, 페이지네이션을 함께 적용.

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
    "page": 0, "size": 20, "totalElements": 1, "hasNext": false
  },
  "error": null, "traceId": "01J..."
}
```

## GET `/api/v1/producers/{producerId}`

```json
{
  "success": true,
  "data": {
    "id": 1, "name": "권민성", "region": "경북영천",
    "tagline": "콩밭 매는 아낙네, 정성으로 키운 잡곡",
    "photoUrl": null, "style": "PREMIUM",
    "priceLevel": 5, "freshnessLevel": 5,
    "rating": 4.9, "reviewCount": 1280, "honorary": true,
    "specialties": ["콩", "봄동", "시금치", "무"],
    "badges": ["산지직송", "당일수확"]
  },
  "error": null, "traceId": "01J..."
}
```

## GET `/api/v1/producers/{producerId}/offers`

농가가 파는 식재료(가격순).

```json
{
  "success": true,
  "data": [
    { "id": 12, "producerId": 1, "producerName": "권민성", "region": "경북영천",
      "ingredientName": "무", "ingredientId": null, "price": 2600, "unit": "개", "freshnessLabel": "당일수확" },
    { "id": 10, "producerId": 1, "producerName": "권민성", "region": "경북영천",
      "ingredientName": "봄동", "ingredientId": null, "price": 5310, "unit": "봉", "freshnessLabel": "당일수확" }
  ],
  "error": null, "traceId": "01J..."
}
```

## GET `/api/v1/ingredients/{ingredientId}/producers`

식재료별 농가 비교(가격순). `producer_offers.ingredient_id` 우선, 미백필 시 식재료명 fallback. V14 시드만 적용된 상태에서는 응답의 `ingredientId`가 `null`일 수 있다.

```json
{
  "success": true,
  "data": [
    { "id": 31, "producerId": 3, "producerName": "김상도", "region": "전남해남",
      "ingredientName": "봄동", "ingredientId": null, "price": 4090, "unit": "봉", "freshnessLabel": "수확 1일 이내" },
    { "id": 10, "producerId": 1, "producerName": "권민성", "region": "경북영천",
      "ingredientName": "봄동", "ingredientId": null, "price": 5310, "unit": "봉", "freshnessLabel": "당일수확" }
  ],
  "error": null, "traceId": "01J..."
}
```

## GET `/api/v1/producers/{producerId}/reviews`

```json
{
  "success": true,
  "data": [
    { "id": 100, "author": "민지", "rating": 5, "item": "콩",
      "body": "경북영천에서 바로 받아서 그런지 정말 싱싱해요. 재구매 의사 100%입니다!",
      "createdAt": "2026-05-30T10:00:00+09:00" }
  ],
  "error": null, "traceId": "01J..."
}
```

## GET `/api/v1/producers/{producerId}/news`

```json
{
  "success": true,
  "data": [
    { "id": 200, "postedAt": "2026-05-28T08:58:00+09:00",
      "title": "제철 콩 5월 산지 소식입니다~", "imageRef": "콩",
      "body": "경북영천 권민성입니다~ 올해는 일조량이 풍부해 콩 품질이 예년보다 좋습니다 ..." }
  ],
  "error": null, "traceId": "01J..."
}
```

## GET `/api/v1/cart`

농가별 그룹 + 배송비(농가별 3,000원, 소계 30,000원↑ 무료) + 결제예정액.

```json
{
  "success": true,
  "data": {
    "groups": [
      { "producerId": 1, "producerName": "권민성",
        "items": [ { "cartItemId": 100, "ingredientName": "봄동", "qty": 2, "unitPrice": 5310, "unit": "봉" } ],
        "subtotal": 10620, "shipping": 3000 }
    ],
    "itemsTotal": 10620, "shippingTotal": 3000, "payTotal": 13620
  },
  "error": null, "traceId": "01J..."
}
```

## POST `/api/v1/orders`

현재 장바구니를 주문으로 전환(모의 결제). 응답은 주문완료 화면용 상세.

### Request
빈 본문 (인증 사용자의 장바구니 기준).

### Response

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
      { "producerName": "권민성", "ingredientName": "봄동", "qty": 2, "unitPrice": 5310 }
    ]
  },
  "error": null, "traceId": "01J..."
}
```

## GET `/api/v1/orders`

```json
{
  "success": true,
  "data": [
    { "id": 5001, "orderNumber": "20260610-142233456-3f9a", "status": "PAID",
      "totalAmount": 13620, "summary": "봄동 외 1건", "orderedAt": "2026-06-10T14:22:33+09:00" }
  ],
  "error": null, "traceId": "01J..."
}
```

## POST `/api/v1/producers/{producerId}/reviews`

MVP: 로그인 사용자가 존재하는 농가에 자유 작성. 작성 시 농가 평점/리뷰수 갱신.

### Request

```json
{ "rating": 5, "item": "봄동", "body": "정말 싱싱해요. 또 주문할게요!" }
```

### Response

```json
{
  "success": true,
  "data": { "id": 320, "author": "user#42", "rating": 5, "item": "봄동",
            "body": "정말 싱싱해요. 또 주문할게요!", "createdAt": "2026-06-10T14:30:00+09:00" },
  "error": null, "traceId": "01J..."
}
```

존재하지 않는 농가면 `PRODUCER_NOT_FOUND`. (배송완료 주문 자격검증은 MVP 범위 밖)

## GET `/api/v1/users/me/reviews?status=written`

```json
{
  "success": true,
  "data": [
    { "reviewId": 320, "producerId": 1, "producerName": "권민성", "item": "봄동",
      "rating": 5, "body": "정말 싱싱해요. 또 주문할게요!", "date": "2026-06-10T14:30:00+09:00" }
  ],
  "error": null,
  "traceId": "01J..."
}
```

`status=writable` 은 MVP에서 빈 배열을 반환한다(future).

---

# Auth API Examples (이메일 회원가입/로그인)

OAuth 전 단계의 이메일/비밀번호 인증. 발급된 `accessToken`을 이후 요청 헤더에
`Authorization: Bearer <accessToken>` 로 넣으면 사용자 단위 API(장바구니/주문/리뷰 작성/찜/마이페이지)를 호출할 수 있다.
Swagger UI에서는 우측 상단 **Authorize** 버튼에 토큰을 붙이면 된다.

## POST `/api/v1/auth/signup`

### Request
```json
{ "email": "user@example.com", "password": "password123", "nickname": "제철러버" }
```

### Response
```json
{
  "success": true,
  "data": { "accessToken": "eyJhbGciOiJ...", "tokenType": "Bearer", "userId": 1, "nickname": "제철러버" },
  "error": null, "traceId": "01J..."
}
```

이미 가입된 이메일이면 `AUTH_EMAIL_DUPLICATE`(409), 닉네임 중복이면 `AUTH_NICKNAME_DUPLICATE`(409).

## POST `/api/v1/auth/login`

### Request
```json
{ "email": "user@example.com", "password": "password123" }
```

### Response
```json
{
  "success": true,
  "data": { "accessToken": "eyJhbGciOiJ...", "tokenType": "Bearer", "userId": 1, "nickname": "제철러버" },
  "error": null, "traceId": "01J..."
}
```

이메일/비밀번호가 틀리면 `AUTH_INVALID_CREDENTIALS`(401).

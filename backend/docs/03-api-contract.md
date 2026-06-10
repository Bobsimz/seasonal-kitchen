# API Contract

## 1. Swagger 우선 개발

백엔드는 Swagger UI와 OpenAPI JSON을 제공해야 합니다.

```text
Swagger UI:    /swagger-ui.html
OpenAPI JSON:  /v3/api-docs
```

프론트엔드는 OpenAPI JSON을 기준으로 TypeScript API client를 생성합니다.

```bash
npx @openapitools/openapi-generator-cli generate \
  -i http://localhost:8080/v3/api-docs \
  -g typescript-fetch \
  -o src/generated/api
```

생성된 코드는 직접 수정하지 않습니다.

## 2. 공통 규칙

- API prefix는 `/api/v1`을 사용합니다.
- Entity를 API에 직접 노출하지 않습니다.
- request DTO와 response DTO를 분리합니다.
- 날짜와 시간은 ISO 8601 형식으로 전달합니다.
- 금액은 숫자로 전달합니다.
- enum 값과 nullable 여부를 Swagger에 명시합니다.
- 목록 API는 동일한 페이지네이션 형식을 사용합니다.
- 오류 코드를 기능별로 정의합니다.
- 가격 데이터에는 기준일, 단위, 출처를 포함합니다.

## 3. 공통 응답

성공 응답:

```json
{
  "success": true,
  "data": {},
  "error": null,
  "traceId": "01J..."
}
```

목록 응답:

```json
{
  "items": [],
  "page": 0,
  "size": 20,
  "totalElements": 86,
  "hasNext": true
}
```

오류 응답:

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

## 4. Swagger 태그

```text
01. Auth
02. Users
03. Home
04. Search
05. Ingredients
06. Prices
07. Stores
08. Recipes
09. Reels
10. Favorites
11. Products
12. Seller Listings
13. Notifications
14. Analytics
15. Creators
16. Promotions
17. Admin
```

## 5. 전체 API 목록

### Auth

```text
POST   /api/v1/auth/signup
POST   /api/v1/auth/login
POST   /api/v1/dev/auth/token
```

이메일/비밀번호 회원가입·로그인이 구현되어 있습니다. 두 엔드포인트 모두 JWT access token(`AuthTokenResponse`: accessToken, tokenType=Bearer, userId, nickname)을 발급합니다. 비밀번호는 BCrypt로 저장합니다.

OAuth(kakao/apple/google) login, refresh, logout은 추후 도입(deferred)입니다. 임시 dev token 엔드포인트(`POST /api/v1/dev/auth/token`)는 `local`, `dev`, `test` 프로필에서만 노출됩니다.

### Users

```text
GET    /api/v1/users/me
PATCH  /api/v1/users/me
GET    /api/v1/users/me/summary
PUT    /api/v1/users/me/preferences
```

### Home and Search

```text
GET    /api/v1/home
GET    /api/v1/search?q=무&type=ALL
GET    /api/v1/search/trending
GET    /api/v1/users/me/recent-searches
```

### Ingredients, Prices and Stores

```text
GET    /api/v1/ingredients
GET    /api/v1/ingredients/{ingredientId}
GET    /api/v1/ingredients/{ingredientId}/prices
GET    /api/v1/ingredients/{ingredientId}/offers
GET    /api/v1/ingredients/{ingredientId}/recipes
GET    /api/v1/ingredients/{ingredientId}/substitutes
```

### Recipes

```text
GET    /api/v1/recipes
GET    /api/v1/recipes/{recipeId}
GET    /api/v1/recipes/{recipeId}/steps
```

### Reels

```text
GET    /api/v1/reels
GET    /api/v1/reels/{reelId}
POST   /api/v1/reels/{reelId}/likes
DELETE /api/v1/reels/{reelId}/likes
GET    /api/v1/reels/{reelId}/comments
POST   /api/v1/reels/{reelId}/comments
POST   /api/v1/reels/{reelId}/view-events
```

### Favorites and Alerts

```text
GET    /api/v1/favorites
POST   /api/v1/favorites
DELETE /api/v1/favorites/{favoriteId}
GET    /api/v1/price-alerts
POST   /api/v1/price-alerts
PATCH  /api/v1/price-alerts/{alertId}
DELETE /api/v1/price-alerts/{alertId}
```

### Producer Commerce

```text
GET    /api/v1/producers
GET    /api/v1/producers/{producerId}
GET    /api/v1/producers/{producerId}/offers
GET    /api/v1/producers/{producerId}/reviews
GET    /api/v1/producers/{producerId}/news
POST   /api/v1/producers/{producerId}/reviews
GET    /api/v1/ingredients/{ingredientId}/producers
POST   /api/v1/producers/me
GET    /api/v1/producers/me
POST   /api/v1/producers/me/offers
GET    /api/v1/cart
POST   /api/v1/cart/items
PATCH  /api/v1/cart/items/{cartItemId}
DELETE /api/v1/cart/items/{cartItemId}
POST   /api/v1/orders
GET    /api/v1/orders
GET    /api/v1/orders/{orderId}
```

전용 products/seller-products API와 판매자 AI 가격 추천/홍보글 API는 현재 미구현(future)입니다. 현재 상품 탭과 판매 등록은 producer/offer 흐름으로 연결합니다.

### Notifications

```text
GET    /api/v1/notifications
PATCH  /api/v1/notifications/{notificationId}/read
PATCH  /api/v1/notifications/read-all
```

### Analytics

```text
POST   /api/v1/events
```

### Creator and Admin

```text
Deferred. No creator/admin controller is implemented in the current backend.
```

## 6. 핵심 DTO 예시

### IngredientCardResponse

```java
public record IngredientCardResponse(
    Long id,
    String name,
    String imageUrl,
    String category,
    PriceSummaryResponse price,
    boolean seasonal,
    String buyingSignal,
    List<String> tags
) {}
```

### PriceSummaryResponse

```java
public record PriceSummaryResponse(
    BigDecimal currentPrice,
    String unit,
    BigDecimal weekChangeRate,
    BigDecimal yearAverageChangeRate,
    LocalDate observedDate,
    String source
) {}
```

### ProducerCardResponse

```java
public record ProducerCardResponse(
    Long id,
    String name,
    String region,
    String tagline,
    String photoUrl,
    String style,
    BigDecimal rating,
    int reviewCount,
    boolean honorary,
    List<String> specialties,
    List<String> badges
) {}
```

### ProducerOfferResponse

```java
public record ProducerOfferResponse(
    Long id,
    Long producerId,
    String producerName,
    String region,
    String ingredientName,
    Long ingredientId,
    BigDecimal price,
    String unit,
    String freshnessLabel
) {}
```

## 7. DTO 작성 규칙

- Swagger `@Schema`에 필드 설명과 예시를 작성합니다.
- 요청 DTO에는 Bean Validation을 적용합니다.
- 생성, 수정, 조회 DTO를 필요에 따라 분리합니다.
- 중첩 응답 DTO를 사용하여 화면 단위 API 호출 수를 줄입니다.
- 상세 조회와 카드 목록 DTO를 분리합니다.
- enum은 문자열로 직렬화합니다.
- 내부 ID와 외부 데이터 제공자의 코드를 분리합니다.

## 8. 프론트엔드 연동 원칙

현재 프론트의 하드코딩 데이터를 아래 순서로 교체합니다.

| 프론트 영역 | 우선 연동 API |
| --- | --- |
| 홈 | `GET /api/v1/home` |
| 식재료 목록 | `GET /api/v1/ingredients` |
| 식재료 상세 | `GET /api/v1/ingredients/{ingredientId}` |
| 가격 비교 | `GET /api/v1/ingredients/{ingredientId}/offers` |
| 검색 | `GET /api/v1/search` |
| 레시피 | `GET /api/v1/recipes/{recipeId}` |
| 릴스 | `GET /api/v1/reels` |
| 상품 | `GET /api/v1/producers` |
| 판매 등록 | `POST /api/v1/producers/me/offers` |
| 마이페이지 | `GET /api/v1/users/me/summary` |
| 알림 | `GET /api/v1/notifications` |

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
11. Shopping Plans
12. AI Recommendations
13. Notifications
14. Analytics
15. Creators
16. Promotions
17. Admin
```

## 5. 전체 API 목록

### Auth

```text
POST   /api/v1/auth/oauth/{provider}
POST   /api/v1/auth/refresh
POST   /api/v1/auth/logout
```

### Users

```text
GET    /api/v1/users/me
PATCH  /api/v1/users/me
PUT    /api/v1/users/me/preferences
GET    /api/v1/users/me/pantry
POST   /api/v1/users/me/pantry
PATCH  /api/v1/users/me/pantry/{pantryItemId}
DELETE /api/v1/users/me/pantry/{pantryItemId}
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

### AI Recommendations and Shopping

```text
POST   /api/v1/recommendations/plans
POST   /api/v1/recommendations/plans/{planId}/messages
GET    /api/v1/recommendations/plans/{planId}
GET    /api/v1/shopping-plans/{planId}
PATCH  /api/v1/shopping-plans/{planId}/items/{itemId}
GET    /api/v1/shopping-plans/{planId}/store-links
```

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
POST   /api/v1/creators/applications
GET    /api/v1/creators/me/reels
POST   /api/v1/creators/me/reels
PATCH  /api/v1/creators/me/reels/{reelId}

GET    /api/v1/admin/ingredients
POST   /api/v1/admin/ingredients
POST   /api/v1/admin/recipes
POST   /api/v1/admin/reels
PATCH  /api/v1/admin/reels/{reelId}/status
GET    /api/v1/admin/import-jobs
POST   /api/v1/admin/import-jobs/kamis
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

### CreateShoppingPlanRequest

```java
public record CreateShoppingPlanRequest(
    Integer days,
    Integer people,
    BigDecimal budget,
    List<String> preferences,
    List<Long> pantryIngredientIds,
    List<Long> excludedIngredientIds,
    List<String> allergyCodes,
    RecommendationPriority priority
) {}
```

### ShoppingPlanResponse

```java
public record ShoppingPlanResponse(
    Long planId,
    String summary,
    BigDecimal estimatedTotal,
    BigDecimal expectedSavingRate,
    List<MealResponse> meals,
    List<ShoppingItemResponse> items,
    List<RecommendationReasonResponse> reasons,
    List<SubstitutionResponse> substitutions
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
| AI 결과 | `POST /api/v1/recommendations/plans` |
| 마이페이지 | `GET /api/v1/users/me` |
| 알림 | `GET /api/v1/notifications` |


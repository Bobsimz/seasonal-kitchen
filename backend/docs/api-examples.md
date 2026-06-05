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

## POST `/api/v1/recommendations/plans`

### Request

```json
{
  "days": 3,
  "people": 2,
  "budget": 30000,
  "preferences": ["간단한 조리", "매운 음식 제외"],
  "pantryIngredientIds": [1, 3],
  "excludedIngredientIds": [9],
  "allergyCodes": ["PEANUT"],
  "priority": "LOW_PRICE"
}
```

### Response

```json
{
  "success": true,
  "data": {
    "planId": 10,
    "summary": "가격이 하락한 제철 식재료 중심으로 3일 식단을 구성했습니다.",
    "estimatedTotal": 27600,
    "expectedSavingRate": 15.2,
    "meals": [
      {
        "date": "2026-06-01",
        "mealType": "DINNER",
        "recipeId": 100,
        "recipeTitle": "무조림"
      }
    ],
    "items": [
      {
        "itemId": 1,
        "ingredientId": 1,
        "ingredientName": "무",
        "quantity": 1,
        "unit": "개",
        "estimatedPrice": 1980,
        "selected": true
      }
    ],
    "reasons": [
      {
        "type": "PRICE_DROP",
        "message": "무 가격이 최근 1주일 기준 하락했습니다."
      }
    ],
    "substitutions": []
  },
  "error": null,
  "traceId": "01J..."
}
```

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

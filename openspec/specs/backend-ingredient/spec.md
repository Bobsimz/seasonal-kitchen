# ingredient

## Purpose

식재료 목록, 상세, 가격 이력, 대체 식재료, 구매처 오퍼, 관련 레시피 API의 현재 동작을 정의한다.

## Requirements

### Requirement: 활성 식재료 목록 조회

시스템은 SHALL 활성 식재료만 페이지네이션 목록으로 반환해야 한다.

#### Scenario: 식재료 목록을 조회한다

- **GIVEN** `ingredients.active=true`인 식재료가 존재한다
- **WHEN** `GET /api/v1/ingredients`를 호출한다
- **THEN** 시스템은 `IngredientCardResponse` 목록을 `ListResponse`로 반환해야 한다

### Requirement: 식재료 상세 조회

시스템은 SHALL 식재료 상세에 기본 정보, 가격 요약, 제철 필드, 영양, 손질 팁, 보관 팁, 가격 비교 가능 매장 수를 포함해야 한다.

#### Scenario: 식재료 상세를 조회한다

- **GIVEN** 활성 식재료가 존재한다
- **WHEN** `GET /api/v1/ingredients/{ingredientId}`를 호출한다
- **THEN** 시스템은 `IngredientDetailResponse`를 반환해야 한다

### Requirement: 식재료 관련 데이터 조회

시스템은 SHALL 식재료의 가격 이력, 대체 식재료, 구매처 오퍼, 관련 레시피를 조회할 수 있어야 한다.

#### Scenario: 구매처 오퍼를 조회한다

- **GIVEN** 활성 식재료와 `store_offers`가 존재한다
- **WHEN** `GET /api/v1/ingredients/{ingredientId}/offers`를 호출한다
- **THEN** 시스템은 가격순 구매처 오퍼 목록을 반환해야 한다

## Related API endpoints

- `GET /api/v1/ingredients`
- `GET /api/v1/ingredients/{ingredientId}`
- `GET /api/v1/ingredients/{ingredientId}/prices`
- `GET /api/v1/ingredients/{ingredientId}/substitutes`
- `GET /api/v1/ingredients/{ingredientId}/offers`
- `GET /api/v1/ingredients/{ingredientId}/recipes`

## Related database tables

- `ingredients`
- `ingredient_aliases`
- `ingredient_nutritions`
- `ingredient_care_tips`
- `ingredient_storage_tips`
- `ingredient_substitutes`
- `price_snapshots`
- `stores`
- `store_offers`
- `recipe_ingredients`
- `recipes`

## Known deferred or placeholder behavior

- `seasonMonths`, `seasonScore`, `seasonal`, `buyingSignal`, `tags`는 실제 제철 도메인 완성 전까지 시드 데이터 또는 단순 규칙에 의존할 수 있다.
- KAMIS 등 외부 식재료 데이터 연동은 아직 구현되어 있지 않다.

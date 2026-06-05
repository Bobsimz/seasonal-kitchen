# recipe

## Purpose

레시피 목록, 상세, 조리 단계, 식재료 관련 레시피 조회의 현재 동작을 정의한다.

## Requirements

### Requirement: 공개 레시피 목록 조회

시스템은 SHALL 레시피 카드 목록을 페이지네이션으로 반환해야 한다.

#### Scenario: 레시피 목록을 조회한다

- **GIVEN** 공개 가능한 레시피가 존재한다
- **WHEN** `GET /api/v1/recipes`를 호출한다
- **THEN** 시스템은 `RecipeCardResponse` 목록을 반환해야 한다

### Requirement: 레시피 상세 조회

시스템은 SHALL 레시피 상세에 기본 정보, 재료, 예상 총 재료비, 태그, 크리에이터, 좋아요 수, 관련 릴스를 포함해야 한다.

#### Scenario: 레시피 상세를 조회한다

- **GIVEN** 레시피가 존재한다
- **WHEN** `GET /api/v1/recipes/{recipeId}`를 호출한다
- **THEN** 시스템은 `RecipeDetailResponse`를 반환해야 한다

### Requirement: 조리 단계 조회

시스템은 SHALL 레시피별 조리 단계를 순서대로 반환해야 한다.

#### Scenario: 조리 단계를 조회한다

- **GIVEN** `recipe_steps`가 존재한다
- **WHEN** `GET /api/v1/recipes/{recipeId}/steps`를 호출한다
- **THEN** 시스템은 `stepNumber` 순서의 단계 목록을 반환해야 한다

## Related API endpoints

- `GET /api/v1/recipes`
- `GET /api/v1/recipes/{recipeId}`
- `GET /api/v1/recipes/{recipeId}/steps`
- `GET /api/v1/ingredients/{ingredientId}/recipes`

## Related database tables

- `recipes`
- `recipe_ingredients`
- `recipe_steps`
- `ingredients`
- `price_snapshots`
- `reels`
- `creators`
- `reel_reactions`

## Known deferred or placeholder behavior

- 실제 좋아요/조회 집계와 태그는 제한된 데이터 또는 시드 기반일 수 있다.
- 레시피 추천 품질은 실제 AI/외부 데이터 연동 전까지 제한적이다.

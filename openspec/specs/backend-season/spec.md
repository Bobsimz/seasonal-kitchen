# season

## Purpose

현재 제철 정보가 식재료, 홈, 검색 화면에 노출되는 방식을 정의한다. 독립적인 실제 제철 데이터 적재 도메인은 아직 완성되지 않았다.

## Requirements

### Requirement: 식재료 응답의 제철 필드 제공

시스템은 SHALL 식재료 카드와 상세 응답에 제철 관련 필드를 포함해야 한다.

#### Scenario: 식재료 카드에 제철 표시가 포함된다

- **GIVEN** 식재료 목록을 조회한다
- **WHEN** 시스템이 `IngredientCardResponse`를 생성한다
- **THEN** `seasonal`, `buyingSignal`, `tags`를 serialization-safe하게 반환해야 한다

### Requirement: 홈 제철 문구 제공

시스템은 SHALL 홈 응답에 절기 또는 제철 설명 문구를 제공해야 한다.

#### Scenario: 홈 화면을 조회한다

- **GIVEN** 클라이언트가 홈 데이터를 요청한다
- **WHEN** `GET /api/v1/home`을 호출한다
- **THEN** 시스템은 `seasonTitle`, `seasonSubtitle`, `hero`를 반환해야 한다

### Requirement: 실제 제철 데이터 통합은 별도 변경으로 관리

시스템은 SHALL 실제 월별/지역별 제철 데이터 통합을 현재 기준선 기능으로 간주하지 않아야 한다.

#### Scenario: 실제 제철 점수를 검토한다

- **GIVEN** `seasonal_ingredients` 설계와 OpenSpec 변경안이 존재한다
- **WHEN** 현재 구현 기준선을 작성한다
- **THEN** 실제 수집/적재/점수 계산은 보류 항목으로 기록해야 한다

## Related API endpoints

- `GET /api/v1/home`
- `GET /api/v1/ingredients`
- `GET /api/v1/ingredients/{ingredientId}`
- `GET /api/v1/search`

## Related database tables

- 계획 문서 기준: `seasonal_ingredients`
- 현재 구현 관련: `ingredients`
- 현재 구현 관련: `price_snapshots`

## Known deferred or placeholder behavior

- 실제 season domain과 계절 점수 산정은 완성되지 않았다.
- `seasonMonths`, `seasonScore`, `weeklySeason`, `freshnessLabel` 등은 placeholder, null, 빈 배열, 또는 시드 기반 값일 수 있다.
- `real-seasonal-ingredient-data-integration` 변경안은 팀 리뷰 전까지 구현 대상이 아니다.

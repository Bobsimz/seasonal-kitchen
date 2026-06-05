# price

## Purpose

식재료 가격 이력, 가격 요약, 구매처 오퍼, 가격 알림 API의 현재 동작을 정의한다.

## Requirements

### Requirement: 가격 스냅샷 이력 조회

시스템은 SHALL 식재료별 가격 스냅샷을 관측일 기준으로 조회해야 한다.

#### Scenario: 기간 조건으로 가격 이력을 조회한다

- **GIVEN** 활성 식재료와 `price_snapshots`가 존재한다
- **WHEN** `GET /api/v1/ingredients/{ingredientId}/prices?from={from}&to={to}`를 호출한다
- **THEN** 시스템은 기준 단위, 출처, 관측일, 가격 목록을 반환해야 한다

### Requirement: 구매처 오퍼 가격 비교

시스템은 SHALL 공공 평균 가격과 별도로 구매처 오퍼 가격을 조회해야 한다.

#### Scenario: 식재료 오퍼를 조회한다

- **GIVEN** `store_offers`와 `stores`가 존재한다
- **WHEN** `GET /api/v1/ingredients/{ingredientId}/offers`를 호출한다
- **THEN** 시스템은 매장명, 매장 유형, 가격, 단위, 할인, 배송 라벨, 상품 URL을 반환해야 한다

### Requirement: 가격 알림 관리

시스템은 SHALL 현재 사용자의 목표 가격 알림을 조회, 생성, 수정, 삭제할 수 있어야 한다.

#### Scenario: 가격 알림을 생성한다

- **GIVEN** 인증된 사용자와 활성 식재료가 존재한다
- **WHEN** `POST /api/v1/price-alerts`를 호출한다
- **THEN** 시스템은 `price_alerts`에 현재 사용자 알림을 저장해야 한다

## Related API endpoints

- `GET /api/v1/ingredients/{ingredientId}/prices`
- `GET /api/v1/ingredients/{ingredientId}/offers`
- `GET /api/v1/price-alerts`
- `POST /api/v1/price-alerts`
- `PATCH /api/v1/price-alerts/{alertId}`
- `DELETE /api/v1/price-alerts/{alertId}`

## Related database tables

- `price_snapshots`
- `price_forecasts`
- `stores`
- `store_offers`
- `price_alerts`
- `ingredients`
- `users`

## Known deferred or placeholder behavior

- 실제 KAMIS 가격 수집과 가격 전망 모델은 구현되어 있지 않다.
- `trendDirection`, `priceChangeLabel`, `yearAverageChangeRate` 등 일부 표시 필드는 단순 계산 또는 비어 있는 값일 수 있다.

# shopping

## Purpose

장보기 계획 조회, 장보기 항목 선택 상태 변경, 스토어별 구매 링크 조회의 현재 동작을 정의한다.

## Requirements

### Requirement: 장보기 계획 조회

시스템은 SHALL 현재 사용자의 장보기 계획을 조회할 수 있어야 한다.

#### Scenario: 장보기 계획을 조회한다

- **GIVEN** 인증된 사용자에게 속한 장보기 계획이 존재한다
- **WHEN** `GET /api/v1/shopping-plans/{planId}`를 호출한다
- **THEN** 시스템은 식단, 장보기 항목, 예상 총액, 절약 정보를 포함한 `ShoppingPlanResponse`를 반환해야 한다

### Requirement: 장보기 항목 선택 변경

시스템은 SHALL 장보기 계획 항목의 선택 여부를 변경할 수 있어야 한다.

#### Scenario: 장보기 항목을 선택 해제한다

- **GIVEN** 인증된 사용자의 장보기 계획과 항목이 존재한다
- **WHEN** `PATCH /api/v1/shopping-plans/{planId}/items/{itemId}`에 `selected=false`를 보낸다
- **THEN** 시스템은 해당 항목의 선택 상태를 갱신해야 한다

### Requirement: 스토어별 구매 링크 조회

시스템은 SHALL 장보기 항목을 스토어별로 묶어 구매 링크 응답을 제공해야 한다.

#### Scenario: 스토어 링크를 조회한다

- **GIVEN** 장보기 계획과 연결 가능한 `store_offers`가 존재한다
- **WHEN** `GET /api/v1/shopping-plans/{planId}/store-links`를 호출한다
- **THEN** 시스템은 `savingAmount`와 `storeGroups`를 반환해야 한다

## Related API endpoints

- `GET /api/v1/shopping-plans/{planId}`
- `PATCH /api/v1/shopping-plans/{planId}/items/{itemId}`
- `GET /api/v1/shopping-plans/{planId}/store-links`

## Related database tables

- `shopping_plans`
- `shopping_plan_meals`
- `shopping_plan_items`
- `recommendation_sessions`
- `recipes`
- `ingredients`
- `store_offers`
- `stores`

## Known deferred or placeholder behavior

- 실제 주문 생성과 결제는 구현되어 있지 않다.
- 스토어 링크는 외부 장보기 URL로 이동하기 위한 참조 데이터이며 실제 재고/배송 가능 여부를 보장하지 않는다.

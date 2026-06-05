# ai-chef

## Purpose

AI 장보기 추천 계획 생성, 추천 계획 조회, 추천 수정 메시지 등록의 현재 동작을 정의한다. 실제 LLM 연동은 보류되어 있으며 서버 규칙 기반 추천과 안전한 응답 구조를 기준으로 한다.

## Requirements

### Requirement: 장보기 추천 계획 생성

시스템은 SHALL 요청 조건을 기반으로 장보기 계획과 추천 세션을 생성해야 한다.

#### Scenario: 추천 계획을 생성한다

- **GIVEN** 인증된 사용자가 `days`, `people`, 선택적 `budget`을 보낸다
- **WHEN** `POST /api/v1/recommendations/plans`를 호출한다
- **THEN** 시스템은 `recommendation_sessions`와 `shopping_plans`를 생성하고 `ShoppingPlanResponse`를 반환해야 한다

### Requirement: 추천 계획 조회

시스템은 SHALL 현재 사용자 소유의 추천 계획을 조회할 수 있어야 한다.

#### Scenario: 추천 계획을 다시 조회한다

- **GIVEN** 인증된 사용자의 추천 계획이 존재한다
- **WHEN** `GET /api/v1/recommendations/plans/{planId}`를 호출한다
- **THEN** 시스템은 저장된 계획과 메시지를 반환해야 한다

### Requirement: 추천 수정 메시지 등록

시스템은 SHALL 추천 계획에 사용자 메시지를 추가할 수 있어야 한다.

#### Scenario: 추천 수정 메시지를 보낸다

- **GIVEN** 인증된 사용자의 추천 계획이 존재한다
- **WHEN** `POST /api/v1/recommendations/plans/{planId}/messages`를 호출한다
- **THEN** 시스템은 `recommendation_messages`에 사용자 메시지를 저장해야 한다

## Related API endpoints

- `POST /api/v1/recommendations/plans`
- `GET /api/v1/recommendations/plans/{planId}`
- `POST /api/v1/recommendations/plans/{planId}/messages`
- 관련 조회: `GET /api/v1/shopping-plans/{planId}`

## Related database tables

- `recommendation_sessions`
- `recommendation_messages`
- `shopping_plans`
- `shopping_plan_meals`
- `shopping_plan_items`
- `ingredients`
- `recipes`
- `price_snapshots`

## Known deferred or placeholder behavior

- 실제 LLM API 호출과 JSON Schema 기반 구조화 출력 검증은 보류되어 있다.
- AI는 DB에 없는 가격, 구매처, 식재료를 만들어내면 안 되며 현재 응답은 DB와 시드 데이터를 기반으로 해야 한다.
- 절약률, 대체 제안, 빠른 프롬프트는 단순 규칙 또는 placeholder일 수 있다.

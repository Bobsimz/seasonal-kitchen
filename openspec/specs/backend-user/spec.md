# user

## Purpose

현재 사용자 프로필, 선호도, 마이페이지 요약 API의 동작을 정의한다. 모든 사용자별 조회와 수정은 JWT 현재 사용자 기준으로 동작해야 한다.

## Requirements

### Requirement: 내 프로필 조회 및 수정

시스템은 SHALL 현재 사용자의 프로필을 조회하고 수정할 수 있어야 한다.

#### Scenario: 내 프로필을 조회한다

- **GIVEN** 인증된 사용자가 존재한다
- **WHEN** `GET /api/v1/users/me`를 호출한다
- **THEN** 시스템은 현재 사용자의 `email`, `nickname`, `profileImageUrl`, `status`를 포함한 프로필을 반환해야 한다

#### Scenario: 내 프로필을 수정한다

- **GIVEN** 인증된 사용자가 존재한다
- **WHEN** `PATCH /api/v1/users/me`를 호출한다
- **THEN** 시스템은 현재 사용자의 수정된 프로필을 반환해야 한다

### Requirement: 내 선호도 저장

시스템은 SHALL 현재 사용자의 가구원 수, 예산, 매운맛 회피 여부, 우선순위를 저장해야 한다.

#### Scenario: 선호도를 저장한다

- **GIVEN** 인증된 사용자가 유효한 선호도 요청을 보낸다
- **WHEN** `PUT /api/v1/users/me/preferences`를 호출한다
- **THEN** 시스템은 `user_preferences`를 생성 또는 갱신해야 한다

### Requirement: 마이페이지 요약 제공

시스템은 SHALL 프론트엔드 마이페이지에 필요한 프로필, 통계, 선호도 요약, 개인화 식재료, 메뉴 행을 제공해야 한다.

#### Scenario: 마이페이지 요약을 조회한다

- **GIVEN** 인증된 사용자가 존재한다
- **WHEN** `GET /api/v1/users/me/summary`를 호출한다
- **THEN** 시스템은 현재 사용자 기준 요약 응답을 반환해야 한다

## Related API endpoints

- `GET /api/v1/users/me`
- `PATCH /api/v1/users/me`
- `GET /api/v1/users/me/summary`
- `PUT /api/v1/users/me/preferences`

## Related database tables

- `users`
- `user_preferences`
- `user_allergies`
- `ingredients`
- `favorites`
- `price_alerts`
- `notifications`

## Known deferred or placeholder behavior

- 알레르기 코드 카탈로그 API는 별도 구현되어 있지 않다.
- 월간 절약액, 주문 횟수 등 일부 통계는 실제 결제/주문 데이터가 없어 placeholder 또는 단순 계산일 수 있다.
- 보유 재료(pantry) 기능은 현재 제품 범위에서 제외되었다.

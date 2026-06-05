# favorite

## Purpose

현재 사용자의 찜 목록, 찜 추가, 찜 삭제 동작을 정의한다.

## Requirements

### Requirement: 내 찜 목록 조회

시스템은 SHALL 현재 사용자의 찜 목록을 반환해야 한다.

#### Scenario: 찜 목록을 조회한다

- **GIVEN** 인증된 사용자가 찜한 대상이 존재한다
- **WHEN** `GET /api/v1/favorites`를 호출한다
- **THEN** 시스템은 현재 사용자의 찜 목록만 반환해야 한다

### Requirement: 찜 추가

시스템은 SHALL 현재 사용자가 식재료 또는 레시피 등 대상에 찜을 추가할 수 있어야 한다.

#### Scenario: 새 찜을 추가한다

- **GIVEN** 인증된 사용자와 유효한 `targetType`, `targetId`가 있다
- **WHEN** `POST /api/v1/favorites`를 호출한다
- **THEN** 시스템은 `favorites`에 사용자별 유일한 찜을 저장해야 한다

### Requirement: 찜 삭제

시스템은 SHALL 현재 사용자의 찜 항목만 삭제할 수 있어야 한다.

#### Scenario: 내 찜을 삭제한다

- **GIVEN** 인증된 사용자의 찜 항목이 존재한다
- **WHEN** `DELETE /api/v1/favorites/{favoriteId}`를 호출한다
- **THEN** 시스템은 해당 찜을 삭제해야 한다

## Related API endpoints

- `GET /api/v1/favorites`
- `POST /api/v1/favorites`
- `DELETE /api/v1/favorites/{favoriteId}`

## Related database tables

- `favorites`
- `users`
- `ingredients`
- `recipes`

## Known deferred or placeholder behavior

- `targetType`별 상세 대상 검증 범위는 현재 구현 수준에 따른다.
- 릴스 저장과 레시피 저장 UX는 `favorites`와 완전히 통합되지 않았을 수 있다.

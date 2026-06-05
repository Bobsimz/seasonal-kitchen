# auth

## Purpose

현재 인증 동작을 정의한다. 운영 OAuth 로그인은 보류되어 있으며, 현재 사용자 식별은 JWT 기반으로 동작하고 로컬/개발/테스트 프로필에서는 임시 개발 토큰 발급 API를 제공한다.

## Requirements

### Requirement: JWT 현재 사용자 식별

시스템은 SHALL 인증이 필요한 사용자 API에서 JWT를 해석해 현재 사용자 ID를 결정해야 한다.

#### Scenario: 유효한 JWT로 보호 API를 호출한다

- **GIVEN** 클라이언트가 유효한 Bearer JWT를 보낸다
- **WHEN** 보호 API가 현재 사용자 ID를 요청한다
- **THEN** 시스템은 토큰의 사용자 ID를 사용해야 한다

### Requirement: 개발용 토큰 발급

시스템은 SHALL `local`, `dev`, `test` 프로필에서만 개발용 JWT를 발급해야 한다.

#### Scenario: 개발 환경에서 토큰을 발급한다

- **GIVEN** `userId`가 포함된 요청이 들어온다
- **WHEN** `POST /api/v1/dev/auth/token`을 호출한다
- **THEN** 시스템은 해당 사용자 ID를 담은 access token을 반환해야 한다

### Requirement: OAuth 엔드포인트 보류

시스템은 SHALL 현재 운영 OAuth 로그인 흐름을 완성된 기능으로 간주하지 않아야 한다.

#### Scenario: OAuth 로그인을 검토한다

- **GIVEN** 프론트엔드에 Kakao, Apple, Google 로그인 버튼이 있다
- **WHEN** 현재 백엔드 기준선을 검토한다
- **THEN** OAuth provider 연동은 보류 항목으로 기록해야 한다

## Related API endpoints

- `POST /api/v1/dev/auth/token`
- 계획 문서 기준 보류: `POST /api/v1/auth/oauth/{provider}`
- 계획 문서 기준 보류: `POST /api/v1/auth/refresh`
- 계획 문서 기준 보류: `POST /api/v1/auth/logout`

## Related database tables

- `users`
- `oauth_accounts`
- `refresh_tokens`

## Known deferred or placeholder behavior

- OAuth provider 실제 인증, refresh token 재발급, logout token revoke 흐름은 보류되어 있다.
- 개발용 토큰 API는 임시 기능이며 운영 프로필에서 사용하면 안 된다.

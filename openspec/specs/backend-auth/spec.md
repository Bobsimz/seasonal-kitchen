# auth

## Purpose

현재 인증 동작을 정의한다. MVP 인증은 **이메일/비밀번호 회원가입·로그인**만 지원하며,
두 흐름 모두 JWT access token을 발급한다. 사용자 식별은 JWT 기반으로 동작한다.
OAuth(소셜 로그인), refresh token 재발급, logout token revoke는 고도화/future 항목이다.
`local`/`dev`/`test` 프로필에서는 임시 개발 토큰 발급 API를 추가로 제공한다.

## Requirements

### Requirement: 이메일 회원가입

시스템은 SHALL 이메일/비밀번호/닉네임으로 사용자를 생성하고 JWT access token을 발급해야 한다.
비밀번호는 SHALL 평문으로 저장하지 않고 BCrypt 해시(`users.password_hash`)로 저장해야 한다.

#### Scenario: 새 이메일로 가입한다

- **GIVEN** 미가입 이메일, 8자 이상 비밀번호, 미사용 닉네임이 주어진다
- **WHEN** `POST /api/v1/auth/signup`을 호출한다
- **THEN** 시스템은 사용자를 생성하고 `accessToken`, `tokenType=Bearer`, `userId`, `nickname`을 반환해야 한다
- **AND** 비밀번호는 BCrypt 해시로 저장해야 한다

#### Scenario: 이미 가입된 이메일이다

- **GIVEN** 이미 존재하는 이메일이 주어진다
- **WHEN** 회원가입을 시도한다
- **THEN** 시스템은 `AUTH_EMAIL_DUPLICATE`(409)를 반환해야 한다

#### Scenario: 이미 사용 중인 닉네임이다

- **GIVEN** 이미 존재하는 닉네임이 주어진다
- **WHEN** 회원가입을 시도한다
- **THEN** 시스템은 `AUTH_NICKNAME_DUPLICATE`(409)를 반환해야 한다

### Requirement: 이메일 로그인

시스템은 SHALL 이메일/비밀번호를 검증하고 일치하면 JWT access token을 발급해야 한다.

#### Scenario: 올바른 자격으로 로그인한다

- **GIVEN** 가입된 이메일과 올바른 비밀번호가 주어진다
- **WHEN** `POST /api/v1/auth/login`을 호출한다
- **THEN** 시스템은 `accessToken`, `tokenType=Bearer`, `userId`, `nickname`을 반환해야 한다

#### Scenario: 자격이 올바르지 않다

- **GIVEN** 존재하지 않는 이메일이거나 비밀번호가 틀리거나 비밀번호가 설정되지 않은 사용자다
- **WHEN** 로그인을 시도한다
- **THEN** 시스템은 `AUTH_INVALID_CREDENTIALS`(401)를 반환해야 한다

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

## Related API endpoints

- `POST /api/v1/auth/signup`
- `POST /api/v1/auth/login`
- `POST /api/v1/dev/auth/token` (local/dev/test 전용)

## Related database tables

- `users` (`password_hash` 컬럼 포함)
- `oauth_accounts` (future, 유지)
- `refresh_tokens` (future, 유지)

## Out of Scope (MVP) / Future

- OAuth provider(kakao/apple/google) 로그인: `POST /api/v1/auth/oauth/{provider}`
- Refresh token 재발급: `POST /api/v1/auth/refresh`
- Logout token revoke: `POST /api/v1/auth/logout`
- 위 흐름을 위한 `oauth_accounts`/`refresh_tokens` 테이블은 스키마만 유지하고 사용은 보류한다.
- 동시 가입 중 DB unique 제약 위반을 도메인 오류로 매핑하는 보강은 future hardening으로 둔다.

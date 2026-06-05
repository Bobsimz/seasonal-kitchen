# common-api-contract

## Purpose

현재 구현된 백엔드 API의 공통 계약을 정의한다. 모든 도메인 API는 `/api/v1` 하위에서 공통 응답 래퍼, 공통 목록 형식, 공통 오류 형식을 유지해야 한다.

## Requirements

### Requirement: 공통 성공 응답 형식

시스템은 SHALL 성공 응답을 `ApiResponse<T>` 형식으로 반환해야 한다.

#### Scenario: 단건 또는 객체 응답을 반환한다

- **GIVEN** 클라이언트가 정상 요청을 보낸다
- **WHEN** 컨트롤러가 응답 DTO를 반환한다
- **THEN** 응답은 `success=true`, `data`, `error=null`, `traceId` 필드를 포함해야 한다

### Requirement: 공통 목록 응답 형식

시스템은 SHALL 페이지네이션 목록에 `ListResponse<T>` 형식을 사용해야 한다.

#### Scenario: 페이지 목록을 조회한다

- **GIVEN** 클라이언트가 목록 API를 호출한다
- **WHEN** 조회 결과가 페이지로 반환된다
- **THEN** `items`, `page`, `size`, `totalElements`, `hasNext`를 포함해야 한다

### Requirement: 공통 오류 응답 형식

시스템은 SHALL 검증 실패, 인증 실패, 미존재 리소스 등 오류를 공통 오류 형식으로 반환해야 한다.

#### Scenario: 요청 검증에 실패한다

- **GIVEN** 요청 DTO의 Bean Validation 조건을 만족하지 않는 요청이 들어온다
- **WHEN** 시스템이 요청을 검증한다
- **THEN** `success=false`, `data=null`, `error.code`, `error.message`, `error.fieldErrors`, `traceId`를 포함해야 한다

## Related API endpoints

- `GET /api/v1/health`
- 모든 `/api/v1/**` 도메인 API
- Swagger UI: `/swagger-ui.html`
- OpenAPI JSON: `/v3/api-docs`

## Related database tables

- 도메인별 테이블 전체
- `schema_version_note`

## Known deferred or placeholder behavior

- 일부 화면 표시용 라벨은 서버 계산값이 아니라 시드 데이터 또는 단순 계산값일 수 있다.
- 실서비스 외부 데이터, OAuth, LLM 연동은 아직 완전 구현이 아니다.

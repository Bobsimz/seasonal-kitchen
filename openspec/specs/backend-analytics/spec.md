# analytics

## Purpose

사용자 행동 이벤트 수집 API의 현재 동작을 정의한다.

## Requirements

### Requirement: 사용자 이벤트 기록

시스템은 SHALL 클라이언트에서 전달한 행동 이벤트를 저장해야 한다.

#### Scenario: 이벤트를 기록한다

- **GIVEN** 클라이언트가 이벤트 유형과 선택적 대상 정보를 보낸다
- **WHEN** `POST /api/v1/events`를 호출한다
- **THEN** 시스템은 `user_events`에 이벤트를 저장하고 저장된 이벤트 응답을 반환해야 한다

### Requirement: 인증 사용자와 비인증 이벤트 처리

시스템은 SHALL 사용자 ID가 확인되는 경우 이벤트에 사용자 ID를 연결하고, 확인되지 않는 경우에도 허용된 이벤트를 저장할 수 있어야 한다.

#### Scenario: 인증 사용자가 이벤트를 보낸다

- **GIVEN** 유효한 JWT가 포함된 요청이다
- **WHEN** 이벤트를 기록한다
- **THEN** 시스템은 `user_events.user_id`에 현재 사용자 ID를 저장해야 한다

## Related API endpoints

- `POST /api/v1/events`
- 릴스 조회 이벤트 관련: `POST /api/v1/reels/{reelId}/view-events`

## Related database tables

- `user_events`
- `users`
- `outbox_events`
- `reels`

## Known deferred or placeholder behavior

- 이벤트 비동기 처리, 외부 분석 도구 전송, outbox processor는 완성된 범위가 아니다.
- 이벤트 메타데이터는 `metadata_json` 문자열로 저장되며 엄격한 분석 스키마는 추가 검토가 필요하다.

# notification

## Purpose

알림 목록, 단건 읽음 처리, 전체 읽음 처리의 현재 동작을 정의한다.

## Requirements

### Requirement: 알림 목록 조회

시스템은 SHALL 현재 사용자의 알림 목록과 탭 카운트를 반환해야 한다.

#### Scenario: 알림 목록을 조회한다

- **GIVEN** 인증된 사용자에게 알림이 존재한다
- **WHEN** `GET /api/v1/notifications`를 호출한다
- **THEN** 시스템은 `data.items`와 `data.tabCounts`를 포함한 `NotificationListResponse`를 반환해야 한다

### Requirement: 단건 알림 읽음 처리

시스템은 SHALL 현재 사용자의 특정 알림을 읽음 처리해야 한다.

#### Scenario: 알림 하나를 읽음 처리한다

- **GIVEN** 인증된 사용자의 읽지 않은 알림이 존재한다
- **WHEN** `PATCH /api/v1/notifications/{notificationId}/read`를 호출한다
- **THEN** 시스템은 `readAt`을 설정한 알림을 반환해야 한다

### Requirement: 전체 알림 읽음 처리

시스템은 SHALL 현재 사용자의 모든 읽지 않은 알림을 읽음 처리해야 한다.

#### Scenario: 모든 알림을 읽음 처리한다

- **GIVEN** 인증된 사용자에게 읽지 않은 알림이 존재한다
- **WHEN** `PATCH /api/v1/notifications/read-all`을 호출한다
- **THEN** 시스템은 현재 사용자의 읽지 않은 알림을 모두 읽음 처리해야 한다

## Related API endpoints

- `GET /api/v1/notifications`
- `PATCH /api/v1/notifications/{notificationId}/read`
- `PATCH /api/v1/notifications/read-all`

## Related database tables

- `notifications`
- `users`

## Known deferred or placeholder behavior

- 알림 목록 응답은 이전 plain list에서 `data.items + data.tabCounts` 형태로 변경되어 프론트엔드 호환성 확인이 필요하다.
- 상대 시간, 아이콘, severity, action target 등 일부 화면 표시 필드는 실제 도메인 이벤트와 완전히 연결되지 않았을 수 있다.

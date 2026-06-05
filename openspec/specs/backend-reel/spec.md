# reel

## Purpose

릴스 피드, 상세, 좋아요, 댓글, 조회 이벤트 API의 현재 동작을 정의한다.

## Requirements

### Requirement: 릴스 피드 조회

시스템은 SHALL 게시된 릴스 목록을 페이지네이션으로 반환해야 한다.

#### Scenario: 릴스 피드를 조회한다

- **GIVEN** 게시된 릴스와 크리에이터가 존재한다
- **WHEN** `GET /api/v1/reels`를 호출한다
- **THEN** 시스템은 `ReelResponse` 목록을 `ListResponse`로 반환해야 한다

### Requirement: 릴스 상호작용

시스템은 SHALL 현재 사용자의 좋아요 생성/삭제, 댓글 조회/등록, 조회 이벤트 기록을 지원해야 한다.

#### Scenario: 릴스에 좋아요를 추가한다

- **GIVEN** 인증된 사용자와 릴스가 존재한다
- **WHEN** `POST /api/v1/reels/{reelId}/likes`를 호출한다
- **THEN** 시스템은 현재 사용자의 `LIKE` 반응을 저장해야 한다

#### Scenario: 릴스 댓글을 등록한다

- **GIVEN** 인증된 사용자와 릴스가 존재한다
- **WHEN** `POST /api/v1/reels/{reelId}/comments`를 호출한다
- **THEN** 시스템은 공개 가능한 댓글을 저장하고 반환해야 한다

## Related API endpoints

- `GET /api/v1/reels`
- `GET /api/v1/reels/{reelId}`
- `POST /api/v1/reels/{reelId}/likes`
- `DELETE /api/v1/reels/{reelId}/likes`
- `GET /api/v1/reels/{reelId}/comments`
- `POST /api/v1/reels/{reelId}/comments`
- `POST /api/v1/reels/{reelId}/view-events`

## Related database tables

- `creators`
- `reels`
- `reel_reactions`
- `reel_comments`
- `recipes`
- `users`
- `user_events`

## Known deferred or placeholder behavior

- 영상 파일 저장소와 업로드/관리자 검수 API는 구현 범위 밖이다.
- 저장 수(`saveCount`)와 저장 상태(`saved`)는 실제 저장 도메인과 완전히 연결되지 않았을 수 있다.

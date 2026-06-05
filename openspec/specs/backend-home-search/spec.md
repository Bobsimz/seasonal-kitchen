# home-search

## Purpose

홈 화면과 검색 화면에 필요한 집계 응답의 현재 동작을 정의한다.

## Requirements

### Requirement: 홈 화면 데이터 조회

시스템은 SHALL 홈 화면에 필요한 제철 문구, 히어로, 추천 식재료, 추천 레시피, 릴스, 인기 검색어, 읽지 않은 알림 수를 반환해야 한다.

#### Scenario: 홈을 조회한다

- **GIVEN** 클라이언트가 홈 화면을 렌더링하려고 한다
- **WHEN** `GET /api/v1/home`을 호출한다
- **THEN** 시스템은 `HomeResponse`를 반환해야 한다

### Requirement: 통합 검색

시스템은 SHALL 검색어와 유형 조건을 기준으로 식재료, 레시피, 릴스 검색 결과를 반환해야 한다.

#### Scenario: 전체 검색을 수행한다

- **GIVEN** 검색어 `q`가 제공된다
- **WHEN** `GET /api/v1/search?q={q}&type=ALL`을 호출한다
- **THEN** 시스템은 호환용 flat `items`와 그룹별 `ingredients`, `recipes`, `reels`, 각 count를 반환해야 한다

### Requirement: 인기 검색어와 최근 검색어 조회

시스템은 SHALL 인기 검색어와 현재 사용자의 최근 검색어를 조회할 수 있어야 한다.

#### Scenario: 최근 검색어를 조회한다

- **GIVEN** 인증된 사용자의 최근 검색 기록이 존재한다
- **WHEN** `GET /api/v1/users/me/recent-searches`를 호출한다
- **THEN** 시스템은 현재 사용자 기준 최근 검색어를 반환해야 한다

## Related API endpoints

- `GET /api/v1/home`
- `GET /api/v1/search`
- `GET /api/v1/search/trending`
- `GET /api/v1/users/me/recent-searches`

## Related database tables

- `ingredients`
- `recipes`
- `reels`
- `creators`
- `search_keywords`
- `recent_searches`
- `notifications`
- `users`

## Known deferred or placeholder behavior

- `weeklySeason`, `seasonTitle`, `seasonSubtitle`는 실제 절기 데이터와 완전히 연결되지 않았을 수 있다.
- 검색 랭킹과 인기 검색어는 단순 카운트 또는 시드 데이터 기반일 수 있다.

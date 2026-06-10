# frontend-integration

## Purpose

현재 Next.js 프로토타입 화면이 백엔드 API로 교체될 때 필요한 응답 계약과 알려진 호환성 위험을 정의한다.

## Requirements

### Requirement: 프로토타입 화면의 표시 데이터를 API로 제공

시스템은 SHALL 홈, 상품, 식재료, 레시피, 릴스, 마이페이지, 알림 화면에 보이는 카드, 리스트, 가격, 개수, 라벨을 API 응답으로 제공해야 한다.

#### Scenario: 홈 화면을 API 데이터로 렌더링한다

- **GIVEN** 프론트엔드가 홈 화면을 렌더링한다
- **WHEN** `GET /api/v1/home`을 호출한다
- **THEN** 시스템은 히어로, 추천 식재료, 추천 레시피, 릴스, 인기 검색어, 알림 수를 포함해야 한다

### Requirement: 화면별 주요 API 연결

시스템은 SHALL 프론트엔드 화면별로 필요한 대표 API를 유지해야 한다.

#### Scenario: 가격 비교 화면을 렌더링한다

- **GIVEN** 프론트엔드가 식재료 상세에서 가격 비교로 이동한다
- **WHEN** `GET /api/v1/ingredients/{ingredientId}/offers`를 호출한다
- **THEN** 시스템은 스토어별 가격 비교 카드를 렌더링할 수 있는 필드를 반환해야 한다

#### Scenario: 상품 탭을 농가/오퍼 데이터로 렌더링한다

- **GIVEN** 프론트엔드가 상품 탭 또는 농가 상세를 표시한다
- **WHEN** `GET /api/v1/producers`와 `GET /api/v1/producers/{producerId}/offers`를 호출한다
- **THEN** 시스템은 농가 카드, 판매 식재료, 가격, 단위, 신선도 라벨을 반환해야 한다

#### Scenario: 농가 상품 등록 화면을 렌더링한다

- **GIVEN** 로그인 사용자가 마이페이지에서 농가 등록 또는 상품 등록을 진행한다
- **WHEN** `POST /api/v1/producers/me` 또는 `POST /api/v1/producers/me/offers`를 호출한다
- **THEN** 시스템은 내 농가 프로필과 판매 오퍼를 생성하고 반환해야 한다

### Requirement: 알림 응답 형태 변경 고지

시스템은 SHALL 알림 목록 응답이 plain list가 아니라 `data.items + data.tabCounts`임을 프론트엔드 계약으로 명시해야 한다.

#### Scenario: 알림 화면을 렌더링한다

- **GIVEN** 프론트엔드가 알림 목록을 조회한다
- **WHEN** `GET /api/v1/notifications`를 호출한다
- **THEN** 클라이언트는 `data.items`에서 알림 목록을 읽고 `data.tabCounts`에서 탭 카운트를 읽어야 한다

## Related API endpoints

- `GET /api/v1/home`
- `GET /api/v1/search`
- `GET /api/v1/ingredients`
- `GET /api/v1/ingredients/{ingredientId}`
- `GET /api/v1/ingredients/{ingredientId}/offers`
- `GET /api/v1/recipes`
- `GET /api/v1/recipes/{recipeId}`
- `GET /api/v1/reels`
- `GET /api/v1/producers`
- `GET /api/v1/producers/{producerId}`
- `GET /api/v1/producers/{producerId}/offers`
- `GET /api/v1/ingredients/{ingredientId}/producers`
- `POST /api/v1/producers/me`
- `GET /api/v1/producers/me`
- `POST /api/v1/producers/me/offers`
- `GET /api/v1/users/me/summary`
- `GET /api/v1/notifications`

## Related database tables

- `ingredients`
- `price_snapshots`
- `stores`
- `store_offers`
- `recipes`
- `reels`
- `favorites`
- `price_alerts`
- `producers`
- `producer_specialties`
- `producer_offers`
- `notifications`
- `search_keywords`
- `recent_searches`

## Known deferred or placeholder behavior

- 프론트엔드는 아직 production 앱이라기보다 화면 프로토타입이다.
- demo seed 데이터는 화면 비어 있음 방지를 위한 목적이며 실제 외부 데이터 품질을 보장하지 않는다.
- 전용 products API, 실제 OAuth, 외부 제철/가격 데이터, 판매자 AI 연동 전까지 일부 라벨과 추천 품질은 제한적이다.

## ADDED Requirements

### Requirement: 사용자가 농가로 등록한다

로그인 사용자는 SHALL 본인을 농가(생산자)로 등록할 수 있어야 한다. 한 사용자당 농가는 1개다.
등록 시 `producers.user_id`로 사용자와 연결하고, `rating=0`/`review_count=0`/`honorary=false`로 초기화한다.

#### Scenario: 마이페이지에서 농가로 등록한다
- **GIVEN** 농가로 등록하지 않은 로그인 사용자가 이름·지역·스타일과 선택 항목(소개·사진·취급품목·배지)을 제출한다
- **WHEN** `POST /api/v1/producers/me`를 호출한다
- **THEN** 시스템은 농가를 생성해 사용자와 연결하고 농가 상세를 반환한다
- **AND** 취급품목(specialties)과 배지(badges)를 함께 저장한다

#### Scenario: 이미 농가로 등록된 사용자다
- **GIVEN** 이미 농가로 등록한 사용자다
- **WHEN** 다시 농가 등록을 시도한다
- **THEN** 시스템은 `PRODUCER_ALREADY_REGISTERED`(409)를 반환한다

#### Scenario: 내 농가 조회
- **GIVEN** 로그인 사용자
- **WHEN** `GET /api/v1/producers/me`를 호출한다
- **THEN** 등록했으면 내 농가 상세를, 미등록이면 `PRODUCER_NOT_FOUND`(404)를 반환한다

### Requirement: 농가가 판매 상품을 등록한다

농가로 등록한 사용자는 SHALL 본인 농가에 판매 상품(offer)을 등록할 수 있어야 한다.

#### Scenario: 내 농가에 상품을 등록한다
- **GIVEN** 농가로 등록한 사용자가 식재료명·가격·단위(+선택 ingredientId·신선도)를 제출한다
- **WHEN** `POST /api/v1/producers/me/offers`를 호출한다
- **THEN** 시스템은 해당 농가의 producer_offer를 생성하고 오퍼를 반환한다
- **AND** `ingredientId`가 주어지면 활성 식재료인지 검증하고(없으면 `INGREDIENT_NOT_FOUND`), 비어 있으면 식재료명으로 해석을 시도한다
- **AND** 해당 식재료명이 농가의 specialty에 없으면 추가하여(upsert) 농가 검색/목록에서 새 상품이 누락되지 않게 한다

#### Scenario: 농가 프로필 없이 상품 등록
- **GIVEN** 농가로 등록하지 않은 사용자다
- **WHEN** 상품 등록을 시도한다
- **THEN** 시스템은 `PRODUCER_NOT_FOUND`(404)를 반환한다

## Design Notes

- 권한(MVP): 로그인만 확인. `user_id`로 "내 농가"를 식별하므로 소유권은 자동 보장(남의 농가 수정 불가).
- 입력 항목은 `producers` 스키마에 매핑: name/region/tagline/photo_url/style/price_level/freshness_level + specialties[]/badges[]. rating/review_count/honorary는 시스템 관리(입력받지 않음).
- 시드(V14) 농가는 `user_id=NULL`로 공존한다.

## Out of Scope (MVP) / Future

- 농가 프로필 수정/삭제(`PATCH`/`DELETE /producers/me`).
- 사업자등록번호·연락처·배송정책·정산계좌 등 실서비스 판매자 정보.
- 판매자 AI(가격 추천·홍보글) — 별도.
- 농가 인증/심사(유기농 인증 검증 등). 현재 배지는 자기신고.

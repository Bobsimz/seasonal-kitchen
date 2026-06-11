## ADDED Requirements

### Requirement: 판매자 등록은 신원·연락·약관 동의를 받는다

농가 자가등록(`POST /api/v1/producers/me`)은 SHALL 농가명·대표자명·지역·연락처·주요 판매 품목을 받고,
판매자 약관 동의(필수)를 확인해야 한다. 인증 서류 URL은 선택이며 심사는 추후로 둔다.
스타일·가격대·신선도·배지는 등록 화면에서 받지 않으며 시스템 기본값으로 채운다.

#### Scenario: 판매자 등록 화면 입력으로 농가를 등록한다
- **GIVEN** 로그인 사용자가 농가명·대표자명·지역·연락처·주요 품목과 약관 동의(true)를 제출한다
- **WHEN** `POST /api/v1/producers/me`를 호출한다
- **THEN** 시스템은 농가를 생성하고 신원/연락/인증/약관 값을 저장한다
- **AND** style/priceLevel/freshnessLevel은 기본값(VALUE/3/4)으로 채운다
- **AND** 주요 품목을 specialty로 저장한다

#### Scenario: 약관에 동의하지 않으면 거부한다
- **GIVEN** `agreedToTerms`가 false인 요청
- **WHEN** 농가 등록을 호출한다
- **THEN** 시스템은 `COMMON_VALIDATION_FAILED`(400)를 반환한다

#### Scenario: 대표자명·연락처는 공개 응답에 노출하지 않는다
- **GIVEN** 등록된 농가
- **WHEN** 공개 농가 상세(`GET /api/v1/producers/{id}`)를 조회한다
- **THEN** 응답에 대표자명·연락처·인증서류는 포함하지 않는다

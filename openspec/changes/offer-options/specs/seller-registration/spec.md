## ADDED Requirements

### Requirement: 상품에 옵션(규격/variant)을 둘 수 있다

상품(offer)은 SHALL 여러 옵션을 가질 수 있어야 한다. 각 옵션은 수량(선택)·단위(선택)·가격(필수, ≥0)으로 구성되며,
옵션 라벨은 시스템이 열거하지 않고 판매자가 정의한다. 옵션은 선택사항이며 없으면 빈 배열로 동작한다.

#### Scenario: 옵션과 함께 상품을 등록한다
- **GIVEN** 농가로 등록한 사용자가 상품 기본정보와 옵션 목록(수량+단위+가격)을 제출한다
- **WHEN** `POST /api/v1/producers/me/offers`를 호출한다
- **THEN** 시스템은 옵션을 입력 순서대로 저장한다
- **AND** 응답의 options에 각 옵션(id/quantity/unit/price)을 포함한다

#### Scenario: 가격 없는 옵션은 검증 오류다
- **GIVEN** 옵션 중 price가 없는 행이 포함된다
- **WHEN** 상품 등록을 호출한다
- **THEN** 시스템은 `COMMON_VALIDATION_FAILED`(400)를 반환한다 (옵션 price는 필수)

#### Scenario: 옵션 없이 등록한다
- **GIVEN** 옵션을 제출하지 않는다
- **WHEN** 상품을 등록한다
- **THEN** 시스템은 options를 빈 배열로 반환한다

#### Scenario: 상품 조회가 옵션을 포함한다
- **GIVEN** 옵션이 저장된 상품이 있다
- **WHEN** 농가 상품 목록(`GET /api/v1/producers/{id}/offers`)을 조회한다
- **THEN** 각 상품의 options가 정렬 순서대로 포함된다

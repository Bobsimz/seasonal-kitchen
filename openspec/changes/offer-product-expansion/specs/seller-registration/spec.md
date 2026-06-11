## ADDED Requirements

### Requirement: 농가 상품에 상품 속성을 부여한다

농가가 등록하는 상품(offer)은 SHALL 식재료명·가격·단위에 더해 선택적 상품 속성
(상품명·설명·카테고리·사진 목록·태그 목록)을 가질 수 있어야 한다. 모든 상품 속성은 optional이며,
비어 있으면 식재료명/빈 배열로 동작한다(하위호환).

#### Scenario: 상품 속성과 함께 상품을 등록한다
- **GIVEN** 농가로 등록한 사용자가 식재료명·가격·단위와 함께 상품명·설명·카테고리·사진 목록·태그 목록을 제출한다
- **WHEN** `POST /api/v1/producers/me/offers`를 호출한다
- **THEN** 시스템은 offer를 생성하고 사진(첫 번째를 대표로)과 태그를 함께 저장한다
- **AND** 응답에 title/description/category/photoUrls/tags를 포함한다

#### Scenario: 상품 속성 없이 등록한다(하위호환)
- **GIVEN** 식재료명·가격·단위만 제출한다
- **WHEN** 상품을 등록한다
- **THEN** 시스템은 offer를 생성하고 photoUrls/tags는 빈 배열로 반환한다

### Requirement: 상품 조회 응답에 상품 속성을 포함한다

농가 상품 조회(`GET /api/v1/producers/{id}/offers`)와 식재료별 농가 비교(`GET /api/v1/ingredients/{id}/producers`)는 SHALL 각 offer의 상품 속성(title/description/category/photoUrls/tags)을 함께 반환해야 한다.

#### Scenario: 농가 상품 목록 조회
- **GIVEN** 상품 속성이 저장된 offer들이 있다
- **WHEN** 농가 상품 목록을 조회한다
- **THEN** 각 항목에 title/description/category/photoUrls/tags가 포함된다

# Offer → 상품(Product) 확장

## Why

프론트 상품 화면(16 상품 리스트 / 17 상품 상세 / 25 판매 등록)은 "상품 리스팅" 개념을 요구한다:
상품명("햇 봄동 1.5kg 산지직송"), 상품 설명, 카테고리, 상품 사진(다중), 상품 태그(산지직송·무료배송·콜드체인 등).
현재 백엔드 `producer_offers`는 식재료명·가격·단위·신선도만 있어 이 화면들을 채울 수 없다.

장바구니가 이미 `offerId`를 참조하므로, 별도 `product` 테이블 신설보다 **offer를 상품으로 승격**하는 것이 단순하고 중복이 없다.

## What Changes

- `producer_offers`에 상품 속성 추가: `title`, `description`, `category`.
- 사진·태그는 **정규화 테이블**로 분리: `offer_photos`(다중, 대표 지정), `offer_tags`(다중).
- 상품 등록(`POST /api/v1/producers/me/offers`)이 위 필드를 함께 받아 저장.
- 상품 조회(`GET /api/v1/producers/{id}/offers`, `GET /api/v1/ingredients/{id}/producers`)가 title/description/category/photos/tags를 함께 반환.
- 모든 신규 필드는 nullable/optional — 기존 offer 및 시드 데이터 호환.
- 상품 옵션(규격/variant), 검색 PRODUCT 타입, 판매자 AI는 **별도 change**로 분리(out of scope).

## Impact

- Affected specs: `seller-registration`, `producer-directory`
- Affected code: `producer` 도메인(엔티티/리포지토리/DTO/서비스), 마이그레이션 V23
- Affected DB: `producer_offers`(+컬럼), `offer_photos`(신규), `offer_tags`(신규)

# 상품 옵션(규격/variant) 추가

## Why

프론트 상품 상세(화면 17)는 한 상품 안에서 규격/종류를 고르는 "옵션"을 보여준다
(예: 보통 1.2kg / 대 1.8kg / 세척무 1.0kg, 각 가격 상이). 현재 offer는 가격·단위가 1개뿐이라 표현 불가.

옵션 종류(단·되·개·kg…)는 무한히 많으므로 **시스템이 라벨을 열거하지 않는다.**
판매자가 정의하는 자유 행으로 두되, 오타·기능파손을 줄이기 위해 **수량(숫자)+단위(자유, 추천목록 UX)+가격(숫자)** 으로 반-구조화한다.

## What Changes

- 신규 테이블 `offer_options`(offer_id, quantity, unit, price, sort_order).
- 상품 등록(`POST /api/v1/producers/me/offers`)이 옵션 목록을 함께 받는다(선택, `@Valid`, price 필수·≥0).
- 상품 조회 응답(`ProducerOfferResponse`)에 옵션 목록을 포함한다.
- 옵션 라벨은 표시용이며 가격비교/정렬은 ingredientId+price 기반이라 옵션 단위 오타에 영향받지 않는다.

## Out of Scope / Future

- 장바구니의 옵션 선택(`cart_items.option_id`)은 별도 작업(cart 변경 필요). 현재는 상품 등록/표시까지.
- 단위 동의어 정규화(키로→kg 등)는 선택적 후속.

## Impact

- Affected specs: `seller-registration`
- Affected code: producer 도메인(OfferOption 엔티티/리포지토리, CreateOfferRequest/ProducerOfferResponse, ProducerService), 마이그레이션 V24

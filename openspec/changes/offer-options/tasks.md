# Tasks — 상품 옵션

- [x] 1. V24: offer_options 테이블
- [x] 2. OfferOption 엔티티 + OfferOptionRepository(단건/배치 조회)
- [x] 3. CreateOfferRequest.OptionInput(수량+단위+가격, @Valid) 추가
- [x] 4. ProducerOfferResponse.OptionResponse 추가
- [x] 5. ProducerService: addMyOffer 옵션 저장 + toOffer/toOffers 옵션 집계(배치)
- [x] 6. 테스트(옵션 저장/순서/조회) — 작성됨, 호스트에서 gradlew test
- [ ] 7. (future) 장바구니 옵션 선택(cart_items.option_id)

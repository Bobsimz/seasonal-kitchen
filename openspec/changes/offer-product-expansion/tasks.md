# Tasks — Offer → 상품 확장

## 1. 마이그레이션
- [x] 1.1 V23: producer_offers에 title/description/category 추가
- [x] 1.2 V23: offer_photos, offer_tags 테이블 생성(+인덱스, FK)

## 2. 엔티티 / 리포지토리
- [x] 2.1 ProducerOffer에 title/description/category + 확장 팩토리
- [x] 2.2 OfferPhoto, OfferTag 엔티티
- [x] 2.3 OfferPhotoRepository, OfferTagRepository

## 3. DTO
- [x] 3.1 CreateOfferRequest에 title/description/category/photoUrls/tags(검증)
- [x] 3.2 ProducerOfferResponse에 동일 필드 + photoUrls/tags

## 4. 서비스
- [x] 4.1 addMyOffer: 상품 필드 저장 + 사진(대표 지정)/태그 저장
- [x] 4.2 toOffer: 사진/태그 집계 반환

## 5. 검증
- [ ] 5.1 테스트(상품 필드/사진/태그 저장·조회) — 작성됨, 호스트에서 gradlew test
- [ ] 5.2 openspec validate

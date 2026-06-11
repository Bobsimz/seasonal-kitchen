# Tasks — 판매자 등록 필드 정렬

- [x] 1. V25: producers에 representative_name/contact/certification_image_url/agreed_to_terms
- [x] 2. RegisterProducerRequest 재정렬(대표자명·연락처·인증·약관 추가, style/가격/배지 등 제거)
- [x] 3. Producer.register 팩토리 시그니처 변경 + 신규 getter
- [x] 4. ProducerService.registerMyProducer 반영(배지 블록 제거, 기본값 처리)
- [x] 5. 테스트 시그니처/단언 갱신(style→VALUE 기본, badges 없음)
- [ ] 6. 호스트에서 gradlew test / openspec validate

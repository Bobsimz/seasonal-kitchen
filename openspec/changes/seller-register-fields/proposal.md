# 판매자 등록 필드를 화면(21e)에 맞춤

## Why

프론트에 신규 **판매자 등록 화면(21e `ScreenSellerRegister`)** 이 추가됐다(커밋 c3f7367).
이 화면이 받는 입력과 기존 `RegisterProducerRequest`가 어긋나 정렬이 필요하다.
- 화면에 있는데 백엔드에 없던 것: 대표자 이름, 연락처, 농가 인증 서류, 약관 동의
- 화면에 없는데 요청으로 받던 것: 한줄소개·대표사진·스타일·가격대·신선도·배지

## What Changes

- `producers`에 컬럼 추가: `representative_name`, `contact`, `certification_image_url`, `agreed_to_terms`(V25).
- `RegisterProducerRequest` 재정렬: name·representativeName·region·contact·specialties·certificationImageUrl·agreedToTerms.
  - `agreedToTerms`는 필수 true(@AssertTrue) — 미동의 시 400.
  - tagline/photoUrl/style/priceLevel/freshnessLevel/badges는 요청에서 제거.
- 자가등록 시 style/priceLevel/freshnessLevel은 기본값(VALUE/3/4)으로 채움(컬럼·공개 응답 유지).
- 대표자명·연락처·인증서류는 비공개 정보로 저장만 하고 공개 `ProducerDetailResponse`에는 노출하지 않음.

## Impact

- Affected specs: `seller-registration`
- Affected code: RegisterProducerRequest, Producer 엔티티, ProducerService.registerMyProducer, 마이그레이션 V25
- 기존 시드 농가는 새 컬럼 NULL/false 기본값으로 호환.

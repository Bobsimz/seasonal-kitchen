# 상품 상세 — 네이버식 구매 플로우 + 상세보기(접기/펼치기) 신규 데이터

작성일: 2026-06-13
대상 화면: `/products/[producerId]?offer=<offerId>` (`app/(stack)/products/[id]/page.jsx`)

## 배경 / 목적

현재 상품 상세는 본문에 수량(QtyStepper)을 인라인으로 두고, 하단바에 `장바구니 담기` 단일 버튼만 있다.
네이버 스타일로 다음을 원함:

1. 하단바 = `찜하기` + `구매하기`.
2. `구매하기` 탭 → 바텀시트에서 **옵션 선택 + 수량 선택 + 배송 정보**를 보고, 그 안에서 **장바구니 담기 / 바로 구매** 선택.
3. 상품 광고처럼 **상세보기(접기/펼치기)** 섹션 추가 — 텍스트를 **리스트**로 백엔드에서 받아 렌더.
4. 위 신규 데이터를 **실제 백엔드 구현 문서**로도 정리.

## 핵심 전제 (실제 백엔드 현황 — 확인됨)

- `GET /api/v1/products/{id}` → `ProductDetailResponse` **이미 구현됨**
  (`product/controller/ProductController#getProduct`, `product/service/ProductService#getProduct`).
- **옵션은 이미 실제 구현**: `OfferOption` 엔티티(`offer_options` 테이블: `offer_id, quantity, unit, price, sort_order`) +
  `OfferOptionRepository.findByOfferIdOrderBySortOrderAsc` → `ProductDetailResponse.options: List<OptionResponse{ id, quantity, unit, price }>`.
  → **프론트는 이 형태를 그대로 소비**한다. 옵션 라벨은 `${quantity}${unit}`로 파생(예: `1봉`, `3봉`, `1.5kg`).
- 상세 설명은 현재 `description`(단일 문자열)만 존재. 사용자가 원하는 **`detailSections`(리스트)는 미구현 신규 필드**.

따라서 옵션은 "소비만", `detailSections`만 백엔드 신규 구현 대상이다.

## A. 프론트 데이터 레이어

- `lib/mock/data.js` → `productDetail(offerId)`: 실제 `ProductDetailResponse`의 부분집합 반환.
  - offerId로 offer 역추적: `producerOffers(Math.floor(offerId/100)).find(o => o.id === offerId)` (id가 `producerId*100+idx`로 결정적).
  - `options`: offer 기준가에서 3종 산출 — `{ id, quantity, unit: offer.unit, price }`
    - `quantity=1` → `price=base`, `quantity=3` → `round(base*3*0.95)`, `quantity=5` → `round(base*5*0.90)` (10원 단위).
  - `detailSections`: `{ heading, body }` 리스트 — 농가/지역/신선도/식재료로 템플릿 생성(산지 이야기 / 보관 방법 / 이렇게 드세요).
  - 참고용 `description`(첫 섹션 body)도 포함해 폴백 대응.
- `lib/endpoints.js` → `getProduct: (id) => withFallback(() => api.get('/products/{id}'), () => mock.productDetail(id))`.
- `lib/queries.js` → `qk.product(id)` + `useProduct(id)` (`enabled: !!id`).

### 프론트 회복력(실 백엔드 대비)
- `options`가 비면 → 기본 옵션 1종 `{ id: offerId, quantity: 1, unit, price: offer.price }`로 폴백 (구매 플로우 항상 동작).
- `detailSections`가 없고 `description`만 있으면 → 단일 섹션 `{ heading: '상품 정보', body: description }`으로 렌더.

## B. 구매 플로우 (프론트)

- **하단바**(`BottomBar`): `[♡ 찜]`(고정폭) + `[구매하기]`(primary, flex). 가격은 본문/시트에 표기.
  - 찜 = `FavoriteHeart(targetType='PRODUCT', targetId=offerId, nextHref=현재경로)`. (백엔드 PRODUCT 찜은 §3에서 추후 — 데모 스토어로 동작, 문서에 명시.)
- **`구매하기` → `PurchaseSheet`(신규 `components/domain/PurchaseSheet.jsx`)**:
  - 옵션 라디오 리스트(라벨 = `${quantity}${unit}`, 가격), 기본 선택 = 첫 옵션.
  - 수량 `QtyStepper`.
  - 배송 요약 1줄(`산지직송 · 3,000원 (3만원 이상 무료)`).
  - 결제금액 = `선택옵션.price × 수량`.
  - `[장바구니 담기]` → addToCart(option) → 토스트 + 시트 닫기(머묾).
  - `[바로 구매]` → addToCart(option) → `/checkout`.
  - 비로그인 시 토스트 + `/login?next=` (기존 패턴 재사용).

## C. 상세보기 접기/펼치기 (본문)

- `detailSections`를 카드로 렌더. 기본 접힘: 높이 제한(`max-h`) + 하단 그라데이션 페이드 + `상세정보 펼쳐보기 ▾`.
- 펼치면 전체 표시 + `접기 ▴`. 페이지 내 소규모 로컬 컴포넌트.

## D. 장바구니 옵션 연동 (데모 스토어, 최소 확장)

- `lib/mock/store.js` `addCartItem(offerId, qty, option)`:
  - option 있으면 `unitPrice = option.price`, 라인에 `optionId`/`optionLabel`(`${quantity}${unit}`) 저장.
  - dedup 키 = `offerId + (optionId ?? null)` (다른 옵션 = 다른 라인).
  - `serializeCart` items에 `optionLabel` 추가. 합계는 기존 `unitPrice` 그대로 → 로직 변경 없음.
- `lib/endpoints.js` `addCartItem`: `demoStore.addCartItem(body.offerId, body.qty, body.option)`.
- `useAddToCart`는 body 전체를 전달하므로 변경 불필요(option 포함만 하면 됨).
- `app/(stack)/cart/page.jsx`: 상품명 아래 `optionLabel` 노출(있을 때만).

## E. 백엔드 구현 문서 (산출물)

- `frontend/BACKEND-REQUIREMENTS.md` §1 `/products/{id}`에 `options`(기구현, 소비) 명시 + `detailSections`(신규) 추가, 장바구니 `option` 파라미터 명시.
- `backend/docs/product-detail-options-2026-06-13.md` (신규, 기존 `backend/docs/*` 컨벤션):
  - **옵션**: 이미 구현됨 — 파일 경로/DTO/리포지토리 인용, 프론트 소비 가이드, 시드 예시. (변경 없음)
  - **detailSections(신규 구현 명세)**:
    - 테이블 `offer_detail_sections(id PK, offer_id FK, heading, body TEXT, sort_order)` DDL.
    - 엔티티 `OfferDetailSection`(+ `of(...)` 팩토리, `OfferOption` 스타일 일치).
    - `OfferDetailSectionRepository.findByOfferIdOrderBySortOrderAsc`.
    - `ProductDetailResponse`에 `List<DetailSectionResponse{ heading, body }> detailSections` 필드 추가 + `ProductService.getProduct` 매핑(배치 조회, N+1 회피).
    - 시드/마이그레이션 예시, `INGREDIENT_NOT_FOUND`/`PRODUCT_NOT_FOUND` 등 에러 코드 일관성, 빈 목록 시 `[]`.
  - **장바구니 옵션**: 카트 라인에 `offer_option_id`(nullable FK) + 단가 스냅샷 보강 권고(현재 데모는 클라이언트 스냅샷). 실제 구현 시 `POST /cart/items {offerId, qty, offerOptionId}` 권장.

## 컴포넌트 경계

- 신규 `PurchaseSheet`(옵션·수량·배송·CTA) — offer/options/producer + 콜백 props.
- 상세보기 접기/펼치기 — 페이지 내 로컬 컴포넌트.
- 제거: 본문 인라인 `QtyStepper`, 기존 하단바의 `장바구니 담기` 단일 버튼.

## 검증

- 테스트 하네스 없음 → `next build`로 회귀 확인.
- 수동: 구매하기→시트(옵션 전환 시 결제금액 갱신)→장바구니담기(토스트·머묾)/바로구매(/checkout), 장바구니에 옵션 라벨·가격 반영, 상세보기 접기/펼치기, 찜 토글, 비로그인 분기.
- 백엔드 문서: 실제 파일(`OfferOption`, `ProductService`, `ProductDetailResponse`) 인용이 정확한지 교차 확인.

## 비목표(범위 밖)

- 옵션 백엔드 구현(이미 존재) / 결제·주문 자체 로직 / 검색.
- `detailSections`의 실제 Java 코드 작성은 **문서화만**(코드 구현은 별도 요청 시).

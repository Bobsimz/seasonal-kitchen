# 백엔드 추가 개발 요청서 (프론트 연동 기준)

> 프론트엔드를 "동작하는 웹앱"으로 구현하면서, **현재 API로는 채울 수 없거나 임시 대응한 부분**을 정리했습니다.
> 기준 문서: `backend/docs/frontend-api-guide.md` (canonical). 프론트는 백엔드가 없을 때 mock 데이터로 폴백하도록 만들어 두었으니, 아래 API가 준비되면 폴백 없이 그대로 붙습니다.
>
> 우선순위: **P0** 핵심 커머스 동선 / **P1** 사용성·완성도 / **P2** 고도화.

---

## 1. 전용 상품(Product) 도메인 — P0 — ✅ 구현됨 (2026-06-12)

> **구현 완료**: `producer_offers`를 상품으로 보는 **facade**로 제공(전용 product 테이블 없음). 상품 `id` = `producer_offers.id`.
> `GET /api/v1/products`(q·category·region·style 필터 + page/size), `GET /api/v1/products/{id}`(이미지·옵션·인증·보관·관련레시피), `GET /api/v1/search?type=PRODUCT` 추가됨.
> `stockStatus`: stockQuantity null→UNKNOWN, 0→SOLD_OUT, 1+→IN_STOCK. 상세는 `backend/docs/frontend-api-guide.md` §13.
> 프론트는 임시 대응(`/producers`+offers 조합)을 `/products`로 교체 가능.

현재 "상품 탭/상품 상세"는 `GET /producers` + `GET /producers/{id}/offers` 조합으로 임시 구현했습니다. 전용 상품 도메인이 있으면 카드/검색/재고 표현이 정확해집니다.

| 메서드 | 경로 | 설명 | 응답 핵심 필드 |
| --- | --- | --- | --- |
| GET | `/api/v1/products` | 상품 목록(페이지네이션, 카테고리/지역/스타일 필터) | `id, name, ingredientId, ingredientName, producerId, producerName, region, price, unit, imageUrl, stockStatus, category` |
| GET | `/api/v1/products/{id}` | 상품 상세 | 위 + `images[], description, freshnessLabel, stockQuantity, certifications[], storageMethod, storageNote, options[], tags[], relatedRecipeIds[]` (옵션 `OptionResponse{id,quantity,unit,price}` 기구현). **신규 P1: `detailSections[]`** — §10 |
| GET | `/api/v1/search?type=PRODUCT` | 검색에 상품 타입 추가 | 현재 `ALL/INGREDIENT/RECIPE`만 존재 |

- 임시 대응: 프론트는 `/products`를 농가/오퍼로 구성하고, 상품 상세 라우트는 `/products/[producerId]?offer=<offerId>`로 동작합니다.

## 2. 판매자(농가) 상품 관리 — P0 — ✅ 구현됨 (2026-06-12)

> **구현 완료**: 조회/수정/삭제/통계 모두 추가됨.
> `GET /api/v1/producers/me/offers`(내 상품 목록, 숨김 제외), `PATCH /api/v1/producers/me/offers/{offerId}`(부분 수정 — null=미수정, 컬렉션 제공 시 전체 교체), `DELETE /api/v1/producers/me/offers/{offerId}`(status=HIDDEN 소프트 삭제, 공개·검색·`/products`에서 제외), `GET /api/v1/producers/me/stats`(판매 통계). 타 농가 상품 조작은 `PRODUCER_OFFER_NOT_FOUND`. 상세는 `frontend-api-guide.md` §11.
> 통계 응답 필드는 `salesAmount→monthlyRevenue`, `orderCount`, `periodSeries→revenueSeries`, `topProducts` 등으로 제공(`viewCount`/`favoriteCount`는 후속). 대시보드 mock 제거 가능.

현재 등록만 가능(`POST /producers/me/offers`). 판매자 센터(대시보드)를 완성하려면 조회·수정·삭제·통계가 필요합니다.

| 메서드 | 경로 | 설명 |
| --- | --- | --- |
| GET | `/api/v1/producers/me/offers` | 내 판매 상품 목록 (대시보드 리스트) |
| PATCH | `/api/v1/producers/me/offers/{offerId}` | 가격/단위/신선도 수정 |
| DELETE | `/api/v1/producers/me/offers/{offerId}` | 상품 내리기 |
| GET | `/api/v1/producers/me/stats` | 판매 통계: `viewCount, orderCount, salesAmount, favoriteCount, reviewCount, periodSeries[]` |

- 임시 대응: 판매 상품 목록·통계는 mock(데모)로 표시하고 "데모 통계" 라벨을 달았습니다.
- 참고: AI 가격추천/홍보문구 자동작성 기능은 커머스 피벗에서 **제외(retired)** 되어 프론트에서도 제거했습니다. 상품 등록 화면의 "권장가 안내"는 정적 안내 문구일 뿐 AI 호출이 아닙니다.

## 3. 찜(Favorites) 응답 보강 — P1 — ✅ 구현됨 (2026-06-12)

> **구현 완료**: `FavoriteResponse`에 `title`·`imageUrl`·`subtitle` 추가(기존 `id`/`targetType`/`targetId` 유지). 목록은 대상별 배치 조회로 N+1 회피.
> 매핑 — INGREDIENT: name/이미지/카테고리, RECIPE: 제목/이미지/설명, PRODUCER: 농가명/photoUrl/tagline·region, PRODUCT·OFFER(추후): 상품명/첫사진/가격·단위. 상세는 `frontend-api-guide.md` §7(찜).

`GET /favorites`가 현재 `{id, targetType, targetId}`만 반환합니다. 찜 목록 화면에서 이름/이미지/가격을 보여주려면 대상 요약이 필요합니다.

```jsonc
// 권장 응답
{ "items": [
  { "id": 10, "targetType": "INGREDIENT", "targetId": 12,
    "title": "봄동", "imageUrl": "...", "subtitle": "4,500원/봉" }
]}
```

- 임시 대응: 찜 화면은 id만 있을 때 빈/단순 목록으로 처리합니다.

## 4. 주문/결제/배송 — P0~P1 — 🟡 일부 구현

| 상태 | 항목 | 현재 | 남은 일 |
| --- | --- | --- | --- |
| 🟡 | 결제 | `POST /orders`가 장바구니를 즉시 `PAID`로 전환(모의) | 실제 PG 연동 또는 결제수단/검증 (P2) |
| ✅ | 배송지 | `GET/POST/PATCH/DELETE /api/v1/users/me/addresses` 구현됨. 기본 배송지 항상 1개 정책. 상세 `frontend-api-guide.md` §14 | — |
| ✅ | 주문 상태 | 상태 흐름 `PAID→PREPARING→SHIPPED→DELIVERED`(+배송 전 `CANCELLED`) + 운송장/추적 구현됨 (2026-06-13, V30). 판매자: `GET /api/v1/producers/me/orders`, `PATCH /api/v1/producers/me/orders/{orderId}/status`. 구매자 `OrderResponse`에 `carrier/trackingNumber/shippedAt/deliveredAt` 추가. 상세 `frontend-api-guide.md` §6·§11 | 농가별 분리배송 상태(현재 주문 단위) — 후속 |
| ⬜ | 주문 항목 이미지 | 없음 | `OrderItem.imageUrl` 있으면 주문/완료 화면 품질↑ — P2 |

## 5. 리뷰 — P1 — 🟡 일부 구현

| 상태 | 메서드 | 경로 | 설명 |
| --- | --- | --- | --- |
| 🟡 | GET | `/api/v1/users/me/reviews?status=writable\|written` | `written` 구현됨. `writable`은 배송완료 주문 기반이라 현재 빈 배열 |
| ✅ | (정책) | `POST /producers/{id}/reviews` | MVP 자유 작성 구현됨. 배송완료 주문 검증은 후속 |

- 임시 대응: 내 리뷰 화면은 written 샘플/빈 상태로 처리.

## 6. 인증 고도화 — P1 — ⬜ 미구현

UI에 카카오/Apple/구글 버튼이 있으나 비활성(준비 중)입니다.

| 상태 | 메서드 | 경로 | 설명 |
| --- | --- | --- | --- |
| ⬜ | POST | `/api/v1/auth/oauth/{provider}` | 소셜 로그인 |
| ⬜ | POST | `/api/v1/auth/refresh` | 토큰 갱신 |
| ⬜ | POST | `/api/v1/auth/logout` | 로그아웃 |

- 현재: email/password + access token만. 만료 시 재로그인.

## 7. 이미지 업로드 — P1 — ✅ 구현됨 (2026-06-12)

> **구현 완료**: `POST /api/v1/uploads`(multipart `file`) → `{ url }`. content-type whitelist(`image/png`·`image/jpeg`·`image/webp`·`image/gif`, SVG 제외), 최대 5MB(`app.uploads.max-bytes`). 인증 필요.
> 저장은 `FileStorage` 추상화 — 기본 로컬(`app.uploads.dir`, `GET /uploads/**` 정적 서빙), `app.uploads.storage=s3` + S3 구현 빈 추가로 교체 가능(컨트롤러/서비스 무변경). 받은 `url`을 `certificationImageUrl`·상품 `photoUrls[]`·농가 `photoUrl`(향후 리뷰 사진)에 사용. 상세 `frontend-api-guide.md` §15.

농가 등록/상품 등록/리뷰 작성 화면의 사진 첨부 UI는 `POST /api/v1/uploads`로 연결할 수 있습니다.

| 상태 | 메서드 | 경로 | 설명 |
| --- | --- | --- | --- |
| ✅ | POST | `/api/v1/uploads` (multipart) | 이미지 업로드 → `{ url }` 반환. 농가 `photoUrl`, 상품 `imageUrl`, 리뷰 사진에 사용 |

## 8. 응답 보강 (있으면 좋음) — P2 — ⬜ 미구현

- ⬜ `GET /home`: 명예 농가 캐러셀 데이터 포함(현재 `/producers` 별도 호출), `weeklySeason`(절기/주차 라벨), hero CTA 구조화.
  - ⬜ `heroes[]`: 홈 상단 히어로 캐러셀(여러 제철 카드 스와이프)용 배열. 각 원소는 기존 `hero`와 동일 구조 `{ ingredientId, title, subtitle, imageUrl, priceLabel, trendLabel }`. 현재 프론트는 mock에서 `hero` + 제철 식재료 4종으로 구성(폴백). 미제공 시 단일 `hero`로 자동 폴백. 카드 탭 → 제철 큐레이션(`/curation`).
- ⬜ `GET /ingredients`, `/ingredients/{id}`: `trendDirection`(UP/DOWN/FLAT), `priceChangeLabel`, `seasonMonths`, `buyingSignal`을 실제 계산값으로.
- ⬜ `GET /ingredients/{id}/substitutes`: `reason`(대체 이유) 필드.
- 🟡 `GET /search/trending` & `GET /users/me/recent-searches`: API는 존재. 프론트는 비로그인 최근검색을 클라이언트 보관해도 됨.
- ⬜ 알림 푸시: 디바이스 토큰 등록 `POST /api/v1/notifications/devices` (실시간/푸시) — P2.

## 9. 식재료 상세 · 상품 탭 개편 (2026-06-13) — P1~P2 — ⬜ 미구현

> 2026-06-13 프론트 개편(식재료 상세 "농가 직거래" 섹션·찜 하트, 상품 탭 이커머스 그리드)에서 필요한 백엔드. 상세 설계는 아래 문서 참조.
> - `backend/docs/ingredient-detail-revamp-2026-06-13.md`
> - `docs/superpowers/specs/2026-06-13-products-tab-commerce-list-design.md`
>
> **변경(2026-06-13 구현됨)**: 식재료 상세는 별도 "상품 리스트"(`/ingredients/{id}/products`) 대신 **기존 `GET /ingredients/{id}/producers`** 를 그대로 써서 "농가 직거래" 섹션(베스트+가격순, 행별 담기)을 그린다. 따라서 1순위 요청은 새 엔드포인트가 아니라 **`ProducerOfferResponse` 필드 보강**이다.

| 상태 | 우선 | 대상 | 설명 |
| --- | --- | --- | --- |
| ⬜ 보강 | **P1** | `GET /ingredients/{id}/producers` → `ProducerOfferResponse` | 현재 DTO에 **`rating`, `reviewCount`, `honorary`(명예농가), `style`(유기농/프리미엄/실속 enum)** 가 없음. 식재료 상세 "농가 직거래"(★평점·명예·스타일 배지 + 베스트 선정) **와 기존 농가 비교 페이지**(이미 이 필드들을 렌더) 둘 다 필요. 대표 이미지는 프론트가 `photoUrls[0]` 사용(또는 `photoUrl` 단일 추가). 정렬 가격 오름차순 유지. |
| ⬜ 선택 | P2 | `GET /ingredients/{id}/products` (`ProductCardResponse[]`) | **식재료 상세에선 미사용으로 전환**(위 `/producers` 사용). `/products` 탭이 식재료별 필터를 원하면 `GET /products?ingredientId={id}`(가격 오름차순·`status=ACTIVE`)로 살릴 수 있음. 상세 화면 차단요소 아님. |
| ⬜ 보강 | P2 | `ProductCardResponse` | 상품 탭 정렬(추천순 = rating desc→reviewCount desc, 리뷰많은순)을 위해 `rating`, `reviewCount` 추가. 현재 프론트는 mock에만 두고 클라이언트 정렬로 임시 대응. 필요 시 `GET /products`에 `sort` 파라미터도. |
| ⬜ 선택 | P2 | `IngredientDetailResponse` | `favorited`(로그인 사용자 찜 여부), `favoriteCount`(누적 찜 수) 추가 시 하트 초기 상태를 `GET /favorites` 전체 조회 없이 표기. 없으면 현행(favorites 목록 매칭)대로 동작. |

- 이미 존재(변경 불필요): 식재료 찜 = `favorites` API의 `targetType=INGREDIENT`(§3 기반) 재사용, 농가 비교 라우트 `GET /ingredients/{id}/producers` 자체는 유지(필드만 보강).
- 화면에서 미사용으로 전환됐으나 **API는 유지**: `GET /ingredients/{id}/prices`(가격 추이), 영양 정보, `GET /ingredients/{id}/offers`(리테일 시세).
- 빈 상태(판매 농가 0곳): 프론트가 현재가·농가섹션·구매 CTA를 숨기고 "입고 알림"(=`favorites` 찜)으로 전환 — 추가 백엔드 불필요.
- 프론트 임시 대응: `useIngredientProducers(id)` → 연결/오류 시 `mock.ingredientProducers(id)`(평점·명예·스타일·신선도 포함) 폴백. 위 필드가 실 응답에 추가되면 프론트 수정 없이 전환.

## 10. 상품 상세 구매 플로우 · 상세보기(detailSections) (2026-06-13) — P1~P2

> 2026-06-13 프론트 개편(상품 상세 네이버식 구매 시트 + 상세보기 접기/펼치기)에서 필요한 백엔드.
> 구현 명세(테이블/엔티티/매핑): `backend/docs/product-detail-options-2026-06-13.md`
> 프론트 설계: `docs/superpowers/specs/2026-06-13-product-detail-purchase-flow-design.md`

| 상태 | 우선 | 대상 | 설명 |
| --- | --- | --- | --- |
| ✅ 기구현 | — | `GET /products/{id}` `options[]` | 옵션(규격/variant)은 `offer_options` 테이블 + `ProductDetailResponse.options(OptionResponse{id,quantity,unit,price})`로 **이미 구현됨**. 프론트는 그대로 소비(라벨=`${quantity}${unit}`). 옵션 없는 상품은 `options=[]` → 프론트가 기준가 단일 옵션으로 폴백. |
| ⬜ 신규 | P1 | `GET /products/{id}` `detailSections[]` | "상품 상세정보(접기/펼치기)"용 **제목+본문 섹션 리스트**. `ProductDetailResponse`에 `List<DetailSectionResponse{heading, body}> detailSections` 추가. 새 테이블 `offer_detail_sections(offer_id, heading, body, sort_order)`. 비면 `[]`. 프론트는 없으면 `description` 단일 섹션으로 폴백. 상세는 백엔드 문서 §2 참조. |
| ⬜ 보강 | P1 | `POST /cart/items` `offerOptionId` | 선택 옵션을 장바구니에 반영. 요청 `{offerId, qty, offerOptionId?}`. 서버는 `offerOptionId` 있으면 해당 옵션 단가/라벨로 라인 생성, 같은 offer라도 옵션 다르면 별도 라인. 응답 라인에 `optionLabel`(또는 `offerOptionId`+`quantity/unit`) 포함 권장. 현재 데모는 클라이언트가 옵션 단가/라벨을 스냅샷. |
| ⬜ 선택 | P2 | `favorites` `targetType=PRODUCT` | 상품(=offer) 찜. 현재 데모 스토어로 동작(§3의 PRODUCT·OFFER "추후"와 연결). 실제 구현 시 `targetType=PRODUCT, targetId=offerId` 저장 + 요약(상품명/첫사진/가격·단위) 반환. |

- 프론트 임시 대응: `endpoints.getProduct(id)` → 연결/오류 시 `mock.productDetail(id)` 폴백(옵션 3종 + detailSections 3종 생성). 장바구니는 `addCartItem(offerId, qty, option)`로 옵션 단가/라벨을 데모 스토어 라인에 스냅샷.

---

## 부록 — 프론트가 사용하는 엔드포인트 매핑

`frontend/lib/endpoints.js`에 도메인별로 정리되어 있고, 각 함수는 `실제 API → 실패 시 mock` 순으로 동작합니다.
실제 백엔드만 쓰려면 `frontend/.env.local`에 다음을 설정하세요.

```
NEXT_PUBLIC_API_BASE_URL=http://localhost:8080
NEXT_PUBLIC_DEMO_FALLBACK=off
```

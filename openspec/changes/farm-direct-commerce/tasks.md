## 1. Product Decisions

- [ ] 1.1 Producer identity: admin-seeded profile vs seller-user-linked profile for MVP.
- [ ] 1.2 Decide whether `producer` supersedes `store`/`store_offers` or coexists.
- [ ] 1.3 Cart persistence: backend-persisted vs frontend-local for MVP (shared with product-commerce-pivot 1.5).
- [ ] 1.4 Payment/order scope: mock order (no PG) vs real payment for MVP.
- [x] 1.5 Review eligibility: **MVP = free-form** (any authenticated user can review any existing producer). Delivered-order eligibility is out of MVP scope (future).
- [ ] 1.6 Shipping rule: confirm per-producer shipping fee + free-shipping threshold (30,000원) from frontend.
- [x] 1.7 Producer-as-seller write side: **Option A 확정** — producer 도메인에 통합. `producers.user_id`(V21)로 사용자=농가 연결, `POST /producers/me`, `GET /producers/me`, `POST /producers/me/offers` 구현. (수정/삭제·seller AI는 future)

## 2. Spec Updates

- [ ] 2.1 Add baseline `backend-producer` spec (directory + offer + reviews + news).
- [ ] 2.2 Add baseline `backend-cart-order` spec.
- [ ] 2.3 Add baseline `backend-review` spec.
- [ ] 2.4 Modify `backend-favorite` to add `PRODUCER` target type.
- [ ] 2.5 Modify `seller-listing` (product-commerce-pivot) registration fields: stock, harvest/delivery, freshness/origin, images, category.
- [ ] 2.6 Modify `backend-home-search` to include producer results and honorary-producer carousel.

## 3. Backend Implementation — Producer (P0, priority)

- [x] 3.1 Flyway migration for `producers`, `producer_offers`, `producer_news`, `producer_reviews` (V12).
- [x] 3.2 Producer entity, repository, DTOs (skeleton).
- [x] 3.3 `GET /api/v1/producers` list + `?q=` specialty search (skeleton, stubbed data).
- [x] 3.4 `GET /api/v1/producers/{id}` detail (skeleton).
- [x] 3.5 `GET /api/v1/producers/{id}/offers` producer's products (skeleton).
- [x] 3.6 `GET /api/v1/producers/{id}/reviews` (skeleton).
- [x] 3.7 `GET /api/v1/producers/{id}/news` store news (skeleton).
- [x] 3.8 `GET /api/v1/ingredients/{ingredientId}/producers` per-ingredient compare (skeleton).
- [x] 3.9 DB-backed queries + producer seed (V14__seed_producers.sql from producers-data.js: 8 producers + specialties/badges/offers/news/reviews). `author_name` added to producer_reviews.
- [x] 3.10 ErrorCode `PRODUCER_NOT_FOUND` + ProducerServiceTest (detail/offers/reviews/news/search, unknown→404).
- [x] 3.11 `/ingredients/{id}/producers` compare: runtime name fallback in service (works on seed alone). ProducerServiceTest covers id-based compare via name fallback.
- [x] 3.12 Producer list search combines `q`, `style`, `honorary`, and pageable through a unified repository query.
- [x] 3.13 V14 fixed-id producer seed adjusts the producer identity sequence to avoid later duplicate IDs.
- [ ] 3.14 Backfill `producer_offers.ingredient_id` / `producer_specialties.ingredient_id` from KAMIS or recipe-derived ingredients once the ingredient seed is finalized.
- [ ] 3.15 Optional: re-derive `producer_offers.price` base from KAMIS retail price after the ingredient/price seed lands.

## 4. Backend Implementation — Cart / Order (P1)

- [x] 4.1 Flyway migration for `carts`, `cart_items`, `orders`, `order_items` (V12).
- [x] 4.2 Cart/Order controller + service skeletons (stubbed).
- [x] 4.3a Cart add-item keyed by `offerId` (snapshot from ProducerOffer, no zero-price fallback, dedup→qty++). V13 migration adds `cart_items.offer_id`.
- [x] 4.3 Cart CRUD with per-producer grouping + shipping calculation.
- [x] 4.4 Order create from cart, order list, order detail (mock payment, cart cleared after order).
- [x] 4.6 Harden order-number generation against unique-key collisions (ms-precision timestamp + 16-bit random + existence pre-check + UUID fallback; no migration to avoid Flyway out-of-order with KAMIS V15). DB-sequence migration remains a future option.
- [x] 4.5 CartServiceTest + OrderServiceTest (order from cart, repeated orders produce unique order numbers).

## 5. Backend Implementation — Review + Wishlist (P1)

- [x] 5.1 Review APIs (MVP): `GET /producers/{id}/reviews`, `POST /producers/{id}/reviews` (free-form), `GET /users/me/reviews?status=written`. `status=writable` returns empty (future).
- [x] 5.2 Extend `FavoriteService.validateTarget` for `PRODUCER`.
- [x] 5.5a Update producer rating/review_count aggregates on review create (recompute avg + count).
- [ ] 5.3 Producer-card enrich for favorites response by target type.
- [ ] 5.4 Tests for favorite producer path (review create/aggregate covered by ProducerServiceTest).

### Out of MVP scope (future)

- Delivered-order review eligibility (removed from MVP; reviews are free-form).
- `status=writable` derivation from delivered orders.
- Review edit/delete (`PATCH`/`DELETE /api/v1/reviews/{reviewId}`).

## 6. Backend Implementation — Seller / 농가 자가등록 (P1)

- [x] 6.1 `producers.user_id` 연결(V21) + 사용자=농가 등록 `POST /producers/me`, 내 농가 `GET /producers/me`, 상품 등록 `POST /producers/me/offers`. ErrorCode `PRODUCER_ALREADY_REGISTERED`. ProducerSelfRegistrationTest 작성.
- [ ] 6.2 농가 프로필 수정/삭제(`PATCH`/`DELETE /producers/me`).
- [ ] 6.3 추가 판매자 정보(재고·수확/배송·원산지·사업자번호 등) + 상품에 카테고리/재고.
- [ ] 6.4 판매자 AI(가격 추천·홍보글) — future.

## 7. Verification

- [x] 7.1 Run `openspec validate --all`.
- [x] 7.2 `./gradlew compileJava` after skeleton.
- [ ] 7.3 `./gradlew test` after real implementations.
- [ ] 7.4 Verify frontend producer/cart/order/review screens bind to new APIs.

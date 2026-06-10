# Design — Farm Direct Commerce

## Context

`producers-data.js` is the de-facto domain source on the frontend. This design maps it onto backend tables and APIs, mirroring the existing modular-monolith conventions (`AGENTS.md`). The current backend provides DB-backed producer reads, an offerId-based cart, and mock order creation; seller-side producer management is still out of scope.

## Data Model

### producers
`id, name, region, tagline, photo_url, style(VALUE|ORGANIC|PREMIUM), price_level(1-5), freshness_level(1-5), rating(DECIMAL), review_count, honorary(boolean), created_at`. Specialties as a child table `producer_specialties(producer_id, ingredient_name)` for many-to-one matching (frontend matches by ingredient name, not id, so keep a name column; link `ingredient_id` later when seeded). Badges as `producer_badges(producer_id, label)`.

### producer_offers
`id, producer_id, ingredient_id (nullable until seeded), ingredient_name, price, unit, freshness_label, observed_at`. Separate from `store_offers` (retail) per persistence rule "store offer prices must remain separate". Indexed on `(ingredient_id, price)` and `(producer_id)`.

### producer_news
`id, producer_id, posted_at, title, image_ref, body`. `image_ref` holds either an ingredient name or `"photo"` (frontend convention).

### producer_reviews
`id, producer_id, user_id, author_name(nullable seed display name), rating(1-5), item, body, created_at`. Producer `rating`/`review_count` are denormalized aggregates and are recomputed from `producer_reviews` when a producer review is created. **MVP review policy is free-form**: any authenticated user can review any existing producer; delivered-order eligibility is out of MVP scope (future).

### cart / order
`carts(id, user_id)`, `cart_items(id, cart_id, offer_id, producer_id, ingredient_id, ingredient_name, qty, unit_price, unit)`. Cart add-item accepts `offerId` and snapshots producer/ingredient/price/unit from `producer_offers`. `orders(id, user_id, order_number, total_amount, shipping_fee, points_earned, status, ordered_at)`, `order_items(id, order_id, producer_id, producer_name, ingredient_name, qty, unit_price)`. Shipping is computed per-producer group with a 3,000원 fee and 30,000원 free-shipping threshold.

### favorites
Reuse existing `favorites.target_type`; add `PRODUCER`. No schema change needed.

## API Contract Additions

```text
GET /api/v1/producers ? q= & style= & honorary=        -> ListResponse<ProducerCardResponse>
GET /api/v1/producers/{id}                             -> ProducerDetailResponse
GET /api/v1/producers/{id}/offers                      -> List<ProducerOfferResponse>
GET /api/v1/producers/{id}/reviews                     -> List<ProducerReviewResponse>
GET /api/v1/producers/{id}/news                        -> List<ProducerNewsResponse>
GET /api/v1/ingredients/{ingredientId}/producers       -> List<ProducerOfferResponse>  (compare)

GET    /api/v1/cart                                    -> CartResponse (producer groups)
POST   /api/v1/cart/items                              -> CartResponse
PATCH  /api/v1/cart/items/{cartItemId}                 -> CartResponse
DELETE /api/v1/cart/items/{cartItemId}                 -> void
POST   /api/v1/orders                                  -> OrderResponse
GET    /api/v1/orders                                  -> ListResponse<OrderSummaryResponse>
GET    /api/v1/orders/{orderId}                        -> OrderResponse

GET    /api/v1/users/me/reviews ? status=written      -> List<MyReviewResponse>   (status=writable returns [] in MVP)
POST   /api/v1/producers/{producerId}/reviews         -> ProducerReviewResponse    (free-form, refreshes aggregates)
```

Swagger tags: reuse `07. Stores` slot region — add `18. Producers`, `19. Cart & Orders`, `20. Reviews` (numbering continues from `03-api-contract.md` §4).

## Decisions

- **Producer vs Store**: keep both tables for now; `producer_offers` is the farm-direct path, `store_offers` stays for any retail reference. Final consolidation deferred (task 1.2).
- **Seeded read path first**: producers, specialties, badges, offers, news, and seed reviews are DB-backed from V14. Write-side producer management remains deferred.
- **Specialty matching by name plus ID fallback**: frontend-style name matching is preserved through `ingredient_name`; `GET /ingredients/{ingredientId}/producers` first uses linked `ingredient_id`, then falls back to the ingredient name until backfill lands.
- **Cart item trust boundary**: the client sends only `offerId` and `qty`; producer, ingredient, price, and unit are copied from `producer_offers`.

## Producer as Seller — read vs write split

A producer **is** the selling party (farm = seller). The current skeleton only implements the **consumer-facing read** side of a producer:

- Read (built): producer profile, `producer_offers` (what they sell), reviews, news, q/style/honorary producer search.
- Write (NOT built): a producer registering/editing their own products (the `farm-upload` screen), seller AI (price recommendation, promotional copy), and a producer managing incoming orders.

**RESOLVED (task 1.7): Option A — fold into `producer`.** 사용자=농가를 `producers.user_id`(V21)로 연결하고, 쓰기 API를 producer 도메인에 둔다:
- `POST /api/v1/producers/me` — 농가 자가등록 (마이페이지)
- `GET /api/v1/producers/me` — 내 농가
- `POST /api/v1/producers/me/offers` — 내 농가 상품 등록

권한은 `user_id` 기반(내 농가만). `producer_offers`가 소비자 조회·판매자 등록 공용 listing 테이블. 시드 농가는 `user_id=NULL`로 공존.
미구현(future): 프로필 수정/삭제, 추가 판매자 정보, 판매자 AI. (seller-registration spec 참조)

## Risks / Open

- Payment scope unresolved (1.4) — current implementation uses backend-persisted cart + mock order, no PG.
- Producer identity/auth unresolved (1.1) — skeleton treats producers as read-only seeded data; no producer-side write APIs yet.
- Order number generation uses a millisecond timestamp plus random suffix with existence pre-check and UUID fallback. This is sufficient for MVP, but a DB sequence remains cleaner for production-grade guarantees.
- Delivered-order review eligibility is intentionally out of MVP scope; producer rating/review_count aggregate updates are implemented on review create.

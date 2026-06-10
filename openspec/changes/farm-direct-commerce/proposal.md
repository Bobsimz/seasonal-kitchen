## Why

The frontend prototype has moved further than `product-commerce-pivot` anticipated. Since the 2026-06-05 coverage review, the app reframed from retail price comparison (Coupang, Market Kurly) to **farm-to-consumer direct trade**: producers (생산자) are now first-class, with producer browsing, producer comparison per ingredient, producer store news, reviews, cart, checkout, order history, and a seller (farm) product upload screen. The backend only models a generic `product`/`seller` concept and has no producer, cart, order, or review domains.

This change captures the farm-direct-commerce direction so backend can converge with the current frontend. It complements (does not replace) `product-commerce-pivot`, which still owns product-catalog, seller-listing, and AI chef retirement.

See `backend/docs/frontend-gap-analysis-2026-06-10.md` for the full screen-by-screen gap.

## What Changes

- Add a `producer` (farm/생산자) domain: profile, specialties, style (value/organic/premium), price/freshness level, rating, badges, honorary flag.
- Add producer list/search (by ingredient specialty), producer detail, producer reviews, and producer store news.
- Add per-ingredient producer comparison to replace the retail "price compare" screen with a "producer compare" screen.
- Add cart and order domains: cart grouped by producer with per-producer shipping, order creation from cart, order history and order detail (order number, payment total, shipping, points).
- Add a review domain (MVP): producer reviews list, my written reviews, and free-form review creation (any authenticated user → existing producer) with star rating + body; creating a review refreshes producer rating/review_count. Delivered-order eligibility and writable-review derivation are future.
- Extend favorites to support `PRODUCER` targets (entity already has `targetType`).
- Extend seller product registration fields to match the upload screen: stock quantity, harvest/delivery info, freshness/origin notes, product images, category.
- Confirm consumer AI removal: `chatbot/`, `frontend/components/screens-ai.jsx`, and the "04 · AI 장보기" section are retired; no consumer AI/shopping-plan API is in scope. Seller-facing AI (price recommendation, promotional copy) remains as scoped in `product-commerce-pivot`.

## Capabilities

### New Capabilities

- `producer-directory`: Browse/search producers, producer detail, reviews, and store news.
- `producer-offer`: Per-ingredient producer price/unit/freshness comparison.
- `cart-and-order`: Cart grouped by producer, checkout, and order history.
- `review`: Producer reviews (MVP free-form create + written list; writable/eligibility future).

### Modified Capabilities

- `backend-favorite`: Add `PRODUCER` as a favorite target type.
- `seller-listing`: Add stock, harvest/delivery, freshness/origin, image, and category fields to registration (extends `product-commerce-pivot`).

## Impact

- Affected frontend: producer list/search/detail/compare, cart, purchase, order-complete, order history, reviews, write-review, wishlist (producer tab), farm-upload.
- Affected backend domains: new `producer`, `cart`, `order`, `review`; modified `favorite`, `seller`/`product`, `home`/`search` (producer results, honorary carousel).
- Affected persistence: new `producers`, `producer_offers`, `producer_news`, `producer_reviews`, `carts`, `cart_items`, `orders`, `order_items` tables; `favorites.target_type` gains `PRODUCER`.
- Affected APIs: producer list/detail/reviews/news, ingredient→producers compare, cart CRUD, order create/list/detail, review create + list (MVP), favorites producer type.
- Deferred decisions:
  - Cart persistence: backend vs frontend-local (shared with `product-commerce-pivot` 1.5).
  - Payment/PG scope for MVP (likely mock order without real payment).
  - Producer identity/auth: is a producer a user-role, a separate profile, or admin-seeded?
  - Whether `producer` supersedes `store`/`store_offers` entirely or coexists.

Resolved for MVP:
  - Review eligibility: free-form (any authenticated user → existing producer). Delivered-order gating is future.

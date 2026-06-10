# Frontend Integration Verification

Date: 2026-06-04

> Historical analysis note: 프론트 연동의 현재 단일 기준은 `frontend-api-guide.md`입니다.
> 이 문서는 2026-06-04 검증 이력이며, product/seller API 항목은 현재 producer/offer 흐름으로 대체되었습니다.

Scope:

- Verify P0 frontend screen coverage from `docs/frontend-screen-api-coverage.md`.
- Verify required P0 response fields from `docs/frontend-required-fields.md`.
- Verify Swagger/OpenAPI visibility, local/dev demo seed coverage, seed idempotency, and JWT dev-token usability.

## Summary

| Screen | Required API | Status | Covered fields | Remaining missing fields | Demo data availability | Swagger visibility | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Home header / notifications | `GET /api/v1/home`, `GET /api/v1/notifications` | covered | `seasonTitle`, `seasonSubtitle`, `unreadNotificationCount`, notification list/count fields | Location text is frontend/static for now | Demo user has notifications; home can return unread count | Visible: `/api/v1/home`, `/api/v1/notifications` | `unreadNotificationCount` depends on authenticated user when available. |
| Home hero seasonal card | `GET /api/v1/home` | covered | `hero.title`, `hero.subtitle`, `hero.imageUrl`, `hero.primaryTargetType`, `hero.primaryTargetId` | `weeklySeason`, `recommendedReason`, `cta` are represented by hero/title/subtitle rather than separate fields | Demo ingredients/recipes populate hero candidates | Visible: `/api/v1/home`; example `FrontendHomeResponse` | Separate `cta` object intentionally deferred because no navigation contract is finalized. |
| Home seasonal ingredient carousel | `GET /api/v1/home`, `GET /api/v1/ingredients` | partially covered | `id`, `name`, `imageUrl`, `category`, `price`, `seasonal`, `buyingSignal`, `tags` | `displayUnit`, `trendDirection`, `priceChangeLabel`, `badgeText`, rank/order | Demo seed creates ingredients and public prices | Visible: `/api/v1/home`, `/api/v1/ingredients` | Label-only fields are intentionally deferred; frontend can derive formatting from price/unit/tags until season/price trend scoring is formalized. |
| Home trending recipe/reels cards | `GET /api/v1/home`, `GET /api/v1/reels` | covered | recipe `title/imageUrl/likeCount/tags`, reel `title/thumbnailUrl/viewCount/likeCount/creatorName/durationSeconds` | none blocking | Demo seed creates recipes and reels | Visible: `/api/v1/home`, `/api/v1/reels`; examples include reels | Social counts are deterministic DB counts/defaults until richer analytics exists. |
| Home search result | `GET /api/v1/search?q={q}&type=ALL` | covered | grouped `ingredients`, `recipes`, `reels`, group counts, flat `items` retained | advanced ranking/rankDelta | Demo seed creates searchable ingredients/recipes/reels | Visible: `/api/v1/search` | Existing flat `items` remains for compatibility; grouped fields support screen sections. |
| Recipe list | `GET /api/v1/recipes` | covered | `id`, `title`, `description`, `imageUrl`, `difficulty`, `minutes`, `servings`, `likeCount`, `viewCount`, `creatorName`, `tags`, `seasonal` | `reelCount` | Demo seed creates recipes | Visible: `/api/v1/recipes`; example `FrontendRecipeDetailResponse` | `reelCount` intentionally deferred; related reels are available on detail. |
| Ingredient list | `GET /api/v1/ingredients` | partially covered | list response shape, `id`, `name`, `imageUrl`, `category`, `price`, `seasonal`, `buyingSignal`, `tags` | `displayUnit`, `trendDirection`, `priceChangeLabel`, `freshnessLabel` | Demo seed creates ingredients and prices | Visible: `/api/v1/ingredients` | Display labels intentionally deferred to avoid premature business rules. |
| Ingredient detail | `GET /api/v1/ingredients/{ingredientId}`, `/prices`, `/substitutes` | covered | `seasonMonths`, `nutrition`, `careTips`, `storageTips`, `substitutes.price`, `substitutes.unit`, `substitutes.priceDeltaLabel`, `compareStoreCount` | `seasonMonths` currently empty when no season table exists; `priceDeltaLabel` may be null | Demo seed creates nutrition/care/storage for 봄동 | Visible: `/api/v1/ingredients/{ingredientId}`; example `FrontendIngredientDetailResponse` | Actual season calendar integration intentionally deferred until season domain. |
| Price compare | `GET /api/v1/ingredients/{ingredientId}/offers` | covered | `storeName`, `storeType`, `logoUrl`, `logoText`, `brandColor`, `deliveryLabel`, `price`, `priceRangeMin`, `priceRangeMax`, `originalPrice`, `discountRate`, `badge`, `productUrl`, `observedAt` | `alertTargetPrice` | Demo seed creates seven store offers across five stores | Visible: `/api/v1/ingredients/{ingredientId}/offers`; example `FrontendIngredientOffersResponse` | `alertTargetPrice` belongs to user price-alert state and is intentionally not duplicated in store offers. |
| Product tab | `GET /api/v1/products` | not implemented | none | product cards, seller summary, price/unit, thumbnail, category from ingredient | Demo product data not available | Not visible yet | Replaces prior AI recommendation entry point in the new product direction. |
| Product detail | `GET /api/v1/products/{productId}` | not implemented | none | product detail, linked ingredient, related recipes, seller summary, images, stock/status | Demo product data not available | Not visible yet | Product must reference an ingredient; related recipes should derive from that ingredient. |
| Seller listing AI | `POST /api/v1/seller/products/price-recommendation`, `POST /api/v1/seller/products/promotional-copy` | not implemented | none | price recommendation, transparent assumptions, editable promotional copy | Demo seller/listing data not available | Not visible yet | AI chef/recommendation flow is retired; AI scope moves to seller pricing and product copy. |
| Reels feed | `GET /api/v1/reels`, `GET /api/v1/reels/{reelId}`, reel actions | covered | `id`, `recipeId`, `creatorId`, `creatorName`, `creatorAvatarUrl`, `videoUrl`, `thumbnailUrl`, `title`, `description`, `ingredientTags`, `likeCount`, `commentCount`, `saveCount`, `viewCount`, `durationSeconds`, `liked`, `saved`, `publishedAt` | none blocking | Demo seed creates reels and creator | Visible: reel endpoints; example `FrontendReelsResponse` | `saved` is currently default false unless save domain is later added. |
| Recipe detail from reel | `GET /api/v1/recipes/{recipeId}`, `/steps`, `/ingredients/{ingredientId}/recipes` | covered | `estimatedTotal`, ingredient `estimatedPrice`, `ingredientImageUrl`, `priceTrendDirection`, `tags`, `creatorName`, `likeCount`, `relatedReels`, steps `timerMinutes`, `tip` | `tip` may be null; creator may be null for non-demo recipes | Demo seed creates recipes, ingredients, steps, related reels | Visible: recipe endpoints | Missing optional values are nullable and serialization-safe. |
| My page | `GET /api/v1/users/me/summary` plus existing user APIs | covered | `profile`, `stats.monthlySaving`, `favoriteCount`, `activeAlertCount`, `pantryCount`, `recentOrderCount`, `preferences`, `allergyCodes`, `personalizedIngredients`, `menuRows` | real order/saving calculation | Demo user has preference, allergies, pantry, favorite, alert | Visible: `/api/v1/users/me/summary`; example `FrontendMyPageSummaryResponse` | `monthlySaving` and `recentOrderCount` are zero until order/settlement domains exist. |
| Alerts | `GET /api/v1/notifications`, read APIs | covered with compatibility risk | `items[].id`, `type`, `category`, `title`, `body`, `subtitle`, `icon`, `severity`, `readAt`, `createdAt`, `relativeTime`, `actionTargetType`, `actionTargetId`, `tabCounts` | date group labels such as 오늘/어제 are client-derived; `actionTargetId` may be null | Demo user has ingredient and recipe notifications | Visible: notification endpoints; example `FrontendNotificationsResponse` | T86 changed list response from `data: []` to `data.items + data.tabCounts`; this is the only known response-shape compatibility risk. |

## P0 Required Field Verification

Implemented:

- Home: `seasonTitle`, `seasonSubtitle`, `hero`, `ingredients`, `recipes`, `reels`, `trendingKeywords`, `unreadNotificationCount`.
- Search: grouped `ingredients`, `recipes`, `reels`, and group counts.
- Ingredient detail: `nutrition`, `careTips`, `storageTips`, `compareStoreCount`.
- Ingredient substitutes: `imageUrl`, `price`, `unit`, `priceDeltaLabel`.
- Store offers: store identity, delivery, price range, discount, badge, product URL, observed time.
- Recipe cards/details: social metadata placeholders, tags, seasonal flag, estimated total, ingredient price fields, related reels.
- Reels: feed/detail/action DTOs and counts.
- Products: product list/detail, linked ingredient, related recipes, seller price recommendation, promotional copy.
- My page: aggregate summary, preference state, allergy codes, counts, personalized ingredients.
- Notifications: category/icon/severity/subtitle/relative time/action target/tab counts.

Intentionally deferred:

- Season-domain fields: real `seasonMonths`, `seasonScore`, `trendDirection`, `priceChangeLabel`, `freshnessLabel`, `badgeText`, and `weeklySeason` remain heuristic/null/empty until the season and trend rules are implemented.
- Orders/savings: real `monthlySaving`, `recentOrderCount`, and checkout purchase completion are deferred because no order/payment domain exists.
- Promotion/admin data: promotion-like notification management and store campaigns are deferred to Phase 7 or later.
- Seller AI: price recommendation and promotional copy generation are deferred until product registration fields and AI output schemas are finalized.
- Notification grouping labels: date labels such as today/yesterday/this week should be derived by frontend from `createdAt` or `relativeTime`.

## API Compatibility Verification

No JPA entities are returned directly from controllers. Most prior DTOs were enriched additively without removing existing object fields.

Known compatibility risk:

- `GET /api/v1/notifications` changed from `ApiResponse<List<NotificationResponse>>` to `ApiResponse<NotificationListResponse>` with `items` and `tabCounts`. This was required by T86 for screen-ready tab counts, but clients generated against the prior array response must update.

## Swagger/OpenAPI Verification

The OpenAPI test suite verifies visibility for:

- `GET /api/v1/home`
- `GET /api/v1/search`
- `GET /api/v1/search/trending`
- `GET /api/v1/users/me/recent-searches`
- `GET /api/v1/ingredients/{ingredientId}/offers`
- `GET /api/v1/ingredients/{ingredientId}/recipes`
- `GET /api/v1/recipes`
- `GET /api/v1/recipes/{recipeId}`
- `GET /api/v1/recipes/{recipeId}/steps`
- `GET /api/v1/reels`
- `GET /api/v1/reels/{reelId}`
- `POST /api/v1/reels/{reelId}/likes`
- `GET /api/v1/reels/{reelId}/comments`
- `POST /api/v1/reels/{reelId}/view-events`
- Product and seller listing APIs are not implemented yet.
- `GET /api/v1/users/me/summary`
- `GET /api/v1/notifications`
- `POST /api/v1/dev/auth/token`

OpenAPI components include frontend demo examples:

- `FrontendHomeResponse`
- `FrontendIngredientDetailResponse`
- `FrontendIngredientOffersResponse`
- `FrontendRecipeDetailResponse`
- `FrontendReelsResponse`
- `FrontendMyPageSummaryResponse`
- `FrontendNotificationsResponse`

## Demo Seed Verification

Local/dev demo seed is profile-gated:

- Active profiles: `local`, `dev`
- Property: `app.demo-seed.enabled`
- Environment override: `DEMO_SEED_ENABLED=false`
- Not auto-loaded in `test` profile.

Demo seed is idempotent and creates data for:

- Home: ingredients, prices, recipes, reels, notifications.
- Ingredient list/detail: active ingredients, price snapshots, nutrition/care/storage for 봄동.
- Price compare: seven store offers across five stores.
- Recipe list/detail/steps: 봄동 비빔밥 and 무생채 with ingredients/steps.
- Reels feed/detail: two published reels and creator metadata.
- Product data: not yet available until product/listing domain is implemented.
- My page: demo user preference, allergies, pantry, favorite, price alert.
- Notifications: ingredient and recipe notifications.

## JWT Protected Endpoint Verification

JWT-protected endpoints can be tested with:

```http
POST /api/v1/dev/auth/token
Content-Type: application/json

{
  "userId": 1
}
```

The endpoint is available only in `local`, `dev`, and `test` profiles and issues a Bearer access token for an existing user. Demo seed creates `demo@seasonal-dining.local`; use that user's ID from the database.

## Verification Commands

Required commands:

```bash
./gradlew test
./gradlew clean build
```

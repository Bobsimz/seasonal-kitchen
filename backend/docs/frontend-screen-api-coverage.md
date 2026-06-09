# Frontend Screen API Coverage

Inspection target: `../frontend`

Date: 2026-06-05

## Scope

The frontend is a Next.js prototype rendered from a single app route:

- `app/page.jsx` renders `components/app.jsx`.
- `components/app.jsx` lays out multiple mobile artboards.
- Visible dynamic-looking cards, counts, lists, labels, badges, prices, buttons, and status text are treated as backend coverage requirements.

This document does not evaluate frontend code quality and does not require frontend changes.

## Screens And Coverage Matrix

| Screen name | Route/path if available | Frontend file/component | Visible UI section | Displayed data | Current data source | Required backend API | Existing backend API status | Missing endpoint | Missing response fields | Priority | Recommended backend task |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Splash | `/` artboard `splash` | `components/screens-onboarding.jsx` `ScreenSplash` | Brand intro | App logo, brand name, static slogan | Static JSX | None | Not needed | None | None | P2 | None |
| Onboarding price | `/` artboard `onboard` | `components/screens-onboarding.jsx` `ScreenOnboard` | Seasonal ingredient teaser cards | Ingredient name, image, status text such as `제철 · -15%`, `구매 적기`, `인기 ↑` | Inline array | Optional `GET /api/v1/home` or demo seed | Partially covered by home/ingredients | None if kept static onboarding | `seasonLabel`, `priceChangeLabel`, demo onboarding cards | P2 | `T87-demo-seed-data.md` |
| Onboarding trend | `/` artboard `onboard-2` | `components/screens-onboarding.jsx` `ScreenOnboard2` | Recipe/video trend cards | Recipe title, image, social/trend labels | Inline cards | Optional demo seed or recipe/reels API | Recipes and reels exist | None if kept static onboarding | None blocking | P2 | None |
| Onboarding AI | `/` artboard `onboard-3` | `components/screens-onboarding.jsx` `ScreenOnboard3` | AI explanation | Static prompt examples and result preview | Static JSX | None for MVP | Not needed | None | None | P2 | None |
| Sign up | `/` artboard `signup` | `components/screens-onboarding.jsx` `ScreenSignup` | OAuth buttons | Kakao, Apple, Google, email labels | Static JSX | `POST /api/v1/auth/oauth/{provider}` | Not implemented; only dev token exists | OAuth endpoints | OAuth request/response DTOs | P2 | Future auth task, not frontend-integration P0 |
| Sign up survey | `/` artboard `signup-survey` | `components/screens-onboarding.jsx` `ScreenSignupSurvey` | Preference setup | household size, spicy avoid, allergens, selected count | Inline constants | `PUT /api/v1/users/me/preferences` | Partially covered; preference exists but allergy response/list unclear | Allergy code catalog endpoint optional | `allergyCodes`, allergen labels, selectedAllergens | P1 | `T85-my-page-screen-api.md`, `T87-demo-seed-data.md` |
| Home main | `/` artboard `home-b` | `components/screens-home.jsx` `ScreenHomeB` | Header and notifications | Location-like context, unread notification dot | Static JSX | `GET /api/v1/home`, `GET /api/v1/notifications` | Covered | None | Location text remains frontend/static | P0 | None |
| Home main | `/` artboard `home-b` | `components/screens-home.jsx` `ScreenHomeB` | Hero seasonal card | seasonal headline, hero image, ingredient/recipe callout, price/trend summary | Static JSX and local images | `GET /api/v1/home` | Covered | None | `weeklySeason`, dedicated `cta` object deferred | P0 | None |
| Home main | `/` artboard `home-b` | `components/screens-home.jsx` `ScreenHomeB` | Seasonal ingredient carousel/list | ingredient name, image, current price, unit, trend value, tags | Inline arrays | `GET /api/v1/home` or `GET /api/v1/ingredients` | Ingredients covered but home response needs enrichment | None | `displayUnit`, `priceChangeLabel`, `trendDirection`, `rank`, `badgeText` | P0 | `T80-home-screen-api.md`, `T87-demo-seed-data.md` |
| Home main | `/` artboard `home-b` | `components/screens-home.jsx` `ScreenHomeB` | Trending recipe/reels cards | title, image, views, likes, tags | Inline arrays | `GET /api/v1/home`, `GET /api/v1/reels` | Covered | None | None blocking | P0 | None |
| Home search before | `/` artboard `home-search` | `components/screens-home.jsx` `ScreenHomeSearch` | Search suggestions | recent/popular keywords such as 배추전, 무생채, 시금치 페스토 | Inline array | `GET /api/v1/search/trending`, `GET /api/v1/users/me/recent-searches` | Existing | None | Possibly `category`, `rankDelta`, `displayLabel` | P1 | `T88-swagger-demo-examples.md` |
| Home search result | `/` artboard `home-search-result` | `components/screens-home.jsx` `ScreenHomeSearchResult` | Search result sections | counts and grouped ingredients, recipes, reels for query 봄동 | Inline arrays | `GET /api/v1/search?q=봄동&type=ALL` | Covered with flat and grouped fields | None | Advanced ranking/rankDelta | P0 | None |
| Recipe list | `/` artboard `list-rec` | `components/screens-detail.jsx` `ScreenRecipeList` | Recipe tab/list | categories, recipe cards, title, image, time, difficulty, likes | Inline `allRecipes` | `GET /api/v1/recipes` | Existing | None | `likes`, `tags`, `seasonal`, `creatorName`, `reelCount` | P0 | `T82-recipe-detail-screen-fields.md`, `T87-demo-seed-data.md` |
| Recipe search result | `/` artboard `list-rec-res` | `components/screens-detail.jsx` `ScreenRecipeListSearchResult` | Search filtered list | 봄동 recipe result count and cards | Inline filtered arrays | `GET /api/v1/recipes?query=봄동` or search API | Existing recipes may not support query; search exists flat | Query/filter support if absent | `totalElements`, `likes`, `tags` | P1 | `T82-recipe-detail-screen-fields.md` |
| Ingredient list | `/` artboard `list-ing` | `components/screens-detail.jsx` `ScreenList` | Ingredient tab/list | categories, item cards, price, unit, trend, tags | Inline `allItems` | `GET /api/v1/ingredients` | Existing | None | `displayUnit`, `trendDirection`, `priceChangeLabel`, `freshnessLabel` | P0 | `T80-home-screen-api.md`, `T87-demo-seed-data.md` |
| Ingredient search result | `/` artboard `list-ing-res` | `components/screens-detail.jsx` `ScreenListSearchResult` | Search filtered list | 봄동 ingredient result count and cards | Inline filtered arrays | `GET /api/v1/ingredients?query=봄동` or search API | Ingredients list exists; search exists flat | Query/filter support if absent | same as list | P1 | `T81-ingredient-detail-screen-fields.md` |
| Ingredient detail | `/` artboard `detail` | `components/screens-detail.jsx` `ScreenDetail` | Hero/detail summary | ingredient name, image, season months, price, trend, buying signal, nutrition, substitute ingredients, cleaning/storage tips | Static JSX and arrays | `GET /api/v1/ingredients/{ingredientId}`, `/prices`, `/substitutes` | Covered | None | Real season calendar and trend labels remain deferred | P0 | None |
| Price compare | `/` artboard `compare` | `components/screens-detail.jsx` `ScreenCompare` | Store/platform price comparison | store name, delivery text, price range, original price, discount, tag, logo, alert threshold | Inline `platforms` | `GET /api/v1/ingredients/{ingredientId}/offers` | Covered | None | `alertTargetPrice` belongs to price-alert state, not store offers | P0 | None |
| Product tab | TBD | TBD | Product discovery | product cards, seller, price, unit, origin, category | Not designed yet | `GET /api/v1/products` | Missing | Product list endpoint | Product card DTO | P0 | Product catalog implementation |
| Product detail | TBD | TBD | Product detail | product images, linked ingredient, related recipes, seller, stock/status, price | Not designed yet | `GET /api/v1/products/{productId}` | Missing | Product detail endpoint | Product detail DTO | P0 | Product catalog implementation |
| Seller listing | TBD | TBD | Product registration | product fields, AI price recommendation, AI promotional copy | Not designed yet | seller product and seller AI APIs | Missing | Seller listing endpoints | Registration and AI DTOs | P0 | Seller listing implementation |
| Reels feed | `/` artboard `reels` | `components/screens-reels.jsx` `ScreenReels` | Vertical reels | video/thumbnail, creator, title, ingredients tags, likes, comments, saves, view event | Static JSX | `GET /api/v1/reels`, like/comment/view APIs | Covered | None | `saved` remains default false until save domain is added | P0 | None |
| Recipe detail | `/` artboard `recipe` | `components/screens-reels.jsx` `ScreenRecipeDetail` | Recipe detail from reel | title, image, duration, difficulty, servings, ingredients with prices, related reels, creator/likes | Static JSX arrays | `GET /api/v1/recipes/{recipeId}`, `/steps`, `/ingredients/{id}/recipes` | Covered | None | Optional tips/creator can be null | P0 | None |
| Recipe steps | `/` artboard `steps` | `components/screens-reels.jsx` `ScreenRecipeSteps` | Cooking steps | step index, text, progress dots, timer-like UI | Static JSX | `GET /api/v1/recipes/{recipeId}/steps` | Existing | None | optional `timerMinutes`, `imageUrl`, `tip`, `isCurrent` handled client-side | P1 | `T82-recipe-detail-screen-fields.md` |
| My page | `/` artboard `mypage` | `components/screens-misc.jsx` `ScreenMyPage` | Profile summary | nickname/avatar, savings/stat cards, watched/favorite/alert counts, personalized seasonal list | Static JSX arrays | `GET /api/v1/users/me/summary` plus existing user APIs | Covered | None | Real order/saving calculation deferred | P0 | None |
| Alerts | `/` artboard `alerts` | `components/screens-misc.jsx` `ScreenAlerts` | Notification tabs and grouped list | tabs with counts, date groups, icon/color, title, subtitle, relative time, unread marker | Inline `groups` | `GET /api/v1/notifications` | Covered with `data.items + data.tabCounts` | None | Date group labels are client-derived | P0 | None |
| Cart / checkout | TBD | TBD | Cart and checkout | selected products, quantities, seller/product totals | Not designed yet | TBD | Missing | Cart/checkout decision pending | Cart persistence decision | P1 | Product commerce planning |

## Already Covered APIs

- `GET /api/v1/home`: exists and includes hero, recipes, reels, trending keywords, and unread notification count.
- `GET /api/v1/ingredients`: exists and supports ingredient cards.
- `GET /api/v1/ingredients/{ingredientId}`: exists and includes nutrition, care/storage tips, `seasonMonths`, and `compareStoreCount`.
- `GET /api/v1/ingredients/{ingredientId}/prices`: exists for price history.
- `GET /api/v1/ingredients/{ingredientId}/substitutes`: exists for substitutes, but likely needs price/reason enrichment for UI.
- `GET /api/v1/recipes`: exists with social metadata placeholders, tags, creator name, and seasonal flag.
- `GET /api/v1/recipes/{recipeId}`: exists with ingredients, estimated total, tags, creator metadata, and related reels.
- `GET /api/v1/recipes/{recipeId}/steps`: exists.
- `GET /api/v1/search`, `GET /api/v1/search/trending`, `GET /api/v1/users/me/recent-searches`: exist.
- `GET /api/v1/users/me`, `PATCH /api/v1/users/me`: exist.
- `PUT /api/v1/users/me/preferences`: exists.
- `GET/POST/PATCH/DELETE /api/v1/users/me/pantry`: exist.
- `GET/POST/DELETE /api/v1/favorites`: exist.
- `GET/POST/PATCH/DELETE /api/v1/price-alerts`: exist.
- Product and seller listing APIs are not implemented yet and replace the prior AI recommendation/shopping plan direction.
- `GET /api/v1/notifications`, `PATCH /api/v1/notifications/{notificationId}/read`, `PATCH /api/v1/notifications/read-all`: exist with `data.items + data.tabCounts`.
- `POST /api/v1/events`: exists.

## Missing APIs

- OAuth endpoints: `POST /api/v1/auth/oauth/{provider}`, `POST /api/v1/auth/refresh`, `POST /api/v1/auth/logout`
- Optional catalogs: `GET /api/v1/allergies`

## Seed/Demo Data Requirements

The visible prototype needs enough demo data to avoid empty screens:

- Ingredients: 봄동, 무, 배추, 시금치, 감귤, 대파, 고구마, 브로콜리, 단호박, 콜라비, 순무, 비트
- Recipes: 봄동 비빔밥, 무생채, 봄동 새우전, 배추전, 봄동 쌈밥, 시금치 페스토, 깍두기, 비빔밥, 나물 무침
- Reels: 봄동 비빔밥 1분, 배추전 황금레시피, 깍두기 모음, 시금치 페스토
- Store offers: 쿠팡, 마켓컬리, 오아시스, 네이버 장보기, 이마트몰
- User data: demo user, preferences, allergies, pantry, favorites, price alerts, notifications
- Products: product listings linked to ingredients, with seller, price, unit, origin, stock/status, and related recipe coverage

## Assumptions

- The prototype route is a design canvas, not production navigation. Artboard IDs are treated as screen identifiers.
- Static brand/intro copy is not treated as backend data unless it presents dynamic cards, counts, prices, or lists.
- Emoji icons and UI colors can be generated by frontend, but notification/reel/category semantic fields should come from backend.

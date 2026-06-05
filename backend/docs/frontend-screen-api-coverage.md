# Frontend Screen API Coverage

Inspection target: `../frontend`

Date: 2026-06-03

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
| Onboarding trend | `/` artboard `onboard-2` | `components/screens-onboarding.jsx` `ScreenOnboard2` | Recipe/video trend cards | Recipe title, image, social/trend labels | Inline cards | Optional demo seed or recipe/reels API | Recipes exist, reels missing | `GET /api/v1/reels` if made dynamic | reel title, creator, like/view counts | P2 | `T83-reels-feed-screen-api.md`, `T87-demo-seed-data.md` |
| Onboarding AI | `/` artboard `onboard-3` | `components/screens-onboarding.jsx` `ScreenOnboard3` | AI explanation | Static prompt examples and result preview | Static JSX | None for MVP | Not needed | None | None | P2 | None |
| Sign up | `/` artboard `signup` | `components/screens-onboarding.jsx` `ScreenSignup` | OAuth buttons | Kakao, Apple, Google, email labels | Static JSX | `POST /api/v1/auth/oauth/{provider}` | Not implemented; only dev token exists | OAuth endpoints | OAuth request/response DTOs | P2 | Future auth task, not frontend-integration P0 |
| Sign up survey | `/` artboard `signup-survey` | `components/screens-onboarding.jsx` `ScreenSignupSurvey` | Preference setup | household size, spicy avoid, allergens, selected count | Inline constants | `PUT /api/v1/users/me/preferences` | Partially covered; preference exists but allergy response/list unclear | Allergy code catalog endpoint optional | `allergyCodes`, allergen labels, selectedAllergens | P1 | `T85-my-page-screen-api.md`, `T87-demo-seed-data.md` |
| Home main | `/` artboard `home-b` | `components/screens-home.jsx` `ScreenHomeB` | Header and notifications | Location-like context, unread notification dot | Static JSX | `GET /api/v1/home`, `GET /api/v1/notifications` | Home exists but sparse; notifications exist | None | `unreadNotificationCount`, `seasonTitle`, `seasonSubtitle` | P0 | `T80-home-screen-api.md` |
| Home main | `/` artboard `home-b` | `components/screens-home.jsx` `ScreenHomeB` | Hero seasonal card | seasonal headline, hero image, ingredient/recipe callout, price/trend summary | Static JSX and local images | `GET /api/v1/home` | Existing response only `ingredients`, `recipes` | None | `hero`, `weeklySeason`, `recommendedReason`, `cta`, `imageUrl` quality seed | P0 | `T80-home-screen-api.md` |
| Home main | `/` artboard `home-b` | `components/screens-home.jsx` `ScreenHomeB` | Seasonal ingredient carousel/list | ingredient name, image, current price, unit, trend value, tags | Inline arrays | `GET /api/v1/home` or `GET /api/v1/ingredients` | Ingredients covered but home response needs enrichment | None | `displayUnit`, `priceChangeLabel`, `trendDirection`, `rank`, `badgeText` | P0 | `T80-home-screen-api.md`, `T87-demo-seed-data.md` |
| Home main | `/` artboard `home-b` | `components/screens-home.jsx` `ScreenHomeB` | Trending recipe/reels cards | title, image, views, likes, tags | Inline arrays | `GET /api/v1/home`, `GET /api/v1/reels` | Recipes exist; reels missing | `GET /api/v1/reels` | `viewCount`, `likeCount`, `creatorName`, `duration`, `thumbnailUrl` | P0 | `T80-home-screen-api.md`, `T83-reels-feed-screen-api.md` |
| Home search before | `/` artboard `home-search` | `components/screens-home.jsx` `ScreenHomeSearch` | Search suggestions | recent/popular keywords such as 배추전, 무생채, 시금치 페스토 | Inline array | `GET /api/v1/search/trending`, `GET /api/v1/users/me/recent-searches` | Existing | None | Possibly `category`, `rankDelta`, `displayLabel` | P1 | `T88-swagger-demo-examples.md` |
| Home search result | `/` artboard `home-search-result` | `components/screens-home.jsx` `ScreenHomeSearchResult` | Search result sections | counts and grouped ingredients, recipes, reels for query 봄동 | Inline arrays | `GET /api/v1/search?q=봄동&type=ALL` | Existing search has flat items only | None or enriched search response | Grouped result counts, sectioned results, recipe/reel metadata | P0 | `T80-home-screen-api.md`, `T83-reels-feed-screen-api.md` |
| Recipe list | `/` artboard `list-rec` | `components/screens-detail.jsx` `ScreenRecipeList` | Recipe tab/list | categories, recipe cards, title, image, time, difficulty, likes | Inline `allRecipes` | `GET /api/v1/recipes` | Existing | None | `likes`, `tags`, `seasonal`, `creatorName`, `reelCount` | P0 | `T82-recipe-detail-screen-fields.md`, `T87-demo-seed-data.md` |
| Recipe search result | `/` artboard `list-rec-res` | `components/screens-detail.jsx` `ScreenRecipeListSearchResult` | Search filtered list | 봄동 recipe result count and cards | Inline filtered arrays | `GET /api/v1/recipes?query=봄동` or search API | Existing recipes may not support query; search exists flat | Query/filter support if absent | `totalElements`, `likes`, `tags` | P1 | `T82-recipe-detail-screen-fields.md` |
| Ingredient list | `/` artboard `list-ing` | `components/screens-detail.jsx` `ScreenList` | Ingredient tab/list | categories, item cards, price, unit, trend, tags | Inline `allItems` | `GET /api/v1/ingredients` | Existing | None | `displayUnit`, `trendDirection`, `priceChangeLabel`, `freshnessLabel` | P0 | `T80-home-screen-api.md`, `T87-demo-seed-data.md` |
| Ingredient search result | `/` artboard `list-ing-res` | `components/screens-detail.jsx` `ScreenListSearchResult` | Search filtered list | 봄동 ingredient result count and cards | Inline filtered arrays | `GET /api/v1/ingredients?query=봄동` or search API | Ingredients list exists; search exists flat | Query/filter support if absent | same as list | P1 | `T81-ingredient-detail-screen-fields.md` |
| Ingredient detail | `/` artboard `detail` | `components/screens-detail.jsx` `ScreenDetail` | Hero/detail summary | ingredient name, image, season months, price, trend, buying signal, nutrition, substitute ingredients, cleaning/storage tips | Static JSX and arrays | `GET /api/v1/ingredients/{ingredientId}`, `/prices`, `/substitutes` | Partially covered | None for substitutes/prices; detail enrichment needed | `seasonMonths`, `nutrition`, `careTips`, `storageTips`, `substitutes.price`, `substitutes.reason`, `compareStoreCount` | P0 | `T81-ingredient-detail-screen-fields.md` |
| Price compare | `/` artboard `compare` | `components/screens-detail.jsx` `ScreenCompare` | Store/platform price comparison | store name, delivery text, price range, original price, discount, tag, logo, alert threshold | Inline `platforms` | `GET /api/v1/ingredients/{ingredientId}/offers` | API listed in docs but not implemented in current code | `GET /api/v1/ingredients/{ingredientId}/offers` | `storeName`, `storeType`, `deliveryLabel`, `priceRange`, `discountRate`, `productUrl`, `badge`, `alertTargetPrice` | P0 | `T81-ingredient-detail-screen-fields.md` |
| AI chat | `/` artboard `ai-b` | `components/screens-ai.jsx` `ScreenAIChatB` | Chat and quick prompts | assistant messages, user request, quick prompt cards | Static JSX | `POST /api/v1/recommendations/plans`, `POST /messages` | Existing minimal | None | `messages`, `quickPrompts`, `suggestedConditions`, rich assistant card data | P0 | `T84-ai-shopping-screen-response.md` |
| AI recommendation result | `/` artboard `ai-result` | `components/screens-ai.jsx` `ScreenAIResult` | Plan result and cart | summary, expected savings, selected recipes, cart items, platform split, total | Inline `CART_ITEMS` | `POST /api/v1/recommendations/plans`, `GET /api/v1/shopping-plans/{planId}` | Existing but response is minimal and `items` is `List<Object>` | Store-links endpoint documented but not implemented | meals, reasons, substitutions, shopping items with names/prices/platform/tags, expectedSavingRate, store split | P0 | `T84-ai-shopping-screen-response.md` |
| Reels feed | `/` artboard `reels` | `components/screens-reels.jsx` `ScreenReels` | Vertical reels | video/thumbnail, creator, title, ingredients tags, likes, comments, saves, view event | Static JSX | `GET /api/v1/reels`, like/comment/view APIs | API listed in docs but not implemented in current code | `GET /api/v1/reels`, `GET /api/v1/reels/{id}`, reaction/comment APIs | all reel response fields | P0 | `T83-reels-feed-screen-api.md` |
| Recipe detail | `/` artboard `recipe` | `components/screens-reels.jsx` `ScreenRecipeDetail` | Recipe detail from reel | title, image, duration, difficulty, servings, ingredients with prices, related reels, creator/likes | Static JSX arrays | `GET /api/v1/recipes/{recipeId}`, `/steps`, `/ingredients/{id}/recipes` | Partially covered | Ingredient-to-recipes endpoint listed but not implemented | ingredient estimated prices, creator, likes, related reels, tags, totalEstimatedCost | P0 | `T82-recipe-detail-screen-fields.md` |
| Recipe steps | `/` artboard `steps` | `components/screens-reels.jsx` `ScreenRecipeSteps` | Cooking steps | step index, text, progress dots, timer-like UI | Static JSX | `GET /api/v1/recipes/{recipeId}/steps` | Existing | None | optional `timerMinutes`, `imageUrl`, `tip`, `isCurrent` handled client-side | P1 | `T82-recipe-detail-screen-fields.md` |
| My page | `/` artboard `mypage` | `components/screens-misc.jsx` `ScreenMyPage` | Profile summary | nickname/avatar, savings/stat cards, watched/favorite/alert counts, personalized seasonal list | Static JSX arrays | `GET /api/v1/users/me`, preferences, pantry, favorites, price-alerts, notifications | Partially covered | Aggregated my-page endpoint recommended | `stats`, `activeAlertCount`, `favoriteCount`, `monthlySaving`, `personalizedIngredients` | P0 | `T85-my-page-screen-api.md` |
| Alerts | `/` artboard `alerts` | `components/screens-misc.jsx` `ScreenAlerts` | Notification tabs and grouped list | tabs with counts, date groups, icon/color, title, subtitle, relative time, unread marker | Inline `groups` | `GET /api/v1/notifications` | Existing but flat and lacks UI fields | None or enriched response | `category`, `icon`, `severity`, `actionTargetType`, `actionTargetId`, `relativeTime`, grouped counts | P0 | `T86-notification-screen-fields.md` |
| Checkout | Imported but not in main artboards | `components/screens-misc.jsx` `ScreenCheckout` | Platform split checkout | store groups, item names/prices, savings, external app CTA | Inline arrays | `GET /api/v1/shopping-plans/{planId}/store-links` | Listed in docs but not implemented | `GET /api/v1/shopping-plans/{planId}/store-links` | `storeGroups`, `savingAmount`, `externalCheckoutUrl`, `deliveryLabel` | P1 | `T84-ai-shopping-screen-response.md` |

## Already Covered APIs

- `GET /api/v1/home`: exists, but response is too sparse for the visible home screen.
- `GET /api/v1/ingredients`: exists and supports ingredient cards.
- `GET /api/v1/ingredients/{ingredientId}`: exists, but lacks nutrition, season months, care/storage tips, and richer substitution/store fields.
- `GET /api/v1/ingredients/{ingredientId}/prices`: exists for price history.
- `GET /api/v1/ingredients/{ingredientId}/substitutes`: exists for substitutes, but likely needs price/reason enrichment for UI.
- `GET /api/v1/recipes`: exists, but lacks likes/tags/creator/reel metadata.
- `GET /api/v1/recipes/{recipeId}`: exists, but lacks related reels, ingredient price summary, tags, creator metadata, and estimated cost.
- `GET /api/v1/recipes/{recipeId}/steps`: exists.
- `GET /api/v1/search`, `GET /api/v1/search/trending`, `GET /api/v1/users/me/recent-searches`: exist.
- `GET /api/v1/users/me`, `PATCH /api/v1/users/me`: exist.
- `PUT /api/v1/users/me/preferences`: exists.
- `GET/POST/PATCH/DELETE /api/v1/users/me/pantry`: exist.
- `GET/POST/DELETE /api/v1/favorites`: exist.
- `GET/POST/PATCH/DELETE /api/v1/price-alerts`: exist.
- `POST /api/v1/recommendations/plans`, `GET /api/v1/recommendations/plans/{planId}`, `POST /api/v1/recommendations/plans/{planId}/messages`: exist but response is minimal.
- `GET /api/v1/shopping-plans/{planId}`, `PATCH /api/v1/shopping-plans/{planId}/items/{itemId}`: exist.
- `GET /api/v1/notifications`, `PATCH /api/v1/notifications/{notificationId}/read`, `PATCH /api/v1/notifications/read-all`: exist but notification response is too flat for UI.
- `POST /api/v1/events`: exists.

## Missing APIs

- `GET /api/v1/ingredients/{ingredientId}/offers`
- `GET /api/v1/ingredients/{ingredientId}/recipes`
- `GET /api/v1/reels`
- `GET /api/v1/reels/{reelId}`
- `POST /api/v1/reels/{reelId}/likes`
- `DELETE /api/v1/reels/{reelId}/likes`
- `GET /api/v1/reels/{reelId}/comments`
- `POST /api/v1/reels/{reelId}/comments`
- `POST /api/v1/reels/{reelId}/view-events`
- `GET /api/v1/shopping-plans/{planId}/store-links`
- Recommended aggregate: `GET /api/v1/users/me/summary`
- Optional catalogs: `GET /api/v1/allergies`, `GET /api/v1/recommendations/quick-prompts`

## Seed/Demo Data Requirements

The visible prototype needs enough demo data to avoid empty screens:

- Ingredients: 봄동, 무, 배추, 시금치, 감귤, 대파, 고구마, 브로콜리, 단호박, 콜라비, 순무, 비트
- Recipes: 봄동 비빔밥, 무생채, 봄동 새우전, 배추전, 봄동 쌈밥, 시금치 페스토, 깍두기, 비빔밥, 나물 무침
- Reels: 봄동 비빔밥 1분, 배추전 황금레시피, 깍두기 모음, 시금치 페스토
- Store offers: 쿠팡, 마켓컬리, 오아시스, 네이버 장보기, 이마트몰
- User data: demo user, preferences, allergies, pantry, favorites, price alerts, notifications
- Shopping plan: 5-day/2-person plan with 9 cart items and store split

## Assumptions

- The prototype route is a design canvas, not production navigation. Artboard IDs are treated as screen identifiers.
- Static brand/intro copy is not treated as backend data unless it presents dynamic cards, counts, prices, or lists.
- Emoji icons and UI colors can be generated by frontend, but notification/reel/category semantic fields should come from backend.

## Why

The product direction is shifting from AI chef and shopping recommendation flows toward commerce around farm products, seller listings, product discovery, and ingredient/recipe information. The current specs still describe AI chef, price trend screens, notification-heavy headers, and ingredient-centric exploration, which no longer matches the planned MVP.

This change captures the new direction before implementation so backend, frontend, and design work can converge while details such as seller listing templates are still being decided.

## What Changes

- Remove AI chef as a product-facing feature, including related buttons and pages.
- Rename the current exploration tab into a product tab.
- Add an information tab that contains existing ingredient and recipe experiences.
- Treat ingredients and products as separate concepts.
- Remove price trend screens while preserving seller-facing AI price recommendation based on seed/cultivar cost, investment, market prices, inflation, and labor costs.
- Add seller product registration and product detail capabilities.
- Add AI promotional copy generation based on agricultural product characteristics such as cultivar, seasonality, sweetness, origin, freshness, and growing notes.
- Add product results to search.
- Standardize header icons around search and cart, with notifications removed from the MVP header.
- Add user lifestyle/consumption preference data for future persona and farm-product matching.
- Allow the search screen bottom navigation to be removed later if it harms usability.

## Capabilities

### New Capabilities

- `product-catalog`: Product list/detail browsing for purchasable goods.
- `seller-listing`: Seller-facing product registration, with AI assistance for price recommendation and promotional copy generation.
- `frontend-navigation`: MVP tab/header structure and screen-level navigation rules.
- `user-persona`: Lifestyle and consumption preference fields used for future matching.

### Modified Capabilities

- `search`: Search results include products in addition to information content.
- `ingredient-and-recipe-info`: Existing ingredient and recipe content moves under the information tab.
- `price-intelligence`: Price trend UI is removed, but seller price recommendation and price rise/fall prediction remain separately scoped.
- `ai-chef-retirement`: AI chef pages/buttons are removed from the MVP product surface.

## Impact

- Affected frontend: navigation tabs, headers, search screen, product tab, information tab, seller listing page, product detail page.
- Affected backend domains: new `product` and seller listing domains, existing `ingredient`, `recipe`, `search`, `user`, and `price` domains.
- Affected specs/docs: existing AI chef and shopping specs are removed; price, home/search, frontend integration, and user specs need follow-up updates after this change is approved.
- Affected persistence: likely new product, seller/listing, product image, inventory, and user lifestyle preference tables.
- Affected APIs: product list/detail, seller listing create/update, AI seller price recommendation, AI promotional copy assist, product search category, cart/header-related read APIs.
- Deferred decisions: seller registration template, seller identity/auth flow, payment/order scope, cart persistence, product moderation, exact AI output shape and required pricing inputs.

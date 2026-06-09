## Context

The current repository has backend APIs and specs for ingredients, recipes, prices, search, reels, favorites, notifications, and legacy shopping/recommendation code. The new product direction separates content information from commerce:

- Ingredient: normalized food concept such as `배추`, `감자`, `딸기`.
- Product: purchasable seller listing such as `무농약 감자 3kg`, `성주 참외 5kg`.
- Information tab: ingredient and recipe discovery.
- Product tab: purchasable goods and commerce discovery.

Frontend screens for the new product/seller flows are not available yet, so this change intentionally avoids over-specifying final DTOs.

## Goals / Non-Goals

**Goals:**

- Establish that AI chef is out of the MVP surface.
- Establish product and ingredient separation.
- Add a first-pass product catalog and seller listing contract.
- Keep AI only where it supports seller price recommendation, promotional copy generation, and price prediction.
- Update search/navigation expectations before frontend implementation starts.
- Preserve existing ingredient/recipe APIs as information content.

**Non-Goals:**

- Do not implement payment, settlement, delivery integration, or full order lifecycle in this change.
- Do not finalize seller listing templates before design/product discussion.
- Do not remove backend notification or price data infrastructure only because the MVP header hides notifications.
- Do not merge product and ingredient tables.
- Do not define real AI model/provider integration details yet.

## Decisions

1. Product and ingredient are separate aggregate roots.
   - Rationale: Ingredient metadata is reusable information; product data is seller-, price-, stock-, and delivery-specific.
   - Implication: A product must reference an ingredient, but product search/detail must not be served by ingredient DTOs.

2. Product category follows the linked ingredient category.
   - Rationale: Sellers sell a concrete product for an existing food category, while the seller differentiates the listing through product title, unit, price, origin, story, images, and description.
   - Implication: The product does not need an independent category taxonomy for MVP; category labels can be derived from the linked ingredient.

3. Product detail links back to ingredient information and related recipes.
   - Rationale: Users need to move from a purchasable product to recipes and see required recipe ingredients.
   - Implication: Product detail should expose the linked ingredient and enough related recipe references for frontend navigation.

4. AI chef is retired from the product-facing MVP.
   - Rationale: The new flow prioritizes commerce and seller/product discovery.
   - Implication: Existing AI chef buttons/pages and recommendation specs should be removed; legacy backend recommendation APIs should be removed in a follow-up code cleanup.

5. AI is retained for seller price recommendation, promotional copy generation, and price prediction only.
   - Rationale: These AI uses support the new commerce direction.
   - Implication: AI output must assist pricing, content generation, or prediction, not invent authoritative product facts such as stock, origin, cultivar, sweetness, certifications, or seller identity.

6. Navigation is product-first.
   - Rationale: The current exploration tab is becoming a product tab, while ingredient/recipe content moves to information.
   - Implication: frontend integration specs should describe product tab and information tab separately.

7. Notification removal is initially UI scope.
   - Rationale: Hiding header notification icons does not require deleting backend notification APIs immediately.
   - Implication: notification APIs can remain, but they should be removed from P0 header requirements.

## Open Questions

- What seller identity is required for hackathon MVP: normal user, farm seller profile, or admin-created seller?
- What fields are mandatory for product registration: images, origin, harvest date, delivery method, stock, unit, price, linked ingredient, and seller description?
- What should the AI listing template generate: title, description, tags, freshness notes, storage tips, product story, or all of these?
- Which pricing inputs are mandatory for seller price recommendation: seed/cultivar cost, total investment, market price, inflation rate, labor cost, expected margin, yield, stock volume, or delivery cost?
- Does cart need persistence in backend for MVP, or can it be frontend-local until checkout/order is defined?
- Does product detail include reviews, seller profile, farm story, or related products in the first slice?
- Are price recommendations and price predictions shown on seller registration, product detail, or a separate seller insight component?

## Risks / Trade-offs

- If product/listing fields are over-specified before UI design, backend work may churn.
- If product and ingredient are mixed for speed, future search and seller flows will be hard to maintain.
- Keeping legacy AI chef or shopping recommendation APIs can confuse docs and frontend planning unless code cleanup follows the spec removal.
- AI-generated listing copy can misrepresent product facts unless generated fields are constrained and editable.
- AI price recommendations can mislead sellers if cost inputs, market source dates, inflation/labor assumptions, and confidence/explanation are hidden.

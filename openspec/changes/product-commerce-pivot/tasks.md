## 1. Product Decisions

- [ ] 1.1 Define MVP seller identity: regular user seller, farm profile, or admin-created seller.
- [ ] 1.2 Define minimum product registration fields.
- [x] 1.3 Product registration requires linked `ingredientId`.
- [ ] 1.4 Decide product status lifecycle: draft, pending review, published, hidden, sold out.
- [ ] 1.5 Decide whether cart is frontend-local or backend-persisted for MVP.
- [ ] 1.6 Define required inputs for seller AI price recommendation: seed/cultivar cost, investment, market price, inflation, labor cost, yield, stock volume, and margin policy.
- [ ] 1.7 Define required inputs for AI promotional copy: cultivar, seasonality, sweetness, origin, freshness, growing method, harvest date, and seller-provided notes.

## 2. Spec Updates

- [ ] 2.1 Add baseline `backend-product` spec after product fields are agreed.
- [ ] 2.2 Add baseline `backend-seller-listing` spec after registration flow is agreed.
- [ ] 2.3 Modify `backend-home-search` so search includes product category results.
- [ ] 2.4 Modify `backend-user` for lifestyle/consumption preference fields.
- [ ] 2.5 Modify `backend-price` to remove price trend screen requirements and retain prediction capability.
- [ ] 2.6 Modify `frontend-integration` for product tab, information tab, header icon rules, and AI chef removal.
- [x] 2.7 Remove `backend-ai-chef` and `backend-shopping` baseline specs from the active MVP spec set.

## 3. Backend Implementation Candidates

- [ ] 3.1 Add product/listing Flyway migration.
- [ ] 3.2 Add product entity, repository, service, and DTOs.
- [ ] 3.3 Add public product list/detail APIs.
- [ ] 3.4 Add seller product registration APIs.
- [ ] 3.5 Add AI seller price recommendation endpoint with transparent input assumptions.
- [ ] 3.6 Add AI promotional copy endpoint with editable generated output.
- [ ] 3.7 Add product category to unified search.
- [ ] 3.8 Add lifestyle preference fields to user preference APIs.
- [ ] 3.9 Add related ingredient and related recipe references to product detail responses.

## 4. Frontend Implementation Candidates

- [ ] 4.1 Remove AI chef buttons and pages.
- [ ] 4.2 Rename exploration tab to product tab.
- [ ] 4.3 Add information tab for ingredients and recipes.
- [ ] 4.4 Standardize header icons: search plus cart; reels use search only.
- [ ] 4.5 Remove exploration-tab search bar and add left back button where applicable.
- [ ] 4.6 Add product detail screen.
- [ ] 4.7 Add seller product registration screen.
- [ ] 4.8 Add product category to search results.
- [ ] 4.9 Evaluate whether search screen should hide bottom navigation.

## 5. Verification

- [ ] 5.1 Run `openspec validate --all`.
- [ ] 5.2 Run backend tests after backend code changes.
- [ ] 5.3 Verify frontend navigation and header consistency after screens exist.

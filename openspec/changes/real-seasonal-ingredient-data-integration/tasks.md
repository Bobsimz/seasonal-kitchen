## 1. Data Source Agreement

- [ ] 1.1 Choose the primary seasonal data source and document provider name, endpoint, authentication, quota, and update cadence.
- [ ] 1.2 Choose KAMIS endpoints for public price snapshots and document required request parameters.
- [ ] 1.3 Define internal source identifiers such as `KAMIS`, `PUBLIC_SEASONAL_DATA`, and `CURATED`.
- [ ] 1.4 Define which fields are trusted from each source and which fields require internal curation.

## 2. Persistence Contract

- [ ] 2.1 Add Flyway migration for import job metadata if not already sufficient.
- [ ] 2.2 Add Flyway migration for raw external payload retention.
- [ ] 2.3 Verify `seasonal_ingredients` supports ingredient, month, optional region, score, and source metadata.
- [ ] 2.4 Add or verify unique constraints and indexes for idempotent seasonal and price imports.

## 3. External Data Clients

- [ ] 3.1 Implement KAMIS client under `infrastructure/kamis` with timeout and failure handling.
- [ ] 3.2 Implement seasonal data client or curated data loader under `infrastructure/season`.
- [ ] 3.3 Add DTOs for external responses without exposing them through public controllers.
- [ ] 3.4 Add configuration properties for API keys, base URLs, timeouts, and scheduler enablement.

## 4. Normalization and Import Services

- [ ] 4.1 Implement alias-based ingredient matching using `ingredient_aliases`.
- [ ] 4.2 Persist unmapped external rows as import errors or candidates for review.
- [ ] 4.3 Import seasonal rows idempotently.
- [ ] 4.4 Import price snapshots append-only and idempotently.
- [ ] 4.5 Record import counts and failure details.

## 5. Scheduling and Admin Operations

- [ ] 5.1 Add scheduled import jobs controlled by profile/config.
- [ ] 5.2 Add admin/manual import trigger endpoints if approved for this change.
- [ ] 5.3 Add import job status/list endpoints if approved for this change.
- [ ] 5.4 Ensure admin endpoints require existing security rules and are visible in Swagger.

## 6. API Enrichment

- [ ] 6.1 Enrich ingredient list/detail responses with persisted `seasonal`, `seasonScore`, and `seasonMonths`.
- [ ] 6.2 Enrich home response with real seasonal ingredient sections.
- [ ] 6.3 Derive price trend fields from latest price snapshots where business rules are defined.
- [ ] 6.4 Keep all new response fields additive or nullable.

## 7. Tests and Verification

- [ ] 7.1 Add importer unit tests for success, unmapped rows, duplicate rows, and external failure.
- [ ] 7.2 Add repository/service tests for seasonal lookup by month and region fallback.
- [ ] 7.3 Add controller/OpenAPI tests for enriched ingredient/home/admin APIs.
- [ ] 7.4 Run `./gradlew test`.
- [ ] 7.5 Run `./gradlew clean build`.

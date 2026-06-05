## Why

Seasonal Dining currently has demo-friendly ingredient, price, and home-screen data, but real seasonal ingredient behavior is still heuristic or deferred. The product needs a shared contract for integrating trusted seasonal and public market data before implementation so backend, frontend, and data work do not diverge.

## What Changes

- Add a real seasonal ingredient data capability backed by normalized `seasonal_ingredients` records.
- Add an external data ingestion capability for scheduled collection, normalization, raw payload retention, and idempotent imports.
- Add KAMIS public price ingestion for `price_snapshots` using existing ingredient aliases.
- Enrich existing ingredient and home APIs with real seasonality and trend-derived fields where data is available.
- Add admin/import observability requirements for manual import triggering and failure inspection.
- No breaking API shape changes are intended. Existing DTO fields must remain compatible; new fields should be additive or nullable.

## Capabilities

### New Capabilities

- `seasonal-ingredient-data`: Stores and serves monthly/regional seasonality for ingredients.
- `external-data-ingestion`: Imports external food, seasonal, and price data safely and idempotently.

### Modified Capabilities

- `ingredient-catalog`: Ingredient list/detail responses should use persisted seasonality instead of placeholders when available.
- `price-history`: Price history should be populated from trusted external public price sources such as KAMIS.
- `home-screen`: Home seasonal sections should be driven by persisted seasonality and price trend data.

## Impact

- Affected domains: `ingredient`, `season`, `price`, `home`, `admin`, `notification`, `analytics`.
- Affected infrastructure: `infrastructure/kamis`, future seasonal-data client modules, scheduler/batch jobs.
- Affected persistence: Flyway migrations for seasonal source metadata, import jobs, raw external payloads, and any missing indexes.
- Affected APIs: existing public read APIs may receive additive fields; admin import APIs may be added for local/dev/admin use.
- Affected tests: repository/service/controller tests, importer idempotency tests, scheduler/import failure tests, OpenAPI visibility tests.

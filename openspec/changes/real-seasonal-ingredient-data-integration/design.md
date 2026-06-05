## Context

The backend already defines `seasonal_ingredients`, `price_snapshots`, `ingredient_aliases`, home/search/ingredient APIs, notification jobs, and demo seed data. Frontend verification documents explicitly defer real `seasonMonths`, `seasonScore`, `trendDirection`, `priceChangeLabel`, `freshnessLabel`, `badgeText`, and `weeklySeason` until a real season and trend model exists.

The intended data sources are:

- KAMIS for public agricultural price data.
- Public data portals or agricultural public datasets for seasonal/monthly ingredient information.
- Internal curation for gaps where public seasonality is unavailable or too coarse.

## Goals / Non-Goals

**Goals:**

- Persist real monthly and optional regional seasonality per ingredient.
- Import public price snapshots without overwriting history.
- Normalize external names/codes through `ingredient_aliases`.
- Retain raw external payloads for audit and reprocessing.
- Make imports idempotent and observable.
- Enrich public APIs using real seasonality and price trends without breaking current response contracts.

**Non-Goals:**

- Do not implement OAuth, payment, settlement, promotion, or creator workflows.
- Do not let AI generate or correct prices, stores, or seasonality.
- Do not introduce microservices, Kafka, or RabbitMQ.
- Do not replace existing demo seed data; real data should coexist with local/dev seed behavior.
- Do not require Redis caching in the first implementation slice unless a later task explicitly adds it.

## Decisions

1. Use append-only price snapshots.
   - Rationale: Existing architecture requires price history to remain reproducible.
   - Implication: Import deduplication must use a unique provider/source key such as ingredient, source, price type, unit, observed date, and external item code where available.

2. Use `ingredient_aliases` as the normalization boundary.
   - Rationale: External names such as radish variants must map to one internal ingredient before API responses are calculated.
   - Implication: Unmapped external rows should be retained as import errors or candidates, not silently discarded.

3. Store raw external payloads separately from normalized domain rows.
   - Rationale: Teams need traceability when external APIs change or normalization rules are wrong.
   - Implication: Import jobs should expose counts for fetched, inserted, skipped, failed, and unmapped rows.

4. Keep public APIs additive and nullable.
   - Rationale: Existing frontend/API clients must not break.
   - Implication: Fields such as season labels, trend labels, and score can be null or empty until data exists.

5. Prefer scheduled jobs plus admin/manual import triggers.
   - Rationale: Local/dev verification and production operations both need deterministic import execution.
   - Implication: Scheduled execution should be profile/config controlled and admin endpoints should be protected.

## Risks / Trade-offs

- Public seasonal datasets may not have ingredient names aligned with KAMIS or the internal catalog.
- KAMIS price units may not match internal `baseUnit`; unit conversion rules may need explicit curation.
- External API quotas or outages can delay fresh data. The app should serve the latest known data and record import failures.
- Real seasonality can be regional, but the frontend may initially consume nationwide data only.
- Adding trend-derived labels too early may create misleading business semantics; numeric values should be the source of truth.

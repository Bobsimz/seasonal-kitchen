## MODIFIED Requirements

### Requirement: Home seasonal sections use real data

The home API SHALL build seasonal ingredient sections from persisted seasonal data and latest valid price snapshots when those records exist.

#### Scenario: Seasonal and price data exist

- **GIVEN** active ingredients have seasonal records for the current month
- **AND** latest valid price snapshots exist
- **WHEN** `GET /api/v1/home` is requested
- **THEN** the home response includes seasonal ingredient cards sorted by a deterministic business rule
- **AND** price summaries are based on persisted price snapshots

#### Scenario: Real data is unavailable

- **GIVEN** no real seasonal or price data exists
- **WHEN** `GET /api/v1/home` is requested
- **THEN** the API returns a safe response using existing demo or fallback behavior
- **AND** does not fail only because external data is unavailable

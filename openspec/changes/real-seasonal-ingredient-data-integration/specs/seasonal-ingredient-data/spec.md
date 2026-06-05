## ADDED Requirements

### Requirement: Persist seasonal ingredient records

The system SHALL store seasonal ingredient information per internal ingredient, month, optional region, score, and source.

#### Scenario: Nationwide seasonal data is available

- **GIVEN** an active ingredient exists
- **AND** a seasonal data source provides nationwide seasonality for that ingredient
- **WHEN** the seasonal import runs
- **THEN** the system persists monthly seasonality rows for the ingredient
- **AND** the rows include source and score metadata

#### Scenario: Regional seasonal data is available

- **GIVEN** an active ingredient exists
- **AND** a seasonal data source provides region-specific seasonality
- **WHEN** the seasonal import runs
- **THEN** the system persists rows with `regionCode`
- **AND** the nationwide row remains usable as fallback when no regional row exists

### Requirement: Serve real seasonality in ingredient APIs

Ingredient list and detail responses SHALL use persisted seasonal records to determine seasonal flags, season months, and season score when data exists.

#### Scenario: Ingredient is in season for the current month

- **GIVEN** persisted seasonal data exists for the ingredient and current month
- **WHEN** a client requests ingredient list or detail data
- **THEN** the response marks the ingredient as seasonal
- **AND** includes the best available season score

#### Scenario: No seasonal data exists

- **GIVEN** no persisted seasonal data exists for an ingredient
- **WHEN** a client requests ingredient list or detail data
- **THEN** the response remains serialization-safe
- **AND** seasonal fields are false, empty, or null according to the existing DTO contract

### Requirement: Preserve curated overrides

The system SHALL allow internally curated seasonal data to coexist with external source data and take precedence when explicitly configured.

#### Scenario: Curated row overrides external row

- **GIVEN** an external seasonal row and curated seasonal row exist for the same ingredient, month, and region
- **WHEN** API seasonality is resolved
- **THEN** the curated row is selected before external rows

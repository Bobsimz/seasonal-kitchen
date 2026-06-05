## ADDED Requirements

### Requirement: Import external data idempotently

The system SHALL import external seasonal and price data without creating duplicate normalized records when the same source payload is processed more than once.

#### Scenario: Same import is run twice

- **GIVEN** an external payload was already imported successfully
- **WHEN** the same payload is imported again
- **THEN** the system skips or updates only idempotent metadata
- **AND** does not create duplicate seasonal rows or duplicate price snapshots

### Requirement: Retain raw external payloads

The system SHALL retain raw external response payloads or equivalent audit records for each import execution.

#### Scenario: Import succeeds

- **WHEN** an import job completes successfully
- **THEN** the system records the source, requested parameters, execution time, raw payload reference or body, and row counts

#### Scenario: Import fails

- **WHEN** an external provider request fails or times out
- **THEN** the system records the failure details
- **AND** the public APIs continue serving the latest known valid data

### Requirement: Normalize external ingredients through aliases

The system SHALL map external food names and external item codes to internal ingredients through `ingredient_aliases`.

#### Scenario: Alias exists

- **GIVEN** an external row has a source and external code or name
- **AND** a matching ingredient alias exists
- **WHEN** the import runs
- **THEN** the row is normalized to the mapped internal ingredient

#### Scenario: Alias does not exist

- **GIVEN** an external row has no matching ingredient alias
- **WHEN** the import runs
- **THEN** the row is not exposed through public APIs
- **AND** the system records it as an unmapped candidate or import error

### Requirement: Configure external providers safely

External provider base URLs, API keys, timeouts, and scheduler enablement SHALL be read from application configuration or environment variables.

#### Scenario: Secret is missing in local development

- **GIVEN** a required external API key is not configured
- **WHEN** the application starts
- **THEN** public APIs still start normally
- **AND** the import job is disabled or fails with an explicit configuration error when invoked

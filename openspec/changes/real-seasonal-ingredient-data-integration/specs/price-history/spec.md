## MODIFIED Requirements

### Requirement: Price history imports public market data

Price snapshot history SHALL be populated from trusted public price sources and remain append-only.

#### Scenario: KAMIS price row maps to an ingredient

- **GIVEN** a KAMIS price row has a matching ingredient alias
- **WHEN** the price import runs
- **THEN** a `price_snapshots` row is inserted for the internal ingredient
- **AND** the snapshot includes source, price type, unit, price, and observed date

#### Scenario: Duplicate KAMIS price row is imported

- **GIVEN** the same KAMIS price row was already imported
- **WHEN** the price import runs again
- **THEN** no duplicate `price_snapshots` row is created

#### Scenario: Price unit is unsupported

- **GIVEN** an external price row uses a unit that cannot be mapped
- **WHEN** the price import runs
- **THEN** the row is recorded as an import error
- **AND** the row is not exposed through price APIs

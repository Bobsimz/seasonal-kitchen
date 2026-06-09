## MODIFIED Requirements

### Requirement: Price trend screens are removed from MVP

The product SHALL NOT require a standalone price trend UI for MVP.

#### Scenario: User browses product or information screens

- **GIVEN** the MVP frontend is rendered
- **WHEN** navigation and content sections are shown
- **THEN** no standalone price trend page or tab is required

### Requirement: AI seller price recommendation remains available for seller surfaces

The system SHALL support seller-facing price recommendation using production cost and market context when an approved seller surface requests it.

#### Scenario: Seller price recommendation is displayed

- **GIVEN** seller cost inputs such as seed or cultivar cost, total investment, labor cost, market price, inflation rate, yield or stock volume, and target margin are available
- **WHEN** the seller requests price intelligence during product registration
- **THEN** the system returns a recommended selling price or range
- **AND** the response includes the source date or assumption for market price, inflation, and labor cost inputs
- **AND** the response is distinguishable from the seller's final editable sale price

#### Scenario: Seller price recommendation data is insufficient

- **GIVEN** required cost or market inputs are unavailable
- **WHEN** seller price recommendation is requested
- **THEN** the system returns missing input guidance or a lower-confidence unavailable state
- **AND** does not fabricate cost, wage, inflation, or market values

### Requirement: AI price rise/fall prediction remains available for future surfaces

The system SHALL support AI-assisted price rise/fall prediction when a product, ingredient, or seller workflow has an approved surface for it.

#### Scenario: Prediction is displayed

- **GIVEN** sufficient trusted price data exists
- **WHEN** an approved prediction surface requests price intelligence
- **THEN** the system may return a prediction direction, confidence or explanation, and source date range
- **AND** the prediction must be distinguishable from observed price history

#### Scenario: Prediction data is insufficient

- **GIVEN** insufficient trusted data exists
- **WHEN** prediction is requested
- **THEN** the system returns a safe unavailable state
- **AND** does not fabricate observed or predicted price values

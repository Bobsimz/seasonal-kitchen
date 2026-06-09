## ADDED Requirements

### Requirement: Seller can register a product

The system SHALL support seller-facing product registration for MVP commerce flows.

#### Scenario: Seller submits minimum product fields

- **GIVEN** an authenticated seller provides the minimum required product fields
- **WHEN** the seller creates a product listing
- **THEN** the system stores the listing
- **AND** the listing enters the agreed initial status such as draft, pending review, or published

#### Scenario: Seller edits product before publishing

- **GIVEN** a seller owns a product listing
- **WHEN** the seller updates editable fields
- **THEN** the system persists the changes according to the listing status policy

### Requirement: AI recommends seller product price

The system SHALL support AI price recommendation for sellers using transparent cost and market assumptions.

#### Scenario: Seller requests price recommendation

- **GIVEN** a seller provides pricing inputs such as seed or cultivar cost, total investment, current market price, inflation rate, labor cost, expected yield or stock volume, and desired margin when available
- **WHEN** AI price recommendation is requested
- **THEN** the system returns a recommended price or price range
- **AND** the response explains which inputs and market assumptions were used
- **AND** the seller can edit the final sale price before publishing

#### Scenario: Pricing inputs are incomplete

- **GIVEN** seed cost, investment, market price, inflation, or labor cost inputs are missing
- **WHEN** AI price recommendation is requested
- **THEN** the system returns missing input guidance or a lower-confidence recommendation
- **AND** the system must not present the recommendation as an authoritative market price

### Requirement: AI writes product promotional copy

The system SHALL support AI promotional copy generation for agricultural products once the listing template is agreed.

#### Scenario: Seller requests AI-generated listing content

- **GIVEN** a seller provides factual product inputs such as product name, cultivar, seasonality, sweetness, origin, unit, harvest or freshness information, growing notes, and delivery notes
- **WHEN** AI listing assistance is requested
- **THEN** the system returns editable promotional suggestions such as title, description, tags, selling points, freshness copy, or template sections
- **AND** the response identifies which fields are generated suggestions
- **AND** the seller can review before publishing

#### Scenario: Required factual input is missing

- **GIVEN** a seller requests AI assistance without enough factual product information
- **WHEN** the request is validated
- **THEN** the system asks for or rejects missing factual inputs instead of inventing them

## Open Decisions

- Seller registration template is not finalized.
- Required fields, moderation status, and image upload rules are pending product/design discussion.
- Exact price recommendation formula, market price source, inflation/labor defaults, AI provider, prompt format, and output schema are pending implementation planning.

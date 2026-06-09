## REMOVED Requirements

### Requirement: AI chef is visible as a product-facing page

The product SHALL NOT expose AI chef as an MVP navigation item, button, or standalone page.

#### Scenario: User navigates MVP tabs

- **GIVEN** the user opens the MVP app shell
- **WHEN** bottom tabs, top-level buttons, and page entry points are rendered
- **THEN** no AI chef entry point is displayed

#### Scenario: Existing AI chef UI is still present in code

- **GIVEN** legacy AI chef screens or components still exist
- **WHEN** MVP navigation is configured
- **THEN** those screens are not reachable from visible navigation

## MODIFIED Requirements

### Requirement: AI is limited to commerce support features

AI functionality SHALL be scoped to seller price recommendation, promotional copy generation, and price rise/fall prediction unless a later change reintroduces a consumer-facing assistant.

#### Scenario: Seller requests listing assistance

- **GIVEN** a seller is registering a product
- **WHEN** the seller requests AI assistance
- **THEN** the system may generate price recommendations, editable promotional copy, tags, or suggestions
- **AND** the generated output must not invent stock, origin, cultivar, sweetness, seller identity, or verified certifications

#### Scenario: User views commerce/product experiences

- **GIVEN** a user views product, information, search, or reel screens
- **WHEN** AI features are shown
- **THEN** they are limited to approved seller price recommendation, promotional copy, or price-prediction surfaces

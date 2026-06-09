## ADDED Requirements

### Requirement: Products are distinct from ingredients

The system SHALL model purchasable products separately from ingredient information.

#### Scenario: Product references an ingredient

- **GIVEN** a seller product represents a known ingredient
- **WHEN** the product is stored or returned
- **THEN** it must reference the related `ingredientId`
- **AND** it still has its own product title, price, unit, seller, stock/status, images, origin, and delivery fields

#### Scenario: Product has no exact ingredient match

- **GIVEN** a valid seller product does not map cleanly to an existing ingredient
- **WHEN** the product is registered
- **THEN** the system rejects publication until a valid ingredient mapping is selected or created
- **AND** the product must not be stored as a published product with a null `ingredientId`

### Requirement: Product category follows linked ingredient

The system SHALL derive product category from the linked ingredient category for MVP.

#### Scenario: Product card is returned

- **GIVEN** a product references an ingredient with a category
- **WHEN** the product card is returned
- **THEN** the product category matches the linked ingredient category
- **AND** seller-written title, description, origin, unit, price, and images remain product-specific

### Requirement: Product list is available

The system SHALL provide a product list suitable for the product tab.

#### Scenario: User opens product tab

- **GIVEN** published products exist
- **WHEN** the product list API is requested
- **THEN** the response includes product cards with identity, seller, price, unit, thumbnail, status/badge, and delivery summary fields

### Requirement: Product detail is available

The system SHALL provide a product detail response for a purchasable product.

#### Scenario: User opens product detail

- **GIVEN** a published product exists
- **WHEN** the product detail API is requested
- **THEN** the response includes product identity, seller summary, images, price, unit, stock/status, origin, delivery information, description, and linked ingredient reference
- **AND** the response includes related recipe references based on the linked ingredient when available

#### Scenario: User opens a related recipe from product detail

- **GIVEN** a product detail response includes a related recipe
- **WHEN** the user opens that recipe
- **THEN** the recipe detail can show required recipe ingredients using existing recipe ingredient data

## Open Decisions

- Exact product DTO field names are pending frontend design.
- Review/rating, order count, farm story, and related products are optional until the first product detail design is finalized.
- Cart and checkout persistence are outside this change unless later approved.

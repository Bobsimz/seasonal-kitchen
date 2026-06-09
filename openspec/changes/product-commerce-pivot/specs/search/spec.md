## MODIFIED Requirements

### Requirement: Search includes product category

Unified search SHALL include products as a first-class result category.

#### Scenario: Product matches search query

- **GIVEN** published products match the user's query
- **WHEN** the user searches
- **THEN** the search result includes a product category or product group
- **AND** each product result is distinguishable from ingredient and recipe results

#### Scenario: Query matches both ingredient and product

- **GIVEN** the query matches an ingredient and products related to that ingredient
- **WHEN** the search result is returned
- **THEN** ingredient information and purchasable products are returned in separate categories
- **AND** the API does not collapse product rows into ingredient rows

### Requirement: Search UI can focus on results

Search screens SHALL allow bottom navigation to be removed if the final UI requires a focused result experience.

#### Scenario: Bottom navigation is hidden

- **GIVEN** the search screen is opened
- **WHEN** the design hides bottom navigation
- **THEN** search input, filters, categories, and results remain accessible through the search screen itself

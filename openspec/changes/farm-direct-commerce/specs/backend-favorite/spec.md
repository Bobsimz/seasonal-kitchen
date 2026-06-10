## MODIFIED Requirements

### Requirement: Favorite target types

The favorite system SHALL support `INGREDIENT`, `RECIPE`, and `PRODUCER` target types.

#### Scenario: Favorite a producer
- **GIVEN** an authenticated user and a valid producer id
- **WHEN** the user adds a favorite with target type `PRODUCER`
- **THEN** the system validates the producer exists and stores the favorite

#### Scenario: Favorite an unknown producer
- **GIVEN** an authenticated user and an unknown producer id
- **WHEN** the user adds a `PRODUCER` favorite
- **THEN** the system returns `PRODUCER_NOT_FOUND`

#### Scenario: Wishlist groups by type
- **GIVEN** a user with favorites across types
- **WHEN** the user views the wishlist
- **THEN** favorites can be grouped into producer, ingredient, and recipe tabs

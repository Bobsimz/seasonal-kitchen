## ADDED Requirements

### Requirement: Browse and search producers

The system SHALL provide a producer directory that can be listed and searched.

#### Scenario: List producers
- **GIVEN** seeded producers exist
- **WHEN** a client requests the producer list
- **THEN** the system returns paginated producer cards with name, region, tagline, photo, style, rating, review count, badges, and honorary flag

#### Scenario: Search producers by ingredient
- **GIVEN** a search query naming an ingredient such as 봄동
- **WHEN** the client searches producers with optional `style`, `honorary`, and pageable parameters
- **THEN** the system returns a paginated result of producers whose specialties match the ingredient name and whose filters match

#### Scenario: Filter honorary producers
- **GIVEN** some producers are marked honorary
- **WHEN** the client requests honorary producers
- **THEN** only honorary producers are returned for the best-producer carousel

### Requirement: View producer detail, reviews, and store news

The system SHALL expose a producer's detail, reviews, and store news.

#### Scenario: Get producer detail
- **GIVEN** a valid producer id
- **WHEN** the client requests producer detail
- **THEN** the system returns the producer profile including specialties and badges

#### Scenario: Producer not found
- **GIVEN** an unknown producer id
- **WHEN** the client requests producer detail
- **THEN** the system returns a `PRODUCER_NOT_FOUND` error in the common error format

#### Scenario: Get producer reviews and news
- **GIVEN** a valid producer id
- **WHEN** the client requests reviews or store news
- **THEN** the system returns the producer's reviews (author, rating, date, item, body) or news timeline (date, title, image reference, body)

### Requirement: Compare producers for an ingredient

The system SHALL return producer offers for a given ingredient so the "producer compare" screen can replace retail price comparison.

#### Scenario: Per-ingredient producer offers
- **GIVEN** a valid ingredient id
- **WHEN** the client requests producers for that ingredient
- **THEN** the system returns producer offers with price, unit, and freshness label, ordered by price
- **AND** the lookup uses `producer_offers.ingredient_id` when linked and falls back to the ingredient name while seed backfill is incomplete

## Open Decisions

- Producer identity/auth (admin-seeded vs seller-user-linked) is pending.
- Whether `producer` supersedes `store`/`store_offers` is pending.

## ADDED Requirements

### Requirement: Write producer reviews (MVP free-form)

For the MVP, the system SHALL allow any authenticated user to write a review for an existing producer without
order/delivery eligibility checks. Creating a review SHALL refresh the producer's
`rating` (average) and `review_count` aggregates.

#### Scenario: Submit a review
- **GIVEN** an authenticated user and a valid producer id
- **WHEN** the user submits a star rating and body
- **THEN** the system stores the producer review and returns it in the common response format
- **AND** the producer's `rating` (average) and `review_count` are recomputed from the review rows

#### Scenario: Review an unknown producer
- **GIVEN** an authenticated user and an unknown producer id
- **WHEN** the user submits a review
- **THEN** the system returns `PRODUCER_NOT_FOUND` and stores nothing

### Requirement: View producer reviews and my written reviews

The system SHALL expose a producer's reviews and the authenticated user's written reviews.

#### Scenario: List a producer's reviews
- **GIVEN** a valid producer id
- **WHEN** a client requests the producer's reviews
- **THEN** the system returns reviews with author, rating, item, body, and creation time

#### Scenario: List my written reviews
- **GIVEN** an authenticated user with past producer reviews
- **WHEN** the user requests reviews with `status=written` (default)
- **THEN** the system returns reviews written by that user

## Out of Scope (MVP) / Future

- **Delivered-order review eligibility**: gating reviews to users with a delivered order
  is NOT part of the MVP. Reviews are free-form.
- **Writable reviews**: `status=writable` (derive reviewable items from delivered orders)
  is a future enhancement. The endpoint accepts the parameter but returns an empty list in MVP.
- **Review edit/delete**: `PATCH`/`DELETE /api/v1/reviews/{reviewId}` are future work.

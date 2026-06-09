## ADDED Requirements

### Requirement: User has lifestyle consumption preferences

The system SHALL support user lifestyle or consumption preference data for future personalization and farm-product matching.

#### Scenario: User saves consumption preferences

- **GIVEN** an authenticated user selects consumption preferences such as freshness priority, low-price preference, local/farm-direct preference, eco/organic preference, or cooking frequency
- **WHEN** the user preference API is updated
- **THEN** the preferences are persisted with the user's profile or preference record

#### Scenario: Preferences are unavailable

- **GIVEN** a user has not set lifestyle preferences
- **WHEN** product or information recommendations are generated
- **THEN** the system uses safe defaults
- **AND** does not block normal browsing

## Open Decisions

- Exact preference labels and scoring values are pending persona discussion.
- Whether preferences are collected during onboarding, my page, or seller/product flows is pending frontend planning.

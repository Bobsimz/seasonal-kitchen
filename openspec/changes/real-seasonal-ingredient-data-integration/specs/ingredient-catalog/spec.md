## MODIFIED Requirements

### Requirement: Ingredient responses expose real seasonal state

Ingredient card and detail responses SHALL derive seasonal state from persisted seasonal data when available instead of relying only on demo seed heuristics or placeholders.

#### Scenario: Current month has seasonal data

- **GIVEN** an ingredient has a seasonal row for the current month
- **WHEN** `GET /api/v1/ingredients` or `GET /api/v1/ingredients/{ingredientId}` is requested
- **THEN** the response includes `seasonal=true`
- **AND** includes season score/month information where the DTO supports it

#### Scenario: Seasonal data is missing

- **GIVEN** an ingredient has no seasonal rows
- **WHEN** ingredient APIs are requested
- **THEN** the response remains backward compatible
- **AND** missing seasonal values are represented as false, null, or empty collections

## MODIFIED Requirements

### Requirement: Ingredient and recipe content belongs to information tab

Existing ingredient and recipe discovery SHALL be treated as information content rather than purchasable product content.

#### Scenario: User opens information tab

- **GIVEN** ingredient and recipe APIs are available
- **WHEN** the user opens the information tab
- **THEN** ingredient and recipe content can be displayed using existing information APIs

#### Scenario: Ingredient and product both exist for same food

- **GIVEN** an ingredient such as `감자` exists
- **AND** purchasable potato products exist
- **WHEN** the user navigates information content
- **THEN** the ingredient page presents normalized food information
- **AND** product listings remain separate product records

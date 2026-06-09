## MODIFIED Requirements

### Requirement: MVP tabs separate products from information

The frontend SHALL separate purchasable products from ingredient/recipe information.

#### Scenario: Product tab is shown

- **GIVEN** the user sees the bottom navigation
- **WHEN** the MVP tab set is rendered
- **THEN** the previous exploration tab is represented as a product tab
- **AND** the product tab focuses on purchasable product discovery

#### Scenario: Information tab is shown

- **GIVEN** the user sees the bottom navigation
- **WHEN** the MVP tab set is rendered
- **THEN** an information tab is available
- **AND** the information tab contains existing ingredient and recipe content

### Requirement: Header icons are standardized

The frontend SHALL use consistent header actions across MVP screens.

#### Scenario: Standard screen header is rendered

- **GIVEN** a non-reels MVP screen has a header
- **WHEN** the header actions are rendered
- **THEN** the right side shows search and cart actions
- **AND** notification action is not shown in the MVP header

#### Scenario: Reels header is rendered

- **GIVEN** the reels screen has a header action area
- **WHEN** the header actions are rendered
- **THEN** only the search action is shown on the right side

#### Scenario: Product tab replaces embedded search bar

- **GIVEN** the product tab is displayed
- **WHEN** the page header is rendered
- **THEN** an embedded exploration search bar is not shown
- **AND** navigation uses the standardized search icon
- **AND** a back action is available where the screen hierarchy requires it

### Requirement: Search screen bottom navigation is optional

The frontend SHALL allow bottom navigation to be hidden on search screens if it interferes with search usability.

#### Scenario: Search screen design requires focus

- **GIVEN** the search screen layout is being implemented
- **WHEN** bottom navigation reduces search result usability
- **THEN** the bottom navigation may be hidden on that screen

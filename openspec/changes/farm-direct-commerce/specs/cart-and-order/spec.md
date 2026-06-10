## ADDED Requirements

### Requirement: Manage a cart grouped by producer

The system SHALL maintain a user cart whose items are grouped by producer with per-producer shipping.

#### Scenario: Add item to cart by offer id
- **GIVEN** an authenticated user and a valid `offerId` (producer offer) plus a quantity
- **WHEN** the user adds an item
- **THEN** the system looks up the offer by id and stores producer, ingredient, unit price, and unit as an order-time snapshot taken from the offer (not from client input)
- **AND** returns the cart grouped by producer with per-group shipping and a payment total

#### Scenario: Add an unknown offer
- **GIVEN** an authenticated user and an `offerId` that does not exist
- **WHEN** the user adds an item
- **THEN** the system returns `PRODUCER_OFFER_NOT_FOUND` and creates no cart item (no zero-price fallback)

#### Scenario: Add the same offer twice
- **GIVEN** an authenticated user who already has the offer in their cart
- **WHEN** the user adds the same `offerId` again
- **THEN** the system increases the existing item's quantity instead of creating a duplicate row

#### Scenario: Update or remove cart item
- **GIVEN** an authenticated user with an existing cart item
- **WHEN** the user changes quantity or removes the item
- **THEN** the system persists the change and recomputes group shipping and total

#### Scenario: Free shipping threshold
- **GIVEN** a producer group subtotal meets the free-shipping threshold
- **WHEN** the cart total is computed
- **THEN** that group's shipping fee is waived

### Requirement: Place and view orders

The system SHALL create orders from the cart and expose order history and detail.

#### Scenario: Create order from cart
- **GIVEN** an authenticated user with a non-empty cart
- **WHEN** the user places an order
- **THEN** the system creates an order with an order number, payment total, shipping fee, and earned points
- **AND** returns the order detail for the order-complete screen

#### Scenario: List and view orders
- **GIVEN** an authenticated user with past orders
- **WHEN** the user requests order history or a specific order
- **THEN** the system returns order summaries or the order detail including delivery status

## Open Decisions

- Cart persistence (backend vs frontend-local) is pending.
- Payment/PG scope is pending; MVP may use a mock order without real payment.

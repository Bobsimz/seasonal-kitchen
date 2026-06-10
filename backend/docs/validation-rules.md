# Validation Rules

## Common

- IDs must be positive numbers.
- Page number must be zero or greater.
- Page size must be between 1 and 100.
- Date/time values must use ISO 8601.
- Money values must be numeric and zero or greater unless otherwise stated.

## User

### User Preference

- `householdSize` must be between 1 and 10.
- `budget` must be zero or greater.
- `priority` must be one of the supported preference priorities when used for personalization.

## Ingredient

- `name` is required.
- `name` must be unique among active ingredients.
- `category` is required.
- `baseUnit` is required.
- `active` defaults to true.

## Ingredient Alias

- `ingredientId` is required.
- `source` is required.
- `externalCode` is required when the source provides a code.
- `externalName` is required.
- The same `source + externalCode` pair must not map to multiple ingredients.

## Seasonal Ingredient

- `ingredientId` is required.
- `month` must be between 1 and 12.
- `regionCode` may be nullable for nationwide seasonality.
- `score` must be between 0 and 100.

## Price Snapshot

- `ingredientId` is required.
- `source` is required.
- `priceType` is required.
- `price` must be positive.
- `unit` is required.
- `observedDate` is required.
- Price snapshots are append-only. Do not overwrite historical prices.

## Store

- `name` is required.
- `storeType` is required.
- `externalUrl` must be a valid URL when provided.
- `regionCode` may be nullable for online stores.

## Store Offer

- `storeId` is required.
- `ingredientId` is required.
- `price` must be positive.
- `unit` is required.
- `productUrl` must be a valid URL when provided.
- `observedAt` is required.

## Recipe

- `title` is required.
- `difficulty` must be one of the supported enum values.
- `minutes` must be positive.
- `servings` must be positive.
- `status` is required.

## Recipe Ingredient

- `recipeId` is required.
- `ingredientId` is required.
- `quantity` must be positive when provided.
- `unit` is required when `quantity` is provided.
- `optional` defaults to false.

## Reel

- `recipeId` is required when the reel is recipe-based.
- `creatorId` is required.
- `videoUrl` is required.
- `thumbnailUrl` is required.
- `status` is required.
- `publishedAt` is required when status is published.

## Product

- `ingredientId` is required.
- Product category must be derived from the linked ingredient.
- `title` is required.
- `price` must be positive.
- `unit` is required.
- `stockQuantity` must be zero or greater when provided.
- Seller-written descriptions must not overwrite ingredient master data.

## Seller AI

- Price recommendation inputs must distinguish seller-provided costs from market or public data assumptions.
- AI promotional copy must be editable before publishing.
- AI must not invent stock, origin, cultivar, sweetness, certification, seller identity, market price, wage, or inflation values.

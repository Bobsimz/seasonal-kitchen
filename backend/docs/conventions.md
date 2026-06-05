# Conventions

## Java

- Use constructor injection.
- Do not use field injection.
- Use `record` for simple request/response DTOs.
- Use classes for DTOs only when mutation, inheritance, or framework constraints require it.
- Use `@Transactional(readOnly = true)` for read services.
- Use `@Transactional` for write services.
- Do not return JPA entities from controllers.
- Do not put business logic in controllers.
- Do not use Lombok unless the project already uses it.

## Package Dependency Direction

Allowed direction:

```text
controller -> service -> repository -> entity
controller -> dto
service -> dto
service -> infrastructure client
```

Disallowed direction:

```text
repository -> service
entity -> controller/service/dto
common -> domain package
```

## Domain Package Structure

```text
src/main/java/com/seasonaldining/{domain}/
  controller/
  service/
  repository/
  entity/
  dto/
    request/
    response/
```

Example:

```text
src/main/java/com/seasonaldining/ingredient/
  controller/IngredientController.java
  service/IngredientService.java
  repository/IngredientRepository.java
  entity/Ingredient.java
  dto/response/IngredientCardResponse.java
```

## Naming

### DTO

- Create request: `CreateIngredientRequest`
- Update request: `UpdateUserPreferenceRequest`
- List response item: `IngredientCardResponse`
- Detail response: `IngredientDetailResponse`
- Summary response: `PriceSummaryResponse`

### Exception Code

Use upper snake case.

Examples:

- `INGREDIENT_NOT_FOUND`
- `INVALID_PRICE_UNIT`
- `COMMON_INVALID_REQUEST`

### Test

- Unit test: `{ClassName}Test`
- Integration test: `{FeatureName}IntegrationTest`
- Controller test: `{ControllerName}Test`

## Controller Rules

- Controller method names should describe API behavior.
- Use `ResponseEntity` only when status/header control is needed.
- Keep controller logic limited to validation boundary and service delegation.
- All controller responses should be wrapped in the common API response unless the project explicitly chooses otherwise.

## Service Rules

- One public service method should represent one use case.
- Read methods should use `@Transactional(readOnly = true)`.
- Write methods should use `@Transactional`.
- Throw domain-specific exceptions instead of returning `null`.

## Repository Rules

- Use Spring Data JPA repository interfaces for simple queries.
- Add custom repository/query logic only when query complexity requires it.
- Avoid N+1 by designing explicit fetch strategies.

## Migration Rules

- Use Flyway migration files.
- File naming format:

```text
V{number}__{description}.sql
```

Examples:

```text
V1__create_users.sql
V2__create_ingredients.sql
V3__create_price_snapshots.sql
```

## Swagger Rules

- Add `@Tag` to controllers.
- Add `@Operation` to API methods.
- Add `@Schema` to request/response DTO fields.
- Declare enum descriptions clearly.
- Declare nullable fields clearly.

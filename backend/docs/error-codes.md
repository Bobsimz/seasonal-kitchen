# Error Codes

All error responses must follow the common error response format defined in `docs/03-api-contract.md`.

## Common

| Code | HTTP Status | Message |
| --- | ---: | --- |
| `COMMON_INVALID_REQUEST` | 400 | 잘못된 요청입니다. |
| `COMMON_VALIDATION_FAILED` | 400 | 요청 값 검증에 실패했습니다. |
| `COMMON_UNAUTHORIZED` | 401 | 인증이 필요합니다. |
| `COMMON_FORBIDDEN` | 403 | 권한이 없습니다. |
| `COMMON_NOT_FOUND` | 404 | 요청한 리소스를 찾을 수 없습니다. |
| `COMMON_CONFLICT` | 409 | 이미 존재하거나 충돌하는 데이터입니다. |
| `COMMON_INTERNAL_ERROR` | 500 | 서버 오류가 발생했습니다. |
| `COMMON_EXTERNAL_API_ERROR` | 502 | 외부 API 호출에 실패했습니다. |
| `COMMON_TIMEOUT` | 504 | 요청 시간이 초과되었습니다. |

## Auth

| Code | HTTP Status | Message | 상태 |
| --- | ---: | --- | --- |
| `AUTH_EMAIL_DUPLICATE` | 409 | 이미 가입된 이메일입니다. | 구현 |
| `AUTH_NICKNAME_DUPLICATE` | 409 | 이미 사용 중인 닉네임입니다. | 구현 |
| `AUTH_INVALID_CREDENTIALS` | 401 | 이메일 또는 비밀번호가 올바르지 않습니다. | 구현 |
| `AUTH_INVALID_TOKEN` | 401 | 유효하지 않은 토큰입니다. | 구현 |
| `AUTH_EXPIRED_TOKEN` | 401 | 만료된 토큰입니다. | future |
| `AUTH_REVOKED_REFRESH_TOKEN` | 401 | 폐기된 refresh token입니다. | future |
| `AUTH_UNSUPPORTED_PROVIDER` | 400 | 지원하지 않는 로그인 제공자입니다. | future(OAuth) |

## User

| Code | HTTP Status | Message |
| --- | ---: | --- |
| `USER_NOT_FOUND` | 404 | 사용자를 찾을 수 없습니다. |
| `USER_NICKNAME_DUPLICATED` | 409 | 이미 사용 중인 닉네임입니다. |
| `USER_PREFERENCE_NOT_FOUND` | 404 | 사용자 추천 설정을 찾을 수 없습니다. |
| `PANTRY_ITEM_NOT_FOUND` | 404 | 보유 재료를 찾을 수 없습니다. |

## Ingredient / Season / Price / Store

| Code | HTTP Status | Message |
| --- | ---: | --- |
| `INGREDIENT_NOT_FOUND` | 404 | 식재료를 찾을 수 없습니다. |
| `INGREDIENT_ALIAS_NOT_FOUND` | 404 | 식재료 별칭을 찾을 수 없습니다. |
| `SEASONAL_INGREDIENT_NOT_FOUND` | 404 | 제철 정보를 찾을 수 없습니다. |
| `PRICE_SNAPSHOT_NOT_FOUND` | 404 | 가격 데이터를 찾을 수 없습니다. |
| `INVALID_PRICE_UNIT` | 400 | 지원하지 않는 가격 단위입니다. |
| `STORE_NOT_FOUND` | 404 | 구매처를 찾을 수 없습니다. |
| `STORE_OFFER_NOT_FOUND` | 404 | 구매처 상품 정보를 찾을 수 없습니다. |

## Recipe / Reel / Creator

| Code | HTTP Status | Message |
| --- | ---: | --- |
| `RECIPE_NOT_FOUND` | 404 | 레시피를 찾을 수 없습니다. |
| `RECIPE_STEP_NOT_FOUND` | 404 | 조리 단계를 찾을 수 없습니다. |
| `REEL_NOT_FOUND` | 404 | 릴스를 찾을 수 없습니다. |
| `REEL_COMMENT_NOT_FOUND` | 404 | 릴스 댓글을 찾을 수 없습니다. |
| `CREATOR_NOT_FOUND` | 404 | 크리에이터를 찾을 수 없습니다. |
| `CREATOR_APPLICATION_ALREADY_EXISTS` | 409 | 이미 크리에이터 신청이 존재합니다. |

## Favorite / Notification / Product

| Code | HTTP Status | Message |
| --- | ---: | --- |
| `FAVORITE_NOT_FOUND` | 404 | 찜 정보를 찾을 수 없습니다. |
| `PRICE_ALERT_NOT_FOUND` | 404 | 가격 알림을 찾을 수 없습니다. |
| `NOTIFICATION_NOT_FOUND` | 404 | 알림을 찾을 수 없습니다. |
| `PRODUCT_NOT_FOUND` | 404 | 상품을 찾을 수 없습니다. |
| `PRODUCT_INGREDIENT_REQUIRED` | 400 | 상품은 연결된 식재료가 필요합니다. |
| `SELLER_PRODUCT_NOT_FOUND` | 404 | 판매자 상품을 찾을 수 없습니다. |
| `SELLER_AI_PRICE_INPUT_REQUIRED` | 400 | 가격 추천에 필요한 입력값이 부족합니다. |
| `SELLER_AI_COPY_INPUT_REQUIRED` | 400 | 홍보글 작성에 필요한 상품 정보가 부족합니다. |

## Producer / Cart / Order (farm-direct-commerce)

| Code | HTTP Status | Message |
| --- | ---: | --- |
| `PRODUCER_NOT_FOUND` | 404 | 농가를 찾을 수 없습니다. |
| `PRODUCER_OFFER_NOT_FOUND` | 404 | 농가 판매 상품을 찾을 수 없습니다. |
| `CART_ITEM_NOT_FOUND` | 404 | 장바구니 항목을 찾을 수 없습니다. |
| `ORDER_NOT_FOUND` | 404 | 주문을 찾을 수 없습니다. |

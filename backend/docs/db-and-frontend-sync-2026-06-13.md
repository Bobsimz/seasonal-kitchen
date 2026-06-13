# 프론트엔드 기준 백엔드·DB 싱크 정리 (2026-06-13)

프론트엔드(`frontend/lib/api.js` + 각 페이지가 실제로 읽는 JSON 키, `frontend/lib/mock/data.js`가 권위 계약)를
**source of truth**로 삼아 백엔드 응답/요청 계약과 DB를 점검하고 동기화했다.

> 프론트는 `withFallback`로 **연결오류/5xx만 mock 폴백**하고 **4xx(400/404)는 그대로 노출**한다.
> 즉 ① 라우트 누락·검증실패(4xx)는 화면이 깨지고 ② 500은 폴백에 가려져도 *실서버가 깨진 것*이다.
> 따라서 "필드명만 달라 200이지만 빈칸으로 렌더되는" 불일치까지 모두 프론트 계약에 맞춰 수정했다.

---

## 1. DB에 "추가해야 할 컬럼" — 결론: **신규 스키마 컬럼은 사실상 필요 없음**

프론트가 요구하는 필드는 전부 다음 중 하나로 충족된다.
- **기존 컬럼을 DTO로 노출/리네임** (예: `notifications.read_at` → 응답 `read` 불리언, `producer_news.posted_at` → `date`)
- **조회 시점 조인/파생** (예: 장바구니 썸네일 `imageUrl`은 `offer_photos`/`producers.photo_url`에서 조인, 가격알림 `currentPrice`는 최신 `price_snapshots`에서 파생)

그래서 **테이블에 새 컬럼을 ALTER로 추가한 건 없다.** 추가한 마이그레이션은 아래 1건(데이터 백필)뿐이다.

| 마이그레이션 | 종류 | 내용 |
| --- | --- | --- |
| `V39__backfill_offer_category.sql` | **데이터 백필**(스키마 변경 아님) | 시드된 `producer_offers.category`가 전부 NULL이라 상품탭 카테고리 칩이 '전체'만 떴음 → 식재료명 기준 분류(잎채소/뿌리채소/…)로 백필. `WHERE category IS NULL` 멱등. |

> ⚠️ **버전 번호 주의**: 이 백필은 처음 `V37`로 작성했으나, 머지된 팀원 작업이 이미 `V37__recipe_ingredient_freetext_name.sql`을 점유해 **Flyway 버전 충돌(중복 V37)** 이 발생했다(빌드/기동/통합테스트 전부 실패). 그래서 **`V39`로 재번호**했다. 현재 순서: V37(freetext name) → V38(seed_recipes) → V39(backfill_category). 새 마이그레이션 추가 시 최신 번호를 먼저 확인할 것.

### 참고: "있으면 더 좋은" 컬럼 (필수 아님, 후속 과제)
지금은 조인/파생으로 처리했지만, 성능·스냅샷 정합성을 위해 훗날 추가를 고려할 수 있는 항목.

| 테이블 | 후보 컬럼 | 왜 지금은 불필요한가 |
| --- | --- | --- |
| `cart_items` | `image_url` (스냅샷) | 현재는 `offer_photos`/`producers.photo_url`에서 읽기 시점 조인. 주문 시점 이미지 고정이 필요해지면 스냅샷 컬럼 검토. |
| `price_alerts` | `current_price` 등 | 최신 `price_snapshots`에서 파생. 알림 발송 시점 가격 고정이 필요하면 검토. |
| (신규) `ingredient_seasons` | 제철 월(months) | 백엔드에 **제철 데이터 소스가 없음**(아래 §4). `seasonal`/`seasonMonths`를 실제로 채우려면 별도 테이블/시드 필요. |

---

## 2. 수정한 계약 불일치 (프론트 기준 백엔드 개선)

### BLOCKER — 실서버에서 화면/플로우가 깨지던 것
| 엔드포인트 | 증상(수정 전) | 수정 |
| --- | --- | --- |
| `GET /products` | **HTTP 500** `function lower(bytea) does not exist`. Postgres가 null 파라미터를 bytea로 추론. | `ProducerOfferRepository.searchProducts`의 `:q`/`:region`을 `cast(... as string)`로 명시 타입화. `/search?type=PRODUCT`도 함께 해결. |
| `GET /users/me/summary` | 응답 shape 전면 불일치(`profile`/`menuRows`/`personalizedIngredients`) → 마이페이지 통계·뱃지·추천 캐러셀 전부 빈값/미표시. | `{user, stats{savedAmount,orderCount,reviewCount}, counts{orders,favorites,priceAlerts,reviews}, personalized[]}`로 재구성. orderCount/reviewCount/favorites/alerts 실제 집계. |
| `PUT /users/me/preferences` | 설문 바디(`household/lifestyles/spicyAvoid/allergens`)가 DTO 필수값(`householdSize/priority`)과 불일치 → **400**, 설문이 조용히 저장 안 됨. | DTO 검증 완화 + 프론트 필드 수용, 서버에서 `householdSize`(‘2인’→2)/`priority`/`allergyCodes` 파생. |
| `POST /producers/me` | 농가 등록 바디가 필수값(`representativeName/contact/certificationImageUrl/agreedToTerms`)을 안 보냄 → **400**, 등록 항상 실패. | 해당 필드 선택값화, `style/priceLevel/freshnessLevel/tagline/specialties/badges`를 수용·반영. 구버전 7-arg 편의 생성자로 기존 테스트 호환. |
| `POST /producers/me/offers` | 필수값(`certifications/storageMethod`) 누락 → **400**, 상품 등록 항상 실패. | 두 필드 선택값화. |
| `POST /favorites {PRODUCT}` | `validateTarget`이 PRODUCT 미지원 → **404**, 상품 찜 불가. | `PRODUCT`/`OFFER` 분기 추가(`producer_offers` ACTIVE 검증). |
| `GET /producers/me` | 미등록 사용자에 **404** → 셀러 페이지가 등록 폼 대신 에러 화면. | 미등록 시 **200 + `data:null`** 반환(다른 `/me/*`는 등록 후에만 호출되므로 유지). |

### MISMATCH — 200이지만 필드명/형태가 달라 빈칸/오작동하던 것 (프론트 키에 맞춤)
| 도메인 | 수정 |
| --- | --- |
| 식재료 카드/상세 | `currentPrice/unit/priceChangePct/trendDirection/priceChangeLabel/hot/seasonMonths`를 **flat 필드로 노출**하고 `price_snapshots`에서 채움. `storageTips` 객체→`string[]`. `buyingSignal` `GOOD/HOLD/HIGH`. 이력 1개라 변동률 계산 불가하면 중립(보합/HOLD) 표기. |
| 홈 히어로 | 카드 가격이 채워지며 `priceLabel/trendLabel` 자동 생성. |
| 검색 | `ingredients[]`/`recipes[]`를 풀 카드(IngredientCard/RecipeCard) 형태로 반환(기존 flat `items`는 유지). |
| 레시피 | `minutes→cookMinutes`, `likeCount→likes`, `estimatedTotal→estimatedCost`, 스텝 `description→text`(+`order`), 재료 `name/amount/price/imageUrl` 별칭, `relatedReelIds` 추가. |
| 릴스 | `ingredientTags→ingredients`, `likeCount→likes`, `commentCount→comments`, `saveCount→saves`, `viewCount→views`, `creatorAvatarUrl→creatorAvatar`, `description→caption`. |
| 농가 | 오퍼 `producerPhotoUrl→photoUrl`. 소식 `postedAt→date`(yyyy.MM.dd) + `imageRef→imageUrl`(키워드 ref는 null). |
| 알림 | `type`을 `PRICE/ORDER/COMMUNITY` 버킷으로 매핑(+`rawType`), `read` 불리언 추가, `tabCounts` 키 `ALL/PRICE/ORDER/COMMUNITY`. |
| 가격알림 | `currentPrice/unit/imageUrl` 추가(식재료 + 최신 스냅샷에서 파생). |
| 장바구니 | `Item.imageUrl` 추가(오퍼 대표사진/농가사진 조인). |

---

## 3. 데이터/시드 갭 (스키마 아님 — 백필로 보완 가능)

| 대상 | 현 상태 | 영향 | 권고 |
| --- | --- | --- | --- |
| `producer_offers.category` | 시드 전부 NULL | 상품탭 카테고리 칩 미동작 | **V37로 백필 완료** |
| `producers.photo_url` | V14 시드에서 비어있음 | 농가/오퍼 대표사진 빈값(프론트 플레이스홀더 폴백) | 실제 이미지 URL 확보 후 백필(후속) |
| `price_snapshots` | 대부분 식재료당 1행(이력 없음) | 주간 변동률·추세 % 계산 불가(중립 표기로 대체) | 가격 이력 적재(openspec `real-seasonal-ingredient-data-integration`) |
| CURATED 식재료(V31) | `ingredient_storage_tips`/`nutrition` 미시드 | 식재료 상세 손질·보관·영양 섹션 빈값 | 손질/보관/영양 시드 추가(후속) |
| `reels.recipe_id`, `creators.avatar_url` | V32에서 NULL | 릴스 ‘레시피 보기’ 핀·작성자 아바타 빈값 | 백필(후속) |

---

## 4. 잔여 권고사항 (이번 변경 범위 밖, 별도 판단 필요)

- ~~**운영(supabase) 프로필 레시피 시드 없음**~~ → **해결됨**: 머지된 팀원 작업 `V38__seed_recipes.sql`이 레시피 233건 + 스텝 + 재료(비농산물 free-text 포함)를 Flyway로 시드하고 릴스 `recipe_id`도 연결한다. 이제 모든 프로필에서 `GET /recipes/{id}`가 동작한다. (관련: 비농산물 재료용 `recipe_ingredients.name` 컬럼은 `V37__recipe_ingredient_freetext_name.sql`에서 추가.)
- **제철(seasonal/seasonMonths) 데이터 소스 부재**: 현재 백엔드에 제철 월 정보가 없어 `seasonal=false`로 나간다. 제철 배지를 살리려면 `ingredient_seasons` 류 데이터가 필요.
- **미사용(데드) 프론트 엔드포인트**: `getMe`/`getRecentSearches`/`getReel`/리뷰목록/가격알림 CRUD 등은 정의돼 있으나 호출 페이지가 없다(현재 무해). 추후 연결 시 형태 재검증 필요(문서 §의 INFO 항목 참고).

---

## 5. 검증

- `./gradlew compileJava` / `compileTestJava` **BUILD SUCCESSFUL**.
- 로컬 기동(`SPRING_PROFILES_ACTIVE=local`) 후 전 엔드포인트 스모크: 공개/인증 GET **전부 200**, 쓰기 경로(preferences/favorite PRODUCT/producer register·offer) **전부 2xx**.
- 응답 shape 확인: 마이페이지 `user/stats/counts/personalized`, 알림 `type∈{PRICE,ORDER,COMMUNITY}`·`read`·`tabCounts`, 가격알림 `currentPrice/unit/imageUrl`, 상품 `category` 칩(잎채소 8건) 등 프론트 키와 일치.

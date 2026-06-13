-- V59: 제철 큐레이션 시드 2건 (마늘쫑 · 햇감자) — V56 컨벤션 그대로.
-- 마늘쫑: V58에서 추가한 식재료/레시피 기반(유행 후킹). 햇감자: 기존 '감자'(id 보유) 기반.
-- 관련 식재료는 이름으로, 관련 레시피는 해당 식재료를 쓰는 레시피(recipe_ingredients)로 연결.
-- 메인 이미지는 대표 레시피 썸네일(없으면 식재료 이미지)로 채운다 — 상대/절대 key 혼용, 응답 시 CDN 결합.
-- H2(PostgreSQL 모드) + 실 Postgres 호환(LATERAL/VALUES 별칭 없이). 모든 INSERT는 NOT EXISTS 가드로 idempotent.

-- ── 큐레이션 본문 2건 ──────────────────────────────────────────────
-- 마늘쫑 (display_order 4)
INSERT INTO curations (main_title, subtitle, seasonal_story, main_image_url, display_order, active)
SELECT
    '마늘쫑, SNS가 주목한 제철 한 그릇',
    '아삭한 햇마늘쫑으로 만드는 올여름 유행 비빔밥',
    '마늘쫑은 마늘이 굵어지기 전 늦봄에서 초여름 사이 잠깐 올라오는 꽃대로, 1년 중 딱 이맘때만 아삭하고 연한 식감을 즐길 수 있는 한철 채소예요. 요즘 SNS에서는 송송 썬 마늘쫑을 듬뿍 올려 고추장에 비벼 먹는 ''마늘쫑 비빔밥''이 화제인데, 생마늘보다 매운맛이 부드러워 누구나 부담 없이 즐길 수 있어요. 살짝 볶거나 데치면 단맛이 올라와 비빔밥은 물론 새우볶음·장아찌·된장무침까지 두루 어울립니다. 제철 막바지에 접어들며 가격도 내려간 지금이, 마늘쫑을 가장 알뜰하게 맛볼 적기랍니다.',
    COALESCE(
        (SELECT r.image_url FROM recipes r
            JOIN recipe_ingredients ri ON ri.recipe_id = r.id
            JOIN ingredients i ON i.id = ri.ingredient_id
            WHERE i.name = '마늘쫑' AND r.status = 'PUBLISHED' AND r.image_url IS NOT NULL
            ORDER BY r.id LIMIT 1),
        (SELECT image_url FROM ingredients WHERE name = '마늘쫑' AND image_url IS NOT NULL ORDER BY id LIMIT 1)
    ),
    4, TRUE
WHERE NOT EXISTS (SELECT 1 FROM curations WHERE main_title = '마늘쫑, SNS가 주목한 제철 한 그릇');

-- 햇감자 (display_order 5)
INSERT INTO curations (main_title, subtitle, seasonal_story, main_image_url, display_order, active)
SELECT
    '햇감자, 지금이 가장 맛있는 첫 감자',
    '포슬포슬 갓 캔 6월의 노지 햇감자',
    '6월에서 7월은 노지에서 갓 캐낸 햇감자가 쏟아지는 시기예요. 오래 저장한 감자와 달리 수분이 많아 껍질이 얇고, 삶으면 포슬포슬하면서도 촉촉한 첫 감자만의 식감을 맛볼 수 있어요. 껍질이 얇아 살살 문질러 씻으면 껍질째 조리해도 좋고, 버터에 굴린 알감자조림이나 통째로 찐 감자처럼 단순할수록 본연의 단맛이 살아납니다. 출하가 몰리는 제철이라 가격 부담도 가장 낮은 때이니, 알이 단단하고 싹이 트지 않은 것을 골라 감자조림·감자채볶음·감자전까지 다양하게 즐겨보세요.',
    COALESCE(
        (SELECT r.image_url FROM recipes r
            JOIN recipe_ingredients ri ON ri.recipe_id = r.id
            JOIN ingredients i ON i.id = ri.ingredient_id
            WHERE i.name = '감자' AND r.status = 'PUBLISHED' AND r.image_url IS NOT NULL
            ORDER BY r.id LIMIT 1),
        (SELECT image_url FROM ingredients WHERE name = '감자' AND image_url IS NOT NULL ORDER BY id LIMIT 1)
    ),
    5, TRUE
WHERE NOT EXISTS (SELECT 1 FROM curations WHERE main_title = '햇감자, 지금이 가장 맛있는 첫 감자');

-- ── 관련 식재료 ───────────────────────────────────────────────────
-- 마늘쫑 큐레이션
INSERT INTO curation_ingredients (curation_id, ingredient_id, sort_order)
SELECT c.id, i.id, 0 FROM curations c, ingredients i
WHERE c.main_title = '마늘쫑, SNS가 주목한 제철 한 그릇' AND i.name = '마늘쫑'
AND NOT EXISTS (SELECT 1 FROM curation_ingredients ci WHERE ci.curation_id = c.id AND ci.ingredient_id = i.id);
INSERT INTO curation_ingredients (curation_id, ingredient_id, sort_order)
SELECT c.id, i.id, 1 FROM curations c, ingredients i
WHERE c.main_title = '마늘쫑, SNS가 주목한 제철 한 그릇' AND i.name = '부추'
AND NOT EXISTS (SELECT 1 FROM curation_ingredients ci WHERE ci.curation_id = c.id AND ci.ingredient_id = i.id);
INSERT INTO curation_ingredients (curation_id, ingredient_id, sort_order)
SELECT c.id, i.id, 2 FROM curations c, ingredients i
WHERE c.main_title = '마늘쫑, SNS가 주목한 제철 한 그릇' AND i.name = '양파'
AND NOT EXISTS (SELECT 1 FROM curation_ingredients ci WHERE ci.curation_id = c.id AND ci.ingredient_id = i.id);

-- 햇감자 큐레이션
INSERT INTO curation_ingredients (curation_id, ingredient_id, sort_order)
SELECT c.id, i.id, 0 FROM curations c, ingredients i
WHERE c.main_title = '햇감자, 지금이 가장 맛있는 첫 감자' AND i.name = '감자'
AND NOT EXISTS (SELECT 1 FROM curation_ingredients ci WHERE ci.curation_id = c.id AND ci.ingredient_id = i.id);
INSERT INTO curation_ingredients (curation_id, ingredient_id, sort_order)
SELECT c.id, i.id, 1 FROM curations c, ingredients i
WHERE c.main_title = '햇감자, 지금이 가장 맛있는 첫 감자' AND i.name = '양파'
AND NOT EXISTS (SELECT 1 FROM curation_ingredients ci WHERE ci.curation_id = c.id AND ci.ingredient_id = i.id);
INSERT INTO curation_ingredients (curation_id, ingredient_id, sort_order)
SELECT c.id, i.id, 2 FROM curations c, ingredients i
WHERE c.main_title = '햇감자, 지금이 가장 맛있는 첫 감자' AND i.name = '당근'
AND NOT EXISTS (SELECT 1 FROM curation_ingredients ci WHERE ci.curation_id = c.id AND ci.ingredient_id = i.id);

-- ── 관련 레시피 (메인 식재료를 쓰는 레시피, 큐레이션당 최대 8건, id 순) ──────
-- 마늘쫑 큐레이션 (마늘쫑 레시피 5건)
INSERT INTO curation_recipes (curation_id, recipe_id, sort_order)
SELECT (SELECT id FROM curations WHERE main_title = '마늘쫑, SNS가 주목한 제철 한 그릇'), ranked.recipe_id, ranked.rn - 1
FROM (
    SELECT r.id AS recipe_id, ROW_NUMBER() OVER (ORDER BY r.id) AS rn
    FROM recipes r
    JOIN recipe_ingredients ri ON ri.recipe_id = r.id
    JOIN ingredients i ON i.id = ri.ingredient_id
    WHERE i.name = '마늘쫑' AND r.status = 'PUBLISHED'
    GROUP BY r.id
) ranked
WHERE ranked.rn <= 8
  AND (SELECT id FROM curations WHERE main_title = '마늘쫑, SNS가 주목한 제철 한 그릇') IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM curation_recipes cr
      WHERE cr.curation_id = (SELECT id FROM curations WHERE main_title = '마늘쫑, SNS가 주목한 제철 한 그릇')
        AND cr.recipe_id = ranked.recipe_id
  );

-- 햇감자 큐레이션 (감자 레시피 상위 8건)
INSERT INTO curation_recipes (curation_id, recipe_id, sort_order)
SELECT (SELECT id FROM curations WHERE main_title = '햇감자, 지금이 가장 맛있는 첫 감자'), ranked.recipe_id, ranked.rn - 1
FROM (
    SELECT r.id AS recipe_id, ROW_NUMBER() OVER (ORDER BY r.id) AS rn
    FROM recipes r
    JOIN recipe_ingredients ri ON ri.recipe_id = r.id
    JOIN ingredients i ON i.id = ri.ingredient_id
    WHERE i.name = '감자' AND r.status = 'PUBLISHED'
    GROUP BY r.id
) ranked
WHERE ranked.rn <= 8
  AND (SELECT id FROM curations WHERE main_title = '햇감자, 지금이 가장 맛있는 첫 감자') IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM curation_recipes cr
      WHERE cr.curation_id = (SELECT id FROM curations WHERE main_title = '햇감자, 지금이 가장 맛있는 첫 감자')
        AND cr.recipe_id = ranked.recipe_id
  );

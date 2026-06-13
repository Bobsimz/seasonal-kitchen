-- V56: 제철 큐레이션 시드 3건 (무 · 봄동 · 당근)
-- 관련 식재료는 이름으로, 관련 레시피는 해당 식재료를 쓰는 레시피(recipe_ingredients)로 연결한다.
-- 메인 이미지는 대표 레시피 썸네일(없으면 식재료 이미지)로 채운다 — 모두 상대 key(응답 시 CDN 결합).
-- H2(PostgreSQL 모드, 테스트) + 실 Postgres 양쪽에서 동작하도록 LATERAL/VALUES 별칭 없이 작성.
-- 모든 INSERT는 NOT EXISTS 가드로 idempotent. 적용 후 내용 수정 금지(Flyway 체크섬).

-- ── 큐레이션 본문 3건 ──────────────────────────────────────────────
INSERT INTO curations (main_title, subtitle, seasonal_story, main_image_url, display_order, active)
SELECT
    '무, 겨울을 견디는 단단한 단맛',
    '시원한 국물부터 아삭한 무생채까지, 지금이 가장 맛있어요',
    '찬 바람을 맞을수록 무는 속이 꽉 차고 단맛이 깊어집니다. 겨울 무는 수분이 많고 아린 맛이 적어, 뭇국이나 무조림처럼 푹 익히는 요리에 제격이에요. 채 썰어 새콤하게 무친 무생채는 입맛을 돋우고, 큼직하게 썰어 끓인 맑은 국은 속을 편안하게 데워줍니다. 1년 중 가장 달고 단단한 지금, 무 한 개로 식탁을 풍성하게 채워보세요.',
    COALESCE(
        (SELECT r.image_url FROM recipes r
            JOIN recipe_ingredients ri ON ri.recipe_id = r.id
            JOIN ingredients i ON i.id = ri.ingredient_id
            WHERE i.name = '무' AND r.status = 'PUBLISHED' AND r.image_url IS NOT NULL
            ORDER BY r.id LIMIT 1),
        (SELECT image_url FROM ingredients WHERE name = '무' AND image_url IS NOT NULL ORDER BY id LIMIT 1)
    ),
    1, TRUE
WHERE NOT EXISTS (SELECT 1 FROM curations WHERE main_title = '무, 겨울을 견디는 단단한 단맛');

INSERT INTO curations (main_title, subtitle, seasonal_story, main_image_url, display_order, active)
SELECT
    '봄동, 봄을 가장 먼저 알리는 채소',
    '겨우내 단맛을 머금은 봄의 첫 잎채소',
    '겨울을 견디며 땅에 납작 엎드려 자란 봄동은, 추위를 이겨낸 만큼 잎이 도톰하고 단맛이 깊습니다. 살짝 데쳐 된장에 무치거나 겉절이로 무쳐내면 식탁에 가장 먼저 봄이 찾아와요. 부드러운 잎은 쌈으로도, 국으로도 잘 어울립니다. 1년 중 지금이 가장 연하고 달큰한 때, 봄동으로 봄을 맞이해보세요.',
    COALESCE(
        (SELECT r.image_url FROM recipes r
            JOIN recipe_ingredients ri ON ri.recipe_id = r.id
            JOIN ingredients i ON i.id = ri.ingredient_id
            WHERE i.name = '봄동' AND r.status = 'PUBLISHED' AND r.image_url IS NOT NULL
            ORDER BY r.id LIMIT 1),
        (SELECT image_url FROM ingredients WHERE name = '봄동' AND image_url IS NOT NULL ORDER BY id LIMIT 1)
    ),
    2, TRUE
WHERE NOT EXISTS (SELECT 1 FROM curations WHERE main_title = '봄동, 봄을 가장 먼저 알리는 채소');

INSERT INTO curations (main_title, subtitle, seasonal_story, main_image_url, display_order, active)
SELECT
    '당근, 사계절 든든한 뿌리채소',
    '라페부터 볶음까지, 어디에나 잘 어울려요',
    '당근은 흙 속에서 천천히 단맛을 끌어모으는 든든한 뿌리채소입니다. 기름에 살짝 볶으면 베타카로틴이 더 잘 흡수되고, 새콤하게 절인 당근라페는 김밥과 샌드위치를 산뜻하게 바꿔줍니다. 생으로도, 익혀도 좋은 만능 채소라 냉장고에 늘 두기 좋아요. 색도 영양도 가득한 당근으로 매일의 식탁에 활력을 더해보세요.',
    COALESCE(
        (SELECT r.image_url FROM recipes r
            JOIN recipe_ingredients ri ON ri.recipe_id = r.id
            JOIN ingredients i ON i.id = ri.ingredient_id
            WHERE i.name = '당근' AND r.status = 'PUBLISHED' AND r.image_url IS NOT NULL
            ORDER BY r.id LIMIT 1),
        (SELECT image_url FROM ingredients WHERE name = '당근' AND image_url IS NOT NULL ORDER BY id LIMIT 1)
    ),
    3, TRUE
WHERE NOT EXISTS (SELECT 1 FROM curations WHERE main_title = '당근, 사계절 든든한 뿌리채소');

-- ── 관련 식재료 (curation × ingredient 교차 후 이름으로 한 행만, 없으면 건너뜀) ──────
-- '무' 큐레이션
INSERT INTO curation_ingredients (curation_id, ingredient_id, sort_order)
SELECT c.id, i.id, 0 FROM curations c, ingredients i
WHERE c.main_title = '무, 겨울을 견디는 단단한 단맛' AND i.name = '무'
AND NOT EXISTS (SELECT 1 FROM curation_ingredients ci WHERE ci.curation_id = c.id AND ci.ingredient_id = i.id);
INSERT INTO curation_ingredients (curation_id, ingredient_id, sort_order)
SELECT c.id, i.id, 1 FROM curations c, ingredients i
WHERE c.main_title = '무, 겨울을 견디는 단단한 단맛' AND i.name = '당근'
AND NOT EXISTS (SELECT 1 FROM curation_ingredients ci WHERE ci.curation_id = c.id AND ci.ingredient_id = i.id);
INSERT INTO curation_ingredients (curation_id, ingredient_id, sort_order)
SELECT c.id, i.id, 2 FROM curations c, ingredients i
WHERE c.main_title = '무, 겨울을 견디는 단단한 단맛' AND i.name = '파'
AND NOT EXISTS (SELECT 1 FROM curation_ingredients ci WHERE ci.curation_id = c.id AND ci.ingredient_id = i.id);

-- '봄동' 큐레이션
INSERT INTO curation_ingredients (curation_id, ingredient_id, sort_order)
SELECT c.id, i.id, 0 FROM curations c, ingredients i
WHERE c.main_title = '봄동, 봄을 가장 먼저 알리는 채소' AND i.name = '봄동'
AND NOT EXISTS (SELECT 1 FROM curation_ingredients ci WHERE ci.curation_id = c.id AND ci.ingredient_id = i.id);
INSERT INTO curation_ingredients (curation_id, ingredient_id, sort_order)
SELECT c.id, i.id, 1 FROM curations c, ingredients i
WHERE c.main_title = '봄동, 봄을 가장 먼저 알리는 채소' AND i.name = '냉이'
AND NOT EXISTS (SELECT 1 FROM curation_ingredients ci WHERE ci.curation_id = c.id AND ci.ingredient_id = i.id);
INSERT INTO curation_ingredients (curation_id, ingredient_id, sort_order)
SELECT c.id, i.id, 2 FROM curations c, ingredients i
WHERE c.main_title = '봄동, 봄을 가장 먼저 알리는 채소' AND i.name = '부추'
AND NOT EXISTS (SELECT 1 FROM curation_ingredients ci WHERE ci.curation_id = c.id AND ci.ingredient_id = i.id);

-- '당근' 큐레이션
INSERT INTO curation_ingredients (curation_id, ingredient_id, sort_order)
SELECT c.id, i.id, 0 FROM curations c, ingredients i
WHERE c.main_title = '당근, 사계절 든든한 뿌리채소' AND i.name = '당근'
AND NOT EXISTS (SELECT 1 FROM curation_ingredients ci WHERE ci.curation_id = c.id AND ci.ingredient_id = i.id);
INSERT INTO curation_ingredients (curation_id, ingredient_id, sort_order)
SELECT c.id, i.id, 1 FROM curations c, ingredients i
WHERE c.main_title = '당근, 사계절 든든한 뿌리채소' AND i.name = '양배추'
AND NOT EXISTS (SELECT 1 FROM curation_ingredients ci WHERE ci.curation_id = c.id AND ci.ingredient_id = i.id);
INSERT INTO curation_ingredients (curation_id, ingredient_id, sort_order)
SELECT c.id, i.id, 2 FROM curations c, ingredients i
WHERE c.main_title = '당근, 사계절 든든한 뿌리채소' AND i.name = '양파'
AND NOT EXISTS (SELECT 1 FROM curation_ingredients ci WHERE ci.curation_id = c.id AND ci.ingredient_id = i.id);

-- ── 관련 레시피 (메인 식재료를 쓰는 레시피, 큐레이션당 최대 8건) ──────────
-- 식재료별로 recipe_id 를 DISTINCT 후 id 순 번호를 매겨 상위 8건만 연결(윈도우 함수, LATERAL 미사용).
-- '무' 큐레이션
INSERT INTO curation_recipes (curation_id, recipe_id, sort_order)
SELECT (SELECT id FROM curations WHERE main_title = '무, 겨울을 견디는 단단한 단맛'), ranked.recipe_id, ranked.rn - 1
FROM (
    SELECT r.id AS recipe_id, ROW_NUMBER() OVER (ORDER BY r.id) AS rn
    FROM recipes r
    JOIN recipe_ingredients ri ON ri.recipe_id = r.id
    JOIN ingredients i ON i.id = ri.ingredient_id
    WHERE i.name = '무' AND r.status = 'PUBLISHED'
    GROUP BY r.id
) ranked
WHERE ranked.rn <= 8
  AND (SELECT id FROM curations WHERE main_title = '무, 겨울을 견디는 단단한 단맛') IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM curation_recipes cr
      WHERE cr.curation_id = (SELECT id FROM curations WHERE main_title = '무, 겨울을 견디는 단단한 단맛')
        AND cr.recipe_id = ranked.recipe_id
  );

-- '봄동' 큐레이션
INSERT INTO curation_recipes (curation_id, recipe_id, sort_order)
SELECT (SELECT id FROM curations WHERE main_title = '봄동, 봄을 가장 먼저 알리는 채소'), ranked.recipe_id, ranked.rn - 1
FROM (
    SELECT r.id AS recipe_id, ROW_NUMBER() OVER (ORDER BY r.id) AS rn
    FROM recipes r
    JOIN recipe_ingredients ri ON ri.recipe_id = r.id
    JOIN ingredients i ON i.id = ri.ingredient_id
    WHERE i.name = '봄동' AND r.status = 'PUBLISHED'
    GROUP BY r.id
) ranked
WHERE ranked.rn <= 8
  AND (SELECT id FROM curations WHERE main_title = '봄동, 봄을 가장 먼저 알리는 채소') IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM curation_recipes cr
      WHERE cr.curation_id = (SELECT id FROM curations WHERE main_title = '봄동, 봄을 가장 먼저 알리는 채소')
        AND cr.recipe_id = ranked.recipe_id
  );

-- '당근' 큐레이션
INSERT INTO curation_recipes (curation_id, recipe_id, sort_order)
SELECT (SELECT id FROM curations WHERE main_title = '당근, 사계절 든든한 뿌리채소'), ranked.recipe_id, ranked.rn - 1
FROM (
    SELECT r.id AS recipe_id, ROW_NUMBER() OVER (ORDER BY r.id) AS rn
    FROM recipes r
    JOIN recipe_ingredients ri ON ri.recipe_id = r.id
    JOIN ingredients i ON i.id = ri.ingredient_id
    WHERE i.name = '당근' AND r.status = 'PUBLISHED'
    GROUP BY r.id
) ranked
WHERE ranked.rn <= 8
  AND (SELECT id FROM curations WHERE main_title = '당근, 사계절 든든한 뿌리채소') IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM curation_recipes cr
      WHERE cr.curation_id = (SELECT id FROM curations WHERE main_title = '당근, 사계절 든든한 뿌리채소')
        AND cr.recipe_id = ranked.recipe_id
  );

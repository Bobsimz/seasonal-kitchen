-- V58: 마늘쫑 식재료 + 가격(KAMIS RETAIL) + 관련 레시피 5건 시드.
-- 기존 KAMIS 수집분과 동일한 형식(source='KAMIS', price_type='RETAIL', regday 2026-06-10 / 직전 2026-06-03).
-- KAMIS 품목코드는 깐마늘(258) 다음의 미사용 코드 259(공식 품목명 "마늘종") 부여.
-- recipes/recipe_ingredients/recipe_steps 는 id 명시 없이 IDENTITY 자동 채번(V38이 recipes.id를 233으로 RESTART).
-- 농산물(마늘쫑)은 ingredient_id 연결, 비농산물(양념/단백질)은 ingredient_id=NULL + name(텍스트).
-- 모든 INSERT는 NOT EXISTS 가드로 idempotent. H2(PostgreSQL 모드) + 실 Postgres 양쪽 호환.

-- ── 식재료 ────────────────────────────────────────────────────────
INSERT INTO ingredients (name, category, base_unit, active)
SELECT '마늘쫑', '채소', '100g', TRUE
WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '마늘쫑');

-- 대표 이미지: V45 컨벤션(ingredients/{id}.jpg, CloudFront). id는 채번 후 결정되므로 concat 으로 채운다.
-- (실제 이미지 파일은 별도 S3 업로드 필요 — 미업로드 시 해당 경로 404)
UPDATE ingredients
SET image_url = CONCAT('https://d1lcjrcsx3pn64.cloudfront.net/ingredients/', id, '.jpg')
WHERE name = '마늘쫑' AND image_url IS NULL;

-- KAMIS alias (코드 259 = 마늘종)
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name)
SELECT i.id, 'KAMIS', '259', '마늘종'
FROM ingredients i
WHERE i.name = '마늘쫑'
AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='259');

-- ── 가격 스냅샷 (KAMIS RETAIL, 2행 → 변동률/추세/구매시그널 활성화) ──────
-- 직전가(약 1주 전, V42 컨벤션)
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date)
SELECT i.id, 'KAMIS', 'RETAIL', 1390.00, '100g', DATE '2026-06-03'
FROM ingredients i WHERE i.name = '마늘쫑'
AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-03');
-- 현재가 → 1,180원/100g, 직전 대비 -15% 하락(DOWN, hot, GOOD)
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date)
SELECT i.id, 'KAMIS', 'RETAIL', 1180.00, '100g', DATE '2026-06-10'
FROM ingredients i WHERE i.name = '마늘쫑'
AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- ── 레시피 5건 ────────────────────────────────────────────────────
-- R1. 마늘쫑 비빔밥 (유행 후킹)
INSERT INTO recipes (title, description, image_url, difficulty, minutes, servings, status)
SELECT '마늘쫑 비빔밥', '아삭한 햇마늘쫑을 듬뿍 올려 고추장에 쓱쓱 비벼 먹는, 요즘 SNS에서 유행하는 한 그릇 비빔밥.', NULL, 'EASY', 15, 1, 'PUBLISHED'
WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE title='마늘쫑 비빔밥');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 비빔밥' LIMIT 1), (SELECT id FROM ingredients WHERE name='마늘쫑' LIMIT 1), '마늘쫑', '100g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='마늘쫑') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 비빔밥' LIMIT 1) AND ri.name='마늘쫑');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 비빔밥' LIMIT 1), NULL, '밥', '1공기', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 비빔밥' LIMIT 1) AND ri.name='밥');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 비빔밥' LIMIT 1), NULL, '계란', '1개', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 비빔밥' LIMIT 1) AND ri.name='계란');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 비빔밥' LIMIT 1), NULL, '고추장', '1큰술', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 비빔밥' LIMIT 1) AND ri.name='고추장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 비빔밥' LIMIT 1), NULL, '참기름', '1작은술', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 비빔밥' LIMIT 1) AND ri.name='참기름');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 비빔밥' LIMIT 1), NULL, '통깨', '약간', TRUE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 비빔밥' LIMIT 1) AND ri.name='통깨');
INSERT INTO recipe_steps (recipe_id, step_number, description, minutes) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 비빔밥' LIMIT 1), 1, '마늘쫑을 깨끗이 씻어 1cm 길이로 송송 썬다.', 2 WHERE NOT EXISTS (SELECT 1 FROM recipe_steps s WHERE s.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 비빔밥' LIMIT 1) AND s.step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description, minutes) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 비빔밥' LIMIT 1), 2, '달군 팬에 기름을 약간 두르고 마늘쫑을 1~2분간 아삭하게 볶는다.', 3 WHERE NOT EXISTS (SELECT 1 FROM recipe_steps s WHERE s.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 비빔밥' LIMIT 1) AND s.step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description, minutes) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 비빔밥' LIMIT 1), 3, '그릇에 따뜻한 밥을 담고 볶은 마늘쫑과 계란프라이를 올린다.', 2 WHERE NOT EXISTS (SELECT 1 FROM recipe_steps s WHERE s.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 비빔밥' LIMIT 1) AND s.step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description, minutes) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 비빔밥' LIMIT 1), 4, '고추장·참기름을 넣고 통깨를 뿌려 잘 비벼 먹는다.', 1 WHERE NOT EXISTS (SELECT 1 FROM recipe_steps s WHERE s.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 비빔밥' LIMIT 1) AND s.step_number=4);

-- R2. 마늘쫑 새우볶음
INSERT INTO recipes (title, description, image_url, difficulty, minutes, servings, status)
SELECT '마늘쫑 새우볶음', '탱글한 새우와 아삭한 마늘쫑을 간장에 볶아낸 밥도둑 반찬.', NULL, 'EASY', 15, 2, 'PUBLISHED'
WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE title='마늘쫑 새우볶음');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 새우볶음' LIMIT 1), (SELECT id FROM ingredients WHERE name='마늘쫑' LIMIT 1), '마늘쫑', '150g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='마늘쫑') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 새우볶음' LIMIT 1) AND ri.name='마늘쫑');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 새우볶음' LIMIT 1), NULL, '칵테일새우', '100g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 새우볶음' LIMIT 1) AND ri.name='칵테일새우');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 새우볶음' LIMIT 1), NULL, '간장', '1큰술', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 새우볶음' LIMIT 1) AND ri.name='간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 새우볶음' LIMIT 1), NULL, '올리고당', '1큰술', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 새우볶음' LIMIT 1) AND ri.name='올리고당');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 새우볶음' LIMIT 1), NULL, '다진 마늘', '1작은술', TRUE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 새우볶음' LIMIT 1) AND ri.name='다진 마늘');
INSERT INTO recipe_steps (recipe_id, step_number, description, minutes) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 새우볶음' LIMIT 1), 1, '마늘쫑은 4~5cm로 썰고, 새우는 해동 후 물기를 뺀다.', 3 WHERE NOT EXISTS (SELECT 1 FROM recipe_steps s WHERE s.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 새우볶음' LIMIT 1) AND s.step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description, minutes) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 새우볶음' LIMIT 1), 2, '팬에 기름과 다진 마늘을 넣어 향을 내고 새우를 볶는다.', 4 WHERE NOT EXISTS (SELECT 1 FROM recipe_steps s WHERE s.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 새우볶음' LIMIT 1) AND s.step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description, minutes) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 새우볶음' LIMIT 1), 3, '마늘쫑을 넣고 간장·올리고당을 둘러 센 불에 볶아 마무리한다.', 5 WHERE NOT EXISTS (SELECT 1 FROM recipe_steps s WHERE s.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 새우볶음' LIMIT 1) AND s.step_number=3);

-- R3. 마늘쫑 장아찌
INSERT INTO recipes (title, description, image_url, difficulty, minutes, servings, status)
SELECT '마늘쫑 장아찌', '제철 마늘쫑을 간장물에 담가 오래 두고 먹는 아삭한 밑반찬.', NULL, 'EASY', 20, 4, 'PUBLISHED'
WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE title='마늘쫑 장아찌');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 장아찌' LIMIT 1), (SELECT id FROM ingredients WHERE name='마늘쫑' LIMIT 1), '마늘쫑', '300g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='마늘쫑') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 장아찌' LIMIT 1) AND ri.name='마늘쫑');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 장아찌' LIMIT 1), NULL, '간장', '1컵', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 장아찌' LIMIT 1) AND ri.name='간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 장아찌' LIMIT 1), NULL, '식초', '1컵', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 장아찌' LIMIT 1) AND ri.name='식초');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 장아찌' LIMIT 1), NULL, '설탕', '반컵', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 장아찌' LIMIT 1) AND ri.name='설탕');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 장아찌' LIMIT 1), NULL, '물', '1컵', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 장아찌' LIMIT 1) AND ri.name='물');
INSERT INTO recipe_steps (recipe_id, step_number, description, minutes) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 장아찌' LIMIT 1), 1, '마늘쫑을 통에 들어갈 길이로 잘라 차곡차곡 담는다.', 5 WHERE NOT EXISTS (SELECT 1 FROM recipe_steps s WHERE s.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 장아찌' LIMIT 1) AND s.step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description, minutes) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 장아찌' LIMIT 1), 2, '간장·식초·설탕·물을 냄비에 넣고 한소끔 끓인다.', 8 WHERE NOT EXISTS (SELECT 1 FROM recipe_steps s WHERE s.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 장아찌' LIMIT 1) AND s.step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description, minutes) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 장아찌' LIMIT 1), 3, '뜨거운 절임물을 마늘쫑에 부어 식힌 뒤 냉장 보관한다.', 5 WHERE NOT EXISTS (SELECT 1 FROM recipe_steps s WHERE s.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 장아찌' LIMIT 1) AND s.step_number=3);

-- R4. 마늘쫑 된장무침
INSERT INTO recipes (title, description, image_url, difficulty, minutes, servings, status)
SELECT '마늘쫑 된장무침', '살짝 데친 마늘쫑을 구수한 된장에 조물조물 무친 봄나물 반찬.', NULL, 'EASY', 10, 2, 'PUBLISHED'
WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE title='마늘쫑 된장무침');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 된장무침' LIMIT 1), (SELECT id FROM ingredients WHERE name='마늘쫑' LIMIT 1), '마늘쫑', '200g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='마늘쫑') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 된장무침' LIMIT 1) AND ri.name='마늘쫑');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 된장무침' LIMIT 1), NULL, '된장', '1큰술', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 된장무침' LIMIT 1) AND ri.name='된장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 된장무침' LIMIT 1), NULL, '고춧가루', '1작은술', TRUE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 된장무침' LIMIT 1) AND ri.name='고춧가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 된장무침' LIMIT 1), NULL, '참기름', '1작은술', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 된장무침' LIMIT 1) AND ri.name='참기름');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 된장무침' LIMIT 1), NULL, '통깨', '약간', TRUE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 된장무침' LIMIT 1) AND ri.name='통깨');
INSERT INTO recipe_steps (recipe_id, step_number, description, minutes) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 된장무침' LIMIT 1), 1, '마늘쫑을 끓는 물에 30초간 살짝 데쳐 찬물에 헹군다.', 4 WHERE NOT EXISTS (SELECT 1 FROM recipe_steps s WHERE s.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 된장무침' LIMIT 1) AND s.step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description, minutes) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 된장무침' LIMIT 1), 2, '4cm 길이로 썰어 물기를 짠다.', 2 WHERE NOT EXISTS (SELECT 1 FROM recipe_steps s WHERE s.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 된장무침' LIMIT 1) AND s.step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description, minutes) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 된장무침' LIMIT 1), 3, '된장·고춧가루·참기름·통깨를 넣고 조물조물 무친다.', 3 WHERE NOT EXISTS (SELECT 1 FROM recipe_steps s WHERE s.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 된장무침' LIMIT 1) AND s.step_number=3);

-- R5. 마늘쫑 베이컨볶음
INSERT INTO recipes (title, description, image_url, difficulty, minutes, servings, status)
SELECT '마늘쫑 베이컨볶음', '짭조름한 베이컨과 아삭한 마늘쫑을 굴소스에 볶아 아이도 잘 먹는 반찬.', NULL, 'EASY', 12, 2, 'PUBLISHED'
WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE title='마늘쫑 베이컨볶음');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 베이컨볶음' LIMIT 1), (SELECT id FROM ingredients WHERE name='마늘쫑' LIMIT 1), '마늘쫑', '150g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='마늘쫑') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 베이컨볶음' LIMIT 1) AND ri.name='마늘쫑');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 베이컨볶음' LIMIT 1), NULL, '베이컨', '100g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 베이컨볶음' LIMIT 1) AND ri.name='베이컨');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 베이컨볶음' LIMIT 1), NULL, '굴소스', '1큰술', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 베이컨볶음' LIMIT 1) AND ri.name='굴소스');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 베이컨볶음' LIMIT 1), NULL, '후추', '약간', TRUE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 베이컨볶음' LIMIT 1) AND ri.name='후추');
INSERT INTO recipe_steps (recipe_id, step_number, description, minutes) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 베이컨볶음' LIMIT 1), 1, '마늘쫑은 4cm, 베이컨은 1cm 폭으로 썬다.', 3 WHERE NOT EXISTS (SELECT 1 FROM recipe_steps s WHERE s.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 베이컨볶음' LIMIT 1) AND s.step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description, minutes) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 베이컨볶음' LIMIT 1), 2, '팬에 베이컨을 먼저 볶아 기름을 낸다.', 4 WHERE NOT EXISTS (SELECT 1 FROM recipe_steps s WHERE s.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 베이컨볶음' LIMIT 1) AND s.step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description, minutes) SELECT (SELECT id FROM recipes WHERE title='마늘쫑 베이컨볶음' LIMIT 1), 3, '마늘쫑을 넣고 굴소스·후추로 간해 센 불에 볶는다.', 5 WHERE NOT EXISTS (SELECT 1 FROM recipe_steps s WHERE s.recipe_id=(SELECT id FROM recipes WHERE title='마늘쫑 베이컨볶음' LIMIT 1) AND s.step_number=3);

-- ── 레시피 태그 (V54 컨벤션: 연결된 활성 식재료 이름 → 태그) ──────────
INSERT INTO recipe_tags (recipe_id, tag)
SELECT DISTINCT ri.recipe_id, ing.name
FROM recipe_ingredients ri
JOIN ingredients ing ON ing.id = ri.ingredient_id
WHERE ing.active = TRUE
  AND ri.recipe_id IN (SELECT id FROM recipes WHERE title IN ('마늘쫑 비빔밥','마늘쫑 새우볶음','마늘쫑 장아찌','마늘쫑 된장무침','마늘쫑 베이컨볶음'))
  AND NOT EXISTS (SELECT 1 FROM recipe_tags rt WHERE rt.recipe_id = ri.recipe_id AND rt.tag = ing.name);

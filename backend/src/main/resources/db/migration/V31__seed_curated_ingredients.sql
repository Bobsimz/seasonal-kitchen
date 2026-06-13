-- V31: CURATED 농산물 시드 (레시피 연결용)
-- 출처: 유튜브 레시피 릴스(@oh_mechu, @food_radio) 영상 분석으로 추출한, KAMIS 53품목에 없는 농산물
-- source='CURATED' 로 KAMIS 실데이터와 격리. 가격(price_snapshots)은 실측 출처 부재로 미포함 — 추후 별도 적재.
-- 모든 INSERT는 NOT EXISTS 가드로 idempotent (재실행 안전). 적용된 뒤에는 내용 수정 금지(Flyway 체크섬).

-- 청양고추 (채소) — 연결 레시피 21건
INSERT INTO ingredients (name, category, base_unit, active) SELECT '청양고추', '채소', '100g', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '청양고추');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'CURATED', 'CURATED-청양고추', '청양고추' FROM ingredients i WHERE i.name = '청양고추' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='CURATED' AND a.external_code='CURATED-청양고추');

-- 콩나물 (채소) — 연결 레시피 7건
INSERT INTO ingredients (name, category, base_unit, active) SELECT '콩나물', '채소', '300g', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '콩나물');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'CURATED', 'CURATED-콩나물', '콩나물' FROM ingredients i WHERE i.name = '콩나물' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='CURATED' AND a.external_code='CURATED-콩나물');

-- 부추 (채소) — 연결 레시피 6건
INSERT INTO ingredients (name, category, base_unit, active) SELECT '부추', '채소', '100g', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '부추');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'CURATED', 'CURATED-부추', '부추' FROM ingredients i WHERE i.name = '부추' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='CURATED' AND a.external_code='CURATED-부추');

-- 가지 (채소) — 연결 레시피 6건
INSERT INTO ingredients (name, category, base_unit, active) SELECT '가지', '채소', '1개', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '가지');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'CURATED', 'CURATED-가지', '가지' FROM ingredients i WHERE i.name = '가지' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='CURATED' AND a.external_code='CURATED-가지');

-- 꽈리고추 (채소) — 연결 레시피 4건
INSERT INTO ingredients (name, category, base_unit, active) SELECT '꽈리고추', '채소', '100g', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '꽈리고추');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'CURATED', 'CURATED-꽈리고추', '꽈리고추' FROM ingredients i WHERE i.name = '꽈리고추' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='CURATED' AND a.external_code='CURATED-꽈리고추');

-- 냉이 (채소) — 연결 레시피 2건
INSERT INTO ingredients (name, category, base_unit, active) SELECT '냉이', '채소', '100g', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '냉이');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'CURATED', 'CURATED-냉이', '냉이' FROM ingredients i WHERE i.name = '냉이' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='CURATED' AND a.external_code='CURATED-냉이');

-- 청경채 (채소) — 연결 레시피 2건
INSERT INTO ingredients (name, category, base_unit, active) SELECT '청경채', '채소', '100g', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '청경채');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'CURATED', 'CURATED-청경채', '청경채' FROM ingredients i WHERE i.name = '청경채' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='CURATED' AND a.external_code='CURATED-청경채');

-- 봄동 (채소) — 연결 레시피 2건
INSERT INTO ingredients (name, category, base_unit, active) SELECT '봄동', '채소', '1포기', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '봄동');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'CURATED', 'CURATED-봄동', '봄동' FROM ingredients i WHERE i.name = '봄동' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='CURATED' AND a.external_code='CURATED-봄동');

-- 고수 (채소) — 연결 레시피 2건
INSERT INTO ingredients (name, category, base_unit, active) SELECT '고수', '채소', '100g', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '고수');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'CURATED', 'CURATED-고수', '고수' FROM ingredients i WHERE i.name = '고수' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='CURATED' AND a.external_code='CURATED-고수');

-- 달래 (채소) — 연결 레시피 2건
INSERT INTO ingredients (name, category, base_unit, active) SELECT '달래', '채소', '100g', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '달래');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'CURATED', 'CURATED-달래', '달래' FROM ingredients i WHERE i.name = '달래' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='CURATED' AND a.external_code='CURATED-달래');

-- 들깨 (기타) — 연결 레시피 2건
INSERT INTO ingredients (name, category, base_unit, active) SELECT '들깨', '기타', '100g', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '들깨');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'CURATED', 'CURATED-들깨', '들깨' FROM ingredients i WHERE i.name = '들깨' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='CURATED' AND a.external_code='CURATED-들깨');

-- 오이고추 (채소) — 연결 레시피 1건
INSERT INTO ingredients (name, category, base_unit, active) SELECT '오이고추', '채소', '100g', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '오이고추');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'CURATED', 'CURATED-오이고추', '오이고추' FROM ingredients i WHERE i.name = '오이고추' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='CURATED' AND a.external_code='CURATED-오이고추');

-- 유채 (채소) — 연결 레시피 1건
INSERT INTO ingredients (name, category, base_unit, active) SELECT '유채', '채소', '100g', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '유채');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'CURATED', 'CURATED-유채', '유채' FROM ingredients i WHERE i.name = '유채' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='CURATED' AND a.external_code='CURATED-유채');

-- 양상추 (채소) — 연결 레시피 1건
INSERT INTO ingredients (name, category, base_unit, active) SELECT '양상추', '채소', '1통', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '양상추');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'CURATED', 'CURATED-양상추', '양상추' FROM ingredients i WHERE i.name = '양상추' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='CURATED' AND a.external_code='CURATED-양상추');

-- 시래기 (채소) — 연결 레시피 1건
INSERT INTO ingredients (name, category, base_unit, active) SELECT '시래기', '채소', '100g', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '시래기');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'CURATED', 'CURATED-시래기', '시래기' FROM ingredients i WHERE i.name = '시래기' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='CURATED' AND a.external_code='CURATED-시래기');

-- 표고버섯 (채소) — 연결 레시피 1건
INSERT INTO ingredients (name, category, base_unit, active) SELECT '표고버섯', '채소', '100g', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '표고버섯');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'CURATED', 'CURATED-표고버섯', '표고버섯' FROM ingredients i WHERE i.name = '표고버섯' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='CURATED' AND a.external_code='CURATED-표고버섯');

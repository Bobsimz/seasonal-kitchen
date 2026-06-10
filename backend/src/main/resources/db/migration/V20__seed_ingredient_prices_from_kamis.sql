-- AUTO-GENERATED from saved KAMIS raw (offline rebuild) - 전체 품목
-- regday: 2026-06-10 / type: RETAIL / cats: 100,200,300,400 / items: 53
-- review before use. re-run safe (NOT EXISTS guards).

-- 쌀 (곡류) 62484.00 / 20kg
INSERT INTO ingredients (name, category, base_unit, active) SELECT '쌀', '곡류', '20kg', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '쌀');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '111', '쌀' FROM ingredients i WHERE i.name = '쌀' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='111');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 62484.00, '20kg', DATE '2026-06-10' FROM ingredients i WHERE i.name = '쌀' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 찹쌀 (곡류) 5394.00 / 1kg
INSERT INTO ingredients (name, category, base_unit, active) SELECT '찹쌀', '곡류', '1kg', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '찹쌀');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '112', '찹쌀' FROM ingredients i WHERE i.name = '찹쌀' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='112');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 5394.00, '1kg', DATE '2026-06-10' FROM ingredients i WHERE i.name = '찹쌀' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 콩 (곡류) 5018.00 / 500g
INSERT INTO ingredients (name, category, base_unit, active) SELECT '콩', '곡류', '500g', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '콩');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '141', '콩' FROM ingredients i WHERE i.name = '콩' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='141');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 5018.00, '500g', DATE '2026-06-10' FROM ingredients i WHERE i.name = '콩' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 팥 (곡류) 13245.00 / 500g
INSERT INTO ingredients (name, category, base_unit, active) SELECT '팥', '곡류', '500g', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '팥');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '142', '팥' FROM ingredients i WHERE i.name = '팥' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='142');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 13245.00, '500g', DATE '2026-06-10' FROM ingredients i WHERE i.name = '팥' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 녹두 (곡류) 11869.00 / 500g
INSERT INTO ingredients (name, category, base_unit, active) SELECT '녹두', '곡류', '500g', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '녹두');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '143', '녹두' FROM ingredients i WHERE i.name = '녹두' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='143');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 11869.00, '500g', DATE '2026-06-10' FROM ingredients i WHERE i.name = '녹두' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 고구마 (곡류) 5874.00 / 1kg
INSERT INTO ingredients (name, category, base_unit, active) SELECT '고구마', '곡류', '1kg', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '고구마');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '151', '고구마' FROM ingredients i WHERE i.name = '고구마' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='151');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 5874.00, '1kg', DATE '2026-06-10' FROM ingredients i WHERE i.name = '고구마' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 감자 (곡류) 381.00 / 100g
INSERT INTO ingredients (name, category, base_unit, active) SELECT '감자', '곡류', '100g', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '감자');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '152', '감자' FROM ingredients i WHERE i.name = '감자' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='152');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 381.00, '100g', DATE '2026-06-10' FROM ingredients i WHERE i.name = '감자' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 배추 (채소) 3582.00 / 1포기
INSERT INTO ingredients (name, category, base_unit, active) SELECT '배추', '채소', '1포기', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '배추');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '211', '배추' FROM ingredients i WHERE i.name = '배추' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='211');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 3582.00, '1포기', DATE '2026-06-10' FROM ingredients i WHERE i.name = '배추' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 양배추 (채소) 3162.00 / 1포기
INSERT INTO ingredients (name, category, base_unit, active) SELECT '양배추', '채소', '1포기', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '양배추');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '212', '양배추' FROM ingredients i WHERE i.name = '양배추' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='212');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 3162.00, '1포기', DATE '2026-06-10' FROM ingredients i WHERE i.name = '양배추' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 시금치 (채소) 734.00 / 100g
INSERT INTO ingredients (name, category, base_unit, active) SELECT '시금치', '채소', '100g', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '시금치');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '213', '시금치' FROM ingredients i WHERE i.name = '시금치' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='213');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 734.00, '100g', DATE '2026-06-10' FROM ingredients i WHERE i.name = '시금치' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 상추 (채소) 1030.00 / 100g
INSERT INTO ingredients (name, category, base_unit, active) SELECT '상추', '채소', '100g', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '상추');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '214', '상추' FROM ingredients i WHERE i.name = '상추' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='214');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 1030.00, '100g', DATE '2026-06-10' FROM ingredients i WHERE i.name = '상추' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 얼갈이배추 (채소) 2428.00 / 1kg
INSERT INTO ingredients (name, category, base_unit, active) SELECT '얼갈이배추', '채소', '1kg', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '얼갈이배추');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '215', '얼갈이배추' FROM ingredients i WHERE i.name = '얼갈이배추' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='215');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 2428.00, '1kg', DATE '2026-06-10' FROM ingredients i WHERE i.name = '얼갈이배추' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 수박 (채소) 23605.00 / 1개
INSERT INTO ingredients (name, category, base_unit, active) SELECT '수박', '채소', '1개', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '수박');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '221', '수박' FROM ingredients i WHERE i.name = '수박' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='221');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 23605.00, '1개', DATE '2026-06-10' FROM ingredients i WHERE i.name = '수박' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 참외 (채소) 17521.00 / 10개
INSERT INTO ingredients (name, category, base_unit, active) SELECT '참외', '채소', '10개', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '참외');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '222', '참외' FROM ingredients i WHERE i.name = '참외' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='222');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 17521.00, '10개', DATE '2026-06-10' FROM ingredients i WHERE i.name = '참외' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 오이 (채소) 7345.00 / 10개
INSERT INTO ingredients (name, category, base_unit, active) SELECT '오이', '채소', '10개', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '오이');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '223', '오이' FROM ingredients i WHERE i.name = '오이' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='223');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 7345.00, '10개', DATE '2026-06-10' FROM ingredients i WHERE i.name = '오이' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 호박 (채소) 1188.00 / 1개
INSERT INTO ingredients (name, category, base_unit, active) SELECT '호박', '채소', '1개', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '호박');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '224', '호박' FROM ingredients i WHERE i.name = '호박' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='224');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 1188.00, '1개', DATE '2026-06-10' FROM ingredients i WHERE i.name = '호박' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 토마토 (채소) 3953.00 / 1kg
INSERT INTO ingredients (name, category, base_unit, active) SELECT '토마토', '채소', '1kg', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '토마토');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '225', '토마토' FROM ingredients i WHERE i.name = '토마토' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='225');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 3953.00, '1kg', DATE '2026-06-10' FROM ingredients i WHERE i.name = '토마토' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 무 (채소) 1783.00 / 1개
INSERT INTO ingredients (name, category, base_unit, active) SELECT '무', '채소', '1개', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '무');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '231', '무' FROM ingredients i WHERE i.name = '무' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='231');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 1783.00, '1개', DATE '2026-06-10' FROM ingredients i WHERE i.name = '무' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 당근 (채소) 3367.00 / 1kg
INSERT INTO ingredients (name, category, base_unit, active) SELECT '당근', '채소', '1kg', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '당근');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '232', '당근' FROM ingredients i WHERE i.name = '당근' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='232');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 3367.00, '1kg', DATE '2026-06-10' FROM ingredients i WHERE i.name = '당근' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 열무 (채소) 2376.00 / 1kg
INSERT INTO ingredients (name, category, base_unit, active) SELECT '열무', '채소', '1kg', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '열무');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '233', '열무' FROM ingredients i WHERE i.name = '열무' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='233');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 2376.00, '1kg', DATE '2026-06-10' FROM ingredients i WHERE i.name = '열무' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 건고추 (채소) 17257.00 / 600g
INSERT INTO ingredients (name, category, base_unit, active) SELECT '건고추', '채소', '600g', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '건고추');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '241', '건고추' FROM ingredients i WHERE i.name = '건고추' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='241');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 17257.00, '600g', DATE '2026-06-10' FROM ingredients i WHERE i.name = '건고추' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 풋고추 (채소) 1590.00 / 100g
INSERT INTO ingredients (name, category, base_unit, active) SELECT '풋고추', '채소', '100g', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '풋고추');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '242', '풋고추' FROM ingredients i WHERE i.name = '풋고추' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='242');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 1590.00, '100g', DATE '2026-06-10' FROM ingredients i WHERE i.name = '풋고추' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 붉은고추 (채소) 2391.00 / 100g
INSERT INTO ingredients (name, category, base_unit, active) SELECT '붉은고추', '채소', '100g', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '붉은고추');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '243', '붉은고추' FROM ingredients i WHERE i.name = '붉은고추' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='243');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 2391.00, '100g', DATE '2026-06-10' FROM ingredients i WHERE i.name = '붉은고추' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 양파 (채소) 1826.00 / 1kg
INSERT INTO ingredients (name, category, base_unit, active) SELECT '양파', '채소', '1kg', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '양파');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '245', '양파' FROM ingredients i WHERE i.name = '양파' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='245');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 1826.00, '1kg', DATE '2026-06-10' FROM ingredients i WHERE i.name = '양파' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 파 (채소) 2939.00 / 1kg
INSERT INTO ingredients (name, category, base_unit, active) SELECT '파', '채소', '1kg', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '파');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '246', '파' FROM ingredients i WHERE i.name = '파' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='246');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 2939.00, '1kg', DATE '2026-06-10' FROM ingredients i WHERE i.name = '파' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 생강 (채소) 15631.00 / 1kg
INSERT INTO ingredients (name, category, base_unit, active) SELECT '생강', '채소', '1kg', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '생강');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '247', '생강' FROM ingredients i WHERE i.name = '생강' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='247');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 15631.00, '1kg', DATE '2026-06-10' FROM ingredients i WHERE i.name = '생강' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 고춧가루 (채소) 33492.00 / 1kg
INSERT INTO ingredients (name, category, base_unit, active) SELECT '고춧가루', '채소', '1kg', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '고춧가루');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '248', '고춧가루' FROM ingredients i WHERE i.name = '고춧가루' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='248');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 33492.00, '1kg', DATE '2026-06-10' FROM ingredients i WHERE i.name = '고춧가루' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 미나리 (채소) 1416.00 / 100g
INSERT INTO ingredients (name, category, base_unit, active) SELECT '미나리', '채소', '100g', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '미나리');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '252', '미나리' FROM ingredients i WHERE i.name = '미나리' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='252');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 1416.00, '100g', DATE '2026-06-10' FROM ingredients i WHERE i.name = '미나리' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 깻잎 (채소) 2419.00 / 100g
INSERT INTO ingredients (name, category, base_unit, active) SELECT '깻잎', '채소', '100g', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '깻잎');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '253', '깻잎' FROM ingredients i WHERE i.name = '깻잎' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='253');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 2419.00, '100g', DATE '2026-06-10' FROM ingredients i WHERE i.name = '깻잎' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 피망 (채소) 1528.00 / 100g
INSERT INTO ingredients (name, category, base_unit, active) SELECT '피망', '채소', '100g', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '피망');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '255', '피망' FROM ingredients i WHERE i.name = '피망' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='255');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 1528.00, '100g', DATE '2026-06-10' FROM ingredients i WHERE i.name = '피망' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 파프리카 (채소) 1438.00 / 200g
INSERT INTO ingredients (name, category, base_unit, active) SELECT '파프리카', '채소', '200g', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '파프리카');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '256', '파프리카' FROM ingredients i WHERE i.name = '파프리카' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='256');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 1438.00, '200g', DATE '2026-06-10' FROM ingredients i WHERE i.name = '파프리카' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 멜론 (채소) 12035.00 / 1개
INSERT INTO ingredients (name, category, base_unit, active) SELECT '멜론', '채소', '1개', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '멜론');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '257', '멜론' FROM ingredients i WHERE i.name = '멜론' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='257');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 12035.00, '1개', DATE '2026-06-10' FROM ingredients i WHERE i.name = '멜론' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 깐마늘(국산) (채소) 12470.00 / 1kg
INSERT INTO ingredients (name, category, base_unit, active) SELECT '깐마늘(국산)', '채소', '1kg', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '깐마늘(국산)');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '258', '깐마늘(국산)' FROM ingredients i WHERE i.name = '깐마늘(국산)' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='258');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 12470.00, '1kg', DATE '2026-06-10' FROM ingredients i WHERE i.name = '깐마늘(국산)' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 알배기배추 (채소) 2675.00 / 1포기
INSERT INTO ingredients (name, category, base_unit, active) SELECT '알배기배추', '채소', '1포기', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '알배기배추');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '279', '알배기배추' FROM ingredients i WHERE i.name = '알배기배추' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='279');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 2675.00, '1포기', DATE '2026-06-10' FROM ingredients i WHERE i.name = '알배기배추' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 브로콜리 (채소) 2123.00 / 1개
INSERT INTO ingredients (name, category, base_unit, active) SELECT '브로콜리', '채소', '1개', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '브로콜리');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '280', '브로콜리' FROM ingredients i WHERE i.name = '브로콜리' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='280');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 2123.00, '1개', DATE '2026-06-10' FROM ingredients i WHERE i.name = '브로콜리' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 방울토마토 (채소) 7261.00 / 1kg
INSERT INTO ingredients (name, category, base_unit, active) SELECT '방울토마토', '채소', '1kg', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '방울토마토');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '422', '방울토마토' FROM ingredients i WHERE i.name = '방울토마토' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='422');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 7261.00, '1kg', DATE '2026-06-10' FROM ingredients i WHERE i.name = '방울토마토' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 참깨 (기타) 18020.00 / 500g
INSERT INTO ingredients (name, category, base_unit, active) SELECT '참깨', '기타', '500g', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '참깨');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '312', '참깨' FROM ingredients i WHERE i.name = '참깨' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='312');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 18020.00, '500g', DATE '2026-06-10' FROM ingredients i WHERE i.name = '참깨' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 땅콩 (기타) 3548.00 / 100g
INSERT INTO ingredients (name, category, base_unit, active) SELECT '땅콩', '기타', '100g', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '땅콩');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '314', '땅콩' FROM ingredients i WHERE i.name = '땅콩' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='314');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 3548.00, '100g', DATE '2026-06-10' FROM ingredients i WHERE i.name = '땅콩' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 느타리버섯 (기타) 1004.00 / 100g
INSERT INTO ingredients (name, category, base_unit, active) SELECT '느타리버섯', '기타', '100g', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '느타리버섯');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '315', '느타리버섯' FROM ingredients i WHERE i.name = '느타리버섯' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='315');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 1004.00, '100g', DATE '2026-06-10' FROM ingredients i WHERE i.name = '느타리버섯' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 팽이버섯 (기타) 443.00 / 150g
INSERT INTO ingredients (name, category, base_unit, active) SELECT '팽이버섯', '기타', '150g', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '팽이버섯');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '316', '팽이버섯' FROM ingredients i WHERE i.name = '팽이버섯' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='316');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 443.00, '150g', DATE '2026-06-10' FROM ingredients i WHERE i.name = '팽이버섯' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 새송이버섯 (기타) 547.00 / 100g
INSERT INTO ingredients (name, category, base_unit, active) SELECT '새송이버섯', '기타', '100g', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '새송이버섯');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '317', '새송이버섯' FROM ingredients i WHERE i.name = '새송이버섯' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='317');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 547.00, '100g', DATE '2026-06-10' FROM ingredients i WHERE i.name = '새송이버섯' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 호두 (기타) 2033.00 / 100g
INSERT INTO ingredients (name, category, base_unit, active) SELECT '호두', '기타', '100g', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '호두');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '318', '호두' FROM ingredients i WHERE i.name = '호두' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='318');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 2033.00, '100g', DATE '2026-06-10' FROM ingredients i WHERE i.name = '호두' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 아몬드 (기타) 1950.00 / 100g
INSERT INTO ingredients (name, category, base_unit, active) SELECT '아몬드', '기타', '100g', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '아몬드');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '319', '아몬드' FROM ingredients i WHERE i.name = '아몬드' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='319');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 1950.00, '100g', DATE '2026-06-10' FROM ingredients i WHERE i.name = '아몬드' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 사과 (과일) 27214.00 / 10개
INSERT INTO ingredients (name, category, base_unit, active) SELECT '사과', '과일', '10개', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '사과');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '411', '사과' FROM ingredients i WHERE i.name = '사과' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='411');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 27214.00, '10개', DATE '2026-06-10' FROM ingredients i WHERE i.name = '사과' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 배 (과일) 38675.00 / 10개
INSERT INTO ingredients (name, category, base_unit, active) SELECT '배', '과일', '10개', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '배');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '412', '배' FROM ingredients i WHERE i.name = '배' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='412');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 38675.00, '10개', DATE '2026-06-10' FROM ingredients i WHERE i.name = '배' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 바나나 (과일) 315.00 / 100g
INSERT INTO ingredients (name, category, base_unit, active) SELECT '바나나', '과일', '100g', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '바나나');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '418', '바나나' FROM ingredients i WHERE i.name = '바나나' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='418');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 315.00, '100g', DATE '2026-06-10' FROM ingredients i WHERE i.name = '바나나' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 참다래 (과일) 11553.00 / 10개
INSERT INTO ingredients (name, category, base_unit, active) SELECT '참다래', '과일', '10개', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '참다래');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '419', '참다래' FROM ingredients i WHERE i.name = '참다래' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='419');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 11553.00, '10개', DATE '2026-06-10' FROM ingredients i WHERE i.name = '참다래' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 파인애플 (과일) 7116.00 / 1개
INSERT INTO ingredients (name, category, base_unit, active) SELECT '파인애플', '과일', '1개', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '파인애플');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '420', '파인애플' FROM ingredients i WHERE i.name = '파인애플' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='420');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 7116.00, '1개', DATE '2026-06-10' FROM ingredients i WHERE i.name = '파인애플' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 오렌지 (과일) 18633.00 / 10개
INSERT INTO ingredients (name, category, base_unit, active) SELECT '오렌지', '과일', '10개', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '오렌지');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '421', '오렌지' FROM ingredients i WHERE i.name = '오렌지' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='421');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 18633.00, '10개', DATE '2026-06-10' FROM ingredients i WHERE i.name = '오렌지' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 레몬 (과일) 9533.00 / 10개
INSERT INTO ingredients (name, category, base_unit, active) SELECT '레몬', '과일', '10개', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '레몬');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '424', '레몬' FROM ingredients i WHERE i.name = '레몬' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='424');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 9533.00, '10개', DATE '2026-06-10' FROM ingredients i WHERE i.name = '레몬' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 체리 (과일) 3027.00 / 100g
INSERT INTO ingredients (name, category, base_unit, active) SELECT '체리', '과일', '100g', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '체리');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '425', '체리' FROM ingredients i WHERE i.name = '체리' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='425');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 3027.00, '100g', DATE '2026-06-10' FROM ingredients i WHERE i.name = '체리' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 망고 (과일) 5149.00 / 1개
INSERT INTO ingredients (name, category, base_unit, active) SELECT '망고', '과일', '1개', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '망고');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '428', '망고' FROM ingredients i WHERE i.name = '망고' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='428');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 5149.00, '1개', DATE '2026-06-10' FROM ingredients i WHERE i.name = '망고' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- 아보카도 (과일) 1864.00 / 1개
INSERT INTO ingredients (name, category, base_unit, active) SELECT '아보카도', '과일', '1개', TRUE WHERE NOT EXISTS (SELECT 1 FROM ingredients WHERE name = '아보카도');
INSERT INTO ingredient_aliases (ingredient_id, source, external_code, external_name) SELECT i.id, 'KAMIS', '430', '아보카도' FROM ingredients i WHERE i.name = '아보카도' AND NOT EXISTS (SELECT 1 FROM ingredient_aliases a WHERE a.source='KAMIS' AND a.external_code='430');
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'KAMIS', 'RETAIL', 1864.00, '1개', DATE '2026-06-10' FROM ingredients i WHERE i.name = '아보카도' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id=i.id AND p.source='KAMIS' AND p.price_type='RETAIL' AND p.observed_date=DATE '2026-06-10');

-- link producer data to ingredients by name
UPDATE producer_offers SET ingredient_id=(SELECT i.id FROM ingredients i WHERE i.name=producer_offers.ingredient_name) WHERE ingredient_id IS NULL AND EXISTS (SELECT 1 FROM ingredients i WHERE i.name=producer_offers.ingredient_name);
UPDATE producer_specialties SET ingredient_id=(SELECT i.id FROM ingredients i WHERE i.name=producer_specialties.ingredient_name) WHERE ingredient_id IS NULL AND EXISTS (SELECT 1 FROM ingredients i WHERE i.name=producer_specialties.ingredient_name);

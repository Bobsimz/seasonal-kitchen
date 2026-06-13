-- V33: CURATED 식재료 16종 가격 시드 (추정 소매가)
-- KAMIS 자동 수집을 종료함에 따라, CURATED 농산물(V31)의 가격을 수기 추정치로 채운다.
-- 가격은 한국 마트 통상 소매가 기준 '추정치'이며 공식 시세가 아니다. observed_date 기준 1회 스냅샷.
-- source='CURATED'로 KAMIS(RETAIL) 실데이터와 구분. 이름 기준 매칭(환경별 id 상이) + NOT EXISTS 가드로 idempotent.

-- 청양고추 (100g) 1200원 [추정]
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'CURATED', 'RETAIL', 1200.00, '100g', DATE '2026-06-13' FROM ingredients i WHERE i.name = '청양고추' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id = i.id AND p.source='CURATED' AND p.price_type='RETAIL' AND p.observed_date = DATE '2026-06-13');

-- 콩나물 (300g) 1500원 [추정]
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'CURATED', 'RETAIL', 1500.00, '300g', DATE '2026-06-13' FROM ingredients i WHERE i.name = '콩나물' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id = i.id AND p.source='CURATED' AND p.price_type='RETAIL' AND p.observed_date = DATE '2026-06-13');

-- 부추 (100g) 1000원 [추정]
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'CURATED', 'RETAIL', 1000.00, '100g', DATE '2026-06-13' FROM ingredients i WHERE i.name = '부추' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id = i.id AND p.source='CURATED' AND p.price_type='RETAIL' AND p.observed_date = DATE '2026-06-13');

-- 가지 (1개) 1000원 [추정]
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'CURATED', 'RETAIL', 1000.00, '1개', DATE '2026-06-13' FROM ingredients i WHERE i.name = '가지' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id = i.id AND p.source='CURATED' AND p.price_type='RETAIL' AND p.observed_date = DATE '2026-06-13');

-- 꽈리고추 (100g) 1300원 [추정]
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'CURATED', 'RETAIL', 1300.00, '100g', DATE '2026-06-13' FROM ingredients i WHERE i.name = '꽈리고추' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id = i.id AND p.source='CURATED' AND p.price_type='RETAIL' AND p.observed_date = DATE '2026-06-13');

-- 냉이 (100g) 2500원 [추정]
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'CURATED', 'RETAIL', 2500.00, '100g', DATE '2026-06-13' FROM ingredients i WHERE i.name = '냉이' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id = i.id AND p.source='CURATED' AND p.price_type='RETAIL' AND p.observed_date = DATE '2026-06-13');

-- 청경채 (100g) 900원 [추정]
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'CURATED', 'RETAIL', 900.00, '100g', DATE '2026-06-13' FROM ingredients i WHERE i.name = '청경채' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id = i.id AND p.source='CURATED' AND p.price_type='RETAIL' AND p.observed_date = DATE '2026-06-13');

-- 봄동 (1포기) 2500원 [추정]
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'CURATED', 'RETAIL', 2500.00, '1포기', DATE '2026-06-13' FROM ingredients i WHERE i.name = '봄동' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id = i.id AND p.source='CURATED' AND p.price_type='RETAIL' AND p.observed_date = DATE '2026-06-13');

-- 고수 (100g) 1500원 [추정]
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'CURATED', 'RETAIL', 1500.00, '100g', DATE '2026-06-13' FROM ingredients i WHERE i.name = '고수' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id = i.id AND p.source='CURATED' AND p.price_type='RETAIL' AND p.observed_date = DATE '2026-06-13');

-- 달래 (100g) 2000원 [추정]
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'CURATED', 'RETAIL', 2000.00, '100g', DATE '2026-06-13' FROM ingredients i WHERE i.name = '달래' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id = i.id AND p.source='CURATED' AND p.price_type='RETAIL' AND p.observed_date = DATE '2026-06-13');

-- 들깨 (100g) 2500원 [추정]
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'CURATED', 'RETAIL', 2500.00, '100g', DATE '2026-06-13' FROM ingredients i WHERE i.name = '들깨' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id = i.id AND p.source='CURATED' AND p.price_type='RETAIL' AND p.observed_date = DATE '2026-06-13');

-- 오이고추 (100g) 1200원 [추정]
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'CURATED', 'RETAIL', 1200.00, '100g', DATE '2026-06-13' FROM ingredients i WHERE i.name = '오이고추' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id = i.id AND p.source='CURATED' AND p.price_type='RETAIL' AND p.observed_date = DATE '2026-06-13');

-- 유채 (100g) 1500원 [추정]
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'CURATED', 'RETAIL', 1500.00, '100g', DATE '2026-06-13' FROM ingredients i WHERE i.name = '유채' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id = i.id AND p.source='CURATED' AND p.price_type='RETAIL' AND p.observed_date = DATE '2026-06-13');

-- 양상추 (1통) 3000원 [추정]
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'CURATED', 'RETAIL', 3000.00, '1통', DATE '2026-06-13' FROM ingredients i WHERE i.name = '양상추' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id = i.id AND p.source='CURATED' AND p.price_type='RETAIL' AND p.observed_date = DATE '2026-06-13');

-- 시래기 (100g) 2000원 [추정]
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'CURATED', 'RETAIL', 2000.00, '100g', DATE '2026-06-13' FROM ingredients i WHERE i.name = '시래기' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id = i.id AND p.source='CURATED' AND p.price_type='RETAIL' AND p.observed_date = DATE '2026-06-13');

-- 표고버섯 (100g) 2500원 [추정]
INSERT INTO price_snapshots (ingredient_id, source, price_type, price, unit, observed_date) SELECT i.id, 'CURATED', 'RETAIL', 2500.00, '100g', DATE '2026-06-13' FROM ingredients i WHERE i.name = '표고버섯' AND NOT EXISTS (SELECT 1 FROM price_snapshots p WHERE p.ingredient_id = i.id AND p.source='CURATED' AND p.price_type='RETAIL' AND p.observed_date = DATE '2026-06-13');

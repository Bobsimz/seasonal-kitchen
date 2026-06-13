-- V37: producer_offers.category 백필
-- V14에서 시드된 16개 농가 상품(producer_offers)은 category가 NULL이라
-- 상품(products) 탭의 카테고리 칩이 죽어 있다(프론트는 상품에 실제 존재하는 category 값에서만 칩을 만든다).
--
-- 프론트 상품 탭(app/(tabs)/products/page.jsx)의 CAT_ORDER 는 세분 분류를 쓴다:
--   잎채소 / 뿌리채소 / 열매채소 / 꽃채소 / 과일 / 양념채소 / 기타
-- CAT_ORDER 에 없는 값은 칩으로 노출되지 않으므로(예: ingredients.category 의 '채소'·'곡류'),
-- 칩을 살리려면 위 세분 분류로 매핑해야 한다.
--
-- 따라서 (1) 식재료명 기준 CASE 매핑을 먼저 적용해 알려진 시드 품목을 세분 분류로 채우고,
--        (2) 그래도 NULL인 행은 ingredients.name 조인으로 ingredients.category 를 복사한다(향후 행 대비 폴백).
-- 두 단계 모두 WHERE category IS NULL 로만 갱신해 멱등(이미 채워진 DB에서 재실행해도 안전)하다.

-- (1) 식재료명 → 세분 카테고리(CAT_ORDER) 매핑. V14 시드 품목(콩/봄동/시금치/무/배추/감귤/귤/브로콜리/대파/마늘/굴/단호박/고구마) 전부 포함.
UPDATE producer_offers
SET category = CASE ingredient_name
        WHEN '봄동'   THEN '잎채소'
        WHEN '시금치' THEN '잎채소'
        WHEN '배추'   THEN '잎채소'
        WHEN '무'     THEN '뿌리채소'
        WHEN '고구마' THEN '뿌리채소'
        WHEN '단호박' THEN '열매채소'
        WHEN '브로콜리' THEN '꽃채소'
        WHEN '대파'   THEN '양념채소'
        WHEN '마늘'   THEN '양념채소'
        WHEN '감귤'   THEN '과일'
        WHEN '귤'     THEN '과일'
        WHEN '콩'     THEN '기타'
        WHEN '굴'     THEN '기타'
        ELSE NULL
    END
WHERE category IS NULL
  AND ingredient_name IN ('봄동','시금치','배추','무','고구마','단호박','브로콜리','대파','마늘','감귤','귤','콩','굴');

-- (2) 폴백: 위에서 못 채운 행은 ingredients.name = producer_offers.ingredient_name 조인으로 카테고리 복사.
UPDATE producer_offers po
SET category = i.category
FROM ingredients i
WHERE po.category IS NULL
  AND i.name = po.ingredient_name;

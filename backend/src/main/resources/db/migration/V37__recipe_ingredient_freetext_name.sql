-- 레시피 재료에 비농산물(양념·가공·축산·수산)도 담을 수 있도록 확장.
-- 농산물은 ingredient_id로 식재료 상세에 연결되고, 비농산물은 ingredient_id=NULL + name(자유 텍스트)로 표시만 한다.
ALTER TABLE recipe_ingredients ADD COLUMN name VARCHAR(150);
ALTER TABLE recipe_ingredients ALTER COLUMN ingredient_id DROP NOT NULL;

-- V60: 큐레이션 노출 순서 조정 + 마늘쫑/햇감자 이미지 연결 (데이터 전용 UPDATE — DDL/삭제 없음).
-- 순서: 마늘쫑=1, 햇감자=2 (기존 무=3·봄동=4·당근=5로 밀림 — 사용자 요청).
-- 이미지: 마늘쫑 레시피 5건 image_url 연결 + 큐레이션 배너를 먹음직스러운 컷으로 지정.
-- 이미지 파일(ingredients/71.jpg, dishes/233~237.jpg, curations/potato.jpg)은 S3에 사전 업로드 완료.
-- 이름/제목 기준(환경 독립). UPDATE만이라 재실행 안전(멱등).

-- ── 큐레이션 노출 순서 ─────────────────────────────────────────────
UPDATE curations SET display_order=1 WHERE main_title='마늘쫑, SNS가 주목한 제철 한 그릇';
UPDATE curations SET display_order=2 WHERE main_title='햇감자, 지금이 가장 맛있는 첫 감자';
UPDATE curations SET display_order=3 WHERE main_title='무, 겨울을 견디는 단단한 단맛';
UPDATE curations SET display_order=4 WHERE main_title='봄동, 봄을 가장 먼저 알리는 채소';
UPDATE curations SET display_order=5 WHERE main_title='당근, 사계절 든든한 뿌리채소';

-- ── 마늘쫑 레시피 대표 이미지 (dishes/{recipe_id}.jpg) ──────────────
UPDATE recipes SET image_url='dishes/233.jpg' WHERE title='마늘쫑 비빔밥' AND image_url IS NULL;
UPDATE recipes SET image_url='dishes/234.jpg' WHERE title='마늘쫑 새우볶음' AND image_url IS NULL;
UPDATE recipes SET image_url='dishes/235.jpg' WHERE title='마늘쫑 장아찌' AND image_url IS NULL;
UPDATE recipes SET image_url='dishes/236.jpg' WHERE title='마늘쫑 된장무침' AND image_url IS NULL;
UPDATE recipes SET image_url='dishes/237.jpg' WHERE title='마늘쫑 베이컨볶음' AND image_url IS NULL;

-- ── 큐레이션 배너 이미지 (먹음직스러운 컷) ──────────────────────────
-- 마늘쫑: 식재료 사진(ingredients/71.jpg) 대신 유행 메뉴 '마늘쫑 비빔밥' 컷으로.
UPDATE curations SET main_image_url='dishes/233.jpg' WHERE main_title='마늘쫑, SNS가 주목한 제철 한 그릇';
-- 햇감자: 식재료/기존 컷보다 먹음직스러운 감자조림 컷으로.
UPDATE curations SET main_image_url='curations/potato.jpg' WHERE main_title='햇감자, 지금이 가장 맛있는 첫 감자';

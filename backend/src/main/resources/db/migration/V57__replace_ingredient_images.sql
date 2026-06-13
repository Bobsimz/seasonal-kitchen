-- V57: 잘못된 식재료 대표 이미지 교체 (삽화/중복/오품종 30종 → 새 사진).
-- 신규 사진을 S3 ingredients/{id}_v2.jpg 로 업로드(원본 보존), image_url 을 새 CloudFront URL 로 갱신.
-- 이름 기준(환경 독립). 같은 값 재설정이라 재실행 안전(멱등). V45 에서 백필된 URL 을 덮어쓴다.

UPDATE ingredients SET image_url='https://d1lcjrcsx3pn64.cloudfront.net/ingredients/3_v2.jpg' WHERE name='콩' AND active=true;
UPDATE ingredients SET image_url='https://d1lcjrcsx3pn64.cloudfront.net/ingredients/7_v2.jpg' WHERE name='감자' AND active=true;
UPDATE ingredients SET image_url='https://d1lcjrcsx3pn64.cloudfront.net/ingredients/10_v2.jpg' WHERE name='시금치' AND active=true;
UPDATE ingredients SET image_url='https://d1lcjrcsx3pn64.cloudfront.net/ingredients/12_v2.jpg' WHERE name='얼갈이배추' AND active=true;
UPDATE ingredients SET image_url='https://d1lcjrcsx3pn64.cloudfront.net/ingredients/17_v2.jpg' WHERE name='토마토' AND active=true;
UPDATE ingredients SET image_url='https://d1lcjrcsx3pn64.cloudfront.net/ingredients/21_v2.jpg' WHERE name='건고추' AND active=true;
UPDATE ingredients SET image_url='https://d1lcjrcsx3pn64.cloudfront.net/ingredients/23_v2.jpg' WHERE name='붉은고추' AND active=true;
UPDATE ingredients SET image_url='https://d1lcjrcsx3pn64.cloudfront.net/ingredients/26_v2.jpg' WHERE name='생강' AND active=true;
UPDATE ingredients SET image_url='https://d1lcjrcsx3pn64.cloudfront.net/ingredients/27_v2.jpg' WHERE name='고춧가루' AND active=true;
UPDATE ingredients SET image_url='https://d1lcjrcsx3pn64.cloudfront.net/ingredients/29_v2.jpg' WHERE name='깻잎' AND active=true;
UPDATE ingredients SET image_url='https://d1lcjrcsx3pn64.cloudfront.net/ingredients/33_v2.jpg' WHERE name='깐마늘(국산)' AND active=true;
UPDATE ingredients SET image_url='https://d1lcjrcsx3pn64.cloudfront.net/ingredients/34_v2.jpg' WHERE name='알배기배추' AND active=true;
UPDATE ingredients SET image_url='https://d1lcjrcsx3pn64.cloudfront.net/ingredients/37_v2.jpg' WHERE name='참깨' AND active=true;
UPDATE ingredients SET image_url='https://d1lcjrcsx3pn64.cloudfront.net/ingredients/38_v2.jpg' WHERE name='땅콩' AND active=true;
UPDATE ingredients SET image_url='https://d1lcjrcsx3pn64.cloudfront.net/ingredients/40_v2.jpg' WHERE name='팽이버섯' AND active=true;
UPDATE ingredients SET image_url='https://d1lcjrcsx3pn64.cloudfront.net/ingredients/43_v2.jpg' WHERE name='아몬드' AND active=true;
UPDATE ingredients SET image_url='https://d1lcjrcsx3pn64.cloudfront.net/ingredients/45_v2.jpg' WHERE name='배' AND active=true;
UPDATE ingredients SET image_url='https://d1lcjrcsx3pn64.cloudfront.net/ingredients/46_v2.jpg' WHERE name='바나나' AND active=true;
UPDATE ingredients SET image_url='https://d1lcjrcsx3pn64.cloudfront.net/ingredients/47_v2.jpg' WHERE name='참다래' AND active=true;
UPDATE ingredients SET image_url='https://d1lcjrcsx3pn64.cloudfront.net/ingredients/48_v2.jpg' WHERE name='파인애플' AND active=true;
UPDATE ingredients SET image_url='https://d1lcjrcsx3pn64.cloudfront.net/ingredients/50_v2.jpg' WHERE name='레몬' AND active=true;
UPDATE ingredients SET image_url='https://d1lcjrcsx3pn64.cloudfront.net/ingredients/53_v2.jpg' WHERE name='아보카도' AND active=true;
UPDATE ingredients SET image_url='https://d1lcjrcsx3pn64.cloudfront.net/ingredients/57_v2.jpg' WHERE name='부추' AND active=true;
UPDATE ingredients SET image_url='https://d1lcjrcsx3pn64.cloudfront.net/ingredients/58_v2.jpg' WHERE name='가지' AND active=true;
UPDATE ingredients SET image_url='https://d1lcjrcsx3pn64.cloudfront.net/ingredients/60_v2.jpg' WHERE name='냉이' AND active=true;
UPDATE ingredients SET image_url='https://d1lcjrcsx3pn64.cloudfront.net/ingredients/63_v2.jpg' WHERE name='고수' AND active=true;
UPDATE ingredients SET image_url='https://d1lcjrcsx3pn64.cloudfront.net/ingredients/65_v2.jpg' WHERE name='들깨' AND active=true;
UPDATE ingredients SET image_url='https://d1lcjrcsx3pn64.cloudfront.net/ingredients/66_v2.jpg' WHERE name='오이고추' AND active=true;
UPDATE ingredients SET image_url='https://d1lcjrcsx3pn64.cloudfront.net/ingredients/67_v2.jpg' WHERE name='유채' AND active=true;
UPDATE ingredients SET image_url='https://d1lcjrcsx3pn64.cloudfront.net/ingredients/68_v2.jpg' WHERE name='양상추' AND active=true;

-- V66: 마늘쫑 판매 상품(producer_offers) 시드 — 농가 3곳(VALUE/ORGANIC/PREMIUM) × offer 1건 (V48 패턴).
-- 식재료 상세 "이 재료를 파는 상품" 섹션이 비어있던 문제 해결. 데이터 전용(INSERT만, DDL/삭제 없음).
-- ingredient_id는 이름 조회로 연결(환경 독립), status=ACTIVE. offer 고정 id 2184~2186 (현재 max 2183).
-- offer_photos.url은 절대 CloudFront URL(기존 관례) — 업로드된 마늘쫑 대표사진(ingredients/71.jpg) 재사용.
-- 모든 INSERT는 NOT EXISTS 가드로 idempotent. H2(PostgreSQL 모드)+실 Postgres 호환.

-- ── offer 2184: 농가 101 (VALUE, 알뜰) ──────────────────────────────
INSERT INTO producer_offers (id,producer_id,ingredient_id,ingredient_name,price,unit,freshness_label,title,description,category,stock_quantity,storage_method,storage_note,status)
SELECT 2184,101,(SELECT id FROM ingredients WHERE name='마늘쫑' LIMIT 1),'마늘쫑',5200,'g','당일수확','마늘쫑 500g 알뜰 실속','아삭한 햇마늘쫑을(를) 산지에서 직접 보내드립니다. 볶음·장아찌·비빔밥에 두루 좋아요.','채소',100,'냉장 보관','물기 없이 신문지에 싸 냉장 보관하고, 살짝 데쳐 냉동하면 오래 두고 먹을 수 있어요.','ACTIVE'
WHERE NOT EXISTS (SELECT 1 FROM producer_offers WHERE id=2184);
INSERT INTO offer_options (offer_id,quantity,unit,price,sort_order) SELECT 2184,500,'g',5200,0 WHERE NOT EXISTS (SELECT 1 FROM offer_options WHERE offer_id=2184 AND sort_order=0);
INSERT INTO offer_options (offer_id,quantity,unit,price,sort_order) SELECT 2184,1000,'g',9900,1 WHERE NOT EXISTS (SELECT 1 FROM offer_options WHERE offer_id=2184 AND sort_order=1);
INSERT INTO offer_options (offer_id,quantity,unit,price,sort_order) SELECT 2184,2000,'g',18800,2 WHERE NOT EXISTS (SELECT 1 FROM offer_options WHERE offer_id=2184 AND sort_order=2);
INSERT INTO offer_tags (offer_id,label) SELECT 2184,'산지직송' WHERE NOT EXISTS (SELECT 1 FROM offer_tags WHERE offer_id=2184 AND label='산지직송');
INSERT INTO offer_tags (offer_id,label) SELECT 2184,'당일수확' WHERE NOT EXISTS (SELECT 1 FROM offer_tags WHERE offer_id=2184 AND label='당일수확');
INSERT INTO offer_photos (offer_id,url,sort_order,is_primary) SELECT 2184,'https://d1lcjrcsx3pn64.cloudfront.net/ingredients/71.jpg',0,TRUE WHERE NOT EXISTS (SELECT 1 FROM offer_photos WHERE offer_id=2184 AND sort_order=0);
INSERT INTO producer_specialties (producer_id,ingredient_name,ingredient_id) SELECT 101,'마늘쫑',(SELECT id FROM ingredients WHERE name='마늘쫑' LIMIT 1) WHERE NOT EXISTS (SELECT 1 FROM producer_specialties WHERE producer_id=101 AND ingredient_name='마늘쫑');

-- ── offer 2185: 농가 102 (ORGANIC, 유기농) ──────────────────────────
INSERT INTO producer_offers (id,producer_id,ingredient_id,ingredient_name,price,unit,freshness_label,title,description,category,stock_quantity,storage_method,storage_note,status)
SELECT 2185,102,(SELECT id FROM ingredients WHERE name='마늘쫑' LIMIT 1),'마늘쫑',6500,'g','수확 1일 이내','유기농 마늘쫑 500g','무농약으로 키운 연한 마늘쫑이에요. 알싸한 향이 부드러워 데쳐 무치기에 좋습니다.','채소',80,'냉장 보관','물기 없이 신문지에 싸 냉장 보관하고, 살짝 데쳐 냉동하면 오래 두고 먹을 수 있어요.','ACTIVE'
WHERE NOT EXISTS (SELECT 1 FROM producer_offers WHERE id=2185);
INSERT INTO offer_options (offer_id,quantity,unit,price,sort_order) SELECT 2185,500,'g',6500,0 WHERE NOT EXISTS (SELECT 1 FROM offer_options WHERE offer_id=2185 AND sort_order=0);
INSERT INTO offer_options (offer_id,quantity,unit,price,sort_order) SELECT 2185,1000,'g',12500,1 WHERE NOT EXISTS (SELECT 1 FROM offer_options WHERE offer_id=2185 AND sort_order=1);
INSERT INTO offer_tags (offer_id,label) SELECT 2185,'유기농' WHERE NOT EXISTS (SELECT 1 FROM offer_tags WHERE offer_id=2185 AND label='유기농');
INSERT INTO offer_tags (offer_id,label) SELECT 2185,'산지직송' WHERE NOT EXISTS (SELECT 1 FROM offer_tags WHERE offer_id=2185 AND label='산지직송');
INSERT INTO offer_photos (offer_id,url,sort_order,is_primary) SELECT 2185,'https://d1lcjrcsx3pn64.cloudfront.net/ingredients/71.jpg',0,TRUE WHERE NOT EXISTS (SELECT 1 FROM offer_photos WHERE offer_id=2185 AND sort_order=0);
INSERT INTO producer_specialties (producer_id,ingredient_name,ingredient_id) SELECT 102,'마늘쫑',(SELECT id FROM ingredients WHERE name='마늘쫑' LIMIT 1) WHERE NOT EXISTS (SELECT 1 FROM producer_specialties WHERE producer_id=102 AND ingredient_name='마늘쫑');

-- ── offer 2186: 농가 103 (PREMIUM, 프리미엄 선별) ─────────────────────
INSERT INTO producer_offers (id,producer_id,ingredient_id,ingredient_name,price,unit,freshness_label,title,description,category,stock_quantity,storage_method,storage_note,status)
SELECT 2186,103,(SELECT id FROM ingredients WHERE name='마늘쫑' LIMIT 1),'마늘쫑',6900,'g','당일수확','햇마늘쫑 프리미엄 선별','굵기와 길이를 선별한 햇마늘쫑이에요. 식감이 아삭하고 향이 진해 볶음 요리에 특히 좋습니다.','채소',60,'냉장 보관','물기 없이 신문지에 싸 냉장 보관하고, 살짝 데쳐 냉동하면 오래 두고 먹을 수 있어요.','ACTIVE'
WHERE NOT EXISTS (SELECT 1 FROM producer_offers WHERE id=2186);
INSERT INTO offer_options (offer_id,quantity,unit,price,sort_order) SELECT 2186,500,'g',6900,0 WHERE NOT EXISTS (SELECT 1 FROM offer_options WHERE offer_id=2186 AND sort_order=0);
INSERT INTO offer_options (offer_id,quantity,unit,price,sort_order) SELECT 2186,1000,'g',13200,1 WHERE NOT EXISTS (SELECT 1 FROM offer_options WHERE offer_id=2186 AND sort_order=1);
INSERT INTO offer_options (offer_id,quantity,unit,price,sort_order) SELECT 2186,2000,'g',25800,2 WHERE NOT EXISTS (SELECT 1 FROM offer_options WHERE offer_id=2186 AND sort_order=2);
INSERT INTO offer_tags (offer_id,label) SELECT 2186,'당일수확' WHERE NOT EXISTS (SELECT 1 FROM offer_tags WHERE offer_id=2186 AND label='당일수확');
INSERT INTO offer_tags (offer_id,label) SELECT 2186,'안심패킹' WHERE NOT EXISTS (SELECT 1 FROM offer_tags WHERE offer_id=2186 AND label='안심패킹');
INSERT INTO offer_photos (offer_id,url,sort_order,is_primary) SELECT 2186,'https://d1lcjrcsx3pn64.cloudfront.net/ingredients/71.jpg',0,TRUE WHERE NOT EXISTS (SELECT 1 FROM offer_photos WHERE offer_id=2186 AND sort_order=0);
INSERT INTO producer_specialties (producer_id,ingredient_name,ingredient_id) SELECT 103,'마늘쫑',(SELECT id FROM ingredients WHERE name='마늘쫑' LIMIT 1) WHERE NOT EXISTS (SELECT 1 FROM producer_specialties WHERE producer_id=103 AND ingredient_name='마늘쫑');

-- V47: 추가 농가 시드 (자가등록 신원 필드 포함, V25 스키마 기준)
-- (구 V39로 작성했으나 외부 푸시와 번호 충돌로 손실 → V47로 복원)
-- 본 마이그레이션은 producers 행만 생성한다 — 특산품(producer_specialties)·배지는 비워두고,
-- 취급 품목·상품(producer_offers)은 후속 V48에서 채운다.
-- 규칙: contact 일괄 더미('010-1234-5678'), agreed_to_terms=true, certification_image_url 더미 placeholder.
-- id 101~118 별도 대역 — 자가등록 농가(id 9~ 자동 증가)와 충돌 회피, identity 시퀀스는 변경하지 않음.
-- style 구성: VALUE 6(101·105·108·110·113·114), ORGANIC 6(102·104·107·109·112·115), PREMIUM 6(103·106·111·116·117·118)
--   → 상품 가격 3단계(실속/표준/프리미엄)를 style별 6농가로 분산 적재하기 위함.
-- 모든 INSERT는 NOT EXISTS 가드로 idempotent (재실행 안전). 적용 후 내용 수정 금지(Flyway 체크섬).

-- (101) 들녘농원 / 이정훈 / 전북김제
INSERT INTO producers (id,name,representative_name,region,contact,certification_image_url,agreed_to_terms,style,price_level,freshness_level,tagline,rating,review_count,honorary)
SELECT 101,'들녘농원','이정훈','전북김제','010-1234-5678','https://placehold.co/800x600?text=cert',true,'VALUE',2,4,'너른 김제평야에서 키운 사계절 채소',4.6,312,false
WHERE NOT EXISTS (SELECT 1 FROM producers WHERE id=101);

-- (102) 산골농부 / 김도윤 / 강원홍천
INSERT INTO producers (id,name,representative_name,region,contact,certification_image_url,agreed_to_terms,style,price_level,freshness_level,tagline,rating,review_count,honorary)
SELECT 102,'산골농부','김도윤','강원홍천','010-1234-5678','https://placehold.co/800x600?text=cert',true,'ORGANIC',4,5,'해발 600m 청정 고랭지 무농약 쌈채소',4.8,287,false
WHERE NOT EXISTS (SELECT 1 FROM producers WHERE id=102);

-- (103) 햇살가득농장 / 박서연 / 경남밀양
INSERT INTO producers (id,name,representative_name,region,contact,certification_image_url,agreed_to_terms,style,price_level,freshness_level,tagline,rating,review_count,honorary)
SELECT 103,'햇살가득농장','박서연','경남밀양','010-1234-5678','https://placehold.co/800x600?text=cert',true,'PREMIUM',4,5,'밀양 햇살 듬뿍, 당도 높은 제철 농산물',4.9,521,true
WHERE NOT EXISTS (SELECT 1 FROM producers WHERE id=103);

-- (104) 바른먹거리 / 최민호 / 충북괴산
INSERT INTO producers (id,name,representative_name,region,contact,certification_image_url,agreed_to_terms,style,price_level,freshness_level,tagline,rating,review_count,honorary)
SELECT 104,'바른먹거리','최민호','충북괴산','010-1234-5678','https://placehold.co/800x600?text=cert',true,'ORGANIC',3,4,'괴산 유기농 1세대, 30년 외길',4.7,445,true
WHERE NOT EXISTS (SELECT 1 FROM producers WHERE id=104);

-- (105) 푸른들농원 / 정예린 / 전남나주
INSERT INTO producers (id,name,representative_name,region,contact,certification_image_url,agreed_to_terms,style,price_level,freshness_level,tagline,rating,review_count,honorary)
SELECT 105,'푸른들농원','정예린','전남나주','010-1234-5678','https://placehold.co/800x600?text=cert',true,'VALUE',2,4,'나주 배밭 옆 텃밭, 정직한 가격',4.5,198,false
WHERE NOT EXISTS (SELECT 1 FROM producers WHERE id=105);

-- (106) 새벽농장 / 한지우 / 경기여주
INSERT INTO producers (id,name,representative_name,region,contact,certification_image_url,agreed_to_terms,style,price_level,freshness_level,tagline,rating,review_count,honorary)
SELECT 106,'새벽농장','한지우','경기여주','010-1234-5678','https://placehold.co/800x600?text=cert',true,'PREMIUM',5,5,'여주 새벽에 수확해 당일 출고',4.9,673,false
WHERE NOT EXISTS (SELECT 1 FROM producers WHERE id=106);

-- (107) 텃밭이야기 / 오승현 / 충남부여
INSERT INTO producers (id,name,representative_name,region,contact,certification_image_url,agreed_to_terms,style,price_level,freshness_level,tagline,rating,review_count,honorary)
SELECT 107,'텃밭이야기','오승현','충남부여','010-1234-5678','https://placehold.co/800x600?text=cert',true,'ORGANIC',3,5,'부여 백마강변 무농약 봄나물 전문',4.8,356,true
WHERE NOT EXISTS (SELECT 1 FROM producers WHERE id=107);

-- (108) 흙내음농원 / 신유나 / 경북의성
INSERT INTO producers (id,name,representative_name,region,contact,certification_image_url,agreed_to_terms,style,price_level,freshness_level,tagline,rating,review_count,honorary)
SELECT 108,'흙내음농원','신유나','경북의성','010-1234-5678','https://placehold.co/800x600?text=cert',true,'VALUE',2,3,'의성 마늘밭에서 키운 건강 채소',4.4,142,false
WHERE NOT EXISTS (SELECT 1 FROM producers WHERE id=108);

-- (109) 청정밭 / 임재혁 / 강원정선
INSERT INTO producers (id,name,representative_name,region,contact,certification_image_url,agreed_to_terms,style,price_level,freshness_level,tagline,rating,review_count,honorary)
SELECT 109,'청정밭','임재혁','강원정선','010-1234-5678','https://placehold.co/800x600?text=cert',true,'ORGANIC',4,5,'정선 고랭지 청정 채소, 친환경 인증',4.7,289,true
WHERE NOT EXISTS (SELECT 1 FROM producers WHERE id=109);

-- (110) 한아름농장 / 윤소희 / 전북정읍
INSERT INTO producers (id,name,representative_name,region,contact,certification_image_url,agreed_to_terms,style,price_level,freshness_level,tagline,rating,review_count,honorary)
SELECT 110,'한아름농장','윤소희','전북정읍','010-1234-5678','https://placehold.co/800x600?text=cert',true,'VALUE',3,4,'정읍 내장산 자락 사계절 농산물',4.6,401,false
WHERE NOT EXISTS (SELECT 1 FROM producers WHERE id=110);

-- (111) 자연그대로 / 강태경 / 경남거창
INSERT INTO producers (id,name,representative_name,region,contact,certification_image_url,agreed_to_terms,style,price_level,freshness_level,tagline,rating,review_count,honorary)
SELECT 111,'자연그대로','강태경','경남거창','010-1234-5678','https://placehold.co/800x600?text=cert',true,'PREMIUM',5,5,'거창 고랭지 프리미엄 채소',4.9,558,true
WHERE NOT EXISTS (SELECT 1 FROM producers WHERE id=111);

-- (112) 미소진농원 / 배현우 / 충북단양
INSERT INTO producers (id,name,representative_name,region,contact,certification_image_url,agreed_to_terms,style,price_level,freshness_level,tagline,rating,review_count,honorary)
SELECT 112,'미소진농원','배현우','충북단양','010-1234-5678','https://placehold.co/800x600?text=cert',true,'ORGANIC',4,4,'단양 산골 무농약 제철 먹거리',4.7,234,false
WHERE NOT EXISTS (SELECT 1 FROM producers WHERE id=112);

-- (113) 안동들녘 / 권나래 / 경북안동  [VALUE 보강]
INSERT INTO producers (id,name,representative_name,region,contact,certification_image_url,agreed_to_terms,style,price_level,freshness_level,tagline,rating,review_count,honorary)
SELECT 113,'안동들녘','권나래','경북안동','010-1234-5678','https://placehold.co/800x600?text=cert',true,'VALUE',2,4,'안동 들녘에서 키운 사계절 알뜰 채소',4.5,176,false
WHERE NOT EXISTS (SELECT 1 FROM producers WHERE id=113);

-- (114) 예산황토농원 / 문태웅 / 충남예산  [VALUE 보강]
INSERT INTO producers (id,name,representative_name,region,contact,certification_image_url,agreed_to_terms,style,price_level,freshness_level,tagline,rating,review_count,honorary)
SELECT 114,'예산황토농원','문태웅','충남예산','010-1234-5678','https://placehold.co/800x600?text=cert',true,'VALUE',3,3,'예산 황토밭에서 키운 가성비 농산물',4.4,203,false
WHERE NOT EXISTS (SELECT 1 FROM producers WHERE id=114);

-- (115) 섬진강푸름 / 류지안 / 전남곡성  [ORGANIC 보강]
INSERT INTO producers (id,name,representative_name,region,contact,certification_image_url,agreed_to_terms,style,price_level,freshness_level,tagline,rating,review_count,honorary)
SELECT 115,'섬진강푸름','류지안','전남곡성','010-1234-5678','https://placehold.co/800x600?text=cert',true,'ORGANIC',4,5,'곡성 섬진강변 친환경 무농약 채소',4.8,264,true
WHERE NOT EXISTS (SELECT 1 FROM producers WHERE id=115);

-- (116) 청송사과원 / 백승호 / 경북청송  [PREMIUM 보강]
INSERT INTO producers (id,name,representative_name,region,contact,certification_image_url,agreed_to_terms,style,price_level,freshness_level,tagline,rating,review_count,honorary)
SELECT 116,'청송사과원','백승호','경북청송','010-1234-5678','https://placehold.co/800x600?text=cert',true,'PREMIUM',5,5,'청송 사과밭, 일교차로 키운 프리미엄 과채',4.9,612,true
WHERE NOT EXISTS (SELECT 1 FROM producers WHERE id=116);

-- (117) 지리산자락 / 서미경 / 경남하동  [PREMIUM 보강]
INSERT INTO producers (id,name,representative_name,region,contact,certification_image_url,agreed_to_terms,style,price_level,freshness_level,tagline,rating,review_count,honorary)
SELECT 117,'지리산자락','서미경','경남하동','010-1234-5678','https://placehold.co/800x600?text=cert',true,'PREMIUM',5,5,'하동 지리산 자락 고품질 제철 농산물',4.8,487,true
WHERE NOT EXISTS (SELECT 1 FROM producers WHERE id=117);

-- (118) 영동햇골 / 조현수 / 충북영동  [PREMIUM 보강]
INSERT INTO producers (id,name,representative_name,region,contact,certification_image_url,agreed_to_terms,style,price_level,freshness_level,tagline,rating,review_count,honorary)
SELECT 118,'영동햇골','조현수','충북영동','010-1234-5678','https://placehold.co/800x600?text=cert',true,'PREMIUM',4,5,'영동 일교차로 끌어올린 당도 높은 작물',4.7,398,false
WHERE NOT EXISTS (SELECT 1 FROM producers WHERE id=118);

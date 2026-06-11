-- 판매자 등록 화면(21e)에 맞춰 producers에 신원/연락/인증/약관 필드 추가.
-- style/price_level/freshness_level/tagline/photo_url/badges는 등록 화면에서 받지 않으므로
-- 자가등록 시 기본값(style=VALUE, price_level=3, freshness_level=4)으로 채운다(컬럼은 유지).
ALTER TABLE producers ADD COLUMN representative_name VARCHAR(50);
ALTER TABLE producers ADD COLUMN contact VARCHAR(30);
ALTER TABLE producers ADD COLUMN certification_image_url VARCHAR(500);
ALTER TABLE producers ADD COLUMN agreed_to_terms BOOLEAN NOT NULL DEFAULT FALSE;

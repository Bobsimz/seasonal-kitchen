-- 판매자 상품 관리(숨김/삭제)를 위한 상태 컬럼.
-- cart_items·offer_photos 등이 producer_offers를 FK 참조하므로 물리 삭제 대신 status=HIDDEN 소프트 삭제.
-- 기존 데이터 호환: NOT NULL DEFAULT 'ACTIVE'.
ALTER TABLE producer_offers ADD COLUMN status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE';  -- ACTIVE | HIDDEN

CREATE INDEX idx_producer_offers_producer_status ON producer_offers(producer_id, status);

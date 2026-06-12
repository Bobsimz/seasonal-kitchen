-- 판매자 통계 "인기 상품"을 상품(offer) 단위로 집계하기 위해 주문 항목에 상품 스냅샷을 남긴다.
-- 모두 nullable — 기존 order_items 데이터 호환(과거 행은 offer_id NULL → 통계에서 ingredient_name fallback).

ALTER TABLE order_items ADD COLUMN offer_id BIGINT;
ALTER TABLE order_items ADD COLUMN offer_title VARCHAR(150);
ALTER TABLE order_items ADD COLUMN offer_unit VARCHAR(30);

CREATE INDEX idx_order_items_offer ON order_items(offer_id);

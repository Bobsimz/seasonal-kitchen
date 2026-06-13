-- 장바구니 선택 옵션(규격/variant) 반영. BACKEND-REQUIREMENTS #10.
-- 같은 offer라도 옵션이 다르면 별도 라인 → 유니크 키를 (cart_id, offer_id, offer_option_id)로 확장.
-- option 없는 라인은 offer_option_id NULL(옵션 단가 대신 offer 기본가 사용).
-- (원래 V32였으나 팀원의 V32(seed reels)와 충돌하여 V35로 이동)
ALTER TABLE cart_items ADD COLUMN offer_option_id BIGINT;
ALTER TABLE cart_items ADD COLUMN option_label VARCHAR(60);
ALTER TABLE cart_items
    ADD CONSTRAINT fk_cart_items_offer_option FOREIGN KEY (offer_option_id) REFERENCES offer_options(id);

-- 기존 (cart_id, offer_id) 유니크를 옵션 포함 유니크로 교체.
DROP INDEX uq_cart_items_cart_offer;
CREATE UNIQUE INDEX uq_cart_items_cart_offer_option ON cart_items(cart_id, offer_id, offer_option_id);

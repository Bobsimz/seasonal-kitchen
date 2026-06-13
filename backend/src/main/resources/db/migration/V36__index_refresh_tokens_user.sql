-- refresh_tokens 테이블은 V5에서 이미 생성됨. 여기서는 사용자별 조회/일괄 폐기를 위한 인덱스만 추가.
-- (인증 고도화 #6: refresh/logout. 원래 V33이었으나 팀의 V33__seed_curated_prices와 충돌하여 V36으로 이동)
CREATE INDEX idx_refresh_tokens_user ON refresh_tokens(user_id);

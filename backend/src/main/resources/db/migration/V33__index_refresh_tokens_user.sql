-- refresh_tokens 테이블은 V5에서 이미 생성됨. 여기서는 사용자별 조회/일괄 폐기를 위한 인덱스만 추가.
-- (인증 고도화 #6: refresh/logout 구현 시 사용)
CREATE INDEX idx_refresh_tokens_user ON refresh_tokens(user_id);

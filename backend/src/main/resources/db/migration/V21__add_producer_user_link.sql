-- 농가(생산자)를 사용자 계정과 연결. "마이페이지 → 농가로 등록" 흐름 지원.
-- 시드(V14) 농가들은 user_id가 NULL(운영자 시드). 자가등록 농가만 user_id를 가진다.
-- 한 사용자 = 한 농가 (NULL은 여러 개 허용되므로 일반 unique 인덱스로 충분).

ALTER TABLE producers ADD COLUMN user_id BIGINT;

ALTER TABLE producers
    ADD CONSTRAINT fk_producers_user FOREIGN KEY (user_id) REFERENCES users(id);

CREATE UNIQUE INDEX uq_producers_user ON producers(user_id);

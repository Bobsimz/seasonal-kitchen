-- V62: 시드(보여주기용) 농가 리뷰 제거 + 평점/리뷰수를 실제 리뷰 기준으로 리셋.
-- 배경: V14가 producers.rating/review_count를 가짜 집계값(예: 4.9/1280)으로 박고,
--       producer_reviews에는 정형 더미 리뷰 24건(producer 1~8, 3건씩)을 넣어 둠.
--       헤더 숫자(1280)와 실제 리뷰 행(3건)이 불일치 → 실제 백엔드와 맞춘다.
-- 시드 식별: 시드 리뷰는 author_name이 채워져 있고(예 '민지'), 실사용자 리뷰(createReview)는
--           userId만 쓰고 author_name=NULL이다. → author_name IS NOT NULL 인 행만 삭제(실제 리뷰 보존).
DELETE FROM producer_reviews WHERE author_name IS NOT NULL;

-- 남은(실제) 리뷰 기준으로 평점·리뷰수 재계산 — 백엔드 recomputeReviewStats()와 동일 규칙
-- (평균 소수 2자리 반올림, 리뷰 없으면 0/0). 시드 제거 후 대부분 0/0이 된다.
-- H2(PostgreSQL 모드)·Postgres 공통 호환을 위해 '::' 대신 CAST(...) 사용, 별칭 없이 테이블명 한정.
UPDATE producers SET
    review_count = COALESCE((SELECT COUNT(*) FROM producer_reviews r WHERE r.producer_id = producers.id), 0),
    rating = COALESCE((SELECT ROUND(CAST(AVG(r.rating) AS NUMERIC), 2) FROM producer_reviews r WHERE r.producer_id = producers.id), 0);

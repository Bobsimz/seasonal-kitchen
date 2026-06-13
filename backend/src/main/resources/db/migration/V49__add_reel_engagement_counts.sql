-- V49: 릴스 참여수(like/comment/save) baseline 컬럼 추가 + 조회수 기반 시드.
-- reel_reactions/comments 는 user_id NOT NULL FK라 COUNT 기반으론 사용자 수(14명) 이상 표현 불가.
-- 따라서 표시용 baseline 을 컬럼으로 둔다. 실제 표시값 = 이 baseline + 사용자 액션(reactions/comments)
-- (ReelService.toResponse, RecipeService.recipeLikes 에서 합산).
ALTER TABLE reels ADD COLUMN like_count BIGINT NOT NULL DEFAULT 0;
ALTER TABLE reels ADD COLUMN comment_count BIGINT NOT NULL DEFAULT 0;
ALTER TABLE reels ADD COLUMN save_count BIGINT NOT NULL DEFAULT 0;

-- 조회수 기반 추정(데모용): 좋아요≈4.2%, 댓글≈0.4%, 저장≈1.6%. like_count=0 가드로 멱등.
-- H2(PostgreSQL 모드)·Postgres 공통: CAST(FLOOR(...) AS BIGINT).
UPDATE reels SET
    like_count = CAST(FLOOR(view_count * 0.042) AS BIGINT),
    comment_count = CAST(FLOOR(view_count * 0.004) AS BIGINT),
    save_count = CAST(FLOOR(view_count * 0.016) AS BIGINT)
WHERE like_count = 0;

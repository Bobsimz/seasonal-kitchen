-- V46: 릴스 크리에이터 아바타(avatar_url) 백필.
-- 유튜브 채널(@oh_mechu, @food_radio) 공개 아바타를 S3(avatars/{id}.jpg)에 적재.
-- ReelService가 avatar_url을 MediaUrlResolver로 감싸므로 상대 키만 저장(reels/thumbnails와 동일 패턴).
-- creator id(V32 명시 1,2) 기준, avatar_url IS NULL 가드로 멱등.
UPDATE creators SET avatar_url='avatars/1.jpg' WHERE id=1 AND avatar_url IS NULL;
UPDATE creators SET avatar_url='avatars/2.jpg' WHERE id=2 AND avatar_url IS NULL;

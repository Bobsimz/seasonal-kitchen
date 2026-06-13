-- V62: recipe image_url 표기를 상대키로 정규화.
-- recipes.image_url 은 RecipeService 가 MediaUrlResolver.resolve() 로 감싸 CloudFront 도메인을
-- 런타임에 붙이므로 상대키(dishes/{id}.jpg)로 저장하는 것이 설계 의도다(V52 — 환경독립).
-- 그런데 한 건(id=9)만 절대 CloudFront URL 로 저장되어 표기가 불일치했다.
-- 절대 URL 도 resolver 가 그대로 통과시켜 서빙 결과는 동일하지만, DB 표기를 상대키로 통일해
-- 도메인 하드코딩(환경 의존)을 제거한다.
-- CloudFront 베이스 접두사만 벗겨 남는 상대키를 보존하고, 접두사 가드로 멱등성을 보장한다(재실행 시 0건).

UPDATE recipes
   SET image_url = regexp_replace(image_url, '^https://d1lcjrcsx3pn64\.cloudfront\.net/', '')
 WHERE image_url LIKE 'https://d1lcjrcsx3pn64.cloudfront.net/%';

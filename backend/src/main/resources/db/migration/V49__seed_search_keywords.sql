-- V49: 실시간 인기 검색어 시드 — search_keywords 가 비어 있어 GET /search/trending 이 항상 빈 배열을 반환하던 문제 해결.
-- search_count 는 사용자가 실제 검색할 때마다 +1 된다(SearchService.search). 여기서는 초기 노출용 baseline 만 심는다.
-- 키워드는 데모 폴백(frontend mock.trending)과 동일하게 맞춰, 백엔드 연결 여부와 무관하게 화면이 일관되도록 한다.
-- 멱등: keyword UNIQUE 제약 + NOT EXISTS 가드 (재실행 안전). 적용 후 수정 금지(Flyway 체크섬).

INSERT INTO search_keywords (keyword, search_count) SELECT '봄동',        1284 WHERE NOT EXISTS (SELECT 1 FROM search_keywords WHERE keyword='봄동');
INSERT INTO search_keywords (keyword, search_count) SELECT '무생채',      1102 WHERE NOT EXISTS (SELECT 1 FROM search_keywords WHERE keyword='무생채');
INSERT INTO search_keywords (keyword, search_count) SELECT '배추전',       968 WHERE NOT EXISTS (SELECT 1 FROM search_keywords WHERE keyword='배추전');
INSERT INTO search_keywords (keyword, search_count) SELECT '시금치 페스토', 845 WHERE NOT EXISTS (SELECT 1 FROM search_keywords WHERE keyword='시금치 페스토');
INSERT INTO search_keywords (keyword, search_count) SELECT '깍두기',       712 WHERE NOT EXISTS (SELECT 1 FROM search_keywords WHERE keyword='깍두기');
INSERT INTO search_keywords (keyword, search_count) SELECT '감귤',         603 WHERE NOT EXISTS (SELECT 1 FROM search_keywords WHERE keyword='감귤');

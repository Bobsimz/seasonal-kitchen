-- V67: 마늘쫑 상품(offer) 대표 이미지를 상품별 실제 사진으로 교체 (offer_photos.url 갱신, 데이터 전용).
-- V66 시드는 3개 offer가 모두 공유 ingredients/71.jpg를 가리켰음 → 상품별 사진(offers/{offer_id}/1.*)으로 분리.
-- 이미지 파일은 S3에 사전 업로드 완료. offer_photos.url 관례대로 절대 CloudFront URL. UPDATE만이라 멱등.
UPDATE offer_photos SET url='https://d1lcjrcsx3pn64.cloudfront.net/offers/2184/1.jpg' WHERE offer_id=2184 AND sort_order=0;
UPDATE offer_photos SET url='https://d1lcjrcsx3pn64.cloudfront.net/offers/2185/1.png' WHERE offer_id=2185 AND sort_order=0;
UPDATE offer_photos SET url='https://d1lcjrcsx3pn64.cloudfront.net/offers/2186/1.jpg' WHERE offer_id=2186 AND sort_order=0;

-- V53: 농가 대표 사진 26곳 photo_url 적재 (S3 producers/{id}.png → CloudFront 절대 URL)
-- producer.photo_url은 toCard/toDetail에서 MediaUrlResolver를 거치지 않고 그대로 반환되므로
-- (resolver도 절대 URL은 보존) 절대 URL로 저장한다. recipe(상대키 dishes/x.jpg)와 패턴이 다름.
-- 운영 DB에는 직접 UPDATE로 선반영됨 — 본 마이그레이션은 코드 기록/신규 환경 재현용.
-- 사진은 작물 기준으로 농가에 1:1 매칭(콩→권민성, 감귤→박정후, 굴→최영자, 배→푸른들농원 등).

UPDATE producers SET photo_url='https://d1lcjrcsx3pn64.cloudfront.net/producers/1.png' WHERE id=1;
UPDATE producers SET photo_url='https://d1lcjrcsx3pn64.cloudfront.net/producers/2.png' WHERE id=2;
UPDATE producers SET photo_url='https://d1lcjrcsx3pn64.cloudfront.net/producers/3.png' WHERE id=3;
UPDATE producers SET photo_url='https://d1lcjrcsx3pn64.cloudfront.net/producers/4.png' WHERE id=4;
UPDATE producers SET photo_url='https://d1lcjrcsx3pn64.cloudfront.net/producers/5.png' WHERE id=5;
UPDATE producers SET photo_url='https://d1lcjrcsx3pn64.cloudfront.net/producers/6.png' WHERE id=6;
UPDATE producers SET photo_url='https://d1lcjrcsx3pn64.cloudfront.net/producers/7.png' WHERE id=7;
UPDATE producers SET photo_url='https://d1lcjrcsx3pn64.cloudfront.net/producers/8.png' WHERE id=8;
UPDATE producers SET photo_url='https://d1lcjrcsx3pn64.cloudfront.net/producers/101.png' WHERE id=101;
UPDATE producers SET photo_url='https://d1lcjrcsx3pn64.cloudfront.net/producers/102.png' WHERE id=102;
UPDATE producers SET photo_url='https://d1lcjrcsx3pn64.cloudfront.net/producers/103.png' WHERE id=103;
UPDATE producers SET photo_url='https://d1lcjrcsx3pn64.cloudfront.net/producers/104.png' WHERE id=104;
UPDATE producers SET photo_url='https://d1lcjrcsx3pn64.cloudfront.net/producers/105.png' WHERE id=105;
UPDATE producers SET photo_url='https://d1lcjrcsx3pn64.cloudfront.net/producers/106.png' WHERE id=106;
UPDATE producers SET photo_url='https://d1lcjrcsx3pn64.cloudfront.net/producers/107.png' WHERE id=107;
UPDATE producers SET photo_url='https://d1lcjrcsx3pn64.cloudfront.net/producers/108.png' WHERE id=108;
UPDATE producers SET photo_url='https://d1lcjrcsx3pn64.cloudfront.net/producers/109.png' WHERE id=109;
UPDATE producers SET photo_url='https://d1lcjrcsx3pn64.cloudfront.net/producers/110.png' WHERE id=110;
UPDATE producers SET photo_url='https://d1lcjrcsx3pn64.cloudfront.net/producers/111.png' WHERE id=111;
UPDATE producers SET photo_url='https://d1lcjrcsx3pn64.cloudfront.net/producers/112.png' WHERE id=112;
UPDATE producers SET photo_url='https://d1lcjrcsx3pn64.cloudfront.net/producers/113.png' WHERE id=113;
UPDATE producers SET photo_url='https://d1lcjrcsx3pn64.cloudfront.net/producers/114.png' WHERE id=114;
UPDATE producers SET photo_url='https://d1lcjrcsx3pn64.cloudfront.net/producers/115.png' WHERE id=115;
UPDATE producers SET photo_url='https://d1lcjrcsx3pn64.cloudfront.net/producers/116.png' WHERE id=116;
UPDATE producers SET photo_url='https://d1lcjrcsx3pn64.cloudfront.net/producers/117.png' WHERE id=117;
UPDATE producers SET photo_url='https://d1lcjrcsx3pn64.cloudfront.net/producers/118.png' WHERE id=118;

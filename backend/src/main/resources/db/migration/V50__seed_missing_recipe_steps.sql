-- V50: 조리 단계 없던 레시피 149개에 조리 단계 시드.
-- 원본 숏츠에 단계 설명이 없던 레시피(steps_source=title_only/ingredients_only)에 대해,
-- 해당 음식의 실제 표준 레시피를 기존 단계와 동일 톤(평서형 ~다, 손질→조리→양념→마무리)으로 작성.
-- recipe_id 기준, (recipe_id, step_number) 미존재 가드로 멱등. minutes/image_url 은 NULL.

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 1, 1, '참치캔은 기름을 따라내고 마요네즈 2스푼을 넣어 고루 섞는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=1) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=1 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 1, 2, '쪽파는 송송 썰고, 청양고추는 잘게 다진다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=1) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=1 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 1, 3, '참치마요에 양조간장 1스푼, 쪽파, 청양고추를 넣고 고루 버무린다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=1) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=1 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 1, 4, '따뜻한 밥 위에 참치마요를 얹으면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=1) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=1 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 2, 1, '당근은 껍질을 벗겨 채칼로 곱게 채 썬다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=2) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=2 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 2, 2, '당근 채에 소금 1꼬집을 뿌려 5분간 절인 뒤 물기를 꼭 짜낸다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=2) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=2 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 2, 3, '올리브오일 2스푼, 식초 1스푼, 설탕 1/2스푼, 후추 약간을 섞어 드레싱을 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=2) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=2 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 2, 4, '당근에 드레싱을 넣고 고루 버무려 냉장고에 30분 이상 재우면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=2) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=2 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 3, 1, '무는 0.5cm 두께로 동그랗게 썬 뒤 소금을 살짝 뿌려 10분간 절이고 물기를 닦는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=3) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=3 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 3, 2, '무 앞뒤에 밀가루를 고루 묻히고 남은 가루를 털어낸다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=3) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=3 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 3, 3, '계란 1개를 풀어 달걀물을 만들고 무를 담가 옷을 입힌다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=3) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=3 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 3, 4, '달궈진 팬에 식용유를 두르고 중불에서 앞뒤 노릇하게 부쳐 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=3) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=3 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 4, 1, '피망은 씨를 제거하고 한 입 크기로 썰고, 베이컨은 2cm 폭으로 자른다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=4) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=4 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 4, 2, '달궈진 팬에 식용유 없이 베이컨을 먼저 넣고 중불에서 볶는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=4) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=4 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 4, 3, '베이컨 기름이 나오면 피망을 넣고 함께 볶는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=4) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=4 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 4, 4, '진간장 1스푼, 마요네즈 1스푼을 넣고 강불에서 빠르게 볶아 마무리한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=4) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=4 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 5, 1, '양배추는 굵게 채 썰어 끓는 물에 30초간 데친 뒤 물기를 짠다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=5) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=5 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 5, 2, '참치캔은 기름을 따라낸다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=5) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=5 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 5, 3, '고추장 1스푼, 간장 1스푼, 참기름 1스푼, 설탕 1/2스푼을 섞어 양념장을 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=5) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=5 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 5, 4, '밥 위에 양배추, 참치를 얹고 양념장을 올려 고루 비벼 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=5) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=5 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 6, 1, '대파는 송송 썰고, 계란 2개는 풀어 소금 1꼬집을 섞는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=6) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=6 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 6, 2, '달궈진 팬에 식용유를 충분히 두르고 대파를 넣어 중불에서 볶는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=6) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=6 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 6, 3, '대파가 숨이 죽으면 찬밥 1공기를 넣고 주걱으로 풀어가며 볶는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=6) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=6 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 6, 4, '계란물을 밥 위에 붓고 빠르게 섞으며 강불에서 볶는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=6) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=6 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 6, 5, '간장 1스푼으로 간을 맞추고 후추를 뿌려 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=6) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=6 AND step_number=5);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 7, 1, '오이는 0.3cm 두께로 어슷 썰고, 부추는 4cm 길이로 자른다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=7) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=7 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 7, 2, '오이에 소금 1/2스푼을 뿌려 5분간 절인 뒤 물기를 꼭 짠다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=7) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=7 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 7, 3, '고춧가루 1스푼, 간장 1스푼, 참기름 1스푼, 다진 마늘 1/2스푼, 설탕 1/2스푼을 섞는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=7) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=7 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 7, 4, '오이와 부추를 양념에 넣고 살살 버무리면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=7) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=7 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 9, 1, '시금치는 뿌리를 자르고 흐르는 물에 깨끗이 씻어 3cm 길이로 자른다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=9) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=9 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 9, 2, '냄비에 물 500ml를 끓이고 된장 1.5스푼을 풀어 넣는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=9) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=9 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 9, 3, '다진 마늘 1/2스푼을 넣고 2분간 더 끓인다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=9) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=9 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 9, 4, '시금치를 넣고 1분간 끓인 뒤 국간장으로 간을 맞추면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=9) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=9 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 12, 1, '소고기는 한 입 크기로 썰고, 무는 나박 썰고, 콩나물은 씻어 둔다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=12) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=12 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 12, 2, '냄비에 물 1/4컵을 넣고 소고기와 다진 마늘 1스푼을 넣어 중불에서 볶듯 익힌다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=12) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=12 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 12, 3, '고춧가루 1.5스푼, 국간장 2스푼, 진간장 1스푼을 넣고 한 번 더 볶는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=12) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=12 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 12, 4, '물 700ml를 붓고 무를 넣어 센불에서 끓인다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=12) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=12 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 12, 5, '무가 익으면 콩나물을 넣고 참치액 1스푼으로 간을 보정한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=12) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=12 AND step_number=5);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 12, 6, '대파를 송송 썰어 넣고 후추를 뿌려 한소끔 끓이면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=12) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=12 AND step_number=6);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 13, 1, '미나리는 4cm 길이로 잘라 씻어 두고, 청양고추와 홍고추는 어슷 썬다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=13) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=13 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 13, 2, '부침가루와 물을 1:1 비율로 섞어 반죽을 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=13) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=13 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 13, 3, '반죽에 미나리, 청양고추, 홍고추를 넣고 고루 섞는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=13) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=13 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 13, 4, '달궈진 팬에 식용유를 두르고 반죽을 얇게 펴 중불에서 앞뒤 노릇하게 굽는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=13) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=13 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 13, 5, '양조간장과 식초를 1:1로 섞은 초간장을 곁들이면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=13) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=13 AND step_number=5);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 17, 1, '감자는 껍질을 벗겨 푹 삶은 뒤 뜨거울 때 으깬다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=17) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=17 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 17, 2, '으깬 감자에 마요네즈 2스푼, 소금 1꼬집, 후추 약간을 넣고 고루 섞는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=17) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=17 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 17, 3, '식빵 한 면에 버터를 바르고 감자 필링을 듬뿍 올린다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=17) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=17 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 17, 4, '다른 식빵으로 덮고 먹기 좋은 크기로 잘라 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=17) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=17 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 21, 1, '새송이버섯은 0.5cm 두께로 어슷 썬 뒤 소금을 살짝 뿌려 밑간한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=21) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=21 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 21, 2, '버섯 앞뒤에 밀가루를 고루 묻히고 남은 가루를 털어낸다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=21) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=21 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 21, 3, '계란 1개를 풀어 달걀물을 만들고 버섯을 담가 옷을 입힌다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=21) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=21 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 21, 4, '달궈진 팬에 식용유를 두르고 중불에서 앞뒤 노릇하게 부쳐 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=21) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=21 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 24, 1, '토마토는 꼭지를 제거하고 8등분으로 썬다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=24) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=24 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 24, 2, '솥에 쌀 1컵을 씻어 담고 물을 평소보다 약간 적게 부은 뒤 토마토를 올린다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=24) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=24 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 24, 3, '올리브오일 1스푼, 소금 1꼬집을 뿌린다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=24) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=24 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 24, 4, '뚜껑을 덮고 중불에서 끓어오르면 약불로 줄여 15분간 뜸을 들인다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=24) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=24 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 24, 5, '다 익으면 토마토를 으깨듯 고루 섞어 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=24) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=24 AND step_number=5);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 26, 1, '애호박은 0.5cm 두께로 둥글게 썬 뒤 소금을 살짝 뿌려 5분간 절이고 물기를 닦는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=26) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=26 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 26, 2, '애호박 앞뒤에 밀가루를 고루 묻히고 남은 가루를 털어낸다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=26) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=26 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 26, 3, '계란 1개를 풀어 달걀물을 만들고 애호박을 담가 옷을 입힌다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=26) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=26 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 26, 4, '달궈진 팬에 식용유를 두르고 중불에서 앞뒤 노릇하게 부쳐 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=26) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=26 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 29, 1, '양배추와 당근은 잘게 다지고, 팽이버섯은 밑동을 제거해 찢어 둔다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=29) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=29 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 29, 2, '냄비에 물 600ml를 붓고 찬밥 1공기를 넣어 중불에서 끓인다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=29) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=29 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 29, 3, '양배추, 당근, 팽이버섯을 넣고 밥알이 퍼질 때까지 저어가며 끓인다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=29) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=29 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 29, 4, '계란 1개를 풀어 넣고 약불에서 저어가며 익힌다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=29) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=29 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 29, 5, '소금으로 간을 맞추고 참기름 1스푼, 깨를 뿌려 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=29) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=29 AND step_number=5);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 30, 1, '닭다리살은 한 입 크기로 썰고 소금, 후추로 밑간한 뒤 감자전분을 고루 묻힌다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=30) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=30 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 30, 2, '가지는 한 입 크기로 썰어 소금을 뿌려 5분간 절이고 물기를 닦는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=30) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=30 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 30, 3, '진간장 2스푼, 설탕 1.5스푼, 식초 1.5스푼, 물 3스푼, 생강즙 1/2스푼을 섞어 소스를 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=30) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=30 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 30, 4, '달궈진 팬에 식용유를 두르고 닭다리살을 중불에서 앞뒤 노릇하게 굽는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=30) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=30 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 30, 5, '가지를 넣어 함께 볶다가 소스를 붓고 강불에서 졸이듯 볶아 마무리한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=30) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=30 AND step_number=5);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 33, 1, '상추는 깨끗이 씻어 먹기 좋은 크기로 손으로 뜯어 둔다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=33) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=33 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 33, 2, '냄비에 물 500ml를 끓이고 된장 1.5스푼을 풀어 넣는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=33) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=33 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 33, 3, '다진 마늘 1/2스푼을 넣고 2분간 끓인다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=33) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=33 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 33, 4, '상추를 넣고 1분 이내로 살짝 끓여 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=33) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=33 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 34, 1, '애호박은 반달 모양으로 썰고, 베이컨은 2cm 폭으로 자른다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=34) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=34 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 34, 2, '달궈진 팬에 식용유 없이 베이컨을 먼저 볶아 기름을 낸다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=34) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=34 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 34, 3, '베이컨 기름에 애호박을 넣고 중불에서 투명해질 때까지 볶는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=34) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=34 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 34, 4, '소금, 후추로 간을 맞추고 참기름 1/2스푼을 둘러 마무리한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=34) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=34 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 37, 1, '깻잎은 줄기를 잘라 깨끗이 씻고, 청양고추는 잘게 다진다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=37) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=37 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 37, 2, '계란 2개를 풀고 소금 1꼬집, 참치액 1/2스푼, 다진 마늘 1/2스푼, 청양고추를 넣어 섞는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=37) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=37 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 37, 3, '달궈진 팬에 식용유를 두르고 깻잎을 펼쳐 올린 뒤 계란물을 골고루 붓는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=37) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=37 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 37, 4, '약불에서 뚜껑을 덮어 1분간 익힌 뒤 뒤집어 30초 더 익혀 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=37) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=37 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 39, 1, '감자는 껍질을 벗겨 곱게 채 썰고 찬물에 담가 전분을 뺀 뒤 물기를 꼭 짠다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=39) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=39 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 39, 2, '감자 채에 소금 1꼬집, 감자전분 1스푼을 넣고 고루 섞어 반죽처럼 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=39) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=39 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 39, 3, '달궈진 팬에 식용유를 넉넉히 두르고 감자 채를 얇게 펴 올린다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=39) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=39 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 39, 4, '중불에서 바닥이 노릇해지면 뒤집어 반대쪽도 바삭하게 부쳐 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=39) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=39 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 40, 1, '무는 껍질을 벗겨 나박 썬 뒤 씻어 둔다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=40) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=40 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 40, 2, '내열 그릇에 씻은 쌀 1컵, 무, 물을 넣고 전자레인지에서 10분간 익힌다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=40) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=40 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 40, 3, '중간에 한 번 꺼내 섞은 뒤 다시 5분 돌리고 5분간 뜸을 들인다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=40) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=40 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 40, 4, '간장 2스푼, 참기름 1스푼, 다진 파, 고춧가루 약간을 섞어 양념장을 만들어 곁들이면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=40) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=40 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 43, 1, '오이는 채 썰고, 참치캔은 기름을 따라낸다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=43) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=43 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 43, 2, '계란 1개를 프라이 또는 스크램블로 익혀 둔다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=43) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=43 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 43, 3, '밥 위에 오이, 참치, 계란을 얹는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=43) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=43 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 43, 4, '간장(또는 쯔유) 1스푼, 참기름 1스푼, 스리라차 1/2스푼을 뿌리고 고루 비벼 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=43) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=43 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 46, 1, '양배추는 한 입 크기로 썰고, 샤브샤브용 고기는 접시에 펼쳐 둔다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=46) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=46 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 46, 2, '냄비에 물을 붓고 코인육수 1개, 참치액 1스푼, 쯔유 1스푼을 넣어 끓인다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=46) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=46 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 46, 3, '육수가 끓으면 양배추와 고기를 넣어 살짝 익힌다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=46) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=46 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 46, 4, '양조간장 1스푼, 식초 1스푼, 설탕 1/2스푼을 섞어 소스를 만들어 곁들이면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=46) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=46 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 52, 1, '오이는 깨끗이 씻어 방망이나 칼 옆면으로 두드려 으깬 뒤 한 입 크기로 자른다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=52) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=52 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 52, 2, '오이에 소금 1/2스푼을 뿌려 5분간 절이고 물기를 꼭 짠다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=52) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=52 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 52, 3, '고춧가루 1스푼, 간장 1스푼, 참기름 1스푼, 다진 마늘 1/2스푼, 식초 1/2스푼을 섞는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=52) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=52 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 52, 4, '오이에 양념을 넣고 버무려 깨를 뿌리면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=52) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=52 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 53, 1, '절임배추는 잎 사이사이를 물로 한 번 헹궈 물기를 뺀다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=53) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=53 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 53, 2, '고춧가루 700g, 멸치액젓 200ml, 새우젓 100g, 다진 마늘 200g, 다진 생강 20g을 섞어 양념을 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=53) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=53 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 53, 3, '무는 가늘게 채 썰어 양념 일부와 먼저 버무려 소를 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=53) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=53 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 53, 4, '절임배추 잎 사이에 소를 켜켜이 채워 넣는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=53) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=53 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 53, 5, '겉잎으로 배추를 감싸 김치통에 차곡차곡 담아 실온에서 반나절 익힌 뒤 냉장 보관하면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=53) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=53 AND step_number=5);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 56, 1, '사과는 껍질을 벗기고 씨를 제거한 뒤 1cm 크기로 깍둑썬다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=56) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=56 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 56, 2, '냄비에 사과와 설탕 200g을 넣고 사과즙이 나올 때까지 30분 재운다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=56) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=56 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 56, 3, '중불에서 저어가며 끓이다 거품이 나면 걷어낸다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=56) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=56 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 56, 4, '레몬즙 2스푼과 계피가루 1/4티스푼을 넣고 약불에서 20분 더 졸인다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=56) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=56 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 56, 5, '잼이 걸쭉해지면 소독한 유리병에 담아 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=56) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=56 AND step_number=5);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 57, 1, '고구마는 껍질을 벗기고 강판에 갈거나 믹서기로 곱게 간다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=57) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=57 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 57, 2, '간 고구마에 소금 1/4티스푼을 넣고 잘 섞어 반죽을 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=57) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=57 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 57, 3, '달군 팬에 식용유를 두르고 반죽을 한 숟갈씩 올려 동그랗게 편다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=57) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=57 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 57, 4, '중불에서 한쪽 면이 노릇해지면 치즈를 올리고 뒤집어 치즈가 녹도록 굽는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=57) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=57 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 57, 5, '치즈가 완전히 녹으면 접시에 담아 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=57) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=57 AND step_number=5);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 61, 1, '감자는 껍질을 벗기고 얇게 채 썰어 소금물에 담갔다가 물기를 뺀다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=61) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=61 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 61, 2, '팬에 식용유를 두르고 감자채를 중불에서 투명해질 때까지 볶다가 소금, 후추로 간한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=61) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=61 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 61, 3, '또띠아 한 장을 팬에 올리고 감자볶음을 절반 면에 고르게 얹는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=61) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=61 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 61, 4, '또띠아를 반으로 접고 중불에서 양면을 눌러가며 노릇하게 굽는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=61) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=61 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 61, 5, '먹기 좋은 크기로 잘라 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=61) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=61 AND step_number=5);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 62, 1, '팽이버섯은 밑동을 자르고 먹기 좋게 찢어 준비한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=62) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=62 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 62, 2, '냄비에 물 600ml를 끓이고 국간장 1스푼, 소금으로 간한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=62) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=62 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 62, 3, '팽이버섯을 넣고 2분간 끓인다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=62) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=62 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 62, 4, '계란 2개를 풀어 냄비에 천천히 돌려 붓고 젓지 않고 30초 기다린다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=62) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=62 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 62, 5, '한 번 가볍게 저어 파를 송송 썰어 올리면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=62) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=62 AND step_number=5);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 63, 1, '감자는 껍질을 벗기고 1cm 두께로 납작하게 썰고, 햄은 같은 크기로 썬다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=63) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=63 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 63, 2, '팬에 식용유를 두르고 감자를 먼저 넣어 중불에서 앞뒤로 노릇하게 굽는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=63) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=63 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 63, 3, '감자가 거의 익으면 햄을 넣고 함께 볶는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=63) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=63 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 63, 4, '간장 1스푼, 설탕 1/2스푼, 후추 약간을 넣고 강불에서 빠르게 섞어 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=63) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=63 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 64, 1, '무는 껍질을 벗기고 0.3cm 두께로 얇게 채 썬다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=64) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=64 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 64, 2, '고춧가루 1.5스푼, 액젓 1스푼, 설탕 1/2스푼, 다진 마늘 1/2스푼, 식초 1스푼을 섞어 양념을 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=64) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=64 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 64, 3, '무채에 양념을 넣고 조물조물 버무린다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=64) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=64 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 64, 4, '참기름 1/2스푼과 깨를 뿌려 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=64) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=64 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 67, 1, '대파는 흰 부분 위주로 5cm 길이로 어슷 썬다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=67) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=67 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 67, 2, '달군 팬에 식용유를 두르고 대파를 넣어 중약불에서 천천히 굽는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=67) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=67 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 67, 3, '대파가 갈색으로 물들며 부드러워질 때까지 뒤집어가며 10분 정도 익힌다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=67) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=67 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 67, 4, '간장 1스푼, 설탕 1/2스푼, 참기름 1/2스푼을 넣고 버무리면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=67) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=67 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 68, 1, '팽이버섯은 밑동을 자르고 먹기 좋게 찢어 준비한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=68) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=68 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 68, 2, '달군 팬에 식용유를 두르고 팽이버섯을 넣어 중불에서 숨이 죽을 때까지 볶는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=68) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=68 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 68, 3, '고추장 1스푼, 간장 1스푼, 설탕 1/2스푼, 다진 마늘 1/2스푼, 고춧가루 1/2스푼을 넣고 고루 볶는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=68) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=68 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 68, 4, '밥 위에 볶은 팽이버섯을 얹고 참기름을 두르면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=68) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=68 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 70, 1, '고추장 1스푼, 진간장 2스푼, 고춧가루 1스푼, 설탕 1스푼, 미림 1스푼, 다진 마늘 1스푼, 후추 약간을 섞어 양념장을 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=70) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=70 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 70, 2, '대패삼겹살과 양파는 한 입 크기로 썰어 양념장에 20분 재운다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=70) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=70 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 70, 3, '넓은 팬을 강불로 달군 뒤 양념에 재운 고기와 양파를 넣고 센 불에서 볶는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=70) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=70 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 70, 4, '고기가 어느 정도 익으면 콩나물을 넣고 뚜껑을 덮어 2분간 숨을 죽인다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=70) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=70 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 70, 5, '대파를 넣고 함께 볶아 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=70) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=70 AND step_number=5);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 73, 1, '미나리는 다듬어 5cm 길이로 썰고, 오리고기는 한 입 크기로 자른다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=73) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=73 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 73, 2, '고추장 2스푼, 고춧가루 1스푼, 간장 1스푼, 설탕 1스푼, 다진 마늘 1스푼, 참기름 1스푼을 섞어 양념을 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=73) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=73 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 73, 3, '오리고기에 양념을 넣고 주물러 10분 이상 재운다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=73) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=73 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 73, 4, '달군 팬에 양념한 오리고기를 넣고 중불에서 앞뒤로 익힌다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=73) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=73 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 73, 5, '고기가 익으면 미나리를 넣고 살짝 볶아 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=73) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=73 AND step_number=5);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 74, 1, '애호박은 1cm 두께로 동그랗게 썰고 소금을 살짝 뿌려 10분 후 물기를 닦는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=74) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=74 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 74, 2, '애호박에 밀가루를 얇게 입히고 달걀물을 씌운 뒤 빵가루를 고르게 묻힌다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=74) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=74 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 74, 3, '170°C 기름에 애호박을 넣고 양면이 황금빛이 될 때까지 3분간 튀긴다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=74) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=74 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 74, 4, '기름을 뺀 뒤 접시에 담고 소금 또는 소스와 함께 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=74) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=74 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 76, 1, '감자는 껍질을 벗기고 한 입 크기로 썰어 물에 담가 전분을 뺀다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=76) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=76 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 76, 2, '냄비에 감자를 넣고 물 200ml, 간장 2스푼, 설탕 1스푼, 다진 마늘 1/2스푼을 넣어 중불에서 끓인다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=76) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=76 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 76, 3, '국물이 반으로 줄면 약불로 줄이고 감자가 부드러워질 때까지 졸인다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=76) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=76 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 76, 4, '참기름과 통깨를 뿌려 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=76) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=76 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 77, 1, '알배추는 먹기 좋은 크기로 찢고, 훈제오리는 한 입 크기로 썬다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=77) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=77 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 77, 2, '냄비 바닥에 알배추를 깔고 그 위에 훈제오리를 얹은 뒤 물 100ml와 진간장 1스푼, 후추 약간을 넣는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=77) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=77 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 77, 3, '뚜껑을 닫고 중약불에서 7분간 찐다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=77) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=77 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 77, 4, '식초 1스푼, 진간장 1스푼, 설탕 1/2스푼, 다진 양파, 청양고추를 섞어 소스를 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=77) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=77 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 77, 5, '찜이 완성되면 소스와 함께 담아 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=77) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=77 AND step_number=5);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 78, 1, '미나리는 다듬어 5cm로 썰고, 멍게는 한 입 크기로 자른다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=78) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=78 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 78, 2, '부침가루 100g에 물 150ml를 넣어 반죽하고 소금으로 간한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=78) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=78 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 78, 3, '반죽에 미나리와 멍게를 넣어 고루 섞는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=78) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=78 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 78, 4, '달군 팬에 식용유를 넉넉히 두르고 반죽을 부어 중불에서 노릇하게 굽는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=78) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=78 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 78, 5, '뒤집어 반대면도 바삭하게 구워 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=78) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=78 AND step_number=5);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 82, 1, '오이는 씨를 제거하고 김밥 길이로 가늘게 채 썰어 소금에 살짝 절인 뒤 물기를 뺀다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=82) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=82 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 82, 2, '명란은 껍질에서 알만 긁어내 참기름 1/2스푼과 섞는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=82) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=82 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 82, 3, '밥에 소금 약간과 참기름을 넣어 섞은 뒤 김 위에 고르게 편다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=82) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=82 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 82, 4, '밥 위에 명란과 오이를 나란히 올리고 단단하게 만다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=82) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=82 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 82, 5, '먹기 좋은 두께로 썰어 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=82) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=82 AND step_number=5);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 83, 1, '애호박은 반달 모양으로 썰고, 두부는 큼직하게 자른다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=83) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=83 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 83, 2, '냄비에 멸치 육수 600ml를 끓이고 된장 1.5스푼을 풀어 넣는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=83) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=83 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 83, 3, '애호박과 두부를 넣고 중불에서 5분간 끓인다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=83) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=83 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 83, 4, '고춧가루 1/2스푼, 다진 마늘 1/2스푼, 청양고추를 넣고 2분 더 끓여 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=83) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=83 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 84, 1, '팽이버섯은 밑동을 자르고 잘게 찢어 준비한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=84) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=84 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 84, 2, '계란 2개를 풀고 참치액 1스푼, 다진 마늘 1/2스푼을 넣어 섞는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=84) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=84 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 84, 3, '팽이버섯을 계란물에 넣고 고루 버무린다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=84) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=84 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 84, 4, '달군 팬에 식용유를 두르고 버섯 반죽을 동글납작하게 올려 중불에서 굽는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=84) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=84 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 84, 5, '양면이 노릇하게 익으면 접시에 담아 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=84) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=84 AND step_number=5);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 86, 1, '토마토는 씨를 제거하고 0.5cm 크기로 잘게 깍둑썬다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=86) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=86 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 86, 2, '양파는 잘게 다지고, 고수(또는 파)는 송송 썬다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=86) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=86 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 86, 3, '토마토, 양파, 고수를 볼에 넣고 레몬즙 1스푼, 소금, 후추로 간한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=86) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=86 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 86, 4, '취향에 따라 청양고추나 할라피뇨를 넣고 잘 섞어 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=86) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=86 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 89, 1, '파는 10cm 길이로 썰고, 오징어·새우 등 해물은 깨끗이 손질해 한 입 크기로 자른다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=89) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=89 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 89, 2, '부침가루 150g에 얼음물 200ml를 넣어 걸쭉하게 반죽한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=89) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=89 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 89, 3, '달군 팬에 기름을 넉넉히 두르고 파를 먼저 깔아 반죽을 붓는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=89) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=89 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 89, 4, '해물을 고르게 올리고 중강불에서 눌러가며 바삭하게 굽는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=89) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=89 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 89, 5, '뒤집어 반대면도 노릇하게 구워 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=89) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=89 AND step_number=5);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 91, 1, '팽이버섯은 밑동을 자르고 먹기 좋게 찢어 준비한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=91) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=91 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 91, 2, '달군 팬에 식용유를 두르고 팽이버섯을 넣어 중불에서 볶다가 간장 1스푼, 소금으로 간한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=91) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=91 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 91, 3, '볶은 팽이버섯을 한쪽으로 밀고 계란 2개를 깨 넣어 스크램블한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=91) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=91 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 91, 4, '밥 위에 팽이버섯과 스크램블에그를 얹고 참기름을 두르면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=91) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=91 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 94, 1, '무는 나박나박 썰고, 오징어는 껍질을 벗기고 링 모양으로 썬다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=94) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=94 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 94, 2, '냄비에 물 700ml를 끓이고 무를 넣어 5분간 끓여 국물을 낸다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=94) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=94 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 94, 3, '국간장 1.5스푼, 다진 마늘 1/2스푼, 소금으로 간한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=94) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=94 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 94, 4, '오징어를 넣고 3분간 더 끓여 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=94) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=94 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 95, 1, '얼갈이배추는 3cm 길이로 썰어 흐르는 물에 씻어 준비한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=95) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=95 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 95, 2, '냄비에 물 600ml를 끓이고 된장 1.5스푼을 풀어 넣는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=95) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=95 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 95, 3, '얼갈이배추를 넣고 중불에서 5분간 끓인다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=95) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=95 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 95, 4, '다진 마늘 1/2스푼, 국간장으로 간을 맞추고 한소끔 더 끓여 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=95) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=95 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 96, 1, '무는 가늘게 채 썰어 고춧가루, 액젓, 설탕, 다진 마늘, 식초로 무생채를 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=96) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=96 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 96, 2, '따뜻한 밥을 넓은 그릇에 담는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=96) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=96 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 96, 3, '밥 위에 무생채를 듬뿍 올리고 참기름을 두른다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=96) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=96 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 96, 4, '취향에 따라 달걀 프라이나 깨를 얹어 비벼 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=96) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=96 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 98, 1, '양배추는 굵게 채 썰고, 우삼겹은 먹기 좋은 크기로 자른다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=98) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=98 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 98, 2, '달군 팬에 우삼겹을 넣어 중강불에서 기름이 나오도록 볶다가 간장 1스푼, 설탕 1/2스푼, 다진 마늘 1/2스푼을 넣는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=98) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=98 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 98, 3, '양배추를 넣고 숨이 살짝 죽을 때까지 함께 볶는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=98) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=98 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 98, 4, '후추로 마무리하고 밥 위에 얹어 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=98) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=98 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 100, 1, '배추는 한 입 크기로 찢어 준비한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=100) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=100 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 100, 2, '고춧가루 1.5스푼, 액젓 1스푼, 다진 마늘 1/2스푼, 설탕 1/2스푼, 참기름 1/2스푼을 섞어 양념을 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=100) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=100 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 100, 3, '배추에 양념을 넣고 조물조물 무친다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=100) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=100 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 100, 4, '쪽파와 깨를 뿌려 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=100) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=100 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 101, 1, '가지는 0.5cm 두께로 어슷 썰어 소금을 살짝 뿌려 5분간 절인 뒤 물기를 닦는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=101) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=101 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 101, 2, '부침가루와 튀김가루를 1:1로 섞고 물을 넣어 묽지 않게 반죽한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=101) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=101 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 101, 3, '가지에 반죽을 고루 묻힌다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=101) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=101 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 101, 4, '달군 팬에 식용유를 두르고 중불에서 앞뒤로 노릇하게 지진다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=101) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=101 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 101, 5, '진간장과 식초를 1:1로 섞고 깨를 뿌려 찍어 먹는 양념장을 만들면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=101) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=101 AND step_number=5);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 102, 1, '브로콜리는 한 입 크기로 잘라 끓는 소금물에 1분간 데친 뒤 찬물에 헹궈 물기를 뺀다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=102) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=102 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 102, 2, '두부는 키친타월로 물기를 제거한 뒤 으깬다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=102) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=102 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 102, 3, '브로콜리와 으깬 두부에 소금 0.5스푼, 참기름 1스푼, 깨를 넣어 고루 무친다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=102) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=102 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 102, 4, '그릇에 담아 마무리한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=102) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=102 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 103, 1, '파채는 흐르는 물에 한 번 헹궈 매운기를 빼고 물기를 제거한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=103) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=103 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 103, 2, '진간장 1스푼, 식초 1스푼, 고춧가루 1스푼, 설탕 0.5스푼을 섞어 양념장을 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=103) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=103 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 103, 3, '파채에 양념장을 넣고 고루 버무리면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=103) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=103 AND step_number=3);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 106, 1, '새송이버섯은 결대로 손으로 찢거나 0.5cm 두께로 슬라이스한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=106) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=106 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 106, 2, '달군 팬에 식용유를 두르고 버섯을 넣어 중강불에서 노릇하게 굽듯 볶는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=106) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=106 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 106, 3, '진간장 1스푼, 다진마늘 0.5스푼, 참기름 0.5스푼을 넣고 골고루 볶아 마무리한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=106) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=106 AND step_number=3);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 107, 1, '애호박은 0.5cm 두께로 동그랗게 썰어 소금을 살짝 뿌려 5분 절인 뒤 물기를 닦는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=107) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=107 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 107, 2, '참치는 체에 밭쳐 기름을 제거한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=107) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=107 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 107, 3, '부침가루를 얇게 묻히고 달걀물(소금 한 꼬집 포함)을 입힌다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=107) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=107 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 107, 4, '애호박 위에 참치를 올리고 달걀물을 한 번 더 묻혀 중불 팬에서 앞뒤로 노릇하게 지지면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=107) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=107 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 110, 1, '브로콜리는 한 입 크기로 잘라 끓는 소금물에 1분간 살짝 데친 뒤 물기를 뺀다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=110) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=110 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 110, 2, '내열 용기에 브로콜리를 펼쳐 담고 소금·후추로 밑간한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=110) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=110 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 110, 3, '위에 피자치즈를 고루 올린다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=110) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=110 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 110, 4, '에어프라이어 200℃에서 5분 또는 오븐에서 180℃로 8분 구워 치즈가 녹으면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=110) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=110 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 111, 1, '깍두기(무)는 잘게 다져 기름 두른 팬에 먼저 볶아 새콤한 맛을 날린다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=111) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=111 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 111, 2, '깍두기 국물 2스푼, 고춧가루 0.5스푼, 참기름을 넣어 한번 더 볶는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=111) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=111 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 111, 3, '밥을 넣고 센불에서 골고루 볶는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=111) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=111 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 111, 4, '달걀 프라이를 따로 구워 위에 올리면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=111) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=111 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 113, 1, '고구마는 깨끗이 씻어 포크로 여러 군데 찌른 뒤 전자레인지에서 5분 익힌다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=113) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=113 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 113, 2, '익힌 고구마 윗부분을 가로로 칼집 내어 속을 살짝 눌러 공간을 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=113) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=113 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 113, 3, '버터 1조각을 올려 녹인 뒤 달걀 1개를 그 위에 깨뜨려 넣는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=113) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=113 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 113, 4, '전자레인지에서 달걀이 반숙이 될 때까지 1분 30초 더 가열하면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=113) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=113 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 116, 1, '무는 가늘게 채 썬다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=116) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=116 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 116, 2, '고춧가루 1스푼, 식초 1스푼, 설탕 0.5스푼, 소금 0.3스푼, 다진마늘 0.5스푼을 넣고 새콤달콤하게 무쳐 무생채를 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=116) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=116 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 116, 3, '따뜻한 밥을 그릇에 담고 무생채를 올린다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=116) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=116 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 116, 4, '참기름을 한 바퀴 두르고 깨를 뿌린 뒤 고루 비비면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=116) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=116 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 119, 1, '열무는 깨끗이 씻어 먹기 좋은 길이로 자른다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=119) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=119 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 119, 2, '고춧가루 1.5스푼, 액젓 1스푼, 다진마늘 0.5스푼, 설탕 0.5스푼, 식초 1스푼을 섞어 양념을 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=119) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=119 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 119, 3, '열무에 양념을 넣고 고루 버무려 열무겉절이를 준비한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=119) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=119 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 119, 4, '따뜻한 밥 위에 열무겉절이를 올리고 참기름을 뿌려 고루 비비면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=119) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=119 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 120, 1, '오이는 얇게 반달 썰고, 양파는 채 썬다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=120) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=120 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 120, 2, '고춧가루 1스푼, 액젓 1스푼, 식초 1스푼, 설탕 0.5스푼, 다진마늘 0.5스푼을 섞어 양념장을 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=120) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=120 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 120, 3, '오이와 양파에 양념장을 넣고 고루 버무린다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=120) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=120 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 120, 4, '깨를 뿌려 마무리한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=120) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=120 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 121, 1, '베이컨은 팬에 바삭하게 구워 키친타월에 올려 기름을 뺀다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=121) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=121 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 121, 2, '쪽파는 잘게 송송 썬다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=121) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=121 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 121, 3, '베이글은 반으로 가른 뒤 토스터 또는 팬에서 노릇하게 굽는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=121) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=121 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 121, 4, '구운 베이글 단면에 크림치즈를 넉넉히 바르고 베이컨과 쪽파를 얹으면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=121) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=121 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 122, 1, '쪽파는 잘게 송송 썰어 준비한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=122) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=122 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 122, 2, '팬에 버터를 녹이고 쪽파 흰 부분을 먼저 볶아 향을 낸다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=122) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=122 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 122, 3, '불린 쌀(또는 밥)을 넣고 육수(물+치킨스톡)를 조금씩 부어가며 쌀이 익을 때까지 저어가며 끓인다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=122) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=122 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 122, 4, '소금·후추로 간하고 파마산 치즈 2스푼, 버터 1조각을 넣어 섞는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=122) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=122 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 122, 5, '쪽파 초록 부분을 위에 올리면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=122) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=122 AND step_number=5);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 123, 1, '상추는 흐르는 물에 씻어 손으로 먹기 좋게 찢는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=123) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=123 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 123, 2, '고춧가루 1스푼, 진간장 1스푼, 식초 0.5스푼, 설탕 0.5스푼, 다진마늘 0.3스푼, 참기름 0.5스푼을 섞어 양념장을 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=123) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=123 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 123, 3, '먹기 직전 상추에 양념장을 넣고 살살 버무린다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=123) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=123 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 123, 4, '깨를 뿌려 마무리한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=123) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=123 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 126, 1, '배추는 한 입 크기로 썬다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=126) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=126 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 126, 2, '냄비에 물 700ml를 붓고 된장 1.5스푼을 풀어 끓인다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=126) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=126 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 126, 3, '국물이 끓으면 배추를 넣고 중불에서 배추가 투명해질 때까지 5분간 끓인다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=126) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=126 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 126, 4, '다진마늘 0.5스푼을 넣고 소금으로 간을 맞추면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=126) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=126 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 128, 1, '감자는 껍질을 벗겨 한 입 크기로 깍둑 썬다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=128) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=128 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 128, 2, '냄비에 물 700ml를 붓고 감자를 넣어 중불에서 끓인다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=128) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=128 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 128, 3, '감자가 반쯤 익으면 국간장 1스푼, 다진마늘 0.5스푼을 넣어 간한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=128) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=128 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 128, 4, '달걀을 풀어 국물에 천천히 둘러 붓고, 실파(또는 대파)를 올리면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=128) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=128 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 129, 1, '양배추는 가늘게 채 썰어 찬물에 10분 담갔다가 물기를 뺀다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=129) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=129 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 129, 2, '참치 1캔은 체에 밭쳐 기름을 제거한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=129) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=129 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 129, 3, '마요네즈 3스푼, 소금·후추 약간, 레몬즙(또는 식초) 0.5스푼을 섞어 드레싱을 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=129) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=129 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 129, 4, '양배추와 참치에 드레싱을 넣고 고루 버무리면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=129) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=129 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 133, 1, '감자는 껍질을 벗겨 큼직하게 잘라 끓는 물에 15분 삶아 부드럽게 익힌다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=133) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=133 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 133, 2, '삶은 감자를 체에 내리거나 포크로 으깬다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=133) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=133 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 133, 3, '마요네즈 3스푼, 설탕 0.5스푼, 소금·후추 약간, 식초 0.5스푼을 넣어 고루 섞는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=133) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=133 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 133, 4, '오이 슬라이스와 당근(얇게 썬 것)을 넣어 섞은 뒤 냉장고에서 20분 차갑게 두면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=133) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=133 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 134, 1, '양배추는 굵게 채 썬다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=134) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=134 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 134, 2, '달군 팬에 식용유를 두르고 다진마늘 0.5스푼을 볶아 향을 낸다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=134) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=134 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 134, 3, '양배추를 넣고 센불에서 숨이 살짝 죽을 때까지 볶는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=134) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=134 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 134, 4, '굴소스 1스푼, 진간장 0.5스푼, 후추 약간으로 간하고 참기름을 한 바퀴 둘러 마무리한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=134) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=134 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 138, 1, '진간장 4스푼, 정종 4스푼, 미림 4스푼, 설탕 1스푼을 섞어 스키야키 소스를 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=138) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=138 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 138, 2, '배추·양파·대파·청경채는 먹기 좋게 썰고, 두부는 도톰하게 슬라이스하며, 실곤약과 버섯도 준비한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=138) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=138 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 138, 3, '냄비에 소스와 물 100ml를 붓고 끓이다가 소고기를 먼저 넣어 익힌다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=138) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=138 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 138, 4, '준비한 채소, 두부, 실곤약, 버섯을 넣고 중불에서 끓인다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=138) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=138 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 138, 5, '날달걀을 작은 그릇에 풀어 익힌 재료를 찍어 먹으면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=138) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=138 AND step_number=5);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 141, 1, '통마늘은 칼 옆면으로 살짝 눌러 으깬다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=141) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=141 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 141, 2, '베이컨은 1cm 폭으로 썰고 계란은 풀어둔다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=141) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=141 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 141, 3, '달군 팬에 식용유를 두르고 마늘을 넣어 노릇하게 볶다가 베이컨을 넣고 함께 볶는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=141) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=141 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 141, 4, '밥을 넣고 센불에서 골고루 볶다가 굴소스 1스푼, 진간장 0.5스푼으로 간한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=141) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=141 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 141, 5, '달걀을 넣어 빠르게 볶아 익히면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=141) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=141 AND step_number=5);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 142, 1, '감자는 껍질을 벗겨 한 입 크기로 썬다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=142) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=142 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 142, 2, '고추장 1스푼, 진간장 1스푼, 설탕 1스푼, 다진마늘 0.5스푼, 물 100ml를 섞어 양념장을 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=142) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=142 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 142, 3, '팬에 감자를 넣고 양념장을 부어 중불에서 뚜껑을 덮고 10분간 익힌다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=142) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=142 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 142, 4, '뚜껑을 열고 양념이 자작해질 때까지 조리면서 깨를 뿌려 마무리한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=142) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=142 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 143, 1, '애호박은 반달 모양으로 0.5cm 두께로 썬다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=143) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=143 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 143, 2, '달군 팬에 식용유를 두르고 다진마늘 0.3스푼을 넣어 향을 낸다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=143) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=143 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 143, 3, '애호박을 넣고 중불에서 투명해질 때까지 볶는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=143) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=143 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 143, 4, '소금으로 간하고 참기름·깨를 뿌려 마무리한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=143) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=143 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 146, 1, '시금치는 뿌리를 다듬고 깨끗이 씻는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=146) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=146 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 146, 2, '끓는 소금물에 시금치를 30초간 데친 뒤 찬물에 헹궈 꼭 짠다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=146) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=146 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 146, 3, '진간장 0.5스푼, 다진마늘 0.3스푼, 참기름 0.5스푼, 깨 약간을 넣어 고루 무치면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=146) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=146 AND step_number=3);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 147, 1, '무는 나박하게 나박 썬다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=147) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=147 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 147, 2, '냄비에 물 700ml를 붓고 무를 넣어 중불에서 10분간 끓인다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=147) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=147 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 147, 3, '들깨가루 2스푼을 넣고 약불에서 5분 더 끓인다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=147) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=147 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 147, 4, '국간장 1스푼, 다진마늘 0.3스푼으로 간을 맞추면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=147) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=147 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 148, 1, '알배추는 먹기 좋은 크기로 채 썬 뒤 소금 1작은술을 뿌려 5분간 절인다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=148) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=148 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 148, 2, '절인 알배추를 손으로 꼭 짜 물기를 제거한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=148) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=148 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 148, 3, '고춧가루 1.5스푼, 액젓 1스푼, 다진 마늘 0.5스푼, 설탕 0.5스푼을 넣고 버무리면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=148) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=148 AND step_number=3);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 149, 1, '두부는 한입 크기로 썰어 키친타월로 물기를 닦는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=149) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=149 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 149, 2, '오이는 반달 모양으로 슬라이스한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=149) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=149 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 149, 3, '접시에 두부, 오이, 젓갈을 보기 좋게 담아 삼합으로 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=149) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=149 AND step_number=3);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 156, 1, '양파는 껍질을 벗겨 적당한 두께로 슬라이스한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=156) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=156 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 156, 2, '물·진간장·식초·설탕을 1:1:1:1 비율로 섞어 절임물을 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=156) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=156 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 156, 3, '절임물을 냄비에 끓여 한 번 식힌 뒤 양파에 붓는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=156) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=156 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 156, 4, '뚜껑을 덮어 냉장고에서 하루 이상 숙성하면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=156) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=156 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 157, 1, '냉동새우는 찬물에 해동하고, 부추는 4cm 길이로 썰고, 청양고추는 송송 썬다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=157) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=157 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 157, 2, '부침가루에 물을 넣어 반죽을 만들고 부추, 새우, 청양고추를 넣어 섞는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=157) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=157 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 157, 3, '팬에 식용유를 두르고 반죽을 떠서 올린 뒤 중불에서 앞뒤로 노릇하게 굽는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=157) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=157 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 157, 4, '바삭하게 익으면 접시에 담아 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=157) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=157 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 161, 1, '토마토는 꼭지 쪽에 십자 칼집을 넣어 속 재료가 잘 배도록 준비한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=161) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=161 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 161, 2, '고춧가루 1스푼, 설탕 0.5스푼, 소금 약간, 다진 마늘 0.5스푼을 섞어 속재료를 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=161) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=161 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 161, 3, '칼집 낸 부분에 양념을 채워 넣어 냉장고에서 30분 이상 재운다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=161) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=161 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 161, 4, '접시에 담아 매콤달콤한 토마토소박이 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=161) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=161 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 162, 1, '고구마는 껍질을 벗겨 얇게 슬라이스한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=162) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=162 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 162, 2, '팬에 식용유를 살짝 두르고 고구마를 한 층으로 깔아 약불에서 천천히 익힌다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=162) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=162 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 162, 3, '고구마가 바닥에 눌어 노릇하게 굳으면 뒤집어 반대쪽도 익힌다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=162) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=162 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 162, 4, '바삭하고 구수하게 익으면 접시에 담아 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=162) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=162 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 163, 1, '파스타 면은 소금물에 넣어 알 덴테로 삶아 건진다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=163) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=163 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 163, 2, '팬에 버터 20g을 녹이고 다진 마늘을 넣어 약불에서 향을 낸다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=163) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=163 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 163, 3, '삶은 면을 팬에 넣고 레몬즙 2스푼, 레몬 제스트 1작은술을 넣어 볶는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=163) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=163 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 163, 4, '소금·후추로 간을 맞추고 파마산 치즈를 갈아 올려 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=163) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=163 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 164, 1, '배추는 길게 반 갈라 소금물에 30분간 절인 뒤 씻어 물기를 뺀다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=164) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=164 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 164, 2, '오리고기는 먹기 좋은 크기로 썰고 소금·후추로 밑간한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=164) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=164 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 164, 3, '냄비 바닥에 배추를 깔고 그 위에 오리고기를 얹어 물 1컵을 붓는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=164) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=164 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 164, 4, '뚜껑을 덮고 중불에서 20분간 쪄낸다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=164) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=164 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 164, 5, '다진 마늘, 간장 1스푼으로 간을 맞추어 마무리한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=164) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=164 AND step_number=5);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 165, 1, '고구마는 삶거나 쪄서 껍질을 벗기고 으깬 뒤 설탕 1스푼을 넣어 반죽한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=165) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=165 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 165, 2, '밀가루, 이스트, 따뜻한 물, 설탕, 소금을 섞어 호떡 반죽을 만들어 30분 발효한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=165) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=165 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 165, 3, '반죽을 납작하게 펴고 가운데 고구마 소를 넣어 오므려 동그랗게 빚는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=165) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=165 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 165, 4, '팬에 식용유를 두르고 반죽을 올려 눌러가며 앞뒤 노릇하게 굽는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=165) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=165 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 165, 5, '바삭하게 익으면 접시에 담아 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=165) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=165 AND step_number=5);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 166, 1, '고구마는 삶아 껍질을 벗기고 으깨어 설탕 1스푼, 버터 10g을 넣고 섞는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=166) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=166 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 166, 2, '찹쌀가루에 따뜻한 물을 조금씩 넣으며 반죽한 뒤 고구마 소를 넣어 동그랗게 빚는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=166) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=166 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 166, 3, '빚은 반죽에 깨를 고루 묻힌다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=166) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=166 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 166, 4, '팬에 식용유를 두르고 약중불에서 뒤집어가며 골고루 익힌다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=166) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=166 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 166, 5, '속까지 완전히 익으면 접시에 담아 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=166) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=166 AND step_number=5);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 167, 1, '새우는 씻어 손질하고, 애호박은 반달 모양으로 썬다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=167) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=167 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 167, 2, '팬에 식용유를 두르고 새우를 볶다가 색이 바뀌면 애호박을 넣고 함께 볶는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=167) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=167 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 167, 3, '소금·후추로 간하고 참기름을 한 방울 둘러 향을 낸다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=167) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=167 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 167, 4, '따뜻한 밥 위에 볶음을 올려 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=167) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=167 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 168, 1, '양배추는 굵게 채 썰고, 파스타 면은 소금물에 삶아 건진다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=168) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=168 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 168, 2, '팬에 식용유를 두르고 양배추를 센불에서 볶다가 면을 넣고 함께 볶는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=168) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=168 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 168, 3, '간장 1.5스푼, 굴소스 1스푼, 후추 약간을 넣어 야끼소바 풍으로 양념한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=168) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=168 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 168, 4, '가쓰오부시나 파를 올려 마무리한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=168) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=168 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 169, 1, '감자는 껍질을 벗겨 납작하게 썬 뒤 찬물에 담가 전분을 뺀다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=169) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=169 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 169, 2, '물기를 닦은 감자에 소금 약간 뿌리고 전분가루를 골고루 묻힌다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=169) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=169 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 169, 3, '160도 기름에 감자를 1차로 튀겨 속을 익힌다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=169) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=169 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 169, 4, '180도로 온도를 올려 2차 튀김으로 겉을 바삭하게 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=169) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=169 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 170, 1, '팽이버섯은 밑동을 잘라 먹기 좋게 가른다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=170) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=170 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 170, 2, '간장 1.5스푼, 설탕 0.5스푼, 다진 마늘 0.5스푼, 참기름 0.5스푼을 섞어 불고기 양념을 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=170) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=170 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 170, 3, '팬에 식용유를 두르고 팽이버섯을 넣어 중불에서 볶는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=170) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=170 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 170, 4, '양념을 넣고 버섯이 숨이 죽을 때까지 볶아 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=170) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=170 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 171, 1, '사과는 깨끗이 씻어 얇게 슬라이스한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=171) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=171 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 171, 2, '슬라이스한 사과를 채반에 펼쳐 바람이 잘 통하는 곳에서 반나절 건조한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=171) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=171 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 171, 3, '건조한 사과 슬라이스를 찻잔에 넣고 뜨거운 물 200ml를 부어 3분간 우린다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=171) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=171 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 171, 4, '기호에 따라 꿀을 조금 넣어 사과꽃차 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=171) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=171 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 172, 1, '당근은 껍질을 벗기고 채칼로 가늘게 채 썬다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=172) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=172 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 172, 2, '채 썬 당근에 소금 0.5작은술을 뿌려 5분간 절인 뒤 물기를 꼭 짠다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=172) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=172 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 172, 3, '식초 1.5스푼, 설탕 1스푼, 올리브유 1스푼, 후추 약간을 섞어 드레싱을 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=172) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=172 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 172, 4, '당근에 드레싱을 넣고 버무린 뒤 냉장고에서 30분 숙성하면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=172) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=172 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 173, 1, '토마토는 한입 크기로 썰고, 계란은 소금 약간 넣어 풀어둔다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=173) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=173 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 173, 2, '팬에 식용유를 두르고 달군 뒤 계란을 넣어 반숙 상태로 볶아 꺼낸다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=173) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=173 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 173, 3, '같은 팬에 토마토를 넣고 중불에서 볶다가 물 1컵을 부어 끓인다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=173) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=173 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 173, 4, '볶아둔 계란을 다시 넣고 소금, 설탕 0.5스푼으로 간을 맞춰 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=173) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=173 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 174, 1, '두부는 한입 크기로 썰고, 오이는 얇게 슬라이스하고, 명란은 껍질을 제거한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=174) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=174 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 174, 2, '따뜻한 밥을 그릇에 담고 두부, 오이, 명란을 보기 좋게 올린다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=174) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=174 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 174, 3, '간장 1스푼, 참기름 0.5스푼, 고춧가루 약간을 섞어 양념장을 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=174) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=174 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 174, 4, '양념장을 뿌리고 비벼 먹으면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=174) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=174 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 175, 1, '감자는 껍질을 벗겨 굵게 갈거나 채 썬 뒤 전분이 가라앉도록 찬물에 5분 담근다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=175) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=175 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 175, 2, '물을 따라 버리고 남은 전분과 감자를 섞어 소금 약간으로 간한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=175) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=175 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 175, 3, '팬에 식용유를 넉넉히 두르고 반죽을 납작하게 올려 중불에서 굽는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=175) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=175 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 175, 4, '한 면이 노릇하게 굳으면 뒤집어 반대쪽도 바삭하게 구워 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=175) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=175 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 176, 1, '오이는 씻어 얇게 어슷썰기 한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=176) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=176 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 176, 2, '라면을 끓는 물에 넣어 면이 거의 익으면 오이 슬라이스를 넣는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=176) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=176 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 176, 3, '스프를 넣고 1분 더 끓여 오이 향이 배도록 한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=176) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=176 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 176, 4, '그릇에 담고 기호에 따라 참기름을 한 방울 둘러 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=176) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=176 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 177, 1, '수박은 세로로 반 갈라 한쪽 면이 평평하게 놓이도록 한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=177) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=177 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 177, 2, '수박 속살을 격자 모양으로 일정하게 칼집을 넣어 테트리스 블록 모양을 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=177) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=177 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 177, 3, '칼집 낸 속살을 위로 밀어 올리듯 한 블록씩 분리되도록 살짝 벌린다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=177) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=177 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 177, 4, '접시에 담으면 쏙쏙 집어 먹기 편한 수박테트리스 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=177) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=177 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 178, 1, '알배추는 먹기 좋은 크기로 잘라 찬물에 씻은 뒤 물기를 뺀다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=178) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=178 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 178, 2, '마요네즈 1.5스푼, 식초 1스푼, 설탕 0.5스푼, 소금 약간을 섞어 드레싱을 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=178) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=178 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 178, 3, '알배추에 드레싱을 뿌리고 가볍게 버무려 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=178) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=178 AND step_number=3);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 179, 1, '사과는 씨를 제거하고 한입 크기로 깍뚝썰기 한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=179) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=179 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 179, 2, '레몬즙 1스푼, 꿀 1스푼, 올리브유 0.5스푼을 섞어 드레싱을 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=179) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=179 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 179, 3, '사과에 드레싱을 넣고 가볍게 버무린 뒤 견과류나 크랜베리를 올려 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=179) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=179 AND step_number=3);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 180, 1, '감자는 삶아 껍질을 벗기고 으깨어 소금 약간으로 간한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=180) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=180 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 180, 2, '라이스페이퍼를 물에 적셔 부드럽게 불린 뒤 도마에 편다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=180) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=180 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 180, 3, '라이스페이퍼 위에 으깬 감자를 올리고 단단하게 감싸 빵 모양으로 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=180) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=180 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 180, 4, '팬에 식용유를 두르고 겉면이 노릇하게 구워 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=180) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=180 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 182, 1, '고구마는 삶거나 쪄서 껍질을 벗기고 한입 크기로 썬다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=182) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=182 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 182, 2, '버터 10g을 팬에 녹이고 고구마를 넣어 약불에서 겉면을 살짝 볶는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=182) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=182 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 182, 3, '설탕 1스푼을 뿌려 고구마에 윤기가 돌도록 졸인다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=182) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=182 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 182, 4, '슬라이스 치즈나 모차렐라 치즈를 올리고 뚜껑을 덮어 녹인 뒤 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=182) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=182 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 183, 1, '오이는 채칼로 얇게 슬라이스한 뒤 소금 약간을 뿌려 5분간 절인다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=183) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=183 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 183, 2, '면은 끓는 물에 삶아 찬물에 헹구어 물기를 뺀다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=183) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=183 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 183, 3, '간장 2스푼, 식초 2스푼, 설탕 1스푼, 참기름 1스푼으로 양념장을 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=183) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=183 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 183, 4, '절인 오이로 면을 돌돌 말아 그릇에 담고 양념장을 끼얹으면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=183) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=183 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 184, 1, '고구마는 껍질을 벗기고 찜기에 쪄서 완전히 익힌다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=184) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=184 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 184, 2, '뜨거운 고구마를 으깨어 설탕 1스푼, 버터 1/2스푼을 넣고 부드럽게 반죽한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=184) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=184 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 184, 3, '또띠아 위에 고구마 반죽을 펴 바르고 슬라이스 치즈를 올린다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=184) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=184 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 184, 4, '또띠아를 돌돌 말아 팬에 굴려 앞뒤로 노릇하게 구우면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=184) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=184 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 185, 1, '감자는 껍질을 벗기고 삶아 으깬 뒤 소금·버터로 간해 매쉬드포테이토를 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=185) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=185 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 185, 2, '브로콜리는 한 송이씩 잘라 소금물에 데친다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=185) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=185 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 185, 3, '크래커 위에 매쉬드포테이토를 별 모양으로 짜 올린다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=185) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=185 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 185, 4, '데친 브로콜리를 트리 모양으로 꽂고 작은 채소로 장식하면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=185) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=185 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 186, 1, '배추는 큼직하게 잘라 소금물에 살짝 절인 뒤 물기를 짜낸다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=186) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=186 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 186, 2, '소고기(우삼겹 또는 불고기용) 100g은 간장 1스푼, 다진 마늘 1/2스푼으로 밑간한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=186) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=186 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 186, 3, '냄비에 배추를 깔고 밑간한 소고기를 올려 물 1/2컵을 붓는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=186) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=186 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 186, 4, '뚜껑을 닫고 중약불에서 15분간 쪄내면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=186) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=186 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 187, 1, '수박 껍질의 초록 외피는 제거하고 흰 부분만 잘게 깍둑썬다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=187) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=187 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 187, 2, '냄비에 수박 껍질, 설탕 1컵, 레몬즙 2스푼을 넣고 30분간 재워둔다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=187) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=187 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 187, 3, '중불에서 저으며 끓이고, 거품이 오르면 걷어낸다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=187) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=187 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 187, 4, '껍질이 투명해지고 잼 농도가 되면 병에 담아 마무리한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=187) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=187 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 188, 1, '닭가슴살은 소금물에 삶아 완전히 익힌 뒤 결대로 찢는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=188) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=188 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 188, 2, '오이는 채 썰어 소금 약간을 뿌려 5분 절인 뒤 물기를 짜낸다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=188) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=188 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 188, 3, '간장 2스푼, 식초 1스푼, 설탕 1스푼, 와사비 1/2스푼, 참기름 1스푼으로 냉채 소스를 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=188) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=188 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 188, 4, '닭가슴살과 오이를 그릇에 담고 소스를 뿌려 고루 버무리면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=188) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=188 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 189, 1, '감자는 껍질을 벗기고 강판에 갈아 면포로 물기를 꼭 짠다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=189) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=189 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 189, 2, '감자 간 것에 소금 약간, 전분 1스푼을 넣고 잘 섞는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=189) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=189 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 189, 3, '팬에 식용유를 두르고 감자 반죽을 얇고 둥글게 펴 중약불에서 바삭하게 굽는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=189) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=189 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 189, 4, '뒤집어 반대편도 굽고, 치즈를 올려 녹인 뒤 불을 끄면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=189) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=189 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 190, 1, '상추는 깨끗이 씻어 끓는 물에 10초간 데쳐 찬물에 헹군다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=190) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=190 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 190, 2, '데친 상추의 물기를 살짝 짠 뒤 넓게 펼쳐 놓는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=190) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=190 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 190, 3, '밥에 참기름·소금·깨를 넣고 고슬하게 양념해 주먹밥을 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=190) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=190 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 190, 4, '상추 위에 주먹밥을 올려 단단히 감싸 쌈밥을 만들면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=190) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=190 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 191, 1, '양배추는 채 썰고, 김은 가위로 잘게 잘라둔다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=191) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=191 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 191, 2, '양배추를 소금물에 살짝 절인 뒤 물기를 손으로 가볍게 짜낸다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=191) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=191 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 191, 3, '양배추와 김을 볼에 담고 참기름 2스푼, 소금 약간, 통깨를 넣는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=191) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=191 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 191, 4, '재료를 고루 버무리면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=191) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=191 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 192, 1, '사과는 껍질을 벗기고 얇게 슬라이스해 꽃 모양으로 말아 준비한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=192) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=192 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 192, 2, '젤라틴 5g을 찬물에 불린 뒤 뜨거운 물 100ml에 녹인다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=192) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=192 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 192, 3, '꿀 2스푼과 젤라틴 물을 섞어 틀에 붓고 사과 슬라이스를 올린다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=192) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=192 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 192, 4, '냉장고에서 2시간 이상 굳히면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=192) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=192 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 193, 1, '당근은 껍질을 벗기고 채칼로 가늘게 채 썬다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=193) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=193 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 193, 2, '채 썬 당근에 소금 1/2스푼을 뿌려 10분간 절인 뒤 물기를 꼭 짠다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=193) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=193 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 193, 3, '올리브오일 2스푼, 레몬즙 2스푼, 설탕 1스푼, 식초 1스푼, 소금·후추로 드레싱을 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=193) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=193 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 193, 4, '당근에 드레싱을 넣어 버무리고 냉장고에서 30분 숙성하면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=193) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=193 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 194, 1, '돼지고기(보쌈용 앞다리살)는 찬물에 30분 담가 핏물을 제거한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=194) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=194 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 194, 2, '냄비에 물을 충분히 붓고 된장 1스푼, 마늘 10알, 생강 약간을 넣어 끓인다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=194) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=194 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 194, 3, '물이 끓으면 돼지고기를 넣어 중불에서 40~50분 삶는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=194) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=194 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 194, 4, '고기를 꺼내 한 김 식힌 뒤 얇게 썰고 삶은 마늘과 함께 곁들이면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=194) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=194 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 195, 1, '오이는 양끝을 자르고 젓가락 2개를 오이 양쪽에 받쳐 사선으로 칼집을 촘촘히 낸다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=195) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=195 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 195, 2, '반대편도 같은 방법으로 칼집 내어 아코디언 모양으로 늘린다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=195) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=195 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 195, 3, '간장 1스푼, 식초 2스푼, 설탕 1스푼, 고춧가루 1/2스푼, 참기름 1스푼으로 양념을 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=195) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=195 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 195, 4, '오이에 양념을 고루 바르고 냉장고에서 20분 절이면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=195) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=195 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 196, 1, '감자는 껍질을 벗겨 삶아 으깨고, 김치는 잘게 다진다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=196) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=196 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 196, 2, '으깬 감자와 다진 김치를 섞고 소금으로 간해 골프공 크기로 동그랗게 빚는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=196) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=196 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 196, 3, '감자볼 안에 치즈를 한 조각씩 넣고 표면을 매끄럽게 다듬는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=196) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=196 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 196, 4, '팬에 식용유를 두르고 감자볼을 굴려가며 고르게 노릇하게 구우면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=196) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=196 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 197, 1, '돼지등뼈는 찬물에 1시간 이상 담가 핏물을 제거한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=197) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=197 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 197, 2, '끓는 물에 등뼈를 넣어 5분간 데친 뒤 건져 흐르는 물에 헹군다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=197) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=197 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 197, 3, '냄비에 등뼈, 물 2L, 된장 2스푼, 간장 1스푼, 다진 마늘 2스푼을 넣고 센 불로 끓인다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=197) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=197 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 197, 4, '끓어오르면 중불로 줄여 1시간 더 끓이다가 감자를 넣어 20분 더 익힌다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=197) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=197 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 197, 5, '겨자·식초를 곁들여 상에 내면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=197) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=197 AND step_number=5);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 199, 1, '사과는 껍질을 벗기고 잘게 깍둑썰어 내열 용기에 담는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=199) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=199 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 199, 2, '사과에 설탕 3스푼, 레몬즙 1스푼을 넣어 골고루 버무린다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=199) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=199 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 199, 3, '전자레인지에 넣고 3분 가열한 뒤 꺼내 고루 저어준다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=199) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=199 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 199, 4, '다시 2~3분 가열해 잼 농도가 되면 식혀 병에 담아 마무리한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=199) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=199 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 200, 1, '오이는 깨끗이 씻어 도마 위에 놓고 칼로 세게 두드려 어슷하게 뜯는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=200) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=200 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 200, 2, '간장 2스푼, 식초 2스푼, 설탕 1스푼, 고춧가루 1스푼, 다진 마늘 1/2스푼, 참기름 1스푼으로 양념을 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=200) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=200 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 200, 3, '오이에 소금을 약간 뿌려 5분 절인 뒤 물기를 짜낸다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=200) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=200 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 200, 4, '양념을 넣어 고루 버무리고 통깨를 뿌리면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=200) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=200 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 201, 1, '수박은 껍질을 제거하고 한 입 크기의 삼각형 또는 큐브로 썬다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=201) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=201 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 201, 2, '페타치즈는 손으로 크게 부숴 수박 위에 올린다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=201) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=201 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 201, 3, '올리브오일을 두르고 후추를 살짝 뿌린다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=201) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=201 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 201, 4, '민트 잎을 올려 마무리한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=201) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=201 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 202, 1, '새송이버섯은 먹기 좋은 크기로 손으로 찢거나 큼직하게 썬다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=202) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=202 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 202, 2, '팬에 버터 1/2스푼을 녹이고 새송이버섯을 넣어 중불에서 노릇하게 굽는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=202) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=202 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 202, 3, '간장 1스푼, 꿀 1.5스푼, 다진 마늘 1/2스푼을 섞어 소스를 만들어 붓는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=202) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=202 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 202, 4, '소스가 버섯에 고루 배도록 볶다가 통깨를 뿌리면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=202) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=202 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 203, 1, '토마토는 꼭지를 제거하고 큼직하게 깍둑썬다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=203) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=203 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 203, 2, '면은 끓는 물에 삶아 찬물에 헹구어 물기를 뺀다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=203) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=203 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 203, 3, '간장 3스푼, 식초 2스푼, 설탕 1스푼, 참기름 1스푼, 다진 마늘 1/2스푼으로 냉국수 소스를 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=203) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=203 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 203, 4, '그릇에 면을 담고 토마토를 올린 뒤 소스를 끼얹으면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=203) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=203 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 204, 1, '사과는 깨끗이 씻어 껍질째 또는 필러로 껍질을 벗긴다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=204) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=204 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 204, 2, '사과를 4~6등분하고 씨를 제거한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=204) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=204 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 204, 3, '토끼·별·꽃 등 원하는 모양으로 껍질을 V자 또는 곡선으로 칼집 내어 장식한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=204) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=204 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 204, 4, '소금물에 살짝 담가 갈변을 방지하고 접시에 예쁘게 담으면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=204) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=204 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 205, 1, '알배추는 반으로 잘라 단면에 올리브오일을 고루 바른다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=205) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=205 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 205, 2, '소금·후추로 간하고 팬을 강불로 달군 뒤 단면이 아래로 가게 올린다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=205) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=205 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 205, 3, '눌리지 않게 2~3분 구워 노릇한 그릴 자국이 생기면 뒤집어 1~2분 더 굽는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=205) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=205 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 205, 4, '다진 마늘 1/2스푼, 간장 1스푼, 올리브오일을 섞은 소스를 뿌리면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=205) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=205 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 206, 1, '오이는 씨를 제거하고 채 썰고, 크래미는 결대로 찢는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=206) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=206 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 206, 2, '밥은 식초 1스푼, 설탕 1/2스푼, 소금 약간으로 양념해 고슬하게 식힌다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=206) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=206 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 206, 3, '김 위에 양념밥을 얇게 펴고 오이와 크래미를 나란히 올린다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=206) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=206 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 206, 4, '단단히 돌돌 말아 한 입 크기로 썰면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=206) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=206 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 207, 1, '두부는 키친타월로 물기를 제거하고, 오이는 반달 모양으로 썬다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=207) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=207 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 207, 2, '참치캔은 기름을 따라내고, 오이는 소금 약간으로 절인 뒤 물기를 짠다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=207) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=207 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 207, 3, '두부를 손으로 으깨어 참치, 오이와 함께 볼에 담는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=207) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=207 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 207, 4, '마요네즈 2스푼, 소금·후추로 간해 고루 버무리면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=207) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=207 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 208, 1, '당근은 껍질을 벗기고 강판에 곱게 갈거나 잘게 채 썬다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=208) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=208 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 208, 2, '팬에 식용유를 두르고 다진 마늘 1스푼과 당근을 넣어 중불에서 충분히 볶는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=208) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=208 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 208, 3, '물 2컵을 붓고 춘장 2스푼, 굴소스 1스푼을 넣어 잘 풀어가며 끓인다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=208) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=208 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 208, 4, '전분물(전분 1스푼+물 2스푼)로 농도를 맞추고 삶은 면 위에 부으면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=208) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=208 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 209, 1, '알배추는 뿌리째 4등분하여 단면이 평평하게 되도록 다듬는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=209) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=209 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 209, 2, '팬에 식용유를 두르고 중불로 달군 뒤 알배추 단면을 아래로 올려 뚜껑을 덮고 3분간 굽는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=209) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=209 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 209, 3, '뒤집어 반대쪽도 2분간 구워 노릇하게 색을 낸다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=209) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=209 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 209, 4, '소금과 후추로 간하고 그릇에 담아 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=209) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=209 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 210, 1, '배추 잎을 한 장씩 떼어 끓는 물에 30초간 데친 뒤 찬물에 헹궈 물기를 짠다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=210) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=210 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 210, 2, '원하는 속 재료(두부·당근·버섯 등)를 잘게 다져 소금·참기름으로 밑간한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=210) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=210 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 210, 3, '배추 잎을 펼쳐 속 재료를 한 스푼 올리고 김밥 말듯 단단하게 만다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=210) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=210 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 210, 4, '찜기에 물이 끓으면 배추말이를 올려 5분간 찐다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=210) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=210 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 210, 5, '간장 1스푼, 참기름 1/2스푼을 섞어 소스를 만들어 곁들이면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=210) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=210 AND step_number=5);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 211, 1, '수박을 잘라 과육을 숟가락으로 긁어내고 씨를 제거한 뒤 믹서에 곱게 간다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=211) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=211 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 211, 2, '냄비에 수박즙 500ml와 설탕 3스푼을 넣고 약불에서 데우다가 한천가루 5g을 넣어 잘 녹인다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=211) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=211 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 211, 3, '용기에 붓고 한 김 식힌 뒤 냉장고에서 2시간 이상 굳힌다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=211) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=211 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 211, 4, '굳은 젤리를 깍둑썰기하여 화채그릇에 담고 얼음과 사이다를 부으면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=211) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=211 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 212, 1, '양배추는 최대한 얇게 채 썰거나 필러로 슬라이스한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=212) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=212 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 212, 2, '소금 1/2스푼을 뿌려 5분간 절인 뒤 물기를 꼭 짠다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=212) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=212 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 212, 3, '들기름 2스푼, 소금 약간, 참깨 1스푼을 넣고 손으로 살살 버무린다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=212) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=212 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 212, 4, '그릇에 담아 통깨를 뿌리면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=212) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=212 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 213, 1, '팽이버섯은 밑동을 자르고 한 입 크기로 찢는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=213) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=213 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 213, 2, '냄비에 간장 3스푼, 설탕 1스푼, 물 3스푼, 다진 마늘 1스푼을 넣고 끓인다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=213) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=213 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 213, 3, '팽이버섯을 넣고 중불에서 국물이 자작해질 때까지 조린다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=213) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=213 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 213, 4, '밥 위에 장조림을 올리고 달걀노른자 1개와 참기름 1/2스푼을 얹으면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=213) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=213 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 214, 1, '닭은 먹기 좋은 크기로 자르고 토마토는 4등분한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=214) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=214 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 214, 2, '달군 냄비에 식용유를 두르고 닭을 넣어 겉면이 노릇해질 때까지 중불에서 볶는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=214) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=214 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 214, 3, '고춧가루 2스푼, 간장 3스푼, 설탕 1스푼, 다진 마늘 1스푼, 물 1컵을 넣고 끓인다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=214) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=214 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 214, 4, '토마토를 넣고 뚜껑을 덮어 중불에서 15분간 끓인다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=214) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=214 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 214, 5, '국물이 자작해지면 후추로 마무리한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=214) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=214 AND step_number=5);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 215, 1, '오이는 어슷썰기하거나 채 썬 뒤 소금 1/2스푼으로 5분간 절여 물기를 짠다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=215) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=215 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 215, 2, '참깨 1스푼을 절구에 반만 빻아 향을 낸다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=215) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=215 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 215, 3, '오이에 참깨, 참기름 1스푼, 소금 약간을 넣고 가볍게 버무린다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=215) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=215 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 215, 4, '그릇에 담아 통깨를 마저 뿌리면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=215) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=215 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 216, 1, '새송이버섯은 먹기 좋게 슬라이스하거나 세로로 길게 썬다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=216) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=216 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 216, 2, '냄비에 간장 5스푼, 설탕 2스푼, 식초 2스푼, 물 1/2컵을 넣고 끓인다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=216) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=216 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 216, 3, '국물이 끓으면 새송이버섯을 넣고 중불에서 5분간 조린다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=216) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=216 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 216, 4, '불을 끄고 한 김 식힌 뒤 소독한 병에 담아 냉장 보관하면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=216) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=216 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 217, 1, '크래미는 결대로 잘게 찢고 깻잎은 깨끗이 씻어 물기를 턴다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=217) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=217 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 217, 2, '밀가루 3스푼, 달걀 1개, 물 2스푼을 섞어 반죽을 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=217) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=217 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 217, 3, '깻잎 한 장에 반죽을 얇게 바르고 크래미를 올린 뒤 다른 깻잎으로 덮는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=217) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=217 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 217, 4, '달군 팬에 식용유를 두르고 중약불에서 앞뒤로 노릇하게 부치면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=217) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=217 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 218, 1, '오이는 얇게 슬라이스하거나 갈아서 즙을 낸다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=218) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=218 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 218, 2, '오이즙에 설탕 1스푼, 레몬즙 1스푼을 넣고 섞어 얼음 틀에 부어 냉동한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=218) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=218 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 218, 3, '얼린 오이 얼음을 믹서나 빙수기로 곱게 간다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=218) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=218 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 218, 4, '그릇에 담고 슬라이스 오이, 민트를 올려 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=218) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=218 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 219, 1, '고구마는 껍질을 벗기고 최대한 얇게 슬라이스한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=219) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=219 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 219, 2, '키친타월로 수분을 제거하고 설탕 1스푼을 솔솔 뿌린다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=219) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=219 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 219, 3, '에어프라이어 160°C에 15분간 굽고, 뒤집어 5분 더 바삭하게 굽는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=219) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=219 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 219, 4, '그릇에 담아 식히면 바삭한 고구마과자 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=219) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=219 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 220, 1, '양배추는 먹기 좋게 깍둑썰기하거나 채 썬다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=220) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=220 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 220, 2, '냄비에 물 1/2컵, 식초 1/2컵, 설탕 3스푼, 소금 1스푼을 넣고 끓여 피클 물을 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=220) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=220 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 220, 3, '피클 물이 식으면 양배추를 넣고 잘 섞는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=220) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=220 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 220, 4, '소독한 밀폐 용기에 담아 냉장고에서 하루 숙성시키면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=220) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=220 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 221, 1, '오이는 씻어 반으로 갈라 씨 부분을 파낸 뒤 어슷하게 길게 썬다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=221) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=221 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 221, 2, '오이에 소금, 참기름 1/2스푼을 넣어 살짝 밑간한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=221) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=221 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 221, 3, '밥을 참기름 1스푼, 소금 약간으로 양념해 고슬하게 섞는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=221) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=221 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 221, 4, '김 위에 밥을 얇게 펴고 오이를 올려 김밥을 단단하게 만다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=221) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=221 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 221, 5, '먹기 좋게 썰어 그릇에 담으면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=221) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=221 AND step_number=5);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 222, 1, '당근은 강판에 곱게 갈거나 믹서에 갈아 즙을 낸다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=222) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=222 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 222, 2, '달걀 1개, 설탕 2스푼, 식용유 2스푼, 당근 간 것 3스푼을 섞는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=222) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=222 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 222, 3, '밀가루 4스푼, 베이킹파우더 1/4스푼, 시나몬 약간을 체 쳐 넣고 잘 섞는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=222) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=222 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 222, 4, '전자레인지용 컵이나 용기에 반죽을 붓고 전자레인지 700W에서 8분간 돌리면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=222) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=222 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 223, 1, '새송이버섯은 두껍게 슬라이스해 관자 모양이 되도록 단면을 정돈한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=223) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=223 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 223, 2, '칼집을 격자로 넣어 양념이 잘 배도록 한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=223) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=223 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 223, 3, '달군 팬에 버터 1스푼을 두르고 새송이버섯을 올려 강불에서 앞뒤 2분씩 굽는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=223) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=223 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 223, 4, '간장 1스푼, 다진 마늘 1/2스푼을 넣어 버섯에 윤기가 나도록 볶아 마무리한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=223) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=223 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 224, 1, '감자는 껍질을 벗기고 강판에 갈아 물기를 꼭 짠다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=224) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=224 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 224, 2, '라이스페이퍼를 물에 5초간 적셔 살짝 부드럽게 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=224) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=224 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 224, 3, '라이스페이퍼 위에 감자 반죽을 얇게 펴고 반으로 접거나 그대로 사용한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=224) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=224 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 224, 4, '달군 팬에 식용유를 넉넉히 두르고 중불에서 앞뒤 3분씩 바삭하게 부친다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=224) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=224 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 224, 5, '소금으로 간하고 간장 소스에 찍어 먹으면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=224) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=224 AND step_number=5);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 225, 1, '사과는 껍질을 벗기고 얇게 슬라이스한 뒤 레몬즙을 뿌려 갈변을 막는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=225) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=225 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 225, 2, '달걀흰자 2개에 설탕 2스푼을 넣고 단단한 머랭이 될 때까지 휘핑한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=225) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=225 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 225, 3, '사과 슬라이스를 접시에 담고 머랭을 듬뿍 올린다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=225) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=225 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 225, 4, '토치로 머랭 표면을 살짝 그을리거나 그대로 즉시 내면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=225) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=225 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 226, 1, '오이는 어슷 썰어 소독한 밀폐 용기에 담는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=226) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=226 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 226, 2, '냄비에 식초 1/2컵, 설탕 3스푼, 소금 1스푼을 넣고 끓여 피클 물을 만든 뒤 식힌다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=226) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=226 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 226, 3, '식힌 피클 물을 오이에 붓고 냉장고에서 30분 이상 절인다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=226) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=226 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 226, 4, '먹기 직전 차가운 사이다를 피클 물과 함께 붓고 가볍게 섞으면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=226) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=226 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 227, 1, '양배추는 한 잎씩 떼어 먹기 좋게 손으로 찢는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=227) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=227 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 227, 2, '냄비에 다시마 육수 또는 물 1L를 붓고 간장 2스푼, 국간장 1스푼으로 간한다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=227) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=227 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 227, 3, '육수가 끓으면 양배추를 넣고 숨이 살짝 죽을 때까지 끓인다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=227) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=227 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 227, 4, '원하는 채소나 두부를 추가로 넣고 함께 끓이면서 폰즈 소스에 찍어 먹으면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=227) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=227 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 228, 1, '수박껍질의 붉은 과육을 조금 남기고 초록 겉껍질은 필러로 벗긴다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=228) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=228 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 228, 2, '수박껍질을 채 썰어 소금 1스푼을 뿌리고 10분간 절인 뒤 물기를 꼭 짠다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=228) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=228 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 228, 3, '고춧가루 1스푼, 간장 1스푼, 참기름 1스푼, 다진 마늘 1/2스푼을 넣고 버무린다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=228) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=228 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 228, 4, '통깨를 뿌려 그릇에 담으면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=228) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=228 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 229, 1, '브로콜리는 한 입 크기로 잘라 끓는 소금물에 1분간 데친 뒤 물기를 뺀다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=229) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=229 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 229, 2, '오븐용 그릇에 브로콜리를 담고 소금, 후추, 식용유 1스푼을 뿌린다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=229) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=229 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 229, 3, '치즈를 브로콜리 위에 넉넉하게 올린다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=229) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=229 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 229, 4, '오븐 또는 에어프라이어 200°C에서 치즈가 녹고 노릇해질 때까지 5~7분 구우면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=229) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=229 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 230, 1, '마늘은 편으로 얇게 썰거나 다진다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=230) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=230 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 230, 2, '버터 2스푼, 마늘, 파슬리 약간을 섞어 마늘 버터를 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=230) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=230 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 230, 3, '식빵에 마늘 버터를 고르게 펴 바른다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=230) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=230 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 230, 4, '치즈를 올리고 에어프라이어 180°C에서 5분간 구워 치즈가 녹으면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=230) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=230 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 231, 1, '고구마는 삶거나 쪄서 껍질을 벗기고 매끄럽게 으깬다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=231) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=231 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 231, 2, '크림치즈 200g, 달걀 2개, 설탕 3스푼, 으깬 고구마 150g을 믹서에 넣고 고르게 간다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=231) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=231 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 231, 3, '오븐용 틀에 버터를 바르고 반죽을 붓는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=231) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=231 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 231, 4, '오븐 220°C에서 25~30분간 윗면이 진하게 탈 때까지 구워 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=231) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=231 AND step_number=4);

INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 232, 1, '양배추는 최대한 얇게 채 썰고 달걀 2개, 밀가루 4스푼, 물 3스푼을 섞어 반죽을 만든다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=232) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=232 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 232, 2, '반죽에 양배추를 넣고 소금, 가쓰오부시 약간을 더해 골고루 섞는다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=232) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=232 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 232, 3, '달군 팬에 식용유를 두르고 반죽을 둥글게 올려 중불에서 앞뒤 3분씩 노릇하게 부친다.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=232) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=232 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 232, 4, '오코노미야끼 소스와 마요네즈를 뿌리고 가쓰오부시를 올리면 완성.' WHERE EXISTS (SELECT 1 FROM recipes WHERE id=232) AND NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=232 AND step_number=4);


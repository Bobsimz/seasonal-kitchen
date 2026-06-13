-- V38: 레시피 232건 시드 (recipes + recipe_steps + recipe_ingredients) + 릴스 recipe_id 연결
-- 출처: 유튜브 레시피 릴스 영상 분석. recipe id N = reel id N (동일 영상, 채널정렬 동일).
-- recipe_ingredients: 농산물은 ingredient_id 연결(이름 매칭→식재료 상세 링크), 비농산물(양념/가공/축산/수산)은 ingredient_id=NULL + name(텍스트).
-- 모든 INSERT는 NOT EXISTS/조건 가드로 idempotent. image_url은 릴스 썸네일 상대 key(응답시 CloudFront 결합).

-- recipe 1: [오메추] 쪽파참치마요덮밥 (-7REJwnpmeo)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 1, '쪽파참치마요덮밥', '쪽파를 듬뿍 넣어 느끼함을 잡은 불 없이 만드는 초간단 참치마요덮밥.', 'thumbnails/-7REJwnpmeo.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=1);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 1, NULL, '참치캔', '150g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=1 AND ri.name='참치캔');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 1, NULL, '마요네즈', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=1 AND ri.name='마요네즈');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 1, NULL, '양조간장', '반스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=1 AND ri.name='양조간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 1, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '쪽파', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=1 AND ri.name='쪽파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 1, (SELECT id FROM ingredients WHERE name='청양고추' LIMIT 1), '청양고추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='청양고추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=1 AND ri.name='청양고추');

-- recipe 2: [오메추] 당근라페 (-81v8iujvm4)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 2, '당근라페', '샐러드, 김밥, 샌드위치에 활용하기 좋은 당근라페.', 'thumbnails/-81v8iujvm4.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=2);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 2, (SELECT id FROM ingredients WHERE name='당근' LIMIT 1), '당근', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='당근') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=2 AND ri.name='당근');

-- recipe 3: [오메추] 무전 (-WG-NWtH8HI)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 3, '무전', '맛있는 무요리, 무전 만들기 레시피.', 'thumbnails/-WG-NWtH8HI.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=3);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 3, (SELECT id FROM ingredients WHERE name='무' LIMIT 1), '무', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='무') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=3 AND ri.name='무');

-- recipe 4: [오메추] 베이컨피망볶음 (-u_PesupEgg)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 4, '베이컨피망볶음', '간장과 마요네즈로 색다른 맛을 낸 베이컨 피망볶음으로 반찬과 술안주로 모두 활용 가능.', 'thumbnails/-u_PesupEgg.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=4);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 4, (SELECT id FROM ingredients WHERE name='피망' LIMIT 1), '피망', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='피망') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=4 AND ri.name='피망');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 4, NULL, '베이컨', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=4 AND ri.name='베이컨');

-- recipe 5: [오메추] 양배추 참치비빔밥 (0AZ58wNi7oc)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 5, '양배추 참치비빔밥', '양배추와 참치를 활용한 다이어트 비빔밥이다.', 'thumbnails/0AZ58wNi7oc.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=5);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 5, (SELECT id FROM ingredients WHERE name='양배추' LIMIT 1), '양배추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양배추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=5 AND ri.name='양배추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 5, NULL, '참치', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=5 AND ri.name='참치');

-- recipe 6: [오메추] 계란볶음밥 (2espd94O4xU)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 6, '계란볶음밥', '대파와 계란만으로 만드는 간단하고 맛있는 계란볶음밥.', 'thumbnails/2espd94O4xU.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=6);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 6, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '대파', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=6 AND ri.name='대파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 6, NULL, '계란', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=6 AND ri.name='계란');

-- recipe 7: [오메추] 오이부추무침 (3DfSdeiCPgM)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 7, '오이부추무침', '오이와 부추를 간단히 무친 초간단 반찬.', 'thumbnails/3DfSdeiCPgM.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=7);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 7, (SELECT id FROM ingredients WHERE name='오이' LIMIT 1), '오이', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='오이') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=7 AND ri.name='오이');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 7, (SELECT id FROM ingredients WHERE name='부추' LIMIT 1), '부추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='부추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=7 AND ri.name='부추');

-- recipe 8: [오메추] 참외청 (3uBVJt4J0ok)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 8, '참외청', '참외와 설탕을 1:1로 담가 만드는 달달 향긋한 참외청.', 'thumbnails/3uBVJt4J0ok.webp', 'EASY', 30, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=8);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 8, 1, '참외를 밀가루, 베이킹소다 등으로 깨끗이 세척한다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=8 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 8, 2, '참외를 반으로 잘라 씨 부분은 체에 걸러 즙을 내고, 과육은 잘게 썬다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=8 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 8, 3, '볼에 참외, 설탕을 1:1 비율로 넣고 참외즙, 레몬즙을 추가해 잘 섞는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=8 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 8, 4, '실온에서 중간중간 저어 설탕이 다 녹으면 유리병에 넣고 냉장 보관.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=8 AND step_number=4);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 8, (SELECT id FROM ingredients WHERE name='참외' LIMIT 1), '참외', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='참외') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=8 AND ri.name='참외');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 8, NULL, '설탕', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=8 AND ri.name='설탕');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 8, (SELECT id FROM ingredients WHERE name='레몬' LIMIT 1), '레몬즙', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='레몬') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=8 AND ri.name='레몬즙');

-- recipe 9: [오메추] 시금치된장국 (4E-H3ZYhBfI)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 9, '시금치된장국', '뜨끈하고 구수한 시금치 된장국.', 'thumbnails/4E-H3ZYhBfI.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=9);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 9, (SELECT id FROM ingredients WHERE name='시금치' LIMIT 1), '시금치', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='시금치') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=9 AND ri.name='시금치');

-- recipe 10: [오메추] 오코노미야끼 (4NsjWvPZ8L4)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 10, '오코노미야끼', '밀가루 없이 양배추와 계란만으로 만드는 초간단 다이어트 오코노미야끼.', 'thumbnails/4NsjWvPZ8L4.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=10);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 10, 1, '채 썬 양배추에 계란 2개, 소금 약간을 넣고 잘 섞는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=10 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 10, 2, '팬에 기름 두르고 양배추계란을 부어 동그랗게 모양을 잡는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=10 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 10, 3, '양면을 노릇하게 부쳐내고 오코노미야끼소스, 마요네즈, 가쓰오부시를 뿌려 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=10 AND step_number=3);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 10, (SELECT id FROM ingredients WHERE name='양배추' LIMIT 1), '양배추', '200g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양배추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=10 AND ri.name='양배추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 10, NULL, '계란', '2개', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=10 AND ri.name='계란');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 10, NULL, '소금', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=10 AND ri.name='소금');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 10, NULL, '마요네즈', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=10 AND ri.name='마요네즈');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 10, NULL, '오코노미야끼소스', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=10 AND ri.name='오코노미야끼소스');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 10, NULL, '가쓰오부시', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=10 AND ri.name='가쓰오부시');

-- recipe 11: [오메추] 세발나물무침 (4XRkXCEYXdg)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 11, '세발나물무침', '세발나물에 사과와 양파를 더해 새콤달콤하게 무친 봄 제철 무침 반찬.', 'thumbnails/4XRkXCEYXdg.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=11);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 11, 1, '세발나물은 씻어 물기를 빼고, 사과는 껍질째 깨끗이 씻는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=11 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 11, 2, '사과와 양파를 얇게 채썬다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=11 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 11, 3, '믹싱볼에 세발나물, 사과, 양파, 고춧가루, 간장, 액젓, 설탕, 식초, 다진마늘을 넣고 살살 버무린다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=11 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 11, 4, '깨를 뿌리면 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=11 AND step_number=4);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 11, NULL, '세발나물', '150g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=11 AND ri.name='세발나물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 11, (SELECT id FROM ingredients WHERE name='사과' LIMIT 1), '사과', '50g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='사과') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=11 AND ri.name='사과');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 11, (SELECT id FROM ingredients WHERE name='양파' LIMIT 1), '양파', '50g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=11 AND ri.name='양파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 11, (SELECT id FROM ingredients WHERE name='고춧가루' LIMIT 1), '고춧가루', '1스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고춧가루') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=11 AND ri.name='고춧가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 11, NULL, '간장', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=11 AND ri.name='간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 11, NULL, '액젓', '0.5스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=11 AND ri.name='액젓');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 11, NULL, '설탕', '0.3스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=11 AND ri.name='설탕');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 11, NULL, '식초', '1.5스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=11 AND ri.name='식초');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 11, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진마늘', '0.3스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=11 AND ri.name='다진마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 11, (SELECT id FROM ingredients WHERE name='참깨' LIMIT 1), '깨', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='참깨') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=11 AND ri.name='깨');

-- recipe 12: [오메추] 얼큰소고기뭇국 (4ijt9akEtDQ)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 12, '얼큰소고기뭇국', '기름 대신 물을 살짝 넣어 볶고 끓이는 진하고 얼큰한 소고기뭇국.', 'thumbnails/4ijt9akEtDQ.webp', 'EASY', 30, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=12);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 12, NULL, '소고기', '250g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=12 AND ri.name='소고기');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 12, (SELECT id FROM ingredients WHERE name='무' LIMIT 1), '무', '300g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='무') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=12 AND ri.name='무');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 12, (SELECT id FROM ingredients WHERE name='콩나물' LIMIT 1), '콩나물', '100g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='콩나물') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=12 AND ri.name='콩나물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 12, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '대파', '넉넉히', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=12 AND ri.name='대파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 12, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '1스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=12 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 12, (SELECT id FROM ingredients WHERE name='고춧가루' LIMIT 1), '고춧가루', '3스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고춧가루') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=12 AND ri.name='고춧가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 12, NULL, '국간장', '2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=12 AND ri.name='국간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 12, NULL, '참치액', '2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=12 AND ri.name='참치액');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 12, NULL, '진간장', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=12 AND ri.name='진간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 12, NULL, '후추', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=12 AND ri.name='후추');

-- recipe 13: [오메추] 미나리전 (4sMxOGIFU6w)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 13, '미나리전', '부침가루와 물을 1:1로 섞어 미나리를 얇고 바삭하게 부쳐낸 전이다.', 'thumbnails/4sMxOGIFU6w.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=13);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 13, NULL, '부침가루', '1/2컵', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=13 AND ri.name='부침가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 13, NULL, '물', '1/2컵', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=13 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 13, (SELECT id FROM ingredients WHERE name='미나리' LIMIT 1), '미나리', '밥공기 1그릇 가득', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='미나리') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=13 AND ri.name='미나리');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 13, (SELECT id FROM ingredients WHERE name='청양고추' LIMIT 1), '청양고추', '1개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='청양고추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=13 AND ri.name='청양고추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 13, (SELECT id FROM ingredients WHERE name='붉은고추' LIMIT 1), '홍고추', '1개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='붉은고추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=13 AND ri.name='홍고추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 13, NULL, '양조간장', '1(초간장용)', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=13 AND ri.name='양조간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 13, NULL, '식초', '1(초간장용)', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=13 AND ri.name='식초');

-- recipe 14: [오메추] 토마토 차돌박이 샐러드 (54JoNen3Ehg)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 14, '토마토 차돌박이 샐러드', '구운 차돌박이와 슬라이스 토마토에 간장 드레싱을 곁들인 샐러드.', 'thumbnails/54JoNen3Ehg.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=14);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 14, 1, '올리브유, 식초, 간장, 다진 마늘을 섞어 드레싱을 만든다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=14 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 14, 2, '토마토는 슬라이스, 양파는 채 썰어 접시에 담는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=14 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 14, 3, '차돌박이에 소금 살짝 뿌려 굽는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=14 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 14, 4, '구운 차돌박이를 올리고 드레싱을 뿌리면 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=14 AND step_number=4);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 14, NULL, '차돌박이', '150g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=14 AND ri.name='차돌박이');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 14, (SELECT id FROM ingredients WHERE name='토마토' LIMIT 1), '토마토', '1개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='토마토') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=14 AND ri.name='토마토');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 14, (SELECT id FROM ingredients WHERE name='양파' LIMIT 1), '양파', '1/4개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=14 AND ri.name='양파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 14, NULL, '설탕', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=14 AND ri.name='설탕');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 14, NULL, '올리브유', '2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=14 AND ri.name='올리브유');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 14, NULL, '식초', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=14 AND ri.name='식초');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 14, NULL, '양조간장', '2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=14 AND ri.name='양조간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 14, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '1/3스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=14 AND ri.name='다진 마늘');

-- recipe 15: [오메추] 콩나물국 (5hygjegyifc)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 15, '콩나물국', '육수 없이 새우젓과 액젓만으로 끓이는 초간단 콩나물국.', 'thumbnails/5hygjegyifc.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=15);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 15, 1, '냄비에 물 1.5L를 넣고 끓으면 콩나물을 넣는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=15 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 15, 2, '다진 마늘, 국간장, 액젓, 새우젓 넣고 끓이다가 소금으로 간을 맞춘다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=15 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 15, 3, '3분 끓이고 대파 넣으면 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=15 AND step_number=3);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 15, (SELECT id FROM ingredients WHERE name='콩나물' LIMIT 1), '콩나물', '200g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='콩나물') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=15 AND ri.name='콩나물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 15, NULL, '물', '1.5L', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=15 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 15, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '1/2스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=15 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 15, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '대파', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=15 AND ri.name='대파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 15, NULL, '국간장', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=15 AND ri.name='국간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 15, NULL, '새우젓', '1/2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=15 AND ri.name='새우젓');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 15, NULL, '멸치액젓', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=15 AND ri.name='멸치액젓');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 15, NULL, '소금', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=15 AND ri.name='소금');

-- recipe 16: [오메추] 소고기뭇국 (6E7La3svDso)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 16, '소고기뭇국', '고기를 볶지 않고 물을 세 번 나눠 넣어 끓이는 진한 소고기뭇국.', 'thumbnails/6E7La3svDso.webp', 'EASY', 30, 4, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=16);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 16, 1, '무, 대파는 먹기 좋게 썰고 고기는 키친타올로 핏물을 제거한다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=16 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 16, 2, '참기름에 무를 살짝 볶는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=16 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 16, 3, '무가 잠길 정도로 물을 넣고 국간장 3큰술을 넣는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=16 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 16, 4, '손질한 고기를 넣고 잠시 끓인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=16 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 16, 5, '두 번째 물을 추가하고 참치액 2큰술을 넣는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=16 AND step_number=5);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 16, 6, '고기가 다 익으면 세 번째 물 추가 후 다진마늘 1큰술을 넣는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=16 AND step_number=6);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 16, 7, '모자란 간은 소금으로, 후추는 취향껏 넣고 대파를 넣어 한소끔 끓이면 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=16 AND step_number=7);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 16, NULL, '소고기', '250g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=16 AND ri.name='소고기');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 16, (SELECT id FROM ingredients WHERE name='무' LIMIT 1), '무', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='무') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=16 AND ri.name='무');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 16, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '대파', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=16 AND ri.name='대파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 16, NULL, '국간장', '3큰술', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=16 AND ri.name='국간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 16, NULL, '참치액', '2큰술', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=16 AND ri.name='참치액');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 16, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진마늘', '1큰술', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=16 AND ri.name='다진마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 16, NULL, '소금', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=16 AND ri.name='소금');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 16, NULL, '후추', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=16 AND ri.name='후추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 16, NULL, '참기름', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=16 AND ri.name='참기름');

-- recipe 17: [오메추] 감자샌드위치 (6JzCSXoE544)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 17, '감자샌드위치', '감자만 넣고 만드는 간단 감자샌드위치.', 'thumbnails/6JzCSXoE544.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=17);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 17, (SELECT id FROM ingredients WHERE name='감자' LIMIT 1), '감자', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='감자') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=17 AND ri.name='감자');

-- recipe 18: [오메추] 토마토카레 (6VscNKK-gJA)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 18, '토마토카레', '토마토의 산미가 더해져 산뜻하면서도 풍미 깊은 집 카레 업그레이드 레시피.', 'thumbnails/6VscNKK-gJA.webp', 'EASY', 30, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=18);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 18, 1, '양파를 얇게 채 썰어 전자레인지에 4분 돌려 익힌다(700W, 랩 없이).' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=18 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 18, 2, '토마토는 +자 칼집 후 끓는 물에 데치거나 뜨거운 물에 30초 담갔다가 찬물에 식혀 껍질을 벗기고 잘게 썬다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=18 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 18, 3, '냄비에 식용유를 두르고 양파를 갈색빛이 날 때까지 볶는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=18 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 18, 4, '우삼겹을 넣고 볶다가 익으면 키친타월로 기름을 제거한다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=18 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 18, 5, '토마토와 물을 넣고 10분 정도 끓인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=18 AND step_number=5);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 18, 6, '불을 끈 뒤 고형 카레를 풀고 다시 약불로 조금 더 끓여 완성한다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=18 AND step_number=6);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 18, (SELECT id FROM ingredients WHERE name='양파' LIMIT 1), '양파', '1개(약 300g)', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=18 AND ri.name='양파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 18, (SELECT id FROM ingredients WHERE name='토마토' LIMIT 1), '토마토', '300g+', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='토마토') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=18 AND ri.name='토마토');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 18, NULL, '우삼겹', '250g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=18 AND ri.name='우삼겹');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 18, NULL, '물', '400~600ml', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=18 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 18, NULL, '고형카레', '4조각', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=18 AND ri.name='고형카레');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 18, NULL, '식용유', '약간', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=18 AND ri.name='식용유');

-- recipe 19: [오메추] 오이냉국 (6lBnaBnJauM)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 19, '오이냉국', '오이를 채썰어 새콤달콤한 국물에 담근 시원한 여름 냉국이다.', 'thumbnails/6lBnaBnJauM.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=19);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 19, 1, '오이 어슷썬 뒤 채썰고 청양고추·홍고추 잘게 썰기' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=19 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 19, 2, '볼에 오이, 소금, 국간장, 식초, 설탕, 다진 마늘 넣고 살짝 섞기' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=19 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 19, 3, '물 붓고 소금과 설탕이 완전히 녹을 때까지 젓기' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=19 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 19, 4, '청양고추, 홍고추, 깨 넣으면 완성. 먹기 전에 얼음 추가' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=19 AND step_number=4);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 19, (SELECT id FROM ingredients WHERE name='오이' LIMIT 1), '오이', '1개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='오이') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=19 AND ri.name='오이');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 19, (SELECT id FROM ingredients WHERE name='청양고추' LIMIT 1), '청양고추', '1개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='청양고추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=19 AND ri.name='청양고추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 19, (SELECT id FROM ingredients WHERE name='붉은고추' LIMIT 1), '홍고추', '1개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='붉은고추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=19 AND ri.name='홍고추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 19, NULL, '천일염', '2/3스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=19 AND ri.name='천일염');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 19, NULL, '국간장', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=19 AND ri.name='국간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 19, NULL, '식초', '4스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=19 AND ri.name='식초');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 19, NULL, '설탕', '1.5스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=19 AND ri.name='설탕');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 19, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '1/2스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=19 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 19, NULL, '물', '500ml', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=19 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 19, (SELECT id FROM ingredients WHERE name='참깨' LIMIT 1), '깨', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='참깨') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=19 AND ri.name='깨');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 19, NULL, '얼음', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=19 AND ri.name='얼음');

-- recipe 20: [오메추] 봄동된장국 (77C5B4hhKrk)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 20, '봄동된장국', '육수 없이 봄동과 무를 된장에 끓인 구수하고 시원한 봄동 된장국.', 'thumbnails/77C5B4hhKrk.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=20);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 20, 1, '무는 나박썰고 대파와 청양고추는 썬다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=20 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 20, 2, '봄동을 끓는 물에 1~2분 데쳐 찬물로 헹구고 물기를 짜서 적당한 크기로 자른다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=20 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 20, 3, '냄비에 물 1.2L, 무, 된장을 넣고 5분 끓이다가 봄동, 다진 마늘, 고춧가루를 넣고 끓인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=20 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 20, 4, '간이 부족하면 액젓으로 맞추고 대파, 청양고추 넣고 한소끔 끓이면 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=20 AND step_number=4);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 20, (SELECT id FROM ingredients WHERE name='봄동' LIMIT 1), '봄동', '250g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='봄동') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=20 AND ri.name='봄동');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 20, (SELECT id FROM ingredients WHERE name='무' LIMIT 1), '무', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='무') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=20 AND ri.name='무');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 20, NULL, '물', '1.2L', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=20 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 20, NULL, '된장', '3스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=20 AND ri.name='된장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 20, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '0.7~1스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=20 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 20, (SELECT id FROM ingredients WHERE name='고춧가루' LIMIT 1), '고춧가루', '1스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고춧가루') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=20 AND ri.name='고춧가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 20, NULL, '액젓', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=20 AND ri.name='액젓');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 20, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '대파', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=20 AND ri.name='대파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 20, (SELECT id FROM ingredients WHERE name='청양고추' LIMIT 1), '청양고추', '1개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='청양고추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=20 AND ri.name='청양고추');

-- recipe 21: [오메추] 새송이버섯전 (8Y3ua3sDxGM)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 21, '새송이버섯전', '쫄깃한 식감의 새송이버섯전이다.', 'thumbnails/8Y3ua3sDxGM.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=21);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 21, (SELECT id FROM ingredients WHERE name='새송이버섯' LIMIT 1), '새송이버섯', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='새송이버섯') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=21 AND ri.name='새송이버섯');

-- recipe 22: [오메추] 명란두부탕 (93hu6uoXWvU)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 22, '명란두부탕', '부드러운 두부와 명란을 넣어 10분 만에 완성하는 시원 칼칼한 술안주 겸 해장 탕이다.', 'thumbnails/93hu6uoXWvU.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=22);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 22, 1, '두부와 명란은 먹기 좋게 자르고, 청양고추·홍고추는 송송 썬다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=22 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 22, 2, '냄비에 두부, 코인육수, 물 400ml를 넣고 끓인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=22 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 22, 3, '명란과 다진 마늘을 넣고 끓이다가 명란이 익으면 부족한 간을 맞춘다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=22 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 22, 4, '계란, 청양고추, 홍고추를 넣고 마무리하면 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=22 AND step_number=4);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 22, NULL, '두부', '300g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=22 AND ri.name='두부');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 22, NULL, '저염명란', '100g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=22 AND ri.name='저염명란');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 22, NULL, '코인육수', '1개', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=22 AND ri.name='코인육수');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 22, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '0.3스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=22 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 22, NULL, '물', '400ml', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=22 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 22, NULL, '계란', '1개', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=22 AND ri.name='계란');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 22, (SELECT id FROM ingredients WHERE name='청양고추' LIMIT 1), '청양고추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='청양고추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=22 AND ri.name='청양고추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 22, (SELECT id FROM ingredients WHERE name='붉은고추' LIMIT 1), '홍고추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='붉은고추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=22 AND ri.name='홍고추');

-- recipe 23: [오메추] 소고기뭇국 (995OQUDahXE)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 23, '소고기뭇국', '소고기를 한번 데쳐 맑고 진하게 끓이는 소고기뭇국.', 'thumbnails/995OQUDahXE.webp', 'MEDIUM', 40, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=23);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 23, 1, '무는 나박썰고 대파는 먹기 좋게 썬다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=23 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 23, 2, '끓는 물에 소고기를 30초간 데친 후 흐르는 물에 헹군다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=23 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 23, 3, '냄비에 데친 소고기, 무, 물(재료 잠길 만큼), 국간장 2스푼, 소금 약간 넣고 1차 간 후 중불로 끓인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=23 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 23, 4, '고기와 무가 충분히 익으면 물을 더 부어 국물 양을 맞춘다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=23 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 23, 5, '센불로 올려 다진 마늘, 참치액(또는 액젓), 소금으로 간 맞추고 대파 넣어 한소끔 끓인 뒤 후추 뿌려 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=23 AND step_number=5);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 23, NULL, '소고기', '250g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=23 AND ri.name='소고기');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 23, (SELECT id FROM ingredients WHERE name='무' LIMIT 1), '무', '300~350g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='무') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=23 AND ri.name='무');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 23, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '대파', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=23 AND ri.name='대파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 23, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '1스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=23 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 23, NULL, '국간장', '2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=23 AND ri.name='국간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 23, NULL, '소금', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=23 AND ri.name='소금');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 23, NULL, '참치액', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=23 AND ri.name='참치액');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 23, NULL, '액젓', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=23 AND ri.name='액젓');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 23, NULL, '후추', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=23 AND ri.name='후추');

-- recipe 24: [오메추] 토마토솥밥 (9y82MmPURWo)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 24, '토마토솥밥', '여름 제철 토마토로 만드는 상큼한 솥밥.', 'thumbnails/9y82MmPURWo.webp', 'EASY', 30, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=24);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 24, (SELECT id FROM ingredients WHERE name='토마토' LIMIT 1), '토마토', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='토마토') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=24 AND ri.name='토마토');

-- recipe 25: [오메추] 애호박새우전 (AHn-DwOB2Ac)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 25, '애호박새우전', '애호박을 채 썰어 냉동 새우와 함께 부친 쫀득 달달한 전.', 'thumbnails/AHn-DwOB2Ac.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=25);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 25, 1, '애호박은 얇게 채 썰고 소금 뿌려 버무린 뒤 5분 절인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=25 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 25, 2, '청양고추와 냉동 새우를 잘게 썬다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=25 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 25, 3, '애호박의 물기가 생기면 새우, 청양고추, 전분가루를 넣고 잘 섞는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=25 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 25, 4, '기름 두른 팬에 노릇하게 부쳐 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=25 AND step_number=4);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 25, (SELECT id FROM ingredients WHERE name='호박' LIMIT 1), '애호박', '1개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='호박') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=25 AND ri.name='애호박');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 25, NULL, '냉동 새우', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=25 AND ri.name='냉동 새우');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 25, (SELECT id FROM ingredients WHERE name='청양고추' LIMIT 1), '청양고추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='청양고추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=25 AND ri.name='청양고추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 25, NULL, '전분가루', '4~5스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=25 AND ri.name='전분가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 25, NULL, '소금', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=25 AND ri.name='소금');

-- recipe 26: [오메추] 애호박전 (BBs6PZPU55o)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 26, '애호박전', '애호박을 얇게 썰어 부쳐내는 간단한 전 요리.', 'thumbnails/BBs6PZPU55o.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=26);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 26, (SELECT id FROM ingredients WHERE name='호박' LIMIT 1), '애호박', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='호박') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=26 AND ri.name='애호박');

-- recipe 27: [오메추] 치킨카레라이스 (BqopxWxxbRk)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 27, '치킨카레라이스', '갈색빛이 나도록 볶은 양파와 닭다리살로 만드는 풍미 깊은 치킨카레.', 'thumbnails/BqopxWxxbRk.webp', 'EASY', 35, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=27);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 27, 1, '양파는 얇게 채썰어 준비한다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=27 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 27, 2, '예열된 웍/냄비에 기름 두르고 닭고기를 껍질 아래로 놓고 소금간 후 굽는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=27 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 27, 3, '껍질이 노릇해지면 뒤집어 반대쪽 살짝 익힌 후 빼두고, 채썬 양파를 갈색빛이 나도록 10~15분 볶는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=27 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 27, 4, '버터(선택)와 닭고기를 먹기 좋게 잘라 넣고 살짝 볶는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=27 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 27, 5, '물을 붓고 중약불로 10분 끓이다가 약불로 줄이고 카레를 넣어 풀어준 뒤 5분 더 끓여 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=27 AND step_number=5);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 27, NULL, '닭다리살', '400g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=27 AND ri.name='닭다리살');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 27, (SELECT id FROM ingredients WHERE name='양파' LIMIT 1), '양파', '550~600g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=27 AND ri.name='양파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 27, NULL, '카레', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=27 AND ri.name='카레');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 27, NULL, '소금', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=27 AND ri.name='소금');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 27, NULL, '버터', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=27 AND ri.name='버터');

-- recipe 28: [오메추] 봄동전 (CEl5wKJudyM)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 28, '봄동전', '봄동을 부침가루 반죽에 묻혀 기름에 노릇하게 부쳐낸 제철 부침개다.', 'thumbnails/CEl5wKJudyM.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=28);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 28, 1, '봄동 깨끗이 씻어 준비하기' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=28 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 28, 2, '부침가루+물 1:1 비율로 섞고 참치액 살짝 넣어 반죽 만들기' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=28 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 28, 3, '봄동을 반죽에 골고루 묻혀 기름 넉넉한 팬에 노릇하게 구워내면 완성' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=28 AND step_number=3);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 28, (SELECT id FROM ingredients WHERE name='봄동' LIMIT 1), '봄동', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='봄동') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=28 AND ri.name='봄동');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 28, NULL, '부침가루', '1컵', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=28 AND ri.name='부침가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 28, NULL, '물', '1컵', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=28 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 28, NULL, '참치액', '0.3스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=28 AND ri.name='참치액');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 28, (SELECT id FROM ingredients WHERE name='붉은고추' LIMIT 1), '홍고추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='붉은고추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=28 AND ri.name='홍고추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 28, NULL, '진간장', '2스푼(초간장)', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=28 AND ri.name='진간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 28, NULL, '식초', '1스푼(초간장)', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=28 AND ri.name='식초');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 28, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '대파', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=28 AND ri.name='대파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 28, (SELECT id FROM ingredients WHERE name='청양고추' LIMIT 1), '청양고추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='청양고추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=28 AND ri.name='청양고추');

-- recipe 29: [오메추] 양배추계란죽 (CH2kK3ToY0w)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 29, '양배추계란죽', '찬밥으로 끓이는 속 편한 양배추 계란죽으로 아플 때나 아침식사·다이어트식으로 좋은 간단 죽.', 'thumbnails/CH2kK3ToY0w.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=29);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 29, (SELECT id FROM ingredients WHERE name='양배추' LIMIT 1), '양배추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양배추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=29 AND ri.name='양배추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 29, NULL, '계란', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=29 AND ri.name='계란');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 29, NULL, '밥', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=29 AND ri.name='밥');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 29, NULL, '물', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=29 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 29, (SELECT id FROM ingredients WHERE name='당근' LIMIT 1), '당근', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='당근') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=29 AND ri.name='당근');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 29, (SELECT id FROM ingredients WHERE name='팽이버섯' LIMIT 1), '팽이버섯', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='팽이버섯') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=29 AND ri.name='팽이버섯');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 29, NULL, '소금', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=29 AND ri.name='소금');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 29, NULL, '참기름', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=29 AND ri.name='참기름');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 29, (SELECT id FROM ingredients WHERE name='참깨' LIMIT 1), '깨', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='참깨') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=29 AND ri.name='깨');

-- recipe 30: [오메추] 닭고기 가지볶음 (CMH9jOhZnfI)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 30, '닭고기 가지볶음', '새콤달콤 탕수육 소스 맛의 닭다리살과 가지를 함께 구워 볶은 요리.', 'thumbnails/CMH9jOhZnfI.webp', 'EASY', 25, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=30);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 30, NULL, '닭다리살', '150g~200g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=30 AND ri.name='닭다리살');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 30, (SELECT id FROM ingredients WHERE name='가지' LIMIT 1), '가지', '1개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='가지') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=30 AND ri.name='가지');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 30, (SELECT id FROM ingredients WHERE name='감자' LIMIT 1), '감자전분', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='감자') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=30 AND ri.name='감자전분');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 30, NULL, '소금', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=30 AND ri.name='소금');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 30, NULL, '후추', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=30 AND ri.name='후추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 30, NULL, '진간장', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=30 AND ri.name='진간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 30, NULL, '설탕', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=30 AND ri.name='설탕');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 30, NULL, '식초', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=30 AND ri.name='식초');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 30, NULL, '물', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=30 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 30, (SELECT id FROM ingredients WHERE name='생강' LIMIT 1), '생강', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='생강') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=30 AND ri.name='생강');

-- recipe 31: [오메추] 스팸애호박찌개 (CRarrhPFe38)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 31, '스팸애호박찌개', '스팸과 애호박을 고추장 베이스로 끓인 밥도둑 찌개.', 'thumbnails/CRarrhPFe38.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=31);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 31, 1, '스팸, 애호박, 양파는 깍둑썰고 대파, 청양고추, 홍고추는 송송 썬다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=31 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 31, 2, '냄비에 식용유를 두르고 스팸, 고춧가루, 진간장, 국간장, 참치액, 고추장, 설탕, 다진 마늘을 넣어 약불에서 1분 볶는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=31 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 31, 3, '물 500ml, 애호박, 양파를 넣고 10분 끓인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=31 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 31, 4, '대파, 청양고추, 홍고추를 넣고 후추를 뿌려 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=31 AND step_number=4);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 31, (SELECT id FROM ingredients WHERE name='호박' LIMIT 1), '애호박', '1개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='호박') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=31 AND ri.name='애호박');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 31, (SELECT id FROM ingredients WHERE name='양파' LIMIT 1), '양파', '1/2개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=31 AND ri.name='양파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 31, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '대파', '1/3대', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=31 AND ri.name='대파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 31, (SELECT id FROM ingredients WHERE name='청양고추' LIMIT 1), '청양고추', '1개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='청양고추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=31 AND ri.name='청양고추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 31, (SELECT id FROM ingredients WHERE name='붉은고추' LIMIT 1), '홍고추', '1개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='붉은고추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=31 AND ri.name='홍고추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 31, NULL, '스팸', '1캔 (200g)', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=31 AND ri.name='스팸');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 31, NULL, '식용유', '2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=31 AND ri.name='식용유');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 31, (SELECT id FROM ingredients WHERE name='고춧가루' LIMIT 1), '고춧가루', '2스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고춧가루') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=31 AND ri.name='고춧가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 31, NULL, '진간장', '1.5스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=31 AND ri.name='진간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 31, NULL, '국간장', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=31 AND ri.name='국간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 31, NULL, '참치액', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=31 AND ri.name='참치액');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 31, NULL, '고추장', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=31 AND ri.name='고추장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 31, NULL, '설탕', '0.2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=31 AND ri.name='설탕');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 31, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '1스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=31 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 31, NULL, '물', '500ml', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=31 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 31, NULL, '후추', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=31 AND ri.name='후추');

-- recipe 32: [오메추] 가지무침 (Cg9wxKqFzlE)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 32, '가지무침', '전자레인지로 간단하게 만드는 국간장 베이스의 밥도둑 가지무침.', 'thumbnails/Cg9wxKqFzlE.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=32);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 32, 1, '가지를 깨끗이 씻어 반으로 자른 뒤 전자레인지 용기에 넣고 랩 씌워 5분 익힌 후 식힌다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=32 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 32, 2, '국간장, 진간장, 다진 마늘, 고춧가루, 참기름, 대파, 깨를 넣고 양념장을 만든다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=32 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 32, 3, '가지를 먹기 좋게 찢어 물기를 가볍게 짠다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=32 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 32, 4, '가지에 양념장을 넣고 버무려 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=32 AND step_number=4);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 32, (SELECT id FROM ingredients WHERE name='가지' LIMIT 1), '가지', '2개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='가지') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=32 AND ri.name='가지');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 32, NULL, '국간장', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=32 AND ri.name='국간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 32, NULL, '진간장', '0.5스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=32 AND ri.name='진간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 32, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '0.5스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=32 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 32, (SELECT id FROM ingredients WHERE name='고춧가루' LIMIT 1), '고춧가루', '1스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고춧가루') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=32 AND ri.name='고춧가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 32, NULL, '참기름', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=32 AND ri.name='참기름');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 32, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '대파', '1스푼(다진)', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=32 AND ri.name='대파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 32, (SELECT id FROM ingredients WHERE name='참깨' LIMIT 1), '깨', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='참깨') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=32 AND ri.name='깨');

-- recipe 33: [오메추] 상추된장국 (DcqHMbnUD24)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 33, '상추된장국', '상추를 넣어 5~10분 안에 끓이는 초간단 된장국이다.', 'thumbnails/DcqHMbnUD24.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=33);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 33, (SELECT id FROM ingredients WHERE name='상추' LIMIT 1), '상추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='상추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=33 AND ri.name='상추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 33, NULL, '된장', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=33 AND ri.name='된장');

-- recipe 34: [오메추] 애호박 베이컨볶음 (Djq_CLUGDzg)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 34, '애호박 베이컨볶음', '애호박과 베이컨을 함께 볶아 만드는 간단한 반찬.', 'thumbnails/Djq_CLUGDzg.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=34);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 34, (SELECT id FROM ingredients WHERE name='호박' LIMIT 1), '애호박', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='호박') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=34 AND ri.name='애호박');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 34, NULL, '베이컨', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=34 AND ri.name='베이컨');

-- recipe 35: [오메추] 유린기 (EM3AuV5wFls)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 35, '유린기', '기름을 많이 쓰지 않고 바삭하게 구운 닭다리살에 달콤새콤 소스를 뿌린 유린기.', 'thumbnails/EM3AuV5wFls.webp', 'EASY', 25, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=35);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 35, 1, '양상추는 먹기 좋게 뜯어 씻고, 청양고추와 홍고추는 잘게 다진다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=35 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 35, 2, '닭다리살 두툼한 부분에 칼집 내고 소금·후추로 밑간한다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=35 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 35, 3, '물, 설탕, 식초, 진간장, 다진 마늘, 청양고추, 홍고추를 섞어 소스를 만든다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=35 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 35, 4, '닭다리살에 전분 묻혀 기름 넉넉히 두른 팬에 노릇하게 익힌 뒤 먹기 좋게 썬다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=35 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 35, 5, '접시에 양상추 깔고 닭다리살 올리고 소스 뿌려 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=35 AND step_number=5);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 35, NULL, '닭다리살', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=35 AND ri.name='닭다리살');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 35, (SELECT id FROM ingredients WHERE name='상추' LIMIT 1), '양상추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='상추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=35 AND ri.name='양상추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 35, (SELECT id FROM ingredients WHERE name='청양고추' LIMIT 1), '청양고추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='청양고추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=35 AND ri.name='청양고추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 35, (SELECT id FROM ingredients WHERE name='붉은고추' LIMIT 1), '홍고추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='붉은고추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=35 AND ri.name='홍고추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 35, NULL, '소금', '세꼬집', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=35 AND ri.name='소금');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 35, NULL, '후추', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=35 AND ri.name='후추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 35, (SELECT id FROM ingredients WHERE name='감자' LIMIT 1), '감자전분', '2스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='감자') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=35 AND ri.name='감자전분');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 35, NULL, '물', '3스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=35 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 35, NULL, '설탕', '2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=35 AND ri.name='설탕');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 35, NULL, '식초', '3스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=35 AND ri.name='식초');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 35, NULL, '진간장', '3스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=35 AND ri.name='진간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 35, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '1티스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=35 AND ri.name='다진 마늘');

-- recipe 36: [오메추] 유채된장국 (EuCF7R3mUec)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 36, '유채된장국', '제철 유채를 된장과 함께 끓인 구수한 10분 완성 된장국.', 'thumbnails/EuCF7R3mUec.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=36);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 36, 1, '유채는 먹기 좋게 자르고 대파와 고추는 송송 썬다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=36 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 36, 2, '냄비에 물, 코인육수, 된장을 넣고 끓인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=36 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 36, 3, '물이 끓으면 유채와 다진마늘을 넣고 끓인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=36 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 36, 4, '대파, 홍고추 넣어 마무리하면 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=36 AND step_number=4);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 36, (SELECT id FROM ingredients WHERE name='유채' LIMIT 1), '유채', '150~200g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='유채') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=36 AND ri.name='유채');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 36, NULL, '물', '1L', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=36 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 36, NULL, '코인육수', '1개', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=36 AND ri.name='코인육수');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 36, NULL, '된장', '2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=36 AND ri.name='된장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 36, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진마늘', '0.5스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=36 AND ri.name='다진마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 36, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '대파', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=36 AND ri.name='대파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 36, (SELECT id FROM ingredients WHERE name='붉은고추' LIMIT 1), '홍고추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='붉은고추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=36 AND ri.name='홍고추');

-- recipe 37: [오메추] 깻잎계란부침 (EvUJ4rrDQmU)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 37, '깻잎계란부침', '깻잎과 계란만으로 칼 없이 간단하게 만드는 초간단 부침 반찬.', 'thumbnails/EvUJ4rrDQmU.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=37);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 37, (SELECT id FROM ingredients WHERE name='깻잎' LIMIT 1), '깻잎', '20g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깻잎') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=37 AND ri.name='깻잎');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 37, NULL, '계란', '2개', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=37 AND ri.name='계란');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 37, NULL, '소금', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=37 AND ri.name='소금');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 37, NULL, '참치액', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=37 AND ri.name='참치액');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 37, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '1티스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=37 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 37, (SELECT id FROM ingredients WHERE name='청양고추' LIMIT 1), '청양고추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='청양고추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=37 AND ri.name='청양고추');

-- recipe 38: [오메추] 깻잎찜 (Ew251-TrSeA)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 38, '깻잎찜', '전자레인지로 간단하게 만드는 밥도둑 깻잎찜.', 'thumbnails/Ew251-TrSeA.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=38);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 38, 1, '깻잎은 꼭지를 자르고 깨끗이 씻어 물기를 턴다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=38 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 38, 2, '대파는 다지고 양파는 얇게 채썬다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=38 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 38, 3, '고춧가루, 진간장, 국간장, 액젓, 올리고당, 다진 마늘, 대파, 물, 깨를 섞어 양념을 만든다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=38 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 38, 4, '깻잎 두 장마다 양념 반스푼씩 바른다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=38 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 38, 5, '내열 용기에 담아 랩 씌우고 전자레인지 2분~2분 30초 돌리면 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=38 AND step_number=5);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 38, (SELECT id FROM ingredients WHERE name='깻잎' LIMIT 1), '깻잎', '60g(약 30장)', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깻잎') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=38 AND ri.name='깻잎');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 38, (SELECT id FROM ingredients WHERE name='양파' LIMIT 1), '양파', '1/4개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=38 AND ri.name='양파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 38, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '대파', '2스푼(다진)', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=38 AND ri.name='대파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 38, NULL, '진간장', '1.5스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=38 AND ri.name='진간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 38, NULL, '국간장', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=38 AND ri.name='국간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 38, NULL, '액젓', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=38 AND ri.name='액젓');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 38, NULL, '물', '4스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=38 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 38, (SELECT id FROM ingredients WHERE name='고춧가루' LIMIT 1), '고춧가루', '1스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고춧가루') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=38 AND ri.name='고춧가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 38, NULL, '올리고당', '0.5스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=38 AND ri.name='올리고당');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 38, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '0.3스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=38 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 38, (SELECT id FROM ingredients WHERE name='참깨' LIMIT 1), '깨', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='참깨') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=38 AND ri.name='깨');

-- recipe 39: [오메추] 감자채전 (Fc82umX_irg)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 39, '감자채전', '감자 하나만으로 만드는 바삭한 감자채전 레시피.', 'thumbnails/Fc82umX_irg.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=39);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 39, (SELECT id FROM ingredients WHERE name='감자' LIMIT 1), '감자', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='감자') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=39 AND ri.name='감자');

-- recipe 40: [오메추] 무밥 (FwHKuQdJxdw)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 40, '무밥', '전자레인지로 만드는 무밥과 달래장.', 'thumbnails/FwHKuQdJxdw.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=40);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 40, (SELECT id FROM ingredients WHERE name='무' LIMIT 1), '무', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='무') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=40 AND ri.name='무');

-- recipe 41: [오메추] 감자채전 (G6I3IyuVt9E)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 41, '감자채전', '밀가루 없이 감자만으로 만드는 바삭한 감자채전.', 'thumbnails/G6I3IyuVt9E.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=41);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 41, 1, '감자는 껍질을 깎고 최대한 얇게 채썬다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=41 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 41, 2, '채썬 감자에 소금, 후추로 간한다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=41 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 41, 3, '기름 넉넉히 두른 팬에 감자를 넓고 얇게 편다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=41 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 41, 4, '중불 유지, 밑면이 노릇하면 뒤집는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=41 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 41, 5, '앞뒤 바삭하게 익으면 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=41 AND step_number=5);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 41, (SELECT id FROM ingredients WHERE name='감자' LIMIT 1), '감자', '2개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='감자') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=41 AND ri.name='감자');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 41, NULL, '소금', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=41 AND ri.name='소금');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 41, NULL, '후추', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=41 AND ri.name='후추');

-- recipe 42: [오메추] 된장삼겹살가지덮밥 (HSoUVqX2ezY)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 42, '된장삼겹살가지덮밥', '가지와 삼겹살을 된장 양념으로 볶아 밥 위에 올린 덮밥.', 'thumbnails/HSoUVqX2ezY.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=42);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 42, 1, '대파는 다지고 가지는 깍둑썰기, 삼겹살은 잘게 썬다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=42 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 42, 2, '팬에 식용유 두르고 센불에 고기를 볶다가 다진 마늘, 다진 생강, 다진 대파를 넣고 노릇하게 볶는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=42 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 42, 3, '미림, 간장을 넣고 살짝 볶은 후 된장, 설탕을 넣고 1~2분 볶는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=42 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 42, 4, '밥 위에 올리고 계란 노른자, 쪽파를 올려 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=42 AND step_number=4);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 42, (SELECT id FROM ingredients WHERE name='가지' LIMIT 1), '가지', '1개(130g)', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='가지') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=42 AND ri.name='가지');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 42, NULL, '삼겹살', '120g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=42 AND ri.name='삼겹살');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 42, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진마늘', '0.5스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=42 AND ri.name='다진마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 42, (SELECT id FROM ingredients WHERE name='생강' LIMIT 1), '다진생강', '약간', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='생강') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=42 AND ri.name='다진생강');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 42, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '대파', '1/2대', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=42 AND ri.name='대파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 42, NULL, '미림 또는 청주', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=42 AND ri.name='미림 또는 청주');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 42, NULL, '진간장', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=42 AND ri.name='진간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 42, NULL, '시판 된장', '0.5스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=42 AND ri.name='시판 된장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 42, NULL, '설탕', '2작은술', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=42 AND ri.name='설탕');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 42, NULL, '계란', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=42 AND ri.name='계란');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 42, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '쪽파 또는 대파', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=42 AND ri.name='쪽파 또는 대파');

-- recipe 43: [오메추] 오이참치비빔밥 (Ho1X1mMwZX4)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 43, '오이참치비빔밥', '오이와 참치캔, 계란을 간장·참기름으로 비벼 먹는 다이어트 비빔밥.', 'thumbnails/Ho1X1mMwZX4.webp', 'EASY', 10, 1, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=43);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 43, (SELECT id FROM ingredients WHERE name='오이' LIMIT 1), '오이', '1/2개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='오이') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=43 AND ri.name='오이');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 43, NULL, '계란', '1개', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=43 AND ri.name='계란');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 43, NULL, '참치캔', '작은거 1개', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=43 AND ri.name='참치캔');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 43, NULL, '밥', '한공기', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=43 AND ri.name='밥');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 43, NULL, '간장 또는 쯔유', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=43 AND ri.name='간장 또는 쯔유');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 43, NULL, '참기름', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=43 AND ri.name='참기름');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 43, NULL, '스리라차', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=43 AND ri.name='스리라차');

-- recipe 44: [오메추] 우삼겹카레 (IDp44B0cR1E)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 44, '우삼겹카레', '케찹과 우스터소스를 더해 감칠맛을 살린 우삼겹 카레.', 'thumbnails/IDp44B0cR1E.webp', 'EASY', 25, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=44);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 44, 1, '양파를 얇게 채썰어 전자레인지에 4분 돌린다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=44 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 44, 2, '식용유 1스푼에 양파를 갈색빛이 돌 때까지 볶는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=44 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 44, 3, '우삼겹을 넣고 다 익을 때까지 볶는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=44 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 44, 4, '물과 고형카레를 넣고 약불로 잘 녹인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=44 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 44, 5, '케찹, 우스터소스를 넣고 조금 더 끓이면 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=44 AND step_number=5);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 44, NULL, '우삼겹', '250~300g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=44 AND ri.name='우삼겹');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 44, (SELECT id FROM ingredients WHERE name='양파' LIMIT 1), '양파', '2개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=44 AND ri.name='양파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 44, NULL, '카레', '4조각', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=44 AND ri.name='카레');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 44, NULL, '물', '700ml', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=44 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 44, NULL, '케찹', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=44 AND ri.name='케찹');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 44, NULL, '우스터소스', '1~2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=44 AND ri.name='우스터소스');

-- recipe 45: [오메추] 미니김장 (IXSHiWJspDg)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 45, '미니김장', '무채 대신 갈아서 쉽게 만드는 5kg 미니김장으로 둘이서 2시간이면 완성하는 양념 레시피.', 'thumbnails/IXSHiWJspDg.webp', 'MEDIUM', 120, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=45);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 45, 1, '절임배추를 뒤집어서 1~2시간 물을 뺀다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=45 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 45, 2, '물 1L에 육수 재료를 넣고 끓인 뒤 식혀 육수를 준비한다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=45 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 45, 3, '식은 육수 300ml에 찹쌀가루를 풀어 중약불에서 저어가며 되직하게 끓인 뒤 식혀 찹쌀풀을 만든다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=45 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 45, 4, '무 350g에 육수 100ml를 넣고 갈아 무즙을 만든다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=45 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 45, 5, '고춧가루, 액젓류, 갈아놓은 무, 찹쌀풀, 다진 마늘, 다진 생강을 버무리고 육수로 농도를 맞춰 양념을 만든다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=45 AND step_number=5);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 45, 6, '배추 잎 사이사이에 양념을 골고루 바르면 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=45 AND step_number=6);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 45, (SELECT id FROM ingredients WHERE name='배추' LIMIT 1), '절임배추', '5kg', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='배추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=45 AND ri.name='절임배추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 45, NULL, '물', '1L', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=45 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 45, (SELECT id FROM ingredients WHERE name='고춧가루' LIMIT 1), '고춧가루', '350g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고춧가루') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=45 AND ri.name='고춧가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 45, NULL, '새우젓', '100g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=45 AND ri.name='새우젓');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 45, NULL, '멸치액젓', '120ml', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=45 AND ri.name='멸치액젓');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 45, NULL, '황석어액젓', '100ml', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=45 AND ri.name='황석어액젓');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 45, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '200g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=45 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 45, (SELECT id FROM ingredients WHERE name='생강' LIMIT 1), '다진 생강', '30g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='생강') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=45 AND ri.name='다진 생강');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 45, (SELECT id FROM ingredients WHERE name='무' LIMIT 1), '무', '350~400g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='무') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=45 AND ri.name='무');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 45, (SELECT id FROM ingredients WHERE name='찹쌀' LIMIT 1), '찹쌀가루', '3스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='찹쌀') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=45 AND ri.name='찹쌀가루');

-- recipe 46: [오메추] 양배추 샤브샤브 (IbjJGc2JiGU)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 46, '양배추 샤브샤브', '양배추 하나로 간단하게 즐기는 샤브샤브로, 새콤달콤 소스에 찍어 먹는 간편 요리.', 'thumbnails/IbjJGc2JiGU.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=46);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 46, (SELECT id FROM ingredients WHERE name='양배추' LIMIT 1), '양배추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양배추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=46 AND ri.name='양배추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 46, NULL, '샤브샤브용 고기', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=46 AND ri.name='샤브샤브용 고기');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 46, NULL, '물', '500ml', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=46 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 46, NULL, '코인육수', '한 알', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=46 AND ri.name='코인육수');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 46, NULL, '참치액', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=46 AND ri.name='참치액');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 46, NULL, '쯔유', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=46 AND ri.name='쯔유');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 46, NULL, '식초', '1스푼(소스)', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=46 AND ri.name='식초');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 46, NULL, '양조간장', '1스푼(소스)', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=46 AND ri.name='양조간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 46, NULL, '설탕', '0.5스푼(소스)', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=46 AND ri.name='설탕');

-- recipe 47: [오메추] 달래장 (Ip2KoMteHgY)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 47, '달래장', '짜지 않은 황금비율 달래장으로 마른 김, 솥밥, 두부부침에 곁들이는 양념장.', 'thumbnails/Ip2KoMteHgY.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=47);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 47, 1, '달래를 깨끗이 손질 후 먹기 좋게 자른다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=47 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 47, 2, '위 재료를 모두 넣고 잘 섞어 완성한다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=47 AND step_number=2);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 47, (SELECT id FROM ingredients WHERE name='달래' LIMIT 1), '달래', '100g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='달래') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=47 AND ri.name='달래');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 47, (SELECT id FROM ingredients WHERE name='고춧가루' LIMIT 1), '고춧가루', '1스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고춧가루') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=47 AND ri.name='고춧가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 47, NULL, '진간장', '2.5스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=47 AND ri.name='진간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 47, NULL, '국간장', '0.5스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=47 AND ri.name='국간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 47, NULL, '물', '3스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=47 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 47, NULL, '들기름', '1~2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=47 AND ri.name='들기름');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 47, (SELECT id FROM ingredients WHERE name='참깨' LIMIT 1), '깨', '1스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='참깨') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=47 AND ri.name='깨');

-- recipe 48: [오메추] 통마늘 닭볶음탕 (IwvbLH0zyc8)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 48, '통마늘 닭볶음탕', '통마늘을 노릇하게 구워 마늘 기름으로 닭을 볶아 만드는 은은한 마늘 향의 닭볶음탕이다.', 'thumbnails/IwvbLH0zyc8.webp', 'MEDIUM', 40, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=48);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 48, 1, '냄비에 식용유 1스푼 두르고 통마늘을 노릇하게 구워 꺼낸다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=48 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 48, 2, '마늘 기름에 닭고기 겉면을 5분 정도 익힌다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=48 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 48, 3, '설탕, 진간장, 고추장, 고춧가루를 넣고 1분 볶다가 다진 마늘, 물 넣고 중약불로 20분 끓인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=48 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 48, 4, '대파, 양파는 큼직하게 썬다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=48 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 48, 5, '간 조절 후 양파, 대파, 통마늘, 후추를 넣고 채소가 익을 때까지 끓이면 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=48 AND step_number=5);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 48, NULL, '닭볶음탕용 닭', '1kg', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=48 AND ri.name='닭볶음탕용 닭');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 48, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '통마늘', '30알', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=48 AND ri.name='통마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 48, NULL, '식용유', '2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=48 AND ri.name='식용유');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 48, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '대파', '1/2대', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=48 AND ri.name='대파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 48, (SELECT id FROM ingredients WHERE name='양파' LIMIT 1), '양파', '1개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=48 AND ri.name='양파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 48, NULL, '설탕', '2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=48 AND ri.name='설탕');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 48, NULL, '진간장', '6스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=48 AND ri.name='진간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 48, NULL, '고추장', '크게 1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=48 AND ri.name='고추장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 48, (SELECT id FROM ingredients WHERE name='고춧가루' LIMIT 1), '고춧가루', '5스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고춧가루') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=48 AND ri.name='고춧가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 48, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '1스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=48 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 48, NULL, '물', '600ml', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=48 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 48, NULL, '후추', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=48 AND ri.name='후추');

-- recipe 49: [오메추] 닭도리탕 (J1301qbxJ8E)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 49, '닭도리탕', '다진 마늘을 듬뿍 넣어 진하고 얼큰한 국물이 특징인 닭볶음탕.', 'thumbnails/J1301qbxJ8E.webp', 'EASY', 40, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=49);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 49, 1, '감자는 2등분, 대파는 큼직하게 썬다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=49 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 49, 2, '닭은 끓는 물에 3분 데쳐낸 뒤 씻는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=49 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 49, 3, '냄비에 닭과 양념(진간장·국간장·액젓·치킨스톡·고춧가루·다진 마늘 1스푼)을 넣고 끓인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=49 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 49, 4, '끓기 시작하면 감자를 넣고 중불~중약불에서 25~30분 익힌다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=49 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 49, 5, '대파·다진 마늘 듬뿍·후추를 넣고 5분 더 끓이면 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=49 AND step_number=5);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 49, NULL, '닭볶음탕용 닭', '1kg', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=49 AND ri.name='닭볶음탕용 닭');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 49, (SELECT id FROM ingredients WHERE name='감자' LIMIT 1), '감자', '2개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='감자') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=49 AND ri.name='감자');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 49, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '대파', '2대', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=49 AND ri.name='대파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 49, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '많이(취향껏)', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=49 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 49, NULL, '물', '800ml+', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=49 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 49, NULL, '진간장', '2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=49 AND ri.name='진간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 49, NULL, '국간장', '2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=49 AND ri.name='국간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 49, NULL, '액젓 또는 참치액', '2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=49 AND ri.name='액젓 또는 참치액');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 49, NULL, '치킨스톡 또는 다시다', '0.5스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=49 AND ri.name='치킨스톡 또는 다시다');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 49, (SELECT id FROM ingredients WHERE name='고춧가루' LIMIT 1), '고춧가루', '5스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고춧가루') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=49 AND ri.name='고춧가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 49, NULL, '후추', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=49 AND ri.name='후추');

-- recipe 50: [오메추] 토마토살사 차돌박이샐러드 (J8CEDvm63p0)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 50, '토마토살사 차돌박이샐러드', '토마토살사를 드레싱으로 활용한 구운 차돌박이 샐러드.', 'thumbnails/J8CEDvm63p0.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=50);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 50, 1, '토마토, 양파, 청양고추, 고수를 다지고 레몬즙, 소금, 후추를 뿌려 섞어 살사를 만들고 냉장 보관한다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=50 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 50, 2, '차돌박이를 굽고 샐러드 채소를 준비한다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=50 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 50, 3, '샐러드 위에 차돌박이를 올리고 토마토살사를 올리면 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=50 AND step_number=3);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 50, NULL, '차돌박이', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=50 AND ri.name='차돌박이');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 50, (SELECT id FROM ingredients WHERE name='토마토' LIMIT 1), '토마토', '2개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='토마토') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=50 AND ri.name='토마토');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 50, (SELECT id FROM ingredients WHERE name='양파' LIMIT 1), '양파', '반개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=50 AND ri.name='양파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 50, (SELECT id FROM ingredients WHERE name='청양고추' LIMIT 1), '청양고추', '1개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='청양고추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=50 AND ri.name='청양고추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 50, (SELECT id FROM ingredients WHERE name='고수' LIMIT 1), '고수', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고수') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=50 AND ri.name='고수');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 50, (SELECT id FROM ingredients WHERE name='레몬' LIMIT 1), '레몬즙 또는 라임즙', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='레몬') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=50 AND ri.name='레몬즙 또는 라임즙');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 50, NULL, '소금', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=50 AND ri.name='소금');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 50, NULL, '후추', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=50 AND ri.name='후추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 50, NULL, '설탕', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=50 AND ri.name='설탕');

-- recipe 51: [오메추] 콩나물밥 (JmjFcH7IVsw)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 51, '콩나물밥', '전자레인지로 5분 만에 완성하는 초간단 콩나물밥과 양념간장 레시피.', 'thumbnails/JmjFcH7IVsw.webp', 'EASY', 10, 1, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=51);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 51, 1, '밥 한공기 위에 씻은 콩나물 150g을 올리고 랩을 씌워 구멍을 낸 뒤 전자레인지에 5분 돌린다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=51 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 51, 2, '그동안 양념간장 재료를 모두 섞어 양념간장을 만든다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=51 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 51, 3, '계란후라이(선택)와 양념간장을 올리고 비벼 먹는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=51 AND step_number=3);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 51, NULL, '밥', '한공기', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=51 AND ri.name='밥');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 51, (SELECT id FROM ingredients WHERE name='콩나물' LIMIT 1), '콩나물', '150g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='콩나물') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=51 AND ri.name='콩나물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 51, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '대파', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=51 AND ri.name='대파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 51, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '0.5스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=51 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 51, NULL, '국간장', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=51 AND ri.name='국간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 51, NULL, '진간장', '3스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=51 AND ri.name='진간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 51, NULL, '물', '2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=51 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 51, (SELECT id FROM ingredients WHERE name='고춧가루' LIMIT 1), '고춧가루', '1스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고춧가루') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=51 AND ri.name='고춧가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 51, NULL, '참기름', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=51 AND ri.name='참기름');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 51, (SELECT id FROM ingredients WHERE name='참깨' LIMIT 1), '깨', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='참깨') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=51 AND ri.name='깨');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 51, NULL, '계란후라이', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=51 AND ri.name='계란후라이');

-- recipe 52: [오메추] 오이탕탕이 (JuvZ4993oTM)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 52, '오이탕탕이', '오이를 두드려 만드는 오이탕탕이.', 'thumbnails/JuvZ4993oTM.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=52);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 52, (SELECT id FROM ingredients WHERE name='오이' LIMIT 1), '오이', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='오이') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=52 AND ri.name='오이');

-- recipe 53: [오메추] 김장김치 (K4lGZfvjI4I)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 53, '김장김치', '절임배추 20kg으로 간단하게 담그는 김장 레시피.', 'thumbnails/K4lGZfvjI4I.webp', 'HARD', 120, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=53);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 53, (SELECT id FROM ingredients WHERE name='배추' LIMIT 1), '절임배추', '20kg', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='배추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=53 AND ri.name='절임배추');

-- recipe 54: [오메추] 콩나물무침 (KAMZSgRN4WQ)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 54, '콩나물무침', '국간장으로 감칠맛을 낸 간단한 콩나물무침 기본 레시피.', 'thumbnails/KAMZSgRN4WQ.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=54);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 54, 1, '콩나물은 씻어 끓는 물에 3분 데친 후 찬물에 담가 식히고 물기를 제거한다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=54 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 54, 2, '데친 콩나물에 고춧가루, 국간장, 다진 마늘, 대파, 소금, 참기름을 넣고 살살 버무린 뒤 깨를 뿌려 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=54 AND step_number=2);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 54, (SELECT id FROM ingredients WHERE name='콩나물' LIMIT 1), '콩나물', '300g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='콩나물') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=54 AND ri.name='콩나물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 54, (SELECT id FROM ingredients WHERE name='고춧가루' LIMIT 1), '고춧가루', '1스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고춧가루') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=54 AND ri.name='고춧가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 54, NULL, '국간장', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=54 AND ri.name='국간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 54, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '대파', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=54 AND ri.name='대파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 54, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '0.3스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=54 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 54, NULL, '소금', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=54 AND ri.name='소금');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 54, NULL, '참기름', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=54 AND ri.name='참기름');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 54, (SELECT id FROM ingredients WHERE name='참깨' LIMIT 1), '깨', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='참깨') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=54 AND ri.name='깨');

-- recipe 55: [오메추] 순살감자탕 (KMXoqMWnD_w)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 55, '순살감자탕', '등뼈 대신 앞다리살로 만드는 감자탕 레시피로, 된장과 들깨가루로 구수한 맛을 낸다.', 'thumbnails/KMXoqMWnD_w.webp', 'MEDIUM', 80, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=55);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 55, 1, '앞다리살은 큼직하게 썰어 씻고 키친타올로 핏물을 제거한다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=55 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 55, 2, '냄비에 앞다리살, 물 1.5L, 된장 2큰술을 넣고 강불로 5분 끓인 후 뚜껑 덮고 약불로 1시간 끓인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=55 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 55, 3, '감자, 시래기를 넣고 다진 마늘, 고춧가루를 넣어 끓이다가 액젓·국간장으로 간을 맞춘다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=55 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 55, 4, '대파를 넣고 끓이다가 깻잎, 후추, 들깨가루를 넣고 끓이면 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=55 AND step_number=4);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 55, NULL, '앞다리살', '600g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=55 AND ri.name='앞다리살');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 55, NULL, '된장', '2큰술', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=55 AND ri.name='된장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 55, (SELECT id FROM ingredients WHERE name='고춧가루' LIMIT 1), '고춧가루', '3큰술', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고춧가루') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=55 AND ri.name='고춧가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 55, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '2큰술', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=55 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 55, NULL, '액젓', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=55 AND ri.name='액젓');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 55, NULL, '국간장 또는 다시다', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=55 AND ri.name='국간장 또는 다시다');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 55, (SELECT id FROM ingredients WHERE name='감자' LIMIT 1), '감자', '2개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='감자') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=55 AND ri.name='감자');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 55, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '대파', '2대', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=55 AND ri.name='대파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 55, (SELECT id FROM ingredients WHERE name='얼갈이배추' LIMIT 1), '시래기(우거지, 데친 얼갈이도 가능)', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='얼갈이배추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=55 AND ri.name='시래기(우거지, 데친 얼갈이도 가능)');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 55, (SELECT id FROM ingredients WHERE name='깻잎' LIMIT 1), '깻잎', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깻잎') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=55 AND ri.name='깻잎');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 55, (SELECT id FROM ingredients WHERE name='참깨' LIMIT 1), '들깨가루', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='참깨') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=55 AND ri.name='들깨가루');

-- recipe 56: [오메추] 사과잼 (KdqC5SjZXMU)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 56, '사과잼', '사과 과육이 씹히는 달콤 쫀득한 홈메이드 사과잼.', 'thumbnails/KdqC5SjZXMU.webp', 'EASY', 30, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=56);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 56, (SELECT id FROM ingredients WHERE name='사과' LIMIT 1), '사과', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='사과') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=56 AND ri.name='사과');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 56, NULL, '설탕', '사과 무게의 30~50%', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=56 AND ri.name='설탕');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 56, (SELECT id FROM ingredients WHERE name='레몬' LIMIT 1), '레몬즙', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='레몬') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=56 AND ri.name='레몬즙');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 56, NULL, '계피가루', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=56 AND ri.name='계피가루');

-- recipe 57: [오메추] 고구마치즈전 (KrsCmGD6se8)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 57, '고구마치즈전', '밀가루 없이 고구마로 만드는 치즈전.', 'thumbnails/KrsCmGD6se8.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=57);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 57, (SELECT id FROM ingredients WHERE name='고구마' LIMIT 1), '고구마', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고구마') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=57 AND ri.name='고구마');

-- recipe 58: [오메추] 굴배추된장국 (KsTdcKbrmoc)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 58, '굴배추된장국', '냉침 육수에 배추와 굴을 넣어 끓인 뜨끈하고 구수한 된장국으로 해장이나 아침국으로 제격.', 'thumbnails/KsTdcKbrmoc.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=58);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 58, 1, '굴은 소금물에 흔들어 손질 후 물기를 빼고, 배추는 먹기 좋게 자른다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=58 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 58, 2, '육수에 된장, 배추, 다진 마늘을 넣고 끓인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=58 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 58, 3, '굴, 대파, 청양고추, 홍고추를 넣고 한소끔 더 끓인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=58 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 58, 4, '굴이 다 익으면 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=58 AND step_number=4);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 58, NULL, '육수', '1.2L', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=58 AND ri.name='육수');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 58, (SELECT id FROM ingredients WHERE name='배추' LIMIT 1), '배추', '200g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='배추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=58 AND ri.name='배추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 58, NULL, '굴', '200g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=58 AND ri.name='굴');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 58, NULL, '된장', '2~3스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=58 AND ri.name='된장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 58, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '0.5스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=58 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 58, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '대파', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=58 AND ri.name='대파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 58, (SELECT id FROM ingredients WHERE name='청양고추' LIMIT 1), '청양고추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='청양고추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=58 AND ri.name='청양고추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 58, (SELECT id FROM ingredients WHERE name='붉은고추' LIMIT 1), '홍고추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='붉은고추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=58 AND ri.name='홍고추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 58, NULL, '국간장', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=58 AND ri.name='국간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 58, NULL, '액젓', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=58 AND ri.name='액젓');

-- recipe 59: [오메추] 애호박새우젓국 (LKtE0F4AF3g)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 59, '애호박새우젓국', '애호박과 새우젓으로 끓이는 시원하고 깔끔한 초간단 국.', 'thumbnails/LKtE0F4AF3g.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=59);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 59, 1, '애호박은 먹기 좋게 썰고 양파는 채썬다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=59 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 59, 2, '냄비에 애호박, 물 500ml, 새우젓, 다진 마늘, 국간장 넣고 5분 끓인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=59 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 59, 3, '양파 넣고 3분 더 끓이면 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=59 AND step_number=3);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 59, (SELECT id FROM ingredients WHERE name='호박' LIMIT 1), '애호박', '2/3개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='호박') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=59 AND ri.name='애호박');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 59, (SELECT id FROM ingredients WHERE name='양파' LIMIT 1), '양파', '1/2개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=59 AND ri.name='양파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 59, NULL, '물', '500ml', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=59 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 59, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '2/3스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=59 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 59, NULL, '새우젓', '1스푼+', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=59 AND ri.name='새우젓');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 59, NULL, '국간장', '1/2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=59 AND ri.name='국간장');

-- recipe 60: [오메추] 토마토김치 (LebV4aJY-ss)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 60, '토마토김치', '토마토 본연의 단맛과 산미를 살려 식초·설탕 없이 고춧가루와 멸치액젓만으로 무친 초간단 토마토 겉절이.', 'thumbnails/LebV4aJY-ss.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=60);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 60, 1, '토마토는 먹기 좋은 크기로 썰고, 양파는 채 썬다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=60 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 60, 2, '토마토와 양파에 고춧가루 2스푼, 멸치액젓 2스푼을 넣고 살살 버무린다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=60 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 60, 3, '부추를 넣고 한 번만 더 버무리면 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=60 AND step_number=3);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 60, (SELECT id FROM ingredients WHERE name='토마토' LIMIT 1), '토마토', '2개(약 330g)', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='토마토') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=60 AND ri.name='토마토');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 60, (SELECT id FROM ingredients WHERE name='양파' LIMIT 1), '양파', '1/2개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=60 AND ri.name='양파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 60, (SELECT id FROM ingredients WHERE name='부추' LIMIT 1), '부추', '약 50g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='부추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=60 AND ri.name='부추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 60, (SELECT id FROM ingredients WHERE name='고춧가루' LIMIT 1), '고춧가루', '2스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고춧가루') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=60 AND ri.name='고춧가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 60, NULL, '멸치액젓', '2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=60 AND ri.name='멸치액젓');

-- recipe 61: [오메추] 감자퀘사디아 (LhuRCtSr5YM)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 61, '감자퀘사디아', '감자와 또띠아로 만드는 간단한 퀘사디아.', 'thumbnails/LhuRCtSr5YM.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=61);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 61, (SELECT id FROM ingredients WHERE name='감자' LIMIT 1), '감자', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='감자') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=61 AND ri.name='감자');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 61, NULL, '또띠아', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=61 AND ri.name='또띠아');

-- recipe 62: [오메추] 팽이버섯 계란국 (Lzp86suCRbY)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 62, '팽이버섯 계란국', '육수 없이 10분 만에 간단하게 끓이는 팽이버섯 계란국.', 'thumbnails/Lzp86suCRbY.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=62);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 62, (SELECT id FROM ingredients WHERE name='팽이버섯' LIMIT 1), '팽이버섯', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='팽이버섯') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=62 AND ri.name='팽이버섯');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 62, NULL, '계란', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=62 AND ri.name='계란');

-- recipe 63: [오메추] 햄감자볶음 (M05LWlrJsdU)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 63, '햄감자볶음', '감자가 부서지지 않게 만드는 햄감자볶음.', 'thumbnails/M05LWlrJsdU.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=63);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 63, (SELECT id FROM ingredients WHERE name='감자' LIMIT 1), '감자', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='감자') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=63 AND ri.name='감자');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 63, NULL, '햄', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=63 AND ri.name='햄');

-- recipe 64: [오메추] 무생채 (Na6JtOChQtw)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 64, '무생채', '소금, 식초, 설탕 없이 만드는 초간단 무생채 레시피.', 'thumbnails/Na6JtOChQtw.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=64);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 64, (SELECT id FROM ingredients WHERE name='무' LIMIT 1), '무', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='무') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=64 AND ri.name='무');

-- recipe 65: [오메추] 감자볶음 (Ngur6fKeJdQ)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 65, '감자볶음', '소금에 절여 전분을 제거한 후 볶아 덜 부서지고 깔끔한 식감의 감자볶음.', 'thumbnails/Ngur6fKeJdQ.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=65);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 65, 1, '감자는 얇게 채썰고 소금 1티스푼을 넣어 5~10분 절인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=65 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 65, 2, '양파는 채썬다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=65 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 65, 3, '절인 감자를 물로 헹군 뒤 체에 받쳐 물기를 뺀다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=65 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 65, 4, '팬에 기름 두르고 감자를 볶다가 거의 익으면 양파, 다진 마늘 넣고 소금으로 간한다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=65 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 65, 5, '양파까지 익으면 불 끄고 후추, 깨 뿌려 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=65 AND step_number=5);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 65, (SELECT id FROM ingredients WHERE name='감자' LIMIT 1), '감자', '큰거 2개(작은거 3개)', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='감자') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=65 AND ri.name='감자');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 65, (SELECT id FROM ingredients WHERE name='양파' LIMIT 1), '양파', '1/2개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=65 AND ri.name='양파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 65, NULL, '소금', '1티스푼+', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=65 AND ri.name='소금');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 65, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '1/2스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=65 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 65, NULL, '후추', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=65 AND ri.name='후추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 65, (SELECT id FROM ingredients WHERE name='참깨' LIMIT 1), '깨', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='참깨') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=65 AND ri.name='깨');

-- recipe 66: [오메추] 콩자반 (O5JvSS0nAoo)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 66, '콩자반', '서리태를 불리지 않고 바로 간장에 조려 만드는 콩자반.', 'thumbnails/O5JvSS0nAoo.webp', 'EASY', 35, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=66);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 66, 1, '콩을 깨끗이 씻는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=66 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 66, 2, '냄비에 콩 1컵, 물 800ml를 넣고 센불로 시작해 끓으면 중불로 낮춰 20분 끓인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=66 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 66, 3, '설탕 2스푼 넣고 10분 더 끓인다(원하는 식감까지).' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=66 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 66, 4, '간장 4스푼, 물엿 2스푼 넣고 센불로 5분 졸이면 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=66 AND step_number=4);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 66, (SELECT id FROM ingredients WHERE name='콩' LIMIT 1), '서리태', '1컵 (150g)', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='콩') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=66 AND ri.name='서리태');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 66, NULL, '물', '800ml', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=66 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 66, NULL, '설탕', '2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=66 AND ri.name='설탕');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 66, NULL, '진간장', '4스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=66 AND ri.name='진간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 66, NULL, '물엿', '2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=66 AND ri.name='물엿');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 66, (SELECT id FROM ingredients WHERE name='참깨' LIMIT 1), '깨', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='참깨') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=66 AND ri.name='깨');

-- recipe 67: [오메추] 대파볶음 (OOOma_4wZ6o)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 67, '대파볶음', '푹 익힌 대파의 달고 깊은 맛을 살린 반찬이다.', 'thumbnails/OOOma_4wZ6o.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=67);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 67, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '대파', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=67 AND ri.name='대파');

-- recipe 68: [오메추] 매콤팽이버섯덮밥 (O_BrskhiYF4)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 68, '매콤팽이버섯덮밥', '팽이버섯으로 만드는 간단하고 매콤한 한 끼 덮밥 레시피.', 'thumbnails/O_BrskhiYF4.webp', 'EASY', 15, 1, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=68);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 68, (SELECT id FROM ingredients WHERE name='팽이버섯' LIMIT 1), '팽이버섯', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='팽이버섯') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=68 AND ri.name='팽이버섯');

-- recipe 69: [오메추] 냉이된장찌개 (OnsEV9tvdv0)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 69, '냉이된장찌개', '향긋한 냉이를 듬뿍 넣고 된장·고추장을 볶아 끓이는 냉이된장찌개이다.', 'thumbnails/OnsEV9tvdv0.webp', 'MEDIUM', 25, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=69);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 69, 1, '냉이는 찬물에 담갔다가 흔들어 씻고, 뿌리를 긁어낸 뒤 먹기 좋게 썬다. 무는 나박썰기, 나머지 재료도 썬다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=69 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 69, 2, '냄비에 식용유, 된장, 고추장을 넣고 타지 않게 살짝 볶다가 물 550ml와 무를 넣고 5분 끓인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=69 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 69, 3, '무가 어느 정도 익으면 양파, 두부, 다진 마늘, 고춧가루를 넣고 끓인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=69 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 69, 4, '양파와 무가 다 익으면 팽이버섯, 대파, 청양고추를 넣고 부족한 간을 맞춘다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=69 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 69, 5, '마지막에 냉이를 넣고 살짝 더 끓이면 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=69 AND step_number=5);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 69, (SELECT id FROM ingredients WHERE name='냉이' LIMIT 1), '냉이', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='냉이') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=69 AND ri.name='냉이');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 69, (SELECT id FROM ingredients WHERE name='무' LIMIT 1), '무', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='무') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=69 AND ri.name='무');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 69, (SELECT id FROM ingredients WHERE name='양파' LIMIT 1), '양파', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=69 AND ri.name='양파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 69, NULL, '두부', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=69 AND ri.name='두부');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 69, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '대파', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=69 AND ri.name='대파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 69, (SELECT id FROM ingredients WHERE name='청양고추' LIMIT 1), '청양고추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='청양고추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=69 AND ri.name='청양고추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 69, (SELECT id FROM ingredients WHERE name='팽이버섯' LIMIT 1), '팽이버섯', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='팽이버섯') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=69 AND ri.name='팽이버섯');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 69, NULL, '식용유', '0.7스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=69 AND ri.name='식용유');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 69, NULL, '된장', '2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=69 AND ri.name='된장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 69, NULL, '고추장', '0.5스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=69 AND ri.name='고추장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 69, NULL, '물', '550ml', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=69 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 69, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '0.5스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=69 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 69, (SELECT id FROM ingredients WHERE name='고춧가루' LIMIT 1), '고춧가루', '0.5스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고춧가루') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=69 AND ri.name='고춧가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 69, NULL, '참치액', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=69 AND ri.name='참치액');

-- recipe 70: [오메추] 콩나물불고기 (PQL-iDRXi3Y)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 70, '콩나물불고기', '콩나물과 대패삼겹살을 고추장 양념에 넓은 팬에서 볶아 촉촉하게 완성하는 콩나물불고기.', 'thumbnails/PQL-iDRXi3Y.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=70);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 70, (SELECT id FROM ingredients WHERE name='콩나물' LIMIT 1), '콩나물', '300~400g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='콩나물') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=70 AND ri.name='콩나물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 70, NULL, '대패삼겹살', '400g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=70 AND ri.name='대패삼겹살');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 70, (SELECT id FROM ingredients WHERE name='양파' LIMIT 1), '양파', '반개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=70 AND ri.name='양파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 70, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '대파', '1대', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=70 AND ri.name='대파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 70, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진마늘', '1.5스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=70 AND ri.name='다진마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 70, NULL, '설탕', '2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=70 AND ri.name='설탕');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 70, (SELECT id FROM ingredients WHERE name='고춧가루' LIMIT 1), '고춧가루', '3스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고춧가루') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=70 AND ri.name='고춧가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 70, NULL, '진간장', '3~4스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=70 AND ri.name='진간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 70, NULL, '고추장', '3스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=70 AND ri.name='고추장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 70, NULL, '미림', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=70 AND ri.name='미림');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 70, NULL, '후추', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=70 AND ri.name='후추');

-- recipe 71: [오메추] 달래된장찌개 (PQMlL6xlr6E)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 71, '달래된장찌개', '제철 달래를 듬뿍 넣어 끓이는 구수한 달래된장찌개.', 'thumbnails/PQMlL6xlr6E.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=71);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 71, 1, '달래는 손질 후 먹기 좋게 자른다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=71 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 71, 2, '애호박, 양파, 두부는 한입 크기로, 홍고추는 송송 썬다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=71 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 71, 3, '물 450ml에 된장, 애호박, 양파, 다진 마늘을 넣고 끓인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=71 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 71, 4, '애호박이 반쯤 익으면 두부를 넣고 부족한 간을 맞춘다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=71 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 71, 5, '마지막에 달래 올리고 홍고추, 고춧가루 살짝 뿌려 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=71 AND step_number=5);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 71, NULL, '물', '450ml', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=71 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 71, (SELECT id FROM ingredients WHERE name='달래' LIMIT 1), '달래', '50g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='달래') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=71 AND ri.name='달래');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 71, (SELECT id FROM ingredients WHERE name='호박' LIMIT 1), '애호박', '1/3개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='호박') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=71 AND ri.name='애호박');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 71, (SELECT id FROM ingredients WHERE name='양파' LIMIT 1), '양파', '큰것 1/4개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=71 AND ri.name='양파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 71, NULL, '두부', '1/2모', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=71 AND ri.name='두부');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 71, NULL, '된장', '2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=71 AND ri.name='된장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 71, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '0.3스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=71 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 71, NULL, '다시다', '0.3스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=71 AND ri.name='다시다');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 71, (SELECT id FROM ingredients WHERE name='붉은고추' LIMIT 1), '홍고추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='붉은고추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=71 AND ri.name='홍고추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 71, (SELECT id FROM ingredients WHERE name='청양고추' LIMIT 1), '청양고추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='청양고추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=71 AND ri.name='청양고추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 71, (SELECT id FROM ingredients WHERE name='고춧가루' LIMIT 1), '고춧가루', '0.3스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고춧가루') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=71 AND ri.name='고춧가루');

-- recipe 72: [오메추] 참외샐러드 (PqYg7Twbn9A)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 72, '참외샐러드', '참외즙으로 만든 드레싱을 뿌린 상큼 달달한 여름 참외샐러드.', 'thumbnails/PqYg7Twbn9A.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=72);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 72, 1, '참외는 껍질을 필러로 제거한다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=72 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 72, 2, '참외를 반으로 잘라 속을 파낸다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=72 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 72, 3, '파낸 속을 체에 걸러 즙만 추출한다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=72 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 72, 4, '참외즙에 올리브오일, 레몬즙, 소금을 넣고 잘 섞어 드레싱을 만든다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=72 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 72, 5, '참외를 얇게 슬라이스해 접시에 담고 드레싱을 뿌리면 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=72 AND step_number=5);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 72, (SELECT id FROM ingredients WHERE name='참외' LIMIT 1), '참외', '1개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='참외') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=72 AND ri.name='참외');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 72, NULL, '올리브오일', '2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=72 AND ri.name='올리브오일');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 72, (SELECT id FROM ingredients WHERE name='레몬' LIMIT 1), '레몬즙', '1스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='레몬') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=72 AND ri.name='레몬즙');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 72, NULL, '소금', '한꼬집', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=72 AND ri.name='소금');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 72, NULL, '레드페퍼', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=72 AND ri.name='레드페퍼');

-- recipe 73: [오메추] 미나리 오리주물럭 (PtL-PdIQNkU)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 73, '미나리 오리주물럭', '미나리를 듬뿍 넣은 오리주물럭이다.', 'thumbnails/PtL-PdIQNkU.webp', 'MEDIUM', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=73);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 73, (SELECT id FROM ingredients WHERE name='미나리' LIMIT 1), '미나리', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='미나리') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=73 AND ri.name='미나리');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 73, NULL, '오리고기', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=73 AND ri.name='오리고기');

-- recipe 74: [오메추] 애호박까스 (PuryRaJ9sbY)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 74, '애호박까스', '애호박을 튀겨 만든 바삭바삭한 애호박까스다.', 'thumbnails/PuryRaJ9sbY.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=74);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 74, (SELECT id FROM ingredients WHERE name='호박' LIMIT 1), '애호박', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='호박') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=74 AND ri.name='애호박');

-- recipe 75: [오메추] 깍두기 (QHW-5uIOnUc)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 75, '깍두기', '매운 무도 맛있게 담그는 시원하고 아삭한 깍두기.', 'thumbnails/QHW-5uIOnUc.webp', 'MEDIUM', 90, 4, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=75);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 75, 1, '무를 깍둑썰어 소금, 뉴슈가에 버무려 1시간 절인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=75 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 75, 2, '양파 1개를 갈아둔다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=75 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 75, 3, '절여진 무에서 나온 물을 버리고 헹궈 물기를 뺀다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=75 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 75, 4, '절여진 무에 갈아 둔 양파, 다진 마늘, 멸치액젓으로 간을 맞춘 후 고춧가루를 넣고 버무린다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=75 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 75, 5, '반찬 통에 담고 1~2일 숙성 후 냉장보관한다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=75 AND step_number=5);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 75, (SELECT id FROM ingredients WHERE name='무' LIMIT 1), '무', '1개(중간 사이즈)', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='무') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=75 AND ri.name='무');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 75, NULL, '천일염', '2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=75 AND ri.name='천일염');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 75, NULL, '뉴슈가', '1꼬집', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=75 AND ri.name='뉴슈가');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 75, (SELECT id FROM ingredients WHERE name='양파' LIMIT 1), '양파', '1개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=75 AND ri.name='양파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 75, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '0.5스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=75 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 75, (SELECT id FROM ingredients WHERE name='고춧가루' LIMIT 1), '고춧가루', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고춧가루') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=75 AND ri.name='고춧가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 75, NULL, '멸치액젓', '3스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=75 AND ri.name='멸치액젓');

-- recipe 76: [오메추] 감자조림 (RcO8mR7DI7U)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 76, '감자조림', '15분 만에 완성되는 간단한 감자조림 반찬이다.', 'thumbnails/RcO8mR7DI7U.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=76);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 76, (SELECT id FROM ingredients WHERE name='감자' LIMIT 1), '감자', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='감자') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=76 AND ri.name='감자');

-- recipe 77: [오메추] 훈제오리 배추찜 (S1JiFQ9oddo)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 77, '훈제오리 배추찜', '찜기 없이 냄비로 중약불 7분이면 완성되는 훈제오리 배추찜으로, 새콤달콤 찍어먹는 소스와 함께 즐긴다.', 'thumbnails/S1JiFQ9oddo.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=77);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 77, NULL, '훈제오리', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=77 AND ri.name='훈제오리');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 77, (SELECT id FROM ingredients WHERE name='알배기배추' LIMIT 1), '알배추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='알배기배추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=77 AND ri.name='알배추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 77, NULL, '후추', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=77 AND ri.name='후추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 77, NULL, '물', '3스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=77 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 77, NULL, '진간장', '2스푼(소스)', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=77 AND ri.name='진간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 77, NULL, '식초', '2스푼(소스)', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=77 AND ri.name='식초');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 77, NULL, '설탕', '1스푼(소스)', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=77 AND ri.name='설탕');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 77, (SELECT id FROM ingredients WHERE name='양파' LIMIT 1), '양파', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=77 AND ri.name='양파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 77, (SELECT id FROM ingredients WHERE name='청양고추' LIMIT 1), '청양고추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='청양고추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=77 AND ri.name='청양고추');

-- recipe 78: [오메추] 미나리전 (SkrCLZiHbqM)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 78, '미나리전', '미나리와 멍게를 넣어 만든 전.', 'thumbnails/SkrCLZiHbqM.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=78);

-- recipe 79: [오메추] 감자된장국 (SxHMGBUb18E)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 79, '감자된장국', '코인육수와 된장으로 끓이는 구수하고 간단한 아침용 감자된장국.', 'thumbnails/SxHMGBUb18E.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=79);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 79, 1, '냄비에 물을 붓고 코인육수, 된장을 넣고 끓인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=79 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 79, 2, '나박 썬 감자, 다진 마늘을 넣고 7분 정도 끓인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=79 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 79, 3, '감자가 다 익으면 대파를 넣고 한소끔 끓여 완성한다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=79 AND step_number=3);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 79, NULL, '물', '800ml', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=79 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 79, NULL, '코인육수', '1개', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=79 AND ri.name='코인육수');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 79, NULL, '된장', '2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=79 AND ri.name='된장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 79, (SELECT id FROM ingredients WHERE name='감자' LIMIT 1), '감자', '2개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='감자') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=79 AND ri.name='감자');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 79, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '2/3스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=79 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 79, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '대파', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=79 AND ri.name='대파');

-- recipe 80: [오메추] 애호박덮밥 (UOxj0_VypwY)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 80, '애호박덮밥', '고기 없이 애호박과 양파, 달걀프라이만으로 만드는 초간단 한 그릇 덮밥이다.', 'thumbnails/UOxj0_VypwY.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=80);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 80, 1, '팬에 기름을 두르고 대파를 볶는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=80 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 80, 2, '파 향이 나면 채썬 애호박, 채썬 양파, 다진 마늘을 넣고 살짝 볶는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=80 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 80, 3, '고추장, 진간장, 고춧가루, 설탕, 참치액(또는 다시다)를 넣고 볶는다. 수분기가 없으면 물 살짝 추가.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=80 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 80, 4, '밥 위에 애호박볶음, 계란프라이, 참기름(또는 들기름)을 뿌리면 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=80 AND step_number=4);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 80, (SELECT id FROM ingredients WHERE name='호박' LIMIT 1), '애호박', '350g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='호박') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=80 AND ri.name='애호박');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 80, (SELECT id FROM ingredients WHERE name='양파' LIMIT 1), '양파', '큰거 반개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=80 AND ri.name='양파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 80, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '대파', '1/2대', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=80 AND ri.name='대파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 80, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '0.5스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=80 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 80, NULL, '고추장', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=80 AND ri.name='고추장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 80, NULL, '진간장', '3스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=80 AND ri.name='진간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 80, (SELECT id FROM ingredients WHERE name='고춧가루' LIMIT 1), '고춧가루', '1.5스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고춧가루') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=80 AND ri.name='고춧가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 80, NULL, '설탕', '0.3스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=80 AND ri.name='설탕');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 80, NULL, '참기름 또는 들기름', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=80 AND ri.name='참기름 또는 들기름');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 80, NULL, '참치액 또는 다시다', '약간', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=80 AND ri.name='참치액 또는 다시다');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 80, NULL, '계란', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=80 AND ri.name='계란');

-- recipe 81: [오메추] 무조림 (UcAbDYrpiNg)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 81, '무조림', '멸치·생선 없이 무 하나로 만드는 밥도둑 무조림으로, 전자레인지로 미리 익혀 간이 잘 배도록 만든다.', 'thumbnails/UcAbDYrpiNg.webp', 'EASY', 30, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=81);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 81, 1, '무는 껍질을 깎아낸 뒤 1~1.5cm 두께로 썬다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=81 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 81, 2, '전자레인지 용기에 무와 물 3~4스푼을 넣고 랩을 씌워 5분 돌린다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=81 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 81, 3, '양념장 재료를 모두 섞어 준비한다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=81 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 81, 4, '냄비에 무, 양념장, 물을 넣고 끓기 시작하면 뚜껑 덮고 20분 끓인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=81 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 81, 5, '뚜껑을 열고 고추와 대파를 넣은 뒤 양념이 배도록 조린다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=81 AND step_number=5);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 81, (SELECT id FROM ingredients WHERE name='무' LIMIT 1), '무', '500g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='무') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=81 AND ri.name='무');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 81, (SELECT id FROM ingredients WHERE name='고춧가루' LIMIT 1), '고춧가루', '3스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고춧가루') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=81 AND ri.name='고춧가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 81, NULL, '진간장', '3스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=81 AND ri.name='진간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 81, NULL, '국간장', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=81 AND ri.name='국간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 81, NULL, '참치액', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=81 AND ri.name='참치액');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 81, NULL, '된장', '0.3스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=81 AND ri.name='된장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 81, NULL, '맛술', '2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=81 AND ri.name='맛술');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 81, NULL, '물엿', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=81 AND ri.name='물엿');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 81, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '1스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=81 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 81, NULL, '물', '350-400ml', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=81 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 81, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '대파', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=81 AND ri.name='대파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 81, NULL, '고추', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=81 AND ri.name='고추');

-- recipe 82: [오메추] 명란오이김밥 (UohuWbXhyKU)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 82, '명란오이김밥', '재료 세 가지로 만드는 초간단 명란오이김밥.', 'thumbnails/UohuWbXhyKU.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=82);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 82, (SELECT id FROM ingredients WHERE name='오이' LIMIT 1), '오이', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='오이') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=82 AND ri.name='오이');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 82, NULL, '명란', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=82 AND ri.name='명란');

-- recipe 83: [오메추] 애호박찌개 (UtNeBo1pB0Y)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 83, '애호박찌개', '얼큰하고 진한 국물의 애호박찌개.', 'thumbnails/UtNeBo1pB0Y.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=83);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 83, (SELECT id FROM ingredients WHERE name='호박' LIMIT 1), '애호박', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='호박') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=83 AND ri.name='애호박');

-- recipe 84: [오메추] 팽이버섯전 (V7ldBo5iPmc)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 84, '팽이버섯전', '팽이버섯을 계란과 버무려 노릇하게 구워낸 저렴하고 간단한 반찬 겸 술안주다.', 'thumbnails/V7ldBo5iPmc.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=84);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 84, (SELECT id FROM ingredients WHERE name='팽이버섯' LIMIT 1), '팽이버섯', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='팽이버섯') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=84 AND ri.name='팽이버섯');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 84, NULL, '계란', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=84 AND ri.name='계란');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 84, NULL, '참치액', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=84 AND ri.name='참치액');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 84, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '1작은술', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=84 AND ri.name='다진 마늘');

-- recipe 85: [오메추] 참치무조림 (VbbFjeerk4I)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 85, '참치무조림', '무를 전자레인지로 미리 익혀 조리 시간을 단축한 뒤 참치캔과 함께 조린 밥도둑 반찬이다.', 'thumbnails/VbbFjeerk4I.webp', 'EASY', 25, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=85);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 85, 1, '무 껍질 벗겨 1~1.5cm 두께로 자르고, 대파와 홍고추 송송 썰기' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=85 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 85, 2, '무에 물 3스푼 뿌리고 랩 씌워 전자레인지 5~6분 돌리기' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=85 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 85, 3, '냄비에 무, 양념, 물 350ml 넣고 중불로 10분 끓이기' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=85 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 85, 4, '참치캔, 대파, 홍고추 올리고 살짝 더 끓이면 완성' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=85 AND step_number=4);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 85, (SELECT id FROM ingredients WHERE name='무' LIMIT 1), '무', '1/3개(450~500g)', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='무') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=85 AND ri.name='무');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 85, NULL, '참치캔', '1캔 150g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=85 AND ri.name='참치캔');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 85, NULL, '진간장', '3스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=85 AND ri.name='진간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 85, NULL, '참치액', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=85 AND ri.name='참치액');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 85, (SELECT id FROM ingredients WHERE name='고춧가루' LIMIT 1), '고춧가루', '3스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고춧가루') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=85 AND ri.name='고춧가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 85, NULL, '맛술', '2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=85 AND ri.name='맛술');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 85, NULL, '올리고당', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=85 AND ri.name='올리고당');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 85, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '1스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=85 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 85, NULL, '물', '350ml', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=85 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 85, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '대파', '약간', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=85 AND ri.name='대파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 85, (SELECT id FROM ingredients WHERE name='붉은고추' LIMIT 1), '홍고추', '1개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='붉은고추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=85 AND ri.name='홍고추');

-- recipe 86: [오메추] 토마토살사 (Wj4ezGOObMY)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 86, '토마토살사', '토마토로 만드는 살사 소스.', 'thumbnails/Wj4ezGOObMY.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=86);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 86, (SELECT id FROM ingredients WHERE name='토마토' LIMIT 1), '토마토', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='토마토') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=86 AND ri.name='토마토');

-- recipe 87: [오메추] 갈릭버터새송이버섯스테이크 (XGadqlBfRpo)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 87, '갈릭버터새송이버섯스테이크', '갈릭버터쯔유로 간단하게 만드는 식감 좋은 새송이버섯 스테이크.', 'thumbnails/XGadqlBfRpo.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=87);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 87, 1, '새송이버섯 밑동을 잘라내고 3~4cm 두께로 자른 뒤 한쪽 면에 칼집을 낸다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=87 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 87, 2, '팬에 식용유와 버터 20g을 넣고 버터가 녹으면 새송이버섯을 올려 앞뒤로 노릇하게 굽는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=87 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 87, 3, '팬 한쪽에 버터 10g, 다진 마늘을 넣고 살짝 볶아 버섯에 마늘 향을 입힌다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=87 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 87, 4, '쯔유 1스푼 넣고 살짝 볶아 완성한다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=87 AND step_number=4);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 87, (SELECT id FROM ingredients WHERE name='새송이버섯' LIMIT 1), '새송이버섯', '2개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='새송이버섯') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=87 AND ri.name='새송이버섯');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 87, (SELECT id FROM ingredients WHERE name='무' LIMIT 1), '무염 버터', '30g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='무') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=87 AND ri.name='무염 버터');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 87, NULL, '식용유', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=87 AND ri.name='식용유');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 87, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '2/3스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=87 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 87, NULL, '쯔유', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=87 AND ri.name='쯔유');

-- recipe 88: [오메추] 스팸양파볶음 (XKsntlqfAdY)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 88, '스팸양파볶음', '스팸과 양파를 고춧가루 진간장 양념에 볶은 매콤한 밥도둑 반찬이다.', 'thumbnails/XKsntlqfAdY.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=88);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 88, 1, '스팸과 양파를 비슷한 두께로 채썰기' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=88 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 88, 2, '팬에 식용유 두르고 스팸 볶다가 노릇해지면 양파, 다진마늘 넣고 볶기' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=88 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 88, 3, '양파가 반 정도 익으면 고춧가루, 진간장 넣고 약불로 볶기' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=88 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 88, 4, '맛술 또는 물 살짝 넣고 볶은 뒤 깨 뿌리면 완성' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=88 AND step_number=4);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 88, NULL, '스팸', '1/2캔(100g)', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=88 AND ri.name='스팸');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 88, (SELECT id FROM ingredients WHERE name='양파' LIMIT 1), '양파', '1/2개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=88 AND ri.name='양파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 88, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '0.3스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=88 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 88, (SELECT id FROM ingredients WHERE name='고춧가루' LIMIT 1), '고춧가루', '0.5스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고춧가루') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=88 AND ri.name='고춧가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 88, NULL, '진간장', '0.5스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=88 AND ri.name='진간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 88, NULL, '맛술', '1~2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=88 AND ri.name='맛술');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 88, (SELECT id FROM ingredients WHERE name='참깨' LIMIT 1), '깨', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='참깨') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=88 AND ri.name='깨');

-- recipe 89: [오메추] 해물파전 (XTztOo7t1d0)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 89, '해물파전', '해물과 파를 넣어 만드는 바삭한 파전.', 'thumbnails/XTztOo7t1d0.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=89);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 89, NULL, '파', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=89 AND ri.name='파');

-- recipe 90: [오메추] 꽈리고추찜 (XdI8J6wzsAY)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 90, '꽈리고추찜', '찜기 없이 전자레인지로 10분 만에 완성하는 초간단 꽈리고추찜 무침이다.', 'thumbnails/XdI8J6wzsAY.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=90);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 90, 1, '꽈리고추는 꼭지를 제거하고 깨끗이 씻는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=90 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 90, 2, '물기 있는 상태에 밀가루를 골고루 묻힌다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=90 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 90, 3, '전자레인지 용기에 넣고 물을 살짝 뿌린 뒤 랩 씌우고 구멍 뚫어 3~4분 찐다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=90 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 90, 4, '고춧가루, 진간장, 국간장, 설탕, 다진 마늘, 다진 대파, 참기름을 섞어 양념장을 만든다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=90 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 90, 5, '꽈리고추에 양념장을 넣고 살살 버무린 뒤 깨를 뿌리면 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=90 AND step_number=5);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 90, (SELECT id FROM ingredients WHERE name='꽈리고추' LIMIT 1), '꽈리고추', '150g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='꽈리고추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=90 AND ri.name='꽈리고추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 90, NULL, '밀가루', '2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=90 AND ri.name='밀가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 90, (SELECT id FROM ingredients WHERE name='고춧가루' LIMIT 1), '고춧가루', '1스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고춧가루') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=90 AND ri.name='고춧가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 90, NULL, '진간장', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=90 AND ri.name='진간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 90, NULL, '국간장', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=90 AND ri.name='국간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 90, NULL, '설탕', '2/3티스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=90 AND ri.name='설탕');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 90, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '다진 대파', '1~2스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=90 AND ri.name='다진 대파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 90, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '1/3스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=90 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 90, NULL, '참기름', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=90 AND ri.name='참기름');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 90, (SELECT id FROM ingredients WHERE name='참깨' LIMIT 1), '깨', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='참깨') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=90 AND ri.name='깨');

-- recipe 91: [오메추] 팽이버섯 계란덮밥 (XkCACrphzbg)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 91, '팽이버섯 계란덮밥', '팽이버섯과 계란을 활용한 간단한 한 그릇 덮밥이다.', 'thumbnails/XkCACrphzbg.webp', 'EASY', 15, 1, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=91);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 91, (SELECT id FROM ingredients WHERE name='팽이버섯' LIMIT 1), '팽이버섯', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='팽이버섯') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=91 AND ri.name='팽이버섯');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 91, NULL, '계란', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=91 AND ri.name='계란');

-- recipe 92: [오메추] 파김치 (YSnL1a-haqE)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 92, '파김치', '절이지 않고 찹쌀풀 없이 만드는 초간단 쪽파김치.', 'thumbnails/YSnL1a-haqE.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=92);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 92, 1, '양념 재료(고춧가루, 액젓, 연두, 물엿, 물)를 모두 섞는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=92 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 92, 2, '쪽파에 양념을 골고루 입힌다. 흰 부분엔 듬뿍, 초록 부분은 살살 훑듯 버무린다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=92 AND step_number=2);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 92, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '쪽파', '1단(약 1kg)', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=92 AND ri.name='쪽파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 92, (SELECT id FROM ingredients WHERE name='고춧가루' LIMIT 1), '고춧가루', '10스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고춧가루') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=92 AND ri.name='고춧가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 92, NULL, '액젓', '10스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=92 AND ri.name='액젓');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 92, NULL, '연두', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=92 AND ri.name='연두');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 92, NULL, '물엿', '2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=92 AND ri.name='물엿');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 92, NULL, '물', '6스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=92 AND ri.name='물');

-- recipe 93: [오메추] 레몬포셋 (ZDOUNvyePzk)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 93, '레몬포셋', '레몬과 생크림으로 만드는 오븐 없이 완성하는 영국식 꾸덕상큼 디저트.', 'thumbnails/ZDOUNvyePzk.webp', 'EASY', 30, 3, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=93);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 93, 1, '레몬을 반으로 자른 뒤 칼집을 넣고 숟가락으로 과육을 파내 껍질을 그릇으로 준비한다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=93 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 93, 2, '레몬 과육을 짜서 레몬즙 40ml를 준비한다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=93 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 93, 3, '냄비에 생크림과 설탕을 넣고 중불로 끓인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=93 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 93, 4, '끓기 시작하면 약불로 줄여 3분 더 끓인다(총 약 5분).' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=93 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 93, 5, '불을 끈 뒤 레몬즙을 넣고 잘 섞는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=93 AND step_number=5);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 93, 6, '원하면 체에 걸러 레몬 껍질 그릇에 담는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=93 AND step_number=6);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 93, 7, '냉장고에서 최소 4시간 이상 굳혀 완성한다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=93 AND step_number=7);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 93, (SELECT id FROM ingredients WHERE name='레몬' LIMIT 1), '레몬', '3개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='레몬') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=93 AND ri.name='레몬');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 93, NULL, '생크림', '250ml', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=93 AND ri.name='생크림');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 93, NULL, '설탕', '60g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=93 AND ri.name='설탕');

-- recipe 94: [오메추] 오징어뭇국 (Zfesz9TqjR0)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 94, '오징어뭇국', '뜨끈하고 시원한 오징어뭇국.', 'thumbnails/Zfesz9TqjR0.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=94);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 94, (SELECT id FROM ingredients WHERE name='무' LIMIT 1), '무', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='무') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=94 AND ri.name='무');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 94, NULL, '오징어', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=94 AND ri.name='오징어');

-- recipe 95: [오메추] 얼갈이 된장국 (aJdQ7Cpqt_M)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 95, '얼갈이 된장국', '구수하고 뜨끈한 얼갈이배추 된장국.', 'thumbnails/aJdQ7Cpqt_M.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=95);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 95, (SELECT id FROM ingredients WHERE name='얼갈이배추' LIMIT 1), '얼갈이배추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='얼갈이배추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=95 AND ri.name='얼갈이배추');

-- recipe 96: [오메추] 무생채 비빔밥 (aURPHB1-NOA)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 96, '무생채 비빔밥', '무생채를 올려 만드는 초간단 비빔밥.', 'thumbnails/aURPHB1-NOA.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=96);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 96, (SELECT id FROM ingredients WHERE name='무' LIMIT 1), '무', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='무') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=96 AND ri.name='무');

-- recipe 97: [오메추] 감자샐러드 (aYLthFWnA0Q)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 97, '감자샐러드', '볶은 베이컨과 양파, 오이를 넣어 만드는 맥주 안주로 딱인 감자샐러드.', 'thumbnails/aYLthFWnA0Q.webp', 'EASY', 25, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=97);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 97, 1, '양파는 채썰고, 오이는 얇게 썰고, 베이컨은 잘게 썬다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=97 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 97, 2, '감자는 껍질 제거 후 깍둑썰어 전자레인지 용기에 물 1.5스푼과 함께 넣고 랩 덮어 5분 돌린다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=97 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 97, 3, '오이에 소금 두꼬집 넣고 5~10분 절인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=97 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 97, 4, '팬에 기름 반스푼으로 베이컨 볶다가 채썬 양파 넣고 함께 볶는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=97 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 97, 5, '익은 감자에 소금, 설탕 넣고 으깬 뒤 볶은 베이컨·양파 넣고 식힌다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=97 AND step_number=5);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 97, 6, '절인 오이는 물로 헹궈 물기를 짠다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=97 AND step_number=6);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 97, 7, '식은 감자에 오이, 마요네즈 넣고 섞은 뒤 후추 뿌리면 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=97 AND step_number=7);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 97, (SELECT id FROM ingredients WHERE name='감자' LIMIT 1), '감자', '3개 300g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='감자') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=97 AND ri.name='감자');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 97, (SELECT id FROM ingredients WHERE name='양파' LIMIT 1), '양파', '1/4개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=97 AND ri.name='양파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 97, NULL, '베이컨', '2~3줄', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=97 AND ri.name='베이컨');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 97, (SELECT id FROM ingredients WHERE name='오이' LIMIT 1), '오이', '1/2개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='오이') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=97 AND ri.name='오이');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 97, NULL, '소금', '두꼬집+1/3티스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=97 AND ri.name='소금');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 97, NULL, '설탕', '1/2티스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=97 AND ri.name='설탕');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 97, NULL, '마요네즈', '3~4스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=97 AND ri.name='마요네즈');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 97, NULL, '후추', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=97 AND ri.name='후추');

-- recipe 98: [오메추] 양배추 우삼겹덮밥 (bEYMpyheHCw)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 98, '양배추 우삼겹덮밥', '양배추와 우삼겹을 이용해 간단하게 만드는 한 끼 덮밥이다.', 'thumbnails/bEYMpyheHCw.webp', 'EASY', 15, 1, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=98);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 98, (SELECT id FROM ingredients WHERE name='양배추' LIMIT 1), '양배추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양배추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=98 AND ri.name='양배추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 98, NULL, '우삼겹', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=98 AND ri.name='우삼겹');

-- recipe 99: [오메추] 팽이버섯전 (bRgv-T85zw8)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 99, '팽이버섯전', '팽이버섯과 계란만으로 만드는 식감 좋고 쉬운 팽이버섯 부침개.', 'thumbnails/bRgv-T85zw8.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=99);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 99, 1, '팽이버섯은 밑동을 잘라내고 잘게 자른다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=99 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 99, 2, '잘게 자른 팽이버섯에 계란 2개, 참치액을 넣고 잘 섞는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=99 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 99, 3, '기름 두른 팬에 한 숟가락씩 떠서 올리고 중약불로 노릇하게 구워낸다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=99 AND step_number=3);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 99, (SELECT id FROM ingredients WHERE name='팽이버섯' LIMIT 1), '팽이버섯', '150g 1봉', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='팽이버섯') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=99 AND ri.name='팽이버섯');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 99, NULL, '계란', '2개', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=99 AND ri.name='계란');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 99, NULL, '참치액', '1/2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=99 AND ri.name='참치액');

-- recipe 100: [오메추] 배추겉절이 (bSEQErpSnak)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 100, '배추겉절이', '절이지 않고 바로 무쳐먹는 간단 배추 겉절이.', 'thumbnails/bSEQErpSnak.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=100);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 100, (SELECT id FROM ingredients WHERE name='배추' LIMIT 1), '배추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='배추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=100 AND ri.name='배추');

-- recipe 101: [오메추] 가지전 (baOQmMgfwKg)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 101, '가지전', '겉은 바삭하고 속은 촉촉한 가지전으로, 부침가루와 튀김가루를 반반 섞어 더욱 바삭하게 완성한다.', 'thumbnails/baOQmMgfwKg.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=101);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 101, (SELECT id FROM ingredients WHERE name='가지' LIMIT 1), '가지', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='가지') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=101 AND ri.name='가지');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 101, NULL, '부침가루', '1컵', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=101 AND ri.name='부침가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 101, NULL, '튀김가루', '1컵', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=101 AND ri.name='튀김가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 101, NULL, '물', '1컵', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=101 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 101, NULL, '진간장', '2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=101 AND ri.name='진간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 101, NULL, '식초', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=101 AND ri.name='식초');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 101, (SELECT id FROM ingredients WHERE name='참깨' LIMIT 1), '깨', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='참깨') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=101 AND ri.name='깨');

-- recipe 102: [오메추] 브로콜리두부무침 (caevP7cC15A)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 102, '브로콜리두부무침', '브로콜리와 두부로 만드는 간단한 무침 레시피.', 'thumbnails/caevP7cC15A.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=102);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 102, (SELECT id FROM ingredients WHERE name='브로콜리' LIMIT 1), '브로콜리', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='브로콜리') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=102 AND ri.name='브로콜리');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 102, NULL, '두부', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=102 AND ri.name='두부');

-- recipe 103: [오메추] 파채무침 (dhKi8zfcsFU)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 103, '파채무침', '간장·식초·고춧가루·설탕 1:1:1:0.5 비율로 만드는 새콤달콤 고깃집 파채무침.', 'thumbnails/dhKi8zfcsFU.webp', 'EASY', 5, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=103);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 103, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '파채', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=103 AND ri.name='파채');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 103, NULL, '진간장', '1비율', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=103 AND ri.name='진간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 103, NULL, '식초', '1비율', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=103 AND ri.name='식초');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 103, (SELECT id FROM ingredients WHERE name='고춧가루' LIMIT 1), '고춧가루', '1비율', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고춧가루') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=103 AND ri.name='고춧가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 103, NULL, '설탕', '0.5비율', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=103 AND ri.name='설탕');

-- recipe 104: [오메추] 소고기감자국 (e1sqQ8UGMGQ)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 104, '소고기감자국', '소고기를 처음부터 간장·액젓으로 볶아 두 번에 나눠 끓이는 포근한 소고기감자국이다.', 'thumbnails/e1sqQ8UGMGQ.webp', 'EASY', 30, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=104);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 104, 1, '냄비에 참기름을 두르고 소고기, 국간장, 액젓을 넣어 겉면이 살짝 익을 때까지 볶는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=104 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 104, 2, '물 600ml를 붓고 센 불로 끓이다가 거품을 걷어내고 뚜껑 덮어 중약불로 10분 끓인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=104 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 104, 3, '감자는 두툼하게 썰어 찬물에 담가 전분기를 빼고, 대파는 송송 썬다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=104 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 104, 4, '감자를 넣고 물을 추가해 국물 양을 맞춘 뒤 다진 마늘 넣고 7~10분 더 끓인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=104 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 104, 5, '대파 넣기 전 간을 보고 소금으로 맞춘 뒤 대파와 후추를 넣으면 완성. (선택) 불린 당면은 감자가 다 익기 전에 넣고 4분 끓인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=104 AND step_number=5);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 104, NULL, '소고기', '200g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=104 AND ri.name='소고기');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 104, (SELECT id FROM ingredients WHERE name='감자' LIMIT 1), '감자', '작은 것 2개(200~300g)', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='감자') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=104 AND ri.name='감자');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 104, NULL, '참기름', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=104 AND ri.name='참기름');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 104, NULL, '국간장', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=104 AND ri.name='국간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 104, NULL, '액젓', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=104 AND ri.name='액젓');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 104, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '0.7스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=104 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 104, NULL, '물', '600ml+', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=104 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 104, NULL, '불린 당면', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=104 AND ri.name='불린 당면');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 104, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '대파', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=104 AND ri.name='대파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 104, NULL, '소금', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=104 AND ri.name='소금');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 104, NULL, '후추', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=104 AND ri.name='후추');

-- recipe 105: [오메추] 꽈리고추 멸치조림 (e4UdyxOwFno)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 105, '꽈리고추 멸치조림', '꽈리고추와 멸치를 국물이 촉촉하게 남도록 조린 밥도둑 반찬.', 'thumbnails/e4UdyxOwFno.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=105);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 105, 1, '꽈리고추는 꼭지를 제거하고 세척 후 포크나 가위로 구멍을 낸다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=105 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 105, 2, '멸치는 전자레인지에 30초 돌려 비린내를 날린다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=105 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 105, 3, '팬에 식용유 두르고 꽈리고추를 볶다가 물, 진간장, 국간장, 다진 마늘을 넣고 뚜껑 덮고 5분 익힌다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=105 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 105, 4, '뚜껑 열고 멸치 넣고 5분 더 조린다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=105 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 105, 5, '올리고당, 깨 넣어 마무리하면 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=105 AND step_number=5);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 105, (SELECT id FROM ingredients WHERE name='꽈리고추' LIMIT 1), '꽈리고추', '25개(200g)', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='꽈리고추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=105 AND ri.name='꽈리고추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 105, NULL, '멸치', '한줌 50g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=105 AND ri.name='멸치');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 105, NULL, '식용유', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=105 AND ri.name='식용유');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 105, NULL, '진간장', '2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=105 AND ri.name='진간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 105, NULL, '국간장', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=105 AND ri.name='국간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 105, NULL, '물', '1컵(200ml)', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=105 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 105, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '0.5스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=105 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 105, NULL, '올리고당', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=105 AND ri.name='올리고당');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 105, (SELECT id FROM ingredients WHERE name='참깨' LIMIT 1), '깨', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='참깨') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=105 AND ri.name='깨');

-- recipe 106: [오메추] 새송이버섯볶음 (eDijuqRX3qA)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 106, '새송이버섯볶음', '쫄깃한 식감의 새송이버섯을 맛있게 볶아 만든 반찬.', 'thumbnails/eDijuqRX3qA.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=106);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 106, (SELECT id FROM ingredients WHERE name='새송이버섯' LIMIT 1), '새송이버섯', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='새송이버섯') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=106 AND ri.name='새송이버섯');

-- recipe 107: [오메추] 애호박참치전 (eWXJouNV5Og)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 107, '애호박참치전', '부드럽고 고소한 애호박 참치전.', 'thumbnails/eWXJouNV5Og.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=107);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 107, (SELECT id FROM ingredients WHERE name='호박' LIMIT 1), '애호박', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='호박') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=107 AND ri.name='애호박');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 107, NULL, '참치', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=107 AND ri.name='참치');

-- recipe 108: [오메추] 깻잎김치 (ehi3ss_qF6Y)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 108, '깻잎김치', '만들어 바로 먹을 수 있는 깻잎김치로, 반나절 숙성 후 더욱 맛있게 즐길 수 있다.', 'thumbnails/ehi3ss_qF6Y.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=108);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 108, 1, '깻잎을 깨끗이 씻어 물기를 뺀다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=108 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 108, 2, '양파를 얇게 채썬다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=108 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 108, 3, '채썬 양파, 다진 마늘, 양조간장, 국간장, 액젓, 물, 고춧가루, 올리고당, 깨를 섞어 양념을 만든다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=108 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 108, 4, '깻잎 2장마다 양념을 발라주면 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=108 AND step_number=4);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 108, (SELECT id FROM ingredients WHERE name='깻잎' LIMIT 1), '깻잎', '50장', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깻잎') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=108 AND ri.name='깻잎');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 108, (SELECT id FROM ingredients WHERE name='양파' LIMIT 1), '양파', '반개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=108 AND ri.name='양파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 108, NULL, '양조간장', '2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=108 AND ri.name='양조간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 108, NULL, '국간장', '2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=108 AND ri.name='국간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 108, NULL, '액젓', '2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=108 AND ri.name='액젓');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 108, NULL, '물', '4~5스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=108 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 108, (SELECT id FROM ingredients WHERE name='고춧가루' LIMIT 1), '고춧가루', '2스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고춧가루') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=108 AND ri.name='고춧가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 108, NULL, '올리고당', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=108 AND ri.name='올리고당');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 108, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '2/3스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=108 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 108, (SELECT id FROM ingredients WHERE name='참깨' LIMIT 1), '깨', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='참깨') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=108 AND ri.name='깨');

-- recipe 109: [오메추] 새우마늘볶음밥 (eta-dI5TGLc)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 109, '새우마늘볶음밥', '탱글한 냉동 새우와 편마늘향이 가득한 1인분 볶음밥.', 'thumbnails/eta-dI5TGLc.webp', 'EASY', 15, 1, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=109);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 109, 1, '통마늘은 편썰고, 대파는 잘게 썬다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=109 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 109, 2, '냉동 새우는 찬물에 해동 후 물기 제거하고 큼직하게 썬다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=109 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 109, 3, '팬에 식용유 두르고 편마늘 볶다가 노릇해지면 새우·소금·대파 넣고 볶는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=109 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 109, 4, '재료를 한쪽으로 밀고 반대쪽에 달걀 넣어 스크램블한다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=109 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 109, 5, '밥 넣고 볶다가 진간장 넣고 바르르 끓으면 섞는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=109 AND step_number=5);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 109, 6, '굴소스로 간을 맞추고 고슬고슬하게 볶는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=109 AND step_number=6);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 109, 7, '마지막에 통후추를 갈아 뿌린다 (선택).' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=109 AND step_number=7);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 109, NULL, '밥', '1공기', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=109 AND ri.name='밥');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 109, NULL, '냉동 새우', '100g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=109 AND ri.name='냉동 새우');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 109, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '통마늘', '6개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=109 AND ri.name='통마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 109, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '대파', '1/4대', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=109 AND ri.name='대파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 109, NULL, '달걀', '1개', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=109 AND ri.name='달걀');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 109, NULL, '진간장', '0.5스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=109 AND ri.name='진간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 109, NULL, '굴소스', '0.5스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=109 AND ri.name='굴소스');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 109, NULL, '소금', '약간', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=109 AND ri.name='소금');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 109, NULL, '통후추', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=109 AND ri.name='통후추');

-- recipe 110: [오메추] 브로콜리 치즈구이 (fTELzKDnSIM)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 110, '브로콜리 치즈구이', '브로콜리에 치즈를 얹어 구운 간단한 요리.', 'thumbnails/fTELzKDnSIM.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=110);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 110, (SELECT id FROM ingredients WHERE name='브로콜리' LIMIT 1), '브로콜리', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='브로콜리') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=110 AND ri.name='브로콜리');

-- recipe 111: [오메추] 깍두기볶음밥 (f_FmGzacWqc)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 111, '깍두기볶음밥', '깍두기를 활용해 만드는 볶음밥.', 'thumbnails/f_FmGzacWqc.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=111);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 111, (SELECT id FROM ingredients WHERE name='무' LIMIT 1), '깍두기(무)', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='무') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=111 AND ri.name='깍두기(무)');

-- recipe 112: [오메추] 시골 된장찌개 (faEIrt-q-3g)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 112, '시골 된장찌개', '멸치와 큼직한 애호박을 넣어 끓인 구수하고 진한 시골식 된장찌개.', 'thumbnails/faEIrt-q-3g.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=112);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 112, 1, '냄비에 물 500ml, 나박 썬 무, 손질한 멸치, 된장을 넣고 끓인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=112 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 112, 2, '5분 정도 끓이다가 큼직하게 썬 호박과 버섯을 넣고 호박이 익을 때까지 끓인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=112 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 112, 3, '두부, 고추, 대파를 넣고 한소끔 끓이면 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=112 AND step_number=3);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 112, NULL, '물', '500ml', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=112 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 112, NULL, '된장', '2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=112 AND ri.name='된장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 112, NULL, '멸치', '12~15g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=112 AND ri.name='멸치');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 112, (SELECT id FROM ingredients WHERE name='무' LIMIT 1), '무', '100g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='무') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=112 AND ri.name='무');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 112, (SELECT id FROM ingredients WHERE name='호박' LIMIT 1), '애호박', '2/3개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='호박') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=112 AND ri.name='애호박');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 112, (SELECT id FROM ingredients WHERE name='표고버섯' LIMIT 1), '표고버섯', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='표고버섯') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=112 AND ri.name='표고버섯');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 112, NULL, '두부', '150g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=112 AND ri.name='두부');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 112, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '대파', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=112 AND ri.name='대파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 112, NULL, '고추', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=112 AND ri.name='고추');

-- recipe 113: [오메추] 고구마 에그슬럿 (flNKaOSEg4k)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 113, '고구마 에그슬럿', '전자레인지로 만드는 고구마 에그슬럿.', 'thumbnails/flNKaOSEg4k.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=113);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 113, (SELECT id FROM ingredients WHERE name='고구마' LIMIT 1), '고구마', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고구마') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=113 AND ri.name='고구마');

-- recipe 114: [오메추] 중국식 감자무침 (gEwYf0Xnh4Q)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 114, '중국식 감자무침', '감자채를 데쳐 고추기름과 식초로 무친 차갑게 먹는 중국식 반찬.', 'thumbnails/gEwYf0Xnh4Q.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=114);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 114, 1, '감자를 최대한 얇게 채썬다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=114 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 114, 2, '끓는 물에 살짝 투명해질 정도로만 데친다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=114 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 114, 3, '찬물에 식힌 후 물기를 제거한다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=114 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 114, 4, '다진마늘, 고추기름, 소금, 후추, 치킨스톡, 식초로 간해 잘 섞으면 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=114 AND step_number=4);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 114, (SELECT id FROM ingredients WHERE name='감자' LIMIT 1), '감자', '3대', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='감자') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=114 AND ri.name='감자');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 114, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진마늘', '1스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=114 AND ri.name='다진마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 114, NULL, '고추기름', '3~4스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=114 AND ri.name='고추기름');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 114, NULL, '소금', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=114 AND ri.name='소금');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 114, NULL, '후추', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=114 AND ri.name='후추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 114, NULL, '치킨스톡', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=114 AND ri.name='치킨스톡');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 114, NULL, '식초', '1~3스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=114 AND ri.name='식초');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 114, (SELECT id FROM ingredients WHERE name='고수' LIMIT 1), '고수', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고수') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=114 AND ri.name='고수');

-- recipe 115: [오메추] 김장김치 (gcOzpy5y_Cw)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 115, '김장김치', '절임배추 10kg으로 담그는 미니 김장 레시피.', 'thumbnails/gcOzpy5y_Cw.webp', 'HARD', 180, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=115);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 115, 1, '절임배추를 뒤집어 충분히 물을 뺀다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=115 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 115, 2, '물 2.5L에 대파, 양파, 무, 사과, 황태채, 다시마 등을 넣고 육수를 끓여 식힌다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=115 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 115, 3, '쪽파는 2cm로 자르고 무는 채썬다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=115 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 115, 4, '식힌 육수 800ml에 찹쌀가루를 풀어 끓인 후 식힌다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=115 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 115, 5, '채썬 무, 고춧가루, 액젓, 다진 마늘, 생강, 찹쌀풀을 버무린 뒤 쪽파를 넣어 김치양념을 완성한다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=115 AND step_number=5);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 115, 6, '배추에 김치양념을 한 장씩 발라가며 담그면 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=115 AND step_number=6);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 115, (SELECT id FROM ingredients WHERE name='배추' LIMIT 1), '절임배추', '10kg', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='배추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=115 AND ri.name='절임배추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 115, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '쪽파', '400g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=115 AND ri.name='쪽파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 115, (SELECT id FROM ingredients WHERE name='무' LIMIT 1), '무', '2kg', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='무') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=115 AND ri.name='무');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 115, (SELECT id FROM ingredients WHERE name='찹쌀' LIMIT 1), '찹쌀가루', '100g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='찹쌀') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=115 AND ri.name='찹쌀가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 115, (SELECT id FROM ingredients WHERE name='고춧가루' LIMIT 1), '고춧가루', '600g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고춧가루') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=115 AND ri.name='고춧가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 115, (SELECT id FROM ingredients WHERE name='생강' LIMIT 1), '생강', '50g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='생강') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=115 AND ri.name='생강');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 115, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '400g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=115 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 115, NULL, '멸치액젓', '200ml', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=115 AND ri.name='멸치액젓');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 115, NULL, '황석어액젓', '200ml', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=115 AND ri.name='황석어액젓');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 115, NULL, '새우젓', '200g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=115 AND ri.name='새우젓');

-- recipe 116: [오메추] 무생채 비빔밥 (gvO_vYbpZC8)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 116, '무생채 비빔밥', '절이지 않고 바로 만드는 초간단 무생채 비빔밥.', 'thumbnails/gvO_vYbpZC8.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=116);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 116, (SELECT id FROM ingredients WHERE name='무' LIMIT 1), '무', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='무') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=116 AND ri.name='무');

-- recipe 117: [오메추] 꽈리고추 항정살볶음 (hGSkZYE6DvQ)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 117, '꽈리고추 항정살볶음', '갈비양념 같은 단짠 소스에 꽈리고추와 항정살을 함께 볶은 반찬 겸 술안주.', 'thumbnails/hGSkZYE6DvQ.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=117);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 117, 1, '진간장, 맛술, 물, 물엿, 설탕, 후추, 다진 마늘을 섞어 소스를 만든다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=117 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 117, 2, '꽈리고추는 2~3등분으로 자른다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=117 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 117, 3, '항정살을 노릇하게 굽고 가위로 먹기 좋게 자른 뒤 기름을 닦는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=117 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 117, 4, '꽈리고추를 넣고 살짝 볶다가 소스를 붓고 졸인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=117 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 117, 5, '깨 뿌려 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=117 AND step_number=5);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 117, NULL, '항정살', '300g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=117 AND ri.name='항정살');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 117, (SELECT id FROM ingredients WHERE name='꽈리고추' LIMIT 1), '꽈리고추', '50~70g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='꽈리고추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=117 AND ri.name='꽈리고추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 117, NULL, '진간장', '3스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=117 AND ri.name='진간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 117, NULL, '맛술', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=117 AND ri.name='맛술');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 117, NULL, '물', '3스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=117 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 117, NULL, '물엿', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=117 AND ri.name='물엿');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 117, NULL, '설탕', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=117 AND ri.name='설탕');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 117, NULL, '후추', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=117 AND ri.name='후추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 117, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '0.5스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=117 AND ri.name='다진 마늘');

-- recipe 118: [오메추] 가지소보로덮밥 (hUAwNm7qSdM)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 118, '가지소보로덮밥', '불고기 양념 같은 단짠 양념으로 만드는 가지와 돼지고기 다짐육 소보로덮밥.', 'thumbnails/hUAwNm7qSdM.webp', 'EASY', 20, 1, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=118);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 118, 1, '가지는 반 가르고 어슷하게 썬다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=118 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 118, 2, '달군 팬에 기름을 살짝 두르고 가지를 센불로 노릇하게 굽다가 한쪽으로 밀고, 식용유 1스푼, 다짐육, 다진 마늘을 넣고 볶는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=118 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 118, 3, '고기가 다 익으면 맛술, 진간장, 설탕을 넣고 볶는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=118 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 118, 4, '밥 위에 가지를 올리고 계란 노른자 또는 계란 후라이를 올려 완성한다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=118 AND step_number=4);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 118, (SELECT id FROM ingredients WHERE name='가지' LIMIT 1), '가지', '1개(120g)', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='가지') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=118 AND ri.name='가지');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 118, NULL, '돼지고기 다짐육', '180g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=118 AND ri.name='돼지고기 다짐육');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 118, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '0.5~1스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=118 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 118, NULL, '계란', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=118 AND ri.name='계란');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 118, NULL, '맛술', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=118 AND ri.name='맛술');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 118, NULL, '진간장', '3스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=118 AND ri.name='진간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 118, NULL, '설탕', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=118 AND ri.name='설탕');

-- recipe 119: [오메추] 열무비빔밥 (hc-sYj0nz10)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 119, '열무비빔밥', '제철 열무를 올려 만드는 비빔밥.', 'thumbnails/hc-sYj0nz10.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=119);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 119, (SELECT id FROM ingredients WHERE name='열무' LIMIT 1), '열무', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='열무') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=119 AND ri.name='열무');

-- recipe 120: [오메추] 오이무침 (hm9RMdJu6lo)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 120, '오이무침', '절이지 않고 5분만에 바로 만들어먹는 고추장 없는 오이무침.', 'thumbnails/hm9RMdJu6lo.webp', 'EASY', 5, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=120);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 120, (SELECT id FROM ingredients WHERE name='오이' LIMIT 1), '오이', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='오이') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=120 AND ri.name='오이');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 120, (SELECT id FROM ingredients WHERE name='양파' LIMIT 1), '양파', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=120 AND ri.name='양파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 120, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진마늘', '1스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=120 AND ri.name='다진마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 120, (SELECT id FROM ingredients WHERE name='고춧가루' LIMIT 1), '고춧가루', '1.5~2스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고춧가루') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=120 AND ri.name='고춧가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 120, NULL, '액젓', '1.5스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=120 AND ri.name='액젓');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 120, NULL, '설탕', '0.3~0.5스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=120 AND ri.name='설탕');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 120, NULL, '식초', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=120 AND ri.name='식초');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 120, (SELECT id FROM ingredients WHERE name='참깨' LIMIT 1), '깨', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='참깨') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=120 AND ri.name='깨');

-- recipe 121: [오메추] 베이컨 쪽파 크림치즈 베이글 (i34NZ5UriUg)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 121, '베이컨 쪽파 크림치즈 베이글', '베이컨, 쪽파, 크림치즈를 올린 베이글 샌드위치.', 'thumbnails/i34NZ5UriUg.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=121);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 121, NULL, '베이글', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=121 AND ri.name='베이글');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 121, NULL, '베이컨', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=121 AND ri.name='베이컨');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 121, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '쪽파', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=121 AND ri.name='쪽파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 121, NULL, '크림치즈', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=121 AND ri.name='크림치즈');

-- recipe 122: [오메추] 쪽파크림리조또 (j65-rj_EH9U)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 122, '쪽파크림리조또', '생크림 없이 간단하게 만드는 쪽파크림리조또.', 'thumbnails/j65-rj_EH9U.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=122);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 122, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '쪽파', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=122 AND ri.name='쪽파');

-- recipe 123: [오메추] 상추겉절이 (kNwhrctXQtE)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 123, '상추겉절이', '상추로 만드는 겉절이 반찬이다.', 'thumbnails/kNwhrctXQtE.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=123);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 123, (SELECT id FROM ingredients WHERE name='상추' LIMIT 1), '상추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='상추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=123 AND ri.name='상추');

-- recipe 124: [오메추] 매콤양배추참치덮밥 (lCGo8uUgDC0)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 124, '매콤양배추참치덮밥', '양배추와 참치캔을 고추장·고춧가루로 매콤하게 볶아 밥 위에 올린 다이어트 덮밥.', 'thumbnails/lCGo8uUgDC0.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=124);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 124, 1, '양배추, 양파, 청양고추는 먹기 좋게 자른다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=124 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 124, 2, '팬에 기름 두르고 다진 마늘, 양배추, 양파, 청양고추를 볶는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=124 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 124, 3, '어느 정도 익으면 고춧가루, 진간장, 고추장, 설탕을 넣고 볶다가 참치를 넣고 살짝 볶은 뒤 깨를 뿌린다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=124 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 124, 4, '밥 위에 올리고 참기름을 뿌려 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=124 AND step_number=4);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 124, (SELECT id FROM ingredients WHERE name='양배추' LIMIT 1), '양배추', '350g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양배추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=124 AND ri.name='양배추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 124, NULL, '참치', '1캔 150g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=124 AND ri.name='참치');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 124, (SELECT id FROM ingredients WHERE name='양파' LIMIT 1), '양파', '큰거 반개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=124 AND ri.name='양파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 124, (SELECT id FROM ingredients WHERE name='청양고추' LIMIT 1), '청양고추', '취향에 맞게', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='청양고추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=124 AND ri.name='청양고추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 124, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '1스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=124 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 124, (SELECT id FROM ingredients WHERE name='고춧가루' LIMIT 1), '고춧가루', '2스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고춧가루') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=124 AND ri.name='고춧가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 124, NULL, '고추장', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=124 AND ri.name='고추장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 124, NULL, '진간장', '2~3스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=124 AND ri.name='진간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 124, NULL, '설탕', '0.5~1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=124 AND ri.name='설탕');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 124, (SELECT id FROM ingredients WHERE name='참깨' LIMIT 1), '깨', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='참깨') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=124 AND ri.name='깨');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 124, NULL, '참기름', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=124 AND ri.name='참기름');

-- recipe 125: [오메추] 멸치무조림 (lW4a3ga0AbU)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 125, '멸치무조림', '가을 무와 멸치로 만드는 밥도둑 무조림 레시피.', 'thumbnails/lW4a3ga0AbU.webp', 'MEDIUM', 40, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=125);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 125, 1, '국물용 멸치는 머리와 내장을 제거 후 전자레인지에 40초~1분 돌리거나 마른 팬에 덖어 비린내를 날린다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=125 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 125, 2, '무는 반달 또는 동그랗게 1.5~2cm 두께로 자른다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=125 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 125, 3, '냄비에 무, 멸치, 물, 맛술, 다진 마늘, 진간장, 액젓, 설탕, 고춧가루를 넣고 강불로 끓기 시작하면 5분 끓인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=125 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 125, 4, '뚜껑을 덮고 중약불로 20분 이상 끓인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=125 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 125, 5, '무가 익으면 뚜껑을 열고 약불로 조린 뒤 들기름과 대파를 넣고 5분 더 끓여 완성한다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=125 AND step_number=5);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 125, (SELECT id FROM ingredients WHERE name='무' LIMIT 1), '무', '1kg', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='무') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=125 AND ri.name='무');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 125, NULL, '국물용 멸치', '30~40g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=125 AND ri.name='국물용 멸치');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 125, NULL, '물', '800ml', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=125 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 125, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '1스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=125 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 125, NULL, '맛술', '3스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=125 AND ri.name='맛술');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 125, NULL, '진간장', '6스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=125 AND ri.name='진간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 125, NULL, '액젓', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=125 AND ri.name='액젓');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 125, NULL, '설탕', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=125 AND ri.name='설탕');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 125, (SELECT id FROM ingredients WHERE name='고춧가루' LIMIT 1), '고춧가루', '3스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고춧가루') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=125 AND ri.name='고춧가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 125, NULL, '들기름', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=125 AND ri.name='들기름');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 125, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '대파', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=125 AND ri.name='대파');

-- recipe 126: [오메추] 배추된장국 (lhoRZI3nLBM)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 126, '배추된장국', '아침 국으로 추천하는 따뜻한 배추된장국.', 'thumbnails/lhoRZI3nLBM.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=126);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 126, (SELECT id FROM ingredients WHERE name='배추' LIMIT 1), '배추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='배추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=126 AND ri.name='배추');

-- recipe 127: [오메추] 오이고추된장무침 (m1ICCOqb7hM)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 127, '오이고추된장무침', '5분도 안 걸리는 초간단 오이고추 된장무침으로 물밥이나 고기와 곁들이기 좋은 반찬.', 'thumbnails/m1ICCOqb7hM.webp', 'EASY', 5, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=127);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 127, 1, '오이고추는 큼직하게 자른다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=127 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 127, 2, '된장, 마늘, 참기름, 깨 양념에 고추를 버무리면 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=127 AND step_number=2);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 127, (SELECT id FROM ingredients WHERE name='오이고추' LIMIT 1), '오이고추', '4~5개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='오이고추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=127 AND ri.name='오이고추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 127, NULL, '된장', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=127 AND ri.name='된장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 127, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '1/2스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=127 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 127, NULL, '참기름', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=127 AND ri.name='참기름');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 127, (SELECT id FROM ingredients WHERE name='참깨' LIMIT 1), '깨', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='참깨') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=127 AND ri.name='깨');

-- recipe 128: [오메추] 감자계란국 (nwkfTBwXGX0)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 128, '감자계란국', '육수 없이 끓이는 간단한 감자계란국 레시피.', 'thumbnails/nwkfTBwXGX0.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=128);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 128, (SELECT id FROM ingredients WHERE name='감자' LIMIT 1), '감자', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='감자') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=128 AND ri.name='감자');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 128, NULL, '계란', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=128 AND ri.name='계란');

-- recipe 129: [오메추] 양배추참치마요샐러드 (nxqwWP3ukMc)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 129, '양배추참치마요샐러드', '다이어트와 술안주로 좋은 양배추 참치마요 샐러드.', 'thumbnails/nxqwWP3ukMc.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=129);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 129, (SELECT id FROM ingredients WHERE name='양배추' LIMIT 1), '양배추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양배추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=129 AND ri.name='양배추');

-- recipe 130: [오메추] 차돌박이 채소찜 (o89NUFpC9Bs)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 130, '차돌박이 채소찜', '찜기 없이 뚜껑 있는 팬에 배추·청경채·쪽파를 깔고 우삼겹을 올려 중불로 쪄내는 간단 채소찜이다.', 'thumbnails/o89NUFpC9Bs.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=130);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 130, 1, '팬 바닥에 채소(배추, 청경채 등) 가득 깔기' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=130 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 130, 2, '채소 위에 우삼겹 올리고 맛술 뿌린 뒤 소금·후추 뿌리고 뚜껑 덮어 중불 7~8분' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=130 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 130, 3, '소스 만들어 찜 완성 후 찍어 먹기' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=130 AND step_number=3);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 130, (SELECT id FROM ingredients WHERE name='배추' LIMIT 1), '배추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='배추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=130 AND ri.name='배추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 130, (SELECT id FROM ingredients WHERE name='청경채' LIMIT 1), '청경채', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='청경채') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=130 AND ri.name='청경채');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 130, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '쪽파', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=130 AND ri.name='쪽파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 130, NULL, '우삼겹', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=130 AND ri.name='우삼겹');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 130, NULL, '미림', '2~3스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=130 AND ri.name='미림');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 130, NULL, '소금', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=130 AND ri.name='소금');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 130, NULL, '후추', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=130 AND ri.name='후추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 130, NULL, '진간장', '2스푼(소스)', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=130 AND ri.name='진간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 130, NULL, '식초', '2스푼(소스)', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=130 AND ri.name='식초');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 130, NULL, '설탕', '1스푼(소스)', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=130 AND ri.name='설탕');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 130, NULL, '물', '1~2스푼(소스)', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=130 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 130, NULL, '연겨자', '취향껏(소스)', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=130 AND ri.name='연겨자');

-- recipe 131: [오메추] 배추전 (ote0LzjywZw)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 131, '배추전', '알배추에 부침가루 반죽을 입혀 노릇하게 부친 달달고소한 전.', 'thumbnails/ote0LzjywZw.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=131);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 131, 1, '알배추를 깨끗이 씻고 칼등으로 두드려 편다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=131 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 131, 2, '부침가루와 물을 1:1 비율로 반죽한다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=131 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 131, 3, '알배추를 반죽에 골고루 묻혀 기름을 넉넉히 두른 팬에서 중약불로 노릇하게 굽는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=131 AND step_number=3);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 131, (SELECT id FROM ingredients WHERE name='알배기배추' LIMIT 1), '알배추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='알배기배추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=131 AND ri.name='알배추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 131, NULL, '부침가루', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=131 AND ri.name='부침가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 131, NULL, '물', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=131 AND ri.name='물');

-- recipe 132: [오메추] 참치무조림 (p8ZAky6gLI0)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 132, '참치무조림', '전자레인지로 무를 미리 익혀 조리시간을 단축한 초간단 참치무조림이다.', 'thumbnails/p8ZAky6gLI0.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=132);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 132, 1, '무는 껍질을 벗긴 후 1~1.5cm 두께로 자르고 물 2~3스푼 뿌려 랩 씌워 전자레인지에 5~6분 돌린다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=132 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 132, 2, '냄비에 무를 넣고 진간장, 참치액, 고춧가루, 올리고당, 다진 마늘, 물을 넣고 10분 끓인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=132 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 132, 3, '마지막에 대파, 참치캔, 홍고추를 넣고 살짝 더 끓이면 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=132 AND step_number=3);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 132, (SELECT id FROM ingredients WHERE name='무' LIMIT 1), '무', '500g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='무') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=132 AND ri.name='무');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 132, NULL, '물', '350ml', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=132 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 132, NULL, '참치', '150g 1캔', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=132 AND ri.name='참치');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 132, NULL, '진간장', '3스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=132 AND ri.name='진간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 132, NULL, '참치액', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=132 AND ri.name='참치액');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 132, (SELECT id FROM ingredients WHERE name='고춧가루' LIMIT 1), '고춧가루', '3스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고춧가루') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=132 AND ri.name='고춧가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 132, NULL, '올리고당', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=132 AND ri.name='올리고당');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 132, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '1스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=132 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 132, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '대파', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=132 AND ri.name='대파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 132, (SELECT id FROM ingredients WHERE name='붉은고추' LIMIT 1), '홍고추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='붉은고추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=132 AND ri.name='홍고추');

-- recipe 133: [오메추] 이자카야 감자샐러드 (qDESreY6OCo)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 133, '이자카야 감자샐러드', '일본 이자카야 스타일의 감자샐러드 레시피다.', 'thumbnails/qDESreY6OCo.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=133);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 133, (SELECT id FROM ingredients WHERE name='감자' LIMIT 1), '감자', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='감자') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=133 AND ri.name='감자');

-- recipe 134: [오메추] 양배추요리 (qEj61zKffQU)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 134, '양배추요리', '양배추 한 통을 활용한 요리.', 'thumbnails/qEj61zKffQU.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=134);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 134, (SELECT id FROM ingredients WHERE name='양배추' LIMIT 1), '양배추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양배추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=134 AND ri.name='양배추');

-- recipe 135: [오메추] 대파육개장 (rEumUMiwBiI)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 135, '대파육개장', '우삼겹과 대파를 사골 육수에 끓여 20분 만에 완성하는 초간단 대파육개장.', 'thumbnails/rEumUMiwBiI.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=135);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 135, 1, '대파는 반 갈라 6~7cm로 썰고, 양파는 두껍게 채썬다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=135 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 135, 2, '냄비에 우삼겹을 볶다가 어느 정도 익으면 대파를 넣고 숨이 살짝 죽을 때까지 볶는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=135 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 135, 3, '고춧가루를 넣고 약불로 타지 않게 1분 볶는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=135 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 135, 4, '사골곰탕 육수, 물, 국간장, 다진 마늘, 양파를 넣고 뚜껑 덮어 중약불로 10분 이상 끓인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=135 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 135, 5, '대파가 푹 익으면 후추를 뿌려 마무리.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=135 AND step_number=5);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 135, NULL, '우삼겹', '300g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=135 AND ri.name='우삼겹');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 135, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '대파', '2~3대', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=135 AND ri.name='대파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 135, (SELECT id FROM ingredients WHERE name='양파' LIMIT 1), '양파', '1/2개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=135 AND ri.name='양파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 135, (SELECT id FROM ingredients WHERE name='고춧가루' LIMIT 1), '고춧가루', '3스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고춧가루') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=135 AND ri.name='고춧가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 135, NULL, '사골곰탕 육수', '500ml', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=135 AND ri.name='사골곰탕 육수');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 135, NULL, '물', '300ml', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=135 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 135, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '1스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=135 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 135, NULL, '국간장', '2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=135 AND ri.name='국간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 135, NULL, '소금', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=135 AND ri.name='소금');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 135, NULL, '후추', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=135 AND ri.name='후추');

-- recipe 136: [오메추] 양파땡초전 (rG9Ks9Wbtus)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 136, '양파땡초전', '양파와 청양고추로 만드는 달달하고 매콤한 부침개.', 'thumbnails/rG9Ks9Wbtus.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=136);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 136, 1, '양파는 얇게 채썰고 청양고추는 잘게 썬다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=136 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 136, 2, '계란 2개, 소금 약간, 부침가루 1스푼 넣고 반죽한다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=136 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 136, 3, '팬에 기름 두르고 한 스푼씩 떠서 올린 뒤 중약불로 노릇하게 굽는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=136 AND step_number=3);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 136, (SELECT id FROM ingredients WHERE name='양파' LIMIT 1), '양파', '반개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=136 AND ri.name='양파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 136, (SELECT id FROM ingredients WHERE name='청양고추' LIMIT 1), '청양고추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='청양고추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=136 AND ri.name='청양고추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 136, NULL, '계란', '2개', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=136 AND ri.name='계란');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 136, NULL, '부침가루', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=136 AND ri.name='부침가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 136, NULL, '소금', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=136 AND ri.name='소금');

-- recipe 137: [오메추] 마늘빵 (rIV8-nhqfWQ)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 137, '마늘빵', '식빵에 버터와 다진 마늘 소스를 발라 에어프라이어에 구운 바삭 달달한 마늘빵.', 'thumbnails/rIV8-nhqfWQ.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=137);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 137, 1, '버터를 전자레인지에 40초 돌려 녹인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=137 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 137, 2, '녹인 버터에 설탕, 다진마늘, 소금, 파슬리를 넣고 섞는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=137 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 137, 3, '식빵을 3등분으로 길게 자른다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=137 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 137, 4, '식빵에 마늘 소스를 바르고 에어프라이어 180도에서 7분 구우면 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=137 AND step_number=4);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 137, NULL, '식빵', '2장', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=137 AND ri.name='식빵');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 137, NULL, '버터', '2조각(20g)', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=137 AND ri.name='버터');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 137, NULL, '설탕', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=137 AND ri.name='설탕');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 137, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '1스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=137 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 137, NULL, '소금', '1/2티스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=137 AND ri.name='소금');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 137, NULL, '파슬리', '1/3스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=137 AND ri.name='파슬리');

-- recipe 138: [오메추] 스키야키 (rIgFCbPJ9gQ)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 138, '스키야키', '달달짭조름한 소스에 소고기와 채소를 넣어 끓이는 일본식 스키야키로 날계란에 찍어먹는다.', 'thumbnails/rIgFCbPJ9gQ.webp', 'MEDIUM', 30, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=138);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 138, NULL, '진간장', '80ml(약 8스푼)', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=138 AND ri.name='진간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 138, NULL, '정종', '100ml', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=138 AND ri.name='정종');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 138, NULL, '미림', '200ml', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=138 AND ri.name='미림');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 138, NULL, '설탕', '2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=138 AND ri.name='설탕');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 138, (SELECT id FROM ingredients WHERE name='배추' LIMIT 1), '배추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='배추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=138 AND ri.name='배추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 138, (SELECT id FROM ingredients WHERE name='양파' LIMIT 1), '양파', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=138 AND ri.name='양파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 138, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '대파', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=138 AND ri.name='대파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 138, (SELECT id FROM ingredients WHERE name='청경채' LIMIT 1), '청경채', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='청경채') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=138 AND ri.name='청경채');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 138, NULL, '두부', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=138 AND ri.name='두부');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 138, NULL, '실곤약', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=138 AND ri.name='실곤약');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 138, NULL, '버섯', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=138 AND ri.name='버섯');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 138, NULL, '소고기', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=138 AND ri.name='소고기');

-- recipe 139: [오메추] 통마늘닭백숙 (rKne1XjTcl8)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 139, '통마늘닭백숙', '약재 없이 통마늘, 대파, 양파만 넣고 1시간 끓여 만드는 야들야들한 닭백숙.', 'thumbnails/rKne1XjTcl8.webp', 'MEDIUM', 75, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=139);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 139, 1, '생닭은 날개 끝, 꽁지, 지방 많은 부분을 손질한다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=139 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 139, 2, '냄비에 닭, 통마늘, 대파, 양파, 닭이 잠길 만큼의 물, 소금 약간을 넣고 센불로 5분 끓인 뒤 뚜껑 덮고 중불~중약불로 1시간 끓인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=139 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 139, 3, '소스 재료(간장, 식초, 물, 설탕, 채썬 양파, 다진 마늘, 청양고추, 연겨자)를 섞어 찍어먹는 소스를 만든다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=139 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 139, 4, '1시간 뒤 대파와 양파를 건져내고 부추를 올린 뒤 국물을 끼얹어 살짝 익힌다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=139 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 139, 5, '닭고기는 소스에 찍어먹고 남은 국물에 죽을 끓여 마무리한다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=139 AND step_number=5);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 139, NULL, '생닭', '1.2kg', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=139 AND ri.name='생닭');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 139, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '통마늘', '40알', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=139 AND ri.name='통마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 139, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '대파', '1/2대', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=139 AND ri.name='대파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 139, (SELECT id FROM ingredients WHERE name='양파' LIMIT 1), '양파', '1/2개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=139 AND ri.name='양파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 139, NULL, '소금', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=139 AND ri.name='소금');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 139, (SELECT id FROM ingredients WHERE name='부추' LIMIT 1), '부추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='부추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=139 AND ri.name='부추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 139, NULL, '양조간장', '6스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=139 AND ri.name='양조간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 139, NULL, '식초', '6스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=139 AND ri.name='식초');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 139, NULL, '물', '2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=139 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 139, NULL, '설탕', '3스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=139 AND ri.name='설탕');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 139, (SELECT id FROM ingredients WHERE name='양파' LIMIT 1), '채썬 양파', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=139 AND ri.name='채썬 양파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 139, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '1/3스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=139 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 139, (SELECT id FROM ingredients WHERE name='청양고추' LIMIT 1), '청양고추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='청양고추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=139 AND ri.name='청양고추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 139, NULL, '연겨자', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=139 AND ri.name='연겨자');

-- recipe 140: [오메추] 김치콩나물국 (rbiXzI0Gbr0)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 140, '김치콩나물국', '김치와 콩나물을 멸치육수에 끓여 속을 시원하게 풀어주는 해장국.', 'thumbnails/rbiXzI0Gbr0.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=140);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 140, 1, '육수 1.5L에 썬 김치와 김칫국물 100ml를 넣고 중불로 10분 끓인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=140 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 140, 2, '멸치액젓으로 간하고 콩나물, 다진 마늘, 고춧가루를 넣고 끓인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=140 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 140, 3, '콩나물이 익으면 대파 넣고 한소끔 끓이면 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=140 AND step_number=3);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 140, (SELECT id FROM ingredients WHERE name='콩나물' LIMIT 1), '콩나물', '200g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='콩나물') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=140 AND ri.name='콩나물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 140, NULL, '김치', '200g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=140 AND ri.name='김치');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 140, NULL, '김칫국물', '100ml', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=140 AND ri.name='김칫국물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 140, NULL, '멸치육수', '1.5L', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=140 AND ri.name='멸치육수');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 140, NULL, '멸치액젓', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=140 AND ri.name='멸치액젓');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 140, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진마늘', '0.5스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=140 AND ri.name='다진마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 140, (SELECT id FROM ingredients WHERE name='고춧가루' LIMIT 1), '고춧가루', '2스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고춧가루') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=140 AND ri.name='고춧가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 140, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '대파', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=140 AND ri.name='대파');

-- recipe 141: [오메추] 베이컨 마늘볶음밥 (rjhoBi-mhMk)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 141, '베이컨 마늘볶음밥', '통마늘과 베이컨을 넣어 만든 굴소스 베이컨 마늘볶음밥이다.', 'thumbnails/rjhoBi-mhMk.webp', 'EASY', 15, 1, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=141);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 141, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '통마늘', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=141 AND ri.name='통마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 141, NULL, '베이컨', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=141 AND ri.name='베이컨');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 141, NULL, '계란', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=141 AND ri.name='계란');

-- recipe 142: [오메추] 고추장 감자조림 (s4gf0XPZwgc)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 142, '고추장 감자조림', '고추장 양념으로 만드는 감자조림 반찬이다.', 'thumbnails/s4gf0XPZwgc.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=142);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 142, (SELECT id FROM ingredients WHERE name='감자' LIMIT 1), '감자', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='감자') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=142 AND ri.name='감자');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 142, NULL, '고추장', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=142 AND ri.name='고추장');

-- recipe 143: [오메추] 애호박볶음 (sCC7JDRd0UE)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 143, '애호박볶음', '간단하게 만드는 애호박볶음 반찬.', 'thumbnails/sCC7JDRd0UE.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=143);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 143, (SELECT id FROM ingredients WHERE name='호박' LIMIT 1), '애호박', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='호박') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=143 AND ri.name='애호박');

-- recipe 144: [오메추] 매콤팽이버섯덮밥 (tZRcGwU0sSM)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 144, '매콤팽이버섯덮밥', '10분 안에 완성되는 매콤한 팽이버섯볶음을 밥 위에 올리고 계란후라이를 얹은 간단 덮밥.', 'thumbnails/tZRcGwU0sSM.webp', 'EASY', 10, 1, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=144);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 144, 1, '진간장, 고추장, 다진 마늘, 고춧가루, 올리고당, 물을 섞어 양념장을 만든다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=144 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 144, 2, '양파는 채 썰고, 대파는 송송 썰고, 팽이버섯은 밑동을 제거해 2~3등분한다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=144 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 144, 3, '팬에 계란후라이를 부쳐 빼두고, 같은 팬에 양파와 대파를 반쯤 익을 때까지 볶는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=144 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 144, 4, '팽이버섯을 넣고 숨이 죽으면 양념장을 넣어 약불에서 볶는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=144 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 144, 5, '불을 끄고 참기름으로 마무리한 뒤 밥 위에 팽이버섯볶음과 계란후라이를 올리면 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=144 AND step_number=5);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 144, NULL, '밥', '한공기', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=144 AND ri.name='밥');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 144, NULL, '계란', '1개', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=144 AND ri.name='계란');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 144, (SELECT id FROM ingredients WHERE name='팽이버섯' LIMIT 1), '팽이버섯', '1봉(150g)', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='팽이버섯') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=144 AND ri.name='팽이버섯');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 144, (SELECT id FROM ingredients WHERE name='양파' LIMIT 1), '양파', '작은 1/2개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=144 AND ri.name='양파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 144, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '대파', '1/4대', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=144 AND ri.name='대파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 144, NULL, '진간장', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=144 AND ri.name='진간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 144, NULL, '고추장', '0.5스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=144 AND ri.name='고추장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 144, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '0.5스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=144 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 144, (SELECT id FROM ingredients WHERE name='고춧가루' LIMIT 1), '고춧가루', '1스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고춧가루') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=144 AND ri.name='고춧가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 144, NULL, '올리고당', '0.5스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=144 AND ri.name='올리고당');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 144, NULL, '물', '3스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=144 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 144, NULL, '참기름', '0.5스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=144 AND ri.name='참기름');

-- recipe 145: [오메추] 꽈리고추삼겹살볶음 (uFkeY4-BTmY)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 145, '꽈리고추삼겹살볶음', '된장 베이스 소스로 만드는 단짠 삼겹살에 아삭한 꽈리고추를 더한 밥도둑 술안주.', 'thumbnails/uFkeY4-BTmY.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=145);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 145, 1, '된장, 진간장, 설탕, 맛술을 넣고 소스를 만든다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=145 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 145, 2, '팬에 삼겹살을 볶다가 거의 다 익으면 다진 마늘을 넣는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=145 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 145, 3, '고기가 노릇하게 익으면 꽈리고추와 소스를 넣고 볶는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=145 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 145, 4, '꽈리고추가 원하는 식감까지 볶으면 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=145 AND step_number=4);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 145, NULL, '삼겹살', '300g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=145 AND ri.name='삼겹살');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 145, (SELECT id FROM ingredients WHERE name='꽈리고추' LIMIT 1), '꽈리고추', '150g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='꽈리고추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=145 AND ri.name='꽈리고추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 145, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '1스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=145 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 145, NULL, '된장', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=145 AND ri.name='된장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 145, NULL, '진간장', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=145 AND ri.name='진간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 145, NULL, '설탕', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=145 AND ri.name='설탕');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 145, NULL, '맛술', '3스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=145 AND ri.name='맛술');

-- recipe 146: [오메추] 시금치나물 (upU5k6FO5pw)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 146, '시금치나물', '시금치를 데쳐 양념에 무치는 기본 나물 반찬.', 'thumbnails/upU5k6FO5pw.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=146);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 146, (SELECT id FROM ingredients WHERE name='시금치' LIMIT 1), '시금치', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='시금치') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=146 AND ri.name='시금치');

-- recipe 147: [오메추] 들깨뭇국 (v2-RM-QujYs)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 147, '들깨뭇국', '구수하고 따뜻한 들깨뭇국.', 'thumbnails/v2-RM-QujYs.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=147);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 147, (SELECT id FROM ingredients WHERE name='무' LIMIT 1), '무', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='무') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=147 AND ri.name='무');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 147, (SELECT id FROM ingredients WHERE name='참깨' LIMIT 1), '들깨', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='참깨') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=147 AND ri.name='들깨');

-- recipe 148: [오메추] 알배추 배추생채 (v6vklVk43FE)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 148, '알배추 배추생채', '알배추를 채썰어 고춧가루 액젓 양념으로 버무린 5분 완성 겉절이 스타일 반찬이다.', 'thumbnails/v6vklVk43FE.webp', 'EASY', 5, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=148);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 148, (SELECT id FROM ingredients WHERE name='알배기배추' LIMIT 1), '알배추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='알배기배추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=148 AND ri.name='알배추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 148, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=148 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 148, (SELECT id FROM ingredients WHERE name='고춧가루' LIMIT 1), '고춧가루', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고춧가루') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=148 AND ri.name='고춧가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 148, NULL, '액젓', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=148 AND ri.name='액젓');

-- recipe 149: [오메추] 오이젓갈두부삼합 (wSgWcrtE2_A)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 149, '오이젓갈두부삼합', '오이, 젓갈, 두부를 조합한 초간단 술안주 삼합이다.', 'thumbnails/wSgWcrtE2_A.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=149);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 149, (SELECT id FROM ingredients WHERE name='오이' LIMIT 1), '오이', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='오이') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=149 AND ri.name='오이');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 149, NULL, '두부', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=149 AND ri.name='두부');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 149, NULL, '젓갈', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=149 AND ri.name='젓갈');

-- recipe 150: [오메추] 차돌박이냉이솥밥 (xJ6y4AYAEPM)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 150, '차돌박이냉이솥밥', '냉이 향 가득한 차돌박이 솥밥으로 손님초대요리로도 추천하는 인생 레시피.', 'thumbnails/xJ6y4AYAEPM.webp', 'MEDIUM', 60, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=150);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 150, 1, '쌀 두컵은 씻어 체에 받쳐 30분간 마른 불림한다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=150 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 150, 2, '냉이를 손질 후 깨끗이 씻고 두꺼운 뿌리는 먹기 좋게, 잎도 큼지막하게 자른다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=150 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 150, 3, '달궈진 냄비에 차돌박이를 굽다가 설탕, 진간장, 액젓을 넣고 볶은 뒤 빼둔다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=150 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 150, 4, '불린 쌀과 진간장 2스푼을 넣고 1분 볶다가 물 두컵을 넣고 센불로 끓인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=150 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 150, 5, '끓기 시작하면 살짝 저어주고 냉이 뿌리를 올린 뒤 뚜껑 덮고 약불로 10~15분 익힌다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=150 AND step_number=5);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 150, 6, '불을 끄고 냉이 잎, 차돌박이, 버터를 올린 뒤 뚜껑 덮고 5~10분 뜸을 들이면 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=150 AND step_number=6);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 150, (SELECT id FROM ingredients WHERE name='쌀' LIMIT 1), '쌀', '2컵', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='쌀') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=150 AND ri.name='쌀');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 150, NULL, '물', '2컵', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=150 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 150, NULL, '차돌박이', '150g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=150 AND ri.name='차돌박이');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 150, (SELECT id FROM ingredients WHERE name='냉이' LIMIT 1), '냉이', '150g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='냉이') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=150 AND ri.name='냉이');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 150, NULL, '버터', '10g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=150 AND ri.name='버터');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 150, NULL, '진간장', '2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=150 AND ri.name='진간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 150, NULL, '액젓', '0.5스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=150 AND ri.name='액젓');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 150, NULL, '설탕', '0.7스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=150 AND ri.name='설탕');

-- recipe 151: [오메추] 콩나물찜 (xWmnE8q6b8U)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 151, '콩나물찜', '소시지와 어묵을 넣어 만드는 매콤한 콩나물찜.', 'thumbnails/xWmnE8q6b8U.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=151);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 151, 1, '어묵, 소시지, 양파, 대파를 먹기 좋게 썬다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=151 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 151, 2, '고춧가루, 진간장, 참치액, 설탕, 다시다, 전분가루, 다진 마늘, 물 2스푼, 후추를 섞어 양념장을 만든다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=151 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 151, 3, '웍에 콩나물, 물 200ml, 소시지, 어묵, 양파, 대파, 양념장을 올리고 뚜껑 덮어 중불로 3분 익힌다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=151 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 151, 4, '3분 뒤 빠르게 섞고 참기름, 깨를 뿌리면 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=151 AND step_number=4);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 151, (SELECT id FROM ingredients WHERE name='콩나물' LIMIT 1), '콩나물', '500g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='콩나물') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=151 AND ri.name='콩나물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 151, NULL, '소시지', '100g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=151 AND ri.name='소시지');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 151, NULL, '어묵', '150g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=151 AND ri.name='어묵');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 151, (SELECT id FROM ingredients WHERE name='양파' LIMIT 1), '양파', '1/2개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=151 AND ri.name='양파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 151, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '대파', '1/2대', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=151 AND ri.name='대파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 151, NULL, '물', '200ml', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=151 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 151, (SELECT id FROM ingredients WHERE name='고춧가루' LIMIT 1), '고춧가루', '4스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고춧가루') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=151 AND ri.name='고춧가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 151, NULL, '진간장', '4스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=151 AND ri.name='진간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 151, NULL, '참치액', '2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=151 AND ri.name='참치액');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 151, NULL, '설탕', '1/3스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=151 AND ri.name='설탕');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 151, NULL, '다시다', '1/3스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=151 AND ri.name='다시다');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 151, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '1스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=151 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 151, NULL, '전분가루', '1/2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=151 AND ri.name='전분가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 151, NULL, '후추', '약간', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=151 AND ri.name='후추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 151, NULL, '참기름', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=151 AND ri.name='참기름');

-- recipe 152: [오메추] 부추된장국 (y7lu84jrbtw)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 152, '부추된장국', '부추를 마지막에 살짝만 끓여 향을 살린 10분 완성 된장국이다.', 'thumbnails/y7lu84jrbtw.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=152);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 152, 1, '부추를 깨끗이 씻어 4~5cm 크기로 썰기' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=152 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 152, 2, '냄비에 물, 코인육수, 고추장, 된장 넣고 끓이기' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=152 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 152, 3, '액젓·국간장 등으로 간 맞추기' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=152 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 152, 4, '부추, 다진 마늘 넣고 살짝만 끓이면 완성' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=152 AND step_number=4);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 152, (SELECT id FROM ingredients WHERE name='부추' LIMIT 1), '부추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='부추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=152 AND ri.name='부추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 152, NULL, '물', '600ml', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=152 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 152, NULL, '코인육수', '1개', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=152 AND ri.name='코인육수');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 152, NULL, '고추장', '1/3스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=152 AND ri.name='고추장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 152, NULL, '된장', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=152 AND ri.name='된장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 152, NULL, '액젓', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=152 AND ri.name='액젓');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 152, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '1티스푼(생략가능)', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=152 AND ri.name='다진 마늘');

-- recipe 153: [오메추] 지마미도후(땅콩두부) (yY2d95erZow)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 153, '지마미도후(땅콩두부)', '오키나와 전통 방식으로 생땅콩을 갈아 타피오카 전분으로 굳힌 쫀득한 땅콩두부에 흑당 시럽을 곁들인 요리.', 'thumbnails/yY2d95erZow.webp', 'MEDIUM', 60, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=153);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 153, 1, '생땅콩을 물에 담가 냉장고에서 하룻밤 불린 뒤 껍질을 제거한다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=153 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 153, 2, '물 600ml를 붓고 곱게 갈아 면보자기로 꾹 짜서 땅콩물만 사용한다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=153 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 153, 3, '땅콩물에 소금, 타피오카 전분을 넣고 덩어리 없이 잘 풀어준다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=153 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 153, 4, '냄비에 옮겨 약불에서 바닥이 눌지 않게 계속 저어가며 약 20~30분 익힌다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=153 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 153, 5, '풋내가 사라지고 원하는 질감이 되면 불을 끄고 틀에 담아 냉장 보관한다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=153 AND step_number=5);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 153, 6, '냄비에 흑당, 물, 간장을 넣고 녹여 끓인 뒤 시럽을 만든다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=153 AND step_number=6);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 153, 7, '땅콩두부에 흑당 시럽을 뿌려 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=153 AND step_number=7);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 153, (SELECT id FROM ingredients WHERE name='콩' LIMIT 1), '생땅콩', '200g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='콩') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=153 AND ri.name='생땅콩');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 153, NULL, '물', '600ml', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=153 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 153, NULL, '타피오카 전분', '60g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=153 AND ri.name='타피오카 전분');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 153, NULL, '소금', '약간', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=153 AND ri.name='소금');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 153, NULL, '흑당', '50g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=153 AND ri.name='흑당');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 153, NULL, '간장', '1/3스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=153 AND ri.name='간장');

-- recipe 154: [오메추] 양배추삼겹살볶음 (yr_rx7mnT0U)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 154, '양배추삼겹살볶음', '양배추와 삼겹살을 굴소스로 볶아 반찬·덮밥·술안주로 모두 활용 가능한 간단 볶음 요리.', 'thumbnails/yr_rx7mnT0U.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=154);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 154, 1, '양배추는 채썰고, 청양고추(선택)와 삼겹살은 먹기 좋게 썬다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=154 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 154, 2, '달궈진 팬에 식용유 3스푼을 넣고 삼겹살을 볶다가 하얗게 익으면 다진 마늘을 넣고 볶는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=154 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 154, 3, '노릇하게 익으면 청양고추(선택), 간장 1큰술을 넣고 살짝 볶다가 양배추를 넣고 볶는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=154 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 154, 4, '양배추가 살짝 숨이 죽으면 굴소스로 간을 맞추고 원하는 식감까지 볶는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=154 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 154, 5, '마무리로 후추, 참기름을 뿌리고 살짝 볶으면 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=154 AND step_number=5);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 154, (SELECT id FROM ingredients WHERE name='양배추' LIMIT 1), '양배추', '300g', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양배추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=154 AND ri.name='양배추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 154, NULL, '삼겹살', '150g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=154 AND ri.name='삼겹살');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 154, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '1큰술', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=154 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 154, NULL, '간장', '1큰술', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=154 AND ri.name='간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 154, NULL, '굴소스', '1큰술', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=154 AND ri.name='굴소스');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 154, NULL, '후추', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=154 AND ri.name='후추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 154, NULL, '참기름', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=154 AND ri.name='참기름');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 154, (SELECT id FROM ingredients WHERE name='청양고추' LIMIT 1), '청양고추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='청양고추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=154 AND ri.name='청양고추');

-- recipe 155: [오메추] 아보카도 명란비빔밥 (z8oLErCYo_8)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 155, '아보카도 명란비빔밥', '아보카도, 명란젓, 계란후라이를 올린 한끼 비빔밥.', 'thumbnails/z8oLErCYo_8.webp', 'EASY', 10, 1, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=155);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 155, 1, '양파는 얇게 채썰고, 아보카도는 반으로 갈라 씨·껍질 제거 후 먹기 좋게 썬다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=155 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 155, 2, '명란젓은 막을 제거하거나 먹기 좋게 썬다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=155 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 155, 3, '계란후라이를 만들고 밥 위에 채썬 양파, 계란후라이, 아보카도, 명란젓, 쪽파를 올린 후 참기름을 뿌려 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=155 AND step_number=3);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 155, NULL, '밥', '한공기', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=155 AND ri.name='밥');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 155, (SELECT id FROM ingredients WHERE name='양파' LIMIT 1), '양파', '약간', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=155 AND ri.name='양파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 155, NULL, '명란젓', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=155 AND ri.name='명란젓');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 155, NULL, '계란', '1개', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=155 AND ri.name='계란');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 155, (SELECT id FROM ingredients WHERE name='아보카도' LIMIT 1), '아보카도', '1/2개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='아보카도') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=155 AND ri.name='아보카도');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 155, NULL, '참기름', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=155 AND ri.name='참기름');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 155, (SELECT id FROM ingredients WHERE name='파' LIMIT 1), '쪽파', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=155 AND ri.name='쪽파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 155, NULL, '양조간장', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=155 AND ri.name='양조간장');

-- recipe 156: [오메추] 양파장아찌 (zDNjz4o4_vY)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 156, '양파장아찌', '물·간장·식초·설탕 1:1:1:1 비율로 담그는 양파장아찌.', 'thumbnails/zDNjz4o4_vY.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=156);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 156, (SELECT id FROM ingredients WHERE name='양파' LIMIT 1), '양파', '2개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=156 AND ri.name='양파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 156, NULL, '물', '100ml', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=156 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 156, NULL, '진간장', '100ml', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=156 AND ri.name='진간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 156, NULL, '식초', '100ml', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=156 AND ri.name='식초');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 156, NULL, '설탕', '70ml', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=156 AND ri.name='설탕');

-- recipe 157: [오메추] 새우부추전 (zFGxDJt0tuU)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 157, '새우부추전', '부추와 냉동 새우로 만드는 초간단 부침개.', 'thumbnails/zFGxDJt0tuU.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=157);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 157, NULL, '부침가루', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=157 AND ri.name='부침가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 157, (SELECT id FROM ingredients WHERE name='부추' LIMIT 1), '부추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='부추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=157 AND ri.name='부추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 157, NULL, '냉동새우', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=157 AND ri.name='냉동새우');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 157, (SELECT id FROM ingredients WHERE name='청양고추' LIMIT 1), '청양고추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='청양고추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=157 AND ri.name='청양고추');

-- recipe 158: [오메추] 삼색소보로덮밥 (zP2LCQijoXY)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 158, '삼색소보로덮밥', '다짐육 소보로, 스크램블 에그, 부추를 올린 예쁘고 맛있는 삼색 소보로덮밥 2인분.', 'thumbnails/zP2LCQijoXY.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=158);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 158, 1, '계란에 소금 약간 넣고 풀어 기름 두른 팬에 약불로 스크램블 에그를 만들어 빼둔다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=158 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 158, 2, '팬에 다짐육, 진간장, 맛술, 설탕을 넣고 불 켜서 수분 다 날아갈 때까지 볶는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=158 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 158, 3, '밥 위에 스크램블 에그, 다짐육 반반 올리고 부추, 계란 노른자(선택) 올려 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=158 AND step_number=3);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 158, NULL, '다짐육', '200g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=158 AND ri.name='다짐육');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 158, NULL, '계란', '2~3개', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=158 AND ri.name='계란');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 158, (SELECT id FROM ingredients WHERE name='부추' LIMIT 1), '부추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='부추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=158 AND ri.name='부추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 158, NULL, '소금', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=158 AND ri.name='소금');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 158, NULL, '진간장', '3스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=158 AND ri.name='진간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 158, NULL, '맛술', '3스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=158 AND ri.name='맛술');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 158, NULL, '설탕', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=158 AND ri.name='설탕');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 158, NULL, '밥', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=158 AND ri.name='밥');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 158, NULL, '계란 노른자', '(생략 가능)', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=158 AND ri.name='계란 노른자');

-- recipe 159: [오메추] 가지볶음 (zTGYk8mgmZw)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 159, '가지볶음', '간장 양념으로 볶아내는 밥도둑 가지볶음 밑반찬.', 'thumbnails/zTGYk8mgmZw.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=159);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 159, 1, '가지는 반 갈라 어슷 썰고 양파는 가지 두께로 채썬다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=159 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 159, 2, '식용유 두른 웍에 가지·양파 볶다가 숨이 죽으면 불 끄고 맛술, 진간장, 국간장, 고춧가루, 다진 마늘 넣는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=159 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 159, 3, '다시 센불로 볶다가 참기름, 깨로 마무리하면 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=159 AND step_number=3);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 159, (SELECT id FROM ingredients WHERE name='가지' LIMIT 1), '가지', '3개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='가지') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=159 AND ri.name='가지');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 159, (SELECT id FROM ingredients WHERE name='양파' LIMIT 1), '양파', '1/2개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=159 AND ri.name='양파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 159, NULL, '맛술', '3스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=159 AND ri.name='맛술');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 159, NULL, '진간장', '2~3스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=159 AND ri.name='진간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 159, NULL, '국간장', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=159 AND ri.name='국간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 159, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '1스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=159 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 159, (SELECT id FROM ingredients WHERE name='고춧가루' LIMIT 1), '고춧가루', '1스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고춧가루') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=159 AND ri.name='고춧가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 159, NULL, '참기름', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=159 AND ri.name='참기름');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 159, (SELECT id FROM ingredients WHERE name='참깨' LIMIT 1), '깨', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='참깨') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=159 AND ri.name='깨');

-- recipe 160: [오메추] 얼큰애호박찌개 (z_99PmGqWUk)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 160, '얼큰애호박찌개', '돼지고기 앞다리살과 애호박으로 끓이는 얼큰 칼칼한 찌개.', 'thumbnails/z_99PmGqWUk.webp', 'MEDIUM', 35, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=160);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 160, 1, '애호박, 양파는 큼직하게 채썰고 앞다리살도 큼직하게 썰어 준비한다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=160 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 160, 2, '냄비에 기름을 두르고 앞다리살을 볶는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=160 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 160, 3, '겉면이 하얗게 익으면 고춧가루 5스푼을 넣고 약불로 볶은 후 간장 3스푼을 넣고 볶는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=160 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 160, 4, '물 1L를 넣고 국간장 2스푼, 다진 마늘 1스푼을 넣어 중약불로 20분 끓인다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=160 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 160, 5, '양파, 애호박, 새우젓 1스푼을 넣고 끓이다가 채소가 익으면 부족한 간을 참치액 또는 다시다로 맞춰 완성한다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=160 AND step_number=5);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 160, (SELECT id FROM ingredients WHERE name='호박' LIMIT 1), '애호박', '1개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='호박') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=160 AND ri.name='애호박');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 160, (SELECT id FROM ingredients WHERE name='양파' LIMIT 1), '양파', '반개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=160 AND ri.name='양파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 160, NULL, '돼지고기 앞다리살', '400~500g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=160 AND ri.name='돼지고기 앞다리살');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 160, (SELECT id FROM ingredients WHERE name='고춧가루' LIMIT 1), '고춧가루', '5스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고춧가루') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=160 AND ri.name='고춧가루');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 160, NULL, '물', '1L~1.2L', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=160 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 160, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진 마늘', '1스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=160 AND ri.name='다진 마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 160, NULL, '진간장', '3스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=160 AND ri.name='진간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 160, NULL, '국간장', '2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=160 AND ri.name='국간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 160, NULL, '새우젓', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=160 AND ri.name='새우젓');

-- recipe 161: [푸드라디오] 토마토소박이 (07JDOeohuzM)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 161, '토마토소박이', '매콤달콤한 한국식 토마토 요리.', 'thumbnails/07JDOeohuzM.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=161);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 161, (SELECT id FROM ingredients WHERE name='토마토' LIMIT 1), '토마토', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='토마토') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=161 AND ri.name='토마토');

-- recipe 162: [푸드라디오] 고구마누룽지 (0OgY6zCsXyo)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 162, '고구마누룽지', '고구마를 눌러 만드는 고구마누룽지.', 'thumbnails/0OgY6zCsXyo.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=162);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 162, (SELECT id FROM ingredients WHERE name='고구마' LIMIT 1), '고구마', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고구마') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=162 AND ri.name='고구마');

-- recipe 163: [푸드라디오] 레몬버터파스타 (2-e0PL1Yjzg)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 163, '레몬버터파스타', '감성 넘치는 레몬버터 파스타 레시피.', 'thumbnails/2-e0PL1Yjzg.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=163);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 163, (SELECT id FROM ingredients WHERE name='레몬' LIMIT 1), '레몬', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='레몬') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=163 AND ri.name='레몬');

-- recipe 164: [푸드라디오] 오리배추찜 (22RzHe8-jNE)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 164, '오리배추찜', '배추와 오리를 함께 쪄내는 부모님 입맛 저격 찜 요리.', 'thumbnails/22RzHe8-jNE.webp', 'MEDIUM', 40, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=164);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 164, (SELECT id FROM ingredients WHERE name='배추' LIMIT 1), '배추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='배추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=164 AND ri.name='배추');

-- recipe 165: [푸드라디오] 고구마호떡 (3LankTilBow)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 165, '고구마호떡', '고구마로 만드는 달달한 호떡.', 'thumbnails/3LankTilBow.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=165);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 165, (SELECT id FROM ingredients WHERE name='고구마' LIMIT 1), '고구마', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고구마') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=165 AND ri.name='고구마');

-- recipe 166: [푸드라디오] 고구마찰깨빵 (3OFPs0i_axo)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 166, '고구마찰깨빵', '고구마를 활용해 만드는 찰깨빵.', 'thumbnails/3OFPs0i_axo.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=166);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 166, (SELECT id FROM ingredients WHERE name='고구마' LIMIT 1), '고구마', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고구마') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=166 AND ri.name='고구마');

-- recipe 167: [푸드라디오] 애호박새우밥 (3RuxyFTNSmk)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 167, '애호박새우밥', '맛있으면서 건강한 애호박새우밥.', 'thumbnails/3RuxyFTNSmk.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=167);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 167, (SELECT id FROM ingredients WHERE name='호박' LIMIT 1), '애호박', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='호박') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=167 AND ri.name='애호박');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 167, NULL, '새우', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=167 AND ri.name='새우');

-- recipe 168: [푸드라디오] 야끼소바파스타 (86gqhWw7A38)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 168, '야끼소바파스타', '양배추가 들어간 야끼소바풍 다이어트 파스타.', 'thumbnails/86gqhWw7A38.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=168);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 168, (SELECT id FROM ingredients WHERE name='양배추' LIMIT 1), '양배추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양배추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=168 AND ri.name='양배추');

-- recipe 169: [푸드라디오] 쫀득감자튀김 (8LA3O96HIO8)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 169, '쫀득감자튀김', '바삭하고 쫀득한 식감의 감자튀김.', 'thumbnails/8LA3O96HIO8.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=169);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 169, (SELECT id FROM ingredients WHERE name='감자' LIMIT 1), '감자', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='감자') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=169 AND ri.name='감자');

-- recipe 170: [푸드라디오] 불고기팽이버섯볶음 (AurTIzmR1vE)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 170, '불고기팽이버섯볶음', '초등학생도 만들 수 있는 간단한 불고기 양념 팽이버섯볶음.', 'thumbnails/AurTIzmR1vE.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=170);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 170, (SELECT id FROM ingredients WHERE name='팽이버섯' LIMIT 1), '팽이버섯', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='팽이버섯') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=170 AND ri.name='팽이버섯');

-- recipe 171: [푸드라디오] 사과꽃차 (BBZHurR3_Fc)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 171, '사과꽃차', '솔로 탈출 꿀팁으로 소개하는 사과꽃 활용 요리.', 'thumbnails/BBZHurR3_Fc.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=171);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 171, (SELECT id FROM ingredients WHERE name='사과' LIMIT 1), '사과', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='사과') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=171 AND ri.name='사과');

-- recipe 172: [푸드라디오] 당근라페 (DOvmxneUq8o)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 172, '당근라페', '당근 한 바가지를 소진할 수 있는 당근라페 레시피다.', 'thumbnails/DOvmxneUq8o.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=172);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 172, (SELECT id FROM ingredients WHERE name='당근' LIMIT 1), '당근', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='당근') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=172 AND ri.name='당근');

-- recipe 173: [푸드라디오] 토마토계란탕 (EscqdhUOiXU)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 173, '토마토계란탕', '계속 먹게 되는 토마토와 계란으로 만드는 중국식 토마토계란탕이다.', 'thumbnails/EscqdhUOiXU.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=173);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 173, (SELECT id FROM ingredients WHERE name='토마토' LIMIT 1), '토마토', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='토마토') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=173 AND ri.name='토마토');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 173, NULL, '계란', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=173 AND ri.name='계란');

-- recipe 174: [푸드라디오] 명란오이두부비빔밥 (F1jh1R5wFPo)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 174, '명란오이두부비빔밥', '명란, 오이, 두부를 올려 만드는 다이어트 비빔밥이다.', 'thumbnails/F1jh1R5wFPo.webp', 'EASY', 10, 1, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=174);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 174, NULL, '명란', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=174 AND ri.name='명란');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 174, (SELECT id FROM ingredients WHERE name='오이' LIMIT 1), '오이', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='오이') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=174 AND ri.name='오이');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 174, NULL, '두부', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=174 AND ri.name='두부');

-- recipe 175: [푸드라디오] 감자전 (FtexlAWSJNY)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 175, '감자전', '세상에서 제일 쉽게 만드는 해시브라운 스타일 감자전.', 'thumbnails/FtexlAWSJNY.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=175);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 175, (SELECT id FROM ingredients WHERE name='감자' LIMIT 1), '감자', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='감자') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=175 AND ri.name='감자');

-- recipe 176: [푸드라디오] 오이라면 (HP86w6X0mFQ)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 176, '오이라면', '오이를 넣어 만드는 독특한 오이라면.', 'thumbnails/HP86w6X0mFQ.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=176);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 176, (SELECT id FROM ingredients WHERE name='오이' LIMIT 1), '오이', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='오이') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=176 AND ri.name='오이');

-- recipe 177: [푸드라디오] 수박테트리스 (Hq61MtS9v0I)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 177, '수박테트리스', '수박을 테트리스 블록처럼 잘라 쏙쏙 집어먹기 편하게 만드는 수박 자르기 방법.', 'thumbnails/Hq61MtS9v0I.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=177);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 177, (SELECT id FROM ingredients WHERE name='수박' LIMIT 1), '수박', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='수박') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=177 AND ri.name='수박');

-- recipe 178: [푸드라디오] 알배추샐러드 (KRXEIUEbXVI)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 178, '알배추샐러드', '알배추(알배기배추)로 만드는 샐러드 레시피.', 'thumbnails/KRXEIUEbXVI.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=178);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 178, (SELECT id FROM ingredients WHERE name='알배기배추' LIMIT 1), '알배추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='알배기배추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=178 AND ri.name='알배추');

-- recipe 179: [푸드라디오] 사과샐러드 (KXfnuvcivUQ)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 179, '사과샐러드', '사과를 활용한 매일 먹고 싶은 샐러드 레시피.', 'thumbnails/KXfnuvcivUQ.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=179);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 179, (SELECT id FROM ingredients WHERE name='사과' LIMIT 1), '사과', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='사과') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=179 AND ri.name='사과');

-- recipe 180: [푸드라디오] 감자빵 (KoHLIGU-PmQ)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 180, '감자빵', '싹 나기 직전의 감자와 라이스페이퍼로 만드는 감자빵.', 'thumbnails/KoHLIGU-PmQ.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=180);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 180, (SELECT id FROM ingredients WHERE name='감자' LIMIT 1), '감자', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='감자') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=180 AND ri.name='감자');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 180, NULL, '라이스페이퍼', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=180 AND ri.name='라이스페이퍼');

-- recipe 181: [푸드라디오] 토마토 에그슬럿 (LbxUex8rIhg)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 181, '토마토 에그슬럿', '전자레인지로 3분만에 만드는 토마토 에그슬럿과 토마토화채.', 'thumbnails/LbxUex8rIhg.webp', 'EASY', 5, 1, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=181);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 181, 1, '토마토 꼭지 부분을 잘라내고 숟가락으로 속을 파낸다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=181 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 181, 2, '계란을 넣고 소금·후추 한꼬집씩 넣는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=181 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 181, 3, '치즈를 뿌리고 노른자를 콕 터트린 후 전자레인지 3분 돌린다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=181 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 181, 4, '파낸 토마토 속에 얼음과 밀키스, 젤리를 넣어 화채를 만든다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=181 AND step_number=4);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 181, NULL, '계란', '1개', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=181 AND ri.name='계란');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 181, (SELECT id FROM ingredients WHERE name='토마토' LIMIT 1), '토마토', '1개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='토마토') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=181 AND ri.name='토마토');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 181, NULL, '치즈', '10g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=181 AND ri.name='치즈');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 181, NULL, '소금', '0.1g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=181 AND ri.name='소금');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 181, NULL, '후추', '0.1g', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=181 AND ri.name='후추');

-- recipe 182: [푸드라디오] 치즈고구마 (OGgN9qwXsJU)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 182, '치즈고구마', '패밀리 레스토랑 스타일의 치즈고구마로 간단하지만 중독성 있는 맛을 내는 고구마 요리.', 'thumbnails/OGgN9qwXsJU.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=182);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 182, (SELECT id FROM ingredients WHERE name='고구마' LIMIT 1), '고구마', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고구마') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=182 AND ri.name='고구마');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 182, NULL, '치즈', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=182 AND ri.name='치즈');

-- recipe 183: [푸드라디오] 오이냉국수 (PehRi79wV2k)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 183, '오이냉국수', '오이냉국 업그레이드 버전의 오이말이국수.', 'thumbnails/PehRi79wV2k.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=183);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 183, (SELECT id FROM ingredients WHERE name='오이' LIMIT 1), '오이', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='오이') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=183 AND ri.name='오이');

-- recipe 184: [푸드라디오] 고구마치즈롤 (TIr1yMFSiVc)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 184, '고구마치즈롤', '추운 겨울 고구마로 만드는 치즈롤 또는 고구마치즈또띠아.', 'thumbnails/TIr1yMFSiVc.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=184);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 184, (SELECT id FROM ingredients WHERE name='고구마' LIMIT 1), '고구마', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고구마') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=184 AND ri.name='고구마');

-- recipe 185: [푸드라디오] 브로콜리감자 트리 카나페 (TWTxPFDbl8g)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 185, '브로콜리감자 트리 카나페', '브로콜리와 감자로 만든 크리스마스 트리 모양의 귀여운 핑거푸드.', 'thumbnails/TWTxPFDbl8g.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=185);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 185, (SELECT id FROM ingredients WHERE name='브로콜리' LIMIT 1), '브로콜리', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='브로콜리') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=185 AND ri.name='브로콜리');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 185, (SELECT id FROM ingredients WHERE name='감자' LIMIT 1), '감자', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='감자') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=185 AND ri.name='감자');

-- recipe 186: [푸드라디오] 배추찜 (VQFWQZeuQB4)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 186, '배추찜', '소고기와 배추로 만드는 간단한 배추찜.', 'thumbnails/VQFWQZeuQB4.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=186);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 186, (SELECT id FROM ingredients WHERE name='배추' LIMIT 1), '배추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='배추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=186 AND ri.name='배추');

-- recipe 187: [푸드라디오] 수박껍질잼 (VvQPf9JbACU)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 187, '수박껍질잼', '수박 껍질로 만드는 수제 잼.', 'thumbnails/VvQPf9JbACU.webp', 'EASY', 30, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=187);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 187, (SELECT id FROM ingredients WHERE name='수박' LIMIT 1), '수박 껍질', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='수박') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=187 AND ri.name='수박 껍질');

-- recipe 188: [푸드라디오] 닭가슴살오이냉채 (WHhScNeUyiY)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 188, '닭가슴살오이냉채', '닭가슴살과 오이로 만드는 와사비 냉채 또는 오이순두부 레시피.', 'thumbnails/WHhScNeUyiY.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=188);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 188, NULL, '닭가슴살', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=188 AND ri.name='닭가슴살');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 188, (SELECT id FROM ingredients WHERE name='오이' LIMIT 1), '오이', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='오이') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=188 AND ri.name='오이');

-- recipe 189: [푸드라디오] 치즈 감자 누룽지 (XgtAkBDP3XU)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 189, '치즈 감자 누룽지', '감자로 만드는 치즈 올린 바삭한 누룽지.', 'thumbnails/XgtAkBDP3XU.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=189);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 189, (SELECT id FROM ingredients WHERE name='감자' LIMIT 1), '감자', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='감자') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=189 AND ri.name='감자');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 189, NULL, '치즈', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=189 AND ri.name='치즈');

-- recipe 190: [푸드라디오] 익힌 상추쌈밥 (XwwmSn6iq8M)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 190, '익힌 상추쌈밥', '상추를 익혀 활용하는 색다른 쌈밥 요리.', 'thumbnails/XwwmSn6iq8M.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=190);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 190, (SELECT id FROM ingredients WHERE name='상추' LIMIT 1), '상추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='상추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=190 AND ri.name='상추');

-- recipe 191: [푸드라디오] 참기름양배추무침 (YWDAmftLIWo)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 191, '참기름양배추무침', '과식한 다음날 속을 달래주는 참기름 양배추 김무침.', 'thumbnails/YWDAmftLIWo.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=191);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 191, (SELECT id FROM ingredients WHERE name='양배추' LIMIT 1), '양배추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양배추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=191 AND ri.name='양배추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 191, NULL, '참기름', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=191 AND ri.name='참기름');

-- recipe 192: [푸드라디오] 꿀사과젤리 (ZV11ng8PQwE)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 192, '꿀사과젤리', '영주사과로 만든 사과꽃 모양 푸딩에 꿀인삼을 곁들인 여름 디저트.', 'thumbnails/ZV11ng8PQwE.webp', 'MEDIUM', 30, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=192);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 192, (SELECT id FROM ingredients WHERE name='사과' LIMIT 1), '사과', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='사과') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=192 AND ri.name='사과');

-- recipe 193: [푸드라디오] 당근라페 (Zgl1S-hVtrg)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 193, '당근라페', '당근으로 만드는 프렌치 스타일 당근라페이다.', 'thumbnails/Zgl1S-hVtrg.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=193);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 193, (SELECT id FROM ingredients WHERE name='당근' LIMIT 1), '당근', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='당근') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=193 AND ri.name='당근');

-- recipe 194: [푸드라디오] 마늘보쌈 (_3se6nUQpo4)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 194, '마늘보쌈', '마늘을 곁들인 보쌈(수육) 레시피.', 'thumbnails/_3se6nUQpo4.webp', 'MEDIUM', 60, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=194);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 194, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '마늘', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=194 AND ri.name='마늘');

-- recipe 195: [푸드라디오] 오이 아코디언 (anUYNyTZTxM)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 195, '오이 아코디언', '오이를 아코디언 모양으로 칼집 내어 만드는 오이무침·절임.', 'thumbnails/anUYNyTZTxM.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=195);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 195, (SELECT id FROM ingredients WHERE name='오이' LIMIT 1), '오이', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='오이') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=195 AND ri.name='오이');

-- recipe 196: [푸드라디오] 김치감자볼 (bIgmlQtC-04)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 196, '김치감자볼', '남은 김치와 감자를 활용한 치즈 김치감자볼.', 'thumbnails/bIgmlQtC-04.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=196);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 196, (SELECT id FROM ingredients WHERE name='감자' LIMIT 1), '감자', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='감자') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=196 AND ri.name='감자');

-- recipe 197: [푸드라디오] 감자탕 (bstNP1RSgTY)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 197, '감자탕', '돼지등뼈를 전날 핏물 제거 후 된장과 함께 끓여낸 4인분 감자탕 황금 레시피다.', 'thumbnails/bstNP1RSgTY.webp', 'MEDIUM', 120, 4, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=197);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 197, NULL, '돼지등뼈', '2kg', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=197 AND ri.name='돼지등뼈');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 197, NULL, '된장', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=197 AND ri.name='된장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 197, (SELECT id FROM ingredients WHERE name='감자' LIMIT 1), '감자', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='감자') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=197 AND ri.name='감자');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 197, NULL, '간장', '1(겨자소스)', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=197 AND ri.name='간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 197, NULL, '물', '1(겨자소스)', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=197 AND ri.name='물');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 197, NULL, '식초', '0.3(겨자소스)', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=197 AND ri.name='식초');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 197, NULL, '설탕', '0.3(겨자소스)', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=197 AND ri.name='설탕');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 197, NULL, '겨자', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=197 AND ri.name='겨자');

-- recipe 198: [푸드라디오] 마늘굴소스계란파스타 (cRaOZsHpR44)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 198, '마늘굴소스계란파스타', '다진마늘과 굴소스를 넣어 만드는 K-스타일 계란 파스타.', 'thumbnails/cRaOZsHpR44.webp', 'EASY', 15, 1, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=198);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 198, 1, '냄비에 물과 소금 1스푼을 넣고 파스타 면 1인분을 8분 삶는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=198 AND step_number=1);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 198, 2, '베이컨 3줄을 썰고 양파를 채썬다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=198 AND step_number=2);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 198, 3, '중불 팬에 버터를 두르고 마늘을 볶다가 채썬 양파와 식용유를 넣고 볶는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=198 AND step_number=3);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 198, 4, '가운데 계란을 넣어 스크램블한 후 익힌 면과 면수 1국자를 넣는다.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=198 AND step_number=4);
INSERT INTO recipe_steps (recipe_id, step_number, description) SELECT 198, 5, '굴소스 2스푼, 간장 1스푼, 청양고추 1스푼(선택)을 넣고 볶아 완성.' WHERE NOT EXISTS (SELECT 1 FROM recipe_steps WHERE recipe_id=198 AND step_number=5);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 198, NULL, '계란', '2개', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=198 AND ri.name='계란');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 198, (SELECT id FROM ingredients WHERE name='양파' LIMIT 1), '양파', '1개', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양파') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=198 AND ri.name='양파');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 198, NULL, '베이컨', '3줄', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=198 AND ri.name='베이컨');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 198, NULL, '파스타 면', '1인분', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=198 AND ri.name='파스타 면');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 198, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '다진마늘', '1스푼', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=198 AND ri.name='다진마늘');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 198, NULL, '버터', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=198 AND ri.name='버터');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 198, NULL, '식용유', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=198 AND ri.name='식용유');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 198, NULL, '굴소스', '2스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=198 AND ri.name='굴소스');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 198, NULL, '간장', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=198 AND ri.name='간장');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 198, NULL, '소금', '1스푼', FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=198 AND ri.name='소금');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 198, (SELECT id FROM ingredients WHERE name='청양고추' LIMIT 1), '청양고추', '1스푼(선택)', FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='청양고추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=198 AND ri.name='청양고추');

-- recipe 199: [푸드라디오] 사과잼 (covotvDW3e0)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 199, '사과잼', '친구들이 팔아달라고 할 만큼 맛있는 전자레인지 사과잼.', 'thumbnails/covotvDW3e0.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=199);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 199, (SELECT id FROM ingredients WHERE name='사과' LIMIT 1), '사과', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='사과') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=199 AND ri.name='사과');

-- recipe 200: [푸드라디오] 오이탕탕이 (d0a3aloNNv0)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 200, '오이탕탕이', '시원하고 상큼하게 개운한 오이탕탕이.', 'thumbnails/d0a3aloNNv0.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=200);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 200, (SELECT id FROM ingredients WHERE name='오이' LIMIT 1), '오이', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='오이') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=200 AND ri.name='오이');

-- recipe 201: [푸드라디오] 수박과 페타치즈 (dQ6nNhtflu4)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 201, '수박과 페타치즈', '수박에 페타치즈를 곁들여 맛있게 먹는 와인 안주 레시피다.', 'thumbnails/dQ6nNhtflu4.webp', 'EASY', 5, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=201);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 201, (SELECT id FROM ingredients WHERE name='수박' LIMIT 1), '수박', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='수박') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=201 AND ri.name='수박');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 201, NULL, '페타치즈', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=201 AND ri.name='페타치즈');

-- recipe 202: [푸드라디오] 허니버터버섯 (ds45CjUhBC0)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 202, '허니버터버섯', '새송이버섯으로 만드는 교촌 허니콤보 스타일의 허니버터 간장버섯이다.', 'thumbnails/ds45CjUhBC0.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=202);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 202, (SELECT id FROM ingredients WHERE name='새송이버섯' LIMIT 1), '새송이버섯', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='새송이버섯') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=202 AND ri.name='새송이버섯');

-- recipe 203: [푸드라디오] 토마토냉국수 (el8Q3fv2v5A)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 203, '토마토냉국수', '토마토를 활용한 간장 냉국수 요리다.', 'thumbnails/el8Q3fv2v5A.webp', 'EASY', 15, 1, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=203);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 203, (SELECT id FROM ingredients WHERE name='토마토' LIMIT 1), '토마토', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='토마토') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=203 AND ri.name='토마토');

-- recipe 204: [푸드라디오] 사과 자르기 (eoFwH-XuLLc)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 204, '사과 자르기', '사과를 예쁘게 깎고 자르는 방법.', 'thumbnails/eoFwH-XuLLc.webp', 'EASY', 5, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=204);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 204, (SELECT id FROM ingredients WHERE name='사과' LIMIT 1), '사과', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='사과') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=204 AND ri.name='사과');

-- recipe 205: [푸드라디오] 알배추구이 (epwJF9HwKXA)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 205, '알배추구이', '알배추(알배기배추)를 구워 만드는 스테이크 스타일 요리 레시피.', 'thumbnails/epwJF9HwKXA.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=205);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 205, (SELECT id FROM ingredients WHERE name='알배기배추' LIMIT 1), '알배추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='알배기배추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=205 AND ri.name='알배추');

-- recipe 206: [푸드라디오] 오이크래미김밥 (h-LRZn48zik)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 206, '오이크래미김밥', '오이와 크래미를 넣어 만드는 다이어트 김밥.', 'thumbnails/h-LRZn48zik.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=206);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 206, (SELECT id FROM ingredients WHERE name='오이' LIMIT 1), '오이', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='오이') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=206 AND ri.name='오이');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 206, NULL, '크래미', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=206 AND ri.name='크래미');

-- recipe 207: [푸드라디오] 오이참치두부 (hO2N51jhWP0)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 207, '오이참치두부', '점심·저녁을 한번에 해결할 수 있는 오이 참치 두부 요리.', 'thumbnails/hO2N51jhWP0.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=207);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 207, (SELECT id FROM ingredients WHERE name='오이' LIMIT 1), '오이', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='오이') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=207 AND ri.name='오이');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 207, NULL, '참치', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=207 AND ri.name='참치');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 207, NULL, '두부', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=207 AND ri.name='두부');

-- recipe 208: [푸드라디오] 당근짜장면 (hTqN0VqfPL4)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 208, '당근짜장면', '당근을 활용한 흑백요리사 후덕죽 셰프의 당근짜장면 레시피.', 'thumbnails/hTqN0VqfPL4.webp', 'MEDIUM', 30, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=208);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 208, (SELECT id FROM ingredients WHERE name='당근' LIMIT 1), '당근', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='당근') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=208 AND ri.name='당근');

-- recipe 209: [푸드라디오] 알배추스테이크 (jBIdzfNb_WI)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 209, '알배추스테이크', '다이어트용으로 만든 알배추 구이 스테이크.', 'thumbnails/jBIdzfNb_WI.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=209);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 209, (SELECT id FROM ingredients WHERE name='알배기배추' LIMIT 1), '알배추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='알배기배추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=209 AND ri.name='알배추');

-- recipe 210: [푸드라디오] 배추말이 (jRb9nDyFrBo)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 210, '배추말이', '배추로 만드는 맛있는 배추말이(또는 배추만두/배추찜).', 'thumbnails/jRb9nDyFrBo.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=210);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 210, (SELECT id FROM ingredients WHERE name='배추' LIMIT 1), '배추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='배추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=210 AND ri.name='배추');

-- recipe 211: [푸드라디오] 수박화채 젤리 (ku5PCueK_CY)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 211, '수박화채 젤리', '복수박으로 만든 시원한 수박화채 젤리.', 'thumbnails/ku5PCueK_CY.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=211);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 211, (SELECT id FROM ingredients WHERE name='수박' LIMIT 1), '수박', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='수박') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=211 AND ri.name='수박');

-- recipe 212: [푸드라디오] 들기름 양배추무침 (lW8WwqVvRVw)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 212, '들기름 양배추무침', '들기름으로 버무린 양배추라페·무침 요리다.', 'thumbnails/lW8WwqVvRVw.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=212);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 212, (SELECT id FROM ingredients WHERE name='양배추' LIMIT 1), '양배추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양배추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=212 AND ri.name='양배추');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 212, NULL, '들기름', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=212 AND ri.name='들기름');

-- recipe 213: [푸드라디오] 팽이버섯장조림덮밥 (mCP0GUDEHmw)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 213, '팽이버섯장조림덮밥', '팽이버섯으로 만든 오독오독 식감의 장조림을 밥 위에 올리고 노른자와 참기름을 곁들인 덮밥.', 'thumbnails/mCP0GUDEHmw.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=213);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 213, (SELECT id FROM ingredients WHERE name='팽이버섯' LIMIT 1), '팽이버섯', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='팽이버섯') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=213 AND ri.name='팽이버섯');

-- recipe 214: [푸드라디오] 토마토닭볶음탕 (mqO_A3P-Ej0)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 214, '토마토닭볶음탕', '토마토를 넣어 만드는 새콤달콤한 닭볶음탕.', 'thumbnails/mqO_A3P-Ej0.webp', 'MEDIUM', 30, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=214);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 214, (SELECT id FROM ingredients WHERE name='토마토' LIMIT 1), '토마토', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='토마토') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=214 AND ri.name='토마토');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 214, NULL, '닭', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=214 AND ri.name='닭');

-- recipe 215: [푸드라디오] 오이참깨무침 (nf-ZrqH-dD8)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 215, '오이참깨무침', '고소한 참깨를 듬뿍 넣어 만드는 오이참깨무침.', 'thumbnails/nf-ZrqH-dD8.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=215);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 215, (SELECT id FROM ingredients WHERE name='오이' LIMIT 1), '오이', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='오이') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=215 AND ri.name='오이');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 215, (SELECT id FROM ingredients WHERE name='참깨' LIMIT 1), '참깨', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='참깨') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=215 AND ri.name='참깨');

-- recipe 216: [푸드라디오] 새송이버섯장아찌 (phWwE0kXaVA)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 216, '새송이버섯장아찌', '고기 곁들임으로 딱 좋은 새송이버섯장아찌.', 'thumbnails/phWwE0kXaVA.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=216);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 216, (SELECT id FROM ingredients WHERE name='새송이버섯' LIMIT 1), '새송이버섯', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='새송이버섯') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=216 AND ri.name='새송이버섯');

-- recipe 217: [푸드라디오] 크래미 깻잎전 (qIFwtbErmDM)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 217, '크래미 깻잎전', '크래미(게맛살)와 깻잎으로 만드는 간단하고 풍성한 부침개.', 'thumbnails/qIFwtbErmDM.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=217);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 217, (SELECT id FROM ingredients WHERE name='깻잎' LIMIT 1), '깻잎', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깻잎') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=217 AND ri.name='깻잎');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 217, NULL, '크래미(게맛살)', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=217 AND ri.name='크래미(게맛살)');

-- recipe 218: [푸드라디오] 오이빙수 (rE9ir1zrTI4)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 218, '오이빙수', '오이를 활용한 독특한 빙수 레시피.', 'thumbnails/rE9ir1zrTI4.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=218);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 218, (SELECT id FROM ingredients WHERE name='오이' LIMIT 1), '오이', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='오이') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=218 AND ri.name='오이');

-- recipe 219: [푸드라디오] 고구마과자 (rjvrtdfWYwY)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 219, '고구마과자', '고구마로 만드는 바삭한 과자 레시피다.', 'thumbnails/rjvrtdfWYwY.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=219);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 219, (SELECT id FROM ingredients WHERE name='고구마' LIMIT 1), '고구마', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고구마') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=219 AND ri.name='고구마');

-- recipe 220: [푸드라디오] 양배추피클 (snROkB3GXeA)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 220, '양배추피클', '밥 먹을 때마다 찾게 되는 양배추피클 레시피다.', 'thumbnails/snROkB3GXeA.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=220);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 220, (SELECT id FROM ingredients WHERE name='양배추' LIMIT 1), '양배추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양배추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=220 AND ri.name='양배추');

-- recipe 221: [푸드라디오] 오이김밥 (t35BGUB21_4)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 221, '오이김밥', '최화정 레시피로 만드는 오이김밥이다.', 'thumbnails/t35BGUB21_4.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=221);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 221, (SELECT id FROM ingredients WHERE name='오이' LIMIT 1), '오이', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='오이') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=221 AND ri.name='오이');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 221, NULL, '김', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=221 AND ri.name='김');

-- recipe 222: [푸드라디오] 당근케이크 (tViJ2FjIE7I)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 222, '당근케이크', '전자레인지로 8분 만에 완성하는 당근케이크.', 'thumbnails/tViJ2FjIE7I.webp', 'EASY', 8, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=222);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 222, (SELECT id FROM ingredients WHERE name='당근' LIMIT 1), '당근', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='당근') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=222 AND ri.name='당근');

-- recipe 223: [푸드라디오] 새송이버섯관자구이 (vpzcoItdoLw)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 223, '새송이버섯관자구이', '1000원으로 2만원짜리 맛을 내는 새송이버섯 관자 스타일 요리.', 'thumbnails/vpzcoItdoLw.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=223);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 223, (SELECT id FROM ingredients WHERE name='새송이버섯' LIMIT 1), '새송이버섯', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='새송이버섯') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=223 AND ri.name='새송이버섯');

-- recipe 224: [푸드라디오] 라이스페이퍼감자전 (wA9Sgrd7oVM)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 224, '라이스페이퍼감자전', '라이스페이퍼를 활용해 역대급 바삭함을 자랑하는 감자전.', 'thumbnails/wA9Sgrd7oVM.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=224);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 224, (SELECT id FROM ingredients WHERE name='감자' LIMIT 1), '감자', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='감자') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=224 AND ri.name='감자');

-- recipe 225: [푸드라디오] 구름사과 (whrSSyHvMjo)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 225, '구름사과', '입에서 사르르 녹는 구름사과 디저트.', 'thumbnails/whrSSyHvMjo.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=225);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 225, (SELECT id FROM ingredients WHERE name='사과' LIMIT 1), '사과', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='사과') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=225 AND ri.name='사과');

-- recipe 226: [푸드라디오] 사이다 오이피클 (wm0QtUwtr8Y)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 226, '사이다 오이피클', '완성된 피클에 사이다를 부어 만드는 색다른 오이피클.', 'thumbnails/wm0QtUwtr8Y.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=226);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 226, (SELECT id FROM ingredients WHERE name='오이' LIMIT 1), '오이', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='오이') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=226 AND ri.name='오이');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 226, NULL, '사이다', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=226 AND ri.name='사이다');

-- recipe 227: [푸드라디오] 양배추샤브샤브전골 (xKVQ0i3jQoo)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 227, '양배추샤브샤브전골', '양배추 반통을 혼자 클리어할 수 있는 양배추 샤브샤브 전골 레시피.', 'thumbnails/xKVQ0i3jQoo.webp', 'EASY', 20, 1, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=227);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 227, (SELECT id FROM ingredients WHERE name='양배추' LIMIT 1), '양배추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양배추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=227 AND ri.name='양배추');

-- recipe 228: [푸드라디오] 수박껍질무침 (xrJ6wCunbfA)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 228, '수박껍질무침', '버리기 쉬운 수박껍질을 활용한 무침 요리.', 'thumbnails/xrJ6wCunbfA.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=228);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 228, (SELECT id FROM ingredients WHERE name='수박' LIMIT 1), '수박껍질', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='수박') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=228 AND ri.name='수박껍질');

-- recipe 229: [푸드라디오] 브로콜리치즈구이 (yb1gCsyDqWw)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 229, '브로콜리치즈구이', '브로콜리에 치즈를 올려 눌러먹는 브로콜리치즈구이.', 'thumbnails/yb1gCsyDqWw.webp', 'EASY', 10, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=229);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 229, (SELECT id FROM ingredients WHERE name='브로콜리' LIMIT 1), '브로콜리', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='브로콜리') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=229 AND ri.name='브로콜리');
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 229, NULL, '치즈', NULL, FALSE WHERE NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=229 AND ri.name='치즈');

-- recipe 230: [푸드라디오] 치즈 마늘 토스트 (ydKu1Kl8HU4)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 230, '치즈 마늘 토스트', '에어프라이어로 만드는 간식용 치즈 마늘빵 토스트.', 'thumbnails/ydKu1Kl8HU4.webp', 'EASY', 15, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=230);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 230, (SELECT id FROM ingredients WHERE name='깐마늘(국산)' LIMIT 1), '마늘', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='깐마늘(국산)') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=230 AND ri.name='마늘');

-- recipe 231: [푸드라디오] 고구마 바스크치즈케이크 (yeLTRe7Yr-E)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 231, '고구마 바스크치즈케이크', '고구마를 활용한 바스크 스타일 치즈케이크.', 'thumbnails/yeLTRe7Yr-E.webp', 'MEDIUM', 40, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=231);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 231, (SELECT id FROM ingredients WHERE name='고구마' LIMIT 1), '고구마', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='고구마') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=231 AND ri.name='고구마');

-- recipe 232: [푸드라디오] 오코노미야끼 (zHMWRiJwrxA)
INSERT INTO recipes (id, title, description, image_url, difficulty, minutes, servings, status) SELECT 232, '오코노미야끼', '양배추를 주재료로 만드는 일본식 부침개 오코노미야끼.', 'thumbnails/zHMWRiJwrxA.webp', 'EASY', 20, 2, 'PUBLISHED' WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE id=232);
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, name, unit, optional) SELECT 232, (SELECT id FROM ingredients WHERE name='양배추' LIMIT 1), '양배추', NULL, FALSE WHERE EXISTS (SELECT 1 FROM ingredients WHERE name='양배추') AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.recipe_id=232 AND ri.name='양배추');

ALTER TABLE recipes ALTER COLUMN id RESTART WITH 233;

-- 릴스 recipe_id 연결 (recipe id N = reel id N, 동일 영상)
UPDATE reels r SET recipe_id = r.id WHERE r.recipe_id IS NULL AND EXISTS (SELECT 1 FROM recipes rc WHERE rc.id = r.id);
// 목 이미지 모듈 — 모든 화면에서 공유하는 로컬 이미지 (public/food/)
// 식재료/요리 이미지를 카테고리별로 정리
// 사람(아바타)는 로컬 대체본이 없어 Unsplash CDN 사용

const F = (name) => `/food/${name}`;

const FACE = (id, w = 120) =>
  `https://images.unsplash.com/photo-${id}?w=${w}&q=80&auto=format&fit=crop&crop=faces`;

// 식재료 (재료별 사진 — VegPlaceholder fallback / 카드)
export const VEG_IMG = {
  // 채소
  무: F("radish.jpg"),
  배추: F("napa-cabbage.jpg"),
  봄동: F("bomdong.png"),
  시금치: F("spinach.jpg"),
  대파: F("green-onion.png"),
  쪽파: F("green-onion.png"),
  마늘: F("garlic.jpg"),
  깐마늘: F("garlic.jpg"),
  고구마: F("sweet-potato.jpg"),
  당근: F("carrot.jpg"),
  단호박: F("pumpkin.jpg"),
  브로콜리: F("broccoli.webp"),
  비트: F("beet.jpg"),
  콜라비: F("kohlrabi.webp"),
  // 과일
  감귤: F("tangerine.jpg"),
  귤: F("tangerine.jpg"),
  // 곡류
  쌀: F("rice.jpg"),
  보리: F("rice.jpg"),
  // 고기·계란
  돼지고기: F("pork-shoulder.jpg"),
  "돼지고기 앞다리": F("pork-shoulder.jpg"),
  돼지고기앞다리: F("pork-shoulder.jpg"),
  계란: F("egg.jpg"),
  // 기타
  고추장: F("gochujang.jpeg"),
};

// 요리 사진 (레시피 hero)
export const DISH_IMG = {
  무생채: F("musaengchae.jpg"),
  무생채황금레시피2: F("musaengchae-gold.jpg"),
  무생채황금레시피: F("musaengchae-gold-3.jpeg"),
  배추전: F("baechujeon.jpg"),
  시금치페스토: F("spinach-pesto.jpeg"),
  깍두기: F("kkakdugi.webp"),
  비빔밥: F("bibimbap.avif"),
  봄동비빔밥: F("bomdong-bibimbap.png"),
  봄동비빔밥메인: F("bomdong-bibimbap-main.png"),
  봄동비빔밥히어로: F("bomdong-bibimbap-hero.avif"),
  봄동비빔밥릴스1: F("bomdong-bibimbap-reel-1.png"),
  봄동비빔밥릴스2: F("bomdong-bibimbap-reel-2.png"),
  봄동비빔밥릴스3: F("bomdong-bibimbap-reel-3.png"),
  봄동비빔밥스텝: F("bomdong-bibimbap-step.webp"),
  봄동쌈밥: F("bomdong-ssambap.jpg"),
  봄동새우전: F("bomdong-saewoojeon.jpg"),
  나물무침: F("namul.jpg"),
  무양념무침: F("radish-seasoning.webp"),
  default: F("namul.jpg"),
};

// 일반 음식 / 요리 영상 썸네일 (Reels, 카드)
export const FOOD_IMG = [
  F("musaengchae.jpg"),
  F("baechujeon.jpg"),
  F("spinach-pesto.jpeg"),
  F("kkakdugi.webp"),
  F("bibimbap.avif"),
  F("bomdong-bibimbap.png"),
  F("namul.jpg"),
  F("radish-seasoning.webp"),
  F("musaengchae-gold-3.jpeg"),
  F("musaengchae-gold.jpg"),
];

// 사람 (작성자 · 아바타) — 로컬 대체본이 없어 Unsplash 유지
export const FACE_IMG = {
  cookingMom: FACE("1494790108377-be9c29b29330"),
  ansungJae: FACE("1535713875002-d1d0cf377fde"),
  paekJongWon: FACE("1507003211169-0a1dd7228f2d"),
  emily: FACE("1438761681033-6461ffad8d80"),
  me: FACE("1607746882042-944635dfe10e", 80),
  user1: FACE("1599566150163-29194dcaad36"),
  user2: FACE("1500648767791-00dcc994a43e"),
  user3: FACE("1544005313-94ddf0286df2"),
};

// 마켓·매장 사진 — 로컬 대체본 없음
export const STORE_IMG = [];

// 식재료 이름 → 이미지 URL (fallback: 첫번째 글자 텍스트)
export function vegImg(name) {
  if (!name) return null;
  if (VEG_IMG[name]) return VEG_IMG[name];
  for (const key of Object.keys(VEG_IMG)) {
    if (name.includes(key) || key.includes(name)) return VEG_IMG[key];
  }
  return null;
}

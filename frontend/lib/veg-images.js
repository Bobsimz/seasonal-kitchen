// 식재료 이름 → 로컬 이미지(public/food/) 매핑.
// VegImage 컴포넌트의 썸네일 폴백에 사용한다. 데이터가 아니라 표현용 유틸이다.

const F = (name) => `/food/${name}`;

// 채소·과일·곡류·고기 등 식재료 사진
export const VEG_IMG = {
  // 채소
  무: F('radish.jpg'),
  배추: F('napa-cabbage.jpg'),
  봄동: F('bomdong.png'),
  시금치: F('spinach.jpg'),
  대파: F('green-onion.png'),
  쪽파: F('green-onion.png'),
  마늘: F('garlic.jpg'),
  깐마늘: F('garlic.jpg'),
  고구마: F('sweet-potato.jpg'),
  당근: F('carrot.jpg'),
  단호박: F('pumpkin.jpg'),
  브로콜리: F('broccoli.webp'),
  비트: F('beet.jpg'),
  콜라비: F('kohlrabi.webp'),
  // 과일
  감귤: F('tangerine.jpg'),
  귤: F('tangerine.jpg'),
  // 곡류
  쌀: F('rice.jpg'),
  보리: F('rice.jpg'),
  // 고기·계란
  돼지고기: F('pork-shoulder.jpg'),
  '돼지고기 앞다리': F('pork-shoulder.jpg'),
  돼지고기앞다리: F('pork-shoulder.jpg'),
  계란: F('egg.jpg'),
  // 기타
  고추장: F('gochujang.jpeg'),
};

// 이미지가 없을 때 폴백 배경에 띄울 이모지(부분 일치 기준).
const VEG_EMOJI = [
  ['무', '🥬'],
  ['배추', '🥬'],
  ['봄동', '🥬'],
  ['시금치', '🥬'],
  ['브로콜리', '🥦'],
  ['콜라비', '🥬'],
  ['파', '🧅'],
  ['양파', '🧅'],
  ['마늘', '🧄'],
  ['고구마', '🍠'],
  ['감자', '🥔'],
  ['당근', '🥕'],
  ['호박', '🎃'],
  ['비트', '🥬'],
  ['귤', '🍊'],
  ['감귤', '🍊'],
  ['사과', '🍎'],
  ['딸기', '🍓'],
  ['포도', '🍇'],
  ['쌀', '🍚'],
  ['보리', '🌾'],
  ['돼지', '🥩'],
  ['소고기', '🥩'],
  ['닭', '🍗'],
  ['계란', '🥚'],
  ['고추', '🌶️'],
  ['버섯', '🍄'],
  ['옥수수', '🌽'],
  ['오이', '🥒'],
  ['토마토', '🍅'],
];

// 식재료 이름 → 이미지 URL. 정확히 일치하거나 부분 일치하는 항목이 없으면 null.
export function vegImg(name) {
  if (!name) return null;
  if (VEG_IMG[name]) return VEG_IMG[name];
  for (const key of Object.keys(VEG_IMG)) {
    if (name.includes(key) || key.includes(name)) return VEG_IMG[key];
  }
  return null;
}

// 식재료 이름 → 대표 이모지. 매칭 없으면 일반 채소 이모지.
export function vegEmoji(name) {
  if (!name) return '🥬';
  for (const [key, emoji] of VEG_EMOJI) {
    if (name.includes(key)) return emoji;
  }
  return '🥬';
}

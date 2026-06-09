// 농가(생산자) 목 데이터 모듈 — 모든 화면에서 공유
// 이커머스(리테일 시세 비교) → 농가 연결 reframe의 핵심 데이터.
// 인물 사진은 로컬 대체본이 없어 mock-images.js 의 FACE_IMG(Unsplash) 재사용.

import { FACE_IMG } from "./mock-images";

// 생산자 객체 shape:
//   { id, name, region, tagline, photo, specialties[], style, priceLevel,
//     freshnessLevel, rating, reviewCount, honorary, badges[] }
//   style: 'value'(저렴이·실속형) | 'premium'(프리미엄·싱싱) | 'organic'(유기농·무농약)
export const PRODUCERS = [
  {
    id: "p1",
    name: "권민성",
    region: "경북영천",
    tagline: "콩밭 매는 아낙네, 정성으로 키운 잡곡",
    photo: FACE_IMG.paekJongWon,
    specialties: ["콩", "봄동", "시금치", "무"],
    style: "premium",
    priceLevel: 5,
    freshnessLevel: 5,
    rating: 4.9,
    reviewCount: 1280,
    honorary: true,
    badges: ["산지직송", "당일수확"],
  },
  {
    id: "p2",
    name: "홍진이",
    region: "경기오산",
    tagline: "텃밭에서 갓 딴 유기농 봄동",
    photo: FACE_IMG.emily,
    specialties: ["봄동", "배추", "시금치"],
    style: "organic",
    priceLevel: 4,
    freshnessLevel: 5,
    rating: 4.8,
    reviewCount: 642,
    honorary: true,
    badges: ["유기농 인증", "무농약"],
  },
  {
    id: "p3",
    name: "김상도",
    region: "전남해남",
    tagline: "겨울 배추 30년 외길, 해남 황토밭",
    photo: FACE_IMG.ansungJae,
    specialties: ["무", "배추", "봄동"],
    style: "value",
    priceLevel: 2,
    freshnessLevel: 4,
    rating: 4.7,
    reviewCount: 2104,
    honorary: true,
    badges: ["대량 할인", "산지직송"],
  },
  {
    id: "p4",
    name: "박정후",
    region: "제주서귀포",
    tagline: "한라산 햇살 머금은 노지 감귤",
    photo: FACE_IMG.me,
    specialties: ["감귤", "귤"],
    style: "premium",
    priceLevel: 5,
    freshnessLevel: 5,
    rating: 4.9,
    reviewCount: 980,
    honorary: true,
    badges: ["프리미엄", "당일수확"],
  },
  {
    id: "p5",
    name: "이수향",
    region: "강원평창",
    tagline: "고랭지 700m 무농약 채소",
    photo: FACE_IMG.cookingMom,
    specialties: ["시금치", "무", "브로콜리"],
    style: "organic",
    priceLevel: 4,
    freshnessLevel: 5,
    rating: 4.8,
    reviewCount: 415,
    honorary: true,
    badges: ["유기농 인증", "고랭지"],
  },
  {
    id: "p6",
    name: "정대근",
    region: "충남논산",
    tagline: "딸기보다 단 대파, 논산 들녘",
    photo: FACE_IMG.user2,
    specialties: ["대파", "마늘", "무"],
    style: "value",
    priceLevel: 2,
    freshnessLevel: 4,
    rating: 4.6,
    reviewCount: 738,
    honorary: false,
    badges: ["가성비", "산지직송"],
  },
  {
    id: "p7",
    name: "최영자",
    region: "경남통영",
    tagline: "통영 바다를 품은 새벽 생굴",
    photo: FACE_IMG.user1,
    specialties: ["굴"],
    style: "premium",
    priceLevel: 5,
    freshnessLevel: 5,
    rating: 4.9,
    reviewCount: 1560,
    honorary: false,
    badges: ["새벽 출고", "콜드체인"],
  },
  {
    id: "p8",
    name: "윤도현",
    region: "경북상주",
    tagline: "유기농 단호박·고구마 농장",
    photo: FACE_IMG.user3,
    specialties: ["단호박", "고구마"],
    style: "organic",
    priceLevel: 3,
    freshnessLevel: 4,
    rating: 4.7,
    reviewCount: 521,
    honorary: false,
    badges: ["유기농 인증", "산지직송"],
  },
];

// 명예/베스트 생산자 — 홈 캐러셀 · 베스트 농가 섹션
export const HONORARY_PRODUCERS = PRODUCERS.filter((p) => p.honorary);

// 특정 식재료를 취급하는 농가 (specialties 양방향 부분 매칭)
export function producersForIngredient(name) {
  if (!name) return [];
  return PRODUCERS.filter((p) =>
    p.specialties.some((s) => s.includes(name) || name.includes(s)),
  );
}

// 스타일 → 색/라벨 (t 는 동적 토큰이므로 함수로 분리)
export function styleStyle(style, t) {
  if (style === "value")
    return { key: "value", label: "저렴이·실속형", color: t.warning, bg: t.warningBg };
  if (style === "organic")
    return { key: "organic", label: "유기농·무농약", color: t.primaryDark, bg: t.primaryBg };
  return { key: "premium", label: "프리미엄·싱싱", color: t.hot, bg: t.hotBg };
}

// 식재료별 단위 / 기준가 (농가 판매 가격 산출용)
const UNIT_BY_INGREDIENT = {
  무: "개", 봄동: "봉", 배추: "포기", 시금치: "단", 대파: "단", 마늘: "접",
  감귤: "kg", 귤: "kg", 단호박: "개", 고구마: "kg", 굴: "kg", 콩: "kg", 브로콜리: "개",
};
const BASE_PRICE = {
  무: 2200, 봄동: 4500, 배추: 6800, 시금치: 3800, 대파: 3500, 마늘: 8900,
  감귤: 9900, 귤: 9900, 단호박: 4200, 고구마: 7150, 굴: 12900, 콩: 8500, 브로콜리: 2990,
};

// 농가 × 식재료 → { price, unit, fresh }  (priceLevel/freshnessLevel 기반 산출)
export function producerOffer(producer, name) {
  const unit = UNIT_BY_INGREDIENT[name] || "kg";
  const base = BASE_PRICE[name] || 3000;
  const mult = 0.82 + (producer.priceLevel - 1) * 0.09; // 1~5 → 0.82~1.18
  const price = Math.round((base * mult) / 10) * 10;
  const fresh =
    producer.freshnessLevel >= 5
      ? "당일수확"
      : producer.freshnessLevel >= 4
        ? "수확 1일 이내"
        : "산지직송";
  return { price, unit, fresh };
}

// 농가 스토어 소식 (NEWS 타임라인) — 농가별 샘플 3건
// img: 식재료명(→vegImg) 또는 "photo"(→농가 사진)
export function producerNews(producer) {
  const item = producer.specialties[0];
  return [
    {
      date: "2026.05.28. 오전 08:58",
      title: `제철 ${item} 5월 산지 소식입니다~`,
      img: item,
      body: `${producer.region} ${producer.name}입니다~ 올해는 일조량이 풍부해 ${item} 품질이 예년보다 좋습니다. 경매장 시세는 올랐지만, 소비자분들께 신선하고 맛있는 ${item}을(를) 보내드린다는 자부심으로 합리적인 가격에 정직하게 판매하고 있습니다. 이제 5월 끝자락…`,
    },
    {
      date: "2026.04.12. 오전 09:00",
      title: `${item}의 계절이 돌아왔습니다~`,
      img: "photo",
      body: `${item}의 계절이 다가왔습니다. 이번 해는 일조량이 풍부하여 ${producer.region} ${item}이(가) 무럭무럭 잘 자라고 있습니다. 작년 대비 생산량과 품질이 더 좋아졌습니다~ 산지의 신선함 그대로, 올 한 해 사랑받을 수 있도록 정직하게 판매하겠습니다. 꼭 한번 드셔보세요.`,
    },
    {
      date: "2026.03.07. 오전 08:56",
      title: `봄을 알리는 첫 수확을 시작하였습니다~`,
      img: item,
      body: `안녕하세요 생산자 ${producer.name}입니다~ 겨울 날씨가 포근하고 일조량이 좋아 수확을 조금 빨리 시작한 것 같습니다. 현재로썬 올해 생산량과 품질, 당도 3가지 다 우수할 것으로 보입니다. 토양에 투자하고 영양소를 원활하게 공급하며 정성껏 키웠습니다…`,
    },
  ];
}

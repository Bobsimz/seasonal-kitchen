// 데모용 목 데이터 — 응답 "형태"는 backend/docs/frontend-api-guide.md 의 실제 API 와
// 동일하게 맞춰서, 백엔드가 켜지면 그대로 교체되도록 했습니다.
// 백엔드 미기동/실패 시 lib/endpoints.js 가 이 데이터로 폴백합니다.

import {
  VEG_IMG,
  DISH_IMG,
  FOOD_IMG,
  FACE_IMG,
  vegImg,
} from '@/components/legacy/mock-images';
import { PRODUCERS, producerOffer } from '@/components/legacy/producers-data';

// ── 농가(생산자) : legacy PRODUCERS → API ProducerResponse 형태 ──────────
const STYLE_MAP = { value: 'VALUE', organic: 'ORGANIC', premium: 'PREMIUM' };
const pid = (p) => Number(p.id.replace('p', '')); // 'p1' → 1

export const producers = PRODUCERS.map((p) => ({
  id: pid(p),
  name: p.name,
  region: p.region,
  tagline: p.tagline,
  photoUrl: p.photo,
  style: STYLE_MAP[p.style] || 'PREMIUM',
  priceLevel: p.priceLevel,
  freshnessLevel: p.freshnessLevel,
  rating: p.rating,
  reviewCount: p.reviewCount,
  honorary: p.honorary,
  specialties: p.specialties,
  badges: p.badges,
}));

export const getProducer = (id) => producers.find((p) => p.id === Number(id));

// 농가가 파는 상품(offer) — priceLevel/freshness 기반 산출.
// id 는 (농가, 품목순서)로 결정적이게 만든다 — store.findOffer 가 같은 id 로 재조회하므로
// 데모 장바구니 담기가 안정적으로 동작한다.
export function producerOffers(producerId) {
  const p = PRODUCERS.find((x) => pid(x) === Number(producerId));
  if (!p) return [];
  return p.specialties.map((name, idx) => {
    const { price, unit, fresh } = producerOffer(p, name);
    return {
      id: Number(producerId) * 100 + idx,
      producerId: Number(producerId),
      producerName: p.name,
      region: p.region,
      ingredientName: name,
      ingredientId: ingredientIdByName(name),
      price,
      unit,
      freshnessLabel: fresh,
    };
  });
}

export function producerReviews(producerId) {
  const p = getProducer(producerId);
  if (!p) return [];
  const it = p.specialties[0];
  return [
    { id: 1, author: '민지', rating: 5, item: it, body: `${p.region}에서 바로 받아서 그런지 정말 싱싱해요. 재구매 의사 100%!`, createdAt: '2026-05-30T10:00:00+09:00' },
    { id: 2, author: '재현', rating: 5, item: p.specialties[1] || it, body: '포장도 꼼꼼하고 당일 수확이라 식감이 살아있어요.', createdAt: '2026-05-21T09:00:00+09:00' },
    { id: 3, author: '수안', rating: 4, item: it, body: '맛은 좋은데 배송이 하루 늦었어요. 그래도 또 주문할게요.', createdAt: '2026-05-12T18:30:00+09:00' },
  ];
}

export function producerNews(producerId) {
  const p = getProducer(producerId);
  if (!p) return [];
  const it = p.specialties[0];
  return [
    { id: 1, date: '2026.05.28', title: `제철 ${it} 5월 산지 소식입니다~`, imageUrl: vegImg(it), body: `${p.region} ${p.name}입니다~ 올해는 일조량이 풍부해 ${it} 품질이 예년보다 좋습니다.` },
    { id: 2, date: '2026.04.12', title: `${it}의 계절이 돌아왔습니다~`, imageUrl: p.photoUrl, body: `${it}의 계절이 다가왔습니다. 산지의 신선함 그대로 정직하게 판매하겠습니다.` },
  ];
}

// ── 식재료 ───────────────────────────────────────────────────────
const ING = [
  { id: 1, name: '무', cat: '뿌리채소', price: 2200, unit: '개', change: -12, season: [11, 12, 1, 2], hot: false },
  { id: 2, name: '배추', cat: '잎채소', price: 6800, unit: '포기', change: 8, season: [11, 12, 1], hot: false },
  { id: 12, name: '봄동', cat: '잎채소', price: 4500, unit: '봉', change: -15, season: [1, 2, 3], hot: true },
  { id: 4, name: '시금치', cat: '잎채소', price: 3800, unit: '단', change: -6, season: [12, 1, 2, 3], hot: false },
  { id: 5, name: '감귤', cat: '과일', price: 9900, unit: 'kg', change: 4, season: [11, 12, 1], hot: false },
  { id: 6, name: '대파', cat: '양념채소', price: 3500, unit: '단', change: -3, season: [11, 12, 1, 2], hot: false },
  { id: 7, name: '고구마', cat: '뿌리채소', price: 7150, unit: 'kg', change: 2, season: [9, 10, 11], hot: false },
  { id: 8, name: '브로콜리', cat: '꽃채소', price: 2990, unit: '개', change: -9, season: [11, 12, 1, 2], hot: false },
  { id: 9, name: '단호박', cat: '열매채소', price: 4200, unit: '개', change: 1, season: [9, 10, 11], hot: false },
  { id: 10, name: '콜라비', cat: '뿌리채소', price: 3300, unit: '개', change: -5, season: [11, 12, 1, 2], hot: false },
];

const NUTRITION = {
  무: [{ label: '비타민C', value: '풍부' }, { label: '식이섬유', value: '높음' }, { label: '칼로리', value: '18kcal' }],
  봄동: [{ label: '베타카로틴', value: '풍부' }, { label: '비타민C', value: '높음' }, { label: '칼로리', value: '15kcal' }],
};

const ingredientName = (id) => ING.find((i) => i.id === Number(id))?.name;
export function ingredientIdByName(name) {
  return ING.find((i) => i.name === name || name.includes(i.name) || i.name.includes(name))?.id ?? null;
}

function toIngredientCard(i) {
  return {
    id: i.id,
    name: i.name,
    category: i.cat,
    imageUrl: vegImg(i.name),
    currentPrice: i.price,
    unit: i.unit,
    priceChangePct: i.change,
    trendDirection: i.change > 1 ? 'UP' : i.change < -1 ? 'DOWN' : 'FLAT',
    priceChangeLabel: i.change === 0 ? '보합' : `${i.change > 0 ? '+' : ''}${i.change}%`,
    seasonal: i.season.includes(6), // 데모: 현재(6월) 제철 여부
    hot: i.hot,
    seasonMonths: i.season,
  };
}

export const ingredients = ING.map(toIngredientCard);
export const listIngredients = () => ingredients;

export function getIngredient(id) {
  const i = ING.find((x) => x.id === Number(id));
  if (!i) return null;
  const card = toIngredientCard(i);
  return {
    ...card,
    // 구매 신호 enum (UI가 코드→라벨/톤 매핑). GOOD=구매적기, HIGH=비싼시기, HOLD=평년수준
    buyingSignal: i.change <= -10 ? 'GOOD' : i.change >= 5 ? 'HIGH' : 'HOLD',
    nutrition: NUTRITION[i.name] || NUTRITION['무'],
    careTips: ['겉잎을 한 겹 벗겨 흐르는 물에 헹굽니다.', `용도에 맞게 ${i.unit} 단위로 손질해 보관하세요.`],
    storageTips: ['신문지에 싸서 냉장 보관하면 더 오래갑니다.', '잘라둔 것은 밀폐용기에 담아 2~3일 내 사용.'],
    compareStoreCount: 5,
  };
}

// 가격 이력 (상세 차트)
export function ingredientPrices(id) {
  const i = ING.find((x) => x.id === Number(id));
  if (!i) return [];
  const base = i.price;
  const points = ['1월', '2월', '3월', '4월', '5월', '6월'];
  return points.map((label, idx) => ({
    label,
    price: Math.round((base * (1 + Math.sin(idx) * 0.12)) / 10) * 10,
  }));
}

// 대체 식재료
export function ingredientSubstitutes(id) {
  const name = ingredientName(id);
  const map = { 봄동: ['배추', '시금치'], 무: ['콜라비', '배추'], 배추: ['봄동', '양배추'] };
  return (map[name] || ['배추', '시금치']).map((n) => ({
    id: ingredientIdByName(n),
    name: n,
    imageUrl: vegImg(n),
    reason: '식감과 조리법이 비슷해요',
  }));
}

// 리테일 스토어 가격 비교 (시세)
export function ingredientStoreOffers(id) {
  const i = ING.find((x) => x.id === Number(id));
  if (!i) return [];
  const stores = [
    { store: '쿠팡', delivery: '로켓프레시 · 내일 새벽', mult: 1.0, tag: '최저가' },
    { store: '마켓컬리', delivery: '샛별배송 · 내일 새벽', mult: 1.08, tag: null },
    { store: '오아시스', delivery: '새벽배송', mult: 0.96, tag: '특가' },
    { store: '네이버 장보기', delivery: '오늘 도착', mult: 1.12, tag: null },
    { store: '이마트몰', delivery: '쓱배송', mult: 1.05, tag: null },
  ];
  return stores
    .map((s, idx) => ({
      id: idx + 1,
      store: s.store,
      delivery: s.delivery,
      price: Math.round((i.price * s.mult) / 10) * 10,
      originalPrice: Math.round((i.price * s.mult * 1.15) / 10) * 10,
      discountPct: 13,
      tag: s.tag,
    }))
    .sort((a, b) => a.price - b.price);
}

// 식재료별 농가 비교 (가격순)
export function ingredientProducers(id) {
  const name = ingredientName(id);
  if (!name) return [];
  return PRODUCERS.filter((p) => p.specialties.some((s) => s.includes(name) || name.includes(s)))
    .map((p) => {
      const { price, unit, fresh } = producerOffer(p, name);
      // 담기용 offerId — producerOffers 와 동일 id 를 써서 store.findOffer 로 해석되게 한다.
      const offer = producerOffers(pid(p)).find(
        (o) => o.ingredientName.includes(name) || name.includes(o.ingredientName),
      );
      return {
        id: offer ? offer.id : pid(p) * 100,
        producerId: pid(p),
        producerName: p.name,
        region: p.region,
        ingredientName: name,
        ingredientId: Number(id),
        price,
        unit,
        freshnessLabel: fresh,
        rating: p.rating,
        reviewCount: p.reviewCount,
        style: STYLE_MAP[p.style],
        honorary: p.honorary,
        photoUrl: p.photoUrl,
        badges: p.badges,
      };
    })
    .sort((a, b) => a.price - b.price);
}

// 식재료별 농가 직거래 "상품" 목록 — /products(ProductCardResponse) 형태.
// id 는 producerOffers 의 offer id 를 그대로 써서(=결정적) 데모 장바구니 담기와 호환된다.
// 백엔드 GET /ingredients/{id}/products 가 생기면 그대로 교체됩니다
// (docs/ingredient-detail-revamp-2026-06-13.md).
export function ingredientProducts(id) {
  const i = ING.find((x) => x.id === Number(id));
  if (!i) return [];
  const name = i.name;
  const list = [];
  for (const p of PRODUCERS) {
    if (!p.specialties.some((s) => s.includes(name) || name.includes(s))) continue;
    const offer = producerOffers(pid(p)).find(
      (o) => o.ingredientName.includes(name) || name.includes(o.ingredientName),
    );
    if (!offer) continue;
    list.push({
      id: offer.id,
      name: `${offer.region} ${offer.ingredientName} · ${offer.freshnessLabel}`,
      ingredientId: Number(id),
      ingredientName: offer.ingredientName,
      producerId: offer.producerId,
      producerName: offer.producerName,
      region: offer.region,
      price: offer.price,
      unit: offer.unit,
      imageUrl: vegImg(name),
      stockStatus: 'IN_STOCK',
      category: i.cat,
    });
  }
  return list.sort((a, b) => a.price - b.price);
}

// ── 레시피 ───────────────────────────────────────────────────────
const RECIPES = [
  { id: 101, title: '봄동 비빔밥', img: DISH_IMG.봄동비빔밥, time: 20, difficulty: '쉬움', likes: 1240, servings: 2, ings: ['봄동', '쌀', '고추장', '계란'], tags: ['#봄동', '#한그릇', '#제철'], creator: '쿠킹맘', seasonal: true },
  { id: 102, title: '무생채', img: DISH_IMG.무생채, time: 15, difficulty: '쉬움', likes: 980, servings: 3, ings: ['무', '고추장', '대파'], tags: ['#무', '#밑반찬'], creator: '백종원', seasonal: true },
  { id: 103, title: '봄동 새우전', img: DISH_IMG.봄동새우전, time: 25, difficulty: '보통', likes: 620, servings: 2, ings: ['봄동', '계란'], tags: ['#봄동', '#전'], creator: '에밀리', seasonal: true },
  { id: 104, title: '배추전', img: DISH_IMG.배추전, time: 20, difficulty: '쉬움', likes: 540, servings: 2, ings: ['배추', '계란'], tags: ['#배추', '#전'], creator: '안성재', seasonal: false },
  { id: 105, title: '봄동 쌈밥', img: DISH_IMG.봄동쌈밥, time: 30, difficulty: '보통', likes: 410, servings: 2, ings: ['봄동', '쌀', '고추장'], tags: ['#봄동', '#쌈밥'], creator: '쿠킹맘', seasonal: true },
  { id: 106, title: '시금치 페스토', img: DISH_IMG.시금치페스토, time: 15, difficulty: '쉬움', likes: 380, servings: 4, ings: ['시금치', '마늘'], tags: ['#시금치', '#파스타'], creator: '에밀리', seasonal: true },
  { id: 107, title: '깍두기', img: DISH_IMG.깍두기, time: 40, difficulty: '보통', likes: 760, servings: 6, ings: ['무', '대파', '마늘'], tags: ['#무', '#김치'], creator: '백종원', seasonal: false },
  { id: 108, title: '비빔밥', img: DISH_IMG.비빔밥, time: 25, difficulty: '쉬움', likes: 1520, servings: 2, ings: ['시금치', '무', '계란', '고추장'], tags: ['#한그릇'], creator: '쿠킹맘', seasonal: false },
  { id: 109, title: '나물 무침', img: DISH_IMG.나물무침, time: 20, difficulty: '쉬움', likes: 290, servings: 4, ings: ['시금치', '마늘'], tags: ['#밑반찬'], creator: '안성재', seasonal: true },
];

function toRecipeCard(r) {
  return {
    id: r.id,
    title: r.title,
    imageUrl: r.img,
    cookMinutes: r.time,
    difficulty: r.difficulty,
    likes: r.likes,
    servings: r.servings,
    tags: r.tags,
    creatorName: r.creator,
    seasonal: r.seasonal,
    mainIngredients: r.ings,
  };
}
export const recipes = RECIPES.map(toRecipeCard);
export const listRecipes = () => recipes;

export function getRecipe(id) {
  const r = RECIPES.find((x) => x.id === Number(id));
  if (!r) return null;
  return {
    ...toRecipeCard(r),
    description: `제철 ${r.ings[0]}(으)로 만드는 ${r.title}. 간단하지만 재료 본연의 맛을 살린 레시피예요.`,
    estimatedCost: r.ings.length * 2500,
    ingredients: r.ings.map((n) => ({
      ingredientId: ingredientIdByName(n),
      name: n,
      amount: '적당량',
      imageUrl: vegImg(n),
      price: ING.find((i) => i.name === n)?.price ?? null,
    })),
    relatedReelIds: [r.id - 100],
  };
}

export function recipeSteps(id) {
  const r = RECIPES.find((x) => x.id === Number(id));
  if (!r) return [];
  return [
    { order: 1, text: `${r.ings[0]}을(를) 깨끗이 씻어 먹기 좋게 썰어 준비합니다.`, imageUrl: r.img },
    { order: 2, text: '팬을 달군 뒤 재료를 넣고 중불에서 볶습니다.', imageUrl: null, timerMinutes: 5 },
    { order: 3, text: '양념을 넣고 골고루 버무린 뒤 간을 맞춥니다.', imageUrl: null },
    { order: 4, text: '그릇에 담아 마무리합니다. 맛있게 드세요!', imageUrl: r.img },
  ];
}

export function recipesForIngredient(id) {
  const name = ingredientName(id);
  if (!name) return recipes.slice(0, 4);
  const matched = recipes.filter((r) => r.mainIngredients.some((n) => n === name));
  return matched.length ? matched : recipes.slice(0, 4);
}

// ── 릴스 ─────────────────────────────────────────────────────────
export const reels = [
  { id: 1, recipeId: 101, title: '봄동 비빔밥 1분 완성', thumbnailUrl: DISH_IMG.봄동비빔밥릴스1, videoUrl: null, creatorName: '쿠킹맘', creatorAvatar: FACE_IMG.cookingMom, likes: 3200, comments: 128, saves: 540, views: 48000, ingredients: ['봄동', '쌀', '고추장'], caption: '제철 봄동으로 만드는 초간단 비빔밥 🌱' },
  { id: 2, recipeId: 104, title: '배추전 황금레시피', thumbnailUrl: DISH_IMG.배추전, videoUrl: null, creatorName: '백종원', creatorAvatar: FACE_IMG.paekJongWon, likes: 5400, comments: 340, saves: 1200, views: 92000, ingredients: ['배추', '계란'], caption: '바삭한 배추전 비법 공개' },
  { id: 3, recipeId: 107, title: '깍두기 한 번에 끝내기', thumbnailUrl: DISH_IMG.깍두기, videoUrl: null, creatorName: '안성재', creatorAvatar: FACE_IMG.ansungJae, likes: 2100, comments: 90, saves: 430, views: 31000, ingredients: ['무', '대파'], caption: '아삭한 깍두기 담그는 법' },
  { id: 4, recipeId: 106, title: '시금치 페스토 파스타', thumbnailUrl: DISH_IMG.시금치페스토, videoUrl: null, creatorName: '에밀리', creatorAvatar: FACE_IMG.emily, likes: 1800, comments: 64, saves: 380, views: 27000, ingredients: ['시금치', '마늘'], caption: '초록초록 건강 파스타 🥬' },
];

export const getReel = (id) => reels.find((r) => r.id === Number(id));
export function reelComments(id) {
  return [
    { id: 1, author: '지수', body: '와 이거 진짜 맛있겠다 🤤', createdAt: '2026-06-10T12:00:00+09:00' },
    { id: 2, author: '현우', body: '봄동 어디서 사요?', createdAt: '2026-06-10T13:20:00+09:00' },
  ];
}

// ── 홈 ───────────────────────────────────────────────────────────
export function home() {
  const hero = {
    title: '지금이 제철, 봄동',
    subtitle: '이번 주 시세 -15% · 구매 적기',
    ingredientId: 12,
    imageUrl: DISH_IMG.봄동비빔밥히어로,
    priceLabel: '4,500원/봉',
    trendLabel: '-15%',
  };
  const seasonalIngredients = ingredients.filter((i) => i.seasonal || i.hot).slice(0, 8);
  // 히어로 캐러셀 슬라이드 — 대표(봄동) + 시세 하락폭이 큰 "지금 구매 적기" 식재료 4종.
  // (데모 season 기준상 제철 항목이 적을 수 있어, 전체 식재료에서 시세 매력도 순으로 보강)
  const heroPool = ingredients
    .filter((i) => i.id !== hero.ingredientId)
    .sort((a, b) => (a.priceChangePct ?? 0) - (b.priceChangePct ?? 0))
    .slice(0, 4);
  const heroes = [
    hero,
    ...heroPool.map((i) => ({
      title: `지금이 제철, ${i.name}`,
      subtitle: i.priceChangeLabel ? `이번 주 ${i.priceChangeLabel} · 지금이 구매 적기` : '제철 맞이 · 지금이 가장 신선해요',
      ingredientId: i.id,
      imageUrl: i.imageUrl,
      priceLabel: `${i.currentPrice.toLocaleString()}원/${i.unit}`,
      trendLabel: i.priceChangeLabel ?? '제철',
    })),
  ];
  return {
    locationLabel: '우리 동네 제철',
    unreadNotificationCount: 2,
    hero,
    heroes,
    seasonalIngredients,
    trendingRecipes: recipes.slice(0, 6),
    trendingReels: reels,
    trendingKeywords: ['봄동', '무생채', '배추전', '시금치 페스토', '깍두기'],
  };
}

// ── 검색 ─────────────────────────────────────────────────────────
export function search(q, type = 'ALL') {
  const ql = (q || '').trim();
  const ings = ingredients.filter((i) => !ql || i.name.includes(ql));
  const recs = recipes.filter((r) => !ql || r.title.includes(ql) || r.mainIngredients.some((n) => n.includes(ql)));
  const rls = reels.filter((r) => !ql || r.title.includes(ql) || r.ingredients.some((n) => n.includes(ql)));
  const items = [
    ...ings.map((i) => ({ type: 'INGREDIENT', id: i.id, title: i.name, description: '제철 식재료', imageUrl: i.imageUrl })),
    ...recs.map((r) => ({ type: 'RECIPE', id: r.id, title: r.title, description: `${r.cookMinutes}분 · ${r.difficulty}`, imageUrl: r.imageUrl })),
  ];
  return {
    items: type === 'ALL' ? items : items.filter((x) => x.type === type),
    ingredients: ings,
    recipes: recs,
    reels: rls,
    ingredientCount: ings.length,
    recipeCount: recs.length,
    reelCount: rls.length,
  };
}

export const trending = () =>
  ['봄동', '무생채', '배추전', '시금치 페스토', '깍두기', '감귤'].map((keyword, idx) => ({ keyword, searchCount: 100 - idx * 12 }));

export const recentSearches = () => ['봄동', '배추전', '무'];

// ── 사용자 / 마이페이지 ──────────────────────────────────────────
export const demoUser = { id: 1, nickname: '제철러버', email: 'demo@seasonal.kitchen', photoUrl: FACE_IMG.me };

export function userSummary() {
  return {
    user: demoUser,
    stats: { savedAmount: 32400, orderCount: 7, reviewCount: 3 },
    counts: { favorites: 12, priceAlerts: 4, orders: 7, reviews: 3, written: 3 },
    personalized: ingredients.slice(0, 4),
  };
}

// ── 알림 ─────────────────────────────────────────────────────────
export function notifications() {
  return {
    tabCounts: { ALL: 4, PRICE: 2, ORDER: 1, COMMUNITY: 1 },
    items: [
      { id: 1, type: 'PRICE', title: '봄동 가격이 떨어졌어요', body: '관심 등록한 봄동이 4,500원으로 -15%', createdAt: '2026-06-12T08:30:00+09:00', read: false, icon: 'price' },
      { id: 2, type: 'ORDER', title: '주문이 출고되었어요', body: '경북영천 권민성 · 봄동 외 1건', createdAt: '2026-06-11T15:00:00+09:00', read: false, icon: 'order' },
      { id: 3, type: 'PRICE', title: '무 구매 적기 알림', body: '무가 평년 대비 -12% 입니다', createdAt: '2026-06-10T09:00:00+09:00', read: true, icon: 'price' },
      { id: 4, type: 'COMMUNITY', title: '내 리뷰에 좋아요가 달렸어요', body: '권민성 농가 리뷰 +5', createdAt: '2026-06-09T20:00:00+09:00', read: true, icon: 'community' },
    ],
  };
}

// ── 가격 알림 ────────────────────────────────────────────────────
export function priceAlerts() {
  return [
    { id: 1, ingredientId: 12, ingredientName: '봄동', imageUrl: vegImg('봄동'), currentPrice: 4500, targetPrice: 4000, unit: '봉', active: true },
    { id: 2, ingredientId: 1, ingredientName: '무', imageUrl: vegImg('무'), currentPrice: 2200, targetPrice: 2000, unit: '개', active: true },
  ];
}

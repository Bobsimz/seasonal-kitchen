// Design tokens for 제철식재료 앱
// 메인 그린(#16C172)은 고정.
// 비교 가능한 3개 축:
//   1) GREEN_PRESETS   — 보조 그린 (연한/강조/차트 그린)
//   2) ACCENT_PRESETS  — 포인트 컬러 (가격↑, 핫템, 뱃지)
//   3) NEUTRAL_PRESETS — 중립 톤 (배경, 텍스트, 보더)

// === 고정 브랜드 그린 (메인) =================================================
export const BRAND = {
  primary: '#16C172',
};

// === 1) 보조 그린 옵션 ======================================================
// primary 는 고정. 같이 쓰이는 보조 그린 4종을 한 세트로:
//   primaryDark  — 강조 그린 (그라데이션 끝, hover, 강조 텍스트)
//   primaryBg    — 연한 그린 배경 (AI 검색 칩 등)
//   primarySoft  — 부드러운 하이라이트 (텍스트 마커 하이라이트)
//   chartGreen / chartGreenDark — 가격 차트 막대
export const GREEN_PRESETS = {
  // 산뜻하고 채도가 높은 — 기존 톤
  fresh: {
    label: '프레시',
    primaryDark:   '#0B8C4F',
    primaryBg:     '#E8F8EF',
    primarySoft:   '#C6EDD5',
    chartGreen:    '#9DD477',
    chartGreenDark:'#4F8F3B',
  },
  // 깊고 진한 숲 톤 — 차분하고 신뢰감
  forest: {
    label: '포레스트',
    primaryDark:   '#065F46',
    primaryBg:     '#E3F4EB',
    primarySoft:   '#B5DEC6',
    chartGreen:    '#7FB683',
    chartGreenDark:'#2E6E3A',
  },
  // 채도 낮춘 민트 — 가볍고 청량
  mint: {
    label: '민트',
    primaryDark:   '#0F9D7E',
    primaryBg:     '#E4F7F0',
    primarySoft:   '#B8E6D5',
    chartGreen:    '#8FD3BC',
    chartGreenDark:'#3E9A78',
  },
  // 노란기 살짝 — 자연/유기농 무드
  olive: {
    label: '올리브',
    primaryDark:   '#3F6E1F',
    primaryBg:     '#EEF6E0',
    primarySoft:   '#D4E5AC',
    chartGreen:    '#B7D26C',
    chartGreenDark:'#6A8E2A',
  },
  // 푸르스름한 보석 톤 — 모던
  emerald: {
    label: '에메랄드',
    primaryDark:   '#047857',
    primaryBg:     '#E6F7EE',
    primarySoft:   '#B8E6D0',
    chartGreen:    '#88D4B5',
    chartGreenDark:'#2E8A66',
  },
  // 라임 강조 — 발랄·트렌디
  lime: {
    label: '라임',
    primaryDark:   '#3F7A1F',
    primaryBg:     '#EDF8E3',
    primarySoft:   '#CDE9A3',
    chartGreen:    '#B5DD6F',
    chartGreenDark:'#5C9A2E',
  },
  // 세이지 — 채도 낮춘 차분한 회녹
  sage: {
    label: '세이지',
    primaryDark:   '#4A7A5C',
    primaryBg:     '#EDF2EC',
    primarySoft:   '#C8D6C5',
    chartGreen:    '#A8C2A0',
    chartGreenDark:'#5E8568',
  },
  // 말차 — 부드럽고 따뜻한 녹차 톤
  matcha: {
    label: '말차',
    primaryDark:   '#5C7A3E',
    primaryBg:     '#F1F5E5',
    primarySoft:   '#D2DDB3',
    chartGreen:    '#B5C77A',
    chartGreenDark:'#7A9143',
  },
  // 피스타치오 — 노란기 도는 밝은 파스텔
  pistachio: {
    label: '피스타치오',
    primaryDark:   '#6A8E3E',
    primaryBg:     '#F2F7E0',
    primarySoft:   '#DAE9A8',
    chartGreen:    '#C5D86A',
    chartGreenDark:'#84A23B',
  },
  // 제이드 — 푸르름이 진한 보석 톤
  jade: {
    label: '제이드',
    primaryDark:   '#0D7D6E',
    primaryBg:     '#E2F4F0',
    primarySoft:   '#A6DED2',
    chartGreen:    '#7AC9B5',
    chartGreenDark:'#2E8073',
  },
  // 파인 — 짙은 상록수, 럭셔리·고급
  pine: {
    label: '파인',
    primaryDark:   '#1F4D34',
    primaryBg:     '#DDEEE2',
    primarySoft:   '#A8CDB1',
    chartGreen:    '#6FA079',
    chartGreenDark:'#2D5C3A',
  },
  // 스프링 — 가장 채도 높은 봄 새싹
  spring: {
    label: '스프링',
    primaryDark:   '#2EA84E',
    primaryBg:     '#E9FAE4',
    primarySoft:   '#B5E5B0',
    chartGreen:    '#8FD688',
    chartGreenDark:'#3FA84E',
  },
  // 시폼 — 푸르스름한 청량 파스텔
  seafoam: {
    label: '시폼',
    primaryDark:   '#3A8E7A',
    primaryBg:     '#E0F4EE',
    primarySoft:   '#A8DCCD',
    chartGreen:    '#88CEBD',
    chartGreenDark:'#3F8D7C',
  },
};

// === 2) 포인트 컬러 옵션 ====================================================
export const ACCENT_PRESETS = {
  coral:    { label: '코랄',   hot: '#FF5A36', hotBg: '#FFEFEA', warning: '#F6A323', warningBg: '#FFF6E5' },
  tomato:   { label: '토마토', hot: '#E94B3C', hotBg: '#FCEAE8', warning: '#E8932B', warningBg: '#FCF1DE' },
  tangerine:{ label: '탱저린', hot: '#FF7A1A', hotBg: '#FFF0E1', warning: '#F2B33A', warningBg: '#FFF7E2' },
  berry:    { label: '베리',   hot: '#E63973', hotBg: '#FCE6EE', warning: '#F09A2E', warningBg: '#FCF1DD' },
  plum:     { label: '플럼',   hot: '#B0479E', hotBg: '#F5E7F2', warning: '#E0972E', warningBg: '#FAF0D9' },
  cobalt:   { label: '코발트', hot: '#2D6FE0', hotBg: '#E5EEFC', warning: '#E8A52A', warningBg: '#FCF2D9' },
};

// === 3) 중립 톤 옵션 ========================================================
export const NEUTRAL_PRESETS = {
  'warm-green': {
    label: '웜 그린',
    bg: '#FBFCFA', bgSoft: '#F4F6F2', card: '#FFFFFF',
    text: '#0F1A14', textMid: '#475048', textSoft: '#8A938C',
    border: '#ECEFEB', borderSoft: '#F2F4F0',
  },
  'cool-gray': {
    label: '쿨 그레이',
    bg: '#FAFAFB', bgSoft: '#F2F3F5', card: '#FFFFFF',
    text: '#111315', textMid: '#4B5159', textSoft: '#8B9098',
    border: '#E8EAEE', borderSoft: '#EFF1F4',
  },
  'cream': {
    label: '크림',
    bg: '#FCFAF6', bgSoft: '#F5F1E8', card: '#FFFFFF',
    text: '#1A1610', textMid: '#5A4F3F', textSoft: '#988A75',
    border: '#EDE6D6', borderSoft: '#F3EEE2',
  },
  'pure': {
    label: '퓨어 화이트',
    bg: '#FFFFFF', bgSoft: '#F6F6F7', card: '#FFFFFF',
    text: '#0A0A0A', textMid: '#4A4A4A', textSoft: '#8E8E8E',
    border: '#ECECEC', borderSoft: '#F3F3F3',
  },
  'stone': {
    label: '스톤',
    bg: '#F4F4F1', bgSoft: '#EBEBE6', card: '#FFFFFF',
    text: '#16171A', textMid: '#52555B', textSoft: '#888B91',
    border: '#E0E0DA', borderSoft: '#E8E8E2',
  },
};

export function makeTokens(greenKey = 'fresh', accentKey = 'coral', neutralKey = 'warm-green') {
  const green   = GREEN_PRESETS[greenKey]     || GREEN_PRESETS.fresh;
  const accent  = ACCENT_PRESETS[accentKey]   || ACCENT_PRESETS.coral;
  const neutral = NEUTRAL_PRESETS[neutralKey] || NEUTRAL_PRESETS['warm-green'];
  return {
    // 브랜드(메인 고정) + 보조 그린
    ...BRAND,
    primaryDark:    green.primaryDark,
    primaryBg:      green.primaryBg,
    primarySoft:    green.primarySoft,
    chartGreen:     green.chartGreen,
    chartGreenDark: green.chartGreenDark,
    // 중립
    ...neutral,
    // 포인트
    hot: accent.hot,
    hotBg: accent.hotBg,
    warning: accent.warning,
    warningBg: accent.warningBg,
    // 기타
    info: '#3B82F6',
    danger: '#EF4444',
    chartGray: '#D4D9D2',
  };
}


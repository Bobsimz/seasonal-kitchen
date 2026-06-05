// flow-arrows.jsx — 디자인 캔버스 섹션별 버튼→화면 플로우를
// 빨간 곡선 화살표로 표시하는 SVG 오버레이. DCSection은 비-아트보드
// 자식을 row 컨테이너 안의 절대-배치 자리에 그대로 렌더하므로
// (design-canvas.jsx의 row-wrapper 참고) 각 섹션 끝에 끼워 넣으면 됨.

import React from "react";
import { PHONE_W, PHONE_H } from "./phone";

// DCSection의 row 레이아웃과 정확히 일치해야 함:
//   padding-left: 60, gap: 48, artboard width: PHONE_W
const PADDING_LEFT = 60;
const GAP = 48;
const STRIDE = PHONE_W + GAP;

const leftOf = (n) => PADDING_LEFT + n * STRIDE;
const rightOf = (n) => leftOf(n) + PHONE_W;
const MID_Y = PHONE_H / 2;

const STROKE = "#FF3B30";

function bezier({ x1, y1, x2, y2 }) {
  const c = Math.max(GAP, Math.abs(x2 - x1) * 0.55);
  return `M ${x1} ${y1} C ${x1 + c} ${y1}, ${x2 - c} ${y2}, ${x2} ${y2}`;
}

function FlowArrows({ id, edges, rowWidth }) {
  const markerId = `flow-head-${id}`;
  return (
    <svg
      width={rowWidth}
      height={PHONE_H}
      viewBox={`0 0 ${rowWidth} ${PHONE_H}`}
      style={{
        position: "absolute",
        left: 0,
        top: 0,
        pointerEvents: "none",
        overflow: "visible",
      }}
      aria-hidden="true"
    >
      <defs>
        <marker
          id={markerId}
          viewBox="0 0 10 10"
          refX="8"
          refY="5"
          markerWidth="5"
          markerHeight="5"
          orient="auto-start-reverse"
          markerUnits="strokeWidth"
        >
          <path d="M 0 0 L 10 5 L 0 10 z" fill={STROKE} />
        </marker>
      </defs>
      {edges.map((e, i) => (
        <path
          key={i}
          d={bezier(e)}
          stroke={STROKE}
          strokeWidth={4}
          fill="none"
          strokeLinecap="round"
          markerEnd={`url(#${markerId})`}
        />
      ))}
    </svg>
  );
}

// ── 01 · 진입 & 온보딩 (6 아트보드) ────────────────────────────
const ONBOARDING_EDGES = [
  // 01 Splash → 02 Onboard (전체화면 탭)
  { x1: rightOf(0), y1: MID_Y, x2: leftOf(1), y2: MID_Y },
  // 02 "다음" → 03
  { x1: leftOf(1) + PHONE_W / 2 + 20, y1: 770, x2: leftOf(2), y2: MID_Y },
  // 03 "다음" → 04
  { x1: leftOf(2) + PHONE_W / 2 + 20, y1: 770, x2: leftOf(3), y2: MID_Y },
  // 04 "시작하기" → 05
  { x1: leftOf(3) + PHONE_W / 2 + 20, y1: 770, x2: leftOf(4), y2: MID_Y },
  // 05 "이메일로 가입" → 06
  { x1: leftOf(4) + PHONE_W / 2 + 20, y1: 340, x2: leftOf(5), y2: MID_Y },
];
export const OnboardingFlow = () => (
  <FlowArrows id="onboard" edges={ONBOARDING_EDGES} rowWidth={rightOf(5)} />
);

// ── 02 · 홈 (3 아트보드: 04 홈, 05 검색 전, 06 검색 결과) ────────
const HOME_EDGES = [
  // 04 우측 상단 검색 버튼 → 05 (검색바 영역으로 진입)
  { x1: leftOf(0) + 360, y1: 55, x2: leftOf(1), y2: 78 },
  // 05 검색바 → 06
  { x1: leftOf(1) + 355, y1: 70, x2: leftOf(2), y2: MID_Y },
];
export const HomeFlow = () => (
  <FlowArrows id="home" edges={HOME_EDGES} rowWidth={rightOf(2)} />
);

// ── 03 · 식재료 & 레시피 탐색 (재정렬 후: 09, 10, 07, 08, 11, 11′, 12) ──
const CATALOG_EDGES = [
  // 09 레시피 검색바 → 10
  { x1: leftOf(0) + 195, y1: 78, x2: leftOf(1), y2: MID_Y },
  // 07 식재료 검색바 → 08
  { x1: leftOf(2) + 195, y1: 78, x2: leftOf(3), y2: MID_Y },
  // 07 "무" 항목 카드 → 11 식재료 상세
  { x1: leftOf(2) + 195, y1: 380, x2: leftOf(4), y2: MID_Y },
  // 11′ 모바일 상세 "온라인 가격 비교하기" → 12 가격 비교
  { x1: leftOf(5) + 330, y1: 793, x2: leftOf(6), y2: MID_Y },
];
export const CatalogFlow = () => (
  <FlowArrows id="catalog" edges={CATALOG_EDGES} rowWidth={rightOf(6)} />
);

// ── 04 · AI 장보기 (4 아트보드: 11, 11′, 12, 12′) ────────────────
const AI_EDGES = [
  // 11′ 모바일 AI 챗 "찜하기 9개 · ₩38,400" 카드 → 12 AI 추천 결과
  { x1: leftOf(1) + 295, y1: 720, x2: leftOf(2), y2: MID_Y },
];
export const AiFlow = () => (
  <FlowArrows id="ai" edges={AI_EDGES} rowWidth={rightOf(3)} />
);

// ── 05 · 레시피 릴스 & 상세 (4 아트보드: 13, 14, 14′, 15) ─────────
const REELS_EDGES = [
  // 13 우측 "자세히" 핸들 → 14 (수평 거리 짧으니 거의 수평으로 진입)
  { x1: leftOf(0) + 390, y1: 159, x2: leftOf(1), y2: 200 },
  // 14′ 모바일 상세 "조리 순서 보기" → 15 조리 순서
  { x1: leftOf(2) + 370, y1: 800, x2: leftOf(3), y2: MID_Y },
];
export const ReelsFlow = () => (
  <FlowArrows id="reels" edges={REELS_EDGES} rowWidth={rightOf(3)} />
);

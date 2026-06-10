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

// ── 01 · 진입 & 온보딩 (5 아트보드: 01 스플래시, 02·03 온보딩, 04·05 가입) ──
const ONBOARDING_EDGES = [
  // 01 Splash → 02 Onboard (전체화면 탭)
  { x1: rightOf(0), y1: MID_Y, x2: leftOf(1), y2: MID_Y },
  // 02 "다음" → 03
  { x1: leftOf(1) + PHONE_W / 2 + 20, y1: 770, x2: leftOf(2), y2: MID_Y },
  // 03 "시작하기" → 04 Sign Up
  { x1: leftOf(2) + PHONE_W / 2 + 20, y1: 770, x2: leftOf(3), y2: MID_Y },
  // 04 "이메일로 가입" → 05 설문
  { x1: leftOf(3) + PHONE_W / 2 + 20, y1: 340, x2: leftOf(4), y2: MID_Y },
];
export const OnboardingFlow = () => (
  <FlowArrows id="onboard" edges={ONBOARDING_EDGES} rowWidth={rightOf(4)} />
);

// ── 02 · 홈 (3 아트보드: 07 홈, 08 검색 전, 09 검색 결과) ────────
const HOME_EDGES = [
  // 07 우측 상단 '검색' 아이콘 위 → 08 (검색바 영역으로 진입)
  { x1: leftOf(0) + 305, y1: 42, x2: leftOf(1), y2: 78 },
  // 08 → 09 화살표는 제거됨
];
export const HomeFlow = () => (
  <FlowArrows id="home" edges={HOME_EDGES} rowWidth={rightOf(2)} />
);

// ── 03 · 정보 — 식재료 & 레시피 (농가 제거 후 8 아트보드: 10,11,12,13,14,14′,15,15a) ──
const CATALOG_EDGES = [
  // 10→11, 12→13 화살표는 제거됨 (홈 검색결과(09)에서 직접 진입하는 흐름으로 대체)
  // 11 좌측 상단 뒤로가기 → 10 (검색결과 → 기본 리스트, 화살표 끝을 10 우측 테두리에)
  { x1: leftOf(1) + 30, y1: 66, x2: rightOf(0), y2: 66 },
  // 13 좌측 상단 뒤로가기 → 12 (검색결과 → 기본 리스트, 화살표 끝을 12 우측 테두리에)
  { x1: leftOf(3) + 30, y1: 66, x2: rightOf(2), y2: 66 },
  // 12 "무" 항목 카드 → 14 식재료 상세
  { x1: leftOf(2) + 195, y1: 380, x2: leftOf(4), y2: MID_Y },
  // 14′ 모바일 상세 "온라인 가격 비교하기" → 15 농가 비교
  { x1: leftOf(5) + 330, y1: 793, x2: leftOf(6), y2: MID_Y },
];
export const CatalogFlow = () => (
  <FlowArrows id="catalog" edges={CATALOG_EDGES} rowWidth={rightOf(7)} />
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

// ─────────────────────────────────────────────────────────────
// CrossSectionFlow — 섹션을 가로지르는 화살표 (예: 09 홈 검색결과 → 11/13 정보 검색결과).
// 섹션별 FlowArrows는 행-로컬 좌표라 섹션을 넘는 연결을 그릴 수 없어, 여기서는
// 캔버스 월드(data-dc-world) 안에 절대 배치된 SVG에 DOM 실측 좌표로 베지어를 그린다.
// 줌 시 섹션 간격(--dc-inv-zoom 의존)이 변하므로 ResizeObserver로 재측정한다.
//   pairs: [{ src: CSS선택자(시작 요소), dst: CSS선택자(도착 요소) }]
// ─────────────────────────────────────────────────────────────
export function CrossSectionFlow({ pairs }) {
  const [paths, setPaths] = React.useState([]);
  const [dims, setDims] = React.useState({ w: 0, h: 0 });

  React.useEffect(() => {
    const world = document.querySelector("[data-dc-world]");
    if (!world) return undefined;

    const measure = () => {
      const wb = world.getBoundingClientRect();
      const scale = wb.width / world.offsetWidth || 1;
      const toWorld = (el) => {
        const r = el.getBoundingClientRect();
        return {
          left: (r.left - wb.left) / scale,
          top: (r.top - wb.top) / scale,
          right: (r.right - wb.left) / scale,
          bottom: (r.bottom - wb.top) / scale,
          cx: (r.left + r.width / 2 - wb.left) / scale,
        };
      };
      const next = [];
      for (const p of pairs) {
        const src = document.querySelector(p.src);
        const dst = document.querySelector(p.dst);
        if (!src || !dst) continue;
        const s = toWorld(src);
        const d = toWorld(dst);
        // 시작: 더보기 버튼의 하단 중앙 / 도착: 대상 아트보드의 상단 중앙
        next.push({ x1: s.cx, y1: s.bottom, x2: d.cx, y2: d.top });
      }
      setPaths(next);
      setDims({ w: world.offsetWidth, h: world.offsetHeight });
    };

    measure();
    // 폰트/이미지 로딩과 첫 레이아웃 정착 후 재측정
    const raf = requestAnimationFrame(() =>
      requestAnimationFrame(measure),
    );
    const t = setTimeout(measure, 500);
    const ro =
      typeof ResizeObserver !== "undefined"
        ? new ResizeObserver(measure)
        : null;
    if (ro) ro.observe(world);
    window.addEventListener("resize", measure);
    return () => {
      cancelAnimationFrame(raf);
      clearTimeout(t);
      if (ro) ro.disconnect();
      window.removeEventListener("resize", measure);
    };
  }, [pairs]);

  return (
    <div
      data-omelette-chrome=""
      style={{
        position: "absolute",
        top: 0,
        left: 0,
        width: dims.w || "100%",
        height: dims.h || "100%",
        pointerEvents: "none",
        overflow: "visible",
        zIndex: 40,
      }}
    >
      <svg
        width={dims.w}
        height={dims.h}
        style={{ position: "absolute", top: 0, left: 0, overflow: "visible" }}
        aria-hidden="true"
      >
        <defs>
          <marker
            id="cross-flow-head"
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
        {paths.map((e, i) => {
          const c = Math.max(90, Math.abs(e.y2 - e.y1) * 0.4);
          const d = `M ${e.x1} ${e.y1} C ${e.x1} ${e.y1 + c}, ${e.x2} ${e.y2 - c}, ${e.x2} ${e.y2}`;
          return (
            <path
              key={i}
              d={d}
              stroke={STROKE}
              strokeWidth={4}
              fill="none"
              strokeLinecap="round"
              markerEnd="url(#cross-flow-head)"
            />
          );
        })}
      </svg>
    </div>
  );
}

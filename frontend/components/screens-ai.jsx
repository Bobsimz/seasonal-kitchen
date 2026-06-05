// AI 추천 — 2가지 변형
// A: 단계형 (선택 UI 5단계) — 사용자가 제안한 플로우
// B: 챗형 (GPT 스타일 자유 대화 + 카드 응답)
// + 결과 화면

import React from "react";
import { Phone, AppHeader, BottomTabBar, VegPlaceholder, Chip, priceRange } from "./phone";
import { DISH_IMG, FACE_IMG } from "./mock-images";

// ─────────────────────────────────────────────────────────────
// A1 — 단계 1·2 (며칠/몇 명/먹고 싶은 음식)
// ─────────────────────────────────────────────────────────────
export function ScreenAIStepA1({ t }) {
  return (
    <Phone t={t}>
      <AppHeader
        t={t}
        title="AI 장보기"
        leftBack
        rightIcons={
          <div
            className="tap"
            style={{
              width: 32,
              height: 32,
              display: "grid",
              placeItems: "center",
              fontSize: 12,
              fontWeight: 700,
              color: t.textSoft,
            }}
          >
            건너뛰기
          </div>
        }
      />
      <div
        className="phone-scroll"
        style={{ flex: 1, overflow: "auto", background: t.bg }}
      >
        {/* progress */}
        <div style={{ padding: "4px 20px 0" }}>
          <div style={{ display: "flex", gap: 4 }}>
            {[0, 1, 2, 3, 4].map((i) => (
              <div
                key={i}
                style={{
                  flex: 1,
                  height: 4,
                  borderRadius: 2,
                  background: i < 2 ? t.primary : t.borderSoft,
                }}
              />
            ))}
          </div>
          <div
            style={{
              fontSize: 11.5,
              fontWeight: 700,
              color: t.primary,
              marginTop: 8,
            }}
          >
            STEP 2 of 5
          </div>
        </div>

        <div style={{ padding: "8px 20px 0" }}>
          <div
            style={{
              fontSize: 22,
              fontWeight: 800,
              color: t.text,
              letterSpacing: -0.6,
              lineHeight: 1.3,
            }}
          >
            먹고 싶은 음식을
            <br />
            골라주세요
          </div>
          <div style={{ marginTop: 4, fontSize: 13, color: t.textMid }}>
            선택한 음식의 재료를 우선 반영해요
          </div>
        </div>

        {/* — quick recap of step 1 — */}
        <div style={{ padding: "16px 20px 0" }}>
          <div
            style={{
              background: "#fff",
              borderRadius: 14,
              padding: "12px 14px",
              border: `1px solid ${t.borderSoft}`,
              display: "flex",
              alignItems: "center",
              gap: 10,
            }}
          >
            <span style={{ fontSize: 18 }}>📋</span>
            <span style={{ fontSize: 12.5, color: t.textMid, flex: 1 }}>
              <b style={{ color: t.text }}>5일 · 2인</b> 분량으로 추천해요
            </span>
            <span style={{ fontSize: 12, fontWeight: 700, color: t.primary }}>
              수정
            </span>
          </div>
        </div>

        {/* search input */}
        <div style={{ padding: "14px 20px 0" }}>
          <div
            style={{
              height: 44,
              borderRadius: 12,
              background: "#fff",
              border: `1.5px solid ${t.borderSoft}`,
              display: "flex",
              alignItems: "center",
              padding: "0 12px",
              gap: 8,
            }}
          >
            <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
              <circle
                cx="7"
                cy="7"
                r="5"
                stroke={t.textSoft}
                strokeWidth="1.5"
              />
              <path
                d="M10.5 10.5L14 14"
                stroke={t.textSoft}
                strokeWidth="1.5"
                strokeLinecap="round"
              />
            </svg>
            <span style={{ flex: 1, fontSize: 13, color: t.textSoft }}>
              음식 검색…
            </span>
          </div>
        </div>

        {/* category chip */}
        <div
          style={{
            display: "flex",
            gap: 6,
            padding: "14px 20px 0",
            overflowX: "auto",
          }}
          className="phone-scroll"
        >
          {["🌱 제철 추천", "한식", "양식", "간단식", "국·찌개", "면 요리"].map(
            (c, i) => (
              <div
                key={i}
                style={{
                  padding: "7px 12px",
                  borderRadius: 999,
                  fontSize: 12,
                  fontWeight: 700,
                  background: i === 0 ? t.primary : "#fff",
                  color: i === 0 ? "#fff" : t.textMid,
                  border: i === 0 ? "none" : `1px solid ${t.border}`,
                  whiteSpace: "nowrap",
                  flexShrink: 0,
                }}
              >
                {c}
              </div>
            ),
          )}
        </div>

        {/* food grid */}
        <div style={{ padding: "16px 20px 0" }}>
          <div
            style={{
              display: "grid",
              gridTemplateColumns: "1fr 1fr 1fr",
              gap: 10,
            }}
          >
            {[
              {
                name: "봄동비빔밥",
                s: true,
                season: true,
                img: DISH_IMG.봄동비빔밥,
              },
              { name: "무생채", s: true, season: true, img: DISH_IMG.무생채 },
              { name: "배추전", s: false, season: true, img: DISH_IMG.배추전 },
              {
                name: "무 양념무침",
                s: true,
                season: false,
                img: DISH_IMG.무양념무침,
              },
              { name: "비빔밥", s: false, season: false, img: DISH_IMG.비빔밥 },
              {
                name: "나물무침",
                s: false,
                season: false,
                img: DISH_IMG.나물무침,
              },
              { name: "깍두기", s: false, season: false, img: DISH_IMG.깍두기 },
              {
                name: "시금치페스토",
                s: false,
                season: false,
                img: DISH_IMG.시금치페스토,
              },
              {
                name: "무생채 황금레시피",
                s: false,
                season: false,
                img: DISH_IMG.무생채황금레시피,
              },
            ].map((f, i) => (
              <div
                key={i}
                className="tap"
                style={{
                  borderRadius: 14,
                  overflow: "hidden",
                  position: "relative",
                  background: "#fff",
                  border: f.s
                    ? `2px solid ${t.primary}`
                    : `1px solid ${t.borderSoft}`,
                }}
              >
                <div
                  style={{
                    aspectRatio: "1",
                    position: "relative",
                    backgroundImage: `url(${f.img})`,
                    backgroundSize: "cover",
                    backgroundPosition: "center",
                  }}
                >
                  {f.season && (
                    <div
                      style={{
                        position: "absolute",
                        top: 6,
                        left: 6,
                        fontSize: 9,
                        fontWeight: 800,
                        color: t.primaryDark,
                        background: "#fff",
                        padding: "2px 6px",
                        borderRadius: 999,
                      }}
                    >
                      제철
                    </div>
                  )}
                  {f.s && (
                    <div
                      style={{
                        position: "absolute",
                        bottom: 6,
                        right: 6,
                        width: 22,
                        height: 22,
                        borderRadius: 11,
                        background: t.primary,
                        display: "grid",
                        placeItems: "center",
                      }}
                    >
                      <svg width="12" height="12" viewBox="0 0 12 12">
                        <path
                          d="M2.5 6l2.5 2.5L9.5 4"
                          stroke="#fff"
                          strokeWidth="2"
                          fill="none"
                          strokeLinecap="round"
                          strokeLinejoin="round"
                        />
                      </svg>
                    </div>
                  )}
                </div>
                <div
                  style={{
                    padding: 8,
                    fontSize: 12,
                    fontWeight: 700,
                    color: t.text,
                    textAlign: "center",
                  }}
                >
                  {f.name}
                </div>
              </div>
            ))}
          </div>
        </div>
        <div style={{ height: 90 }} />
      </div>
      {/* sticky bottom cta */}
      <div
        style={{
          position: "absolute",
          left: 0,
          right: 0,
          bottom: 34,
          padding: 16,
          background: "linear-gradient(180deg, transparent, #fff 30%)",
        }}
      >
        <div
          style={{
            fontSize: 11.5,
            color: t.textSoft,
            textAlign: "center",
            marginBottom: 8,
          }}
        >
          3개 선택됨 · 최대 5개
        </div>
        <button
          className="tap"
          style={{
            width: "100%",
            height: 52,
            borderRadius: 14,
            border: "none",
            background: t.primary,
            color: "#fff",
            fontSize: 15,
            fontWeight: 800,
            letterSpacing: -0.3,
          }}
        >
          다음
        </button>
      </div>
    </Phone>
  );
}

// ─────────────────────────────────────────────────────────────
// A2 — 단계 4·5 (포함/제외 + 소비 스타일)
// ─────────────────────────────────────────────────────────────
export function ScreenAIStepA2({ t }) {
  return (
    <Phone t={t}>
      <AppHeader
        t={t}
        title="AI 장보기"
        leftBack
        rightIcons={
          <div
            className="tap"
            style={{
              width: 32,
              height: 32,
              display: "grid",
              placeItems: "center",
              fontSize: 12,
              fontWeight: 700,
              color: t.textSoft,
            }}
          >
            건너뛰기
          </div>
        }
      />
      <div
        className="phone-scroll"
        style={{ flex: 1, overflow: "auto", background: t.bg }}
      >
        <div style={{ padding: "4px 20px 0" }}>
          <div style={{ display: "flex", gap: 4 }}>
            {[0, 1, 2, 3, 4].map((i) => (
              <div
                key={i}
                style={{
                  flex: 1,
                  height: 4,
                  borderRadius: 2,
                  background: i < 4 ? t.primary : t.borderSoft,
                }}
              />
            ))}
          </div>
          <div
            style={{
              fontSize: 11.5,
              fontWeight: 700,
              color: t.primary,
              marginTop: 8,
            }}
          >
            STEP 4 of 5
          </div>
        </div>

        <div style={{ padding: "8px 20px 0" }}>
          <div
            style={{
              fontSize: 21,
              fontWeight: 800,
              color: t.text,
              letterSpacing: -0.6,
              lineHeight: 1.3,
            }}
          >
            꼭 포함/제외할 재료가
            <br />
            있나요?
          </div>
        </div>

        {/* 포함 */}
        <div style={{ padding: "20px 20px 0" }}>
          <div
            style={{
              fontSize: 13,
              fontWeight: 700,
              color: t.primary,
              marginBottom: 8,
              display: "flex",
              alignItems: "center",
              gap: 4,
            }}
          >
            <svg width="14" height="14" viewBox="0 0 14 14">
              <circle cx="7" cy="7" r="6" fill={t.primary} />
              <path
                d="M4 7h6M7 4v6"
                stroke="#fff"
                strokeWidth="2"
                strokeLinecap="round"
              />
            </svg>
            포함할 재료
          </div>
          <div style={{ display: "flex", flexWrap: "wrap", gap: 6 }}>
            {[
              { name: "토마토", s: true },
              { name: "양배추", s: true },
              { name: "애호박", s: true },
              { name: "브로콜리", s: false },
              { name: "계란", s: false },
              { name: "닭가슴살", s: false },
            ].map((c, i) => (
              <div
                key={i}
                style={{
                  padding: "8px 14px",
                  borderRadius: 999,
                  fontSize: 13,
                  fontWeight: 600,
                  background: c.s ? t.primary : "#fff",
                  color: c.s ? "#fff" : t.textMid,
                  border: c.s ? "none" : `1px solid ${t.border}`,
                }}
              >
                {c.s && "✓ "}
                {c.name}
              </div>
            ))}
            <div
              style={{
                padding: "8px 14px",
                borderRadius: 999,
                fontSize: 13,
                fontWeight: 600,
                background: t.bgSoft,
                color: t.textSoft,
                border: `1px dashed ${t.border}`,
              }}
            >
              + 직접 입력
            </div>
          </div>
        </div>

        {/* 제외 */}
        <div style={{ padding: "20px 20px 0" }}>
          <div
            style={{
              fontSize: 13,
              fontWeight: 700,
              color: t.hot,
              marginBottom: 8,
              display: "flex",
              alignItems: "center",
              gap: 4,
            }}
          >
            <svg width="14" height="14" viewBox="0 0 14 14">
              <circle cx="7" cy="7" r="6" fill={t.hot} />
              <path
                d="M4 7h6"
                stroke="#fff"
                strokeWidth="2"
                strokeLinecap="round"
              />
            </svg>
            제외할 재료
          </div>
          <div style={{ display: "flex", flexWrap: "wrap", gap: 6 }}>
            {[
              { name: "오이", s: true },
              { name: "고수", s: true },
              { name: "버섯", s: false },
              { name: "깻잎", s: false },
              { name: "가지", s: false },
            ].map((c, i) => (
              <div
                key={i}
                style={{
                  padding: "8px 14px",
                  borderRadius: 999,
                  fontSize: 13,
                  fontWeight: 600,
                  background: c.s ? t.hot : "#fff",
                  color: c.s ? "#fff" : t.textMid,
                  border: c.s ? "none" : `1px solid ${t.border}`,
                }}
              >
                {c.s && "✕ "}
                {c.name}
              </div>
            ))}
            <div
              style={{
                padding: "8px 14px",
                borderRadius: 999,
                fontSize: 13,
                fontWeight: 600,
                background: t.bgSoft,
                color: t.textSoft,
                border: `1px dashed ${t.border}`,
              }}
            >
              + 직접 입력
            </div>
          </div>
        </div>

        {/* 소비 스타일 */}
        <div style={{ padding: "24px 20px 0" }}>
          <div
            style={{
              fontSize: 14,
              fontWeight: 800,
              color: t.text,
              marginBottom: 10,
            }}
          >
            소비 스타일
          </div>
          <div
            style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 8 }}
          >
            {[
              { label: "🌱 제철 우선", s: true },
              { label: "💸 가성비 우선", s: true },
              { label: "⭐ 리뷰 좋은 순", s: false },
              { label: "🔥 인기순", s: false },
              { label: "🥗 건강 우선", s: false },
              { label: "⏱ 조리 쉬운 순", s: false },
            ].map((c, i) => (
              <div
                key={i}
                className="tap"
                style={{
                  padding: "12px 12px",
                  borderRadius: 12,
                  fontSize: 13,
                  fontWeight: 700,
                  background: c.s ? t.primaryBg : "#fff",
                  color: c.s ? t.primaryDark : t.textMid,
                  border: c.s
                    ? `1.5px solid ${t.primary}`
                    : `1px solid ${t.borderSoft}`,
                  display: "flex",
                  alignItems: "center",
                  gap: 4,
                }}
              >
                {c.label}
              </div>
            ))}
          </div>
        </div>

        <div style={{ height: 110 }} />
      </div>
      <div
        style={{
          position: "absolute",
          left: 0,
          right: 0,
          bottom: 34,
          padding: 16,
          background: "linear-gradient(180deg, transparent, #fff 30%)",
          display: "flex",
          gap: 8,
        }}
      >
        <button
          className="tap"
          style={{
            width: 80,
            height: 52,
            borderRadius: 14,
            border: `1.5px solid ${t.border}`,
            background: "#fff",
            color: t.textMid,
            fontSize: 14,
            fontWeight: 700,
          }}
        >
          이전
        </button>
        <button
          className="tap"
          style={{
            flex: 1,
            height: 52,
            borderRadius: 14,
            border: "none",
            background: t.primary,
            color: "#fff",
            fontSize: 15,
            fontWeight: 800,
          }}
        >
          ✨ AI 추천 생성하기
        </button>
      </div>
    </Phone>
  );
}

// ─────────────────────────────────────────────────────────────
// AI Result — 추천 결과 (식재료 카드)
// ─────────────────────────────────────────────────────────────
const CART_ITEMS = [
  { name: "봄동", q: "1단", price: 2400, plat: "쿠팡", tag: "제철적기" },
  { name: "배추", q: "1포기", price: 2890, plat: "쿠팡", tag: "과잉" },
  { name: "당근", q: "300g", price: 1990, plat: "컬리", tag: "" },
  { name: "대파", q: "1단", price: 3500, plat: "컬리", tag: "⚠ 가격↑" },
  { name: "계란", q: "15구", price: 5900, plat: "쿠팡", tag: "" },
  { name: "돼지고기 앞다리", q: "500g", price: 8900, plat: "컬리", tag: "" },
  { name: "시금치", q: "200g", price: 1890, plat: "쿠팡", tag: "제철" },
  { name: "고추장", q: "500g", price: 4990, plat: "쿠팡", tag: "" },
  { name: "쌀", q: "1kg", price: 7150, plat: "컬리", tag: "" },
];

export function ScreenAIResult({ t }) {
  const [checked, setChecked] = React.useState(() =>
    CART_ITEMS.map(() => true),
  );
  const checkedCount = checked.filter(Boolean).length;
  const toggle = (i) =>
    setChecked((prev) => prev.map((v, idx) => (idx === i ? !v : v)));
  return (
    <Phone t={t}>
      <div
        className="phone-scroll"
        style={{
          flex: 1,
          overflow: "auto",
          background: t.bg,
          paddingBottom: 96,
        }}
      >
        {/* gradient header */}
        <div
          style={{
            padding: "52px 20px 24px",
            background: `linear-gradient(135deg, ${t.primary}, ${t.primaryDark})`,
            color: "#fff",
            position: "relative",
            overflow: "hidden",
          }}
        >
          <div
            style={{
              position: "absolute",
              right: -40,
              top: -40,
              width: 200,
              height: 200,
              borderRadius: 200,
              background: "rgba(255,255,255,0.08)",
            }}
          />
          <div
            style={{
              display: "flex",
              alignItems: "center",
              justifyContent: "space-between",
              marginBottom: 16,
            }}
          >
            <div
              className="tap"
              style={{
                width: 32,
                height: 32,
                display: "grid",
                placeItems: "center",
              }}
            >
              <svg width="20" height="20" viewBox="0 0 20 20">
                <path
                  d="M13 4L7 10l6 6"
                  stroke="#fff"
                  strokeWidth="2"
                  fill="none"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                />
              </svg>
            </div>
          </div>
          <div
            style={{
              fontSize: 24,
              fontWeight: 800,
              letterSpacing: -0.7,
              lineHeight: 1.3,
            }}
          >
            5일 · 2인 가족을 위한
            <br />
            이번 주 식재료
          </div>
          <div style={{ fontSize: 13, opacity: 0.9, marginTop: 8 }}>
            제철 · 가성비 중심 · 8개 메뉴 가능
          </div>

          {/* total */}
          <div
            style={{
              marginTop: 16,
              background: "rgba(255,255,255,0.16)",
              backdropFilter: "blur(8px)",
              borderRadius: 14,
              padding: "12px 14px",
              display: "flex",
              alignItems: "center",
              justifyContent: "space-between",
            }}
          >
            <div>
              <div style={{ fontSize: 11, opacity: 0.85 }}>총 예상 비용</div>
              <div
                style={{
                  fontSize: 22,
                  fontWeight: 800,
                  fontFeatureSettings: '"tnum"',
                  marginTop: 2,
                  width: 300,
                }}
              >
                ₩{priceRange(CART_ITEMS.reduce((s, i) => s + i.price, 0))}
              </div>
            </div>
          </div>
        </div>

        {/* meal preview pills */}
        <div
          style={{
            padding: "14px 20px 0",
            display: "flex",
            gap: 6,
            overflowX: "auto",
          }}
          className="phone-scroll"
        >
          {["봄동 비빔밥", "된장찌개", "배추전", "제육볶음", "봄동 새우전"].map(
            (m, i) => (
              <div
                key={i}
                style={{
                  padding: "8px 14px",
                  borderRadius: 999,
                  fontSize: 12.5,
                  fontWeight: 700,
                  background: "#fff",
                  border: `1px solid ${t.borderSoft}`,
                  color: t.text,
                  whiteSpace: "nowrap",
                  flexShrink: 0,
                }}
              >
                {m}
              </div>
            ),
          )}
        </div>

        {/* ingredients list */}
        <div style={{ padding: "14px 16px 0" }}>
          <div
            style={{
              background: "#fff",
              borderRadius: 18,
              border: `1px solid ${t.borderSoft}`,
              overflow: "hidden",
            }}
          >
            <div
              style={{
                padding: "14px 16px 8px",
                display: "flex",
                justifyContent: "space-between",
                alignItems: "center",
              }}
            >
              <div style={{ fontSize: 14, fontWeight: 800, color: t.text }}>
                식재료 ({CART_ITEMS.length}개)
              </div>
              <span style={{ fontSize: 11.5, color: t.textSoft }}>
                {checkedCount}개 선택
              </span>
            </div>
            {CART_ITEMS.map((it, i) => {
              const on = checked[i];
              return (
                <div
                  key={i}
                  className="tap"
                  onClick={() => toggle(i)}
                  style={{
                    display: "flex",
                    alignItems: "center",
                    gap: 12,
                    padding: "11px 16px",
                    borderTop: `1px solid ${t.borderSoft}`,
                  }}
                >
                  <div
                    style={{
                      width: 20,
                      height: 20,
                      borderRadius: 6,
                      border: `1.5px solid ${on ? t.primary : t.border}`,
                      background: on ? t.primary : "#fff",
                      display: "grid",
                      placeItems: "center",
                      flexShrink: 0,
                    }}
                  >
                    {on && (
                      <svg
                        width="12"
                        height="12"
                        viewBox="0 0 12 12"
                        fill="none"
                      >
                        <path
                          d="M2.5 6.5L5 9l4.5-5"
                          stroke="#fff"
                          strokeWidth="2"
                          strokeLinecap="round"
                          strokeLinejoin="round"
                        />
                      </svg>
                    )}
                  </div>
                  <VegPlaceholder name={it.name} size={36} t={t} />
                  <div style={{ flex: 1, minWidth: 0 }}>
                    <div
                      style={{
                        display: "flex",
                        alignItems: "center",
                        gap: 6,
                        flexWrap: "wrap",
                      }}
                    >
                      <span
                        style={{
                          fontSize: 13.5,
                          fontWeight: 700,
                          color: on ? t.text : t.textSoft,
                        }}
                      >
                        {it.name}
                      </span>
                      <span style={{ fontSize: 11, color: t.textSoft }}>
                        {it.q}
                      </span>
                      {it.tag && (
                        <span
                          style={{
                            fontSize: 10,
                            fontWeight: 700,
                            padding: "2px 6px",
                            borderRadius: 999,
                            color: it.tag.includes("⚠") ? t.hot : t.primary,
                            background: it.tag.includes("⚠")
                              ? t.hotBg
                              : t.primaryBg,
                          }}
                        >
                          {it.tag}
                        </span>
                      )}
                    </div>
                    <div
                      style={{
                        fontSize: 10.5,
                        color: t.textSoft,
                        marginTop: 2,
                      }}
                    >
                      {it.plat} 바로가기 ›
                    </div>
                  </div>
                  <div
                    style={{
                      fontSize: 13.5,
                      fontWeight: 800,
                      color: on ? t.text : t.textSoft,
                      fontFeatureSettings: '"tnum"',
                    }}
                  >
                    ₩{priceRange(it.price)}
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      </div>

      {/* Floating CTA — 선택한 항목만 찜하기 */}
      <div
        style={{
          position: "absolute",
          left: 0,
          right: 0,
          bottom: 0,
          padding: "20px 16px 27px",
          background: "#fff",
          borderTop: `1px solid ${t.borderSoft}`,
          zIndex: 90,
        }}
      >
        <button
          className="tap"
          disabled={checkedCount === 0}
          style={{
            width: "100%",
            height: 52,
            borderRadius: 14,
            border: "none",
            background: checkedCount === 0 ? t.border : t.primary,
            color: "#fff",
            fontSize: 15,
            fontWeight: 800,
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            gap: 8,
          }}
        >
          <svg width="18" height="18" viewBox="0 0 18 18" fill="none">
            <path
              d="M9 15s-6-3.5-6-8.2C3 4.6 4.7 3 6.7 3c1 0 1.9.5 2.3 1.2C9.5 3.5 10.4 3 11.3 3 13.3 3 15 4.6 15 6.8 15 11.5 9 15 9 15z"
              fill="#fff"
            />
          </svg>
          {checkedCount}개 식재료 찜하기
        </button>
      </div>
    </Phone>
  );
}

// ─────────────────────────────────────────────────────────────
// B — 챗형 (GPT 스타일 + 카드)
// ─────────────────────────────────────────────────────────────
export function ScreenAIChatB({ t }) {
  return (
    <Phone t={t}>
      <AppHeader
        t={t}
        title="AI 셰프"
        leftBack
        rightIcons={
          <Chip color={t.primary} bg={t.primaryBg}>
            ● 온라인
          </Chip>
        }
      />
      <div
        className="phone-scroll"
        style={{
          flex: 1,
          overflow: "auto",
          background: t.bgSoft,
          paddingBottom: 90,
        }}
      >
        {/* Bot greeting */}
        <Msg t={t} bot>
          <div
            style={{
              fontSize: 14,
              color: t.text,
              fontWeight: 600,
              marginBottom: 8,
            }}
          >
            안녕하세요 🌱
          </div>
          <div style={{ fontSize: 14, color: t.text, lineHeight: 1.55 }}>
            이번 주 장보기를 도와드릴게요. <b>어떤 식으로 시작</b>해 볼까요?
          </div>
          <div
            style={{
              display: "flex",
              flexDirection: "column",
              gap: 6,
              marginTop: 12,
            }}
          >
            {[
              "🛒 5일치 2인 가족, 가성비 위주로 짜줘",
              "🌱 지금 제철 재료로 짜줘",
              "🥘 냉장고에 있는 재료로 요리",
            ].map((q, i) => (
              <button
                key={i}
                className="tap"
                style={{
                  background: "#fff",
                  border: `1px solid ${t.borderSoft}`,
                  borderRadius: 12,
                  padding: "10px 12px",
                  textAlign: "left",
                  fontSize: 13,
                  fontWeight: 600,
                  color: t.text,
                }}
              >
                {q}
              </button>
            ))}
          </div>
        </Msg>

        {/* User msg */}
        <Msg t={t} user>
          5일치 2인 가족, 가성비 위주로 짜줘. 오이는 빼고
        </Msg>

        {/* Bot thinking */}
        <Msg t={t} bot>
          <div style={{ fontSize: 14, color: t.text, lineHeight: 1.55 }}>
            좋아요! <b style={{ color: t.primary }}>제철 무·배추</b>가 평년 대비
            −22%여서 활용하기 딱이에요. 아삭한 무로 일주일을 즐겨보세요!
          </div>
          {/* Mini cards */}
          <div
            style={{
              background: "#fff",
              borderRadius: 14,
              padding: 12,
              marginTop: 10,
              border: `1px solid ${t.borderSoft}`,
            }}
          >
            <div
              style={{
                fontSize: 11.5,
                fontWeight: 800,
                color: t.primary,
                letterSpacing: 0.4,
              }}
            >
              이번 주 메뉴 · 5일
            </div>
            <div
              style={{
                display: "flex",
                flexDirection: "column",
                gap: 8,
                marginTop: 10,
              }}
            >
              {[
                { day: "월", meal: "무생채 + 된장찌개", tag: "제철" },
                { day: "화", meal: "배추전", tag: "과잉↓" },
                { day: "수", meal: "제육볶음", tag: "" },
                { day: "목", meal: "비빔밥", tag: "" },
                { day: "금", meal: "시금치 무침 + 김치찌개", tag: "제철" },
              ].map((m, i) => (
                <div
                  key={i}
                  style={{ display: "flex", alignItems: "center", gap: 10 }}
                >
                  <div
                    style={{
                      width: 24,
                      height: 24,
                      borderRadius: 8,
                      background: t.primaryBg,
                      color: t.primaryDark,
                      fontWeight: 800,
                      fontSize: 11.5,
                      display: "grid",
                      placeItems: "center",
                    }}
                  >
                    {m.day}
                  </div>
                  <span
                    style={{
                      flex: 1,
                      fontSize: 13,
                      fontWeight: 600,
                      color: t.text,
                    }}
                  >
                    {m.meal}
                  </span>
                  {m.tag && (
                    <Chip color={t.primary} bg={t.primaryBg}>
                      {m.tag}
                    </Chip>
                  )}
                </div>
              ))}
            </div>
          </div>

          {/* CTA card */}
          <div
            className="tap"
            style={{
              background: t.text,
              borderRadius: 14,
              padding: 14,
              marginTop: 8,
              color: "#fff",
              display: "flex",
              alignItems: "center",
              gap: 10,
            }}
          >
            <div
              style={{
                width: 40,
                height: 40,
                borderRadius: 12,
                background: "rgba(255,255,255,0.15)",
                display: "grid",
                placeItems: "center",
                fontSize: 20,
              }}
            >
              🛒
            </div>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 13, fontWeight: 700 }}>
                찜하기 9개 · ₩{priceRange(38400)}
              </div>
              <div style={{ fontSize: 11, opacity: 0.7 }}>재료 보러 가기</div>
            </div>
            <svg width="14" height="14" viewBox="0 0 14 14">
              <path
                d="M5 3l4 4-4 4"
                stroke="#fff"
                strokeWidth="1.8"
                fill="none"
                strokeLinecap="round"
                strokeLinejoin="round"
              />
            </svg>
          </div>
        </Msg>

        {/* Suggestion chip — 다음 단계 제안 */}
        <div style={{ padding: "4px 16px 0", marginLeft: 40 }}>
          <div
            className="tap"
            style={{
              display: "inline-block",
              fontSize: 14,
              color: t.text,
              padding: "9px 0px",
            }}
          >
            무생채 레시피부터 시작해볼까요?!
          </div>
        </div>

        {/* User msg — 시작 동의 */}
        <Msg t={t} user>
          응. 시작해줘.
        </Msg>

        {/* Bot — 레시피 시작 + hero 이미지 */}
        <Msg t={t} bot>
          <div style={{ fontSize: 14, color: t.text, lineHeight: 1.55 }}>
            제철 무를 이용한 <b style={{ color: t.primary }}>무생채 레시피</b>{" "}
            시작해볼게요.
            <br />
            저만 믿고 따라오세요~!
          </div>
          <div
            style={{
              marginTop: 10,
              borderRadius: 14,
              overflow: "hidden",
              position: "relative",
              aspectRatio: "16/11",
              backgroundImage: `url(${DISH_IMG.무생채황금레시피})`,
              backgroundSize: "cover",
              backgroundPosition: "center",
            }}
          >
            <div
              style={{
                position: "absolute",
                left: 14,
                bottom: 14,
                color: "#fff",
                fontSize: 18,
                fontWeight: 800,
                lineHeight: 1.25,
                letterSpacing: -0.4,
                textShadow: "0 2px 8px rgba(0,0,0,0.4)",
              }}
            >
              5분만에 무생채
              <br />
              황금레시피
            </div>
          </div>
          <div
            style={{
              border: `1px solid ${t.borderSoft}`,
              padding: "10px 0px",
              fontSize: 14,
              color: t.text,
              lineHeight: 1.5,
            }}
          >
            민지님은 매운걸 좋아하시는데,
            <br />더 매운 버전을 원하신다면 말씀해주세요!
          </div>
        </Msg>

        {/* User msg — 진행 */}
        <Msg t={t} user>
          좋아. 더 매운 버전으로 시작해줘.
        </Msg>

        {/* Bot — 조리 스텝 */}
        <Msg t={t} bot>
          <div style={{ fontSize: 14, color: t.text, lineHeight: 1.55 }}>
            세번째로, 무에 양념을 버무릴거에요.
          </div>
          <div
            style={{
              marginTop: 10,
              borderRadius: 14,
              overflow: "hidden",
              position: "relative",
              aspectRatio: "16/11",
              backgroundImage: `url(${DISH_IMG.무양념무침})`,
              backgroundSize: "cover",
              backgroundPosition: "center",
            }}
          >
            <div
              style={{
                position: "absolute",
                top: 10,
                right: 10,
                background: "rgba(0,0,0,0.55)",
                color: "#fff",
                fontSize: 12,
                fontWeight: 700,
                padding: "4px 10px",
                borderRadius: 999,
                display: "flex",
                alignItems: "center",
                gap: 4,
                fontFeatureSettings: '"tnum"',
              }}
            >
              <svg width="11" height="11" viewBox="0 0 11 11" fill="none">
                <circle
                  cx="5.5"
                  cy="5.5"
                  r="4.5"
                  stroke="#fff"
                  strokeWidth="1.2"
                />
                <path
                  d="M5.5 3v2.5l1.5 1"
                  stroke="#fff"
                  strokeWidth="1.2"
                  strokeLinecap="round"
                />
              </svg>
              2:00
            </div>
          </div>
          <div
            style={{
              marginTop: 8,
              fontSize: 13,
              color: t.text,
              lineHeight: 1.55,
            }}
          >
            볼에 무채를 넣고 고춧가루·다진마늘·설탕·식초·소금을
            <br />
            모두 넣어 손으로 골고루 무쳐주세요.
            <br />
            너무 세게 누르지 않는 것이 포인트!
          </div>
        </Msg>

        <div style={{ height: 4 }} />
      </div>

      {/* Input bar */}
      <div
        style={{
          position: "absolute",
          left: 0,
          right: 0,
          bottom: 0,
          padding: "10px 14px 30px",
          background: "#fff",
          borderTop: `1px solid ${t.borderSoft}`,
          display: "flex",
          alignItems: "center",
          gap: 8,
        }}
      >
        <div
          style={{
            flex: 1,
            minHeight: 44,
            borderRadius: 22,
            background: t.bgSoft,
            display: "flex",
            alignItems: "center",
            padding: "0 14px 0 16px",
            gap: 8,
          }}
        >
          <span style={{ flex: 1, fontSize: 13.5, color: t.textSoft }} />
          <span style={{ fontSize: 18 }}>🎙️</span>
        </div>
        <div
          className="tap"
          style={{
            width: 44,
            height: 44,
            borderRadius: 22,
            background: t.primary,
            display: "grid",
            placeItems: "center",
          }}
        >
          <svg width="18" height="18" viewBox="0 0 18 18" fill="none">
            <path
              d="M9 14V4M9 4l-5 5M9 4l5 5"
              stroke="#fff"
              strokeWidth="2.2"
              strokeLinecap="round"
              strokeLinejoin="round"
            />
          </svg>
        </div>
      </div>
    </Phone>
  );
}

function Msg({ children, bot, user, t }) {
  if (user) {
    return (
      <div
        style={{
          padding: "8px 16px 4px",
          display: "flex",
          justifyContent: "flex-end",
        }}
      >
        <div
          style={{
            maxWidth: "78%",
            background: t.primary,
            color: "#fff",
            padding: "10px 14px",
            borderRadius: "18px 18px 4px 18px",
            fontSize: 14,
            fontWeight: 500,
            lineHeight: 1.4,
          }}
        >
          {children}
        </div>
      </div>
    );
  }
  return (
    <div
      style={{
        padding: "12px 16px 4px",
        display: "flex",
        gap: 8,
        alignItems: "flex-start",
      }}
    >
      <div
        style={{
          width: 32,
          height: 32,
          borderRadius: 16,
          background: t.primary,
          color: "#fff",
          fontSize: 16,
          display: "grid",
          placeItems: "center",
          flexShrink: 0,
          marginTop: 2,
        }}
      >
        🧑‍🍳
      </div>
      <div style={{ flex: 1, maxWidth: "85%" }}>{children}</div>
    </div>
  );
}

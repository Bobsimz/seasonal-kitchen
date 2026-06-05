// Home screens — 2 variations
// A: 정보 밀도형 (제철.상회 스타일을 그린 톤으로, 가격/구매 적기 강조)
// B: 비주얼 트렌디형 (당근/배민 톤, 카드 + 릴스 우선)

import React from "react";
import { Phone, BottomTabBar, VegPlaceholder, Chip, priceRange } from "./phone";
import { DISH_IMG, vegImg } from "./mock-images";

// 봄동 hero 이미지
const HERO_IMG = "/food/bomdong_main.jpg";

// ─────────────────────────────────────────────────────────────
// Common atoms used on home
// ─────────────────────────────────────────────────────────────
export function PriceBadge({ trend, value, t }) {
  // trend: 'down' | 'up' | 'best'
  if (trend === "down")
    return (
      <span
        style={{
          display: "inline-flex",
          alignItems: "center",
          gap: 3,
          color: t.primary,
          fontWeight: 700,
          fontSize: 12,
        }}
      >
        <svg width="9" height="9" viewBox="0 0 9 9">
          <path d="M4.5 8L1 3h7L4.5 8z" fill="currentColor" />
        </svg>
        {value}
      </span>
    );
  if (trend === "up")
    return (
      <span
        style={{
          display: "inline-flex",
          alignItems: "center",
          gap: 3,
          color: t.hot,
          fontWeight: 700,
          fontSize: 12,
        }}
      >
        <svg width="9" height="9" viewBox="0 0 9 9">
          <path d="M4.5 1L8 6H1L4.5 1z" fill="currentColor" />
        </svg>
        {value}
      </span>
    );
  return (
    <span style={{ color: t.textSoft, fontWeight: 600, fontSize: 12 }}>
      {value}
    </span>
  );
}

// ─────────────────────────────────────────────────────────────
// HOME A — 정보 밀도형
// ─────────────────────────────────────────────────────────────
export function ScreenHomeA({ t }) {
  return (
    <Phone t={t} tabBar={<BottomTabBar active="home" t={t} />}>
      <div
        className="phone-scroll"
        style={{ flex: 1, overflow: "auto", background: t.bg }}
      >
        {/* Header */}
        <div style={{ paddingTop: 52, padding: "52px 20px 12px" }}>
          <div
            style={{
              display: "flex",
              alignItems: "center",
              justifyContent: "space-between",
              marginBottom: 14,
            }}
          >
            <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
              <div
                style={{
                  width: 28,
                  height: 28,
                  borderRadius: 8,
                  background: t.primary,
                  display: "grid",
                  placeItems: "center",
                  color: "#fff",
                  fontWeight: 800,
                  fontSize: 14,
                }}
              >
                제
              </div>
              <div
                style={{
                  fontSize: 19,
                  fontWeight: 800,
                  color: t.text,
                  letterSpacing: -0.5,
                }}
              >
                제철식탁
              </div>
            </div>
            <div style={{ display: "flex", gap: 8 }}>
              <div
                className="tap"
                style={{
                  width: 36,
                  height: 36,
                  display: "grid",
                  placeItems: "center",
                }}
              >
                <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                  <path
                    d="M10 3a6 6 0 016 6c0 5-6 9-6 9s-6-4-6-9a6 6 0 016-6z"
                    stroke={t.textMid}
                    strokeWidth="1.5"
                  />
                </svg>
              </div>
              <div
                className="tap"
                style={{
                  position: "relative",
                  width: 36,
                  height: 36,
                  display: "grid",
                  placeItems: "center",
                }}
              >
                <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                  <path
                    d="M4 8a6 6 0 0112 0v3l2 3H2l2-3V8z"
                    stroke={t.textMid}
                    strokeWidth="1.5"
                    strokeLinejoin="round"
                  />
                  <path
                    d="M8 17a2 2 0 004 0"
                    stroke={t.textMid}
                    strokeWidth="1.5"
                  />
                </svg>
                <div
                  style={{
                    position: "absolute",
                    top: 6,
                    right: 6,
                    width: 7,
                    height: 7,
                    borderRadius: 4,
                    background: t.hot,
                    border: "1.5px solid #fff",
                  }}
                />
              </div>
            </div>
          </div>

          {/* Title */}
          <div
            style={{
              fontSize: 12,
              fontWeight: 700,
              color: t.primary,
              letterSpacing: 0.4,
              marginBottom: 6,
            }}
          >
            11월 둘째 주 · 입동
          </div>
          <div
            style={{
              fontSize: 25,
              fontWeight: 800,
              color: t.text,
              letterSpacing: -0.9,
              lineHeight: 1.25,
            }}
          >
            지금이 가장 알뜰한
            <br />
            <span
              style={{
                background: `linear-gradient(180deg, transparent 60%, ${t.primarySoft} 60%)`,
                padding: "0 2px",
              }}
            >
              제철 식재료
            </span>{" "}
            14가지
          </div>

          {/* Search */}
          <div
            style={{
              marginTop: 16,
              height: 48,
              borderRadius: 14,
              background: "#fff",
              border: `1.5px solid ${t.borderSoft}`,
              display: "flex",
              alignItems: "center",
              padding: "0 14px",
              gap: 10,
            }}
          >
            <svg width="18" height="18" viewBox="0 0 18 18" fill="none">
              <circle
                cx="8"
                cy="8"
                r="5.5"
                stroke={t.textSoft}
                strokeWidth="1.6"
              />
              <path
                d="M12 12l3 3"
                stroke={t.textSoft}
                strokeWidth="1.6"
                strokeLinecap="round"
              />
            </svg>
            <span style={{ flex: 1, fontSize: 14, color: t.textSoft }}>
              무, 배추, 비빔밥 …
            </span>
            <div
              style={{
                fontSize: 11,
                fontWeight: 700,
                color: t.primary,
                background: t.primaryBg,
                padding: "4px 8px",
                borderRadius: 8,
              }}
            >
              AI 검색
            </div>
          </div>
        </div>

        {/* AI 추천 큰 카드 */}
        <div style={{ padding: "4px 20px 0" }}>
          <div
            className="tap"
            style={{
              borderRadius: 20,
              padding: 18,
              background: `linear-gradient(135deg, ${t.primary} 0%, ${t.primaryDark} 100%)`,
              color: "#fff",
              position: "relative",
              overflow: "hidden",
            }}
          >
            <div
              style={{
                position: "absolute",
                right: -20,
                top: -20,
                width: 130,
                height: 130,
                borderRadius: 80,
                background: "rgba(255,255,255,0.08)",
              }}
            />
            <div
              style={{
                position: "absolute",
                right: 20,
                top: 20,
                fontSize: 36,
                lineHeight: 1,
              }}
            >
              🧑‍🍳
            </div>
            <div
              style={{
                fontSize: 11.5,
                fontWeight: 700,
                opacity: 0.85,
                letterSpacing: 0.3,
              }}
            >
              AI 장보기 추천
            </div>
            <div
              style={{
                fontSize: 18,
                fontWeight: 800,
                marginTop: 6,
                letterSpacing: -0.5,
                lineHeight: 1.3,
              }}
            >
              우리 집 조건에 맞는
              <br />
              이번 주 장보기 짜드릴게요
            </div>
            <div
              style={{
                marginTop: 14,
                display: "inline-flex",
                alignItems: "center",
                gap: 6,
                padding: "6px 12px",
                borderRadius: 999,
                background: "rgba(255,255,255,0.2)",
                fontSize: 12,
                fontWeight: 700,
              }}
            >
              3가지 질문으로 시작 →
            </div>
          </div>
        </div>

        {/* 오늘 추천 레시피 (스와이프) */}
        <div style={{ paddingTop: 22 }}>
          <div
            style={{
              padding: "0 20px",
              display: "flex",
              alignItems: "baseline",
              justifyContent: "space-between",
              marginBottom: 10,
            }}
          >
            <div
              style={{
                fontSize: 16,
                fontWeight: 800,
                color: t.text,
                letterSpacing: -0.4,
              }}
            >
              오늘 뭐 먹지? <span style={{ color: t.primary }}>레시피</span>
            </div>
            <span style={{ fontSize: 12, color: t.textSoft, fontWeight: 600 }}>
              1 / 5
            </span>
          </div>
          <div
            style={{
              display: "flex",
              gap: 12,
              overflowX: "auto",
              padding: "0 20px 4px",
            }}
            className="phone-scroll"
          >
            {[
              {
                name: "무생채",
                tag: "입동·제철",
                time: "15분",
                diff: "쉬움",
                img: DISH_IMG.무생채,
              },
              {
                name: "배추전",
                tag: "구매 적기",
                time: "20분",
                diff: "쉬움",
                img: DISH_IMG.배추전,
              },
              {
                name: "시금치 페스토",
                tag: "제철",
                time: "25분",
                diff: "보통",
                img: DISH_IMG.시금치페스토,
              },
            ].map((r, i) => (
              <div
                key={i}
                className="tap"
                style={{
                  width: 220,
                  flexShrink: 0,
                  borderRadius: 18,
                  background: "#fff",
                  border: `1px solid ${t.borderSoft}`,
                  overflow: "hidden",
                }}
              >
                <div
                  style={{
                    height: 124,
                    position: "relative",
                    backgroundImage: `url(${r.img})`,
                    backgroundSize: "cover",
                    backgroundPosition: "center",
                  }}
                >
                  <div
                    style={{
                      position: "absolute",
                      top: 10,
                      left: 10,
                      fontSize: 10.5,
                      fontWeight: 700,
                      color: t.primary,
                      background: "#fff",
                      padding: "3px 8px",
                      borderRadius: 999,
                    }}
                  >
                    {r.tag}
                  </div>
                </div>
                <div style={{ padding: 12 }}>
                  <div
                    style={{
                      fontSize: 14.5,
                      fontWeight: 700,
                      color: t.text,
                      letterSpacing: -0.3,
                    }}
                  >
                    {r.name}
                  </div>
                  <div
                    style={{ fontSize: 12, color: t.textSoft, marginTop: 4 }}
                  >
                    {r.time} · {r.diff} · 좋아요 1.2k
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* 가격 동향 — 표 */}
        <div style={{ padding: "22px 20px 0" }}>
          <div
            style={{
              display: "flex",
              alignItems: "baseline",
              justifyContent: "space-between",
              marginBottom: 10,
            }}
          >
            <div
              style={{
                fontSize: 16,
                fontWeight: 800,
                color: t.text,
                letterSpacing: -0.4,
              }}
            >
              이번 주 가격 동향
            </div>
            <span style={{ fontSize: 11, color: t.textSoft }}>
              KAMIS 시세 · 오늘 기준
            </span>
          </div>

          <div
            style={{
              borderRadius: 18,
              background: "#fff",
              border: `1px solid ${t.borderSoft}`,
              overflow: "hidden",
            }}
          >
            {/* tab strip */}
            <div style={{ display: "flex", padding: "12px 6px 8px", gap: 4 }}>
              {["전체", "🔥 하락", "⬆ 상승", "🌱 신선"].map((tab, i) => (
                <div
                  key={i}
                  style={{
                    padding: "6px 12px",
                    borderRadius: 999,
                    fontSize: 12,
                    fontWeight: 700,
                    background: i === 1 ? t.primaryBg : "transparent",
                    color: i === 1 ? t.primaryDark : t.textMid,
                  }}
                >
                  {tab}
                </div>
              ))}
            </div>

            {[
              {
                name: "무",
                sub: "단",
                price: "1,200",
                trend: "down",
                delta: "-15%",
                tag: "구매 적기",
                tagColor: t.primary,
              },
              {
                name: "배추",
                sub: "포기",
                price: "3,200",
                trend: "down",
                delta: "-22%",
                tag: "과잉",
                tagColor: t.primary,
              },
              {
                name: "시금치",
                sub: "100g",
                price: "1,890",
                trend: "down",
                delta: "-8%",
                tag: "제철",
                tagColor: t.primary,
              },
              {
                name: "감귤",
                sub: "1kg",
                price: "8,900",
                trend: "up",
                delta: "+12%",
                tag: "인기↑",
                tagColor: t.hot,
              },
              {
                name: "대파",
                sub: "1단",
                price: "3,500",
                trend: "up",
                delta: "+18%",
                tag: "주의",
                tagColor: t.warning,
              },
            ].map((row, i, arr) => (
              <div
                key={i}
                className="tap"
                style={{
                  display: "flex",
                  alignItems: "center",
                  gap: 12,
                  padding: "12px 16px",
                  borderTop: i === 0 ? `1px solid ${t.borderSoft}` : "none",
                  borderBottom:
                    i < arr.length - 1 ? `1px solid ${t.borderSoft}` : "none",
                }}
              >
                <VegPlaceholder name={row.name} size={40} t={t} />
                <div style={{ flex: 1, minWidth: 0 }}>
                  <div
                    style={{ display: "flex", alignItems: "center", gap: 6 }}
                  >
                    <span
                      style={{ fontSize: 14.5, fontWeight: 700, color: t.text }}
                    >
                      {row.name}
                    </span>
                    <Chip
                      color={row.tagColor}
                      bg={
                        row.tagColor === t.primary
                          ? t.primaryBg
                          : row.tagColor === t.hot
                            ? t.hotBg
                            : t.warningBg
                      }
                    >
                      {row.tag}
                    </Chip>
                  </div>
                  <div
                    style={{ fontSize: 11.5, color: t.textSoft, marginTop: 3 }}
                  >
                    {row.sub} 평균 · 전국
                  </div>
                </div>
                <div style={{ textAlign: "right" }}>
                  <div
                    style={{
                      fontSize: 14.5,
                      fontWeight: 800,
                      color: t.text,
                      fontFeatureSettings: '"tnum"',
                    }}
                  >
                    ₩{priceRange(row.price)}
                  </div>
                  <PriceBadge trend={row.trend} value={row.delta} t={t} />
                </div>
              </div>
            ))}
            <div
              className="tap"
              style={{
                padding: 14,
                textAlign: "center",
                fontSize: 13,
                fontWeight: 700,
                color: t.primary,
                borderTop: `1px solid ${t.borderSoft}`,
              }}
            >
              전체 식재료 14개 보기 →
            </div>
          </div>
        </div>

        {/* 트렌드 섹션 */}
        <div style={{ padding: "22px 20px 0" }}>
          <div
            style={{
              fontSize: 16,
              fontWeight: 800,
              color: t.text,
              letterSpacing: -0.4,
              marginBottom: 10,
            }}
          >
            이번 주 SNS 핫템
          </div>
          <div
            style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 10 }}
          >
            {[
              { name: "대파", sub: "#대파라면", views: "124만" },
              { name: "깐마늘", sub: "#마늘덕후", views: "89만" },
            ].map((c, i) => (
              <div
                key={i}
                className="tap"
                style={{
                  borderRadius: 16,
                  padding: 12,
                  background: "#fff",
                  border: `1px solid ${t.borderSoft}`,
                  display: "flex",
                  alignItems: "center",
                  gap: 10,
                }}
              >
                <VegPlaceholder name={c.name} size={48} t={t} />
                <div style={{ minWidth: 0 }}>
                  <div
                    style={{ fontSize: 13.5, fontWeight: 700, color: t.text }}
                  >
                    {c.name}
                  </div>
                  <div
                    style={{ fontSize: 11, color: t.textSoft, marginTop: 1 }}
                  >
                    {c.sub}
                  </div>
                  <div
                    style={{
                      fontSize: 10.5,
                      color: t.hot,
                      fontWeight: 700,
                      marginTop: 3,
                    }}
                  >
                    조회 {c.views}
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>

        <div style={{ height: 24 }} />
      </div>
    </Phone>
  );
}

// ─────────────────────────────────────────────────────────────
// HOME B — 비주얼 트렌디형 (메인 채택안)
// ─────────────────────────────────────────────────────────────
export function ScreenHomeB({ t }) {
  return (
    <Phone t={t} tabBar={<BottomTabBar active="home" t={t} />} bg={t.bg}>
      <div
        className="phone-scroll"
        style={{ flex: 1, overflow: "auto", position: "relative" }}
      >
        {/* ============ HERO — 봄동 풀블리드 ============ */}
        <div
          style={{
            position: "relative",
            paddingTop: 38,
            paddingBottom: 14,
            overflow: "hidden",
          }}
        >
          {/* 봄동 이미지 */}
          <div
            style={{
              position: "absolute",
              inset: 0,
              backgroundImage: `url(${HERO_IMG})`,
              backgroundSize: "cover",
              backgroundPosition: "center 30%",
            }}
          />
          {/* 다크 오버레이 — 위에서 아래로 짙어짐 */}
          <div
            style={{
              position: "absolute",
              inset: 0,
              background:
                "linear-gradient(180deg, rgba(15,26,20,0.35) 0%, rgba(15,26,20,0.45) 45%, rgba(15,26,20,0.78) 100%)",
            }}
          />

          {/* ── Top bar ── */}
          <div
            style={{
              position: "relative",
              padding: "0 20px",
              display: "flex",
              alignItems: "center",
              justifyContent: "space-between",
            }}
          >
            <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
              <div
                style={{
                  fontSize: 19,
                  fontWeight: 800,
                  color: "#fff",
                  letterSpacing: -0.5,
                }}
              ></div>
            </div>
            <div style={{ display: "flex", gap: 8 }}>
              <div
                className="tap"
                style={{
                  width: 38,
                  height: 38,
                  borderRadius: 19,
                  background: "rgba(255,255,255,0.18)",
                  backdropFilter: "blur(10px)",
                  border: "1px solid rgba(255,255,255,0.25)",
                  display: "grid",
                  placeItems: "center",
                }}
              >
                <svg width="18" height="18" viewBox="0 0 18 18" fill="none">
                  <circle
                    cx="8"
                    cy="8"
                    r="5.5"
                    stroke="#fff"
                    strokeWidth="1.6"
                  />
                  <path
                    d="M12 12l3 3"
                    stroke="#fff"
                    strokeWidth="1.6"
                    strokeLinecap="round"
                  />
                </svg>
              </div>
              <div
                className="tap"
                style={{
                  position: "relative",
                  width: 38,
                  height: 38,
                  borderRadius: 19,
                  background: "rgba(255,255,255,0.18)",
                  backdropFilter: "blur(10px)",
                  border: "1px solid rgba(255,255,255,0.25)",
                  display: "grid",
                  placeItems: "center",
                }}
              >
                <svg width="18" height="18" viewBox="0 0 18 18" fill="none">
                  <path
                    d="M4 7a5 5 0 0110 0v2l2 3H2l2-3V7z"
                    stroke="#fff"
                    strokeWidth="1.5"
                    strokeLinejoin="round"
                  />
                </svg>
                <div
                  style={{
                    position: "absolute",
                    top: 8,
                    right: 8,
                    width: 7,
                    height: 7,
                    borderRadius: 4,
                    background: t.hot,
                    border: "1.5px solid #fff",
                  }}
                />
              </div>
            </div>
          </div>

          {/* ── 좌측 카피 (1열) ── */}
          <div style={{ position: "relative", padding: "0 22px" }}>
            {/* Season — 미니멀 글로우 도트 + 텍스트 */}
            <div
              style={{
                display: "inline-flex",
                alignItems: "center",
                gap: 7,
                fontSize: 11.5,
                fontWeight: 900,
                color: "rgba(255,255,255,0.92)",
                letterSpacing: 0.4,
                textShadow: "0 1px 6px rgba(0,0,0,0.55)",
              }}
            >
              <span
                style={{
                  width: 5,
                  height: 5,
                  borderRadius: 3,
                  background: "#9DE8B5",
                  boxShadow: "0 0 10px rgba(157,232,181,0.9)",
                }}
              />
              2월 셋째 주
            </div>

            {/* Title */}
            <div style={{ marginTop: 10 }}>
              <div
                style={{
                  fontSize: 28,
                  fontWeight: 800,
                  color: "#fff",
                  letterSpacing: -1.2,
                  lineHeight: 1,
                  marginBottom: 4,
                  textShadow: "0 2px 18px rgba(0,0,0,0.35)",
                }}
              >
                지금이
              </div>
              <div
                style={{
                  fontSize: 42,
                  fontWeight: 800,
                  letterSpacing: -1.8,
                  lineHeight: 1,
                  color: "#9DE8B5",
                  fontStyle: "italic",
                  display: "inline-block",
                  position: "relative",
                  textShadow: "0 2px 22px rgba(0,0,0,0.4)",
                }}
              >
                딱!
                <svg
                  style={{
                    position: "absolute",
                    left: 0,
                    right: 0,
                    bottom: -6,
                    width: "100%",
                  }}
                  height="8"
                  viewBox="0 0 80 10"
                  preserveAspectRatio="none"
                >
                  <path
                    d="M2 6 Q 40 -1, 78 5"
                    stroke="#9DE8B5"
                    strokeWidth="3"
                    fill="none"
                    strokeLinecap="round"
                    opacity="0.85"
                  />
                </svg>
              </div>
              <div
                style={{
                  fontSize: 18,
                  fontWeight: 800,
                  color: "#fff",
                  letterSpacing: -0.6,
                  lineHeight: 1.15,
                  marginTop: 10,
                  marginBottom: 10,
                  textShadow: "0 2px 12px rgba(0,0,0,0.4)",
                }}
              >
                <span
                  style={{
                    background:
                      "linear-gradient(180deg, transparent 55%, rgba(157,232,181,0.55) 55%)",
                    padding: "0 4px",
                  }}
                >
                  봄동
                </span>
                의 계절
              </div>
            </div>
          </div>

          {/* 평년 대비 ▼22% — 히어로 우측 하단 */}
          <div
            style={{
              position: "absolute",
              bottom: 14,
              right: 22,
              display: "inline-flex",
              alignItems: "baseline",
              gap: 8,
              fontSize: 11.5,
              fontWeight: 700,
              color: "rgba(255,255,255,0.72)",
              letterSpacing: 0.4,
              textShadow: "0 1px 6px rgba(0,0,0,0.5)",
            }}
          >
            평년 대비
            <span
              style={{
                color: "#9DE8B5",
                fontWeight: 800,
                fontSize: 13,
                letterSpacing: -0.2,
                fontFeatureSettings: '"tnum"',
              }}
            >
              ▼22%
            </span>
          </div>

          {/* ── 페이지 인디케이터 (히어로 최하단 중앙) ── */}
          <div
            style={{
              position: "absolute",
              left: 0,
              right: 0,
              bottom: 10,
              display: "flex",
              justifyContent: "center",
              alignItems: "center",
              gap: 5,
            }}
          >
            {[0, 1, 2, 3, 4].map((i) => {
              const active = i === 0;
              return (
                <span
                  key={i}
                  style={{
                    width: active ? 14 : 5,
                    height: 5,
                    borderRadius: 3,
                    background: active ? "#fff" : "rgba(255,255,255,0.45)",
                    transition: "all 0.2s ease",
                  }}
                />
              );
            })}
          </div>
        </div>

        {/* ============ 지금이 제철 (슬라이드 카드) ============ */}
        <div style={{ padding: "18px 0 0" }}>
          <div
            style={{
              padding: "0 20px",
              display: "flex",
              alignItems: "baseline",
              justifyContent: "space-between",
              marginBottom: 12,
            }}
          >
            <div
              style={{
                fontSize: 18,
                fontWeight: 800,
                width: 150,
                color: t.text,
                letterSpacing: -0.5,
              }}
            >
              지금이 <span style={{ color: t.primary }}>제철</span>
            </div>
            <span style={{ fontSize: 12, color: t.primary, fontWeight: 700 }}>
              14개 모두 →
            </span>
          </div>
          <div
            style={{
              display: "flex",
              gap: 12,
              overflowX: "auto",
              padding: "0 20px 6px",
            }}
            className="phone-scroll"
          >
            {[
              {
                name: "봄동",
                price: "2,400",
                range: "2,100~2,800",
                unit: "단",
                delta: "-22%",
                tag: "제철 적기",
                color: "#c9e0a8",
              },
              {
                name: "배추",
                price: "3,200",
                range: "2,800~3,600",
                unit: "포기",
                delta: "-22%",
                tag: "과잉 공급",
                color: "#dfe7c4",
              },
              {
                name: "감귤",
                price: "8,900",
                range: "7,800~9,800",
                unit: "1kg",
                delta: "+12%",
                tag: "인기 ↑",
                color: "#ffd9a8",
              },
              {
                name: "시금치",
                price: "1,890",
                range: "1,600~2,200",
                unit: "100g",
                delta: "-8%",
                tag: "신선",
                color: "#c9e0a8",
              },
              {
                name: "고구마",
                price: "6,200",
                range: "5,500~7,000",
                unit: "1kg",
                delta: "-5%",
                tag: "제철",
                color: "#e5b88a",
              },
              {
                name: "단호박",
                price: "4,400",
                range: "3,900~4,900",
                unit: "개",
                delta: "-11%",
                tag: "제철",
                color: "#f0c896",
              },
            ].map((c, i) => {
              const dn = c.delta.startsWith("-");
              return (
                <div
                  key={i}
                  className="tap"
                  style={{
                    width: 160,
                    flexShrink: 0,
                    borderRadius: 18,
                    background: "#fff",
                    border: `1px solid ${t.borderSoft}`,
                    overflow: "hidden",
                    boxShadow: "0 4px 14px rgba(20,40,30,0.06)",
                  }}
                >
                  {/* Photo */}
                  <div
                    style={{
                      aspectRatio: "1",
                      position: "relative",
                      overflow: "hidden",
                      backgroundImage: vegImg(c.name)
                        ? `url(${vegImg(c.name)})`
                        : `radial-gradient(circle at 35% 30%, #fff 0%, ${c.color} 50%, ${darken(c.color, 0.2)} 100%)`,
                      backgroundSize: "cover",
                      backgroundPosition: "center",
                    }}
                  >
                    <div
                      style={{
                        position: "absolute",
                        top: 8,
                        left: 8,
                        fontSize: 9.5,
                        fontWeight: 800,
                        color: t.primary,
                        background: "#fff",
                        padding: "3px 8px",
                        borderRadius: 999,
                        boxShadow: "0 1px 4px rgba(0,0,0,0.08)",
                      }}
                    >
                      {c.tag}
                    </div>
                    <div
                      className="tap"
                      style={{
                        position: "absolute",
                        top: 8,
                        right: 8,
                        width: 26,
                        height: 26,
                        borderRadius: 13,
                        background: "rgba(255,255,255,0.95)",
                        display: "grid",
                        placeItems: "center",
                      }}
                    >
                      <svg width="13" height="13" viewBox="0 0 14 14">
                        <path
                          d="M7 12s-5-3-5-7a3 3 0 015-2 3 3 0 015 2c0 4-5 7-5 7z"
                          stroke={t.textSoft}
                          strokeWidth="1.4"
                          fill="none"
                        />
                      </svg>
                    </div>
                  </div>
                  <div style={{ padding: "10px 12px 12px" }}>
                    <div
                      style={{ fontSize: 14, fontWeight: 800, color: t.text }}
                    >
                      {c.name}
                    </div>
                    <div
                      style={{
                        fontSize: 12.5,
                        fontWeight: 700,
                        color: t.text,
                        fontFeatureSettings: '"tnum"',
                        marginTop: 2,
                        whiteSpace: "nowrap",
                      }}
                    >
                      ₩{c.range}{" "}
                      <span
                        style={{
                          fontSize: 10,
                          color: t.textSoft,
                          fontWeight: 500,
                        }}
                      >
                        /{c.unit}
                      </span>
                    </div>
                    <div
                      style={{
                        display: "flex",
                        justifyContent: "flex-end",
                        marginTop: 6,
                      }}
                    >
                      <PriceBadge
                        trend={dn ? "down" : "up"}
                        value={c.delta}
                        t={t}
                      />
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        </div>

        {/* ============ 지금 핫한 레시피 ============ */}
        <div style={{ padding: "28px 0 0" }}>
          <div
            style={{
              padding: "0 20px",
              display: "flex",
              alignItems: "baseline",
              justifyContent: "space-between",
              marginBottom: 12,
            }}
          >
            <div
              style={{
                fontSize: 18,
                fontWeight: 800,
                color: t.text,
                letterSpacing: -0.5,
                width: 200,
              }}
            >
              지금 핫한 레시피
            </div>
            <span style={{ fontSize: 12, color: t.primary, fontWeight: 700 }}>
              모두 보기 →
            </span>
          </div>
          <div
            style={{
              display: "flex",
              gap: 10,
              overflowX: "auto",
              padding: "0 20px 4px",
            }}
            className="phone-scroll"
          >
            {[
              {
                name: "봄동 비빔밥 1분",
                views: "124만",
                likes: "8.4만",
                user: "쿠킹맘",
                rank: 1,
                badge: "HOT",
                badgeColor: t.hot,
                img: DISH_IMG.봄동비빔밥히어로,
              },
              {
                name: "배추전 황금레시피",
                views: "89만",
                likes: "5.1만",
                user: "안성재",
                rank: 2,
                badge: "트렌드",
                badgeColor: t.warning,
                img: DISH_IMG.배추전,
              },
              {
                name: "깍두기 모음",
                views: "62만",
                likes: "3.8만",
                user: "백종원",
                rank: 3,
                badge: "인기",
                badgeColor: t.info,
                img: DISH_IMG.깍두기,
              },
              {
                name: "시금치 페스토",
                views: "41만",
                likes: "2.2만",
                user: "에밀리",
                rank: 4,
                badge: "신상",
                badgeColor: t.primary,
                img: DISH_IMG.시금치페스토,
              },
            ].map((r, i) => (
              <div
                key={i}
                className="tap"
                style={{
                  width: 156,
                  flexShrink: 0,
                  borderRadius: 18,
                  position: "relative",
                  overflow: "hidden",
                  aspectRatio: "9/14",
                  background: "#222",
                }}
              >
                <div
                  style={{
                    position: "absolute",
                    inset: 0,
                    backgroundImage: `url(${r.img})`,
                    backgroundSize: "cover",
                    backgroundPosition: "center",
                  }}
                />
                <div
                  style={{
                    position: "absolute",
                    inset: 0,
                    background:
                      "linear-gradient(180deg, rgba(0,0,0,0.05) 0%, rgba(0,0,0,0.55) 100%)",
                  }}
                />
                {/* HOT / 트렌드 / 인기 badge */}
                <div
                  style={{
                    position: "absolute",
                    top: 10,
                    left: 10,
                    display: "inline-flex",
                    alignItems: "center",
                    gap: 3,
                    padding: "3px 8px 3px 6px",
                    borderRadius: 6,
                    background: r.badgeColor,
                    color: "#fff",
                    fontWeight: 800,
                    fontSize: 10,
                    letterSpacing: 0.3,
                    boxShadow: `0 2px 6px ${r.badgeColor}66`,
                  }}
                >
                  <span style={{ fontSize: 10, fontWeight: 800 }}>
                    #{r.rank}
                  </span>
                  <span
                    style={{
                      width: 1,
                      height: 8,
                      background: "rgba(255,255,255,0.5)",
                    }}
                  />
                  {r.badge}
                </div>
                <div
                  style={{
                    position: "absolute",
                    top: 10,
                    right: 10,
                    width: 26,
                    height: 26,
                    borderRadius: 13,
                    background: "rgba(0,0,0,0.4)",
                    backdropFilter: "blur(8px)",
                    display: "grid",
                    placeItems: "center",
                  }}
                >
                  <svg width="9" height="9" viewBox="0 0 10 10">
                    <path d="M2 1l7 4-7 4V1z" fill="#fff" />
                  </svg>
                </div>
                <div
                  style={{
                    position: "absolute",
                    left: 0,
                    right: 0,
                    bottom: 0,
                    padding: 12,
                    background:
                      "linear-gradient(180deg, transparent 0%, rgba(0,0,0,0.85) 100%)",
                    color: "#fff",
                  }}
                >
                  <div
                    style={{
                      fontSize: 13,
                      fontWeight: 800,
                      letterSpacing: -0.3,
                      lineHeight: 1.2,
                    }}
                  >
                    {r.name}
                  </div>
                  <div style={{ fontSize: 10, opacity: 0.85, marginTop: 4 }}>
                    @{r.user}
                  </div>
                  <div
                    style={{
                      display: "flex",
                      gap: 8,
                      marginTop: 6,
                      fontSize: 10,
                      fontWeight: 700,
                    }}
                  >
                    <span style={{ color: "#FF6E8A" }}>♥ {r.likes}</span>
                    <span style={{ opacity: 0.8 }}>▶ {r.views}</span>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* ============ 이번 주 가격 동향 ============ */}
        <div style={{ padding: "28px 20px 0" }}>
          <div
            style={{
              display: "flex",
              alignItems: "baseline",
              justifyContent: "space-between",
              marginBottom: 12,
            }}
          >
            <div
              style={{
                fontSize: 18,
                fontWeight: 800,
                color: t.text,
                letterSpacing: -0.5,
                width: 230,
              }}
            >
              이번 주 가격 동향
            </div>
            <span style={{ fontSize: 11, color: t.textSoft }}>
              KAMIS 시세 · 오늘 기준
            </span>
          </div>

          <div
            style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 8 }}
          >
            {/* 가격 상승 중 */}
            <div
              className="tap"
              style={{
                borderRadius: 16,
                padding: "14px 14px 16px",
                background: t.hotBg,
                border: `1px solid ${t.hot}33`,
              }}
            >
              <div
                style={{
                  display: "inline-flex",
                  alignItems: "center",
                  gap: 4,
                  padding: "3px 8px 3px 6px",
                  borderRadius: 999,
                  background: "#fff",
                  color: t.hot,
                  fontSize: 11,
                  fontWeight: 800,
                }}
              >
                <svg width="9" height="9" viewBox="0 0 9 9">
                  <path d="M4.5 1L8 6H1L4.5 1z" fill="currentColor" />
                </svg>
                가격 상승 중
              </div>
              <div
                style={{
                  fontSize: 15,
                  fontWeight: 800,
                  color: t.text,
                  marginTop: 8,
                  letterSpacing: -0.4,
                  lineHeight: 1.3,
                }}
              >
                마늘, 양파,
                <br />
                대파
              </div>
              <div
                style={{
                  fontSize: 11,
                  color: t.hot,
                  marginTop: 6,
                  fontWeight: 600,
                }}
              >
                지금 담아두면 좋아요
              </div>
            </div>
            {/* 가격 하락 중 */}
            <div
              className="tap"
              style={{
                borderRadius: 16,
                padding: "14px 14px 16px",
                background: t.primaryBg,
                border: `1px solid ${t.primarySoft}`,
              }}
            >
              <div
                style={{
                  display: "inline-flex",
                  alignItems: "center",
                  gap: 4,
                  padding: "3px 8px 3px 6px",
                  borderRadius: 999,
                  background: "#fff",
                  color: t.primaryDark,
                  fontSize: 11,
                  fontWeight: 800,
                }}
              >
                <svg width="9" height="9" viewBox="0 0 9 9">
                  <path d="M4.5 8L1 3h7L4.5 8z" fill="currentColor" />
                </svg>
                가격 하락 중
              </div>
              <div
                style={{
                  fontSize: 15,
                  fontWeight: 800,
                  color: t.text,
                  marginTop: 8,
                  letterSpacing: -0.4,
                  lineHeight: 1.3,
                }}
              >
                토마토, 가지,
                <br />
                옥수수
              </div>
              <div
                style={{
                  fontSize: 11,
                  color: t.primaryDark,
                  marginTop: 6,
                  fontWeight: 600,
                }}
              >
                급하게 사지 않아도 돼요
              </div>
            </div>
          </div>
        </div>

        <div style={{ height: 30 }} />
      </div>
    </Phone>
  );
}

// helper for color shading on slide cards
function darken(hex, amt) {
  // expects #RRGGBB
  const c = hex.replace("#", "");
  const r = Math.max(0, parseInt(c.slice(0, 2), 16) - amt * 255);
  const g = Math.max(0, parseInt(c.slice(2, 4), 16) - amt * 255);
  const b = Math.max(0, parseInt(c.slice(4, 6), 16) - amt * 255);
  return `rgb(${r | 0},${g | 0},${b | 0})`;
}

// ─────────────────────────────────────────────────────────────
// 검색 화면 — 검색 전 (홈에서 상단 검색바 탭, 키워드 입력 전)
// ─────────────────────────────────────────────────────────────
export function ScreenHomeSearch({ t }) {
  return (
    <Phone t={t} tabBar={<BottomTabBar active="home" t={t} />} bg={t.bg}>
      <div className="phone-scroll" style={{ flex: 1, overflow: "auto" }}>
        {/* Search bar header — 빈 입력 상태 */}
        <div
          style={{
            paddingTop: 50,
            padding: "50px 14px 12px",
            background: "#fff",
            borderBottom: `1px solid ${t.borderSoft}`,
            display: "flex",
            alignItems: "center",
            gap: 8,
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
                stroke={t.text}
                strokeWidth="2"
                fill="none"
                strokeLinecap="round"
                strokeLinejoin="round"
              />
            </svg>
          </div>
          <div
            style={{
              flex: 1,
              height: 42,
              borderRadius: 12,
              background: t.bgSoft,
              border: `1px solid ${t.borderSoft}`,
              display: "flex",
              alignItems: "center",
              padding: "0 14px",
              gap: 8,
            }}
          >
            <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
              <circle
                cx="7"
                cy="7"
                r="5"
                stroke={t.textSoft}
                strokeWidth="1.6"
              />
              <path
                d="M10.5 10.5L14 14"
                stroke={t.textSoft}
                strokeWidth="1.6"
                strokeLinecap="round"
              />
            </svg>
            <span
              style={{
                flex: 1,
                fontSize: 14,
                color: t.textSoft,
                fontWeight: 500,
              }}
            >
              재료, 레시피, 키워드를 검색해보세요
            </span>
          </div>
        </div>

        {/* 최근 검색 */}
        <div style={{ padding: "18px 20px 0" }}>
          <div
            style={{
              display: "flex",
              alignItems: "baseline",
              justifyContent: "space-between",
              marginBottom: 10,
            }}
          >
            <div style={{ fontSize: 14, fontWeight: 800, color: t.text }}>
              최근 검색
            </div>
            <span style={{ fontSize: 11.5, color: t.textSoft }}>전체 삭제</span>
          </div>
          <div style={{ display: "flex", flexWrap: "wrap", gap: 6 }}>
            {["배추전", "무생채", "시금치 페스토", "깍두기", "감귤"].map(
              (k, i) => (
                <div
                  key={i}
                  style={{
                    padding: "7px 12px 7px 14px",
                    borderRadius: 999,
                    background: "#fff",
                    border: `1px solid ${t.border}`,
                    fontSize: 12.5,
                    fontWeight: 600,
                    color: t.text,
                    display: "flex",
                    alignItems: "center",
                    gap: 6,
                  }}
                >
                  {k}
                  <span
                    style={{ color: t.textSoft, fontSize: 13, lineHeight: 1 }}
                  >
                    ✕
                  </span>
                </div>
              ),
            )}
          </div>
        </div>

        {/* 인기 검색어 */}
        <div style={{ padding: "24px 20px 0" }}>
          <div
            style={{
              display: "flex",
              alignItems: "baseline",
              justifyContent: "space-between",
              marginBottom: 12,
            }}
          >
            <div style={{ fontSize: 14, fontWeight: 800, color: t.text }}>
              실시간 인기 검색어
            </div>
            <span style={{ fontSize: 11, color: t.textSoft }}>
              오후 6:30 기준
            </span>
          </div>
          <div
            style={{
              background: "#fff",
              borderRadius: 16,
              border: `1px solid ${t.borderSoft}`,
              overflow: "hidden",
            }}
          >
            {[
              { rank: 1, kw: "봄동", change: "↑" },
              { rank: 2, kw: "봄동 비빔밥 레시피", change: "↑" },
              { rank: 3, kw: "배추 가격", change: "new" },
              { rank: 4, kw: "감귤", change: "−" },
              { rank: 5, kw: "깍두기 황금레시피", change: "↑" },
            ].map((it, i, arr) => (
              <div
                key={i}
                className="tap"
                style={{
                  display: "flex",
                  alignItems: "center",
                  gap: 14,
                  padding: "10px 16px",
                  borderBottom:
                    i < arr.length - 1 ? `1px solid ${t.borderSoft}` : "none",
                }}
              >
                <span
                  style={{
                    fontSize: 14,
                    fontWeight: 800,
                    width: 16,
                    color: it.rank <= 3 ? t.hot : t.textMid,
                    fontFeatureSettings: '"tnum"',
                  }}
                >
                  {it.rank}
                </span>
                <span
                  style={{
                    flex: 1,
                    fontSize: 13.5,
                    fontWeight: 600,
                    color: t.text,
                  }}
                >
                  {it.kw}
                </span>
                <span
                  style={{
                    fontSize: 11,
                    fontWeight: 700,
                    color:
                      it.change === "new"
                        ? t.primary
                        : it.change === "↑"
                          ? t.hot
                          : t.textSoft,
                  }}
                >
                  {it.change === "new" ? "NEW" : it.change}
                </span>
              </div>
            ))}
          </div>
        </div>

        <div style={{ height: 30 }} />
      </div>
    </Phone>
  );
}

// ─────────────────────────────────────────────────────────────
// 검색 결과 화면 — 검색 후 ('봄동' 입력 → 재료 / 레시피 / 릴스 한 페이지)
// ─────────────────────────────────────────────────────────────
function SectionHeader({ title, count, more, t }) {
  return (
    <div
      style={{
        padding: "0 20px",
        display: "flex",
        alignItems: "baseline",
        justifyContent: "space-between",
        marginBottom: 12,
      }}
    >
      <div
        style={{
          fontSize: 16,
          fontWeight: 800,
          color: t.text,
          letterSpacing: -0.4,
          display: "flex",
          alignItems: "baseline",
          gap: 6,
        }}
      >
        {title}
        {count != null && (
          <span
            style={{
              fontSize: 12,
              fontWeight: 700,
              color: t.textSoft,
              fontFeatureSettings: '"tnum"',
            }}
          >
            {count}
          </span>
        )}
      </div>
      {more && (
        <span
          className="tap"
          style={{ fontSize: 12, color: t.primary, fontWeight: 700 }}
        >
          더보기 →
        </span>
      )}
    </div>
  );
}

export function ScreenHomeSearchResult({ t }) {
  return (
    <Phone t={t} tabBar={<BottomTabBar active="home" t={t} />} bg={t.bg}>
      <div className="phone-scroll" style={{ flex: 1, overflow: "auto" }}>
        {/* Search bar header — '봄동' 입력 상태 */}
        <div
          style={{
            paddingTop: 50,
            padding: "50px 14px 12px",
            background: "#fff",
            borderBottom: `1px solid ${t.borderSoft}`,
            display: "flex",
            alignItems: "center",
            gap: 8,
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
                stroke={t.text}
                strokeWidth="2"
                fill="none"
                strokeLinecap="round"
                strokeLinejoin="round"
              />
            </svg>
          </div>
          <div
            style={{
              flex: 1,
              height: 42,
              borderRadius: 12,
              background: t.bgSoft,
              border: `1px solid ${t.borderSoft}`,
              display: "flex",
              alignItems: "center",
              padding: "0 14px",
              gap: 8,
            }}
          >
            <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
              <circle
                cx="7"
                cy="7"
                r="5"
                stroke={t.textSoft}
                strokeWidth="1.6"
              />
              <path
                d="M10.5 10.5L14 14"
                stroke={t.textSoft}
                strokeWidth="1.6"
                strokeLinecap="round"
              />
            </svg>
            <span
              style={{ flex: 1, fontSize: 14, color: t.text, fontWeight: 600 }}
            >
              봄동
            </span>
            <div style={{ color: t.textSoft, fontSize: 18, lineHeight: 1 }}>
              ✕
            </div>
          </div>
        </div>

        {/* AI 답변 카드 */}
        <div style={{ padding: "16px 20px 0" }}>
          <div
            style={{
              borderRadius: 16,
              padding: 14,
              background: `linear-gradient(135deg, ${t.primaryBg}, #fff)`,
              border: `1px solid ${t.primarySoft}`,
            }}
          >
            <div
              style={{
                display: "flex",
                alignItems: "center",
                gap: 6,
                marginBottom: 6,
              }}
            >
              <div
                style={{
                  width: 18,
                  height: 18,
                  borderRadius: 9,
                  background: t.primary,
                  color: "#fff",
                  fontSize: 11,
                  display: "grid",
                  placeItems: "center",
                }}
              >
                🧑‍🍳
              </div>
              <span
                style={{
                  fontSize: 11.5,
                  fontWeight: 800,
                  color: t.primary,
                  letterSpacing: 0.3,
                }}
              >
                AI 답변
              </span>
            </div>
            <div style={{ fontSize: 13, color: t.text, lineHeight: 1.55 }}>
              <b>봄동</b>은 지금이 평년 대비{" "}
              <b style={{ color: t.primary }}>−22%</b>로 가장 알뜰한 시기예요.
              제일 어울리는 메뉴는 <b>봄동 비빔밥</b>·<b>봄동 새우전</b>이에요.
            </div>
          </div>
        </div>

        {/* ── 섹션 구분선 ── */}
        <div style={{ height: 8, background: t.bgSoft, marginTop: 22 }} />

        {/* 식재료 — 기존 디자인 */}
        <div style={{ padding: "18px 0 0" }}>
          <SectionHeader title="식재료" count={1} t={t} />
          <div style={{ padding: "0 20px 14px" }}>
            <div
              className="tap"
              style={{
                background: "#fff",
                borderRadius: 16,
                border: `1px solid ${t.borderSoft}`,
                padding: 14,
                display: "flex",
                alignItems: "center",
                gap: 14,
              }}
            >
              <VegPlaceholder name="봄동" size={64} t={t} />
              <div style={{ flex: 1, minWidth: 0 }}>
                <div
                  style={{
                    display: "flex",
                    alignItems: "center",
                    gap: 6,
                    marginBottom: 4,
                  }}
                >
                  <span
                    style={{ fontSize: 16, fontWeight: 800, color: t.text }}
                  >
                    봄동
                  </span>
                  <span
                    style={{
                      fontSize: 10,
                      fontWeight: 700,
                      color: t.primary,
                      background: t.primaryBg,
                      padding: "2px 7px",
                      borderRadius: 999,
                    }}
                  >
                    제철 적기
                  </span>
                </div>
                <div
                  style={{
                    fontSize: 13,
                    fontWeight: 700,
                    color: t.text,
                    fontFeatureSettings: '"tnum"',
                  }}
                >
                  ₩{priceRange(2400)}{" "}
                  <span
                    style={{
                      fontSize: 10.5,
                      color: t.textSoft,
                      fontWeight: 500,
                    }}
                  >
                    /단
                  </span>
                </div>
                <div
                  style={{
                    fontSize: 11.5,
                    color: t.primaryDark,
                    marginTop: 3,
                    fontWeight: 600,
                  }}
                >
                  평년 대비 −22% · 2월 제철
                </div>
              </div>
              <PriceBadge trend="down" value="-22%" t={t} />
            </div>
          </div>
          <div style={{ padding: "0 20px" }}>
            <div
              className="tap"
              style={{
                width: "100%",
                height: 44,
                borderRadius: 12,
                background: t.bgSoft,
                border: `1px solid ${t.borderSoft}`,
                display: "flex",
                alignItems: "center",
                justifyContent: "center",
                gap: 6,
                fontSize: 13,
                fontWeight: 700,
                color: t.text,
                letterSpacing: -0.2,
              }}
            >
              식재료 더보기
              <svg width="12" height="12" viewBox="0 0 12 12" fill="none">
                <path
                  d="M4 2l4 4-4 4"
                  stroke={t.text}
                  strokeWidth="1.8"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                />
              </svg>
            </div>
          </div>
        </div>

        {/* ── 섹션 구분선 ── */}
        <div style={{ height: 8, background: t.bgSoft, marginTop: 22 }} />

        {/* 레시피 — 가로 스크롤 */}
        <div style={{ padding: "18px 0 0" }}>
          <SectionHeader title="레시피" count={24} t={t} />
          <div
            className="phone-scroll"
            style={{
              display: "flex",
              gap: 12,
              overflowX: "auto",
              padding: "0 20px 4px",
            }}
          >
            {[
              {
                name: "봄동 비빔밥",
                time: "15분",
                diff: "쉬움",
                likes: "8.4만",
                img: DISH_IMG.봄동비빔밥히어로,
              },
              {
                name: "봄동 새우전",
                time: "20분",
                diff: "쉬움",
                likes: "5.1만",
                img: DISH_IMG.봄동새우전,
              },
              {
                name: "봄동 쌈밥",
                time: "25분",
                diff: "보통",
                likes: "3.2만",
                img: DISH_IMG.봄동쌈밥,
              },
              {
                name: "봄동 나물무침",
                time: "10분",
                diff: "쉬움",
                likes: "2.8만",
                img: DISH_IMG.나물무침,
              },
            ].map((r, i) => (
              <div
                key={i}
                className="tap"
                style={{
                  width: 200,
                  flexShrink: 0,
                  borderRadius: 18,
                  background: "#fff",
                  border: `1px solid ${t.borderSoft}`,
                  overflow: "hidden",
                }}
              >
                <div
                  style={{
                    height: 124,
                    backgroundImage: `url(${r.img})`,
                    backgroundSize: "cover",
                    backgroundPosition: "center",
                  }}
                />
                <div style={{ padding: "10px 12px 12px" }}>
                  <div
                    style={{
                      fontSize: 14,
                      fontWeight: 700,
                      color: t.text,
                      letterSpacing: -0.3,
                    }}
                  >
                    {r.name}
                  </div>
                  <div
                    style={{
                      fontSize: 11.5,
                      color: t.textSoft,
                      marginTop: 4,
                    }}
                  >
                    {r.time} · {r.diff} · ♥ {r.likes}
                  </div>
                </div>
              </div>
            ))}
          </div>
          <div style={{ padding: "14px 20px 0" }}>
            <div
              className="tap"
              style={{
                width: "100%",
                height: 44,
                borderRadius: 12,
                background: t.bgSoft,
                border: `1px solid ${t.borderSoft}`,
                display: "flex",
                alignItems: "center",
                justifyContent: "center",
                gap: 6,
                fontSize: 13,
                fontWeight: 700,
                color: t.text,
                letterSpacing: -0.2,
              }}
            >
              레시피 더보기
              <svg width="12" height="12" viewBox="0 0 12 12" fill="none">
                <path
                  d="M4 2l4 4-4 4"
                  stroke={t.text}
                  strokeWidth="1.8"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                />
              </svg>
            </div>
          </div>
        </div>

        {/* ── 섹션 구분선 ── */}
        <div style={{ height: 8, background: t.bgSoft, marginTop: 22 }} />

        {/* 릴스 — 가로 스크롤 (더보기 없음) */}
        <div style={{ padding: "18px 0 0" }}>
          <SectionHeader title="릴스" count={56} t={t} />
          <div
            className="phone-scroll"
            style={{
              display: "flex",
              gap: 10,
              overflowX: "auto",
              padding: "0 20px 4px",
            }}
          >
            {[
              {
                name: "봄동 비빔밥 1분",
                user: "쿠킹맘",
                views: "124만",
                likes: "8.4만",
                img: DISH_IMG.봄동비빔밥릴스1,
              },
              {
                name: "봄동 새우전 황금팁",
                user: "안성재",
                views: "89만",
                likes: "5.1만",
                img: DISH_IMG.봄동비빔밥릴스2,
              },
              {
                name: "봄동으로 5분 요리",
                user: "백종원",
                views: "62만",
                likes: "3.8만",
                img: DISH_IMG.봄동비빔밥릴스3,
              },
              {
                name: "봄동 쌈밥 ASMR",
                user: "에밀리",
                views: "41만",
                likes: "2.2만",
                img: DISH_IMG.봄동쌈밥,
              },
            ].map((r, i) => (
              <div
                key={i}
                className="tap"
                style={{
                  width: 140,
                  flexShrink: 0,
                  borderRadius: 16,
                  position: "relative",
                  overflow: "hidden",
                  aspectRatio: "9/14",
                  background: "#222",
                }}
              >
                <div
                  style={{
                    position: "absolute",
                    inset: 0,
                    backgroundImage: `url(${r.img})`,
                    backgroundSize: "cover",
                    backgroundPosition: "center",
                  }}
                />
                <div
                  style={{
                    position: "absolute",
                    inset: 0,
                    background:
                      "linear-gradient(180deg, rgba(0,0,0,0.05) 0%, rgba(0,0,0,0.6) 100%)",
                  }}
                />
                <div
                  style={{
                    position: "absolute",
                    top: 10,
                    right: 10,
                    width: 24,
                    height: 24,
                    borderRadius: 12,
                    background: "rgba(0,0,0,0.4)",
                    backdropFilter: "blur(8px)",
                    display: "grid",
                    placeItems: "center",
                  }}
                >
                  <svg width="9" height="9" viewBox="0 0 10 10">
                    <path d="M2 1l7 4-7 4V1z" fill="#fff" />
                  </svg>
                </div>
                <div
                  style={{
                    position: "absolute",
                    left: 0,
                    right: 0,
                    bottom: 0,
                    padding: 10,
                    color: "#fff",
                  }}
                >
                  <div
                    style={{
                      fontSize: 12,
                      fontWeight: 800,
                      letterSpacing: -0.2,
                      lineHeight: 1.25,
                    }}
                  >
                    {r.name}
                  </div>
                  <div style={{ fontSize: 10, opacity: 0.85, marginTop: 3 }}>
                    @{r.user}
                  </div>
                  <div
                    style={{
                      display: "flex",
                      gap: 8,
                      marginTop: 5,
                      fontSize: 10,
                      fontWeight: 700,
                    }}
                  >
                    <span style={{ color: "#FF6E8A" }}>♥ {r.likes}</span>
                    <span style={{ opacity: 0.8 }}>▶ {r.views}</span>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>

        <div style={{ height: 30 }} />
      </div>
    </Phone>
  );
}

// ─────────────────────────────────────────────────────────────
// AI 시작 시트 (하단 중앙 AI 버튼 탭 → 슬라이드업 시트)
// ─────────────────────────────────────────────────────────────
export function ScreenAISheet({ t }) {
  return (
    <Phone t={t} tabBar={<BottomTabBar active="ai" t={t} />} bg={t.bg}>
      <div style={{ flex: 1, position: "relative", overflow: "hidden" }}>
        {/* dimmed home background */}
        <div
          style={{
            position: "absolute",
            inset: 0,
            background: `linear-gradient(180deg, ${t.primarySoft} 0%, ${t.bg} 100%)`,
            filter: "blur(2px)",
          }}
        >
          <div
            style={{
              position: "absolute",
              right: -10,
              top: 70,
              width: 200,
              height: 200,
              borderRadius: 200,
              background:
                "radial-gradient(circle at 35% 35%, #f5a55a, #d77a2f)",
              opacity: 0.6,
            }}
          />
          <div
            style={{
              position: "absolute",
              right: 70,
              top: 180,
              width: 80,
              height: 80,
              borderRadius: 80,
              background:
                "radial-gradient(circle at 30% 30%, #c8e58e, #6ba83f)",
              opacity: 0.6,
            }}
          />
        </div>
        <div
          style={{
            position: "absolute",
            inset: 0,
            background: "rgba(0,0,0,0.45)",
          }}
        />

        {/* Sheet */}
        <div
          style={{
            position: "absolute",
            left: 0,
            right: 0,
            bottom: 0,
            background: "#fff",
            borderRadius: "24px 24px 0 0",
            padding: "12px 20px 24px",
            boxShadow: "0 -20px 60px rgba(0,0,0,0.18)",
            maxHeight: "78%",
            overflow: "auto",
          }}
          className="phone-scroll"
        >
          {/* drag handle */}
          <div
            style={{
              width: 40,
              height: 4,
              borderRadius: 2,
              background: t.borderSoft,
              margin: "0 auto 18px",
            }}
          />

          {/* Header */}
          <div
            style={{
              display: "flex",
              alignItems: "center",
              gap: 12,
              marginBottom: 6,
            }}
          >
            <div
              style={{
                width: 44,
                height: 44,
                borderRadius: 22,
                background: `linear-gradient(135deg, ${t.primary}, ${t.primaryDark})`,
                display: "grid",
                placeItems: "center",
                fontSize: 22,
              }}
            >
              🧑‍🍳
            </div>
            <div style={{ flex: 1 }}>
              <div
                style={{
                  fontSize: 17,
                  fontWeight: 800,
                  color: t.text,
                  letterSpacing: -0.4,
                }}
              >
                AI 셰프
              </div>
              <div style={{ fontSize: 12, color: t.textSoft, marginTop: 1 }}>
                ● 온라인 · 평균 응답 3초
              </div>
            </div>
            <div
              className="tap"
              style={{
                width: 32,
                height: 32,
                borderRadius: 16,
                background: t.bgSoft,
                display: "grid",
                placeItems: "center",
                color: t.textMid,
                fontSize: 16,
              }}
            >
              ✕
            </div>
          </div>

          <div
            style={{
              fontSize: 14,
              color: t.text,
              lineHeight: 1.55,
              marginTop: 10,
            }}
          >
            안녕하세요 🌱
            <br />
            <b>이번 주 장보기</b>, 어떻게 도와드릴까요?
          </div>

          {/* Quick start cards */}
          <div
            style={{
              display: "flex",
              flexDirection: "column",
              gap: 8,
              marginTop: 16,
            }}
          >
            {[
              {
                ic: "🛒",
                title: "우리 집 조건으로 추천",
                sub: "인원·예산·취향 입력 → 식재료 쇼핑 완성",
                primary: true,
              },
              {
                ic: "🌱",
                title: "지금 제철 재료로 짜줘",
                sub: "11월 입동 · 14개 중 골라서",
              },
              {
                ic: "🥘",
                title: "냉장고에 있는 재료로",
                sub: "사진 한 장이면 OK",
              },
              {
                ic: "🎬",
                title: "본 레시피 재료 한 번에 주문",
                sub: "최근 본 레시피 3개",
              },
            ].map((q, i) => (
              <div
                key={i}
                className="tap"
                style={{
                  padding: 14,
                  borderRadius: 14,
                  background: q.primary ? t.text : "#fff",
                  color: q.primary ? "#fff" : t.text,
                  border: q.primary ? "none" : `1px solid ${t.borderSoft}`,
                  display: "flex",
                  alignItems: "center",
                  gap: 12,
                }}
              >
                <div
                  style={{
                    width: 40,
                    height: 40,
                    borderRadius: 12,
                    background: q.primary
                      ? "rgba(255,255,255,0.15)"
                      : t.primaryBg,
                    display: "grid",
                    placeItems: "center",
                    fontSize: 20,
                    flexShrink: 0,
                  }}
                >
                  {q.ic}
                </div>
                <div style={{ flex: 1, minWidth: 0 }}>
                  <div
                    style={{
                      fontSize: 14,
                      fontWeight: 800,
                      letterSpacing: -0.2,
                    }}
                  >
                    {q.title}
                  </div>
                  <div
                    style={{
                      fontSize: 11.5,
                      opacity: q.primary ? 0.75 : 1,
                      color: q.primary ? "#fff" : t.textSoft,
                      marginTop: 3,
                    }}
                  >
                    {q.sub}
                  </div>
                </div>
                <svg width="14" height="14" viewBox="0 0 14 14">
                  <path
                    d="M5 3l4 4-4 4"
                    stroke={q.primary ? "#fff" : t.textSoft}
                    strokeWidth="1.7"
                    fill="none"
                    strokeLinecap="round"
                    strokeLinejoin="round"
                  />
                </svg>
              </div>
            ))}
          </div>

          {/* Free input */}
          <div
            style={{
              marginTop: 16,
              padding: "12px 14px",
              borderRadius: 14,
              border: `1px dashed ${t.border}`,
              display: "flex",
              alignItems: "center",
              gap: 10,
            }}
          >
            <span style={{ fontSize: 16 }}>💬</span>
            <span style={{ flex: 1, fontSize: 13, color: t.textSoft }}>
              아니면 자유롭게 채팅으로 물어보세요…
            </span>
            <span style={{ fontSize: 16 }}>🎙️</span>
          </div>
        </div>
      </div>
    </Phone>
  );
}

// Reels feed + Recipe detail (사이드 스와이프) + Recipe steps

import React from "react";
import {
  Phone,
  BottomTabBar,
  PhoneStatus,
  AppHeader,
  VegPlaceholder,
  Chip,
  priceRange,
} from "./phone";
import { DISH_IMG, FACE_IMG, vegImg } from "./mock-images";
import { producersForIngredient } from "./producers-data";

// 해당 재료를 파는 농가가 있는지
const hasProducer = (name) => producersForIngredient(name).length > 0;

const IMG = {
  reelHero: DISH_IMG.봄동비빔밥히어로,
  recipeHero: DISH_IMG.봄동비빔밥히어로,
  stepMix: DISH_IMG.봄동비빔밥스텝,
  avatarCreator: FACE_IMG.cookingMom,
  relatedReels: [
    DISH_IMG.봄동비빔밥릴스1,
    DISH_IMG.봄동쌈밥,
    DISH_IMG.봄동새우전,
  ],
};

// ─────────────────────────────────────────────────────────────
// REELS — 세로 영상 피드 (위/아래: 다음 레시피, 좌/우: 상세로)
// ─────────────────────────────────────────────────────────────
export function ScreenReels({ t }) {
  return (
    <Phone t={t} dark tabBar={<BottomTabBar active="reels" t={t} dark />}>
      <div
        style={{
          flex: 1,
          position: "relative",
          overflow: "hidden",
          background: "#000",
        }}
      >
        {/* Video bg — 봄동 비빔밥 영상 썸네일 */}
        <div
          style={{
            position: "absolute",
            inset: 0,
            backgroundImage: `url(${IMG.reelHero})`,
            backgroundSize: "cover",
            backgroundPosition: "center",
          }}
        >
          <div
            style={{
              position: "absolute",
              inset: 0,
              background:
                "linear-gradient(180deg, rgba(0,0,0,0.35) 0%, rgba(0,0,0,0.15) 35%, rgba(0,0,0,0.55) 100%)",
            }}
          />
        </div>

        {/* Status bar shim (dark) */}
        <div
          style={{
            position: "absolute",
            top: 0,
            left: 0,
            right: 0,
            zIndex: 10,
          }}
        >
          <PhoneStatus dark />
        </div>

        {/* Top tabs — 추천 / 팔로우 */}
        <div
          style={{
            position: "absolute",
            top: 46,
            left: 0,
            right: 0,
            display: "flex",
            justifyContent: "center",
            gap: 22,
            zIndex: 10,
          }}
        >
          {[
            { key: "rec", label: "추천", active: true },
            { key: "follow", label: "팔로우", active: false },
          ].map((tab) => (
            <div
              key={tab.key}
              className="tap"
              style={{
                display: "flex",
                flexDirection: "column",
                alignItems: "center",
                gap: 6,
              }}
            >
              <span
                style={{
                  fontSize: 15,
                  fontWeight: tab.active ? 800 : 600,
                  color: tab.active ? "#fff" : "rgba(255,255,255,0.6)",
                  letterSpacing: -0.2,
                  textShadow: "0 1px 2px rgba(0,0,0,0.3)",
                }}
              >
                {tab.label}
              </span>
              <div
                style={{
                  width: 18,
                  height: 2.5,
                  borderRadius: 2,
                  background: tab.active ? "#fff" : "transparent",
                }}
              />
            </div>
          ))}
        </div>

        {/* Center play indicator */}
        <div
          style={{
            position: "absolute",
            top: "50%",
            left: "50%",
            transform: "translate(-50%, -50%)",
            width: 64,
            height: 64,
            borderRadius: 32,
            background: "rgba(255,255,255,0.18)",
            backdropFilter: "blur(20px)",
            display: "grid",
            placeItems: "center",
          }}
        >
          <svg width="22" height="22" viewBox="0 0 22 22">
            <path d="M6 4l12 7-12 7V4z" fill="#fff" />
          </svg>
        </div>

        {/* Side action rail */}
        <div
          style={{
            position: "absolute",
            right: 12,
            bottom: 130,
            display: "flex",
            flexDirection: "column",
            gap: 18,
            alignItems: "center",
            zIndex: 5,
          }}
        >
          {/* avatar */}
          <div style={{ position: "relative" }}>
            <div
              style={{
                width: 44,
                height: 44,
                borderRadius: 22,
                backgroundImage: `url(${IMG.avatarCreator})`,
                backgroundSize: "cover",
                backgroundPosition: "center",
                border: "2px solid #fff",
              }}
            />
            <div
              style={{
                position: "absolute",
                bottom: -6,
                left: "50%",
                transform: "translateX(-50%)",
                width: 20,
                height: 20,
                borderRadius: 10,
                background: t.primary,
                border: "2px solid #000",
                color: "#fff",
                fontSize: 12,
                fontWeight: 800,
                display: "grid",
                placeItems: "center",
              }}
            >
              +
            </div>
          </div>
          {[
            { ic: "♥", n: "84.2K", color: "#FF3B5C" },
            { ic: "💬", n: "1,204", color: "#fff" },
            { ic: "↗", n: "공유", color: "#fff" },
            { ic: "🔖", n: "저장", color: "#fff" },
          ].map((a, i) => (
            <div
              key={i}
              style={{
                display: "flex",
                flexDirection: "column",
                alignItems: "center",
                gap: 4,
              }}
            >
              <div
                style={{
                  width: 42,
                  height: 42,
                  borderRadius: 21,
                  background: "rgba(255,255,255,0.12)",
                  backdropFilter: "blur(8px)",
                  display: "grid",
                  placeItems: "center",
                  fontSize: 18,
                  color: a.color,
                }}
              >
                {a.ic}
              </div>
              <span style={{ fontSize: 10.5, fontWeight: 700, color: "#fff" }}>
                {a.n}
              </span>
            </div>
          ))}
          {/* spinning record disk */}
          <div
            style={{
              width: 36,
              height: 36,
              borderRadius: 18,
              background: `radial-gradient(circle, ${t.primary} 22%, #111 25%, #111 100%)`,
              border: "2px solid rgba(255,255,255,0.2)",
            }}
          />
        </div>

        {/* Bottom info */}
        <div
          style={{
            position: "absolute",
            left: 16,
            right: 80,
            bottom: 16,
            color: "#fff",
            zIndex: 5,
          }}
        >
          <div
            style={{
              display: "flex",
              alignItems: "center",
              gap: 8,
              marginBottom: 8,
            }}
          >
            <span style={{ fontSize: 14, fontWeight: 800 }}>@쿠킹맘</span>
            <span
              style={{
                fontSize: 11,
                fontWeight: 800,
                padding: "3px 8px",
                border: "1.2px solid #fff",
                borderRadius: 999,
              }}
            >
              팔로우
            </span>
          </div>
          <div
            style={{
              fontSize: 14.5,
              fontWeight: 700,
              letterSpacing: -0.3,
              lineHeight: 1.35,
            }}
          >
            1분만에 봄동 비빔밥 🌱
          </div>
          <div style={{ fontSize: 12, opacity: 0.85, marginTop: 4 }}>
            #제철 #봄동 #간단요리 · 12.4만 조회
          </div>

          {/* 주 재료 칩 — 각 칩 탭 시 식재료 상세로 이동 */}
          <div
            style={{ display: "flex", flexWrap: "wrap", gap: 6, marginTop: 10 }}
          >
            {["봄동", "고추장", "쪽파"].map((ing) => (
              <div
                key={ing}
                className="tap"
                style={{
                  display: "inline-flex",
                  alignItems: "center",
                  gap: 6,
                  padding: "6px 10px 6px 6px",
                  borderRadius: 999,
                  background: "rgba(255,255,255,0.18)",
                  backdropFilter: "blur(20px)",
                  border: "1px solid rgba(255,255,255,0.25)",
                }}
              >
                <div
                  style={{
                    width: 22,
                    height: 22,
                    borderRadius: 11,
                    background: t.primaryBg,
                    backgroundImage: vegImg(ing)
                      ? `url(${vegImg(ing)})`
                      : undefined,
                    backgroundSize: "cover",
                    backgroundPosition: "center",
                    display: "grid",
                    placeItems: "center",
                    fontSize: 9,
                    fontWeight: 800,
                    color: t.primaryDark,
                  }}
                >
                  {vegImg(ing) ? null : ing[0]}
                </div>
                <span style={{ fontSize: 12, fontWeight: 700 }}>{ing}</span>
                <svg width="9" height="9" viewBox="0 0 10 10">
                  <path
                    d="M3 1l4 4-4 4"
                    stroke="#fff"
                    strokeWidth="1.6"
                    fill="none"
                    strokeLinecap="round"
                    strokeLinejoin="round"
                  />
                </svg>
              </div>
            ))}
          </div>
        </div>

        {/* Right edge handle — 좌우 스와이프로 레시피 상세 진입 */}
        <div
          style={{
            position: "absolute",
            right: 0,
            top: "20%",
            transform: "translateY(-50%)",
            display: "flex",
            alignItems: "center",
            gap: 6,
            padding: "10px 6px 10px 10px",
            borderTopLeftRadius: 12,
            borderBottomLeftRadius: 12,
            background: "rgba(255,255,255,0.14)",
            backdropFilter: "blur(10px)",
            border: "1px solid rgba(255,255,255,0.22)",
            borderRight: "none",
            color: "#fff",
            zIndex: 5,
          }}
        >
          <span
            style={{
              fontSize: 10.5,
              fontWeight: 700,
              letterSpacing: -0.2,
              writingMode: "vertical-rl",
              textOrientation: "mixed",
            }}
          >
            자세히
          </span>
          <svg width="10" height="14" viewBox="0 0 10 14">
            <path
              d="M7 2L3 7l4 5"
              stroke="currentColor"
              strokeWidth="1.6"
              fill="none"
              strokeLinecap="round"
              strokeLinejoin="round"
            />
          </svg>
        </div>

        {/* Swipe gestures */}
        <div
          style={{
            position: "absolute",
            left: "50%",
            bottom: 100,
            transform: "translateX(-50%)",
            fontSize: 10.5,
            color: "rgba(255,255,255,0.55)",
            fontWeight: 600,
            display: "flex",
            alignItems: "center",
            gap: 4,
          }}
        >
          <svg width="10" height="10" viewBox="0 0 10 10">
            <path
              d="M5 2v6M2 6l3 3 3-3"
              stroke="currentColor"
              strokeWidth="1.4"
              fill="none"
              strokeLinecap="round"
              strokeLinejoin="round"
            />
          </svg>
          다음 레시피
        </div>
      </div>
    </Phone>
  );
}

// ─────────────────────────────────────────────────────────────
// RECIPE DETAIL — 릴스에서 좌→우 스와이프로 전환
// ─────────────────────────────────────────────────────────────
export function ScreenRecipeDetail({ t }) {
  return (
    <Phone t={t}>
      <div
        className="phone-scroll"
        style={{ flex: 1, overflow: "auto", background: "#fff" }}
      >
        {/* Hero video preview */}
        <div style={{ position: "relative", aspectRatio: "4/3" }}>
          <div
            style={{
              position: "absolute",
              inset: 0,
              backgroundImage: `url(${IMG.recipeHero})`,
              backgroundSize: "cover",
              backgroundPosition: "center",
            }}
          >
            <div
              style={{
                position: "absolute",
                inset: 0,
                background:
                  "linear-gradient(180deg, rgba(0,0,0,0.25), rgba(0,0,0,0.05) 40%, rgba(0,0,0,0.2))",
              }}
            />
          </div>
          {/* Back + actions */}
          <div
            style={{
              position: "absolute",
              top: 46,
              left: 14,
              right: 14,
              display: "flex",
              justifyContent: "space-between",
            }}
          >
            <div
              className="tap"
              style={{
                width: 36,
                height: 36,
                borderRadius: 18,
                background: "rgba(255,255,255,0.85)",
                backdropFilter: "blur(10px)",
                display: "grid",
                placeItems: "center",
              }}
            >
              <svg width="18" height="18" viewBox="0 0 18 18">
                <path
                  d="M11 3L5 9l6 6"
                  stroke={t.text}
                  strokeWidth="2"
                  fill="none"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                />
              </svg>
            </div>
            <div style={{ display: "flex", gap: 6 }}>
              <div
                className="tap"
                style={{
                  width: 36,
                  height: 36,
                  borderRadius: 18,
                  background: "rgba(255,255,255,0.85)",
                  backdropFilter: "blur(10px)",
                  display: "grid",
                  placeItems: "center",
                }}
              >
                <svg width="18" height="18" viewBox="0 0 18 18">
                  <path
                    d="M9 16s-6-4-6-9a3.5 3.5 0 016-2.5A3.5 3.5 0 0115 7c0 5-6 9-6 9z"
                    stroke={t.text}
                    strokeWidth="1.6"
                    fill="none"
                  />
                </svg>
              </div>
            </div>
          </div>
          {/* play */}
          <div
            style={{
              position: "absolute",
              top: "50%",
              left: "50%",
              transform: "translate(-50%, -50%)",
              width: 60,
              height: 60,
              borderRadius: 30,
              background: "rgba(0,0,0,0.4)",
              display: "grid",
              placeItems: "center",
              backdropFilter: "blur(8px)",
            }}
          >
            <svg width="22" height="22" viewBox="0 0 22 22">
              <path d="M6 4l12 7-12 7V4z" fill="#fff" />
            </svg>
          </div>
        </div>

        {/* Title block */}
        <div style={{ padding: "18px 20px 0" }}>
          <div style={{ display: "flex", gap: 6, marginBottom: 10 }}>
            <Chip color={t.primary} bg={t.primaryBg}>
              🌱 제철
            </Chip>
          </div>
          <div
            style={{
              fontSize: 23,
              fontWeight: 800,
              color: t.text,
              letterSpacing: -0.7,
              lineHeight: 1.25,
            }}
          >
            1분만에
            <br />
            봄동 비빔밥
          </div>
          <div
            style={{
              display: "flex",
              alignItems: "center",
              gap: 8,
              marginTop: 12,
            }}
          >
            <div
              style={{
                width: 24,
                height: 24,
                borderRadius: 12,
                backgroundImage: `url(${IMG.avatarCreator})`,
                backgroundSize: "cover",
                backgroundPosition: "center",
              }}
            />
            <span style={{ fontSize: 13, fontWeight: 700, color: t.text }}>
              @쿠킹맘
            </span>
            <span style={{ fontSize: 12, color: t.textSoft }}>
              · 좋아요 8.4만
            </span>
          </div>

          {/* Meta — 소요시간 · 난이도 · 인분 */}
          <div
            style={{
              marginTop: 14,
              display: "grid",
              gridTemplateColumns: "1fr 1fr 1fr",
              background: "#fff",
              borderRadius: 14,
              border: `1px solid ${t.borderSoft}`,
              overflow: "hidden",
            }}
          >
            {[
              { label: "소요시간", value: "15분", icon: "⏱" },
              { label: "난이도", value: "쉬움", icon: "" },
              { label: "인분", value: "2인", icon: "" },
            ].map((m, i, arr) => (
              <div
                key={i}
                style={{
                  padding: "10px 8px",
                  borderRight:
                    i < arr.length - 1 ? `1px solid ${t.borderSoft}` : "none",
                  textAlign: "center",
                }}
              >
                <div
                  style={{
                    fontSize: 10.5,
                    color: t.textSoft,
                    fontWeight: 600,
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "center",
                    gap: 3,
                  }}
                >
                  <span style={{ fontSize: 11 }}>{m.icon}</span>
                  {m.label}
                </div>
                <div
                  style={{
                    fontSize: 14,
                    fontWeight: 800,
                    color: t.text,
                    marginTop: 3,
                    fontFeatureSettings: '"tnum"',
                  }}
                >
                  {m.value}
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Ingredients + 가격 */}
        <div style={{ padding: "20px 16px 0" }}>
          <div
            style={{
              padding: "0 4px",
              display: "flex",
              alignItems: "center",
              justifyContent: "space-between",
              marginBottom: 10,
            }}
          >
            <div style={{ fontSize: 16, fontWeight: 800, color: t.text }}>
              재료{" "}
              <span style={{ color: t.textSoft, fontWeight: 600 }}>2인</span>
            </div>
            <span
              style={{
                fontSize: 13,
                fontWeight: 800,
                width: 120,
                color: t.primary,
                fontFeatureSettings: '"tnum"',
              }}
            >
              총 ₩{priceRange(4000)}
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
              { name: "봄동", q: "1줌", price: 1200, dn: true },
              { name: "고추장", q: "2큰술", price: 800, dn: false },
              { name: "마늘", q: "1큰술", price: 400, dn: false },
              { name: "쪽파", q: "약간", price: 1200, dn: false },
              { name: "계란", q: "1개", price: 400, dn: false },
            ].map((it, i, arr) => (
              <div
                key={i}
                style={{
                  display: "flex",
                  alignItems: "center",
                  gap: 10,
                  padding: "11px 14px",
                  borderBottom:
                    i < arr.length - 1 ? `1px solid ${t.borderSoft}` : "none",
                }}
              >
                <VegPlaceholder name={it.name} size={32} t={t} />
                <div style={{ flex: 1 }}>
                  <div
                    style={{ fontSize: 13.5, fontWeight: 700, color: t.text }}
                  >
                    {it.name}
                  </div>
                  <div style={{ fontSize: 11, color: t.textSoft }}>{it.q}</div>
                </div>
                {it.dn && (
                  <Chip color={t.primary} bg={t.primaryBg}>
                    적기 ↓
                  </Chip>
                )}
                {hasProducer(it.name) && (
                  <span
                    className="tap"
                    style={{
                      display: "inline-flex",
                      alignItems: "center",
                      gap: 3,
                      fontSize: 10.5,
                      fontWeight: 700,
                      color: t.primary,
                      background: t.primaryBg,
                      padding: "3px 8px",
                      borderRadius: 999,
                      flexShrink: 0,
                      whiteSpace: "nowrap",
                    }}
                  >
                    농가 보기
                    <svg width="7" height="11" viewBox="0 0 7 11">
                      <path
                        d="M1 1l4.5 4.5L1 10"
                        stroke={t.primary}
                        strokeWidth="1.4"
                        fill="none"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                      />
                    </svg>
                  </span>
                )}
                <div
                  style={{
                    fontSize: 13,
                    fontWeight: 700,
                    color: it.price === 0 ? t.textSoft : t.text,
                    fontFeatureSettings: '"tnum"',
                    minWidth: 50,
                    textAlign: "right",
                  }}
                >
                  {it.price === 0 ? "−" : `₩${priceRange(it.price)}`}
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* ============ 관련 릴스 콘텐츠 ============ */}
        <div style={{ padding: "24px 16px 0" }}>
          <div
            style={{
              padding: "0 4px",
              display: "flex",
              alignItems: "baseline",
              justifyContent: "space-between",
              marginBottom: 10,
            }}
          >
            <div
              style={{
                fontSize: 15,
                fontWeight: 800,
                color: t.text,
                display: "flex",
                alignItems: "center",
                gap: 6,
              }}
            >
              이 레시피의 릴스
            </div>
            <span
              style={{ fontSize: 11.5, color: t.textSoft, fontWeight: 600 }}
            >
              숏폼 3개
            </span>
          </div>
          <div
            style={{
              display: "flex",
              gap: 8,
              overflowX: "auto",
              padding: "0 4px 4px",
              marginLeft: -4,
              marginRight: -4,
            }}
            className="phone-scroll"
          >
            {[
              { user: "쿠킹맘", likes: "8.4만", dur: "0:48", tag: "HOT" },
              { user: "안성재", likes: "5.1만", dur: "1:12" },
              { user: "백종원", likes: "3.8만", dur: "0:55", tag: "신상" },
            ].map((r, i) => (
              <div
                key={i}
                className="tap"
                style={{
                  width: 116,
                  flexShrink: 0,
                  borderRadius: 14,
                  overflow: "hidden",
                  aspectRatio: "9/14",
                  position: "relative",
                  background: "#222",
                }}
              >
                <div
                  style={{
                    position: "absolute",
                    inset: 0,
                    backgroundImage: `url(${IMG.relatedReels[i % IMG.relatedReels.length]})`,
                    backgroundSize: "cover",
                    backgroundPosition: "center",
                  }}
                />
                {r.tag && (
                  <div
                    style={{
                      position: "absolute",
                      top: 8,
                      left: 8,
                      padding: "2px 6px",
                      borderRadius: 4,
                      background: r.tag === "HOT" ? t.hot : t.primary,
                      color: "#fff",
                      fontSize: 9,
                      fontWeight: 800,
                      letterSpacing: 0.3,
                    }}
                  >
                    {r.tag}
                  </div>
                )}
                <div
                  style={{
                    position: "absolute",
                    top: 8,
                    right: 8,
                    padding: "2px 6px",
                    borderRadius: 4,
                    background: "rgba(0,0,0,0.55)",
                    backdropFilter: "blur(6px)",
                    color: "#fff",
                    fontSize: 9.5,
                    fontWeight: 700,
                    fontFeatureSettings: '"tnum"',
                  }}
                >
                  {r.dur}
                </div>
                <div
                  style={{
                    position: "absolute",
                    top: "50%",
                    left: "50%",
                    transform: "translate(-50%,-50%)",
                    width: 32,
                    height: 32,
                    borderRadius: 16,
                    background: "rgba(255,255,255,0.22)",
                    backdropFilter: "blur(8px)",
                    display: "grid",
                    placeItems: "center",
                  }}
                >
                  <svg width="10" height="10" viewBox="0 0 10 10">
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
                    background:
                      "linear-gradient(180deg, transparent 0%, rgba(0,0,0,0.85) 100%)",
                    color: "#fff",
                  }}
                >
                  <div
                    style={{
                      fontSize: 10.5,
                      fontWeight: 700,
                      letterSpacing: -0.2,
                    }}
                  >
                    @{r.user}
                  </div>
                  <div style={{ fontSize: 9.5, opacity: 0.85, marginTop: 2 }}>
                    ♥ {r.likes}
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>

        <div style={{ height: 96 }} />
      </div>

      {/* Floating action bar — AI 셰프 : 조리 순서 보기 (1:1) */}
      <div
        style={{
          position: "absolute",
          left: 0,
          right: 0,
          bottom: 0,
          padding: "20px 16px 27px",
          background: "#fff",
          borderTop: `1px solid ${t.borderSoft}`,
          display: "flex",
          gap: 8,
          zIndex: 90,
        }}
      >
        <button
          className="tap"
          style={{
            flex: 1,
            height: 52,
            borderRadius: 14,
            border: `1px solid ${t.borderSoft}`,
            background: "#fff",
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            gap: 6,
            padding: 0,
            boxShadow: "0 4px 14px rgba(20,40,30,0.06)",
            fontSize: 14,
            fontWeight: 700,
            color: t.text,
            letterSpacing: -0.3,
          }}
        >
          <svg width="20" height="20" viewBox="0 0 26 26" fill="none">
            <path
              d="M13 4c-2 0-3.5 1.5-3.5 3.5 0 0-3 0-4.5 2.5C3.5 12.5 5 15.5 7.5 17c-0.5 3 1.5 5 5.5 5s6-2 5.5-5c2.5-1.5 4-4.5 2.5-7-1.5-2.5-4.5-2.5-4.5-2.5C16.5 5.5 15 4 13 4z"
              fill={t.primary}
            />
            <circle cx="10" cy="11" r="1" fill="#fff" />
            <circle cx="16" cy="11" r="1" fill="#fff" />
            <path
              d="M10 15c1 1.5 5 1.5 6 0"
              stroke="#fff"
              strokeWidth="1.5"
              strokeLinecap="round"
              fill="none"
            />
          </svg>
          함께 요리하기
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
            fontSize: 14.5,
            fontWeight: 800,
            letterSpacing: -0.3,
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            gap: 8,
          }}
        >
          <svg width="18" height="18" viewBox="0 0 18 18" fill="none">
            <path
              d="M3 4h12M3 9h12M3 14h8"
              stroke="#fff"
              strokeWidth="1.6"
              strokeLinecap="round"
            />
          </svg>
          조리 순서 보기
        </button>
      </div>
    </Phone>
  );
}

// ─────────────────────────────────────────────────────────────
// RECIPE STEPS — 조리 순서 (step-by-step)
// ─────────────────────────────────────────────────────────────
export function ScreenRecipeSteps({ t }) {
  return (
    <Phone t={t}>
      <AppHeader
        t={t}
        title="조리 순서"
        leftBack
        rightIcons={
          <Chip color={t.text} bg={t.bgSoft}>
            3 / 5
          </Chip>
        }
      />
      <div
        className="phone-scroll"
        style={{ flex: 1, overflow: "auto", background: t.bg }}
      >
        {/* progress */}
        <div style={{ padding: "8px 20px 0" }}>
          <div style={{ display: "flex", gap: 4 }}>
            {[0, 1, 2, 3, 4].map((i) => (
              <div
                key={i}
                style={{
                  flex: 1,
                  height: 4,
                  borderRadius: 2,
                  background: i < 3 ? t.primary : t.borderSoft,
                }}
              />
            ))}
          </div>
        </div>

        {/* big step number + image */}
        <div style={{ padding: "14px 20px 0" }}>
          <div
            style={{
              fontSize: 11,
              fontWeight: 800,
              color: t.primary,
              letterSpacing: 1,
            }}
          >
            STEP 03
          </div>
          <div
            style={{
              fontSize: 26,
              fontWeight: 800,
              color: t.text,
              letterSpacing: -0.7,
              marginTop: 4,
              lineHeight: 1.2,
            }}
          >
            봄동에 양념을
            <br />
            버무려요
          </div>
        </div>

        <div style={{ padding: "16px 16px 0" }}>
          <div
            style={{
              aspectRatio: "4/3",
              borderRadius: 18,
              backgroundImage: `url(${IMG.stepMix})`,
              backgroundSize: "cover",
              backgroundPosition: "center",
              position: "relative",
              overflow: "hidden",
            }}
          >
            {/* timer */}
            <div
              style={{
                position: "absolute",
                top: 12,
                right: 12,
                padding: "6px 10px 6px 8px",
                borderRadius: 999,
                background: "rgba(0,0,0,0.7)",
                backdropFilter: "blur(8px)",
                color: "#fff",
                fontSize: 12,
                fontWeight: 700,
                display: "flex",
                alignItems: "center",
                gap: 4,
                fontFeatureSettings: '"tnum"',
              }}
            >
              <svg width="12" height="12" viewBox="0 0 12 12" fill="none">
                <circle
                  cx="6"
                  cy="6.5"
                  r="4.5"
                  stroke="#fff"
                  strokeWidth="1.4"
                />
                <path
                  d="M6 4v3l2 1"
                  stroke="#fff"
                  strokeWidth="1.4"
                  strokeLinecap="round"
                />
              </svg>
              2:00
            </div>
          </div>
        </div>

        <div style={{ padding: "16px 22px 0" }}>
          <div
            style={{
              fontSize: 15,
              lineHeight: 1.65,
              color: t.text,
              fontWeight: 500,
            }}
          >
            볼에 무채를 넣고{" "}
            <b style={{ color: t.primaryDark }}>
              고춧가루·다진마늘·설탕·식초·소금
            </b>
            을 모두 넣어 손으로 골고루 무쳐주세요. 너무 세게 누르지 않는 것이
            포인트!
          </div>

          <div
            style={{
              marginTop: 16,
              padding: "12px 14px",
              background: "#fff",
              borderRadius: 12,
              border: `1px solid ${t.borderSoft}`,
              display: "flex",
              alignItems: "center",
              gap: 10,
            }}
          >
            <span style={{ fontSize: 20 }}>💡</span>
            <span
              style={{
                fontSize: 12.5,
                color: t.textMid,
                lineHeight: 1.5,
                flex: 1,
              }}
            >
              <b style={{ color: t.text }}>TIP</b> · 식초는 마지막에 넣어야 무가
              무르지 않아요
            </span>
          </div>
        </div>

        <div style={{ height: 120 }} />
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
            width: 72,
            height: 52,
            borderRadius: 14,
            border: `1.5px solid ${t.border}`,
            background: "#fff",
            color: t.textMid,
            fontSize: 14,
            fontWeight: 700,
          }}
        >
          ← 이전
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
          다음 →
        </button>
      </div>
    </Phone>
  );
}

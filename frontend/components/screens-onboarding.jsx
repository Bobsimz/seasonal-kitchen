// Onboarding screens

import React from "react";
import { Phone, PHONE_H, AppHeader, Chip, priceRange } from "./phone";
import { DISH_IMG, vegImg } from "./mock-images";
import { PRODUCERS } from "./producers-data";
import { ProducerFeatureCard } from "./producer-card";

// 온보딩 제목 전용 폰트 (본문은 Pretendard 유지)
const TITLE_FONT =
  "'Gmarket Sans', Pretendard, -apple-system, system-ui, sans-serif";

export function ScreenSplash({ t }) {
  return (
    <Phone t={t} hideStatus hideHomeIndicator>
      <div
        style={{
          flex: 1,
          minHeight: PHONE_H,
          background: `linear-gradient(180deg, ${t.primary} 0%, ${t.primaryDark} 100%)`,
          display: "flex",
          flexDirection: "column",
          alignItems: "center",
          justifyContent: "center",
          color: "#fff",
          padding: 32,
        }}
      >
        <div
          style={{
            width: 88,
            height: 88,
            borderRadius: 24,
            background: "rgba(255,255,255,0.15)",
            backdropFilter: "blur(10px)",
            display: "grid",
            placeItems: "center",
            fontSize: 44,
            marginBottom: 24,
            border: "1.5px solid rgba(255,255,255,0.25)",
          }}
        >
          <svg
            width="65"
            className="mt-2"
            height="65"
            viewBox="0 0 48 48"
            fill="none"
          >
            {/* 셰프 모자 */}
            <path
              d="M24 6c-3.6 0-6.5 2.7-6.5 6.3 0 0-5.5 0-8.3 4.5-2.7 4.5 0 9.9 4.6 12.6-0.9 5.4 2.7 9 10.2 9s11.1-3.6 10.2-9c4.6-2.7 7.3-8.1 4.6-12.6-2.8-4.5-8.3-4.5-8.3-4.5 0-3.6-2.9-6.3-6.5-6.3z"
              fill="#fff"
              stroke="#fff"
              strokeWidth="1.2"
              strokeLinejoin="round"
            />
            {/* 눈 */}
            <circle cx="19" cy="24" r="1.8" fill={t.primary} />
            <circle cx="29" cy="24" r="1.8" fill={t.primary} />
            {/* 입 (웃는) */}
            <path
              d="M19 30c1.7 2.4 8.3 2.4 10 0"
              stroke={t.primary}
              strokeWidth="2.2"
              strokeLinecap="round"
              fill="none"
            />
          </svg>
        </div>
        <div
          style={{
            fontFamily: TITLE_FONT,
            fontSize: 32,
            fontWeight: 700,
            letterSpacing: -1,
            marginBottom: 8,
          }}
        >
          제철식탁
        </div>
        <div style={{ fontSize: 15, opacity: 0.85, letterSpacing: -0.2 }}>
          오늘 가장 알뜰한 식재료
        </div>
      </div>
    </Phone>
  );
}

export function ScreenOnboard({ t }) {
  return (
    <Phone t={t} hideStatus={false}>
      <div
        style={{
          flex: 1,
          padding: "60px 24px 24px",
          display: "flex",
          flexDirection: "column",
        }}
      >
        <div
          style={{
            fontFamily: TITLE_FONT,
            paddingTop: 24,
            fontSize: 28,
            fontWeight: 700,
            letterSpacing: -1,
            lineHeight: 1.25,
            color: t.text,
          }}
        >
          제철 식재료를 직접 키우는
          <br />
          <span style={{ color: t.primary }}>다양한 농가</span>를 만나요
        </div>
        <div
          style={{
            marginTop: 12,
            fontSize: 14,
            color: t.textMid,
            lineHeight: 1.55,
          }}
        >
          저렴이부터 프리미엄·유기농까지, <br />
          내 기호에 맞는 농가의 재료를 골라보세요.
        </div>

        {/* Hero stack of veg cards — centered scatter in a fixed-size stage */}
        <div
          style={{
            flex: 1,
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            marginTop: 12,
            marginBottom: 12,
          }}
        >
          <div style={{ position: "relative", width: 304, height: 358 }}>
            {[
              { p: PRODUCERS[2], x: 0, y: 0, rot: -7 }, // value · 김상도
              { p: PRODUCERS[3], x: 170, y: 18, rot: 6 }, // premium · 박정후
              { p: PRODUCERS[4], x: 4, y: 198, rot: 5 }, // organic · 이수향
              { p: PRODUCERS[0], x: 168, y: 212, rot: -6 }, // premium · 권민성
            ].map((c, i) => (
              <div
                key={i}
                style={{
                  position: "absolute",
                  left: c.x,
                  top: c.y,
                  transform: `rotate(${c.rot}deg)`,
                }}
              >
                <ProducerFeatureCard producer={c.p} t={t} width={134} />
              </div>
            ))}
          </div>
        </div>

        {/* Dots */}
        <div
          style={{
            display: "flex",
            gap: 6,
            justifyContent: "center",
            marginBottom: 16,
          }}
        >
          <div
            style={{
              width: 22,
              height: 6,
              borderRadius: 3,
              background: t.primary,
            }}
          />
          <div
            style={{
              width: 6,
              height: 6,
              borderRadius: 3,
              background: t.borderSoft,
            }}
          />
          <div
            style={{
              width: 6,
              height: 6,
              borderRadius: 3,
              background: t.borderSoft,
            }}
          />
        </div>

        <button
          className="tap"
          style={{
            width: "100%",
            height: 56,
            borderRadius: 16,
            border: "none",
            background: t.primary,
            color: "#fff",
            fontSize: 16,
            fontWeight: 700,
            letterSpacing: -0.3,
          }}
        >
          다음
        </button>
        <div
          style={{
            textAlign: "center",
            marginTop: 14,
            fontSize: 13,
            color: t.textSoft,
          }}
        >
          이미 계정이 있어요 ·{" "}
          <span style={{ color: t.primary, fontWeight: 600 }}>로그인</span>
        </div>
      </div>
    </Phone>
  );
}

export function ScreenSignup({ t }) {
  return (
    <Phone t={t}>
      <AppHeader t={t} title="가입하고 시작하기" leftBack />
      <div
        style={{ flex: 1, padding: "20px 22px", overflow: "auto" }}
        className="phone-scroll"
      >
        <div
          style={{
            fontFamily: TITLE_FONT,
            fontSize: 22,
            fontWeight: 700,
            color: t.text,
            letterSpacing: -0.6,
            lineHeight: 1.3,
          }}
        >
          간편하게 시작하고
          <br />
          맞춤 추천을 받아보세요
        </div>
        <div style={{ marginTop: 6, fontSize: 13, color: t.textMid }}>
          가격 알림 · 찜한 재료 추천 · 개인화된 레시피
        </div>

        <div
          style={{
            marginTop: 28,
            display: "flex",
            flexDirection: "column",
            gap: 10,
          }}
        >
          {[
            {
              label: "카카오로 3초만에 시작",
              bg: "#FEE500",
              color: "#191919",
              icon: " ",
            },
            { label: "Apple로 계속", bg: "#000", color: "#fff", icon: " " },
            {
              label: "구글로 계속",
              bg: "#fff",
              color: "#202124",
              border: "1px solid #E5E5E7",
              icon: " ",
            },
          ].map((b, i) => (
            <button
              key={i}
              className="tap"
              style={{
                height: 54,
                borderRadius: 14,
                border: b.border || "none",
                background: b.bg,
                color: b.color,
                fontSize: 15,
                fontWeight: 700,
                letterSpacing: -0.3,
                display: "flex",
                alignItems: "center",
                justifyContent: "center",
                gap: 8,
              }}
            >
              {b.icon === "G" ? (
                <div
                  style={{
                    width: 18,
                    height: 18,
                    borderRadius: 9,
                    background:
                      "conic-gradient(from 0deg, #4285F4, #34A853, #FBBC04, #EA4335)",
                  }}
                />
              ) : b.icon ? (
                <span style={{ fontSize: 16 }}>{b.icon}</span>
              ) : (
                <svg width="14" height="16" viewBox="0 0 14 16" fill="#fff">
                  <path d="M9.4 0c.1 1-.3 2-1 2.7-.7.8-1.7 1.3-2.7 1.2 0-1 .4-2 1-2.7C7.4.5 8.4 0 9.4 0zm3.4 11.9c-.5 1.1-.7 1.6-1.4 2.6-.9 1.4-2.2 3.1-3.8 3.1-1.4 0-1.8-.9-3.7-.9-1.9 0-2.3.9-3.7.9-1.6 0-2.8-1.5-3.7-2.9C-2 12-2.5 7.5-.6 5c1.3-1.7 3.4-2.7 5.4-2.7 1.8 0 3 1 4.5 1 1.5 0 2.4-1 4.5-1 1.6 0 3.3.9 4.5 2.4-4 2.2-3.3 7.8-1.5 7.2z" />
                </svg>
              )}
              {b.label}
            </button>
          ))}
        </div>

        <div
          style={{
            display: "flex",
            alignItems: "center",
            gap: 10,
            margin: "24px 0",
            color: t.textSoft,
            fontSize: 12,
          }}
        >
          <div style={{ flex: 1, height: 1, background: t.borderSoft }} />
          또는
          <div style={{ flex: 1, height: 1, background: t.borderSoft }} />
        </div>

        <button
          className="tap"
          style={{
            width: "100%",
            height: 50,
            borderRadius: 14,
            border: `1.5px solid ${t.border}`,
            background: "#fff",
            fontSize: 14,
            fontWeight: 600,
            color: t.textMid,
          }}
        >
          이메일로 가입
        </button>

        <div
          style={{
            marginTop: 28,
            fontSize: 11.5,
            color: t.textSoft,
            lineHeight: 1.5,
            textAlign: "center",
          }}
        >
          가입 시{" "}
          <span style={{ color: t.text, fontWeight: 600 }}>이용약관</span>과{" "}
          <span style={{ color: t.text, fontWeight: 600 }}>
            개인정보처리방침
          </span>
          에 동의합니다
        </div>
      </div>
    </Phone>
  );
}

// ─────────────────────────────────────────────────────────────
// Signup Survey — 가입 직후 1회 받는 맞춤 추천용 설문
//   ① 가구수  ② 매운 음식 비선호  ③ 알레르기 정보
// ─────────────────────────────────────────────────────────────
export function ScreenSignupSurvey({ t }) {
  const households = ["1인", "2인", "3인", "4인 이상"];
  const selectedHousehold = "2인";
  const spicyAvoid = true;
  const allergens = [
    "난류",
    "우유",
    "메밀",
    "땅콩",
    "대두",
    "밀",
    "고등어",
    "게",
    "새우",
    "돼지고기",
    "복숭아",
    "토마토",
    "호두",
    "닭고기",
    "쇠고기",
    "오징어",
    "조개류",
    "잣",
  ];
  const selectedAllergens = new Set(["새우", "땅콩"]);

  return (
    <Phone t={t}>
      <AppHeader
        t={t}
        title="가입하고 시작하기"
        leftBack
        rightIcons={
          <div
            className="tap"
            style={{
              fontSize: 13,
              fontWeight: 600,
              color: t.textSoft,
              padding: "6px 4px",
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
        <div style={{ padding: "20px 22px 24px" }}>
          {/* progress */}
          <div style={{ display: "flex", gap: 4, marginBottom: 18 }}>
            {[0, 1].map((i) => (
              <div
                key={i}
                style={{
                  flex: 1,
                  height: 4,
                  borderRadius: 2,
                  background: t.primary,
                }}
              />
            ))}
          </div>

          <div
            style={{
              fontFamily: TITLE_FONT,
              fontSize: 22,
              fontWeight: 700,
              color: t.text,
              letterSpacing: -0.6,
              lineHeight: 1.3,
            }}
          >
            조금만 더 알려주세요
          </div>
          <div style={{ marginTop: 6, fontSize: 13, color: t.textMid }}>
            가구·취향·알레르기에 맞춰 추천해드려요
          </div>

          {/* ① 가구수 */}
          <div style={{ marginTop: 28 }}>
            <div
              style={{
                fontSize: 14,
                fontWeight: 700,
                color: t.text,
                letterSpacing: -0.3,
              }}
            >
              가구원 수
            </div>
            <div style={{ marginTop: 4, fontSize: 12, color: t.textSoft }}>
              5일치 메뉴와 식재료 양을 맞추는 데 써요
            </div>
            <div
              style={{
                marginTop: 12,
                display: "flex",
                gap: 6,
                background: t.bgSoft,
                padding: 4,
                borderRadius: 12,
              }}
            >
              {households.map((h) => {
                const active = h === selectedHousehold;
                return (
                  <div
                    key={h}
                    className="tap"
                    style={{
                      flex: 1,
                      height: 40,
                      borderRadius: 9,
                      display: "grid",
                      placeItems: "center",
                      fontSize: 13,
                      fontWeight: active ? 700 : 500,
                      color: active ? t.text : t.textMid,
                      background: active ? "#fff" : "transparent",
                      boxShadow: active
                        ? "0 1px 3px rgba(20,40,30,0.08)"
                        : "none",
                      letterSpacing: -0.3,
                    }}
                  >
                    {h}
                  </div>
                );
              })}
            </div>
          </div>

          {/* ② 매운 음식 비선호 */}
          <div
            style={{
              marginTop: 24,
              padding: "14px 16px",
              borderRadius: 12,
              border: `1px solid ${t.borderSoft}`,
              background: "#fff",
              display: "flex",
              alignItems: "center",
              gap: 12,
            }}
          >
            <div style={{ flex: 1, minWidth: 0 }}>
              <div
                style={{
                  fontSize: 14,
                  fontWeight: 700,
                  color: t.text,
                  letterSpacing: -0.3,
                }}
              >
                매운 음식은 빼주세요
              </div>
              <div style={{ marginTop: 2, fontSize: 12, color: t.textSoft }}>
                고추·청양·매운 양념 레시피를 추천에서 제외
              </div>
            </div>
            {/* iOS-style toggle */}
            <div
              className="tap"
              style={{
                position: "relative",
                width: 44,
                height: 26,
                borderRadius: 999,
                background: spicyAvoid ? t.primary : t.borderSoft,
                transition: "background 0.15s",
                flexShrink: 0,
              }}
            >
              <div
                style={{
                  position: "absolute",
                  top: 2,
                  left: spicyAvoid ? 20 : 2,
                  width: 22,
                  height: 22,
                  borderRadius: 11,
                  background: "#fff",
                  boxShadow: "0 1px 3px rgba(0,0,0,0.18)",
                  transition: "left 0.15s",
                }}
              />
            </div>
          </div>

          {/* ③ 알레르기 정보 */}
          <div style={{ marginTop: 24 }}>
            <div
              style={{
                display: "flex",
                alignItems: "baseline",
                justifyContent: "space-between",
              }}
            >
              <div
                style={{
                  fontSize: 14,
                  fontWeight: 700,
                  color: t.text,
                  letterSpacing: -0.3,
                }}
              >
                알레르기
              </div>
              <div style={{ fontSize: 11.5, color: t.textSoft }}>해당 없음</div>
            </div>
            <div style={{ marginTop: 4, fontSize: 12, color: t.textSoft }}>
              선택한 재료가 들어간 레시피는 추천에서 제외돼요
            </div>
            <div
              style={{
                marginTop: 12,
                display: "flex",
                flexWrap: "wrap",
                gap: 8,
              }}
            >
              {allergens.map((a) => {
                const on = selectedAllergens.has(a);
                return (
                  <div
                    key={a}
                    className="tap"
                    style={{
                      padding: "8px 14px",
                      borderRadius: 999,
                      fontSize: 13,
                      fontWeight: on ? 700 : 500,
                      letterSpacing: -0.3,
                      color: on ? t.primaryDark : t.textMid,
                      background: on ? t.primaryBg : "#fff",
                      border: on
                        ? `1px solid ${t.primary}`
                        : `1px solid ${t.borderSoft}`,
                    }}
                  >
                    {a}
                  </div>
                );
              })}
            </div>
            <div
              style={{
                marginTop: 10,
                fontSize: 11.5,
                color: t.textSoft,
                lineHeight: 1.5,
              }}
            >
              {selectedAllergens.size}개 선택됨 · 마이페이지에서 언제든 변경할
              수 있어요
            </div>
          </div>

          <div style={{ height: 16 }} />

          <button
            className="tap"
            style={{
              width: "100%",
              height: 54,
              borderRadius: 14,
              border: "none",
              background: t.primary,
              color: "#fff",
              fontSize: 15,
              fontWeight: 800,
              letterSpacing: -0.3,
            }}
          >
            시작하기
          </button>
          <div
            style={{
              textAlign: "center",
              marginTop: 12,
              fontSize: 12.5,
              color: t.textSoft,
            }}
          >
            나중에 입력할게요
          </div>
        </div>
      </div>
    </Phone>
  );
}

// ─────────────────────────────────────────────────────────────
// Onboard 2 — 제철 음식 트렌드 (요즘 뜨는 제철 음식)
//   요즘 SNS·유튜브에서 가장 많이 언급되는 제철 음식 보여주기
// ─────────────────────────────────────────────────────────────
export function ScreenOnboard2({ t }) {
  const cards = [
    {
      title: "봄동 비빔밥",
      user: "쿠킹맘",
      views: "124만",
      badge: "HOT",
      badgeColor: t.hot,
      x: 0,
      y: 18,
      rot: -7,
      bg: "#3e4d30",
      img: DISH_IMG.봄동비빔밥,
    },
    {
      title: "배추전",
      user: "안성재",
      views: "89만",
      badge: "트렌드",
      badgeColor: t.warning,
      x: 170,
      y: 0,
      rot: 6,
      bg: "#3e4d30",
      img: DISH_IMG.배추전,
    },
    {
      title: "시금치 페스토",
      user: "에밀리",
      views: "41만",
      badge: "신상",
      badgeColor: t.primary,
      x: 4,
      y: 198,
      rot: 5,
      bg: "#2d4a30",
      img: DISH_IMG.시금치페스토,
    },
    {
      title: "깍두기",
      user: "백종원",
      views: "62만",
      badge: "인기",
      badgeColor: t.info,
      x: 168,
      y: 214,
      rot: -6,
      bg: "#5a3b2c",
      img: DISH_IMG.깍두기,
    },
  ];
  return (
    <Phone t={t} hideStatus={false}>
      <div
        style={{
          flex: 1,
          padding: "60px 24px 24px",
          display: "flex",
          flexDirection: "column",
        }}
      >
        <div
          style={{
            fontFamily: TITLE_FONT,
            paddingTop: 24,
            fontSize: 28,
            fontWeight: 700,
            letterSpacing: -1,
            lineHeight: 1.25,
            color: t.text,
          }}
        >
          요즘 뜨는
          <br />
          <span style={{ color: t.primary }}>제철 음식</span>이 뭔지
          <br />
          궁금하다면
        </div>
        <div
          style={{
            marginTop: 12,
            fontSize: 14,
            color: t.textMid,
            lineHeight: 1.55,
          }}
        >
          SNS · 유튜브에서 가장 많이 언급된 재료와
          <br />
          트렌드 레시피를 매주 모아 보여드려요.
        </div>

        {/* Hero — trending recipe scatter */}
        <div
          style={{
            flex: 1,
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            marginTop: 12,
            marginBottom: 12,
          }}
        >
          <div style={{ position: "relative", width: 304, height: 358 }}>
            {cards.map((c, i) => (
              <div
                key={i}
                style={{
                  position: "absolute",
                  left: c.x,
                  top: c.y,
                  transform: `rotate(${c.rot}deg)`,
                  width: 134,
                  height: 188,
                  borderRadius: 18,
                  overflow: "hidden",
                  background: c.bg,
                  boxShadow: "0 8px 28px rgba(20,40,30,0.18)",
                }}
              >
                <div
                  style={{
                    position: "absolute",
                    inset: 0,
                    backgroundImage: `url(${c.img})`,
                    backgroundSize: "cover",
                    backgroundPosition: "center",
                  }}
                />
                <div
                  style={{
                    position: "absolute",
                    inset: 0,
                    background:
                      "linear-gradient(180deg, rgba(0,0,0,0.15) 0%, rgba(0,0,0,0.55) 100%)",
                  }}
                />
                <div
                  style={{
                    position: "absolute",
                    top: 8,
                    left: 8,
                    padding: "3px 8px",
                    borderRadius: 5,
                    background: c.badgeColor,
                    color: "#fff",
                    fontWeight: 800,
                    fontSize: 9.5,
                    letterSpacing: 0.3,
                    boxShadow: `0 2px 6px ${c.badgeColor}66`,
                  }}
                >
                  {c.badge}
                </div>
                <div
                  style={{
                    position: "absolute",
                    top: "50%",
                    left: "50%",
                    transform: "translate(-50%,-50%)",
                    width: 28,
                    height: 28,
                    borderRadius: 14,
                    background: "rgba(255,255,255,0.25)",
                    backdropFilter: "blur(6px)",
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
                    padding: "14px 10px 10px",
                    background:
                      "linear-gradient(180deg, transparent, rgba(0,0,0,0.85))",
                    color: "#fff",
                  }}
                >
                  <div
                    style={{
                      fontSize: 12,
                      fontWeight: 800,
                      letterSpacing: -0.2,
                      lineHeight: 1.2,
                    }}
                  >
                    {c.title}
                  </div>
                  <div style={{ fontSize: 10, opacity: 0.85, marginTop: 3 }}>
                    @{c.user}
                  </div>
                  <div
                    style={{
                      fontSize: 10,
                      fontWeight: 700,
                      marginTop: 4,
                      color: "#FFB7A7",
                    }}
                  >
                    ♥ {c.views}
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Dots */}
        <div
          style={{
            display: "flex",
            gap: 6,
            justifyContent: "center",
            marginBottom: 16,
          }}
        >
          <div
            style={{
              width: 6,
              height: 6,
              borderRadius: 3,
              background: t.borderSoft,
            }}
          />
          <div
            style={{
              width: 22,
              height: 6,
              borderRadius: 3,
              background: t.primary,
            }}
          />
          <div
            style={{
              width: 6,
              height: 6,
              borderRadius: 3,
              background: t.borderSoft,
            }}
          />
        </div>

        <button
          className="tap"
          style={{
            width: "100%",
            height: 56,
            borderRadius: 16,
            border: "none",
            background: t.primary,
            color: "#fff",
            fontSize: 16,
            fontWeight: 700,
            letterSpacing: -0.3,
          }}
        >
          다음
        </button>
        <div
          style={{
            textAlign: "center",
            marginTop: 14,
            fontSize: 13,
            color: t.textSoft,
          }}
        >
          이미 계정이 있어요 ·{" "}
          <span style={{ color: t.primary, fontWeight: 600 }}>로그인</span>
        </div>
      </div>
    </Phone>
  );
}

// ─────────────────────────────────────────────────────────────
// Onboard 3 — AI 셰프 소개 (요리가 어렵다구요?)
//   대화 한 줄로 장보기·메뉴 추천이 완성되는 데모
// ─────────────────────────────────────────────────────────────
export function ScreenOnboard3({ t }) {
  return (
    <Phone t={t} hideStatus={false}>
      <div
        style={{
          flex: 1,
          padding: "60px 24px 24px",
          display: "flex",
          flexDirection: "column",
        }}
      >
        <div
          style={{
            fontFamily: TITLE_FONT,
            paddingTop: 24,
            fontSize: 28,
            fontWeight: 700,
            letterSpacing: -1,
            lineHeight: 1.25,
            color: t.text,
          }}
        >
          요리가 어렵다구요?
          <br />
          <span style={{ color: t.primary }}>AI 셰프</span>와 함께하세요
        </div>
        <div
          style={{
            marginTop: 12,
            fontSize: 14,
            color: t.textMid,
            lineHeight: 1.55,
          }}
        >
          예산 · 인원 · 취향만 알려주시면 5분 만에
          <br />
          이번 주 장바구니와 5일치 메뉴까지 짜드려요.
        </div>

        {/* Hero — chat conversation mock */}
        <div
          style={{
            flex: 1,
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            marginTop: 12,
            marginBottom: 12,
          }}
        >
          <div style={{ position: "relative", width: 304, height: 358 }}>
            {/* User bubble */}
            <div
              style={{
                position: "absolute",
                right: 0,
                top: 18,
                maxWidth: 300,
                width: 180,
                padding: "12px 14px",
                borderRadius: "18px 18px 4px 18px",
                background: t.primary,
                color: "#fff",
                fontSize: 13,
                fontWeight: 600,
                lineHeight: 1.45,
                boxShadow: "0 6px 18px rgba(20,40,30,0.18)",
              }}
            >
              5일치 2인 가족,
              <br />
              가성비 위주로 짜줘
            </div>

            {/* AI avatar + bubble */}
            <div
              style={{
                position: "absolute",
                left: 0,
                top: 102,
                display: "flex",
                alignItems: "flex-start",
                gap: 10,
                maxWidth: 270,
              }}
            >
              <div
                style={{
                  width: 40,
                  height: 40,
                  borderRadius: 20,
                  background: `linear-gradient(135deg, ${t.primary}, ${t.primaryDark})`,
                  display: "grid",
                  placeItems: "center",
                  fontSize: 20,
                  flexShrink: 0,
                  boxShadow: `0 6px 18px ${t.primary}55`,
                }}
              >
                🧑‍🍳
              </div>
              <div
                style={{
                  padding: "12px 14px",
                  borderRadius: "18px 18px 18px 4px",
                  background: "#fff",
                  fontSize: 13,
                  color: t.text,
                  lineHeight: 1.45,
                  border: `1px solid ${t.borderSoft}`,
                  boxShadow: "0 6px 18px rgba(20,40,30,0.10)",
                }}
              >
                <b style={{ color: t.primary }}>제철 무·배추</b>가<br />
                평년 -22%라 활용하기 딱이에요!
              </div>
            </div>

            {/* Generated cart card */}
            <div
              style={{
                position: "absolute",
                left: 14,
                right: 0,
                bottom: 70,
                background: t.text,
                color: "#fff",
                borderRadius: 16,
                padding: "12px 14px",
                display: "flex",
                alignItems: "center",
                gap: 10,
                boxShadow: "0 12px 28px rgba(20,40,30,0.28)",
              }}
            >
              <div
                style={{
                  width: 38,
                  height: 38,
                  borderRadius: 11,
                  background: "rgba(255,255,255,0.15)",
                  display: "grid",
                  placeItems: "center",
                  fontSize: 19,
                  flexShrink: 0,
                }}
              >
                🛒
              </div>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div
                  style={{
                    fontSize: 10,
                    fontWeight: 800,
                    color: t.primary,
                    letterSpacing: 0.5,
                  }}
                >
                  AI 셰프가 완성한
                </div>
                <div
                  style={{
                    fontSize: 13,
                    fontWeight: 800,
                    letterSpacing: -0.2,
                    marginTop: 1,
                  }}
                >
                  식재료 9개 · ₩{priceRange(38400)}
                </div>
                <div style={{ fontSize: 10.5, opacity: 0.7, marginTop: 2 }}>
                  쿠팡 · 마켓컬리 자동 분배
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Dots */}
        <div
          style={{
            display: "flex",
            gap: 6,
            justifyContent: "center",
            marginBottom: 16,
          }}
        >
          <div
            style={{
              width: 6,
              height: 6,
              borderRadius: 3,
              background: t.borderSoft,
            }}
          />
          <div
            style={{
              width: 6,
              height: 6,
              borderRadius: 3,
              background: t.borderSoft,
            }}
          />
          <div
            style={{
              width: 22,
              height: 6,
              borderRadius: 3,
              background: t.primary,
            }}
          />
        </div>

        <button
          className="tap"
          style={{
            width: "100%",
            height: 56,
            borderRadius: 16,
            border: "none",
            background: t.primary,
            color: "#fff",
            fontSize: 16,
            fontWeight: 700,
            letterSpacing: -0.3,
          }}
        >
          시작하기
        </button>
        <div
          style={{
            textAlign: "center",
            marginTop: 14,
            fontSize: 13,
            color: t.textSoft,
          }}
        >
          이미 계정이 있어요 ·{" "}
          <span style={{ color: t.primary, fontWeight: 600 }}>로그인</span>
        </div>
      </div>
    </Phone>
  );
}

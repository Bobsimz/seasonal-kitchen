// MyPage, Notifications, Wishlist, Order checkout

import React from "react";
import { Phone, BottomTabBar, AppHeader, VegPlaceholder, Chip, priceRange } from "./phone";
import { FACE_IMG } from "./mock-images";
import { PriceBadge } from "./screens-home";

// ─────────────────────────────────────────────────────────────
// MyPage
// ─────────────────────────────────────────────────────────────
export function ScreenMyPage({ t }) {
  return (
    <Phone t={t} tabBar={<BottomTabBar active="my" t={t} />}>
      <div
        className="phone-scroll"
        style={{ flex: 1, overflow: "auto", background: t.bg }}
      >
        {/* Header */}
        <div
          style={{
            paddingTop: 52,
            padding: "52px 20px 20px",
            background: "#fff",
            borderBottom: `1px solid ${t.borderSoft}`,
          }}
        >
          <div
            style={{
              display: "flex",
              alignItems: "center",
              justifyContent: "space-between",
              marginBottom: 18,
            }}
          >
            <div
              style={{
                fontSize: 21,
                fontWeight: 800,
                color: t.text,
                letterSpacing: -0.5,
              }}
            >
              마이페이지
            </div>
            <div style={{ display: "flex", gap: 6 }}>
              <div
                className="tap"
                style={{
                  width: 32,
                  height: 32,
                  display: "grid",
                  placeItems: "center",
                }}
              ></div>
            </div>
          </div>
          <div style={{ display: "flex", alignItems: "center", gap: 12 }}>
            <div
              style={{
                width: 60,
                height: 60,
                borderRadius: 30,
                backgroundImage: `url(${FACE_IMG.me})`,
                backgroundSize: "cover",
                backgroundPosition: "center",
                border: `2px solid ${t.primary}`,
              }}
            />
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 16, fontWeight: 800, color: t.text }}>
                민지님
              </div>
              <div style={{ fontSize: 12, color: t.textSoft, marginTop: 2 }}>
                가입 38일 · 절약 ₩{priceRange(67800)}
              </div>
            </div>
            <div
              className="tap"
              style={{
                padding: "7px 12px",
                borderRadius: 999,
                border: `1px solid ${t.border}`,
                fontSize: 12,
                fontWeight: 700,
                color: t.textMid,
              }}
            >
              프로필 수정
            </div>
          </div>

          {/* Stats */}
          <div
            style={{
              display: "grid",
              gridTemplateColumns: "1fr 1fr 1fr",
              gap: 6,
              marginTop: 18,
            }}
          >
            {[
              { n: "12", l: "찜한 재료" },
              { n: "34", l: "저장 레시피" },
              { n: "5", l: "진행중 알림" },
            ].map((s, i) => (
              <div
                key={i}
                style={{
                  padding: "12px 8px",
                  borderRadius: 12,
                  background: t.bgSoft,
                  textAlign: "center",
                }}
              >
                <div
                  style={{
                    fontSize: 18,
                    fontWeight: 800,
                    color: t.text,
                    fontFeatureSettings: '"tnum"',
                  }}
                >
                  {s.n}
                </div>
                <div style={{ fontSize: 11, color: t.textSoft, marginTop: 2 }}>
                  {s.l}
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* 가격 하락 알림 active */}
        <div style={{ padding: "14px 16px 0" }}>
          <div
            style={{
              borderRadius: 18,
              padding: 16,
              background: `linear-gradient(135deg, ${t.primary}, ${t.primaryDark})`,
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
                fontSize: 80,
                opacity: 0.15,
              }}
            >
              🔔
            </div>
            <div
              style={{
                fontSize: 12,
                fontWeight: 800,
                opacity: 0.9,
                letterSpacing: 0.5,
              }}
            >
              개인화 맞춤 추천 · 5건
            </div>
            <div
              style={{
                fontSize: 17,
                fontWeight: 800,
                marginTop: 4,
                letterSpacing: -0.4,
              }}
            >
              찜한 <b>배추</b>가 22% 떨어졌어요
            </div>
            <div style={{ fontSize: 11.5, marginTop: 4, opacity: 0.9 }}>
              지금 사러 가기 · 평년 -22%
            </div>
          </div>
        </div>

        {/* My picks (wishlist) */}
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
              내가 찜한 재료
            </div>
            <span style={{ fontSize: 12, color: t.primary, fontWeight: 700 }}>
              전체 →
            </span>
          </div>
          <div
            style={{ display: "flex", gap: 8, overflowX: "auto" }}
            className="phone-scroll"
          >
            {[
              { name: "무", d: "-15%", dn: true },
              { name: "배추", d: "-22%", dn: true },
              { name: "감귤", d: "+12%", dn: false },
              { name: "대파", d: "+18%", dn: false },
              { name: "시금치", d: "-8%", dn: true },
            ].map((c, i) => (
              <div
                key={i}
                style={{
                  width: 90,
                  flexShrink: 0,
                  padding: 10,
                  borderRadius: 14,
                  background: "#fff",
                  border: `1px solid ${t.borderSoft}`,
                  textAlign: "center",
                }}
              >
                <VegPlaceholder name={c.name} size={70} t={t} />
                <div
                  style={{
                    fontSize: 12.5,
                    fontWeight: 700,
                    color: t.text,
                    marginTop: 6,
                  }}
                >
                  {c.name}
                </div>
                <div style={{ marginTop: 3 }}>
                  <PriceBadge trend={c.dn ? "down" : "up"} value={c.d} t={t} />
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Menu rows */}
        <div style={{ padding: "20px 16px 0" }}>
          <div
            style={{
              background: "#fff",
              borderRadius: 18,
              border: `1px solid ${t.borderSoft}`,
              overflow: "hidden",
            }}
          >
            {[
              { ic: "🔔", label: "가격 알림 설정", sub: "5건 활성" },
              { ic: "🌱", label: "제철 캘린더", sub: "11월 알림" },
            ].map((r, i, arr) => (
              <div
                key={i}
                className="tap"
                style={{
                  display: "flex",
                  alignItems: "center",
                  gap: 12,
                  padding: "14px 16px",
                  borderBottom:
                    i < arr.length - 1 ? `1px solid ${t.borderSoft}` : "none",
                }}
              >
                <div
                  style={{
                    width: 36,
                    height: 36,
                    borderRadius: 11,
                    background: t.bgSoft,
                    display: "grid",
                    placeItems: "center",
                    fontSize: 18,
                  }}
                >
                  {r.ic}
                </div>
                <div style={{ flex: 1 }}>
                  <div style={{ fontSize: 14, fontWeight: 700, color: t.text }}>
                    {r.label}
                  </div>
                  <div
                    style={{ fontSize: 11.5, color: t.textSoft, marginTop: 2 }}
                  >
                    {r.sub}
                  </div>
                </div>
                {r.tag && (
                  <Chip color={t.primary} bg={t.primaryBg}>
                    {r.tag}
                  </Chip>
                )}
                <svg width="14" height="14" viewBox="0 0 14 14">
                  <path
                    d="M5 3l4 4-4 4"
                    stroke={t.textSoft}
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

        <div style={{ height: 24 }} />
      </div>
    </Phone>
  );
}

// ─────────────────────────────────────────────────────────────
// Notifications
// ─────────────────────────────────────────────────────────────
export function ScreenAlerts({ t }) {
  const groups = [
    {
      date: "오늘",
      items: [
        {
          ic: "📉",
          color: t.primary,
          bg: t.primaryBg,
          title: "찜한 배추 가격 하락",
          sub: `평년 대비 -22% · 쿠팡 ₩${priceRange(2890)}`,
          time: "1시간 전",
          new: true,
        },
        {
          ic: "🌱",
          color: t.primary,
          bg: t.primaryBg,
          title: "11월 제철 식재료가 시작됐어요",
          sub: "무·배추·감귤·시금치 외 8개",
          time: "5시간 전",
          new: true,
        },
        {
          ic: "🔥",
          color: t.hot,
          bg: t.hotBg,
          title: "대파 가격 급등 ⚠",
          sub: "+18% · 다음 주 추가 상승 전망",
          time: "오전 9:12",
        },
      ],
    },
    {
      date: "어제",
      items: [
        {
          ic: "🎬",
          color: t.text,
          bg: t.bgSoft,
          title: "@쿠킹맘님의 새 레시피",
          sub: "1분만에 봄동 비빔밥",
          time: "20:14",
        },
        {
          ic: "✨",
          color: t.primary,
          bg: t.primaryBg,
          title: "AI 추천 결과가 준비됐어요",
          sub: `이번 주 식재료 9개 · ₩${priceRange(38400)}`,
          time: "18:02",
        },
      ],
    },
    {
      date: "이번 주",
      items: [
        {
          ic: "🛒",
          color: t.text,
          bg: t.bgSoft,
          title: "장보기 추천 받아보세요",
          sub: "자취생 만원으로 살아남기 장보기 추천",
          time: "11/9",
        },
        {
          ic: "💸",
          color: t.warning,
          bg: t.warningBg,
          title: "마켓컬리 신규 할인 정보 도착",
          sub: "마켓컬리 3만원 이상 구매 시, ₩5,000 할인",
          time: "11/8",
        },
      ],
    },
  ];
  return (
    <Phone t={t}>
      <AppHeader
        t={t}
        title="알림"
        leftBack
        rightIcons={
          <div
            className="tap"
            style={{
              fontSize: 12.5,
              fontWeight: 700,
              color: t.primary,
              padding: "6px 10px",
            }}
          >
            모두 읽음
          </div>
        }
      />
      <div
        className="phone-scroll"
        style={{ flex: 1, overflow: "auto", background: t.bg }}
      >
        {/* Tab */}
        <div
          style={{
            background: "#fff",
            display: "flex",
            gap: 18,
            padding: "8px 22px 0",
            borderBottom: `1px solid ${t.borderSoft}`,
          }}
        >
          {[
            { l: "전체", n: 7, a: true },
            { l: "레시피", n: 2 },
            { l: "재료", n: 2 },
          ].map((tab, i) => (
            <div
              key={i}
              style={{
                padding: "12px 0 10px",
                display: "flex",
                gap: 4,
                alignItems: "center",
                fontSize: 13.5,
                fontWeight: 700,
                color: tab.a ? t.text : t.textSoft,
                borderBottom: tab.a
                  ? `2px solid ${t.primary}`
                  : "2px solid transparent",
              }}
            >
              {tab.l}
              <span
                style={{
                  fontSize: 11,
                  color: tab.a ? t.primary : t.textSoft,
                  fontWeight: 700,
                }}
              >
                {tab.n}
              </span>
            </div>
          ))}
        </div>

        {groups.map((g, gi) => (
          <div key={gi}>
            <div
              style={{
                padding: "16px 20px 6px",
                fontSize: 11.5,
                fontWeight: 700,
                color: t.textSoft,
                letterSpacing: 0.4,
              }}
            >
              {g.date.toUpperCase()}
            </div>
            <div
              style={{
                background: "#fff",
                margin: "0 16px",
                borderRadius: 18,
                border: `1px solid ${t.borderSoft}`,
                overflow: "hidden",
              }}
            >
              {g.items.map((it, i, arr) => (
                <div
                  key={i}
                  className="tap"
                  style={{
                    display: "flex",
                    alignItems: "flex-start",
                    gap: 12,
                    padding: "14px 16px",
                    borderBottom:
                      i < arr.length - 1 ? `1px solid ${t.borderSoft}` : "none",
                    position: "relative",
                  }}
                >
                  <div
                    style={{
                      width: 38,
                      height: 38,
                      borderRadius: 12,
                      background: it.bg,
                      display: "grid",
                      placeItems: "center",
                      fontSize: 18,
                      flexShrink: 0,
                    }}
                  >
                    {it.ic}
                  </div>
                  <div style={{ flex: 1, minWidth: 0 }}>
                    <div
                      style={{
                        fontSize: 13.5,
                        fontWeight: 700,
                        color: t.text,
                        letterSpacing: -0.2,
                      }}
                    >
                      {it.title}
                    </div>
                    <div
                      style={{
                        fontSize: 12,
                        color: t.textMid,
                        marginTop: 3,
                        lineHeight: 1.4,
                      }}
                    >
                      {it.sub}
                    </div>
                    <div
                      style={{ fontSize: 11, color: t.textSoft, marginTop: 4 }}
                    >
                      {it.time}
                    </div>
                  </div>
                  {it.new && (
                    <div
                      style={{
                        width: 7,
                        height: 7,
                        borderRadius: 4,
                        background: t.primary,
                        marginTop: 6,
                      }}
                    />
                  )}
                </div>
              ))}
            </div>
          </div>
        ))}
        <div style={{ height: 30 }} />
      </div>
    </Phone>
  );
}

// ─────────────────────────────────────────────────────────────
// Checkout — 플랫폼별 분배 + 외부 연동
// ─────────────────────────────────────────────────────────────
export function ScreenCheckout({ t }) {
  return (
    <Phone t={t}>
      <AppHeader t={t} title="플랫폼별 주문하기" leftBack />
      <div
        className="phone-scroll"
        style={{ flex: 1, overflow: "auto", background: t.bgSoft }}
      >
        <div style={{ padding: "12px 16px 0" }}>
          <div
            style={{
              background: "#fff",
              borderRadius: 18,
              padding: 16,
              border: `1px solid ${t.borderSoft}`,
            }}
          >
            <div
              style={{
                fontSize: 12,
                fontWeight: 800,
                color: t.primary,
                letterSpacing: 0.4,
              }}
            >
              SMART SPLIT
            </div>
            <div
              style={{
                fontSize: 17,
                fontWeight: 800,
                color: t.text,
                marginTop: 4,
                letterSpacing: -0.4,
              }}
            >
              가장 저렴한 조합으로
              <br />
              2곳에 나눠 담았어요
            </div>
            <div
              style={{
                marginTop: 12,
                padding: "10px 12px",
                borderRadius: 12,
                background: t.primaryBg,
                color: t.primaryDark,
                fontSize: 12,
                fontWeight: 700,
                display: "flex",
                alignItems: "center",
                gap: 6,
              }}
            >
              💰 한 곳에서 살 때보다{" "}
              <b style={{ fontWeight: 800 }}>₩{priceRange(6820)}</b> 절약
            </div>
          </div>
        </div>

        {/* Coupang batch */}
        <div style={{ padding: "14px 16px 0" }}>
          <div
            style={{
              background: "#fff",
              borderRadius: 18,
              overflow: "hidden",
              border: `1px solid ${t.borderSoft}`,
            }}
          >
            <div
              style={{
                display: "flex",
                alignItems: "center",
                gap: 10,
                padding: "14px 16px",
                borderBottom: `1px solid ${t.borderSoft}`,
              }}
            >
              <div
                style={{
                  width: 40,
                  height: 40,
                  borderRadius: 10,
                  background: "#FF5C39",
                  color: "#fff",
                  fontSize: 18,
                  fontWeight: 800,
                  display: "grid",
                  placeItems: "center",
                }}
              >
                C
              </div>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 14.5, fontWeight: 800, color: t.text }}>
                  쿠팡 로켓프레시
                </div>
                <div style={{ fontSize: 11, color: t.textSoft, marginTop: 2 }}>
                  5개 · 내일(목) 도착
                </div>
              </div>
              <div
                style={{
                  fontSize: 15,
                  fontWeight: 800,
                  color: t.text,
                  fontFeatureSettings: '"tnum"',
                }}
              >
                ₩{priceRange(21470)}
              </div>
            </div>
            {[
              { n: "무 1단", p: 1190 },
              { n: "계란 15구", p: 5900 },
              { n: "시금치 200g", p: 1890 },
              { n: "고추장 500g", p: 4990 },
              { n: "배추 1포기", p: 7500 },
            ].map((x, i, arr) => (
              <div
                key={i}
                style={{
                  display: "flex",
                  justifyContent: "space-between",
                  padding: "8px 16px",
                  fontSize: 12.5,
                  color: t.textMid,
                }}
              >
                <span>{x.n}</span>
                <span style={{ fontFeatureSettings: '"tnum"' }}>
                  ₩{priceRange(x.p)}
                </span>
              </div>
            ))}
            <button
              className="tap"
              style={{
                margin: 12,
                padding: "12px",
                borderRadius: 12,
                border: "none",
                background: "#FF5C39",
                color: "#fff",
                width: "calc(100% - 24px)",
                fontSize: 13.5,
                fontWeight: 800,
                display: "flex",
                alignItems: "center",
                justifyContent: "center",
                gap: 6,
              }}
            >
              쿠팡 앱에서 결제하기
              <svg width="14" height="14" viewBox="0 0 14 14">
                <path
                  d="M3 11L11 3M11 3H5M11 3v6"
                  stroke="#fff"
                  strokeWidth="1.7"
                  fill="none"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                />
              </svg>
            </button>
          </div>
        </div>

        {/* Kurly batch */}
        <div style={{ padding: "12px 16px 0" }}>
          <div
            style={{
              background: "#fff",
              borderRadius: 18,
              overflow: "hidden",
              border: `1px solid ${t.borderSoft}`,
            }}
          >
            <div
              style={{
                display: "flex",
                alignItems: "center",
                gap: 10,
                padding: "14px 16px",
                borderBottom: `1px solid ${t.borderSoft}`,
              }}
            >
              <div
                style={{
                  width: 40,
                  height: 40,
                  borderRadius: 10,
                  background: "#5F0080",
                  color: "#fff",
                  fontSize: 18,
                  fontWeight: 800,
                  display: "grid",
                  placeItems: "center",
                }}
              >
                K
              </div>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 14.5, fontWeight: 800, color: t.text }}>
                  마켓컬리 샛별배송
                </div>
                <div style={{ fontSize: 11, color: t.textSoft, marginTop: 2 }}>
                  4개 · 오늘 밤 도착
                </div>
              </div>
              <div
                style={{
                  fontSize: 15,
                  fontWeight: 800,
                  color: t.text,
                  fontFeatureSettings: '"tnum"',
                }}
              >
                ₩{priceRange(16930)}
              </div>
            </div>
            {[
              { n: "당근 300g", p: 1990 },
              { n: "대파 1단", p: 3500 },
              { n: "돼지고기 앞다리 500g", p: 8900 },
              { n: "쌀 1kg", p: 7150 },
            ].map((x, i) => (
              <div
                key={i}
                style={{
                  display: "flex",
                  justifyContent: "space-between",
                  padding: "8px 16px",
                  fontSize: 12.5,
                  color: t.textMid,
                }}
              >
                <span>{x.n}</span>
                <span style={{ fontFeatureSettings: '"tnum"' }}>
                  ₩{priceRange(x.p)}
                </span>
              </div>
            ))}
            <button
              className="tap"
              style={{
                margin: 12,
                padding: "12px",
                borderRadius: 12,
                border: "none",
                background: "#5F0080",
                color: "#fff",
                width: "calc(100% - 24px)",
                fontSize: 13.5,
                fontWeight: 800,
                display: "flex",
                alignItems: "center",
                justifyContent: "center",
                gap: 6,
              }}
            >
              마켓컬리 앱에서 결제하기
              <svg width="14" height="14" viewBox="0 0 14 14">
                <path
                  d="M3 11L11 3M11 3H5M11 3v6"
                  stroke="#fff"
                  strokeWidth="1.7"
                  fill="none"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                />
              </svg>
            </button>
          </div>
        </div>

        <div style={{ padding: "14px 16px 0" }}>
          <div
            style={{
              padding: 14,
              background: "#fff",
              borderRadius: 14,
              border: `1px dashed ${t.border}`,
              fontSize: 11.5,
              color: t.textMid,
              lineHeight: 1.6,
            }}
          >
            <b style={{ color: t.text }}>참고</b> · 각 플랫폼 결제는 해당 앱에서
            진행돼요. 제철식탁은 결제를 대행하지 않으며, 가격 정보만 제공합니다.
          </div>
        </div>
        <div style={{ height: 30 }} />
      </div>
    </Phone>
  );
}

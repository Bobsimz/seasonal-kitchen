// MyPage, Notifications, Wishlist, Order checkout

import React from "react";
import {
  Phone,
  BottomTabBar,
  AppHeader,
  VegPlaceholder,
  Chip,
  priceRange,
  priceExact,
} from "./phone";
import { FACE_IMG, DISH_IMG } from "./mock-images";
import { PriceBadge } from "./screens-home";
import { PRODUCERS, producerReviews } from "./producers-data";
import { ProducerRow } from "./producer-card";
import { ProducerHeader, StickyBar } from "./screens-farm";

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
              {/* 장바구니만 노출 */}
              <div
                className="tap"
                style={{
                  position: "relative",
                  width: 32,
                  height: 32,
                  display: "grid",
                  placeItems: "center",
                }}
              >
                <svg width="22" height="22" viewBox="0 0 20 20" fill="none">
                  <path
                    d="M2 2h2l1.7 9.5a1 1 0 001 .8h7a1 1 0 001-.8L17 5.5H5.2"
                    stroke={t.text}
                    strokeWidth="1.6"
                    strokeLinecap="round"
                    strokeLinejoin="round"
                  />
                  <circle cx="8" cy="16.5" r="1.3" fill={t.text} />
                  <circle cx="14.5" cy="16.5" r="1.3" fill={t.text} />
                </svg>
                <div
                  style={{
                    position: "absolute",
                    top: -2,
                    right: -2,
                    minWidth: 14,
                    height: 14,
                    padding: "0 3px",
                    borderRadius: 7,
                    background: t.hot,
                    border: "1.5px solid #fff",
                    color: "#fff",
                    fontSize: 8.5,
                    fontWeight: 800,
                    display: "grid",
                    placeItems: "center",
                  }}
                >
                  3
                </div>
              </div>
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

        {/* 판매자 센터 — 판매 권한 사용자만 노출되는 통계 접속 버튼 */}
        <div style={{ padding: "14px 16px 0" }}>
          <div
            className="tap"
            style={{
              borderRadius: 18,
              padding: 16,
              background: "#fff",
              border: `1px solid ${t.borderSoft}`,
              display: "flex",
              alignItems: "center",
              gap: 12,
            }}
          >
            <div
              style={{
                width: 44,
                height: 44,
                borderRadius: 13,
                background: t.primaryBg,
                display: "grid",
                placeItems: "center",
                fontSize: 22,
                flexShrink: 0,
              }}
            >
              🧑‍🌾
            </div>
            <div style={{ flex: 1, minWidth: 0 }}>
              <div
                style={{
                  display: "flex",
                  alignItems: "center",
                  gap: 6,
                }}
              >
                <span style={{ fontSize: 14.5, fontWeight: 800, color: t.text }}>
                  판매자 센터
                </span>
                <span
                  style={{
                    fontSize: 10,
                    fontWeight: 800,
                    color: t.primaryDark,
                    background: t.primaryBg,
                    padding: "2px 7px",
                    borderRadius: 999,
                  }}
                >
                  판매자
                </span>
              </div>
              <div style={{ fontSize: 11.5, color: t.textSoft, marginTop: 3 }}>
                오늘 매출 <b style={{ color: t.text }}>₩{priceExact(184000)}</b> · 주문 7건
              </div>
            </div>
            <span
              style={{
                fontSize: 12.5,
                fontWeight: 800,
                color: t.primary,
                whiteSpace: "nowrap",
              }}
            >
              통계 보기 →
            </span>
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
              { ic: "📦", label: "주문 내역", sub: "최근 3건" },
              { ic: "❤️", label: "찜한 농가", sub: "8곳" },
              { ic: "⭐", label: "리뷰 관리", sub: "작성 가능 2건", tag: "NEW" },
              { ic: "🌱", label: "제철 캘린더", sub: "11월 알림" },
              { ic: "🧑‍🌾", label: "판매자 등록", sub: "농가 판매 시작하기" },
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
// 21e — 판매자 등록 (마이페이지 → 농가 판매자 신청)
// ─────────────────────────────────────────────────────────────
export function ScreenSellerRegister({ t }) {
  const items = ["무", "배추", "봄동", "시금치", "감귤", "대파"];
  const selected = new Set(["무", "배추"]);
  const Field = ({ label, value, placeholder, badge }) => (
    <div style={{ padding: "16px 16px 0" }}>
      <div
        style={{
          display: "flex",
          alignItems: "center",
          gap: 6,
          fontSize: 12.5,
          fontWeight: 800,
          color: t.text,
          marginBottom: 8,
        }}
      >
        {label}
        {badge && (
          <span
            style={{
              fontSize: 10,
              fontWeight: 800,
              color: t.primaryDark,
              background: t.primaryBg,
              padding: "2px 7px",
              borderRadius: 999,
            }}
          >
            {badge}
          </span>
        )}
      </div>
      <div
        style={{
          height: 48,
          borderRadius: 12,
          border: `1px solid ${t.border}`,
          background: t.bgSoft,
          display: "flex",
          alignItems: "center",
          padding: "0 14px",
          fontSize: 13.5,
          color: value ? t.text : t.textSoft,
          fontWeight: value ? 700 : 500,
        }}
      >
        {value || placeholder}
      </div>
    </div>
  );
  return (
    <Phone t={t}>
      <AppHeader t={t} title="판매자 등록" leftBack />
      <div
        className="phone-scroll"
        style={{ flex: 1, overflow: "auto", background: t.bg }}
      >
        {/* 안내 카드 */}
        <div style={{ padding: "14px 16px 0" }}>
          <div
            style={{
              borderRadius: 18,
              padding: 18,
              background: `linear-gradient(135deg, ${t.primary}, ${t.primaryDark})`,
              color: "#fff",
              position: "relative",
              overflow: "hidden",
            }}
          >
            <div
              style={{
                position: "absolute",
                right: -16,
                top: -16,
                fontSize: 80,
                opacity: 0.15,
              }}
            >
              🧑‍🌾
            </div>
            <div
              style={{
                fontSize: 12,
                fontWeight: 800,
                opacity: 0.9,
                letterSpacing: 0.5,
              }}
            >
              농가 판매자 신청
            </div>
            <div
              style={{
                fontSize: 18,
                fontWeight: 800,
                marginTop: 4,
                letterSpacing: -0.4,
              }}
            >
              내 농가 상품을
              <br />
              직접 판매해보세요
            </div>
            <div style={{ fontSize: 11.5, marginTop: 6, opacity: 0.9, lineHeight: 1.5 }}>
              인증 후 상품 탭에서 바로 판매 등록할 수 있어요
            </div>
          </div>
        </div>

        {/* 입력 폼 */}
        <Field label="농가/농장 이름" placeholder="예) 해남 송지농원" />
        <Field label="대표자 이름" placeholder="실명을 입력해주세요" />
        <Field label="대표 지역" placeholder="예) 전남 해남" />
        <Field label="연락처" placeholder="010-0000-0000" />

        {/* 주요 판매 품목 */}
        <div style={{ padding: "16px 16px 0" }}>
          <div style={{ fontSize: 12.5, fontWeight: 800, color: t.text, marginBottom: 8 }}>
            주요 판매 품목
          </div>
          <div style={{ display: "flex", flexWrap: "wrap", gap: 8 }}>
            {items.map((it) => {
              const on = selected.has(it);
              return (
                <div
                  key={it}
                  className="tap"
                  style={{
                    padding: "9px 16px",
                    borderRadius: 999,
                    fontSize: 13,
                    fontWeight: 700,
                    background: on ? t.primaryBg : "#fff",
                    border: `1px solid ${on ? t.primary : t.border}`,
                    color: on ? t.primaryDark : t.textMid,
                  }}
                >
                  {it}
                </div>
              );
            })}
          </div>
        </div>

        {/* 농가 인증 업로드 */}
        <div style={{ padding: "16px 16px 0" }}>
          <div
            style={{
              display: "flex",
              alignItems: "center",
              gap: 6,
              fontSize: 12.5,
              fontWeight: 800,
              color: t.text,
              marginBottom: 8,
            }}
          >
            농가 인증
            <span
              style={{
                fontSize: 10,
                fontWeight: 800,
                color: t.primaryDark,
                background: t.primaryBg,
                padding: "2px 7px",
                borderRadius: 999,
              }}
            >
              필수
            </span>
          </div>
          <div
            className="tap"
            style={{
              height: 96,
              borderRadius: 14,
              border: `1.5px dashed ${t.border}`,
              background: t.bgSoft,
              display: "flex",
              flexDirection: "column",
              alignItems: "center",
              justifyContent: "center",
              gap: 6,
              color: t.textSoft,
            }}
          >
            <span style={{ fontSize: 24 }}>＋</span>
            <span style={{ fontSize: 11.5, fontWeight: 700 }}>
              농업경영체 등록확인서 첨부
            </span>
          </div>
        </div>

        {/* 약관 동의 */}
        <div style={{ padding: "18px 16px 0" }}>
          <div
            style={{
              display: "flex",
              alignItems: "center",
              gap: 10,
              padding: "12px 14px",
              borderRadius: 12,
              background: t.bgSoft,
            }}
          >
            <div
              style={{
                width: 22,
                height: 22,
                borderRadius: 6,
                background: t.primary,
                display: "grid",
                placeItems: "center",
                flexShrink: 0,
              }}
            >
              <svg width="13" height="13" viewBox="0 0 14 14">
                <path
                  d="M3 7.5l2.5 2.5L11 4"
                  stroke="#fff"
                  strokeWidth="2"
                  fill="none"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                />
              </svg>
            </div>
            <span style={{ fontSize: 12.5, color: t.textMid, fontWeight: 600 }}>
              판매자 이용약관 및 정산 정책에 동의합니다
            </span>
          </div>
        </div>

        <div style={{ height: 110 }} />
      </div>

      <StickyBar t={t}>
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
          }}
        >
          판매자 신청하기
        </button>
      </StickyBar>
    </Phone>
  );
}

// ─────────────────────────────────────────────────────────────
// 21f — 판매자 통계 (판매자 센터 · 데이터 통계 대시보드)
// ─────────────────────────────────────────────────────────────
export function ScreenSellerDashboard({ t }) {
  const kpis = [
    { k: "이번 달 매출", v: "₩4,820,000", d: "+12%", up: true },
    { k: "주문", v: "186건", d: "+8%", up: true },
    { k: "상품 조회수", v: "12,430", d: "+21%", up: true },
    { k: "전환율", v: "3.4%", d: "-0.3%", up: false },
  ];
  const week = [
    { d: "월", v: 62 },
    { d: "화", v: 48 },
    { d: "수", v: 80 },
    { d: "목", v: 56 },
    { d: "금", v: 95 },
    { d: "토", v: 100 },
    { d: "일", v: 74 },
  ];
  const tops = [
    { veg: "무", name: "해남 황토밭 가을무 3kg", sold: 64, amt: 537600 },
    { veg: "배추", name: "절임 배추 10kg 예약", sold: 28, amt: 669200 },
    { veg: "봄동", name: "햇 봄동 1.5kg 산지직송", sold: 41, amt: 282900 },
  ];
  return (
    <Phone t={t}>
      <AppHeader
        t={t}
        title="판매자 통계"
        leftBack
        rightIcons={
          <div
            className="tap"
            style={{
              display: "flex",
              alignItems: "center",
              gap: 3,
              fontSize: 12.5,
              fontWeight: 700,
              color: t.text,
              padding: "6px 10px",
              borderRadius: 999,
              border: `1px solid ${t.border}`,
            }}
          >
            이번 달
            <svg width="10" height="10" viewBox="0 0 10 10">
              <path
                d="M2 3.5l3 3 3-3"
                stroke={t.textSoft}
                strokeWidth="1.6"
                fill="none"
                strokeLinecap="round"
              />
            </svg>
          </div>
        }
      />
      <div
        className="phone-scroll"
        style={{ flex: 1, overflow: "auto", background: t.bgSoft }}
      >
        {/* KPI 그리드 */}
        <div
          style={{
            padding: "14px 16px 0",
            display: "grid",
            gridTemplateColumns: "1fr 1fr",
            gap: 10,
          }}
        >
          {kpis.map((s, i) => (
            <div
              key={i}
              style={{
                background: "#fff",
                borderRadius: 16,
                border: `1px solid ${t.borderSoft}`,
                padding: 14,
              }}
            >
              <div style={{ fontSize: 11.5, color: t.textSoft, fontWeight: 600 }}>
                {s.k}
              </div>
              <div
                style={{
                  fontSize: 19,
                  fontWeight: 800,
                  color: t.text,
                  marginTop: 6,
                  fontFeatureSettings: '"tnum"',
                  letterSpacing: -0.4,
                }}
              >
                {s.v}
              </div>
              <div
                style={{
                  fontSize: 11.5,
                  fontWeight: 800,
                  marginTop: 4,
                  color: s.up ? t.primary : t.hot,
                }}
              >
                {s.up ? "▲" : "▼"} {s.d.replace(/[+-]/, "")}
                <span
                  style={{ color: t.textSoft, fontWeight: 600, marginLeft: 4 }}
                >
                  전월 대비
                </span>
              </div>
            </div>
          ))}
        </div>

        {/* 최근 7일 매출 차트 */}
        <div style={{ padding: "14px 16px 0" }}>
          <div
            style={{
              background: "#fff",
              borderRadius: 18,
              border: `1px solid ${t.borderSoft}`,
              padding: 16,
            }}
          >
            <div
              style={{
                display: "flex",
                alignItems: "baseline",
                justifyContent: "space-between",
                marginBottom: 14,
              }}
            >
              <span style={{ fontSize: 14, fontWeight: 800, color: t.text }}>
                최근 7일 매출
              </span>
              <span style={{ fontSize: 11.5, color: t.textSoft }}>
                일 평균 ₩689,000
              </span>
            </div>
            <div
              style={{
                display: "flex",
                alignItems: "flex-end",
                justifyContent: "space-between",
                gap: 8,
                height: 120,
              }}
            >
              {week.map((b, i) => {
                const peak = i === 5;
                return (
                  <div
                    key={i}
                    style={{
                      flex: 1,
                      display: "flex",
                      flexDirection: "column",
                      alignItems: "center",
                      gap: 6,
                      height: "100%",
                      justifyContent: "flex-end",
                    }}
                  >
                    <div
                      style={{
                        width: "100%",
                        height: `${b.v}%`,
                        borderRadius: 6,
                        background: peak
                          ? `linear-gradient(180deg, ${t.primary}, ${t.primaryDark})`
                          : t.primaryBg,
                      }}
                    />
                    <span style={{ fontSize: 10.5, color: t.textSoft }}>{b.d}</span>
                  </div>
                );
              })}
            </div>
          </div>
        </div>

        {/* 인기 상품 */}
        <div style={{ padding: "14px 16px 0" }}>
          <div style={{ fontSize: 14, fontWeight: 800, color: t.text, padding: "0 2px 10px" }}>
            인기 상품
          </div>
          <div
            style={{
              background: "#fff",
              borderRadius: 18,
              border: `1px solid ${t.borderSoft}`,
              overflow: "hidden",
            }}
          >
            {tops.map((p, i, arr) => (
              <div
                key={i}
                style={{
                  display: "flex",
                  alignItems: "center",
                  gap: 12,
                  padding: "12px 16px",
                  borderBottom:
                    i < arr.length - 1 ? `1px solid ${t.borderSoft}` : "none",
                }}
              >
                <span
                  style={{
                    width: 20,
                    fontSize: 14,
                    fontWeight: 800,
                    color: i === 0 ? t.primary : t.textSoft,
                    textAlign: "center",
                    fontFeatureSettings: '"tnum"',
                  }}
                >
                  {i + 1}
                </span>
                <VegPlaceholder name={p.veg} size={44} t={t} />
                <div style={{ flex: 1, minWidth: 0 }}>
                  <div
                    style={{
                      fontSize: 13.5,
                      fontWeight: 700,
                      color: t.text,
                      whiteSpace: "nowrap",
                      overflow: "hidden",
                      textOverflow: "ellipsis",
                    }}
                  >
                    {p.name}
                  </div>
                  <div style={{ fontSize: 11.5, color: t.textSoft, marginTop: 2 }}>
                    {p.sold}건 판매
                  </div>
                </div>
                <div
                  style={{
                    fontSize: 13.5,
                    fontWeight: 800,
                    color: t.text,
                    fontFeatureSettings: '"tnum"',
                    whiteSpace: "nowrap",
                  }}
                >
                  ₩{priceExact(p.amt)}
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* 정산 예정 */}
        <div style={{ padding: "14px 16px 0" }}>
          <div
            style={{
              borderRadius: 16,
              padding: "14px 16px",
              background: t.primaryBg,
              display: "flex",
              alignItems: "center",
              gap: 10,
            }}
          >
            <span style={{ fontSize: 20 }}>💰</span>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 13, fontWeight: 800, color: t.primaryDark }}>
                정산 예정 금액 ₩{priceExact(2940000)}
              </div>
              <div style={{ fontSize: 11.5, color: t.textMid, marginTop: 2 }}>
                다음 정산일 2026.06.25
              </div>
            </div>
            <span style={{ fontSize: 12.5, fontWeight: 800, color: t.primary }}>
              내역 →
            </span>
          </div>
        </div>

        <div style={{ height: 28 }} />
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

// ─────────────────────────────────────────────────────────────
// 공용 — 세그먼트 탭
// ─────────────────────────────────────────────────────────────
function SegTabs({ tabs, active, onChange, t }) {
  return (
    <div
      style={{
        display: "flex",
        background: t.bgSoft,
        borderRadius: 12,
        padding: 4,
        gap: 4,
        margin: "12px 16px 0",
      }}
    >
      {tabs.map((tab) => {
        const on = active === tab.id;
        return (
          <div
            key={tab.id}
            className="tap"
            onClick={() => onChange(tab.id)}
            style={{
              flex: 1,
              padding: "9px 8px",
              borderRadius: 9,
              textAlign: "center",
              background: on ? "#fff" : "transparent",
              boxShadow: on ? "0 2px 6px rgba(20,40,30,0.08)" : "none",
              fontSize: 13,
              fontWeight: on ? 800 : 600,
              color: on ? t.text : t.textSoft,
            }}
          >
            {tab.label}
          </div>
        );
      })}
    </div>
  );
}

const StatusChip = ({ done, t }) => (
  <span
    style={{
      fontSize: 11,
      fontWeight: 800,
      padding: "3px 9px",
      borderRadius: 999,
      color: done ? t.primaryDark : t.warning,
      background: done ? t.primaryBg : t.warningBg,
    }}
  >
    {done ? "배송완료" : "배송중"}
  </span>
);

// ─────────────────────────────────────────────────────────────
// 21a — 주문 내역
// ─────────────────────────────────────────────────────────────
export function ScreenOrders({ t }) {
  const orders = [
    {
      date: "2026.06.09",
      no: "2026-0609-0427",
      done: false,
      p: PRODUCERS[2],
      items: [
        { name: "무", qty: 2, unit: "개", price: 2090 },
        { name: "배추", qty: 1, unit: "포기", price: 5560 },
      ],
    },
    {
      date: "2026.05.28",
      no: "2026-0528-0193",
      done: true,
      p: PRODUCERS[4],
      items: [{ name: "시금치", qty: 3, unit: "단", price: 4140 }],
    },
    {
      date: "2026.05.14",
      no: "2026-0514-0061",
      done: true,
      p: PRODUCERS[0],
      items: [
        { name: "봄동", qty: 2, unit: "봉", price: 5310 },
        { name: "무", qty: 1, unit: "개", price: 2530 },
      ],
    },
  ];
  return (
    <Phone t={t}>
      <AppHeader t={t} title="주문 내역" leftBack />
      <div
        className="phone-scroll"
        style={{ flex: 1, overflow: "auto", background: t.bgSoft }}
      >
        {orders.map((o, oi) => {
          const total = o.items.reduce((a, it) => a + it.price * it.qty, 0);
          return (
            <div key={oi} style={{ padding: "12px 16px 0" }}>
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
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "space-between",
                    padding: "12px 16px",
                    borderBottom: `1px solid ${t.borderSoft}`,
                  }}
                >
                  <span style={{ fontSize: 12, color: t.textSoft }}>
                    {o.date} · {o.no}
                  </span>
                  <StatusChip done={o.done} t={t} />
                </div>
                <div style={{ padding: "12px 16px 0" }}>
                  <ProducerHeader producer={o.p} t={t} size={36} />
                </div>
                <div style={{ padding: "10px 16px 0" }}>
                  {o.items.map((it, i) => (
                    <div
                      key={i}
                      style={{
                        display: "flex",
                        alignItems: "center",
                        gap: 10,
                        padding: "6px 0",
                      }}
                    >
                      <VegPlaceholder name={it.name} size={36} t={t} />
                      <div style={{ flex: 1, minWidth: 0 }}>
                        <span
                          style={{ fontSize: 13, fontWeight: 700, color: t.text }}
                        >
                          {it.name}
                        </span>
                        <span style={{ fontSize: 11.5, color: t.textSoft }}>
                          {" "}
                          {it.qty}
                          {it.unit}
                        </span>
                      </div>
                      <span
                        style={{
                          fontSize: 13,
                          fontWeight: 700,
                          color: t.text,
                          fontFeatureSettings: '"tnum"',
                        }}
                      >
                        ₩{priceExact(it.price * it.qty)}
                      </span>
                    </div>
                  ))}
                </div>
                <div
                  style={{
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "space-between",
                    padding: "12px 16px",
                    marginTop: 6,
                    borderTop: `1px solid ${t.borderSoft}`,
                  }}
                >
                  <span style={{ fontSize: 12.5, color: t.textMid }}>
                    총 결제
                    <b
                      style={{
                        color: t.text,
                        marginLeft: 6,
                        fontFeatureSettings: '"tnum"',
                      }}
                    >
                      ₩{priceExact(total)}
                    </b>
                  </span>
                  {o.done && (
                    <span
                      className="tap"
                      style={{
                        fontSize: 12,
                        fontWeight: 800,
                        color: t.primary,
                        border: `1px solid ${t.primary}`,
                        borderRadius: 999,
                        padding: "6px 14px",
                      }}
                    >
                      ⭐ 리뷰 쓰기
                    </span>
                  )}
                </div>
              </div>
            </div>
          );
        })}
        <div style={{ height: 24 }} />
      </div>
    </Phone>
  );
}

// ─────────────────────────────────────────────────────────────
// 21b — 찜 목록 (농가 / 식재료 / 레시피)
// ─────────────────────────────────────────────────────────────
export function ScreenWishlist({ t }) {
  const [tab, setTab] = React.useState("producer");
  const farms = PRODUCERS.slice(0, 4);
  const ings = ["무", "봄동", "배추", "시금치"];
  const recipes = [
    { name: "봄동 비빔밥", img: DISH_IMG.봄동비빔밥, sub: "20분 · 쉬움" },
    { name: "무생채", img: DISH_IMG.무생채, sub: "15분 · 쉬움" },
    { name: "배추전", img: DISH_IMG.배추전, sub: "25분 · 보통" },
  ];
  const Heart = () => <span style={{ fontSize: 18 }}>❤️</span>;
  return (
    <Phone t={t}>
      <AppHeader t={t} title="찜" leftBack />
      <SegTabs
        t={t}
        active={tab}
        onChange={setTab}
        tabs={[
          { id: "producer", label: "농가" },
          { id: "ingredient", label: "식재료" },
          { id: "recipe", label: "레시피" },
        ]}
      />
      <div
        className="phone-scroll"
        style={{ flex: 1, overflow: "auto", background: t.bg }}
      >
        {tab === "producer" && (
          <div style={{ padding: "14px 16px 0" }}>
            <div
              style={{
                background: "#fff",
                borderRadius: 18,
                border: `1px solid ${t.borderSoft}`,
                overflow: "hidden",
              }}
            >
              {farms.map((p, i, arr) => (
                <ProducerRow
                  key={p.id}
                  producer={p}
                  t={t}
                  divider={i < arr.length - 1}
                  trailing={<Heart />}
                />
              ))}
            </div>
          </div>
        )}

        {tab === "ingredient" && (
          <div style={{ padding: "14px 16px 0" }}>
            <div
              style={{
                background: "#fff",
                borderRadius: 18,
                border: `1px solid ${t.borderSoft}`,
                overflow: "hidden",
              }}
            >
              {ings.map((name, i, arr) => (
                <div
                  key={name}
                  className="tap"
                  style={{
                    display: "flex",
                    alignItems: "center",
                    gap: 12,
                    padding: "12px 16px",
                    borderBottom:
                      i < arr.length - 1 ? `1px solid ${t.borderSoft}` : "none",
                  }}
                >
                  <VegPlaceholder name={name} size={48} t={t} />
                  <div style={{ flex: 1, fontSize: 14, fontWeight: 700, color: t.text }}>
                    {name}
                    <div style={{ fontSize: 11.5, color: t.textSoft, fontWeight: 500, marginTop: 2 }}>
                      제철 · 가격 하락 중
                    </div>
                  </div>
                  <Heart />
                </div>
              ))}
            </div>
          </div>
        )}

        {tab === "recipe" && (
          <div style={{ padding: "14px 16px 0" }}>
            <div
              style={{
                background: "#fff",
                borderRadius: 18,
                border: `1px solid ${t.borderSoft}`,
                overflow: "hidden",
              }}
            >
              {recipes.map((r, i, arr) => (
                <div
                  key={r.name}
                  className="tap"
                  style={{
                    display: "flex",
                    alignItems: "center",
                    gap: 12,
                    padding: "12px 16px",
                    borderBottom:
                      i < arr.length - 1 ? `1px solid ${t.borderSoft}` : "none",
                  }}
                >
                  <div
                    style={{
                      width: 52,
                      height: 52,
                      borderRadius: 12,
                      flexShrink: 0,
                      backgroundImage: `url(${r.img})`,
                      backgroundSize: "cover",
                      backgroundPosition: "center",
                    }}
                  />
                  <div style={{ flex: 1, minWidth: 0 }}>
                    <div style={{ fontSize: 14, fontWeight: 700, color: t.text }}>
                      {r.name}
                    </div>
                    <div style={{ fontSize: 11.5, color: t.textSoft, marginTop: 2 }}>
                      {r.sub}
                    </div>
                  </div>
                  <Heart />
                </div>
              ))}
            </div>
          </div>
        )}
        <div style={{ height: 24 }} />
      </div>
    </Phone>
  );
}

// ─────────────────────────────────────────────────────────────
// 21c — 리뷰 관리 (작성한 / 작성 가능)
// ─────────────────────────────────────────────────────────────
export function ScreenReviews({ t }) {
  const [tab, setTab] = React.useState("written");
  const written = producerReviews(PRODUCERS[2])
    .slice(0, 2)
    .map((rv, i) => ({ ...rv, producer: PRODUCERS[2], author: "나" }));
  const pending = [
    { p: PRODUCERS[4], item: "시금치", date: "2026.05.30 배송완료" },
    { p: PRODUCERS[0], item: "봄동", date: "2026.05.16 배송완료" },
  ];
  return (
    <Phone t={t}>
      <AppHeader t={t} title="리뷰 관리" leftBack />
      <SegTabs
        t={t}
        active={tab}
        onChange={setTab}
        tabs={[
          { id: "written", label: "작성한 리뷰" },
          { id: "pending", label: "작성 가능" },
        ]}
      />
      <div
        className="phone-scroll"
        style={{ flex: 1, overflow: "auto", background: t.bgSoft }}
      >
        {tab === "written" &&
          written.map((rv, i) => (
            <div key={i} style={{ padding: "12px 16px 0" }}>
              <div
                style={{
                  background: "#fff",
                  borderRadius: 18,
                  border: `1px solid ${t.borderSoft}`,
                  padding: 16,
                }}
              >
                <div
                  style={{
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "space-between",
                  }}
                >
                  <span style={{ fontSize: 13, fontWeight: 800, color: t.text }}>
                    {rv.producer.region} {rv.producer.name}
                  </span>
                  <span style={{ fontSize: 11, color: t.textSoft }}>
                    {rv.date}
                  </span>
                </div>
                <div style={{ fontSize: 13, color: t.warning, marginTop: 6 }}>
                  {"★".repeat(rv.rating)}
                  <span style={{ color: t.border }}>
                    {"★".repeat(5 - rv.rating)}
                  </span>
                  <span style={{ color: t.textSoft, fontSize: 11, marginLeft: 6 }}>
                    {rv.item} 구매
                  </span>
                </div>
                <div
                  style={{
                    fontSize: 12.5,
                    color: t.textMid,
                    lineHeight: 1.55,
                    marginTop: 8,
                  }}
                >
                  {rv.body}
                </div>
                <div style={{ display: "flex", gap: 8, marginTop: 12 }}>
                  {["수정", "삭제"].map((b) => (
                    <span
                      key={b}
                      className="tap"
                      style={{
                        fontSize: 12,
                        fontWeight: 700,
                        color: t.textMid,
                        border: `1px solid ${t.border}`,
                        borderRadius: 8,
                        padding: "6px 14px",
                      }}
                    >
                      {b}
                    </span>
                  ))}
                </div>
              </div>
            </div>
          ))}

        {tab === "pending" &&
          pending.map((o, i) => (
            <div key={i} style={{ padding: "12px 16px 0" }}>
              <div
                style={{
                  background: "#fff",
                  borderRadius: 18,
                  border: `1px solid ${t.borderSoft}`,
                  padding: 16,
                  display: "flex",
                  alignItems: "center",
                  gap: 12,
                }}
              >
                <VegPlaceholder name={o.item} size={44} t={t} />
                <div style={{ flex: 1, minWidth: 0 }}>
                  <div style={{ fontSize: 13.5, fontWeight: 700, color: t.text }}>
                    {o.p.region} {o.p.name} · {o.item}
                  </div>
                  <div style={{ fontSize: 11.5, color: t.textSoft, marginTop: 2 }}>
                    {o.date}
                  </div>
                </div>
                <span
                  className="tap"
                  style={{
                    fontSize: 12,
                    fontWeight: 800,
                    color: "#fff",
                    background: t.primary,
                    borderRadius: 999,
                    padding: "8px 14px",
                    whiteSpace: "nowrap",
                  }}
                >
                  리뷰 쓰기
                </span>
              </div>
            </div>
          ))}
        <div style={{ height: 24 }} />
      </div>
    </Phone>
  );
}

// ─────────────────────────────────────────────────────────────
// 21d — 리뷰 작성
// ─────────────────────────────────────────────────────────────
export function ScreenWriteReview({ t, producer = PRODUCERS[4] }) {
  const [rating, setRating] = React.useState(5);
  const item = producer.specialties[0];
  return (
    <Phone t={t}>
      <AppHeader t={t} title="리뷰 작성" leftBack />
      <div
        className="phone-scroll"
        style={{ flex: 1, overflow: "auto", background: t.bg }}
      >
        {/* 대상 */}
        <div style={{ padding: "14px 16px 0" }}>
          <div
            style={{
              background: t.bgSoft,
              borderRadius: 14,
              padding: "12px 14px",
              display: "flex",
              alignItems: "center",
              gap: 12,
            }}
          >
            <VegPlaceholder name={item} size={44} t={t} />
            <div>
              <div style={{ fontSize: 13.5, fontWeight: 800, color: t.text }}>
                {producer.region} {producer.name}
              </div>
              <div style={{ fontSize: 11.5, color: t.textSoft, marginTop: 2 }}>
                {item} · 2026.05.30 배송완료
              </div>
            </div>
          </div>
        </div>

        {/* 별점 */}
        <div style={{ padding: "22px 16px 0", textAlign: "center" }}>
          <div style={{ fontSize: 13, fontWeight: 700, color: t.text }}>
            농가는 어떠셨나요?
          </div>
          <div
            style={{
              display: "flex",
              justifyContent: "center",
              gap: 6,
              marginTop: 12,
            }}
          >
            {[1, 2, 3, 4, 5].map((n) => (
              <span
                key={n}
                className="tap"
                onClick={() => setRating(n)}
                style={{
                  fontSize: 34,
                  lineHeight: 1,
                  color: n <= rating ? t.warning : t.border,
                }}
              >
                ★
              </span>
            ))}
          </div>
        </div>

        {/* 사진 */}
        <div style={{ padding: "22px 16px 0" }}>
          <div style={{ fontSize: 12.5, fontWeight: 800, color: t.text, marginBottom: 8 }}>
            사진 첨부
          </div>
          <div style={{ display: "flex", gap: 8 }}>
            <div
              className="tap"
              style={{
                width: 80,
                height: 80,
                borderRadius: 14,
                border: `1.5px dashed ${t.border}`,
                background: t.bgSoft,
                display: "flex",
                flexDirection: "column",
                alignItems: "center",
                justifyContent: "center",
                gap: 4,
                color: t.textSoft,
              }}
            >
              <span style={{ fontSize: 20 }}>＋</span>
              <span style={{ fontSize: 10.5, fontWeight: 700 }}>0/5</span>
            </div>
            <div
              style={{
                width: 80,
                height: 80,
                borderRadius: 14,
                backgroundImage: "url(/uploads/pasted-1779886008264-0.png)",
                backgroundSize: "cover",
                backgroundPosition: "center",
                border: `1px solid ${t.borderSoft}`,
              }}
            />
          </div>
        </div>

        {/* 본문 */}
        <div style={{ padding: "22px 16px 0" }}>
          <div style={{ fontSize: 12.5, fontWeight: 800, color: t.text, marginBottom: 8 }}>
            상세 리뷰
          </div>
          <textarea
            style={{
              width: "100%",
              boxSizing: "border-box",
              minHeight: 120,
              resize: "none",
              border: `1px solid ${t.border}`,
              borderRadius: 12,
              padding: "13px 14px",
              fontSize: 13.5,
              color: t.text,
              background: t.bgSoft,
              fontFamily: "inherit",
              lineHeight: 1.5,
            }}
            placeholder="농가의 신선도, 맛, 포장, 배송 등 솔직한 후기를 남겨주세요."
          />
        </div>

        <div style={{ height: 110 }} />
      </div>

      <StickyBar t={t}>
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
          }}
        >
          등록하기
        </button>
      </StickyBar>
    </Phone>
  );
}

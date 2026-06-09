// Phone wrapper + shared atoms (bottom tab bar, top header, status bar overrides)

import React from "react";

export const PHONE_W = 390;
export const PHONE_H = 844;

// 가격을 ±pct 범위 "min~max" 콤마 포맷으로 변환 (예: 2400 → "2,160~2,640")
export function priceRange(value, pct = 0.1) {
  const n = typeof value === "string" ? Number(value.replace(/,/g, "")) : value;
  const lo = Math.round(n * (1 - pct));
  const hi = Math.round(n * (1 + pct));
  return `${lo.toLocaleString()}~${hi.toLocaleString()}`;
}

// 명확한(단일) 금액 콤마 포맷 (예: 2400 → "2,400") — 농가 직거래 가격용
export function priceExact(value) {
  const n = typeof value === "string" ? Number(value.replace(/,/g, "")) : value;
  return n.toLocaleString();
}

// Compact iOS-y status bar that respects our color theme
export function PhoneStatus({ dark }) {
  const c = dark ? "#fff" : "#0F1A14";
  return (
    <div
      style={{
        position: "absolute",
        top: 0,
        left: 0,
        right: 0,
        zIndex: 10,
        height: 44,
        display: "flex",
        alignItems: "center",
        justifyContent: "space-between",
        padding: "0 28px 0 32px",
        pointerEvents: "none",
      }}
    >
      <span
        style={{ fontSize: 15, fontWeight: 600, color: c, letterSpacing: -0.3 }}
      >
        9:41
      </span>
      <div style={{ display: "flex", gap: 6, alignItems: "center" }}>
        <svg width="17" height="11" viewBox="0 0 17 11" fill="none">
          <rect x="0" y="7" width="3" height="4" rx="0.6" fill={c} />
          <rect x="4.5" y="5" width="3" height="6" rx="0.6" fill={c} />
          <rect x="9" y="2.5" width="3" height="8.5" rx="0.6" fill={c} />
          <rect x="13.5" y="0" width="3" height="11" rx="0.6" fill={c} />
        </svg>
        <svg width="15" height="11" viewBox="0 0 15 11" fill="none">
          <path
            d="M7.5 3a7.4 7.4 0 015.3 2.2l1-1A8.8 8.8 0 007.5 1.5 8.8 8.8 0 001.2 4.2l1 1A7.4 7.4 0 017.5 3z"
            fill={c}
          />
          <path
            d="M7.5 6.3a4 4 0 013 1.3l1-1a5.5 5.5 0 00-4-1.7 5.5 5.5 0 00-4 1.7l1 1a4 4 0 013-1.3z"
            fill={c}
          />
          <circle cx="7.5" cy="9.5" r="1.2" fill={c} />
        </svg>
        <svg width="24" height="11" viewBox="0 0 24 11" fill="none">
          <rect
            x="0.5"
            y="0.5"
            width="20"
            height="10"
            rx="2.5"
            stroke={c}
            strokeOpacity="0.5"
            fill="none"
          />
          <rect x="2" y="2" width="17" height="7" rx="1.5" fill={c} />
          <path
            d="M22 4v3c0.6-0.2 1-0.7 1-1.5 0-0.8-0.4-1.3-1-1.5z"
            fill={c}
            fillOpacity="0.5"
          />
        </svg>
      </div>
    </div>
  );
}

// The Phone wrapper — replaces IOSDevice for our app screens.
// Uses a flex column so a fixed bottom tab bar (passed via prop) sits at the bottom.
//
// Stretch mode: minHeight = PHONE_H but height grows with content so scrollable
// screens unfurl into a single tall canvas for at-a-glance review. Combined
// with `.phone-scroll { overflow: visible !important }` in styles.css, any
// inner scrolling container in a screen expands to show its full content.
export function Phone({
  children,
  dark,
  bg,
  tabBar,
  hideStatus,
  hideHomeIndicator,
  width = PHONE_W,
  height = PHONE_H,
}) {
  return (
    <div
      className="phone-shell"
      style={{
        width,
        minHeight: height,
        borderRadius: 48,
        overflow: "hidden",
        position: "relative",
        background: bg || (dark ? "#0a0a0a" : "#FBFCFA"),
        boxShadow: "0 30px 60px rgba(0,0,0,0.18), 0 0 0 1px rgba(0,0,0,0.1)",
        fontFamily: "Pretendard, -apple-system, system-ui, sans-serif",
        display: "flex",
        flexDirection: "column",
      }}
    >
      {/* dynamic island */}
      <div
        style={{
          position: "absolute",
          top: 11,
          left: "50%",
          transform: "translateX(-50%)",
          width: 120,
          height: 34,
          borderRadius: 22,
          background: "#000",
          zIndex: 50,
        }}
      />
      {!hideStatus && <PhoneStatus dark={dark} />}
      {/* No min-height: 0 here on purpose. The default `min-height: auto`
          lets this flex item carry its content's intrinsic min-size up to
          the Phone shell, so the shell grows past PHONE_H when a screen's
          unfurled content exceeds the device height. */}
      <div style={{ flex: 1, display: "flex", flexDirection: "column" }}>
        {children}
      </div>
      {tabBar}
      {/* home indicator */}
      {!hideHomeIndicator && (
        <div
          style={{
            position: "absolute",
            bottom: 8,
            left: "50%",
            transform: "translateX(-50%)",
            width: 134,
            height: 5,
            borderRadius: 100,
            background: dark ? "rgba(255,255,255,0.85)" : "rgba(0,0,0,0.3)",
            zIndex: 60,
            pointerEvents: "none",
          }}
        />
      )}
    </div>
  );
}

// Bottom tab bar — 5 슬롯: 홈 / 탐색 / [AI 셰프 동그라미 ·중앙] / 릴스 / 마이
export function BottomTabBar({ active = "home", t, dark }) {
  const tabs = [
    {
      id: "home",
      label: "홈",
      icon: (c) => (
        <svg width="22" height="22" viewBox="0 0 22 22" fill="none">
          <path
            d="M3 9.5L11 3l8 6.5V19a1 1 0 01-1 1h-4v-6h-6v6H4a1 1 0 01-1-1V9.5z"
            fill={c === "active" ? t.primary : "none"}
            stroke={c === "active" ? t.primary : t.textSoft}
            strokeWidth="1.7"
            strokeLinejoin="round"
          />
        </svg>
      ),
    },
    {
      id: "list",
      label: "탐색",
      icon: (c) => (
        <svg width="22" height="22" viewBox="0 0 22 22" fill="none">
          <rect
            x="3"
            y="4"
            width="16"
            height="3"
            rx="1"
            stroke={c === "active" ? t.primary : t.textSoft}
            fill={c === "active" ? t.primaryBg : "none"}
            strokeWidth="1.7"
          />
          <rect
            x="3"
            y="9.5"
            width="16"
            height="3"
            rx="1"
            stroke={c === "active" ? t.primary : t.textSoft}
            fill={c === "active" ? t.primaryBg : "none"}
            strokeWidth="1.7"
          />
          <rect
            x="3"
            y="15"
            width="16"
            height="3"
            rx="1"
            stroke={c === "active" ? t.primary : t.textSoft}
            fill={c === "active" ? t.primaryBg : "none"}
            strokeWidth="1.7"
          />
        </svg>
      ),
    },
    {
      id: "reels",
      label: "릴스",
      icon: (c) => (
        <svg width="22" height="22" viewBox="0 0 22 22" fill="none">
          <rect
            x="3"
            y="3"
            width="16"
            height="16"
            rx="4"
            stroke={c === "active" ? t.primary : t.textSoft}
            fill={c === "active" ? t.primary : "none"}
            strokeWidth="1.7"
          />
          <path
            d="M9.5 8L14 11l-4.5 3V8z"
            fill={c === "active" ? "#fff" : t.textSoft}
          />
        </svg>
      ),
    },
    {
      id: "my",
      label: "마이",
      icon: (c) => (
        <svg width="22" height="22" viewBox="0 0 22 22" fill="none">
          <circle
            cx="11"
            cy="8"
            r="3.5"
            stroke={c === "active" ? t.primary : t.textSoft}
            fill={c === "active" ? t.primaryBg : "none"}
            strokeWidth="1.7"
          />
          <path
            d="M4 19c1-3.5 4-5 7-5s6 1.5 7 5"
            stroke={c === "active" ? t.primary : t.textSoft}
            fill={c === "active" ? t.primaryBg : "none"}
            strokeWidth="1.7"
            strokeLinecap="round"
          />
        </svg>
      ),
    },
  ];
  const isAiActive = active === "ai";
  // 좌측 2개, 우측 2개로 분리해 중앙에 AI 버튼을 배치
  const leftTabs = tabs.slice(0, 2);
  const rightTabs = tabs.slice(2);

  const renderTab = (tab) => {
    const isActive = active === tab.id;
    return (
      <div
        key={tab.id}
        className="tap"
        style={{
          flex: 1,
          display: "flex",
          flexDirection: "column",
          alignItems: "center",
          justifyContent: "center",
          gap: 4,
        }}
      >
        {tab.icon(isActive ? "active" : "inactive")}
        <span
          style={{
            fontSize: 10.5,
            fontWeight: isActive ? 700 : 500,
            color: isActive
              ? t.primary
              : dark
                ? "rgba(255,255,255,0.5)"
                : t.textSoft,
          }}
        >
          {tab.label}
        </span>
      </div>
    );
  };

  return (
    <div
      style={{
        flexShrink: 0,
        height: 68,
        paddingTop: 11,
        paddingBottom: 11,
        borderTop: `1px solid ${dark ? "rgba(255,255,255,0.08)" : t.borderSoft}`,
        background: dark ? "rgba(10,10,10,0.95)" : "rgba(255,255,255,0.98)",
        backdropFilter: "blur(20px)",
        display: "flex",
        alignItems: "stretch",
        position: "relative",
        zIndex: 100,
      }}
    >
      {leftTabs.map(renderTab)}

      {/* 중앙 AI 셰프 버튼 — 동그라미, 살짝 위로 솟음 */}
      <div
        style={{
          width: 80,
          display: "flex",
          justifyContent: "center",
          alignItems: "flex-start",
          position: "relative",
          zIndex: 999,
        }}
      >
        <div
          className="tap"
          style={{
            width: 70,
            height: 70,
            borderRadius: 35,
            background: isAiActive
              ? `linear-gradient(135deg, ${t.primaryDark}, ${t.primary})`
              : `linear-gradient(135deg, ${t.primary}, ${t.primaryDark})`,
            marginTop: -14,
            display: "grid",
            placeItems: "center",
            boxShadow: `0 8px 20px ${t.primary}66, 0 2px 6px rgba(0,0,0,0.12)`,
            border: `3px solid ${dark ? "#0a0a0a" : "#fff"}`,
            position: "relative",
            zIndex: 999,
          }}
        >
          {/* AI chef face */}
          <svg
            width="36"
            height="36"
            viewBox="0 0 26 26"
            fill="none"
            style={{ marginBottom: 15 }}
          >
            <path
              d="M13 4c-2 0-3.5 1.5-3.5 3.5 0 0-3 0-4.5 2.5C3.5 12.5 5 15.5 7.5 17c-0.5 3 1.5 5 5.5 5s6-2 5.5-5c2.5-1.5 4-4.5 2.5-7-1.5-2.5-4.5-2.5-4.5-2.5C16.5 5.5 15 4 13 4z"
              fill="#fff"
              stroke="#fff"
              strokeWidth="1"
            />
            <circle cx="10" cy="11" r="1.2" fill={t.primary} />
            <circle cx="16" cy="11" r="1.2" fill={t.primary} />
            <path
              d="M10 15c1 1.5 5 1.5 6 0"
              stroke={t.primary}
              strokeWidth="1.6"
              strokeLinecap="round"
              fill="none"
            />
          </svg>
          {/* sparkle */}
          <div
            style={{
              position: "absolute",
              top: -4,
              right: -4,
              width: 22,
              height: 22,
              borderRadius: 11,
              background: "#fff",
              color: t.primary,
              fontSize: 13,
              fontWeight: 800,
              display: "grid",
              placeItems: "center",
              boxShadow: "0 2px 6px rgba(0,0,0,0.15)",
              zIndex: 1000,
            }}
          >
            ✨
          </div>
          {/* label below */}
          <div
            style={{
              position: "absolute",
              bottom: 9,
              fontSize: 9.5,
              fontWeight: 900,
              color: "rgba(255,255,255,0.75)",
              letterSpacing: -0.2,
            }}
          >
            AI 셰프
          </div>
        </div>
      </div>

      {rightTabs.map(renderTab)}
    </div>
  );
}

// Generic app header for in-app screens
export function AppHeader({
  title,
  leftBack,
  rightIcons,
  t,
  dark,
  transparent,
}) {
  return (
    <div
      style={{
        paddingTop: 50,
        paddingBottom: 10,
        paddingLeft: 18,
        paddingRight: 18,
        display: "flex",
        alignItems: "center",
        gap: 8,
        background: transparent ? "transparent" : dark ? "transparent" : "#fff",
        borderBottom: transparent ? "none" : `1px solid ${t.borderSoft}`,
        flexShrink: 0,
      }}
    >
      {leftBack && (
        <div
          className="tap"
          style={{
            width: 32,
            height: 32,
            display: "grid",
            placeItems: "center",
            marginLeft: -6,
          }}
        >
          <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
            <path
              d="M13 4L7 10l6 6"
              stroke={dark ? "#fff" : t.text}
              strokeWidth="2"
              fill="none"
              strokeLinecap="round"
              strokeLinejoin="round"
            />
          </svg>
        </div>
      )}
      <div
        style={{
          flex: 1,
          fontSize: 17,
          fontWeight: 700,
          color: dark ? "#fff" : t.text,
          letterSpacing: -0.4,
        }}
      >
        {title}
      </div>
      {rightIcons}
    </div>
  );
}

// Soft chip (small pill)
export function Chip({ children, color, bg, border }) {
  return (
    <span
      style={{
        display: "inline-flex",
        alignItems: "center",
        gap: 4,
        padding: "4px 10px",
        borderRadius: 999,
        fontSize: 11.5,
        fontWeight: 600,
        color: color || "#475048",
        background: bg || "#F2F4F0",
        border: border || "none",
        whiteSpace: "nowrap",
      }}
    >
      {children}
    </span>
  );
}

// 재료 이미지 — 실제 이미지가 있으면 표시, 없으면 텍스트 라벨로 폴백
import { vegImg } from "./mock-images";
export function VegPlaceholder({ name, size = 56, t }) {
  const img = vegImg(name);
  const short = size <= 44 ? (name || "").slice(0, 2) : name;
  const fs = size <= 36 ? 10 : size <= 50 ? 11 : 12;
  if (img) {
    return (
      <div
        style={{
          width: size,
          height: size,
          borderRadius: 14,
          flexShrink: 0,
          overflow: "hidden",
          backgroundImage: `url(${img})`,
          backgroundSize: "cover",
          backgroundPosition: "center",
        }}
      />
    );
  }
  return (
    <div
      className="ph ph-veg"
      style={{
        width: size,
        height: size,
        borderRadius: 14,
        display: "grid",
        placeItems: "center",
        flexShrink: 0,
        overflow: "hidden",
      }}
    >
      <span
        style={{
          fontSize: fs,
          fontWeight: 700,
          color: t.primaryDark,
          letterSpacing: -0.3,
          maxWidth: "100%",
          overflow: "hidden",
          textOverflow: "ellipsis",
          whiteSpace: "nowrap",
          padding: "0 4px",
          textAlign: "center",
        }}
      >
        {short}
      </span>
    </div>
  );
}

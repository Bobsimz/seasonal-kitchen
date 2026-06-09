// 농가(생산자) 카드 컴포넌트 군 — 온보딩 · 홈 · 검색 · 리스트 · 상세에서 공유
// 참고 이미지("산지직송 명예생산자"): 원형 사진 + 우하단 초록 왕관 배지 +
// 지역+이름(굵게) + 한 줄 설명. 인라인 스타일 + t 토큰 관례 준수.

import React from "react";
import { styleStyle } from "./producers-data";

// 초록 왕관 배지 — 아바타 우하단에 겹치는 원형 배지
export function CrownBadge({ size = 22, t }) {
  return (
    <div
      style={{
        position: "absolute",
        right: -2,
        bottom: -2,
        width: size,
        height: size,
        borderRadius: size / 2,
        background: t.primary,
        border: "2px solid #fff",
        display: "grid",
        placeItems: "center",
        boxShadow: "0 2px 6px rgba(0,0,0,0.18)",
      }}
    >
      <svg
        width={size * 0.56}
        height={size * 0.56}
        viewBox="0 0 14 14"
        fill="none"
      >
        <path
          d="M1.4 4.3l2.4 2.1L7 1.6l3.2 4.8 2.4-2.1-1 6.6H2.4l-1-6.6z"
          fill="#fff"
        />
      </svg>
    </div>
  );
}

// 원형 아바타 (+왕관) — 캐러셀/리스트 공용
function Avatar({ producer, t, size }) {
  return (
    <div style={{ position: "relative", width: size, height: size, flexShrink: 0 }}>
      <div
        style={{
          width: size,
          height: size,
          borderRadius: size / 2,
          overflow: "hidden",
          backgroundImage: `url(${producer.photo})`,
          backgroundSize: "cover",
          backgroundPosition: "center",
          border: `2px solid #fff`,
          boxShadow: `0 2px 10px rgba(20,40,30,0.12)`,
        }}
      />
      {producer.honorary && <CrownBadge size={Math.round(size * 0.32)} t={t} />}
    </div>
  );
}

// 캐러셀 카드 — 참고 이미지(원형 + 왕관 + 지역·이름 + 한 줄 설명)
export function ProducerCircle({ producer, t, size = 72 }) {
  return (
    <div
      className="tap"
      style={{ width: size + 22, flexShrink: 0, textAlign: "center" }}
    >
      <div style={{ display: "flex", justifyContent: "center" }}>
        <Avatar producer={producer} t={t} size={size} />
      </div>
      <div
        style={{
          fontSize: 12.5,
          fontWeight: 800,
          color: t.text,
          marginTop: 8,
          letterSpacing: -0.3,
          lineHeight: 1.2,
        }}
      >
        {producer.region} {producer.name}
      </div>
      <div
        style={{
          fontSize: 10.5,
          color: t.textSoft,
          marginTop: 2,
          overflow: "hidden",
          textOverflow: "ellipsis",
          whiteSpace: "nowrap",
        }}
      >
        {producer.tagline}
      </div>
    </div>
  );
}

// 리스트/검색 행 — 아바타 + 지역·이름 + 스타일칩 + 한 줄 설명 + ★평점
// trailing: 우측 슬롯 / footer: 하단 슬롯(가격 등을 위아래로 쌓을 때)
export function ProducerRow({ producer, t, trailing, footer, divider }) {
  const ss = styleStyle(producer.style, t);
  return (
    <div
      className="tap"
      style={{
        padding: "13px 14px",
        borderBottom: divider ? `1px solid ${t.borderSoft}` : "none",
      }}
    >
      <div style={{ display: "flex", alignItems: "center", gap: 12 }}>
        <Avatar producer={producer} t={t} size={52} />
        <div style={{ flex: 1, minWidth: 0 }}>
          <div style={{ display: "flex", alignItems: "center", gap: 6 }}>
            <span style={{ fontSize: 14.5, fontWeight: 700, color: t.text }}>
              {producer.region} {producer.name}
            </span>
            <span
              style={{
                fontSize: 10.5,
                fontWeight: 700,
                padding: "2px 8px",
                borderRadius: 999,
                color: ss.color,
                background: ss.bg,
              }}
            >
              {ss.label}
            </span>
          </div>
          <div
            style={{
              fontSize: 11.5,
              color: t.textSoft,
              marginTop: 3,
              overflow: "hidden",
              textOverflow: "ellipsis",
              whiteSpace: "nowrap",
            }}
          >
            {producer.tagline}
          </div>
          <div
            style={{
              display: "flex",
              alignItems: "center",
              gap: 8,
              marginTop: 5,
              fontSize: 11,
              color: t.textMid,
            }}
          >
            <span style={{ fontWeight: 700, color: t.warning }}>
              ★ {producer.rating}
            </span>
            <span style={{ color: t.textSoft }}>
              리뷰 {producer.reviewCount.toLocaleString()}
            </span>
            <span style={{ color: t.textSoft }}>· {producer.badges[0]}</span>
          </div>
        </div>
        {trailing ? (
          <div style={{ flexShrink: 0, textAlign: "right" }}>{trailing}</div>
        ) : (
          <svg
            width="8"
            height="14"
            viewBox="0 0 8 14"
            style={{ flexShrink: 0 }}
          >
            <path
              d="M1 1l6 6-6 6"
              stroke={t.textSoft}
              strokeWidth="1.6"
              fill="none"
              strokeLinecap="round"
              strokeLinejoin="round"
            />
          </svg>
        )}
      </div>
      {footer && (
        <div
          style={{
            marginTop: 10,
            paddingTop: 10,
            borderTop: `1px solid ${t.borderSoft}`,
          }}
        >
          {footer}
        </div>
      )}
    </div>
  );
}

// 온보딩 흩뿌림 카드 — 기존 veg 카드와 동일 chrome, 가격 서브 → 스타일 라벨
export function ProducerFeatureCard({ producer, t, width = 134 }) {
  const ss = styleStyle(producer.style, t);
  return (
    <div
      style={{
        width,
        background: "#fff",
        borderRadius: 18,
        border: `1px solid ${t.borderSoft}`,
        boxShadow: "0 8px 28px rgba(20,40,30,0.12)",
        padding: 12,
      }}
    >
      <div
        style={{
          position: "relative",
          width: "100%",
          height: 96,
          borderRadius: 12,
          overflow: "hidden",
          backgroundImage: `url(${producer.photo})`,
          backgroundSize: "cover",
          backgroundPosition: "center",
        }}
      >
        {producer.honorary && (
          <div style={{ position: "absolute", right: 8, top: 8 }}>
            <div
              style={{
                position: "relative",
                width: 22,
                height: 22,
              }}
            >
              <CrownBadge size={22} t={t} />
            </div>
          </div>
        )}
      </div>
      <div
        style={{
          fontSize: 13,
          fontWeight: 800,
          color: t.text,
          marginTop: 10,
          letterSpacing: -0.3,
        }}
      >
        {producer.region} {producer.name}
      </div>
      <div
        style={{
          fontSize: 11,
          fontWeight: 600,
          color: ss.color,
          marginTop: 3,
        }}
      >
        {ss.label}
      </div>
    </div>
  );
}

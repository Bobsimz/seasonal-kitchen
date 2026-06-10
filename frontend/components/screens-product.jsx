// 상품 탭 — 농가가 등록한 판매 상품 리스트 (식재료 '정보'와 별개의 커머스 목록)
//   · seller=false → 일반 구매자 뷰
//   · seller=true  → 판매 권한 사용자 뷰 (우하단 + FAB → 판매 등록)

import React from "react";
import {
  Phone,
  BottomTabBar,
  VegPlaceholder,
  Chip,
  priceExact,
} from "./phone";

const CATS = ["전체", "잎채소", "뿌리채소", "과일", "곡류", "버섯"];

const PRODUCTS = [
  {
    veg: "봄동",
    name: "햇 봄동 1.5kg 산지직송",
    farm: "해남 송지농원",
    region: "전남 해남",
    rating: "4.9",
    price: 6900,
    unit: "박스",
    tags: ["산지직송", "무료배송"],
  },
  {
    veg: "무",
    name: "해남 황토밭 가을무 3kg",
    farm: "해남 김상도 농가",
    region: "전남 해남",
    rating: "4.8",
    price: 8400,
    unit: "박스",
    tags: ["콜드체인", "흙무"],
  },
  {
    veg: "배추",
    name: "절임 배추 10kg 예약",
    farm: "강원 평창 이수향 농가",
    region: "강원 평창",
    rating: "4.9",
    price: 23900,
    unit: "박스",
    tags: ["유기농", "예약판매"],
  },
  {
    veg: "감귤",
    name: "제주 노지 감귤 5kg",
    farm: "제주 권민성 농가",
    region: "제주 서귀포",
    rating: "5.0",
    price: 18900,
    unit: "박스",
    tags: ["프리미엄", "무료배송"],
  },
  {
    veg: "시금치",
    name: "포항초 시금치 1kg",
    farm: "경북 포항 박정후 농가",
    region: "경북 포항",
    rating: "4.7",
    price: 7200,
    unit: "단",
    tags: ["제철", "산지직송"],
  },
];

// 검색 결과용 상품 세트 (검색어 → 상품 목록)
const PRODUCTS_BY_QUERY = {
  봄동: [
    {
      veg: "봄동",
      name: "햇 봄동 1.5kg 산지직송",
      farm: "해남 송지농원",
      region: "전남 해남",
      rating: "4.9",
      price: 6900,
      unit: "박스",
      tags: ["산지직송", "무료배송"],
    },
    {
      veg: "봄동",
      name: "유기농 봄동 1kg",
      farm: "영천 권민성 농가",
      region: "경북 영천",
      rating: "4.8",
      price: 5400,
      unit: "단",
      tags: ["유기농", "콜드체인"],
    },
    {
      veg: "봄동",
      name: "봄동 겉절이용 2kg",
      farm: "해남 김상도 농가",
      region: "전남 해남",
      rating: "4.7",
      price: 9800,
      unit: "박스",
      tags: ["산지직송", "대용량"],
    },
  ],
};

function ProductCard({ p, t }) {
  return (
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
      <VegPlaceholder name={p.veg} size={72} t={t} />
      <div style={{ flex: 1, minWidth: 0 }}>
        <div
          style={{
            fontSize: 14.5,
            fontWeight: 800,
            color: t.text,
            letterSpacing: -0.2,
            whiteSpace: "nowrap",
            overflow: "hidden",
            textOverflow: "ellipsis",
          }}
        >
          {p.name}
        </div>
        <div
          style={{
            fontSize: 11.5,
            color: t.textSoft,
            marginTop: 3,
            display: "flex",
            alignItems: "center",
            gap: 5,
            whiteSpace: "nowrap",
            overflow: "hidden",
            textOverflow: "ellipsis",
          }}
        >
          <span>{p.farm}</span>
          <span style={{ color: t.primary, fontWeight: 700 }}>★ {p.rating}</span>
        </div>
        <div style={{ display: "flex", gap: 5, marginTop: 7 }}>
          {p.tags.map((tag) => (
            <Chip key={tag} color={t.primaryDark} bg={t.primaryBg}>
              {tag}
            </Chip>
          ))}
        </div>
      </div>
      <div style={{ textAlign: "right", flexShrink: 0 }}>
        <div
          style={{
            fontSize: 16,
            fontWeight: 800,
            color: t.text,
            fontFeatureSettings: '"tnum"',
            whiteSpace: "nowrap",
          }}
        >
          ₩{priceExact(p.price)}
        </div>
        <div style={{ fontSize: 11, color: t.textSoft, marginTop: 1 }}>
          /{p.unit}
        </div>
      </div>
    </div>
  );
}

export function ScreenProductList({ t, seller = false, query = "" }) {
  const list = query ? PRODUCTS_BY_QUERY[query] || [] : PRODUCTS;
  return (
    <Phone t={t} tabBar={<BottomTabBar active="product" t={t} />}>
      {/* 헤더 — 검색 결과면 뒤로가기+검색어, 기본 탭이면 타이틀+검색·장바구니 (둘 중 하나만) */}
      <div
        style={{
          paddingTop: 50,
          padding: "50px 16px 12px",
          background: "#fff",
          borderBottom: `1px solid ${t.borderSoft}`,
          display: "flex",
          alignItems: "center",
          gap: 8,
        }}
      >
        {query ? (
          <React.Fragment>
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
                  stroke={t.text}
                  strokeWidth="2"
                  fill="none"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                />
              </svg>
            </div>
            <span
              style={{
                flex: 1,
                fontSize: 16,
                fontWeight: 700,
                color: t.text,
                letterSpacing: -0.3,
              }}
            >
              ‘{query}’ 검색 결과
            </span>
          </React.Fragment>
        ) : (
          <React.Fragment>
            <div
              style={{
                flex: 1,
                fontSize: 18,
                fontWeight: 800,
                color: t.text,
                letterSpacing: -0.4,
                display: "flex",
                alignItems: "center",
                gap: 6,
              }}
            >
              상품
              {seller && (
                <span
                  style={{
                    fontSize: 10.5,
                    fontWeight: 800,
                    color: t.primaryDark,
                    background: t.primaryBg,
                    padding: "2px 8px",
                    borderRadius: 999,
                  }}
                >
                  판매자
                </span>
              )}
            </div>
            {/* 검색 */}
            <div
              className="tap"
              style={{
                width: 32,
                height: 32,
                display: "grid",
                placeItems: "center",
              }}
            >
              <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                <circle cx="9" cy="9" r="6" stroke={t.text} strokeWidth="1.7" />
                <path
                  d="M13.5 13.5L17 17"
                  stroke={t.text}
                  strokeWidth="1.7"
                  strokeLinecap="round"
                />
              </svg>
            </div>
            {/* 장바구니 */}
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
              <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
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
                  top: 0,
                  right: 0,
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
          </React.Fragment>
        )}
      </div>

      <div
        className="phone-scroll"
        style={{ flex: 1, overflow: "auto", background: t.bg, position: "relative" }}
      >
        {/* 카테고리 pill */}
        <div
          className="phone-scroll"
          style={{
            display: "flex",
            gap: 6,
            overflowX: "auto",
            padding: "14px 16px 4px",
          }}
        >
          {CATS.map((c, i) => (
            <div
              key={c}
              className="tap"
              style={{
                padding: "7px 14px",
                borderRadius: 999,
                fontSize: 12.5,
                fontWeight: 700,
                background: i === 0 ? t.text : "#fff",
                border: i === 0 ? "none" : `1px solid ${t.border}`,
                color: i === 0 ? "#fff" : t.textMid,
                whiteSpace: "nowrap",
                flexShrink: 0,
              }}
            >
              {c}
            </div>
          ))}
        </div>

        {/* 정렬/개수 행 */}
        <div
          style={{
            padding: "12px 20px 8px",
            display: "flex",
            alignItems: "center",
            justifyContent: "space-between",
          }}
        >
          <span style={{ fontSize: 12.5, color: t.textMid }}>
            {query && <b style={{ color: t.text }}>‘{query}’ </b>}
            <b style={{ color: t.text }}>{list.length}개</b> 상품
          </span>
          <div
            style={{
              display: "flex",
              alignItems: "center",
              gap: 4,
              fontSize: 12.5,
              fontWeight: 700,
              color: t.text,
            }}
          >
            추천순
            <svg width="10" height="10" viewBox="0 0 10 10">
              <path
                d="M2 3.5l3 3 3-3"
                stroke="currentColor"
                strokeWidth="1.6"
                fill="none"
                strokeLinecap="round"
                strokeLinejoin="round"
              />
            </svg>
          </div>
        </div>

        {/* 상품 리스트 */}
        <div
          style={{
            display: "flex",
            flexDirection: "column",
            gap: 10,
            padding: "0 16px 24px",
          }}
        >
          {list.map((p, i) => (
            <ProductCard key={i} p={p} t={t} />
          ))}
        </div>

        {/* 판매 권한 사용자 — 우하단 + FAB (당근 UI 참고) → 판매 등록 (검색 결과에선 숨김) */}
        {seller && !query && (
          <div
            className="tap"
            style={{
              position: "sticky",
              bottom: 20,
              marginLeft: "auto",
              marginRight: 18,
              width: "fit-content",
              display: "flex",
              alignItems: "center",
              gap: 6,
              height: 52,
              padding: "0 20px 0 16px",
              borderRadius: 26,
              background: `linear-gradient(135deg, ${t.primary}, ${t.primaryDark})`,
              color: "#fff",
              boxShadow: `0 8px 20px ${t.primary}66, 0 2px 6px rgba(0,0,0,0.12)`,
            }}
          >
            <span style={{ fontSize: 22, fontWeight: 400, lineHeight: 1 }}>＋</span>
            <span style={{ fontSize: 14.5, fontWeight: 800, letterSpacing: -0.3 }}>
              판매 등록
            </span>
          </div>
        )}
      </div>
    </Phone>
  );
}

export function ScreenProductListSeller({ t }) {
  return <ScreenProductList t={t} seller />;
}

// 16b — 상품 검색 결과 (검색 시 나오는 상품 페이지)
export function ScreenProductListSearchResult({ t }) {
  return <ScreenProductList t={t} query="봄동" />;
}

// Ingredient list, detail, and price comparison

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
import { PriceBadge } from "./screens-home";
import { DISH_IMG, FACE_IMG } from "./mock-images";
import {
  PRODUCERS,
  HONORARY_PRODUCERS,
  producersForIngredient,
  producerOffer,
} from "./producers-data";
import { ProducerCircle, ProducerRow } from "./producer-card";

// ─────────────────────────────────────────────────────────────
// LIST — 식재료 카테고리 리스트
// ─────────────────────────────────────────────────────────────
export function ScreenList({ t }) {
  return (
    <Phone t={t} tabBar={<BottomTabBar active="info" t={t} />}>
      <div
        className="phone-scroll"
        style={{ flex: 1, overflow: "auto", background: t.bg }}
      >
        <ListHeader t={t} mode="ingredient" />
        <IngredientListBody t={t} />
      </div>
    </Phone>
  );
}

export function ScreenRecipeList({ t }) {
  return (
    <Phone t={t} tabBar={<BottomTabBar active="info" t={t} />}>
      <div
        className="phone-scroll"
        style={{ flex: 1, overflow: "auto", background: t.bg }}
      >
        <ListHeader t={t} mode="recipe" />
        <RecipeListBody t={t} />
      </div>
    </Phone>
  );
}

// Searched state — '봄동' 검색 결과 (탭 전환해도 동일 검색어 유지)
export function ScreenListSearchResult({ t }) {
  const query = "봄동";
  return (
    <Phone t={t} tabBar={<BottomTabBar active="info" t={t} />}>
      <div
        className="phone-scroll"
        style={{ flex: 1, overflow: "auto", background: t.bg }}
      >
        <ListHeader t={t} mode="ingredient" query={query} />
        <IngredientListBody t={t} query={query} />
      </div>
    </Phone>
  );
}

export function ScreenRecipeListSearchResult({ t }) {
  const query = "봄동";
  return (
    <Phone t={t} tabBar={<BottomTabBar active="info" t={t} />}>
      <div
        className="phone-scroll"
        style={{ flex: 1, overflow: "auto", background: t.bg }}
      >
        <ListHeader t={t} mode="recipe" query={query} />
        <RecipeListBody t={t} query={query} />
      </div>
    </Phone>
  );
}

// 농가 탭 — 베스트 농가 캐러셀 + 카테고리/정렬 + 농가 리스트
export function ScreenProducerList({ t, query = "" }) {
  return (
    <Phone t={t} tabBar={<BottomTabBar active="info" t={t} />}>
      <div
        className="phone-scroll"
        style={{ flex: 1, overflow: "auto", background: t.bg }}
      >
        <ListHeader t={t} mode="producer" query={query} />
        <ProducerListBody t={t} query={query} />
      </div>
    </Phone>
  );
}

export function ScreenProducerListSearchResult({ t }) {
  return <ScreenProducerList t={t} query="봄동" />;
}

function ProducerListBody({ t, query = "" }) {
  const cats = [
    "전체",
    "잎채소",
    "뿌리채소",
    "과일",
    "곡류",
    "해산물",
    "유기농",
    "프리미엄",
  ];
  const list = query
    ? producersForIngredient(query)
    : PRODUCERS;

  return (
    <React.Fragment>
      {/* ── 베스트 농가 — 크라운-써클 캐러셀 ── */}
      <div
        style={{
          padding: "16px 20px 0",
          display: "flex",
          alignItems: "baseline",
          justifyContent: "space-between",
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
          👑 이번주 <span style={{ color: t.primary }}>베스트 농가</span>
        </div>
        <span style={{ fontSize: 12, color: t.primary, fontWeight: 700 }}>
          전체 →
        </span>
      </div>
      <div
        className="phone-scroll"
        style={{ display: "flex", gap: 14, overflowX: "auto", padding: "12px 20px 4px" }}
      >
        {HONORARY_PRODUCERS.map((p) => (
          <ProducerCircle key={p.id} producer={p} t={t} size={68} />
        ))}
      </div>

      {/* ── 카테고리 pill ── */}
      <div
        className="phone-scroll"
        style={{ display: "flex", gap: 6, overflowX: "auto", padding: "14px 20px 0" }}
      >
        {cats.map((c, i) => (
          <div
            key={i}
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

      {/* ── 정렬 행 ── */}
      <div
        style={{
          padding: "14px 20px 8px",
          display: "flex",
          alignItems: "center",
          justifyContent: "space-between",
        }}
      >
        <span style={{ fontSize: 12.5, color: t.textMid }}>
          <b style={{ color: t.text }}>{list.length}곳</b>
          {query ? `의 '${query}' 농가` : "의 추천 농가"}
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
          평점 높은 순
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

      {/* ── 농가 리스트 ── */}
      <div
        style={{
          background: "#fff",
          margin: "0 16px",
          borderRadius: 18,
          border: `1px solid ${t.borderSoft}`,
          overflow: "hidden",
        }}
      >
        {list.map((p, i, arr) => (
          <ProducerRow
            key={p.id}
            producer={p}
            t={t}
            divider={i < arr.length - 1}
          />
        ))}
      </div>
      <div style={{ height: 24 }} />
    </React.Fragment>
  );
}

// Shared header with mode toggle (식재료 ⇄ 레시피)
function ListHeader({ t, mode, query = "" }) {
  const counts =
    query === "봄동"
      ? { ingredient: 1, recipe: 3 }
      : { ingredient: 14, recipe: 86 };
  return (
    <div
      style={{
        paddingTop: 50,
        padding: "50px 20px 12px",
        background: "#fff",
        borderBottom: `1px solid ${t.borderSoft}`,
      }}
    >
      {/* 최상단: 검색 결과면 뒤로가기, 기본 탭이면 검색·장바구니 (둘 중 하나만) */}
      <div
        style={{
          display: "flex",
          alignItems: "center",
          gap: 8,
          marginBottom: 12,
          minHeight: 32,
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
                fontSize: 15,
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
            <span
              style={{
                flex: 1,
                fontSize: 18,
                fontWeight: 800,
                color: t.text,
                letterSpacing: -0.4,
              }}
            >
              정보
            </span>
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
      {/* Mode toggle — pill segmented */}
      <div
        style={{
          display: "flex",
          background: t.bgSoft,
          borderRadius: 12,
          padding: 4,
          gap: 4,
        }}
      >
        {[
          { id: "ingredient", label: "식재료", count: counts.ingredient },
          { id: "recipe", label: "레시피", count: counts.recipe },
        ].map((tab) => {
          const active = mode === tab.id;
          return (
            <div
              key={tab.id}
              className="tap"
              style={{
                flex: 1,
                padding: "10px 12px",
                borderRadius: 9,
                background: active ? "#fff" : "transparent",
                boxShadow: active ? "0 2px 6px rgba(20,40,30,0.08)" : "none",
                display: "flex",
                alignItems: "center",
                justifyContent: "center",
                gap: 6,
                fontSize: 13.5,
                fontWeight: active ? 800 : 600,
                color: active ? t.text : t.textSoft,
              }}
            >
              {tab.label}
              <span
                style={{
                  fontSize: 11,
                  fontWeight: 700,
                  color: active ? t.primary : t.textSoft,
                  background: active ? t.primaryBg : "transparent",
                  padding: "1px 7px",
                  borderRadius: 999,
                }}
              >
                {tab.count}
              </span>
            </div>
          );
        })}
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 식재료 본문
// ─────────────────────────────────────────────────────────────
function IngredientListBody({ t, query = "" }) {
  const cats = ["전체", "잎채소", "뿌리", "과일", "곡류", "육류", "해산물"];
  const allItems = [
    {
      name: "봄동",
      cat: "잎채소",
      price: "2,400",
      range: "2,100~2,800",
      unit: "단",
      delta: "-22%",
      tag: "제철 적기",
      dn: true,
    },
    {
      name: "무",
      cat: "뿌리",
      price: "1,200",
      range: "1,050~1,380",
      unit: "단",
      delta: "-15%",
      tag: "구매 적기",
      dn: true,
    },
    {
      name: "배추",
      cat: "잎채소",
      price: "3,200",
      range: "2,800~3,600",
      unit: "포기",
      delta: "-22%",
      tag: "과잉",
      dn: true,
    },
    {
      name: "시금치",
      cat: "잎채소",
      price: "1,890",
      range: "1,600~2,200",
      unit: "100g",
      delta: "-8%",
      tag: "제철",
      dn: true,
    },
    {
      name: "감귤",
      cat: "과일",
      price: "8,900",
      range: "7,800~9,800",
      unit: "1kg",
      delta: "+12%",
      tag: "인기↑",
      dn: false,
    },
    {
      name: "대파",
      cat: "뿌리",
      price: "3,500",
      range: "3,000~4,200",
      unit: "단",
      delta: "+18%",
      tag: "주의",
      dn: false,
    },
    {
      name: "고구마",
      cat: "뿌리",
      price: "6,200",
      range: "5,500~7,000",
      unit: "1kg",
      delta: "-5%",
      tag: "제철",
      dn: true,
    },
    {
      name: "브로콜리",
      cat: "잎채소",
      price: "2,800",
      range: "2,400~3,200",
      unit: "송이",
      delta: "-3%",
      tag: "안정",
      dn: true,
    },
    {
      name: "단호박",
      cat: "뿌리",
      price: "4,400",
      range: "3,900~4,900",
      unit: "개",
      delta: "-11%",
      tag: "제철",
      dn: true,
    },
  ];
  const items = query
    ? allItems.filter((it) => it.name.includes(query))
    : allItems;
  return (
    <React.Fragment>
      {/* Cats — own row, scrollable */}
      <div
        style={{
          display: "flex",
          gap: 6,
          overflowX: "auto",
          padding: "14px 20px 0",
        }}
        className="phone-scroll"
      >
        {cats.map((c, i) => (
          <div
            key={i}
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

      {/* Sort row */}
      <div
        style={{
          padding: "14px 20px 8px",
          display: "flex",
          alignItems: "center",
          justifyContent: "space-between",
        }}
      >
        <span style={{ fontSize: 12.5, color: t.textMid }}>
          <b style={{ color: t.text }}>{items.length}개</b>
          {query ? `의 '${query}' 검색 결과` : "의 제철 식재료"}
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
          가격 낮은 순
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

      {/* List */}
      <div
        style={{
          background: "#fff",
          margin: "0 16px",
          borderRadius: 18,
          border: `1px solid ${t.borderSoft}`,
          overflow: "hidden",
        }}
      >
        {items.map((it, i) => (
          <div
            key={i}
            className="tap"
            style={{
              display: "flex",
              alignItems: "center",
              gap: 12,
              padding: "13px 14px",
              borderBottom:
                i < items.length - 1 ? `1px solid ${t.borderSoft}` : "none",
            }}
          >
            <VegPlaceholder name={it.name} size={48} t={t} />
            <div style={{ flex: 1, minWidth: 0 }}>
              <div style={{ display: "flex", alignItems: "center", gap: 6 }}>
                <span
                  style={{ fontSize: 14.5, fontWeight: 700, color: t.text }}
                >
                  {it.name}
                </span>
                <Chip
                  color={
                    it.tag.includes("주의") || it.tag.includes("인기")
                      ? t.hot
                      : t.primary
                  }
                  bg={
                    it.tag.includes("주의") || it.tag.includes("인기")
                      ? t.hotBg
                      : t.primaryBg
                  }
                >
                  {it.tag}
                </Chip>
              </div>
              <div style={{ fontSize: 11.5, color: t.textSoft, marginTop: 3 }}>
                {it.cat} · {it.unit}당
              </div>
            </div>
            <div style={{ textAlign: "right" }}>
              <div
                style={{
                  fontSize: 13.5,
                  fontWeight: 800,
                  color: t.text,
                  fontFeatureSettings: '"tnum"',
                  whiteSpace: "nowrap",
                }}
              >
                ₩{it.range}
              </div>
              <PriceBadge
                trend={it.dn ? "down" : "up"}
                value={it.delta}
                t={t}
              />
            </div>
          </div>
        ))}
      </div>
      <div style={{ height: 24 }} />
    </React.Fragment>
  );
}

// ─────────────────────────────────────────────────────────────
// 레시피 본문 — 그리드 + 트렌딩 배너 + 카테고리
// ─────────────────────────────────────────────────────────────
function RecipeListBody({ t, query = "" }) {
  const cats = ["전체", "제철", "국·찌개", "메인", "반찬", "면", "도시락"];
  const allRecipes = [
    {
      name: "봄동 비빔밥",
      tag: "제철",
      time: "10분",
      diff: "쉬움",
      likes: "12.4만",
      cost: 4000,
      user: "쿠킹맘",
      hot: true,
      img: DISH_IMG.봄동비빔밥,
      ingredients: ["봄동"],
    },
    {
      name: "무생채",
      tag: "제철",
      time: "15분",
      diff: "쉬움",
      likes: "8.4만",
      cost: 4200,
      user: "쿠킹맘",
      img: DISH_IMG.무생채,
      ingredients: ["무"],
    },
    {
      name: "봄동 새우전",
      tag: "제철",
      time: "20분",
      diff: "쉬움",
      likes: "6.2만",
      cost: 7800,
      user: "안성재",
      img: DISH_IMG.봄동새우전,
      ingredients: ["봄동"],
    },
    {
      name: "배추전",
      tag: "구매 적기",
      time: "20분",
      diff: "쉬움",
      likes: "5.1만",
      cost: 5800,
      user: "안성재",
      img: DISH_IMG.배추전,
      ingredients: ["배추"],
    },
    {
      name: "봄동 쌈밥",
      tag: "제철",
      time: "15분",
      diff: "쉬움",
      likes: "4.7만",
      cost: 5400,
      user: "백종원",
      img: DISH_IMG.봄동쌈밥,
      ingredients: ["봄동"],
    },
    {
      name: "시금치 페스토",
      tag: "제철",
      time: "25분",
      diff: "보통",
      likes: "3.2만",
      cost: 6500,
      user: "백종원",
      img: DISH_IMG.시금치페스토,
      ingredients: ["시금치"],
    },
    {
      name: "깍두기",
      tag: "제철",
      time: "40분",
      diff: "보통",
      likes: "2.8만",
      cost: 8900,
      user: "김자영",
      img: DISH_IMG.깍두기,
      ingredients: ["무"],
    },
    {
      name: "비빔밥",
      tag: "핫템",
      time: "10분",
      diff: "쉬움",
      likes: "12.4만",
      cost: 3500,
      user: "쿠킹맘",
      hot: true,
      img: DISH_IMG.비빔밥,
      ingredients: ["밥", "나물", "고추장"],
    },
    {
      name: "나물 무침",
      tag: "제철",
      time: "15분",
      diff: "쉬움",
      likes: "1.9만",
      cost: 9200,
      user: "에밀리",
      img: DISH_IMG.나물무침,
      ingredients: ["나물"],
    },
  ];
  const recipes = query
    ? allRecipes.filter(
        (r) =>
          r.name.includes(query) ||
          (r.ingredients && r.ingredients.includes(query)),
      )
    : allRecipes;
  return (
    <React.Fragment>
      {/* Cats */}
      <div
        style={{
          display: "flex",
          gap: 6,
          overflowX: "auto",
          padding: "14px 20px 0",
        }}
        className="phone-scroll"
      >
        {cats.map((c, i) => (
          <div
            key={i}
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

      {/* Trending hero — 1 featured */}
      <div style={{ padding: "14px 16px 0" }}>
        <div
          className="tap"
          style={{
            position: "relative",
            borderRadius: 20,
            overflow: "hidden",
            aspectRatio: "16/9",
          }}
        >
          <div
            style={{
              position: "absolute",
              inset: 0,
              backgroundImage: `url(${DISH_IMG.봄동비빔밥히어로})`,
              backgroundSize: "cover",
              backgroundPosition: "center",
            }}
          >
            <div
              style={{
                position: "absolute",
                inset: 0,
                background:
                  "linear-gradient(180deg, transparent 30%, rgba(0,0,0,0.85) 100%)",
              }}
            />
          </div>
          <div
            style={{
              position: "absolute",
              top: 12,
              left: 12,
              display: "flex",
              gap: 6,
            }}
          >
            <span
              style={{
                fontSize: 11,
                fontWeight: 800,
                padding: "4px 10px",
                borderRadius: 999,
                background: t.hot,
                color: "#fff",
                width: 90,
              }}
            >
              🔥 이번 주 1위
            </span>
            <span
              style={{
                fontSize: 11,
                fontWeight: 700,
                padding: "4px 10px",
                borderRadius: 999,
                background: "rgba(255,255,255,0.2)",
                backdropFilter: "blur(8px)",
                color: "#fff",
              }}
            >
              ▶ 124만
            </span>
          </div>
          <div
            style={{
              position: "absolute",
              left: 14,
              right: 14,
              bottom: 12,
              color: "#fff",
            }}
          >
            <div
              style={{
                fontSize: 19,
                fontWeight: 800,
                letterSpacing: -0.5,
                lineHeight: 1.2,
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
                gap: 6,
                marginTop: 8,
                fontSize: 12,
              }}
            >
              <span
                style={{
                  width: 18,
                  height: 18,
                  borderRadius: 9,
                  backgroundImage: `url(${FACE_IMG.cookingMom})`,
                  backgroundSize: "cover",
                  backgroundPosition: "center",
                  display: "inline-block",
                }}
              />
              <span style={{ fontWeight: 700 }}>@쿠킹맘</span>
              <span style={{ opacity: 0.8 }}>· 좋아요 8.4만</span>
            </div>
          </div>
        </div>
      </div>

      {/* Sort row */}
      <div
        style={{
          padding: "14px 20px 8px",
          display: "flex",
          alignItems: "center",
          justifyContent: "space-between",
        }}
      >
        <span style={{ fontSize: 12.5, color: t.textMid }}>
          <b style={{ color: t.text }}>{recipes.length}개</b>
          {query ? `의 '${query}' 레시피` : "의 레시피"}
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
          좋아요 많은 순
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

      {/* Recipe grid 2-col */}
      <div
        style={{
          padding: "0 16px",
          display: "grid",
          gridTemplateColumns: "1fr 1fr",
          gap: 10,
        }}
      >
        {recipes.map((r, i) => (
          <div
            key={i}
            className="tap"
            style={{
              borderRadius: 16,
              background: "#fff",
              border: `1px solid ${t.borderSoft}`,
              overflow: "hidden",
            }}
          >
            <div
              style={{
                aspectRatio: "4/3",
                position: "relative",
                backgroundImage: `url(${r.img})`,
                backgroundSize: "cover",
                backgroundPosition: "center",
              }}
            >
              {r.hot && (
                <div
                  style={{
                    position: "absolute",
                    top: 8,
                    left: 8,
                    fontSize: 10,
                    fontWeight: 800,
                    color: "#fff",
                    background: t.hot,
                    padding: "3px 8px",
                    borderRadius: 999,
                    width: 60,
                  }}
                >
                  🔥 HOT
                </div>
              )}
              <div
                style={{
                  position: "absolute",
                  bottom: 8,
                  right: 8,
                  background: "rgba(0,0,0,0.65)",
                  backdropFilter: "blur(8px)",
                  color: "#fff",
                  fontSize: 10,
                  fontWeight: 700,
                  padding: "3px 7px",
                  borderRadius: 6,
                  fontFeatureSettings: '"tnum"',
                  width: 76,
                }}
              >
                ⏱ {r.time} · {r.diff}
              </div>
            </div>
            <div style={{ padding: "10px 12px 12px" }}>
              <div
                style={{
                  fontSize: 13.5,
                  fontWeight: 800,
                  color: t.text,
                  letterSpacing: -0.3,
                  lineHeight: 1.25,
                }}
              >
                {r.name}
              </div>
              <div style={{ fontSize: 11, color: t.textSoft, marginTop: 4 }}>
                @{r.user}
              </div>
              <div
                style={{
                  display: "flex",
                  alignItems: "center",
                  justifyContent: "space-between",
                  marginTop: 8,
                }}
              >
                <Chip color={t.primary} bg={t.primaryBg}>
                  {r.tag}
                </Chip>
                <span style={{ fontSize: 11, fontWeight: 700, color: t.text }}>
                  ♥ {r.likes}
                </span>
              </div>
              <div
                style={{
                  marginTop: 8,
                  paddingTop: 8,
                  borderTop: `1px solid ${t.borderSoft}`,
                  fontSize: 11.5,
                  color: t.textMid,
                  display: "flex",
                  alignItems: "center",
                  justifyContent: "space-between",
                }}
              >
                <span>재료비</span>
                <span
                  style={{
                    fontWeight: 800,
                    color: t.text,
                    fontFeatureSettings: '"tnum"',
                  }}
                >
                  ₩{priceRange(r.cost)}
                </span>
              </div>
            </div>
          </div>
        ))}
      </div>
      <div style={{ height: 24 }} />
    </React.Fragment>
  );
}

// ─────────────────────────────────────────────────────────────
// DETAIL — 식재료 상세 (열무 reference 기반)
// ─────────────────────────────────────────────────────────────
export function ScreenDetail({ t }) {
  return (
    <Phone t={t}>
      <div
        className="phone-scroll"
        style={{ flex: 1, overflow: "auto", background: t.bg }}
      >
        <AppHeader
          t={t}
          title="제철 식재료"
          leftBack
          rightIcons={
            <div style={{ display: "flex", gap: 6 }}>
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
                  <path
                    d="M10 17s-7-4-7-10a4 4 0 017-3 4 4 0 017 3c0 6-7 10-7 10z"
                    stroke={t.text}
                    strokeWidth="1.6"
                    fill="none"
                  />
                </svg>
              </div>
            </div>
          }
        />

        {/* Hero — veg name + chips */}
        <div style={{ padding: "20px 20px 16px", background: "#fff" }}>
          <div
            style={{
              display: "flex",
              alignItems: "center",
              gap: 12,
              marginBottom: 12,
            }}
          >
            <VegPlaceholder name="무" size={64} t={t} />
            <div>
              <div
                style={{
                  fontSize: 26,
                  fontWeight: 800,
                  color: t.text,
                  letterSpacing: -0.8,
                  lineHeight: 1,
                }}
              >
                무
              </div>
              <div style={{ fontSize: 12, color: t.textSoft, marginTop: 4 }}>
                Radish · 뿌리채소
              </div>
            </div>
          </div>
          <div style={{ display: "flex", gap: 6, flexWrap: "wrap" }}>
            <Chip color={t.primary} bg={t.primaryBg}>
              📦 공급 과잉
            </Chip>
            <Chip color={t.hot} bg={t.hotBg}>
              🔥 트렌드 상승
            </Chip>
            <Chip color={t.primaryDark} bg={t.primaryBg}>
              ✓ 구매 적기
            </Chip>
          </div>
        </div>

        {/* Price block */}
        <div
          style={{
            margin: "12px 16px 0",
            background: "#fff",
            borderRadius: 18,
            border: `1px solid ${t.borderSoft}`,
            padding: 18,
          }}
        >
          <div
            style={{
              display: "flex",
              alignItems: "center",
              gap: 6,
              color: t.textMid,
              fontSize: 12,
              fontWeight: 600,
              marginBottom: 8,
            }}
          >
            <svg width="14" height="14" viewBox="0 0 14 14">
              <rect x="2" y="6" width="2.5" height="6" fill={t.chartGreen} />
              <rect
                x="6"
                y="3"
                width="2.5"
                height="9"
                fill={t.chartGreenDark}
              />
              <rect x="10" y="8" width="2.5" height="4" fill={t.chartGreen} />
            </svg>
            현재 가격
          </div>
          <div
            style={{
              display: "flex",
              alignItems: "baseline",
              flexWrap: "wrap",
              gap: 8,
            }}
          >
            <div
              style={{
                fontSize: 22,
                fontWeight: 800,
                color: t.text,
                letterSpacing: -0.5,
                fontFeatureSettings: '"tnum"',
                whiteSpace: "nowrap",
              }}
            >
              ₩{priceRange(1200)}
              <span
                style={{
                  fontSize: 13,
                  color: t.textMid,
                  fontWeight: 600,
                  marginLeft: 4,
                }}
              >
                /단
              </span>
            </div>
            <Chip color={t.primary} bg={t.primaryBg}>
              📉 평년 -15%
            </Chip>
          </div>
          <div
            style={{
              fontSize: 12,
              color: t.textSoft,
              fontFeatureSettings: '"tnum"',
              marginTop: 4,
            }}
          >
            주요 매장 기준
          </div>

          <div
            style={{
              marginTop: 14,
              paddingTop: 14,
              borderTop: `1px solid ${t.borderSoft}`,
              display: "flex",
              alignItems: "center",
              justifyContent: "space-between",
              fontSize: 11,
              color: t.textSoft,
            }}
          >
            <span>● KAMIS 공식 시세 · 오늘 기준</span>
            <span style={{ color: t.warning }}>★★★★★</span>
          </div>
        </div>

        {/* 이번주 베스트 농가 — 이 재료(무)를 파는 농가 */}
        <div
          style={{
            margin: "12px 16px 0",
            background: "#fff",
            borderRadius: 18,
            border: `1px solid ${t.borderSoft}`,
            padding: "16px 18px 8px",
          }}
        >
          <div
            style={{
              display: "flex",
              alignItems: "center",
              justifyContent: "space-between",
            }}
          >
            <div style={{ fontSize: 16, fontWeight: 800, color: t.text }}>
              👑 이번주 베스트 농가
            </div>
            <span style={{ fontSize: 11, color: t.primary, fontWeight: 700 }}>
              전체 →
            </span>
          </div>
          <div style={{ fontSize: 11.5, color: t.textSoft, marginTop: 4 }}>
            무를 직접 키우는 농가에서 신선하게 받아보세요
          </div>
          <div style={{ marginTop: 4 }}>
            {producersForIngredient("무")
              .slice(0, 3)
              .map((p, i, arr) => {
                const o = producerOffer(p, "무");
                return (
                  <ProducerRow
                    key={p.id}
                    producer={p}
                    t={t}
                    divider={i < arr.length - 1}
                    footer={
                      <div
                        style={{
                          display: "flex",
                          alignItems: "baseline",
                          gap: 6,
                        }}
                      >
                        <span
                          style={{
                            fontSize: 16,
                            fontWeight: 800,
                            color: t.text,
                            fontFeatureSettings: '"tnum"',
                          }}
                        >
                          ₩{priceExact(o.price)}
                        </span>
                        <span style={{ fontSize: 12, color: t.textMid }}>
                          /{o.unit}
                        </span>
                        <span
                          style={{
                            marginLeft: "auto",
                            fontSize: 11.5,
                            fontWeight: 700,
                            color: t.primary,
                          }}
                        >
                          🌱 {o.fresh}
                        </span>
                      </div>
                    }
                  />
                );
              })}
          </div>
        </div>

        {/* 대체 식재료 추천 */}
        <div
          style={{
            margin: "12px 16px 0",
            background: "#fff",
            borderRadius: 18,
            border: `1px solid ${t.borderSoft}`,
            padding: "16px 18px",
          }}
        >
          <div
            style={{
              display: "flex",
              alignItems: "center",
              justifyContent: "space-between",
              marginBottom: 4,
            }}
          >
            <div style={{ fontSize: 14, fontWeight: 800, color: t.text }}>
              대체 식재료 추천
            </div>
            <span style={{ fontSize: 11, color: t.textSoft }}>
              가격·요리 기준
            </span>
          </div>
          <div style={{ fontSize: 11.5, color: t.textSoft, marginBottom: 12 }}>
            무가 없을 때 비슷하게 쓸 수 있는 재료예요
          </div>
          {[
            {
              name: "콜라비",
              reason: "아삭함·생채/깍두기에 무 대용으로 좋아요",
              price: "1,800",
              unit: "개",
              delta: "비슷",
              tone: "neutral",
            },
            {
              name: "순무",
              reason: "국·조림용. 단맛이 더 강해요",
              price: "2,200",
              unit: "단",
              delta: "+8%",
              tone: "up",
            },
            {
              name: "비트",
              reason: "샐러드·피클용. 색이 강하니 양 조절",
              price: "3,400",
              unit: "개",
              delta: "+18%",
              tone: "up",
            },
          ].map((alt, i, arr) => (
            <div
              key={i}
              className="tap"
              style={{
                display: "flex",
                alignItems: "center",
                gap: 12,
                padding: "11px 0",
                borderTop: i === 0 ? `1px solid ${t.borderSoft}` : "none",
                borderBottom:
                  i < arr.length - 1 ? `1px solid ${t.borderSoft}` : "none",
              }}
            >
              <VegPlaceholder name={alt.name} size={40} t={t} />
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontSize: 13.5, fontWeight: 700, color: t.text }}>
                  {alt.name}
                </div>
                <div
                  style={{
                    fontSize: 11.5,
                    color: t.textSoft,
                    marginTop: 2,
                    lineHeight: 1.35,
                  }}
                >
                  {alt.reason}
                </div>
              </div>
              <div style={{ textAlign: "right" }}>
                <div
                  style={{
                    fontSize: 13.5,
                    fontWeight: 800,
                    color: t.text,
                    fontFeatureSettings: '"tnum"',
                  }}
                >
                  ₩{priceRange(alt.price)}
                </div>
                <div
                  style={{
                    fontSize: 10.5,
                    color:
                      alt.tone === "up"
                        ? t.hot
                        : alt.tone === "down"
                          ? t.primary
                          : t.textSoft,
                    marginTop: 2,
                  }}
                >
                  /{alt.unit} · {alt.delta}
                </div>
              </div>
            </div>
          ))}
        </div>

        {/* 손질법 · 보관법 */}
        <div
          style={{
            margin: "12px 16px 0",
            background: "#fff",
            borderRadius: 18,
            border: `1px solid ${t.borderSoft}`,
            padding: "16px 18px",
          }}
        >
          <div
            style={{
              fontSize: 14,
              fontWeight: 800,
              color: t.text,
              marginBottom: 4,
            }}
          >
            손질법
          </div>
          <div style={{ fontSize: 11.5, color: t.textSoft, marginBottom: 10 }}>
            무는 껍질에 식이섬유가 많아요
          </div>
          {[
            "잎과 머리 부분을 잘라내고 흐르는 물에 흙을 씻어내요.",
            "껍질은 얇게 깎거나, 깨끗이 씻어 그대로 사용해도 좋아요.",
            "사용 용도에 맞게 채썰기 · 깍둑썰기 · 나박썰기로 잘라요.",
            "생채로 먹을 땐 소금에 5~10분 절여 물기를 빼면 아삭해요.",
          ].map((step, i, arr) => (
            <div
              key={i}
              style={{
                display: "flex",
                gap: 10,
                padding: "9px 0",
                borderTop: i === 0 ? `1px solid ${t.borderSoft}` : "none",
                borderBottom:
                  i < arr.length - 1 ? `1px solid ${t.borderSoft}` : "none",
              }}
            >
              <div
                style={{
                  width: 20,
                  height: 20,
                  borderRadius: 10,
                  background: t.primaryBg,
                  color: t.primaryDark,
                  fontSize: 11,
                  fontWeight: 800,
                  display: "grid",
                  placeItems: "center",
                  flexShrink: 0,
                  marginTop: 1,
                }}
              >
                {i + 1}
              </div>
              <div
                style={{
                  fontSize: 12.5,
                  color: t.textMid,
                  lineHeight: 1.5,
                  flex: 1,
                }}
              >
                {step}
              </div>
            </div>
          ))}

          <div
            style={{
              fontSize: 14,
              fontWeight: 800,
              color: t.text,
              marginTop: 16,
              marginBottom: 4,
            }}
          >
            보관법
          </div>
          <div style={{ fontSize: 11.5, color: t.textSoft, marginBottom: 10 }}>
            잎과 뿌리를 따로 보관하면 더 오래가요
          </div>
          {[
            { k: "냉장", v: "신문지에 싸서 비닐백 · 7~10일", icon: "🧊" },
            { k: "냉동", v: "깍둑썰기 후 데쳐서 소분 · 2개월", icon: "❄️" },
            { k: "실온", v: "서늘하고 어두운 곳 · 3~5일", icon: "🌡" },
          ].map((s, i, arr) => (
            <div
              key={i}
              style={{
                display: "flex",
                alignItems: "center",
                gap: 12,
                padding: "11px 0",
                borderTop: i === 0 ? `1px solid ${t.borderSoft}` : "none",
                borderBottom:
                  i < arr.length - 1 ? `1px solid ${t.borderSoft}` : "none",
              }}
            >
              <div style={{ fontSize: 18, flexShrink: 0 }}>{s.icon}</div>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 12.5, fontWeight: 700, color: t.text }}>
                  {s.k}
                </div>
                <div
                  style={{ fontSize: 11.5, color: t.textSoft, marginTop: 2 }}
                >
                  {s.v}
                </div>
              </div>
            </div>
          ))}
        </div>

        <div style={{ height: 96 }} />
      </div>

      {/* Floating action bar — 농가에서 구매 */}
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
            flex: 4,
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
              d="M9 16V8M9 8C9 5 6.5 3 3 3c0 3.5 2.5 5 6 5zM9 9c0-2.5 2-4.5 5-4.5 0 3-2 4.5-5 4.5z"
              stroke="#fff"
              strokeWidth="1.5"
              fill="none"
              strokeLinecap="round"
              strokeLinejoin="round"
            />
          </svg>
          농가에서 구매하기
        </button>
      </div>
    </Phone>
  );
}

// ─────────────────────────────────────────────────────────────
// PRICE COMPARE — 쿠팡 / 마켓컬리 / 오아시스 …
// ─────────────────────────────────────────────────────────────
export function ScreenCompare({ t }) {
  // 무를 취급하는 농가 — 가격순 정렬, 최저가 태그
  const farms = producersForIngredient("무")
    .map((p) => {
      const o = producerOffer(p, "무");
      return { producer: p, price: o.price, unit: o.unit, fresh: o.fresh };
    })
    .sort((a, b) => a.price - b.price)
    .map((f, i) => ({ ...f, tag: i === 0 ? "최저가" : null }));
  return (
    <Phone t={t}>
      <AppHeader t={t} title="농가 비교 · 무 1단" leftBack />
      <div
        className="phone-scroll"
        style={{ flex: 1, overflow: "auto", background: t.bgSoft }}
      >
        {/* Summary bar */}
        <div
          style={{
            background: "#fff",
            padding: "14px 20px 16px",
            borderBottom: `1px solid ${t.borderSoft}`,
          }}
        >
          <div style={{ display: "flex", alignItems: "center", gap: 12 }}>
            <VegPlaceholder name="무" size={52} t={t} />
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 11, fontWeight: 700, color: t.primary }}>
                {farms.length}개 농가 · 산지직송
              </div>
              <div
                style={{
                  fontSize: 17,
                  fontWeight: 800,
                  color: t.text,
                  marginTop: 1,
                  letterSpacing: -0.4,
                }}
              >
                무 1단 · 1kg 내외
              </div>
              <div style={{ fontSize: 11.5, color: t.textSoft, marginTop: 2 }}>
                국내산 · 친환경 인증
              </div>
            </div>
          </div>

          <div
            style={{
              display: "flex",
              gap: 6,
              marginTop: 14,
              overflowX: "auto",
            }}
            className="phone-scroll"
          >
            {["가격순", "신선도순", "리뷰순", "🥇 최저가만"].map((f, i) => (
              <div
                key={i}
                style={{
                  padding: "7px 12px",
                  borderRadius: 999,
                  fontSize: 12,
                  fontWeight: 700,
                  whiteSpace: "nowrap",
                  flexShrink: 0,
                  background: i === 0 ? t.text : "#fff",
                  color: i === 0 ? "#fff" : t.textMid,
                  border: i === 0 ? "none" : `1px solid ${t.border}`,
                }}
              >
                {f}
              </div>
            ))}
          </div>
        </div>

        {/* Platform list */}
        <div style={{ padding: "14px 16px 0" }}>
          <div
            style={{
              fontSize: 12,
              fontWeight: 700,
              color: t.textMid,
              padding: "0 4px 8px",
            }}
          >
            전체 비교 · {farms.length}곳
          </div>
          <div
            style={{
              background: "#fff",
              borderRadius: 18,
              border: `1px solid ${t.borderSoft}`,
              overflow: "hidden",
            }}
          >
            {farms.map((f, i) => (
              <div
                key={f.producer.id}
                className="tap"
                style={{
                  padding: "14px 16px",
                  borderBottom:
                    i < farms.length - 1
                      ? `1px solid ${t.borderSoft}`
                      : "none",
                }}
              >
                {/* 농가 정보 */}
                <div
                  style={{ display: "flex", alignItems: "center", gap: 12 }}
                >
                  <div
                    style={{
                      position: "relative",
                      width: 40,
                      height: 40,
                      flexShrink: 0,
                    }}
                  >
                    <div
                      style={{
                        width: 40,
                        height: 40,
                        borderRadius: 20,
                        overflow: "hidden",
                        backgroundImage: `url(${f.producer.photo})`,
                        backgroundSize: "cover",
                        backgroundPosition: "center",
                      }}
                    />
                    {f.producer.honorary && (
                      <div
                        style={{
                          position: "absolute",
                          right: -2,
                          bottom: -2,
                          width: 16,
                          height: 16,
                          borderRadius: 8,
                          background: t.primary,
                          border: "1.5px solid #fff",
                          display: "grid",
                          placeItems: "center",
                          fontSize: 8,
                        }}
                      >
                        👑
                      </div>
                    )}
                  </div>
                  <div style={{ flex: 1, minWidth: 0 }}>
                    <div
                      style={{ display: "flex", alignItems: "center", gap: 6 }}
                    >
                      <span
                        style={{ fontSize: 14, fontWeight: 700, color: t.text }}
                      >
                        {f.producer.region} {f.producer.name}
                      </span>
                      {f.tag && (
                        <Chip color={t.primary} bg={t.primaryBg}>
                          {f.tag}
                        </Chip>
                      )}
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
                      {f.producer.tagline}
                    </div>
                  </div>
                  <svg width="8" height="14" viewBox="0 0 8 14">
                    <path
                      d="M1 1l6 6-6 6"
                      stroke={t.textSoft}
                      strokeWidth="1.6"
                      fill="none"
                      strokeLinecap="round"
                      strokeLinejoin="round"
                    />
                  </svg>
                </div>
                {/* 가격 — 아래에 위아래로 */}
                <div
                  style={{
                    marginTop: 10,
                    paddingTop: 10,
                    borderTop: `1px solid ${t.borderSoft}`,
                    display: "flex",
                    alignItems: "baseline",
                    gap: 6,
                  }}
                >
                  <span
                    style={{
                      fontSize: 16,
                      fontWeight: 800,
                      color: t.text,
                      fontFeatureSettings: '"tnum"',
                    }}
                  >
                    ₩{priceExact(f.price)}
                  </span>
                  <span style={{ fontSize: 12, color: t.textMid }}>
                    /{f.unit}
                  </span>
                  <span
                    style={{
                      marginLeft: "auto",
                      fontSize: 11.5,
                      fontWeight: 700,
                      color: t.primary,
                    }}
                  >
                    🌱 {f.fresh}
                  </span>
                </div>
              </div>
            ))}
          </div>
          <div
            style={{
              marginTop: 10,
              padding: "10px 14px",
              background: "#fff",
              borderRadius: 12,
              border: `1px dashed ${t.border}`,
              fontSize: 11.5,
              color: t.textMid,
              lineHeight: 1.5,
            }}
          >
            <b style={{ color: t.text }}>참고</b> · 가격은 1단(1kg 기준)으로
            환산했어요. 배송비 · 수확일은 각 농가에서 확인하세요.
          </div>
        </div>

        {/* Alert */}
        <div style={{ padding: "14px 16px 24px" }}>
          <div
            className="tap"
            style={{
              borderRadius: 16,
              padding: 14,
              background: "#fff",
              border: `1px solid ${t.borderSoft}`,
              display: "flex",
              alignItems: "center",
              gap: 12,
            }}
          >
            <div
              style={{
                width: 36,
                height: 36,
                borderRadius: 12,
                background: t.primaryBg,
                display: "grid",
                placeItems: "center",
              }}
            >
              <svg width="18" height="18" viewBox="0 0 18 18" fill="none">
                <path
                  d="M4 8a5 5 0 0110 0v2l2 2H2l2-2V8z"
                  stroke={t.primary}
                  strokeWidth="1.5"
                  strokeLinejoin="round"
                />
              </svg>
            </div>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 13, fontWeight: 700, color: t.text }}>
                가격 하락 알림 받기
              </div>
              <div style={{ fontSize: 11, color: t.textSoft, marginTop: 2 }}>
                1,100원 이하로 내려가면 알려드릴게요
              </div>
            </div>
            <div
              style={{
                width: 38,
                height: 22,
                borderRadius: 11,
                background: t.borderSoft,
                position: "relative",
              }}
            >
              <div
                style={{
                  position: "absolute",
                  left: 2,
                  top: 2,
                  width: 18,
                  height: 18,
                  borderRadius: 9,
                  background: "#fff",
                  boxShadow: "0 1px 3px rgba(0,0,0,0.2)",
                }}
              />
            </div>
          </div>
        </div>
      </div>
    </Phone>
  );
}

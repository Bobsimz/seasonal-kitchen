// Ingredient list, detail, and price comparison

import React from "react";
import {
  Phone,
  BottomTabBar,
  AppHeader,
  VegPlaceholder,
  Chip,
  priceRange,
} from "./phone";
import { PriceBadge } from "./screens-home";
import { DISH_IMG, FACE_IMG } from "./mock-images";

// ─────────────────────────────────────────────────────────────
// LIST — 식재료 카테고리 리스트
// ─────────────────────────────────────────────────────────────
export function ScreenList({ t }) {
  return (
    <Phone t={t} tabBar={<BottomTabBar active="list" t={t} />}>
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
    <Phone t={t} tabBar={<BottomTabBar active="list" t={t} />}>
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
    <Phone t={t} tabBar={<BottomTabBar active="list" t={t} />}>
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
    <Phone t={t} tabBar={<BottomTabBar active="list" t={t} />}>
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
      {/* Search — moved to top for consistency with home search */}
      <div
        style={{
          height: 44,
          borderRadius: 12,
          background: t.bgSoft,
          display: "flex",
          alignItems: "center",
          padding: "0 12px",
          gap: 8,
          marginBottom: 12,
        }}
      >
        <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
          <circle cx="7" cy="7" r="5" stroke={t.textSoft} strokeWidth="1.5" />
          <path
            d="M10.5 10.5L14 14"
            stroke={t.textSoft}
            strokeWidth="1.5"
            strokeLinecap="round"
          />
        </svg>
        {query ? (
          <React.Fragment>
            <span
              style={{
                flex: 1,
                fontSize: 14,
                color: t.text,
                fontWeight: 600,
              }}
            >
              {query}
            </span>
            <div style={{ color: t.textSoft, fontSize: 18, lineHeight: 1 }}>
              ✕
            </div>
          </React.Fragment>
        ) : (
          <span style={{ flex: 1, fontSize: 13.5, color: t.textSoft }}>
            {mode === "ingredient"
              ? "식재료 검색 (무, 배추, …)"
              : "레시피 검색 (무생채, 김치찌개, …)"}
          </span>
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
  // Price trend bars
  const months = [
    { m: "1월", v: 0.5 },
    { m: "2월", v: 0.48 },
    { m: "3월", v: 0.55 },
    { m: "4월", v: 0.7 },
    { m: "5월", v: 0.4, now: true },
    { m: "6월", v: 0.66, future: true },
    { m: "7월", v: 0.72, future: true },
  ];
  const maxBar = 120;
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
            가격 동향
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

          {/* Bar chart */}
          <div
            style={{
              marginTop: 22,
              display: "flex",
              alignItems: "flex-end",
              gap: 8,
              height: maxBar,
            }}
          >
            {months.map((m, i) => (
              <div
                key={i}
                style={{
                  flex: 1,
                  display: "flex",
                  flexDirection: "column",
                  alignItems: "center",
                  gap: 6,
                }}
              >
                {m.now && (
                  <div
                    style={{
                      fontSize: 10,
                      fontWeight: 700,
                      color: t.primaryDark,
                      marginBottom: -2,
                    }}
                  >
                    ▼ 최저
                  </div>
                )}
                <div
                  style={{
                    width: "100%",
                    height: m.v * maxBar,
                    borderRadius: 4,
                    background: m.future
                      ? t.chartGray
                      : m.now
                        ? t.chartGreenDark
                        : t.chartGreen,
                  }}
                />
                <div
                  style={{ fontSize: 10, color: t.textSoft, fontWeight: 600 }}
                >
                  {m.m}
                </div>
              </div>
            ))}
          </div>
          {/* Legend */}
          <div
            style={{
              display: "flex",
              justifyContent: "flex-end",
              gap: 12,
              marginTop: 8,
              fontSize: 10.5,
              color: t.textSoft,
            }}
          >
            <span style={{ display: "flex", alignItems: "center", gap: 4 }}>
              <span
                style={{
                  width: 6,
                  height: 6,
                  borderRadius: 3,
                  background: t.chartGreenDark,
                }}
              />
              현재
            </span>
            <span style={{ display: "flex", alignItems: "center", gap: 4 }}>
              <span
                style={{
                  width: 6,
                  height: 6,
                  borderRadius: 3,
                  background: t.chartGreen,
                }}
              />
              실측
            </span>
            <span style={{ display: "flex", alignItems: "center", gap: 4 }}>
              <span
                style={{
                  width: 6,
                  height: 6,
                  borderRadius: 3,
                  background: t.chartGray,
                }}
              />
              예측
            </span>
          </div>

          {/* Mini metrics — 3 in a row */}
          <div
            style={{
              display: "grid",
              gridTemplateColumns: "1fr 1fr 1fr",
              gap: 6,
              marginTop: 16,
            }}
          >
            <div
              style={{ background: t.bgSoft, borderRadius: 12, padding: 10 }}
            >
              <div
                style={{ fontSize: 10.5, color: t.textMid, fontWeight: 600 }}
              >
                전월 대비
              </div>
              <div
                style={{
                  fontSize: 15,
                  fontWeight: 800,
                  color: t.primary,
                  marginTop: 3,
                }}
              >
                ▼ 8%
              </div>
            </div>
            <div
              style={{ background: t.bgSoft, borderRadius: 12, padding: 10 }}
            >
              <div
                style={{ fontSize: 10.5, color: t.textMid, fontWeight: 600 }}
              >
                공급 상태
              </div>
              <div
                style={{
                  fontSize: 15,
                  fontWeight: 800,
                  color: t.text,
                  marginTop: 3,
                }}
              >
                과잉
              </div>
              <div style={{ fontSize: 10, color: t.textSoft, marginTop: 2 }}>
                출하량 +18%
              </div>
            </div>
            <div
              style={{
                background: `linear-gradient(135deg, ${t.primaryBg}, ${t.primarySoft})`,
                borderRadius: 12,
                padding: 10,
              }}
            >
              <div
                style={{
                  fontSize: 10.5,
                  color: t.primaryDark,
                  fontWeight: 700,
                }}
              >
                AI 판단
              </div>
              <div
                style={{
                  fontSize: 15,
                  fontWeight: 800,
                  color: t.primaryDark,
                  marginTop: 3,
                }}
              >
                구매 적기
              </div>
              <div
                style={{
                  fontSize: 10,
                  color: t.primaryDark,
                  marginTop: 2,
                  opacity: 0.85,
                }}
              >
                가격↓ + 트렌드↑
              </div>
            </div>
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

        {/* 영양 정보 */}
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
              영양 정보
            </div>
            <span style={{ fontSize: 11, color: t.textSoft }}>
              100g · 생식 기준
            </span>
          </div>
          <div style={{ fontSize: 11.5, color: t.textSoft, marginBottom: 14 }}>
            수분 94% · 저칼로리 뿌리채소
          </div>

          {/* 칼로리 헤드라인 */}
          <div
            style={{
              display: "flex",
              alignItems: "baseline",
              gap: 8,
              paddingBottom: 14,
              borderBottom: `1px solid ${t.borderSoft}`,
            }}
          >
            <div
              style={{
                fontSize: 32,
                fontWeight: 800,
                color: t.text,
                letterSpacing: -1,
                fontFeatureSettings: '"tnum"',
                lineHeight: 1,
              }}
            >
              18
            </div>
            <span style={{ fontSize: 13, color: t.textMid, fontWeight: 600 }}>
              kcal
            </span>
            <span style={{ marginLeft: "auto" }}>
              <Chip color={t.primary} bg={t.primaryBg}>
                저칼로리
              </Chip>
            </span>
          </div>

          {/* 주요 영양소 그리드 */}
          <div
            style={{
              display: "grid",
              gridTemplateColumns: "1fr 1fr",
              gap: 10,
              marginTop: 14,
            }}
          >
            {[
              { k: "탄수화물", v: "4.1g", sub: "당류 2.5g" },
              { k: "식이섬유", v: "1.6g", sub: "일일 권장 6%" },
              { k: "단백질", v: "0.6g", sub: "" },
              { k: "지방", v: "0.1g", sub: "" },
            ].map((n, i) => (
              <div
                key={i}
                style={{
                  background: t.bgSoft,
                  borderRadius: 12,
                  padding: "10px 12px",
                }}
              >
                <div
                  style={{
                    fontSize: 11,
                    color: t.textMid,
                    fontWeight: 600,
                  }}
                >
                  {n.k}
                </div>
                <div
                  style={{
                    fontSize: 16,
                    fontWeight: 800,
                    color: t.text,
                    marginTop: 2,
                    fontFeatureSettings: '"tnum"',
                  }}
                >
                  {n.v}
                </div>
                {n.sub && (
                  <div
                    style={{
                      fontSize: 10,
                      color: t.textSoft,
                      marginTop: 2,
                    }}
                  >
                    {n.sub}
                  </div>
                )}
              </div>
            ))}
          </div>

          {/* 비타민·미네랄 */}
          <div
            style={{
              marginTop: 14,
              paddingTop: 14,
              borderTop: `1px solid ${t.borderSoft}`,
            }}
          >
            <div
              style={{
                fontSize: 11.5,
                fontWeight: 700,
                color: t.textMid,
                marginBottom: 10,
              }}
            >
              풍부한 비타민·미네랄
            </div>
            {[
              { k: "비타민C", v: "22mg", pct: 0.73, label: "일일 73%" },
              { k: "칼륨", v: "233mg", pct: 0.07, label: "일일 7%" },
              { k: "엽산", v: "25µg", pct: 0.06, label: "일일 6%" },
            ].map((n, i) => (
              <div key={i} style={{ marginTop: i === 0 ? 0 : 10 }}>
                <div
                  style={{
                    display: "flex",
                    justifyContent: "space-between",
                    alignItems: "baseline",
                    fontSize: 12,
                    marginBottom: 4,
                  }}
                >
                  <span style={{ color: t.text, fontWeight: 700 }}>{n.k}</span>
                  <span
                    style={{
                      color: t.textSoft,
                      fontFeatureSettings: '"tnum"',
                    }}
                  >
                    <b style={{ color: t.text, fontWeight: 700 }}>{n.v}</b>
                    <span style={{ marginLeft: 6 }}>{n.label}</span>
                  </span>
                </div>
                <div
                  style={{
                    height: 6,
                    borderRadius: 3,
                    background: t.borderSoft,
                    overflow: "hidden",
                  }}
                >
                  <div
                    style={{
                      width: `${Math.min(100, n.pct * 100)}%`,
                      height: "100%",
                      borderRadius: 3,
                      background: n.pct >= 0.5 ? t.primary : t.primarySoft,
                    }}
                  />
                </div>
              </div>
            ))}
          </div>

          <div
            style={{
              marginTop: 14,
              paddingTop: 12,
              borderTop: `1px solid ${t.borderSoft}`,
              fontSize: 10.5,
              color: t.textSoft,
              lineHeight: 1.55,
            }}
          >
            출처 · 농촌진흥청 국가표준식품성분표 (DB 10.0)
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

      {/* Floating action bar — AI 셰프(1) : 온라인 가격 비교(4) */}
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
            flexDirection: "column",
            alignItems: "center",
            justifyContent: "center",
            gap: 0,
            padding: 0,
            boxShadow: "0 4px 14px rgba(20,40,30,0.06)",
          }}
        >
          <svg width="28" height="28" viewBox="0 0 26 26" fill="none">
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
          <span
            style={{
              fontSize: 9.5,
              fontWeight: 700,
              color: t.text,
              letterSpacing: -0.2,
            }}
          >
            질문하기
          </span>
        </button>
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
            <rect
              x="2"
              y="3"
              width="14"
              height="12"
              rx="2"
              stroke="#fff"
              strokeWidth="1.5"
            />
            <path d="M2 7h14" stroke="#fff" strokeWidth="1.5" />
          </svg>
          온라인 가격 비교하기 (3곳)
        </button>
      </div>
    </Phone>
  );
}

// ─────────────────────────────────────────────────────────────
// PRICE COMPARE — 쿠팡 / 마켓컬리 / 오아시스 …
// ─────────────────────────────────────────────────────────────
export function ScreenCompare({ t }) {
  const platforms = [
    {
      name: "쿠팡",
      sub: "로켓프레시 · 내일 도착",
      price: 1190,
      range: "1,150~1,290",
      orig: 1490,
      discount: 20,
      tag: "최저가",
      tagColor: t.primary,
      brand: "#FF5C39",
      logo: "C",
    },
    {
      name: "마켓컬리",
      sub: "샛별배송 · 오늘밤 도착",
      price: 1290,
      range: "1,250~1,380",
      orig: 1490,
      discount: 13,
      brand: "#5F0080",
      logo: "K",
    },
    {
      name: "오아시스",
      sub: "새벽배송 · 4시 출고",
      price: 1350,
      range: "1,300~1,420",
      orig: null,
      discount: null,
      brand: "#1B6F4E",
      logo: "O",
    },
    {
      name: "네이버 장보기",
      sub: "하나로마트 직배송",
      price: 1450,
      range: "1,400~1,520",
      orig: null,
      discount: null,
      brand: "#03C75A",
      logo: "N",
    },
    {
      name: "이마트몰",
      sub: "쓱배송 · 오늘 도착",
      price: 1490,
      range: "1,450~1,580",
      orig: 1690,
      discount: 12,
      brand: "#FFD400",
      logoColor: "#000",
      logo: "E",
    },
  ];
  return (
    <Phone t={t}>
      <AppHeader t={t} title="가격 비교 · 무 1단" leftBack />
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
                5개 플랫폼 · 실시간
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
            {["가격순", "배송 빠른순", "리뷰순", "🥇 최저가만"].map((f, i) => (
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
            전체 비교 · 5곳
          </div>
          <div
            style={{
              background: "#fff",
              borderRadius: 18,
              border: `1px solid ${t.borderSoft}`,
              overflow: "hidden",
            }}
          >
            {platforms.map((p, i) => (
              <div
                key={i}
                className="tap"
                style={{
                  padding: "14px 16px",
                  borderBottom:
                    i < platforms.length - 1
                      ? `1px solid ${t.borderSoft}`
                      : "none",
                  display: "flex",
                  alignItems: "center",
                  gap: 12,
                }}
              >
                <div
                  style={{
                    width: 40,
                    height: 40,
                    borderRadius: 10,
                    background: p.brand,
                    color: p.logoColor || "#fff",
                    fontWeight: 800,
                    fontSize: 18,
                    display: "grid",
                    placeItems: "center",
                    flexShrink: 0,
                  }}
                >
                  {p.logo}
                </div>
                <div style={{ flex: 1, minWidth: 0 }}>
                  <div
                    style={{ display: "flex", alignItems: "center", gap: 6 }}
                  >
                    <span
                      style={{ fontSize: 14, fontWeight: 700, color: t.text }}
                    >
                      {p.name}
                    </span>
                    {p.tag && (
                      <Chip color={t.primary} bg={t.primaryBg}>
                        {p.tag}
                      </Chip>
                    )}
                  </div>
                  <div
                    style={{ fontSize: 11.5, color: t.textSoft, marginTop: 3 }}
                  >
                    {p.sub}
                  </div>
                </div>
                <div style={{ textAlign: "right" }}>
                  <div
                    style={{
                      fontSize: 14,
                      fontWeight: 800,
                      color: t.text,
                      fontFeatureSettings: '"tnum"',
                      whiteSpace: "nowrap",
                    }}
                  >
                    ₩{p.range}
                  </div>
                </div>
                <svg
                  width="14"
                  height="14"
                  viewBox="0 0 14 14"
                  style={{ marginLeft: 4 }}
                >
                  <path
                    d="M3 11L11 3M11 3H5M11 3v6"
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
            환산했어요. 배송비 · 쿠폰은 각 플랫폼에서 확인하세요.
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

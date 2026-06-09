// 농가 연결 & 주문 — 장바구니 / 구매하기 / 농가 상품 등록
// 이커머스 → 농가 직거래 reframe. 공용 PRODUCERS 데이터 + ProducerCard 군 재사용.

import React from "react";
import { Phone, AppHeader, VegPlaceholder, Chip, priceExact } from "./phone";
import {
  PRODUCERS,
  producerOffer,
  styleStyle,
  producerNews,
} from "./producers-data";
import { CrownBadge } from "./producer-card";
import { vegImg } from "./mock-images";

// 농가 헤더 — 아바타(+왕관) + 지역·이름 + 한 줄 설명
function ProducerHeader({ producer, t, size = 44 }) {
  return (
    <div style={{ display: "flex", alignItems: "center", gap: 12 }}>
      <div
        style={{
          position: "relative",
          width: size,
          height: size,
          flexShrink: 0,
        }}
      >
        <div
          style={{
            width: size,
            height: size,
            borderRadius: size / 2,
            overflow: "hidden",
            backgroundImage: `url(${producer.photo})`,
            backgroundSize: "cover",
            backgroundPosition: "center",
          }}
        />
        {producer.honorary && (
          <CrownBadge size={Math.round(size * 0.34)} t={t} />
        )}
      </div>
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ fontSize: 14.5, fontWeight: 800, color: t.text }}>
          {producer.region} {producer.name}
        </div>
        <div
          style={{
            fontSize: 11.5,
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
    </div>
  );
}

// 수량 스테퍼 (프로토타입 — 시각 전용)
function Stepper({ value, t, small }) {
  const s = small ? 26 : 30;
  return (
    <div
      style={{
        display: "flex",
        alignItems: "center",
        border: `1px solid ${t.border}`,
        borderRadius: 10,
        overflow: "hidden",
      }}
    >
      <div
        className="tap"
        style={{
          width: s,
          height: s,
          display: "grid",
          placeItems: "center",
          color: t.textMid,
          fontSize: 16,
          fontWeight: 700,
        }}
      >
        −
      </div>
      <div
        style={{
          minWidth: 26,
          textAlign: "center",
          fontSize: 13.5,
          fontWeight: 800,
          color: t.text,
          fontFeatureSettings: '"tnum"',
        }}
      >
        {value}
      </div>
      <div
        className="tap"
        style={{
          width: s,
          height: s,
          display: "grid",
          placeItems: "center",
          color: t.primary,
          fontSize: 16,
          fontWeight: 700,
        }}
      >
        +
      </div>
    </div>
  );
}

// 하단 sticky CTA 컨테이너 (ScreenDetail 패턴)
function StickyBar({ children, t }) {
  return (
    <div
      style={{
        position: "absolute",
        left: 0,
        right: 0,
        bottom: 0,
        padding: "16px 16px 27px",
        background: "#fff",
        borderTop: `1px solid ${t.borderSoft}`,
        display: "flex",
        gap: 8,
        zIndex: 90,
      }}
    >
      {children}
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 23 — 장바구니
// ─────────────────────────────────────────────────────────────
export function ScreenCart({ t }) {
  const groups = [
    {
      p: PRODUCERS[2], // 해남 김상도
      shipping: 3000,
      items: [
        { name: "무", qty: 2, unit: "개", price: 2090 },
        { name: "배추", qty: 1, unit: "포기", price: 5560 },
      ],
    },
    {
      p: PRODUCERS[4], // 평창 이수향
      shipping: 3500,
      items: [{ name: "시금치", qty: 3, unit: "단", price: 4140 }],
    },
  ];
  const subtotal = groups.reduce(
    (s, g) => s + g.items.reduce((a, it) => a + it.price * it.qty, 0),
    0,
  );
  const ship = groups.reduce((s, g) => s + g.shipping, 0);
  const total = subtotal + ship;

  return (
    <Phone t={t}>
      <AppHeader
        t={t}
        title="장바구니"
        leftBack
        rightIcons={
          <div
            className="tap"
            style={{
              fontSize: 12.5,
              fontWeight: 700,
              color: t.textSoft,
              padding: "6px 8px",
            }}
          >
            전체삭제
          </div>
        }
      />
      <div
        className="phone-scroll"
        style={{ flex: 1, overflow: "auto", background: t.bgSoft }}
      >
        {groups.map((g, gi) => {
          const sub = g.items.reduce((a, it) => a + it.price * it.qty, 0);
          return (
            <div key={gi} style={{ padding: "12px 16px 0" }}>
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
                    padding: "14px 16px",
                    borderBottom: `1px solid ${t.borderSoft}`,
                  }}
                >
                  <ProducerHeader producer={g.p} t={t} size={40} />
                </div>
                {g.items.map((it, i) => (
                  <div
                    key={i}
                    style={{
                      display: "flex",
                      alignItems: "center",
                      gap: 12,
                      padding: "12px 16px",
                      borderBottom:
                        i < g.items.length - 1
                          ? `1px solid ${t.borderSoft}`
                          : "none",
                    }}
                  >
                    <VegPlaceholder name={it.name} size={48} t={t} />
                    <div style={{ flex: 1, minWidth: 0 }}>
                      <div
                        style={{ fontSize: 14, fontWeight: 700, color: t.text }}
                      >
                        {it.name}
                      </div>
                      <div
                        style={{
                          fontSize: 11.5,
                          color: t.textSoft,
                          marginTop: 2,
                        }}
                      >
                        {it.unit}당 · ₩{priceExact(it.price)}
                      </div>
                      <div style={{ marginTop: 8 }}>
                        <Stepper value={it.qty} t={t} small />
                      </div>
                    </div>
                    <div
                      style={{
                        fontSize: 14,
                        fontWeight: 800,
                        color: t.text,
                        fontFeatureSettings: '"tnum"',
                        whiteSpace: "nowrap",
                      }}
                    >
                      ₩{priceExact(it.price * it.qty)}
                    </div>
                  </div>
                ))}
                <div
                  style={{
                    padding: "12px 16px",
                    background: t.bgSoft,
                    display: "flex",
                    justifyContent: "space-between",
                    fontSize: 12.5,
                    color: t.textMid,
                  }}
                >
                  <span>
                    상품 {g.items.length}개 · 배송비 ₩{priceExact(g.shipping)}
                  </span>
                  <span
                    style={{
                      fontWeight: 800,
                      color: t.text,
                      fontFeatureSettings: '"tnum"',
                    }}
                  >
                    ₩{priceExact(sub)}
                  </span>
                </div>
              </div>
            </div>
          );
        })}

        {/* totals */}
        <div style={{ padding: "14px 16px 0" }}>
          <div
            style={{
              background: "#fff",
              borderRadius: 18,
              border: `1px solid ${t.borderSoft}`,
              padding: 16,
            }}
          >
            {[
              ["상품 금액", subtotal],
              ["배송비", ship],
            ].map(([l, v], i) => (
              <div
                key={i}
                style={{
                  display: "flex",
                  justifyContent: "space-between",
                  fontSize: 13,
                  color: t.textMid,
                  marginBottom: 8,
                }}
              >
                <span>{l}</span>
                <span style={{ fontFeatureSettings: '"tnum"' }}>
                  ₩{priceExact(v)}
                </span>
              </div>
            ))}
            <div
              style={{
                display: "flex",
                justifyContent: "space-between",
                paddingTop: 10,
                borderTop: `1px solid ${t.borderSoft}`,
              }}
            >
              <span style={{ fontSize: 14, fontWeight: 800, color: t.text }}>
                결제 예정 금액
              </span>
              <span
                style={{
                  fontSize: 18,
                  fontWeight: 800,
                  color: t.primary,
                  fontFeatureSettings: '"tnum"',
                }}
              >
                ₩{priceExact(total)}
              </span>
            </div>
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
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            gap: 8,
          }}
        >
          ₩{priceExact(total)} · 주문하기
        </button>
      </StickyBar>
    </Phone>
  );
}

// ─────────────────────────────────────────────────────────────
// 24 — 구매하기 (농가 직거래)
// ─────────────────────────────────────────────────────────────
export function ScreenPurchase({ t }) {
  const p = PRODUCERS[2]; // 해남 김상도
  const o = producerOffer(p, "무");
  const options = [
    { label: "보통 (흙무 1개 · 1.2kg)", price: 0, active: true },
    { label: "대 (1개 · 1.8kg)", price: 1200 },
    { label: "세척무 (1개 · 1.0kg)", price: 800 },
  ];
  return (
    <Phone t={t}>
      <AppHeader t={t} title="구매하기" leftBack />
      <div
        className="phone-scroll"
        style={{ flex: 1, overflow: "auto", background: t.bgSoft }}
      >
        {/* 농가 헤더 */}
        <div style={{ padding: "12px 16px 0" }}>
          <div
            className="tap"
            style={{
              background: "#fff",
              borderRadius: 18,
              border: `1px solid ${t.borderSoft}`,
              padding: 16,
              display: "flex",
              alignItems: "center",
              gap: 8,
            }}
          >
            <div style={{ flex: 1 }}>
              <ProducerHeader producer={p} t={t} size={48} />
            </div>
            <div
              style={{
                display: "flex",
                alignItems: "center",
                gap: 3,
                fontSize: 12,
                fontWeight: 700,
                color: t.warning,
              }}
            >
              ★ {p.rating}
              <span style={{ color: t.textSoft, fontWeight: 600 }}>
                ({p.reviewCount.toLocaleString()})
              </span>
            </div>
          </div>
        </div>

        {/* 상품 hero + 가격 */}
        <div style={{ padding: "12px 16px 0" }}>
          <div
            style={{
              background: "#fff",
              borderRadius: 18,
              border: `1px solid ${t.borderSoft}`,
              padding: 16,
              display: "flex",
              gap: 14,
            }}
          >
            <VegPlaceholder name="무" size={84} t={t} />
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 18, fontWeight: 800, color: t.text }}>
                무
              </div>
              <div
                style={{
                  display: "flex",
                  gap: 6,
                  flexWrap: "wrap",
                  marginTop: 6,
                }}
              >
                <Chip color={t.primary} bg={t.primaryBg}>
                  🌱 {o.fresh}
                </Chip>
                <Chip color={t.primaryDark} bg={t.primaryBg}>
                  📍 {p.region}
                </Chip>
              </div>
              <div
                style={{
                  marginTop: 10,
                  fontSize: 20,
                  fontWeight: 800,
                  color: t.text,
                  fontFeatureSettings: '"tnum"',
                }}
              >
                ₩{priceExact(o.price)}
                <span
                  style={{ fontSize: 13, color: t.textMid, fontWeight: 600 }}
                >
                  {" "}
                  /{o.unit}
                </span>
              </div>
            </div>
          </div>
        </div>

        {/* 옵션 + 수량 */}
        <div style={{ padding: "12px 16px 0" }}>
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
                fontSize: 13,
                fontWeight: 800,
                color: t.text,
                marginBottom: 10,
              }}
            >
              옵션 선택
            </div>
            {options.map((opt, i) => (
              <div
                key={i}
                className="tap"
                style={{
                  display: "flex",
                  alignItems: "center",
                  gap: 10,
                  padding: "11px 12px",
                  borderRadius: 12,
                  marginBottom: 8,
                  border: `1px solid ${opt.active ? t.primary : t.borderSoft}`,
                  background: opt.active ? t.primaryBg : "#fff",
                }}
              >
                <div
                  style={{
                    width: 18,
                    height: 18,
                    borderRadius: 9,
                    border: `2px solid ${opt.active ? t.primary : t.border}`,
                    background: opt.active ? t.primary : "#fff",
                    display: "grid",
                    placeItems: "center",
                  }}
                >
                  {opt.active && (
                    <div
                      style={{
                        width: 7,
                        height: 7,
                        borderRadius: 4,
                        background: "#fff",
                      }}
                    />
                  )}
                </div>
                <span
                  style={{
                    flex: 1,
                    fontSize: 13,
                    fontWeight: 700,
                    color: t.text,
                  }}
                >
                  {opt.label}
                </span>
                <span
                  style={{
                    fontSize: 12.5,
                    fontWeight: 700,
                    color: t.textMid,
                    fontFeatureSettings: '"tnum"',
                  }}
                >
                  {opt.price ? `+₩${priceExact(opt.price)}` : "기본"}
                </span>
              </div>
            ))}
            <div
              style={{
                display: "flex",
                alignItems: "center",
                justifyContent: "space-between",
                marginTop: 4,
              }}
            >
              <span style={{ fontSize: 13, fontWeight: 700, color: t.text }}>
                수량
              </span>
              <Stepper value={1} t={t} />
            </div>
          </div>
        </div>

        {/* 배송 info */}
        <div style={{ padding: "12px 16px 0" }}>
          <div
            style={{
              background: "#fff",
              borderRadius: 18,
              border: `1px solid ${t.borderSoft}`,
              padding: "8px 16px",
            }}
          >
            {[
              { ic: "🚚", k: "배송", v: "산지직송 · 수확 후 1~2일 내 출고" },
              { ic: "📦", k: "배송비", v: "₩3,000 · 3만원 이상 무료" },
              { ic: "🧊", k: "신선도", v: "아이스박스 포장 · 콜드체인" },
            ].map((r, i, arr) => (
              <div
                key={i}
                style={{
                  display: "flex",
                  gap: 12,
                  alignItems: "center",
                  padding: "12px 0",
                  borderBottom:
                    i < arr.length - 1 ? `1px solid ${t.borderSoft}` : "none",
                }}
              >
                <span style={{ fontSize: 16 }}>{r.ic}</span>
                <span
                  style={{
                    width: 52,
                    fontSize: 12.5,
                    color: t.textSoft,
                    fontWeight: 600,
                  }}
                >
                  {r.k}
                </span>
                <span style={{ flex: 1, fontSize: 12.5, color: t.textMid }}>
                  {r.v}
                </span>
              </div>
            ))}
          </div>
        </div>
        <div style={{ height: 110 }} />
      </div>

      <StickyBar t={t}>
        <button
          className="tap"
          style={{
            flex: 1,
            height: 52,
            borderRadius: 14,
            border: `1px solid ${t.border}`,
            background: "#fff",
            color: t.text,
            fontSize: 14,
            fontWeight: 800,
          }}
        >
          장바구니 담기
        </button>
        <button
          className="tap"
          style={{
            flex: 1.6,
            height: 52,
            borderRadius: 14,
            border: "none",
            background: t.primary,
            color: "#fff",
            fontSize: 15,
            fontWeight: 800,
          }}
        >
          주문하기
        </button>
      </StickyBar>
    </Phone>
  );
}

// ─────────────────────────────────────────────────────────────
// 25 — 농가 상품 등록
// ─────────────────────────────────────────────────────────────
const UPLOAD_IMGS = [
  "/uploads/pasted-1779886008264-0.png",
  "/uploads/pasted-1779886410483-0.png",
  "/uploads/pasted-1779886560000-0.png",
];

export function ScreenFarmUpload({ t }) {
  const cats = ["잎채소", "뿌리채소", "과일", "곡류", "버섯", "기타"];
  const Field = ({ label, children, hint }) => (
    <div style={{ marginBottom: 16 }}>
      <div
        style={{
          fontSize: 12.5,
          fontWeight: 800,
          color: t.text,
          marginBottom: 8,
        }}
      >
        {label}
      </div>
      {children}
      {hint && (
        <div style={{ fontSize: 11, color: t.textSoft, marginTop: 6 }}>
          {hint}
        </div>
      )}
    </div>
  );
  const inputBox = {
    width: "100%",
    boxSizing: "border-box",
    border: `1px solid ${t.border}`,
    borderRadius: 12,
    padding: "13px 14px",
    fontSize: 13.5,
    color: t.text,
    background: t.bgSoft,
    fontFamily: "inherit",
  };
  return (
    <Phone t={t}>
      <AppHeader
        t={t}
        title="상품 등록"
        leftBack
        rightIcons={
          <div
            className="tap"
            style={{
              fontSize: 12.5,
              fontWeight: 700,
              color: t.textSoft,
              padding: "6px 8px",
            }}
          >
            임시저장
          </div>
        }
      />
      <div
        className="phone-scroll"
        style={{ flex: 1, overflow: "auto", background: t.bg }}
      >
        <div style={{ padding: "16px 20px 0" }}>
          {/* 사진 */}
          <Field label="상품 사진" hint="최대 10장 · 첫 사진이 대표 이미지예요">
            <div
              style={{ display: "flex", gap: 8, overflowX: "auto" }}
              className="phone-scroll"
            >
              <div
                className="tap"
                style={{
                  width: 84,
                  height: 84,
                  flexShrink: 0,
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
                <span style={{ fontSize: 22 }}>＋</span>
                <span style={{ fontSize: 10.5, fontWeight: 700 }}>3/10</span>
              </div>
              {UPLOAD_IMGS.map((src, i) => (
                <div
                  key={i}
                  style={{
                    width: 84,
                    height: 84,
                    flexShrink: 0,
                    borderRadius: 14,
                    overflow: "hidden",
                    position: "relative",
                    backgroundImage: `url(${src})`,
                    backgroundSize: "cover",
                    backgroundPosition: "center",
                    border:
                      i === 0
                        ? `2px solid ${t.primary}`
                        : `1px solid ${t.borderSoft}`,
                  }}
                >
                  {i === 0 && (
                    <div
                      style={{
                        position: "absolute",
                        bottom: 0,
                        left: 0,
                        right: 0,
                        fontSize: 9.5,
                        fontWeight: 800,
                        color: "#fff",
                        background: t.primary,
                        textAlign: "center",
                        padding: "2px 0",
                      }}
                    >
                      대표
                    </div>
                  )}
                </div>
              ))}
            </div>
          </Field>

          <Field label="상품명">
            <input
              style={inputBox}
              placeholder="예: 해남 황토밭 가을무"
              defaultValue=""
            />
          </Field>

          <Field label="식재료 카테고리">
            <div style={{ display: "flex", gap: 6, flexWrap: "wrap" }}>
              {cats.map((c, i) => (
                <div
                  key={i}
                  className="tap"
                  style={{
                    padding: "8px 14px",
                    borderRadius: 999,
                    fontSize: 12.5,
                    fontWeight: 700,
                    background: i === 1 ? t.primary : "#fff",
                    color: i === 1 ? "#fff" : t.textMid,
                    border: i === 1 ? "none" : `1px solid ${t.border}`,
                  }}
                >
                  {c}
                </div>
              ))}
            </div>
          </Field>

          <Field label="판매 가격 · 단위">
            <div style={{ display: "flex", gap: 8 }}>
              <div
                style={{
                  flex: 1.4,
                  ...inputBox,
                  display: "flex",
                  alignItems: "center",
                  gap: 4,
                }}
              >
                <span style={{ color: t.textSoft }}>₩</span>
                <input
                  style={{
                    border: "none",
                    background: "transparent",
                    outline: "none",
                    flex: 1,
                    fontSize: 13.5,
                    color: t.text,
                  }}
                  placeholder="2,400"
                />
              </div>
              <div
                style={{
                  flex: 1,
                  ...inputBox,
                  display: "flex",
                  alignItems: "center",
                  justifyContent: "space-between",
                }}
              >
                <span style={{ color: t.text }}>개</span>
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
            </div>
          </Field>

          <Field label="재고 수량" hint="실시간 판매 가능 수량">
            <div
              style={{
                ...inputBox,
                display: "flex",
                alignItems: "center",
                justifyContent: "space-between",
              }}
            >
              <input
                style={{
                  border: "none",
                  background: "transparent",
                  outline: "none",
                  flex: 1,
                  fontSize: 13.5,
                  color: t.text,
                }}
                placeholder="120"
              />
              <span style={{ color: t.textSoft, fontSize: 12.5 }}>개</span>
            </div>
          </Field>

          <Field label="수확 · 배송 정보">
            <div
              style={{
                background: t.bgSoft,
                borderRadius: 12,
                border: `1px solid ${t.borderSoft}`,
                overflow: "hidden",
              }}
            >
              {[
                { k: "수확일", v: "오늘 새벽 수확" },
                { k: "출고", v: "주문 후 1~2일 내" },
                { k: "포장", v: "아이스박스 · 콜드체인" },
              ].map((r, i, arr) => (
                <div
                  key={i}
                  className="tap"
                  style={{
                    display: "flex",
                    justifyContent: "space-between",
                    padding: "13px 14px",
                    fontSize: 13,
                    borderBottom:
                      i < arr.length - 1 ? `1px solid ${t.borderSoft}` : "none",
                  }}
                >
                  <span style={{ color: t.textMid, fontWeight: 600 }}>
                    {r.k}
                  </span>
                  <span style={{ color: t.text, fontWeight: 700 }}>
                    {r.v} ›
                  </span>
                </div>
              ))}
            </div>
          </Field>

          <Field label="신선도 · 원산지 소개" hint="0 / 500자">
            <textarea
              style={{
                ...inputBox,
                minHeight: 96,
                resize: "none",
                lineHeight: 1.5,
              }}
              placeholder="해발 200m 황토밭에서 무농약으로 키운 가을무입니다. 단단하고 단맛이 강해 생채·국·깍두기에 좋아요."
            />
          </Field>

          <div style={{ height: 110 }} />
        </div>
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

// ─────────────────────────────────────────────────────────────
// 15a — 농가 상세 (농가 정보 · 판매 재료 · 스토어 소식)
// ─────────────────────────────────────────────────────────────
export function ScreenProducerDetail({ t, producer = PRODUCERS[0] }) {
  const ss = styleStyle(producer.style, t);
  const news = producerNews(producer);
  return (
    <Phone t={t}>
      <div
        className="phone-scroll"
        style={{ flex: 1, overflow: "auto", background: t.bgSoft }}
      >
        {/* ── 농가 정보 (hero) ── */}
        <div style={{ position: "relative", height: 248 }}>
          <div
            style={{
              position: "absolute",
              inset: 0,
              backgroundImage: `url(${producer.photo})`,
              backgroundSize: "cover",
              backgroundPosition: "center",
            }}
          />
          <div
            style={{
              position: "absolute",
              inset: 0,
              background:
                "linear-gradient(180deg, rgba(15,26,20,0.45) 0%, rgba(15,26,20,0.1) 38%, rgba(15,26,20,0.82) 100%)",
            }}
          />
          {/* top bar */}
          <div
            style={{
              position: "relative",
              paddingTop: 50,
              padding: "50px 16px 0",
              display: "flex",
              alignItems: "center",
              justifyContent: "space-between",
            }}
          >
            <div
              className="tap"
              style={{
                width: 36,
                height: 36,
                borderRadius: 18,
                background: "rgba(255,255,255,0.18)",
                backdropFilter: "blur(10px)",
                border: "1px solid rgba(255,255,255,0.25)",
                display: "grid",
                placeItems: "center",
              }}
            >
              <svg width="18" height="18" viewBox="0 0 20 20" fill="none">
                <path
                  d="M13 4L7 10l6 6"
                  stroke="#fff"
                  strokeWidth="2"
                  fill="none"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                />
              </svg>
            </div>
            <div style={{ display: "flex", gap: 8 }}>
              {[
                <path
                  key="s"
                  d="M13 6.5a2 2 0 10-1.9-2.6L7.8 5.8a2 2 0 100 2.4l3.3 1.9A2 2 0 1013 8.5l-3.3-1.9a2 2 0 000-.2L13 6.5z"
                  stroke="#fff"
                  strokeWidth="1.4"
                  fill="none"
                />,
                <path
                  key="h"
                  d="M9 15s-5-3-5-6.3C4 6.6 5.5 5.5 7 5.5c.9 0 1.6.4 2 1 .4-.6 1.1-1 2-1 1.5 0 3 1.1 3 3.2C14 12 9 15 9 15z"
                  stroke="#fff"
                  strokeWidth="1.4"
                  fill="none"
                  strokeLinejoin="round"
                />,
              ].map((p, i) => (
                <div
                  key={i}
                  className="tap"
                  style={{
                    width: 36,
                    height: 36,
                    borderRadius: 18,
                    background: "rgba(255,255,255,0.18)",
                    backdropFilter: "blur(10px)",
                    border: "1px solid rgba(255,255,255,0.25)",
                    display: "grid",
                    placeItems: "center",
                  }}
                >
                  <svg width="18" height="18" viewBox="0 0 18 18" fill="none">
                    {p}
                  </svg>
                </div>
              ))}
            </div>
          </div>
          {/* name block */}
          <div
            style={{
              position: "absolute",
              left: 20,
              right: 20,
              bottom: 16,
              color: "#fff",
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
              {producer.honorary && (
                <span
                  style={{
                    display: "inline-flex",
                    alignItems: "center",
                    gap: 4,
                    fontSize: 11,
                    fontWeight: 800,
                    color: "#fff",
                    background: t.primary,
                    padding: "3px 9px",
                    borderRadius: 999,
                  }}
                >
                  👑 명예생산자
                </span>
              )}
              <span
                style={{
                  fontSize: 11,
                  fontWeight: 800,
                  color: ss.color,
                  background: "#fff",
                  padding: "3px 9px",
                  borderRadius: 999,
                }}
              >
                {ss.label}
              </span>
            </div>
            <div style={{ fontSize: 22, fontWeight: 800, letterSpacing: -0.5 }}>
              {producer.region} {producer.name}
            </div>
            <div
              style={{
                fontSize: 12.5,
                marginTop: 4,
                color: "rgba(255,255,255,0.9)",
              }}
            >
              {producer.tagline}
            </div>
          </div>
        </div>

        {/* 통계 + 팔로우 카드 */}
        <div style={{ padding: "12px 16px 0" }}>
          <div
            style={{
              background: "#fff",
              borderRadius: 18,
              border: `1px solid ${t.borderSoft}`,
              padding: 16,
            }}
          >
            <div style={{ display: "flex" }}>
              {[
                { k: "평점", v: `★ ${producer.rating}` },
                { k: "리뷰", v: producer.reviewCount.toLocaleString() },
                { k: "팔로워", v: "1.2만" },
              ].map((s, i) => (
                <div
                  key={i}
                  style={{
                    flex: 1,
                    textAlign: "center",
                    borderRight: i < 2 ? `1px solid ${t.borderSoft}` : "none",
                  }}
                >
                  <div
                    style={{
                      fontSize: 16,
                      fontWeight: 800,
                      color: i === 0 ? t.warning : t.text,
                      fontFeatureSettings: '"tnum"',
                    }}
                  >
                    {s.v}
                  </div>
                  <div
                    style={{ fontSize: 11, color: t.textSoft, marginTop: 3 }}
                  >
                    {s.k}
                  </div>
                </div>
              ))}
            </div>
            <div
              style={{
                display: "flex",
                gap: 6,
                flexWrap: "wrap",
                marginTop: 14,
                paddingTop: 14,
                borderTop: `1px solid ${t.borderSoft}`,
              }}
            >
              {producer.badges.map((b, i) => (
                <Chip key={i} color={t.primaryDark} bg={t.primaryBg}>
                  {b}
                </Chip>
              ))}
            </div>
            <div style={{ display: "flex", gap: 8, marginTop: 14 }}>
              <button
                className="tap"
                style={{
                  flex: 1.6,
                  height: 44,
                  borderRadius: 12,
                  border: "none",
                  background: t.primary,
                  color: "#fff",
                  fontSize: 13.5,
                  fontWeight: 800,
                }}
              >
                🌱 팔로우
              </button>
              <button
                className="tap"
                style={{
                  flex: 1,
                  height: 44,
                  borderRadius: 12,
                  border: `1px solid ${t.border}`,
                  background: "#fff",
                  color: t.text,
                  fontSize: 13.5,
                  fontWeight: 700,
                }}
              >
                문의
              </button>
            </div>
          </div>
        </div>

        {/* ── 판매 재료 ── */}
        <div style={{ padding: "20px 16px 0" }}>
          <div
            style={{
              fontSize: 16,
              fontWeight: 800,
              color: t.text,
              letterSpacing: -0.4,
              marginBottom: 10,
              padding: "0 2px",
            }}
          >
            판매 중인 재료{" "}
            <span style={{ color: t.primary }}>
              {producer.specialties.length}
            </span>
          </div>
          <div
            style={{
              background: "#fff",
              borderRadius: 18,
              border: `1px solid ${t.borderSoft}`,
              overflow: "hidden",
            }}
          >
            {producer.specialties.map((name, i, arr) => {
              const o = producerOffer(producer, name);
              return (
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
                  <div style={{ flex: 1, minWidth: 0 }}>
                    <div
                      style={{ fontSize: 14, fontWeight: 700, color: t.text }}
                    >
                      {name}
                    </div>
                    <div style={{ marginTop: 4 }}>
                      <Chip color={t.primary} bg={t.primaryBg}>
                        🌱 {o.fresh}
                      </Chip>
                    </div>
                  </div>
                  <div style={{ textAlign: "right", flexShrink: 0 }}>
                    <div
                      style={{
                        fontSize: 15,
                        fontWeight: 800,
                        color: t.text,
                        fontFeatureSettings: '"tnum"',
                        whiteSpace: "nowrap",
                      }}
                    >
                      ₩{priceExact(o.price)}
                    </div>
                    <div
                      style={{ fontSize: 11, color: t.textSoft, marginTop: 1 }}
                    >
                      /{o.unit}
                    </div>
                  </div>
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
                </div>
              );
            })}
          </div>
        </div>

        {/* ── 스토어 소식 (NEWS 타임라인) ── */}
        <div style={{ padding: "24px 16px 0" }}>
          <div
            style={{
              fontSize: 16,
              fontWeight: 800,
              color: t.text,
              letterSpacing: -0.4,
              marginBottom: 14,
              padding: "0 2px",
            }}
          >
            스토어 소식
          </div>
          {news.map((n, i) => {
            const src =
              n.img === "photo"
                ? producer.photo
                : vegImg(n.img) || producer.photo;
            const last = i === news.length - 1;
            return (
              <div key={i} style={{ display: "flex", gap: 12 }}>
                {/* timeline rail */}
                <div
                  style={{
                    display: "flex",
                    flexDirection: "column",
                    alignItems: "center",
                    width: 26,
                    flexShrink: 0,
                  }}
                >
                  <div
                    style={{
                      width: 26,
                      height: 26,
                      borderRadius: 13,
                      background: t.bgSoft,
                      border: `1px solid ${t.border}`,
                      display: "grid",
                      placeItems: "center",
                      fontSize: 12,
                    }}
                  >
                    📣
                  </div>
                  {!last && (
                    <div
                      style={{
                        flex: 1,
                        width: 2,
                        background: t.borderSoft,
                        marginTop: 4,
                      }}
                    />
                  )}
                </div>
                {/* content */}
                <div
                  style={{ flex: 1, minWidth: 0, paddingBottom: last ? 0 : 22 }}
                >
                  <div
                    style={{
                      display: "flex",
                      alignItems: "center",
                      gap: 8,
                      fontSize: 10.5,
                      color: t.textSoft,
                    }}
                  >
                    <span
                      style={{
                        fontWeight: 800,
                        letterSpacing: 0.4,
                        color: t.textMid,
                      }}
                    >
                      NEWS
                    </span>
                    <span>{n.date}</span>
                  </div>
                  <div
                    style={{
                      display: "flex",
                      alignItems: "center",
                      gap: 6,
                      marginTop: 5,
                    }}
                  >
                    <span
                      style={{
                        fontSize: 14.5,
                        fontWeight: 800,
                        color: t.text,
                        letterSpacing: -0.3,
                        lineHeight: 1.3,
                      }}
                    >
                      {n.title}
                    </span>
                    <svg
                      width="14"
                      height="14"
                      viewBox="0 0 14 14"
                      style={{ flexShrink: 0 }}
                    >
                      <path
                        d="M3 7h8M8 4l3 3-3 3"
                        stroke={t.textSoft}
                        strokeWidth="1.4"
                        fill="none"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                      />
                    </svg>
                  </div>
                  <div
                    style={{
                      marginTop: 10,
                      borderRadius: 14,
                      overflow: "hidden",
                      aspectRatio: "16/9",
                      backgroundImage: `url(${src})`,
                      backgroundSize: "cover",
                      backgroundPosition: "center",
                      border: `1px solid ${t.borderSoft}`,
                    }}
                  />
                  <div
                    style={{
                      marginTop: 10,
                      fontSize: 12.5,
                      color: t.textMid,
                      lineHeight: 1.6,
                      display: "-webkit-box",
                      WebkitLineClamp: 3,
                      WebkitBoxOrient: "vertical",
                      overflow: "hidden",
                    }}
                  >
                    {n.body}
                  </div>
                </div>
              </div>
            );
          })}
          <div
            className="tap"
            style={{
              marginTop: 4,
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
            }}
          >
            소식 더보기
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

        <div style={{ height: 110 }} />
      </div>
    </Phone>
  );
}

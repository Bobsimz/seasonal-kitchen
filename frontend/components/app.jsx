// app.jsx — main canvas assembly + tweaks panel

import React from 'react';
import { BRAND, GREEN_PRESETS, ACCENT_PRESETS, NEUTRAL_PRESETS, makeTokens } from './design-tokens';
import { PHONE_W, PHONE_H } from './phone';
import { DesignCanvas, DCSection, DCArtboard } from './design-canvas';
import { TweaksPanel, TweakSection, TweakRadio, useTweaks } from './tweaks-panel';
import { ScreenSplash, ScreenOnboard, ScreenOnboard2, ScreenSignup, ScreenSignupSurvey } from './screens-onboarding';
import { OnboardingFlow, HomeFlow, CatalogFlow, ReelsFlow, CrossSectionFlow } from './flow-arrows';
import { ScreenHomeB, ScreenSeasonalCuration, ScreenHomeSearch, ScreenHomeSearchResult } from './screens-home';
import { ScreenList, ScreenRecipeList, ScreenListSearchResult, ScreenRecipeListSearchResult, ScreenDetail, ScreenCompare } from './screens-detail';
import { ScreenProductList, ScreenProductListSeller, ScreenProductListSearchResult } from './screens-product';
import { ScreenReels, ScreenRecipeDetail, ScreenRecipeSteps } from './screens-reels';
import { ScreenMyPage, ScreenOrders, ScreenWishlist, ScreenReviews, ScreenWriteReview, ScreenSellerRegister, ScreenSellerDashboard } from './screens-misc';
import { ScreenCart, ScreenPurchase, ScreenFarmUpload, ScreenProducerDetail, ScreenOrderComplete } from './screens-farm';

const TWEAK_DEFAULTS = /*EDITMODE-BEGIN*/{
  "green": "spring",
  "accent": "coral",
  "neutral": "pure"
}/*EDITMODE-END*/;

export function App() {
  const [tk, setTweak] = useTweaks(TWEAK_DEFAULTS);
  const t = makeTokens(tk.green, tk.accent, tk.neutral);

  const W = PHONE_W;
  const H = PHONE_H;

  return (
    <React.Fragment>
      <DesignCanvas
        title="제철식탁 — 모바일 앱 프로토타입"
        subtitle="제철 + 농가 연결 · iOS 기준 · Fresh Green"
      >
        <DCSection id="entry" title="01 · 진입 & 온보딩" subtitle="앱 첫 실행 → 3장 온보딩 → 가입 흐름">
          <DCArtboard id="splash"    label="01 Splash"              width={W} height={H}><ScreenSplash    t={t}/></DCArtboard>
          <DCArtboard id="onboard"   label="02 Onboarding · 농가"   width={W} height={H}><ScreenOnboard   t={t}/></DCArtboard>
          <DCArtboard id="onboard-2" label="03 Onboarding · 트렌드" width={W} height={H}><ScreenOnboard2  t={t}/></DCArtboard>
          <DCArtboard id="signup"    label="04 Sign Up"             width={W} height={H}><ScreenSignup    t={t}/></DCArtboard>
          <DCArtboard id="signup-survey" label="05 Sign Up · 설문"   width={W} height={H}><ScreenSignupSurvey t={t}/></DCArtboard>
          <OnboardingFlow />
        </DCSection>

        <DCSection id="home" title="02 · 홈" subtitle="메인 + 검색">
          <DCArtboard id="home-b"   label="06 Home · 메인"      width={W} height={H}><ScreenHomeB       t={t}/></DCArtboard>
          <DCArtboard id="home-curation" label="07 제철 큐레이션 (배너 진입)" width={W} height={H}><ScreenSeasonalCuration t={t}/></DCArtboard>
          <DCArtboard id="home-search" label="08 Home · 검색 전"   width={W} height={H}><ScreenHomeSearch       t={t}/></DCArtboard>
          <DCArtboard id="home-search-result" label="09 Home · 검색 결과" width={W} height={H}><ScreenHomeSearchResult t={t}/></DCArtboard>
          <HomeFlow />
        </DCSection>

        <DCSection id="catalog" title="03 · 정보 (식재료 & 레시피 & 농가)" subtitle="정보 탭은 식재료 ⇄ 레시피 ⇄ 농가 토글로 탐색 · 상세 · 농가 비교 · 직거래 연동">

          <DCArtboard id="list-rec"     label="10 리스트 · 레시피"            width={W} height={H}><ScreenRecipeList             t={t}/></DCArtboard>
          <DCArtboard id="list-rec-res" label="11 리스트 · 레시피 검색 (봄동)" width={W} height={H}><ScreenRecipeListSearchResult t={t}/></DCArtboard>
          <DCArtboard id="list-ing"     label="12 리스트 · 식재료"            width={W} height={H}><ScreenList                   t={t}/></DCArtboard>
          <DCArtboard id="list-ing-res" label="13 리스트 · 식재료 검색 (봄동)" width={W} height={H}><ScreenListSearchResult       t={t}/></DCArtboard>
          <DCArtboard id="detail"       label="14 식재료 상세 (무)"           width={W} height={H}><ScreenDetail                 t={t}/></DCArtboard>
          <DCArtboard id="detail-mob"   label="14′ 식재료 상세 · 모바일"      width={W} height={H}><div className="dc-phone-clip"><ScreenDetail t={t}/></div></DCArtboard>
          <DCArtboard id="compare"      label="15 농가 비교"                  width={W} height={H}><ScreenCompare                t={t}/></DCArtboard>
          <DCArtboard id="producer-detail" label="15a 농가 상세 (경북영천 권민성)" width={W} height={H}><ScreenProducerDetail t={t}/></DCArtboard>
          <CatalogFlow />
        </DCSection>

        <DCSection id="product" title="04 · 상품" subtitle="농가 판매 상품 리스트(구매자/판매자 뷰) · 상품 상세 · 우하단 + 버튼 → 판매 등록">
          <DCArtboard id="product-list"  label="16 상품 리스트"            width={W} height={H}><ScreenProductList       t={t}/></DCArtboard>
          <DCArtboard id="product-list-seller" label="16a 상품 리스트 · 판매자(+ 버튼)" width={W} height={H}><ScreenProductListSeller t={t}/></DCArtboard>
          <DCArtboard id="product-list-search" label="16b 상품 검색 결과 (봄동)" width={W} height={H}><ScreenProductListSearchResult t={t}/></DCArtboard>
          <DCArtboard id="product-detail" label="17 상품 상세"             width={W} height={H}><ScreenPurchase          t={t}/></DCArtboard>
        </DCSection>

        <DCSection id="reels" title="05 · 레시피 릴스 & 상세" subtitle="↕ 새 레시피 · ↔ 좌우 스와이프로 레시피 상세로 전환">
          <DCArtboard id="reels"    label="18 레시피 릴스"        width={W} height={H}><ScreenReels        t={t}/></DCArtboard>
          <DCArtboard id="recipe"     label="19 레시피 상세"           width={W} height={H}><ScreenRecipeDetail t={t}/></DCArtboard>
          <DCArtboard id="recipe-mob" label="19′ 레시피 상세 · 모바일" width={W} height={H}><div className="dc-phone-clip"><ScreenRecipeDetail t={t}/></div></DCArtboard>
          <DCArtboard id="steps"    label="20 조리 순서"          width={W} height={H}><ScreenRecipeSteps  t={t}/></DCArtboard>
          <ReelsFlow />
        </DCSection>

        <DCSection id="me" title="06. 마이페이지" subtitle="개인화 · 주문 내역">
          <DCArtboard id="mypage"   label="21 마이페이지"         width={W} height={H}><ScreenMyPage    t={t}/></DCArtboard>
          <DCArtboard id="orders"   label="21a 주문 내역"         width={W} height={H}><ScreenOrders    t={t}/></DCArtboard>
          <DCArtboard id="wishlist" label="21b 찜 목록"           width={W} height={H}><ScreenWishlist  t={t}/></DCArtboard>
          <DCArtboard id="reviews"  label="21c 리뷰 관리"         width={W} height={H}><ScreenReviews   t={t}/></DCArtboard>
          <DCArtboard id="write-review" label="21d 리뷰 작성"     width={W} height={H}><ScreenWriteReview t={t}/></DCArtboard>
          <DCArtboard id="seller-register" label="21e 판매자 등록"  width={W} height={H}><ScreenSellerRegister t={t}/></DCArtboard>
          <DCArtboard id="seller-dashboard" label="21f 판매자 통계"  width={W} height={H}><ScreenSellerDashboard t={t}/></DCArtboard>
        </DCSection>

        <DCSection id="farm" title="07 · 농가 연결 & 주문" subtitle="장바구니 · 주문 완료 · 판매 등록(AI 작성 도움)">
          <DCArtboard id="cart"        label="22 장바구니"        width={W} height={H}><ScreenCart       t={t}/></DCArtboard>
          <DCArtboard id="order-complete" label="23 주문 완료"   width={W} height={H}><ScreenOrderComplete t={t}/></DCArtboard>
          <DCArtboard id="farm-upload" label="24 판매 등록 (AI 작성 도움)"   width={W} height={H}><ScreenFarmUpload t={t}/></DCArtboard>
        </DCSection>

        {/* 섹션 교차 화살표 — 09 홈 검색결과 더보기 → 11/13 정보 검색결과 (의미대로 매핑) */}
        <CrossSectionFlow
          pairs={[
            { src: '[data-flow-src="ingredient"]', dst: '[data-dc-slot="list-ing-res"]' },
            { src: '[data-flow-src="recipe"]', dst: '[data-dc-slot="list-rec-res"]' },
          ]}
        />
      </DesignCanvas>

      {/* Tweaks panel — 메인 그린 고정 · 포인트 / 중립 톤 비교 */}
      <TweaksPanel title="Tweaks">

        {/* 메인 그린은 고정으로 표시 */}
        <TweakSection label="메인 컬러 (고정)" />
        <div style={{
          display: 'flex', alignItems: 'center', gap: 10,
          padding: '8px 10px', borderRadius: 10,
          background: 'rgba(22,193,114,0.08)',
          border: '1px solid rgba(22,193,114,0.18)',
        }}>
          <div style={{
            width: 22, height: 22, borderRadius: 6,
            background: BRAND.primary,
            boxShadow: '0 0 0 1px rgba(0,0,0,0.06) inset',
          }} />
          <div style={{ display: 'flex', flexDirection: 'column', lineHeight: 1.2 }}>
            <span style={{ fontSize: 11.5, fontWeight: 700, color: 'rgba(15,26,20,0.85)' }}>
              제철 그린 · #16C172
            </span>
            <span style={{ fontSize: 10, color: 'rgba(15,26,20,0.55)', marginTop: 2 }}>
              브랜드 기본 컬러는 고정돼요
            </span>
          </div>
        </div>

        {/* 보조 그린 (연한/강조) */}
        <TweakSection label="보조 그린" />
        <TweakRadio
          label="연한 · 강조 · 차트"
          value={tk.green}
          options={Object.entries(GREEN_PRESETS).map(([key, p]) => ({
            value: key,
            label: p.label,
          }))}
          onChange={(v) => setTweak('green', v)}
        />
        {/* 보조 그린 미리보기 — primaryBg · primarySoft · primary(고정) · primaryDark · chartGreenDark */}
        <div style={{ display: 'flex', alignItems: 'center', gap: 6, padding: '6px 2px 0' }}>
          {(() => {
            const g = GREEN_PRESETS[tk.green] || GREEN_PRESETS.fresh;
            const swatches = [
              { c: g.primaryBg,      label: '연한' },
              { c: g.primarySoft,    label: '소프트' },
              { c: BRAND.primary,    label: '메인', lock: true },
              { c: g.primaryDark,    label: '강조' },
              { c: g.chartGreenDark, label: '차트' },
            ];
            return swatches.map((s, i) => (
              <div key={i} style={{
                width: 20, height: 20, borderRadius: 4,
                background: s.c,
                boxShadow: s.lock
                  ? '0 0 0 1.5px #fff, 0 0 0 2.5px rgba(22,193,114,.9)'
                  : '0 0 0 1px rgba(0,0,0,0.08) inset',
              }} title={s.label + ' · ' + s.c} />
            ));
          })()}
          <span style={{ fontSize: 10, color: 'rgba(41,38,27,.5)', marginLeft: 4 }}>
            연한·소프트·<b style={{ color: BRAND.primary, fontWeight: 700 }}>메인</b>·강조·차트
          </span>
        </div>

        {/* 포인트 컬러 */}
        <TweakSection label="포인트 컬러" />
        <TweakRadio
          label="강조 / 핫"
          value={tk.accent}
          options={Object.entries(ACCENT_PRESETS).map(([key, p]) => ({
            value: key,
            label: p.label,
          }))}
          onChange={(v) => setTweak('accent', v)}
        />
        {/* 현재 포인트 색 미리보기 */}
        <div style={{
          display: 'flex', alignItems: 'center', gap: 8,
          padding: '6px 2px 2px',
        }}>
          <div style={{
            width: 16, height: 16, borderRadius: 4,
            background: ACCENT_PRESETS[tk.accent]?.hot || ACCENT_PRESETS.coral.hot,
            boxShadow: '0 0 0 1px rgba(0,0,0,0.08) inset',
          }} />
          <span style={{ fontSize: 10.5, color: 'rgba(41,38,27,.6)', fontFamily: 'ui-monospace, monospace' }}>
            {ACCENT_PRESETS[tk.accent]?.hot}
          </span>
          <span style={{ fontSize: 10, color: 'rgba(41,38,27,.45)' }}>
            · 가격 상승 · 핫템 뱃지
          </span>
        </div>

        {/* 중립 톤 */}
        <TweakSection label="중립 톤" />
        <TweakRadio
          label="배경 / 텍스트"
          value={tk.neutral}
          options={Object.entries(NEUTRAL_PRESETS).map(([key, p]) => ({
            value: key,
            label: p.label,
          }))}
          onChange={(v) => setTweak('neutral', v)}
        />
        {/* 현재 중립 톤 미리보기 — bg, bgSoft, text */}
        <div style={{
          display: 'flex', alignItems: 'center', gap: 6, padding: '6px 2px 0',
        }}>
          {(() => {
            const n = NEUTRAL_PRESETS[tk.neutral] || NEUTRAL_PRESETS['warm-green'];
            const swatches = [n.bg, n.bgSoft, n.border, n.text];
            return swatches.map((c, i) => (
              <div key={i} style={{
                width: 18, height: 18, borderRadius: 4,
                background: c,
                boxShadow: '0 0 0 1px rgba(0,0,0,0.08) inset',
              }} />
            ));
          })()}
          <span style={{ fontSize: 10, color: 'rgba(41,38,27,.5)', marginLeft: 4 }}>
            배경 · 보조 · 보더 · 텍스트
          </span>
        </div>

        <div style={{ fontSize: 10.5, color: 'rgba(41,38,27,.55)', padding: '10px 2px 0', lineHeight: 1.5 }}>
          💡 메인 그린은 항상 동일하게 유지되고,<br/>
          포인트 컬러와 중립 톤만 비교돼요.
        </div>
      </TweaksPanel>
    </React.Fragment>
  );
}


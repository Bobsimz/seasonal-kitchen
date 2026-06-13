'use client';

import Link from 'next/link';
import { ChevronRight, Star, Sprout } from 'lucide-react';
import {
  useIngredient,
  useIngredientSubstitutes,
  useIngredientProducers,
  useIngredientRecipes,
} from '@/lib/queries';
import { AppHeader, BottomBar } from '@/components/layout';
import { Card, Section } from '@/components/ui/Card';
import { Chip } from '@/components/ui/Chip';
import { TrendBadge } from '@/components/ui/Misc';
import { LoadingScreen } from '@/components/ui/Spinner';
import { ErrorState } from '@/components/ui/States';
import { VegImage } from '@/components/domain/VegImage';
import { ProducerAvatar } from '@/components/domain/ProducerCard';
import { StyleBadge } from '@/components/domain/StyleBadge';
import { AddToCartButton } from '@/components/domain/AddToCartButton';
import { FavoriteHeart } from '@/components/domain/FavoriteHeart';
import { RecipeCard } from '@/components/domain/RecipeCard';
import { won, wonLabel, compact } from '@/lib/format';
import { cn } from '@/lib/cn';

// 구매 적기 신호 → 칩 톤/문구
const BUYING_SIGNAL = {
  GOOD: { tone: 'brand', label: '✓ 구매 적기' },
  HOLD: { tone: 'warn', label: '잠시 지켜보기' },
  HIGH: { tone: 'hot', label: '🔥 비싼 시기' },
};

// 이번주 베스트 농가 가중치 — 명예 > 신선도 > 평점.
const bestScore = (o) => (o.honorary ? 1000 : 0) + (o.freshnessLabel ? 100 : 0) + (o.rating || 0);

export default function IngredientDetailPage({ params }) {
  const id = params.id;

  const { data: ingredient, isLoading, error, refetch } = useIngredient(id);
  const { data: substitutes = [] } = useIngredientSubstitutes(id);
  const { data: offers = [] } = useIngredientProducers(id); // 가격 오름차순 (rating·honorary·style·freshness 포함)
  const { data: recipes = [] } = useIngredientRecipes(id);

  if (isLoading) return <LoadingScreen />;
  if (error || !ingredient) return <ErrorState onRetry={refetch} />;

  const hasOffers = offers.length > 0; // 직거래 농가 존재 여부 — 커머스 표면 on/off 의 단일 기준
  const signal = BUYING_SIGNAL[ingredient.buyingSignal] || null;
  const careTips = ingredient.careTips || [];
  const storageTips = ingredient.storageTips || [];

  // 농가 직거래 섹션 — 베스트 1행 + 가격순 상위, 상세에는 최대 3행.
  const cheapest = hasOffers ? offers[0] : null; // offers 는 가격 오름차순
  const best = hasOffers ? [...offers].sort((a, b) => bestScore(b) - bestScore(a))[0] : null;
  const ordered = best ? [best, ...offers.filter((o) => o.id !== best.id)] : offers;
  const detailRows = ordered.slice(0, 3);

  // ── 정보성 섹션 (팁 / 대체 / 레시피) — 빈 상태에선 대체 식재료를 위로 끌어올린다 ──
  const tipsSection =
    careTips.length > 0 || storageTips.length > 0 ? (
      <Section title="손질·보관 팁">
        <Card className="mx-4 p-[18px]">
          {careTips.length > 0 && (
            <>
              <h3 className="text-[14px] font-extrabold text-ink">손질법</h3>
              <ul className="mt-2.5 space-y-2.5">
                {careTips.map((tip, i) => (
                  <li key={i} className="flex gap-2.5">
                    <span className="mt-0.5 grid h-5 w-5 shrink-0 place-items-center rounded-full bg-brand-bg text-[11px] font-extrabold text-brand-dark">
                      {i + 1}
                    </span>
                    <span className="text-[12.5px] leading-relaxed text-ink-mid">{tip}</span>
                  </li>
                ))}
              </ul>
            </>
          )}
          {storageTips.length > 0 && (
            <>
              <h3 className={cn('text-[14px] font-extrabold text-ink', careTips.length > 0 && 'mt-4')}>보관법</h3>
              <ul className="mt-2.5 space-y-2.5">
                {storageTips.map((tip, i) => (
                  <li key={i} className="flex gap-2.5">
                    <span className="mt-1.5 h-1.5 w-1.5 shrink-0 rounded-full bg-brand" />
                    <span className="text-[12.5px] leading-relaxed text-ink-mid">{tip}</span>
                  </li>
                ))}
              </ul>
            </>
          )}
        </Card>
      </Section>
    ) : null;

  const substitutesSection =
    substitutes.length > 0 ? (
      <Section title={hasOffers ? '대체 식재료' : '대체 식재료 · 지금 살 수 있어요'}>
        <div className="flex gap-3 overflow-x-auto phone-scroll px-4 pb-1">
          {substitutes.map((s) => (
            <Link key={s.id} href={`/ingredients/${s.id}`} className="tap w-[150px] shrink-0">
              <Card className="h-full p-3">
                <VegImage name={s.name} src={s.imageUrl} size={48} />
                <p className="mt-2.5 text-[13.5px] font-bold text-ink">{s.name}</p>
                <p className="mt-1 text-[11.5px] leading-snug text-ink-soft line-clamp-2">{s.reason}</p>
              </Card>
            </Link>
          ))}
        </div>
      </Section>
    ) : null;

  const recipesSection =
    recipes.length > 0 ? (
      <Section
        title="관련 레시피"
        action={
          <Link href={`/info?tab=recipe`} className="tap flex items-center text-[12.5px] font-semibold text-ink-soft">
            더보기 <ChevronRight size={14} />
          </Link>
        }
      >
        <div className="flex gap-3 overflow-x-auto phone-scroll px-4 pb-1">
          {recipes.map((r) => (
            <RecipeCard key={r.id} recipe={r} width={168} className="shrink-0" />
          ))}
        </div>
      </Section>
    ) : null;

  return (
    <>
      {/* 히어로 이미지 위에 투명 헤더 */}
      <div className="relative">
        <AppHeader title={ingredient.name} back transparent className="absolute inset-x-0 top-0" />
        <div className="relative aspect-[16/11] w-full overflow-hidden bg-brand-bg">
          {ingredient.imageUrl ? (
            <img src={ingredient.imageUrl} alt={ingredient.name} className="h-full w-full object-cover" />
          ) : (
            <div className="grid h-full w-full place-items-center">
              <VegImage name={ingredient.name} size={120} />
            </div>
          )}
          <div className="absolute inset-0 bg-gradient-to-b from-black/30 via-transparent to-white" />
        </div>
        <FavoriteHeart
          targetType="INGREDIENT"
          targetId={ingredient.id}
          nextHref={`/ingredients/${id}`}
          stop={false}
          className="absolute right-3 top-2.5 z-20 grid h-11 w-11 place-items-center rounded-full border border-white/25 bg-white/15 backdrop-blur-md"
          iconClassName="text-white"
        />
      </div>

      <div className="animate-fade-up -mt-6 pb-6">
        {/* (1) 이름 · 카테고리 · (판매 시) 현재가 · 추세 · 구매신호 */}
        <div className="rounded-t-3xl bg-white px-5 pt-5">
          <div className="flex items-center gap-3">
            <VegImage name={ingredient.name} src={ingredient.imageUrl} size={56} />
            <div className="min-w-0">
              <h1 className="text-[26px] font-extrabold leading-none tracking-tight text-ink">{ingredient.name}</h1>
              {ingredient.category && <p className="mt-1.5 text-[12px] text-ink-soft">{ingredient.category}</p>}
            </div>
          </div>

          <div className="mt-3 flex flex-wrap gap-1.5">
            {ingredient.seasonal && <Chip tone="brand">🌱 지금 제철</Chip>}
            {ingredient.hot && <Chip tone="hot">🔥 트렌드 상승</Chip>}
            {/* 구매신호 칩은 살 수 있을 때만 — 살 곳 없는데 '구매 적기'는 모순 */}
            {hasOffers && signal && <Chip tone={signal.tone}>{signal.label}</Chip>}
          </div>

          {/* 현재가 (KAMIS) — 직거래 농가가 있을 때만. 살 수 없는데 가격만 노출하지 않는다. */}
          {hasOffers && (
            <Card className="mt-4 p-[18px]">
              <p className="text-[12px] font-semibold text-ink-mid">현재 가격</p>
              <div className="mt-1.5 flex flex-wrap items-baseline gap-2">
                <span className="text-[22px] font-extrabold tracking-tight text-ink tabular">
                  {wonLabel(ingredient.currentPrice)}
                  <span className="ml-1 text-[13px] font-semibold text-ink-mid">/{ingredient.unit}</span>
                </span>
                {ingredient.priceChangeLabel && (
                  <TrendBadge direction={ingredient.trendDirection} label={ingredient.priceChangeLabel} />
                )}
              </div>
              <p className="mt-1 text-[11.5px] text-ink-soft">KAMIS 공식 시세 · 주요 매장 기준</p>
            </Card>
          )}

          {/* 빈 상태 — 직거래 농가 0곳: 인라인 알림 카드 (입고 알림 = 찜 재사용) */}
          {!hasOffers && (
            <Card className="mt-4 border border-line-soft p-[18px] text-center shadow-none">
              <p className="text-[14.5px] font-extrabold text-ink">아직 직거래 농가가 없어요</p>
              <p className="mx-auto mt-1.5 max-w-[280px] text-[12.5px] leading-relaxed text-ink-soft">
                {ingredient.name} 취급 농가가 등록되면 가장 먼저 알려드릴게요. 그동안 손질법과 대체 재료를 확인해 보세요.
              </p>
              <FavoriteHeart
                targetType="INGREDIENT"
                targetId={ingredient.id}
                nextHref={`/ingredients/${id}`}
                stop={false}
                label="입고 알림 받기"
                size={16}
                className="mx-auto mt-3.5 flex items-center justify-center gap-1.5 rounded-xl border border-brand/30 bg-brand-bg px-4 py-2.5 text-[13px] font-bold text-brand-dark"
                iconClassName="text-brand-dark"
                fillClassName="fill-brand-dark text-brand-dark"
              />
            </Card>
          )}
        </div>

        {/* (2) 농가 직거래 — 베스트 + 가격순 상위 (행별 담기). 4곳+ 일 때만 전체 비교 링크 노출 */}
        {hasOffers && (
          <Section
            title="농가 직거래"
            action={
              offers.length > 3 ? (
                <Link
                  href={`/ingredients/${id}/producers`}
                  className="tap flex items-center text-[12.5px] font-semibold text-ink-soft"
                >
                  전체 비교 {offers.length}곳 <ChevronRight size={14} />
                </Link>
              ) : null
            }
          >
            <div className="mx-4 overflow-hidden rounded-2xl border border-line-soft bg-surface">
              {detailRows.map((o, i) => (
                <FarmOfferRow
                  key={o.id}
                  offer={o}
                  recommended={o.id === best?.id}
                  lowest={o.id === cheapest?.id}
                  last={i === detailRows.length - 1}
                />
              ))}
            </div>
            <p className="mt-2 px-5 text-[11px] text-ink-soft">ⓘ 베스트는 명예 농가 · 신선도 · 평점 기준이에요.</p>
          </Section>
        )}

        {/* (3) 정보성 섹션 — 판매 있으면 팁→대체→레시피, 없으면 대체→팁→레시피 */}
        {hasOffers ? (
          <>
            {tipsSection}
            {substitutesSection}
            {recipesSection}
          </>
        ) : (
          <>
            {substitutesSection}
            {tipsSection}
            {recipesSection}
          </>
        )}
      </div>

      {/* 하단 고정 CTA */}
      <BottomBar>
        {hasOffers ? (
          <>
            <div className="flex-1">
              <p className="text-[11px] text-ink-soft">최저 농가가</p>
              <p className="text-[16px] font-extrabold text-ink tabular">
                {wonLabel(cheapest.price)}
                <span className="ml-0.5 text-[12px] font-semibold text-ink-mid">/{cheapest.unit}~</span>
              </p>
            </div>
            <div className="flex-[1.6]">
              <AddToCartButton offerId={cheapest.id} variant="full" label="최저가 담기" />
            </div>
          </>
        ) : (
          <FavoriteHeart
            targetType="INGREDIENT"
            targetId={ingredient.id}
            nextHref={`/ingredients/${id}`}
            stop={false}
            label="입고되면 알림 받기"
            size={18}
            className="flex w-full items-center justify-center gap-2 rounded-xl bg-brand py-3.5 text-[15px] font-extrabold text-white"
            iconClassName="text-white"
            fillClassName="fill-white text-white"
          />
        )}
      </BottomBar>
    </>
  );
}

// 농가 직거래 한 줄 — 좌: 농가(탭 시 농가 상세), 우: 가격 + 담기. recommended/lowest 배지.
function FarmOfferRow({ offer, recommended, lowest, last }) {
  return (
    <div className={cn('px-4 py-3.5', !last && 'border-b border-line-soft')}>
      <Link href={`/producers/${offer.producerId}`} className="tap flex items-center gap-3">
        <ProducerAvatar producer={{ photoUrl: offer.photoUrl, honorary: offer.honorary }} size={44} />
        <div className="min-w-0 flex-1">
          <div className="flex flex-wrap items-center gap-1.5">
            {recommended && (
              <span className="shrink-0 rounded-full bg-brand px-1.5 py-0.5 text-[10.5px] font-extrabold text-white">
                👑 추천
              </span>
            )}
            {lowest && (
              <span className="shrink-0 rounded-full bg-brand-bg px-1.5 py-0.5 text-[10.5px] font-extrabold text-brand-dark">
                최저가
              </span>
            )}
            <span className="truncate text-[14px] font-bold text-ink">
              {offer.region} {offer.producerName}
            </span>
          </div>
          <div className="mt-1 flex items-center gap-2">
            <StyleBadge style={offer.style} className="!px-1.5 !py-0.5 !text-[10.5px]" />
            <span className="flex items-center gap-0.5 text-[11.5px] font-semibold text-ink-mid">
              <Star size={11} className="fill-warn text-warn" />
              {offer.rating}
              <span className="font-normal text-ink-soft">({compact(offer.reviewCount)})</span>
            </span>
          </div>
        </div>
        <ChevronRight size={16} className="shrink-0 text-ink-soft" />
      </Link>

      <div className="mt-2.5 flex items-center gap-2 border-t border-line-soft pt-2.5">
        <div className="flex items-baseline gap-1">
          <span className="text-[16px] font-extrabold tabular-nums text-ink">{won(offer.price)}원</span>
          <span className="text-[12px] text-ink-mid">/{offer.unit}</span>
        </div>
        {offer.freshnessLabel && (
          <span className="ml-1.5 flex items-center gap-0.5 text-[11.5px] font-bold text-brand">
            <Sprout size={12} />
            {offer.freshnessLabel}
          </span>
        )}
        <div className="ml-auto">
          <AddToCartButton offerId={offer.id} />
        </div>
      </div>
    </div>
  );
}

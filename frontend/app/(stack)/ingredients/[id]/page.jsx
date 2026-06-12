'use client';

import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { ChevronRight, Truck } from 'lucide-react';
import {
  useIngredient,
  useIngredientPrices,
  useIngredientSubstitutes,
  useIngredientStoreOffers,
  useIngredientRecipes,
} from '@/lib/queries';
import { AppHeader, BottomBar } from '@/components/layout';
import { Button } from '@/components/ui/Button';
import { Card, Section } from '@/components/ui/Card';
import { Chip } from '@/components/ui/Chip';
import { TrendBadge } from '@/components/ui/Misc';
import { LoadingScreen } from '@/components/ui/Spinner';
import { ErrorState } from '@/components/ui/States';
import { VegImage } from '@/components/domain/VegImage';
import { PriceBars } from '@/components/domain/PriceBars';
import { RecipeCard } from '@/components/domain/RecipeCard';
import { won, wonLabel } from '@/lib/format';
import { cn } from '@/lib/cn';

// 구매 적기 신호 → 칩 톤/문구
const BUYING_SIGNAL = {
  GOOD: { tone: 'brand', label: '✓ 구매 적기' },
  HOLD: { tone: 'warn', label: '잠시 지켜보기' },
  HIGH: { tone: 'hot', label: '🔥 비싼 시기' },
};

export default function IngredientDetailPage({ params }) {
  const id = params.id;
  const router = useRouter();

  const { data: ingredient, isLoading, error, refetch } = useIngredient(id);
  const { data: prices = [] } = useIngredientPrices(id);
  const { data: substitutes = [] } = useIngredientSubstitutes(id);
  const { data: storeOffers = [] } = useIngredientStoreOffers(id);
  const { data: recipes = [] } = useIngredientRecipes(id);

  if (isLoading) return <LoadingScreen />;
  if (error || !ingredient) return <ErrorState onRetry={refetch} />;

  const signal = BUYING_SIGNAL[ingredient.buyingSignal] || null;
  const nutrition = ingredient.nutrition || [];
  const careTips = ingredient.careTips || [];
  const storageTips = ingredient.storageTips || [];

  // 리테일 시세 — 가격 오름차순 정렬
  const sortedOffers = [...storeOffers].sort((a, b) => a.price - b.price);

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
      </div>

      <div className="animate-fade-up -mt-6 pb-6">
        {/* (1) 이름 · 카테고리 · 현재가 · 추세 · 구매신호 */}
        <div className="rounded-t-3xl bg-white px-5 pt-5">
          <div className="flex items-center gap-3">
            <VegImage name={ingredient.name} src={ingredient.imageUrl} size={56} />
            <div className="min-w-0">
              <h1 className="text-[26px] font-extrabold leading-none tracking-tight text-ink">
                {ingredient.name}
              </h1>
              {ingredient.category && (
                <p className="mt-1.5 text-[12px] text-ink-soft">{ingredient.category}</p>
              )}
            </div>
          </div>

          <div className="mt-3 flex flex-wrap gap-1.5">
            {ingredient.seasonal && <Chip tone="brand">🌱 지금 제철</Chip>}
            {ingredient.hot && <Chip tone="hot">🔥 트렌드 상승</Chip>}
            {signal && <Chip tone={signal.tone}>{signal.label}</Chip>}
          </div>

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
        </div>

        {/* (2) 가격 추이 */}
        {prices.length > 0 && (
          <Section title="가격 추이">
            <Card className="mx-4 p-4">
              <PriceBars data={prices} unit={ingredient.unit} />
            </Card>
          </Section>
        )}

        {/* (3) 영양 정보 */}
        {nutrition.length > 0 && (
          <Section title="영양 정보">
            <div className="grid grid-cols-2 gap-2.5 px-4">
              {nutrition.map((n) => (
                <Card key={n.label} className="flex items-center justify-between px-4 py-3">
                  <span className="text-[12.5px] text-ink-mid">{n.label}</span>
                  <span className="text-[14px] font-bold text-ink tabular">{n.value}</span>
                </Card>
              ))}
            </div>
          </Section>
        )}

        {/* (4) 손질 · 보관 팁 */}
        {(careTips.length > 0 || storageTips.length > 0) && (
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
                  <h3 className={cn('text-[14px] font-extrabold text-ink', careTips.length > 0 && 'mt-4')}>
                    보관법
                  </h3>
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
        )}

        {/* (5) 대체 식재료 */}
        {substitutes.length > 0 && (
          <Section title="대체 식재료">
            <div className="flex gap-3 overflow-x-auto phone-scroll px-4 pb-1">
              {substitutes.map((s) => (
                <Link
                  key={s.id}
                  href={`/ingredients/${s.id}`}
                  className="tap w-[150px] shrink-0"
                >
                  <Card className="h-full p-3">
                    <VegImage name={s.name} src={s.imageUrl} size={48} />
                    <p className="mt-2.5 text-[13.5px] font-bold text-ink">{s.name}</p>
                    <p className="mt-1 text-[11.5px] leading-snug text-ink-soft line-clamp-2">{s.reason}</p>
                  </Card>
                </Link>
              ))}
            </div>
          </Section>
        )}

        {/* (6) 리테일 시세 비교 */}
        {sortedOffers.length > 0 && (
          <Section title="리테일 시세 비교">
            <Card className="mx-4 overflow-hidden p-0">
              {sortedOffers.map((o, i) => (
                <div
                  key={o.id}
                  className={cn(
                    'flex items-center gap-3 px-4 py-3.5',
                    i < sortedOffers.length - 1 && 'border-b border-line-soft',
                  )}
                >
                  <div className="min-w-0 flex-1">
                    <div className="flex items-center gap-1.5">
                      <span className="truncate text-[14px] font-bold text-ink">{o.store}</span>
                      {(o.tag || i === 0) && <Chip tone="brand">{o.tag || '최저가'}</Chip>}
                    </div>
                    {o.delivery && <p className="mt-1 text-[11.5px] text-ink-soft">{o.delivery}</p>}
                  </div>
                  <div className="text-right">
                    <div className="flex items-baseline justify-end gap-1">
                      <span className="text-[15px] font-extrabold text-ink tabular">{won(o.price)}</span>
                      <span className="text-[11px] text-ink-mid">원</span>
                    </div>
                    {o.discountPct ? (
                      <p className="mt-0.5 text-[11px] font-bold text-hot tabular">{o.discountPct}% 할인</p>
                    ) : o.originalPrice && o.originalPrice > o.price ? (
                      <p className="mt-0.5 text-[11px] text-ink-soft line-through tabular">{won(o.originalPrice)}원</p>
                    ) : null}
                  </div>
                </div>
              ))}
            </Card>
            <p className="mt-2.5 px-4 text-[11.5px] leading-relaxed text-ink-soft">
              가격은 동일 단위로 환산했어요. 배송비·수확일은 각 판매처에서 확인하세요.
            </p>
          </Section>
        )}

        {/* (7) 관련 레시피 */}
        {recipes.length > 0 && (
          <Section
            title="관련 레시피"
            action={
              <Link
                href={`/info?tab=recipe`}
                className="tap flex items-center text-[12.5px] font-semibold text-ink-soft"
              >
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
        )}
      </div>

      {/* 하단 고정 CTA — 농가 직거래 */}
      <BottomBar>
        <div className="flex-1">
          <p className="text-[11px] text-ink-soft">최저 농가가</p>
          <p className="text-[16px] font-extrabold text-ink tabular">
            {wonLabel(ingredient.currentPrice)}
            <span className="ml-0.5 text-[12px] font-semibold text-ink-mid">/{ingredient.unit}~</span>
          </p>
        </div>
        <Button
          block
          size="lg"
          className="flex-[1.6] gap-1.5"
          onClick={() => router.push(`/ingredients/${id}/producers`)}
        >
          <Truck size={18} /> 농가 직거래 보기
        </Button>
      </BottomBar>
    </>
  );
}

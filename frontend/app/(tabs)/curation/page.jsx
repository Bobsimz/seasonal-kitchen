'use client';

import Link from 'next/link';
import { Sprout, Wallet, Leaf, ChevronRight } from 'lucide-react';
import { useHome, useIngredients, useRecipes } from '@/lib/queries';
import { AppHeader } from '@/components/layout';
import { Card, Section } from '@/components/ui/Card';
import { Chip } from '@/components/ui/Chip';
import { LoadingScreen } from '@/components/ui/Spinner';
import { ErrorState, EmptyState } from '@/components/ui/States';
import { IngredientCard } from '@/components/domain/IngredientCard';
import { RecipeCard } from '@/components/domain/RecipeCard';

const WHY_NOW = [
  { Icon: Sprout, k: '제철 적기', v: '2~3월이 1년 중 가장 달고 부드러워요' },
  { Icon: Wallet, k: '가격 매력', v: '평년 대비 22% 저렴 · 지금이 구매 적기' },
  { Icon: Leaf, k: '영양 가득', v: '비타민C·식이섬유 풍부 · 겨울철 면역에 좋아요' },
];

function WhyNowRow({ Icon, k, v }) {
  return (
    <Card className="flex items-center gap-3 border border-line-soft p-3.5 shadow-none">
      <div className="grid h-[38px] w-[38px] shrink-0 place-items-center rounded-xl bg-brand-bg text-brand">
        <Icon size={18} />
      </div>
      <div className="min-w-0 flex-1">
        <p className="text-[13.5px] font-extrabold text-ink">{k}</p>
        <p className="mt-0.5 text-[11.5px] leading-snug text-ink-soft">{v}</p>
      </div>
    </Card>
  );
}

export default function CurationPage() {
  const { data: home, isLoading, error, refetch } = useHome();
  const { data: ingredients = [] } = useIngredients();
  const { data: recipes = [] } = useRecipes();

  const hero = home?.hero;
  const seasonalIngredients = ingredients.filter((i) => i.seasonal || i.hot).slice(0, 8);
  const seasonalRecipes = recipes.filter((r) => r.seasonal).slice(0, 6);
  const recipeList = seasonalRecipes.length ? seasonalRecipes : recipes.slice(0, 6);

  return (
    <>
      <AppHeader title="제철 큐레이션" back transparent />

      {isLoading && <LoadingScreen />}
      {error && <ErrorState onRetry={refetch} />}

      {home && (
        <div className="-mt-14 animate-fade-up pb-7">
          {/* ── 히어로 ── */}
          <Link href={`/ingredients/${hero.ingredientId}`} className="tap relative block h-[300px] overflow-hidden">
            <img src={hero.imageUrl} alt={hero.title} className="absolute inset-0 h-full w-full object-cover" />
            <div className="absolute inset-0 bg-gradient-to-b from-black/40 via-black/10 to-black/85" />
            <div className="absolute inset-x-0 bottom-0 px-6 pb-5 text-white">
              <div className="flex items-center gap-1.5 text-[11.5px] font-extrabold tracking-wide text-brand-soft drop-shadow">
                <span className="h-1.5 w-1.5 rounded-full bg-brand-soft shadow-[0_0_10px_rgba(157,232,181,0.9)]" />
                {home.locationLabel}
              </div>
              <h1 className="mt-2 font-display text-[30px] font-extrabold leading-tight tracking-tight drop-shadow-lg">
                지금이 딱,
                <br />
                {hero.title.replace(/^지금이 제철,?\s*/, '')}의 계절
              </h1>
              <p className="mt-1.5 text-[12.5px] font-medium text-white/90 drop-shadow">
                1년 중 가장 맛있고 저렴할 때 · {hero.priceLabel} · {hero.trendLabel}
              </p>
            </div>
          </Link>

          {/* ── 제철 이야기 ── */}
          <div className="px-4 pt-4">
            <Card className="border border-line-soft p-[18px] shadow-none">
              <p className="text-[12.5px] font-extrabold tracking-wide text-brand">제철 이야기</p>
              <p className="mt-2.5 text-[14px] leading-[1.75] tracking-tight text-ink-mid">
                겨우내 언 땅을 견디고 올라온 봄동은, 추위를 이겨낸 만큼 잎이 도톰하고 단맛이 깊어요. 찬 바람이 단단하게 키운
                봄의 첫 채소랍니다. 살짝 데쳐 된장에 무치거나 겉절이로 무쳐내면, 식탁에 가장 먼저 봄이 찾아와요. 1년 중 가장
                맛있는 지금, 봄동으로 봄을 맞이해보세요.
              </p>
            </Card>
          </div>

          {/* ── 왜 지금일까요? ── */}
          <Section title="왜 지금이 제철일까요?" className="mt-6">
            <div className="flex flex-col gap-2 px-4">
              {WHY_NOW.map((p) => (
                <WhyNowRow key={p.k} {...p} />
              ))}
            </div>
          </Section>

          {/* ── 이번 주 제철 식재료 ── */}
          <Section
            title="이번 주 제철 식재료"
            action={
              <Link href="/info" className="tap flex items-center text-[12.5px] font-semibold text-ink-soft">
                더보기 <ChevronRight size={14} />
              </Link>
            }
          >
            {seasonalIngredients.length ? (
              <div className="flex gap-3 overflow-x-auto phone-scroll px-4 pb-1">
                {seasonalIngredients.map((i) => (
                  <IngredientCard key={i.id} ingredient={i} />
                ))}
              </div>
            ) : (
              <div className="px-4">
                <EmptyState title="제철 식재료가 없어요" description="곧 새로운 제철 식재료를 채워둘게요." />
              </div>
            )}
          </Section>

          {/* ── 어울리는 제철 레시피 ── */}
          <Section
            title="어울리는 제철 레시피"
            action={
              <Link href="/info?tab=recipe" className="tap flex items-center text-[12.5px] font-semibold text-ink-soft">
                더보기 <ChevronRight size={14} />
              </Link>
            }
          >
            {recipeList.length ? (
              <div className="flex gap-3 overflow-x-auto phone-scroll px-4 pb-1">
                {recipeList.map((r) => (
                  <RecipeCard key={r.id} recipe={r} width={168} className="shrink-0" />
                ))}
              </div>
            ) : (
              <div className="px-4">
                <EmptyState title="레시피가 없어요" description="제철 식재료로 만드는 레시피를 준비 중이에요." />
              </div>
            )}
          </Section>

          {/* ── 제철 상품 전체 보기 ── */}
          <div className="px-4 pt-6">
            <Link
              href={`/ingredients/${hero.ingredientId}/producers`}
              className="tap flex h-[46px] items-center justify-center gap-1.5 rounded-xl border border-line-soft bg-surface-soft text-[13px] font-bold text-ink"
            >
              제철 상품 전체 보기
              <ChevronRight size={14} />
            </Link>
          </div>
        </div>
      )}
    </>
  );
}

'use client';

import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { Clock, Heart, ChevronRight } from 'lucide-react';
import { useRecipe, useReels } from '@/lib/queries';
import { AppHeader, BottomBar } from '@/components/layout';
import { Button } from '@/components/ui/Button';
import { Section } from '@/components/ui/Card';
import { Chip } from '@/components/ui/Chip';
import { LoadingScreen } from '@/components/ui/Spinner';
import { ErrorState } from '@/components/ui/States';
import { VegImage } from '@/components/domain/VegImage';
import { ReelThumb } from '@/components/domain/ReelThumb';
import { FavoriteHeart } from '@/components/domain/FavoriteHeart';
import { won, compact } from '@/lib/format';

export default function RecipeDetailPage({ params }) {
  const id = params.id;
  const router = useRouter();
  const { data: recipe, isLoading, error, refetch } = useRecipe(id);

  if (isLoading) {
    return (
      <>
        <AppHeader back />
        <LoadingScreen />
      </>
    );
  }

  if (error || !recipe) {
    return (
      <>
        <AppHeader title="레시피" back />
        <ErrorState onRetry={refetch} />
      </>
    );
  }

  return (
    <>
      {/* 투명 헤더 — 히어로 이미지 위 (흰 텍스트) + 찜 토글 */}
      <AppHeader
        title={recipe.title}
        back
        transparent
        right={
          <FavoriteHeart
            targetType="RECIPE"
            targetId={recipe.id}
            size={22}
            className="grid h-10 w-10 place-items-center"
            iconClassName="text-white drop-shadow"
            nextHref={`/recipes/${id}`}
          />
        }
      />

      <div className="animate-fade-up pb-6">
        {/* 히어로 — 헤더 뒤로 끌어올림 */}
        <div className="relative -mt-14 aspect-[4/3] w-full overflow-hidden bg-ink">
          {recipe.imageUrl && (
            <img src={recipe.imageUrl} alt={recipe.title} className="h-full w-full object-cover" />
          )}
          <div className="absolute inset-0 bg-gradient-to-t from-black/45 via-black/10 to-black/35" />
        </div>

        {/* 제목 블록 */}
        <div className="px-5 pt-4">
          {recipe.seasonal && (
            <div className="mb-2.5">
              <Chip tone="brand">제철</Chip>
            </div>
          )}
          <h1 className="text-[23px] font-extrabold leading-tight tracking-tight text-ink">
            {recipe.title}
          </h1>

          {/* 메타 행 — 소요시간 · 난이도 · 인분 · 좋아요 */}
          <div className="mt-3 flex flex-wrap items-center gap-x-3 gap-y-1.5 text-[13px] font-semibold text-ink-mid">
            <span className="flex items-center gap-1">
              <Clock size={14} className="text-ink-soft" /> {recipe.cookMinutes}분
            </span>
            <span className="text-line">·</span>
            <span>{recipe.difficulty}</span>
            {recipe.servings != null && (
              <>
                <span className="text-line">·</span>
                <span>{recipe.servings}인분</span>
              </>
            )}
            <span className="text-line">·</span>
            <span className="flex items-center gap-1">
              <Heart size={13} className="text-hot" /> {compact(recipe.likes)}
            </span>
          </div>

          {recipe.description && (
            <p className="mt-3 text-[13.5px] leading-relaxed text-ink-mid">{recipe.description}</p>
          )}

          {/* 태그 칩 */}
          {recipe.tags?.length ? (
            <div className="mt-3 flex flex-wrap gap-2">
              {recipe.tags.map((tag) => (
                <Chip key={tag} tone="neutral">
                  {tag}
                </Chip>
              ))}
            </div>
          ) : null}

          {/* 크리에이터 */}
          {recipe.creatorName && (
            <div className="mt-4 flex items-center gap-2 text-[13px] text-ink-soft">
              <span className="font-bold text-ink">@{recipe.creatorName}</span>
              <span>· 레시피 제공</span>
            </div>
          )}
        </div>

        {/* 재료 + 예상 비용 */}
        <Section
          title={
            <span>
              재료{' '}
              {recipe.servings != null && (
                <span className="text-[13px] font-semibold text-ink-soft">{recipe.servings}인분</span>
              )}
            </span>
          }
          action={
            recipe.estimatedCost != null ? (
              <span className="text-[13px] font-extrabold text-brand">예상 비용 {won(recipe.estimatedCost)}원</span>
            ) : null
          }
        >
          <div className="mx-4 overflow-hidden rounded-2xl border border-line-soft">
            {(recipe.ingredients ?? []).map((it, i, arr) => (
              <IngredientCostRow key={`${it.name}-${i}`} item={it} last={i === arr.length - 1} />
            ))}
          </div>
        </Section>

        {/* 관련 릴스 */}
        <RelatedReels recipe={recipe} />
      </div>

      {/* 하단 고정 CTA */}
      <BottomBar>
        <Button block size="lg" onClick={() => router.push(`/recipes/${id}/steps`)}>
          조리 시작
        </Button>
      </BottomBar>
    </>
  );
}

// 재료 행 — 썸네일 + 이름/분량 + 가격. 식재료 상세로 이동.
function IngredientCostRow({ item, last }) {
  const inner = (
    <>
      <VegImage name={item.name} src={item.imageUrl} size={36} rounded="rounded-xl" />
      <div className="min-w-0 flex-1">
        <p className="line-clamp-1 text-[14px] font-bold text-ink">{item.name}</p>
        {item.amount && <p className="text-[11.5px] text-ink-soft">{item.amount}</p>}
      </div>
      <div className="shrink-0 text-right text-[13px] font-bold tabular-nums text-ink">
        {item.price != null ? `${won(item.price)}원` : '−'}
      </div>
      {item.ingredientId != null && <ChevronRight size={16} className="shrink-0 text-ink-soft" />}
    </>
  );

  const cls = `flex items-center gap-3 px-3.5 py-3 ${!last ? 'border-b border-line-soft' : ''}`;

  if (item.ingredientId != null) {
    return (
      <Link href={`/ingredients/${item.ingredientId}`} className={`tap ${cls}`}>
        {inner}
      </Link>
    );
  }
  return <div className={cls}>{inner}</div>;
}

// 관련 릴스 — relatedReelIds 또는 recipeId 로 매칭한 릴스 캐러셀.
function RelatedReels({ recipe }) {
  const { data: reels = [] } = useReels();

  const related = reels.filter(
    (r) => recipe.relatedReelIds?.includes(r.id) || r.recipeId === recipe.id,
  );

  if (!related.length) return null;

  return (
    <Section title="관련 릴스" action={<span className="text-[12px] font-semibold text-ink-soft">숏폼 {related.length}개</span>}>
      <div className="flex gap-3 overflow-x-auto phone-scroll px-4 pb-1">
        {related.map((r) => (
          <ReelThumb key={r.id} reel={r} width={120} />
        ))}
      </div>
    </Section>
  );
}

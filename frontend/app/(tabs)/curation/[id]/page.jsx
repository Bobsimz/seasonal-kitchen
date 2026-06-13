'use client';

import { useState } from 'react';
import { useParams } from 'next/navigation';
import { useCuration } from '@/lib/queries';
import { AppHeader } from '@/components/layout';
import { Card } from '@/components/ui/Card';
import { LoadingScreen } from '@/components/ui/Spinner';
import { ErrorState, EmptyState } from '@/components/ui/States';
import { SegmentedToggle } from '@/components/ui/SegmentedToggle';
import { IngredientRow } from '@/components/domain/IngredientCard';
import { RecipeRow } from '@/components/domain/RecipeCard';

const TABS = [
  { value: 'ingredient', label: '관련 식재료' },
  { value: 'recipe', label: '관련 레시피' },
];

export default function CurationDetailPage() {
  const { id } = useParams();
  const { data, isLoading, error, refetch } = useCuration(id);
  const [tab, setTab] = useState('ingredient');

  // 투명 헤더(흰 아이콘)는 다크 히어로가 뒤에 있을 때만 읽힌다. 로딩/에러 화면(밝은 배경)에선
  // 뒤로가기 화살표가 묻히므로, 식재료/레시피 상세와 동일하게 데이터가 있을 때만 헤더+히어로를 렌더한다.
  if (isLoading) return <LoadingScreen />;
  if (error || !data) return <ErrorState onRetry={refetch} />;

  return (
    <>
      {/* 히어로 위에 얹히는 투명 헤더(스크롤하면 콘텐츠와 함께 위로 사라짐) — 식재료/레시피 상세와 동일 패턴 */}
      <AppHeader title="제철 큐레이션" back transparent className="absolute inset-x-0 top-0 z-20" />

      <div className="animate-fade-up pb-8">
          {/* ── 히어로: 메인 이미지 · 메인 타이틀 · 서브타이틀 ── */}
          <div className="relative h-[clamp(300px,44svh,380px)] w-full overflow-hidden">
            <img
              src={data.imageUrl}
              alt={data.title ?? '제철 큐레이션'}
              className="absolute inset-0 h-full w-full object-cover"
              style={{ objectPosition: 'center 32%' }}
            />
            {/* 상단 스크림(뒤로가기 가독) + 하단 어둡게(타이틀/서브 가독) */}
            <div
              className="absolute inset-0"
              style={{
                background:
                  'linear-gradient(180deg, rgba(0,0,0,0.45) 0%, rgba(0,0,0,0.10) 28%, rgba(15,26,20,0.18) 52%, rgba(15,26,20,0.84) 100%)',
              }}
            />
            <div className="absolute inset-x-0 bottom-0 px-6 pb-6 text-white">
              <h1
                className="font-display text-[26px] font-extrabold leading-[1.15] tracking-[-0.5px]"
                style={{ textShadow: '0 2px 18px rgba(0,0,0,0.45)' }}
              >
                {data.title}
              </h1>
              {data.subtitle && (
                <p
                  className="mt-2 text-[13.5px] font-medium leading-snug text-white/90"
                  style={{ textShadow: '0 1px 10px rgba(0,0,0,0.5)' }}
                >
                  {data.subtitle}
                </p>
              )}
            </div>
          </div>

          {/* ── 제철 이야기 ── */}
          {data.seasonalStory && (
            <div className="px-4 pt-4">
              <Card className="border border-line-soft p-[18px] shadow-none">
                <p className="text-[12.5px] font-extrabold tracking-wide text-brand">제철 이야기</p>
                <p className="mt-2.5 whitespace-pre-line text-[14px] leading-[1.75] tracking-tight text-ink-mid">
                  {data.seasonalStory}
                </p>
              </Card>
            </div>
          )}

          {/* ── 관련 식재료 / 레시피 탭 ── */}
          <div className="px-4 pt-6">
            <SegmentedToggle options={TABS} value={tab} onChange={setTab} className="w-full" />
          </div>
          <div className="mt-4">
            {tab === 'ingredient' ? (
              <RelatedList
                items={data.relatedIngredients}
                empty="관련 식재료가 없어요"
                render={(i, divider) => <IngredientRow key={i.id} ingredient={i} divider={divider} />}
              />
            ) : (
              <RelatedList
                items={data.relatedRecipes}
                empty="관련 레시피가 없어요"
                render={(r, divider) => <RecipeRow key={r.id} recipe={r} divider={divider} />}
              />
            )}
          </div>
      </div>
    </>
  );
}

function RelatedList({ items = [], empty, render }) {
  if (!items.length) {
    return (
      <div className="px-4">
        <EmptyState title={empty} description="곧 새로운 제철 콘텐츠로 채워둘게요." />
      </div>
    );
  }
  return (
    <div className="mx-4 overflow-hidden rounded-2xl border border-line-soft bg-surface">
      {items.map((item, idx, arr) => render(item, idx < arr.length - 1))}
    </div>
  );
}

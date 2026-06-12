'use client';

import { Suspense, useState } from 'react';
import Link from 'next/link';
import { useRouter, useSearchParams } from 'next/navigation';
import { ChevronRight } from 'lucide-react';
import { useSearch, useTrending } from '@/lib/queries';
import { AppHeader } from '@/components/layout';
import { SearchBar } from '@/components/ui/SearchBar';
import { Chip } from '@/components/ui/Chip';
import { LoadingScreen } from '@/components/ui/Spinner';
import { ErrorState, EmptyState } from '@/components/ui/States';
import { IngredientRow } from '@/components/domain/IngredientCard';
import { RecipeRow } from '@/components/domain/RecipeCard';
import { ReelThumb } from '@/components/domain/ReelThumb';

// 검색 결과 섹션 헤더 — 제목 + 결과 수.
function SectionHeader({ title, count }) {
  return (
    <div className="mb-3 flex items-baseline gap-1.5 px-5">
      <h2 className="text-[16px] font-extrabold tracking-tight text-ink">{title}</h2>
      {count != null && <span className="text-[12px] font-bold text-ink-soft tabular">{count}</span>}
    </div>
  );
}

// "OO 더보기" 가로 버튼 — 정보 탭으로 이동.
function MoreButton({ label, href }) {
  return (
    <div className="px-5 pt-1">
      <Link
        href={href}
        className="tap flex h-11 w-full items-center justify-center gap-1 rounded-xl border border-line-soft bg-line-soft text-[13px] font-bold text-ink"
      >
        {label}
        <ChevronRight size={14} />
      </Link>
    </div>
  );
}

// 섹션 사이 회색 구분 띠.
function SectionDivider() {
  return <div className="mt-6 h-2 w-full bg-line-soft" />;
}

function SearchInner() {
  const router = useRouter();
  const params = useSearchParams();
  const initialQ = params.get('q') || '';

  const [input, setInput] = useState(initialQ);
  const q = input.trim();
  const enabled = q.length > 0;

  const { data, isLoading, error, refetch } = useSearch(q, 'ALL', enabled);

  return (
    <>
      <AppHeader title="검색" back />

      <div className="border-b border-line-soft bg-white px-4 pb-3 pt-1">
        <SearchBar
          value={input}
          onChange={setInput}
          onSubmit={(v) => setInput(v ?? '')}
          autoFocus
          placeholder="재료, 레시피, 키워드를 검색해보세요"
        />
      </div>

      {!enabled && <EmptyQueryView onPick={setInput} />}

      {enabled && (
        <div className="pb-6">
          {isLoading && <LoadingScreen />}
          {error && <ErrorState onRetry={refetch} />}

          {data && (
            <SearchResults
              data={data}
              q={q}
              onNavigate={(href) => router.push(href)}
            />
          )}
        </div>
      )}
    </>
  );
}

// ── 검색 전: 최근 검색 + 실시간 인기 검색어 ──────────────────
function EmptyQueryView({ onPick }) {
  const { data: trending = [] } = useTrending();
  // 최근 검색어 데모: 인기 검색어 일부를 칩으로 노출.
  const recent = trending.slice(0, 5).map((it) => it.keyword);

  return (
    <div className="animate-fade-up pb-6">
      {/* 최근 검색 */}
      {recent.length > 0 && (
        <div className="px-5 pt-5">
          <div className="mb-2.5 flex items-baseline justify-between">
            <h2 className="text-[14px] font-extrabold text-ink">최근 검색</h2>
            <span className="text-[11.5px] text-ink-soft">전체 삭제</span>
          </div>
          <div className="flex flex-wrap gap-2">
            {recent.map((k) => (
              <button
                key={k}
                onClick={() => onPick(k)}
                className="tap flex items-center gap-1.5 rounded-full border border-line bg-white px-3.5 py-1.5 text-[12.5px] font-semibold text-ink"
              >
                {k}
              </button>
            ))}
          </div>
        </div>
      )}

      {/* 실시간 인기 검색어 — 순위 리스트 */}
      <div className="px-5 pt-7">
        <h2 className="mb-3 text-[14px] font-extrabold text-ink">실시간 인기 검색어</h2>
        <div className="overflow-hidden rounded-2xl border border-line-soft bg-white">
          {trending.map((it, idx) => (
            <button
              key={it.keyword}
              onClick={() => onPick(it.keyword)}
              className="tap flex w-full items-center gap-3.5 border-b border-line-soft px-4 py-2.5 last:border-b-0"
            >
              <span
                className={
                  'w-4 text-[14px] font-extrabold tabular ' + (idx < 3 ? 'text-hot' : 'text-ink-mid')
                }
              >
                {idx + 1}
              </span>
              <span className="flex-1 text-left text-[13.5px] font-semibold text-ink">{it.keyword}</span>
            </button>
          ))}
        </div>
      </div>
    </div>
  );
}

// ── 검색 후: 식재료 · 레시피 · 릴스 ────────────────────────
function SearchResults({ data, q, onNavigate }) {
  const { ingredients = [], recipes = [], reels = [], ingredientCount, recipeCount, reelCount } = data;
  const total = (ingredientCount ?? 0) + (recipeCount ?? 0) + (reelCount ?? 0);

  if (total === 0) {
    return (
      <EmptyState
        title={`'${q}' 검색 결과가 없어요`}
        description="다른 키워드로 검색하거나 인기 검색어를 눌러보세요."
      />
    );
  }

  return (
    <div className="animate-fade-up">
      {/* 결과 요약 */}
      <p className="px-5 pt-3 text-[12.5px] font-semibold text-ink-soft">
        식재료 {ingredientCount} · 레시피 {recipeCount} · 릴스 {reelCount}
      </p>

      {/* 식재료 */}
      {ingredients.length > 0 && (
        <div className="pt-4">
          <SectionHeader title="식재료" count={ingredientCount} />
          <div className="mx-4 overflow-hidden rounded-2xl border border-line-soft bg-white">
            {ingredients.slice(0, 4).map((i, idx, arr) => (
              <IngredientRow key={i.id} ingredient={i} divider={idx < arr.length - 1} />
            ))}
          </div>
          {ingredientCount > 4 && (
            <MoreButton label="식재료 더보기" href={`/info?tab=ingredient&q=${encodeURIComponent(q)}`} />
          )}
        </div>
      )}

      {/* 레시피 */}
      {recipes.length > 0 && (
        <>
          <SectionDivider />
          <div className="pt-4">
            <SectionHeader title="레시피" count={recipeCount} />
            <div className="mx-4 overflow-hidden rounded-2xl border border-line-soft bg-white">
              {recipes.slice(0, 4).map((r, idx, arr) => (
                <RecipeRow key={r.id} recipe={r} divider={idx < arr.length - 1} />
              ))}
            </div>
            {recipeCount > 4 && (
              <MoreButton label="레시피 더보기" href={`/info?tab=recipe&q=${encodeURIComponent(q)}`} />
            )}
          </div>
        </>
      )}

      {/* 릴스 */}
      {reels.length > 0 && (
        <>
          <SectionDivider />
          <div className="pt-4">
            <SectionHeader title="릴스" count={reelCount} />
            <div className="flex gap-3 overflow-x-auto phone-scroll px-4 pb-1">
              {reels.map((r) => (
                <ReelThumb key={r.id} reel={r} />
              ))}
            </div>
          </div>
        </>
      )}
    </div>
  );
}

export default function SearchPage() {
  return (
    <Suspense fallback={<LoadingScreen />}>
      <SearchInner />
    </Suspense>
  );
}

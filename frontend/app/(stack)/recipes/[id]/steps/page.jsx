'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { ArrowLeft, ArrowRight, Clock } from 'lucide-react';
import { useRecipeSteps, useRecipe } from '@/lib/queries';
import { AppHeader, BottomBar } from '@/components/layout';
import { Button } from '@/components/ui/Button';
import { Chip } from '@/components/ui/Chip';
import { LoadingScreen } from '@/components/ui/Spinner';
import { ErrorState, EmptyState } from '@/components/ui/States';
import { useToast } from '@/components/ui/Toast';
import { cn } from '@/lib/cn';

export default function RecipeStepsPage({ params }) {
  const id = params.id;
  const router = useRouter();
  const toast = useToast();
  const { data: steps, isLoading, error, refetch } = useRecipeSteps(id);
  const { data: recipe } = useRecipe(id);
  const [current, setCurrent] = useState(0);

  if (isLoading) {
    return (
      <>
        <AppHeader title="조리 순서" back />
        <LoadingScreen />
      </>
    );
  }

  if (error) {
    return (
      <>
        <AppHeader title="조리 순서" back />
        <ErrorState onRetry={refetch} />
      </>
    );
  }

  if (!steps || steps.length === 0) {
    return (
      <>
        <AppHeader title="조리 순서" back />
        <EmptyState title="조리 순서가 없어요" description="아직 등록된 조리 순서가 없습니다." />
      </>
    );
  }

  const total = steps.length;
  const step = steps[current];
  const isLast = current === total - 1;

  const goPrev = () => setCurrent((c) => Math.max(0, c - 1));
  const goNext = () => {
    if (isLast) {
      toast.show('맛있게 드세요!', { type: 'success' });
      router.push(`/recipes/${id}`);
      return;
    }
    setCurrent((c) => Math.min(total - 1, c + 1));
  };

  return (
    <>
      <AppHeader
        title="조리 순서"
        back
        right={
          <Chip tone="neutral" className="px-2.5 py-1 text-[12px] font-bold tabular-nums">
            {current + 1} / {total}
          </Chip>
        }
      />

      <div className="pb-6">
        {recipe?.title && (
          <p className="px-5 pt-3 text-[13px] font-semibold text-ink-soft">{recipe.title}</p>
        )}

        {/* 진행 바 */}
        <div className="px-5 pt-2">
          <div className="flex gap-1">
            {steps.map((s, i) => (
              <button
                key={s.order ?? i}
                onClick={() => setCurrent(i)}
                aria-label={`${i + 1}번째 단계`}
                className="tap h-1.5 flex-1 rounded-full"
              >
                <span
                  className={cn(
                    'block h-full w-full rounded-full transition-colors',
                    i <= current ? 'bg-brand' : 'bg-line-soft',
                  )}
                />
              </button>
            ))}
          </div>
        </div>

        {/* 큰 스텝 번호 + 제목 */}
        <div className="px-5 pt-4">
          <div className="text-[11px] font-extrabold tracking-widest text-brand">
            STEP {String(current + 1).padStart(2, '0')}
          </div>
          <h2 className="mt-1 text-[24px] font-extrabold leading-tight tracking-tight text-ink">
            {`${current + 1}단계`}
          </h2>
        </div>

        {/* 이미지 + 타이머 칩 */}
        {step.imageUrl && (
          <div className="px-4 pt-4">
            <div className="relative aspect-[4/3] w-full overflow-hidden rounded-2xl bg-surface-soft">
              <img src={step.imageUrl} alt={`${current + 1}단계`} className="h-full w-full object-cover" />
              {step.timerMinutes ? (
                <div className="absolute right-3 top-3 flex items-center gap-1.5 rounded-full bg-black/70 px-3 py-1.5 text-[12px] font-bold text-white backdrop-blur tabular-nums">
                  <Clock size={13} />
                  {step.timerMinutes}분
                </div>
              ) : null}
            </div>
          </div>
        )}

        {/* 본문 텍스트 */}
        <div className="px-6 pt-5">
          <p className="text-[15px] font-medium leading-relaxed text-ink">{step.text}</p>

          {!step.imageUrl && step.timerMinutes ? (
            <div className="mt-4 inline-flex items-center gap-1.5 rounded-full bg-brand-bg px-3 py-1.5 text-[12.5px] font-bold text-brand-dark tabular-nums">
              <Clock size={14} />
              타이머 {step.timerMinutes}분
            </div>
          ) : null}
        </div>
      </div>

      <BottomBar>
        <Button
          variant="outline"
          size="lg"
          onClick={goPrev}
          disabled={current === 0}
          className="shrink-0 !px-4"
        >
          <ArrowLeft size={18} className="mr-1" />
          이전
        </Button>
        <Button variant="primary" size="lg" block onClick={goNext}>
          {isLast ? (
            '완료'
          ) : (
            <>
              다음
              <ArrowRight size={18} className="ml-1" />
            </>
          )}
        </Button>
      </BottomBar>
    </>
  );
}

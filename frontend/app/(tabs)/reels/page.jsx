'use client';

import { Suspense, useEffect, useMemo, useRef, useState } from 'react';
import Link from 'next/link';
import { useSearchParams } from 'next/navigation';
import { Heart, MessageCircle, Bookmark, Share2, Play, ChevronRight, Plus } from 'lucide-react';
import { useReels } from '@/lib/queries';
import { AppHeader } from '@/components/layout';
import { LoadingScreen } from '@/components/ui/Spinner';
import { ErrorState, EmptyState } from '@/components/ui/States';
import { useToast } from '@/components/ui/Toast';
import { compact } from '@/lib/format';
import { cn } from '@/lib/cn';

export default function ReelsPage() {
  return (
    <Suspense fallback={<LoadingScreen />}>
      <ReelsInner />
    </Suspense>
  );
}

function ReelsInner() {
  const params = useSearchParams();
  const targetId = params.get('id');
  const { data: reels = [], isLoading, error, refetch } = useReels();
  const scrollerRef = useRef(null);

  // ?id= 로 진입 시 해당 릴로 점프
  useEffect(() => {
    if (!targetId || !reels.length) return;
    const el = scrollerRef.current?.querySelector(`[data-reel-id="${targetId}"]`);
    if (el) el.scrollIntoView({ block: 'start' });
  }, [targetId, reels.length]);

  return (
    <>
      <AppHeader title="릴스" transparent center />

      {isLoading && <LoadingScreen />}
      {error && <ErrorState onRetry={refetch} />}
      {!isLoading && !error && reels.length === 0 && (
        <EmptyState title="아직 릴스가 없어요" description="제철 레시피 숏폼이 곧 채워질 거예요." />
      )}

      {reels.length > 0 && (
        // 헤더(투명)가 위에 겹치도록 -mt 로 끌어올린 풀블리드 세로 피드.
        <div
          ref={scrollerRef}
          className="-mt-14 min-h-0 flex-1 snap-y snap-mandatory overflow-y-auto bg-black phone-scroll"
        >
          {reels.map((reel) => (
            <ReelItem key={reel.id} reel={reel} />
          ))}
        </div>
      )}
    </>
  );
}

function ReelItem({ reel }) {
  const toast = useToast();
  const [liked, setLiked] = useState(false);
  const [saved, setSaved] = useState(false);

  // 좋아요/저장 로컬 옵티미스틱 토글 + 카운트 보정
  const likeCount = useMemo(() => (reel.likes ?? 0) + (liked ? 1 : 0), [reel.likes, liked]);
  const saveCount = useMemo(() => (reel.saves ?? 0) + (saved ? 1 : 0), [reel.saves, saved]);

  const onShare = () => toast.show('링크를 복사했어요');

  return (
    <section
      data-reel-id={reel.id}
      className="relative h-full w-full shrink-0 snap-start overflow-hidden bg-black"
    >
      {/* 풀블리드 썸네일 + 다크 그라데이션 */}
      {reel.thumbnailUrl && (
        <img src={reel.thumbnailUrl} alt={reel.title} className="absolute inset-0 h-full w-full object-cover" />
      )}
      <div className="absolute inset-0 bg-gradient-to-b from-black/35 via-black/10 to-black/65" />

      {/* 중앙 재생 인디케이터 */}
      <div className="absolute left-1/2 top-1/2 grid h-16 w-16 -translate-x-1/2 -translate-y-1/2 place-items-center rounded-full bg-white/15 backdrop-blur-xl">
        <Play size={24} className="fill-white text-white" />
      </div>

      {/* 우측 액션 레일 */}
      <div className="absolute bottom-28 right-3 z-[5] flex flex-col items-center gap-[18px]">
        {/* 크리에이터 아바타 + 팔로우 */}
        <div className="relative mb-1">
          <div className="h-11 w-11 overflow-hidden rounded-full border-2 border-white bg-ink">
            {reel.creatorAvatar && (
              <img src={reel.creatorAvatar} alt={reel.creatorName} className="h-full w-full object-cover" />
            )}
          </div>
          <span className="absolute -bottom-1.5 left-1/2 grid h-5 w-5 -translate-x-1/2 place-items-center rounded-full border-2 border-black bg-brand">
            <Plus size={12} className="text-white" strokeWidth={3} />
          </span>
        </div>

        <RailAction icon={Heart} count={likeCount} active={liked} activeClass="fill-hot text-hot" onClick={() => setLiked((v) => !v)} />
        <RailAction icon={MessageCircle} count={reel.comments} />
        <RailAction icon={Bookmark} count={saveCount} active={saved} activeClass="fill-white text-white" onClick={() => setSaved((v) => !v)} />
        <RailAction icon={Share2} label="공유" onClick={onShare} />
      </div>

      {/* 좌하단 정보 */}
      <div className="absolute bottom-4 left-4 right-[76px] z-[5] text-white">
        <div className="mb-2 flex items-center gap-2">
          <span className="text-[14px] font-extrabold">@{reel.creatorName}</span>
          <button
            onClick={() => toast.show('팔로우했어요', { type: 'success' })}
            className="tap rounded-full border-[1.2px] border-white px-2.5 py-[3px] text-[11px] font-extrabold"
          >
            팔로우
          </button>
        </div>

        <p className="text-[14.5px] font-bold leading-snug tracking-tight">{reel.caption || reel.title}</p>

        <p className="mt-1 text-[12px] font-medium text-white/85">
          {(reel.ingredients || []).map((ing) => `#${ing}`).join(' ')}
          {reel.views != null && <span> · {compact(reel.views)} 조회</span>}
        </p>

        {/* 재료 칩 — 식재료 상세로 */}
        {reel.ingredients?.length > 0 && (
          <div className="mt-2.5 flex flex-wrap gap-1.5">
            {reel.ingredients.map((ing) => (
              <Link
                key={ing}
                href={`/search?q=${encodeURIComponent(ing)}`}
                className="tap inline-flex items-center gap-1.5 rounded-full border border-white/25 bg-white/15 py-1.5 pl-3 pr-2 backdrop-blur-xl"
              >
                <span className="text-[12px] font-bold text-white">{ing}</span>
                <ChevronRight size={11} className="text-white/80" />
              </Link>
            ))}
          </div>
        )}

        {/* 레시피 보기 핀 */}
        {reel.recipeId && (
          <Link
            href={`/recipes/${reel.recipeId}`}
            className="tap mt-3 inline-flex items-center gap-1.5 rounded-full bg-white px-4 py-2 text-[13px] font-extrabold text-ink"
          >
            레시피 보기
            <ChevronRight size={15} className="text-ink" />
          </Link>
        )}
      </div>
    </section>
  );
}

function RailAction({ icon: Icon, count, label, active, activeClass, onClick }) {
  return (
    <button onClick={onClick} className="tap flex flex-col items-center gap-1">
      <span className="grid h-[42px] w-[42px] place-items-center rounded-full bg-white/12 backdrop-blur">
        <Icon size={22} className={cn('text-white', active && activeClass)} />
      </span>
      <span className="text-[10.5px] font-bold text-white">{count != null ? compact(count) : label}</span>
    </button>
  );
}

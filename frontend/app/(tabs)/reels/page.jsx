'use client';

import { Suspense, useEffect, useRef, useState } from 'react';
import Link from 'next/link';
import { useRouter, useSearchParams } from 'next/navigation';
import { Heart, MessageCircle, Bookmark, Share2, Play, ChevronRight, Search, Send } from 'lucide-react';
import { useReels, useReelComments, useLikeReel, useSaveReel, useCommentReel } from '@/lib/queries';
import { useAuth } from '@/lib/auth';
import { AppHeader, HeaderIconButton } from '@/components/layout';
import { Sheet } from '@/components/ui/Sheet';
import { LoadingScreen } from '@/components/ui/Spinner';
import { ErrorState, EmptyState } from '@/components/ui/States';
import { useToast } from '@/components/ui/Toast';
import { compact, relativeTime } from '@/lib/format';
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
  // 댓글 시트는 피드 전체에 하나만 둔다. 탭한 릴을 담아 열고, 닫는 동안 exit 애니메이션을 위해 reel 은 유지한다.
  const [commentReel, setCommentReel] = useState(null);
  const [commentsOpen, setCommentsOpen] = useState(false);

  // ?id= 로 진입 시 해당 릴로 점프
  useEffect(() => {
    if (!targetId || !reels.length) return;
    const el = scrollerRef.current?.querySelector(`[data-reel-id="${targetId}"]`);
    if (el) el.scrollIntoView({ block: 'start' });
  }, [targetId, reels.length]);

  return (
    <>
      <AppHeader
        title="릴스"
        transparent
        center
        right={<HeaderIconButton icon={Search} href="/search" label="검색" transparent />}
      />

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
            <ReelItem
              key={reel.id}
              reel={reel}
              onOpenComments={() => {
                setCommentReel(reel);
                setCommentsOpen(true);
              }}
            />
          ))}
        </div>
      )}

      <CommentsSheet reel={commentReel} open={commentsOpen} onClose={() => setCommentsOpen(false)} />
    </>
  );
}

function ReelItem({ reel, onOpenComments }) {
  const router = useRouter();
  const toast = useToast();
  const { isAuthenticated } = useAuth();
  const likeReel = useLikeReel(reel.id);
  const saveReel = useSaveReel(reel.id);
  const videoRef = useRef(null);
  const [playing, setPlaying] = useState(false);

  // 서버가 내려준 내 상태(liked/saved)를 기준으로 낙관적 토글한다.
  const serverLiked = !!reel.liked;
  const serverSaved = !!reel.saved;
  const [liked, setLiked] = useState(serverLiked);
  const [saved, setSaved] = useState(serverSaved);

  // 표시 카운트 = 서버 카운트 + (로컬 토글이 서버 상태와 다르면 ±1)
  const likeCount = (reel.likes ?? 0) + (liked === serverLiked ? 0 : liked ? 1 : -1);
  const saveCount = (reel.saves ?? 0) + (saved === serverSaved ? 0 : saved ? 1 : -1);

  // 좋아요·저장은 로그인 필요 — 비로그인 시 로그인 유도 후 중단(FavoriteHeart와 동일 동작)
  const requireAuth = () => {
    if (isAuthenticated) return true;
    toast.show('로그인이 필요해요', { type: 'error' });
    const back = typeof window !== 'undefined' ? window.location.pathname + window.location.search : '/reels';
    router.push('/login?next=' + encodeURIComponent(back));
    return false;
  };
  const onLike = () => {
    if (!requireAuth()) return;
    const next = !liked;
    setLiked(next); // 낙관적 토글
    likeReel.mutate(next, {
      onError: () => {
        setLiked(!next);
        toast.show('잠시 후 다시 시도해 주세요', { type: 'error' });
      },
    });
  };
  const onSave = () => {
    if (!requireAuth()) return;
    const next = !saved;
    setSaved(next); // 낙관적 토글
    saveReel.mutate(next, {
      onSuccess: () => toast.show(next ? '저장했어요' : '저장을 해제했어요', { type: 'success' }),
      onError: () => {
        setSaved(!next);
        toast.show('잠시 후 다시 시도해 주세요', { type: 'error' });
      },
    });
  };

  // 세로 피드라 화면에 보이는 릴만 재생 (스크롤 이탈 시 일시정지)
  useEffect(() => {
    const video = videoRef.current;
    if (!video) return;
    const io = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) video.play().catch(() => {});
        else video.pause();
      },
      { threshold: 0.6 },
    );
    io.observe(video);
    return () => io.disconnect();
  }, []);

  // 탭하여 재생/일시정지 토글
  const togglePlay = () => {
    const video = videoRef.current;
    if (!video) return;
    if (video.paused) video.play().catch(() => {});
    else video.pause();
  };

  const onShare = () => toast.show('링크를 복사했어요');

  return (
    <section
      data-reel-id={reel.id}
      className="relative h-full w-full shrink-0 snap-start overflow-hidden bg-black"
    >
      {/* 풀블리드 영상(없으면 썸네일) + 다크 그라데이션 */}
      {reel.videoUrl ? (
        <video
          ref={videoRef}
          src={reel.videoUrl}
          poster={reel.thumbnailUrl || undefined}
          className="absolute inset-0 h-full w-full object-cover"
          playsInline
          muted
          loop
          preload="metadata"
          onClick={togglePlay}
          onPlay={() => setPlaying(true)}
          onPause={() => setPlaying(false)}
        />
      ) : (
        reel.thumbnailUrl && (
          <img src={reel.thumbnailUrl} alt={reel.title} className="absolute inset-0 h-full w-full object-cover" />
        )
      )}
      <div className="pointer-events-none absolute inset-0 bg-gradient-to-b from-black/35 via-black/10 to-black/65" />

      {/* 중앙 재생 인디케이터 — 일시정지 상태에서만 표시 */}
      {!playing && (
        <div className="pointer-events-none absolute left-1/2 top-1/2 grid h-16 w-16 -translate-x-1/2 -translate-y-1/2 place-items-center rounded-full bg-white/15 backdrop-blur-xl">
          <Play size={24} className="fill-white text-white" />
        </div>
      )}

      {/* 우측 액션 레일 */}
      <div className="absolute bottom-28 right-3 z-[5] flex flex-col items-center gap-[18px]">
        {/* 크리에이터 아바타 */}
        <div className="relative mb-1">
          <div className="h-11 w-11 overflow-hidden rounded-full border-2 border-white bg-ink">
            {reel.creatorAvatar && (
              <img src={reel.creatorAvatar} alt={reel.creatorName} className="h-full w-full object-cover" />
            )}
          </div>
        </div>

        <RailAction icon={Heart} count={likeCount} active={liked} activeClass="fill-hot text-hot" onClick={onLike} />
        <RailAction icon={MessageCircle} count={reel.comments} onClick={onOpenComments} />
        <RailAction icon={Bookmark} count={saveCount} active={saved} activeClass="fill-white text-white" onClick={onSave} />
        <RailAction icon={Share2} label="공유" onClick={onShare} />
      </div>

      {/* 좌하단 정보 */}
      <div className="absolute bottom-4 left-4 right-[76px] z-[5] text-white">
        <div className="mb-2 flex items-center gap-2">
          <span className="text-[14px] font-extrabold">@{reel.creatorName}</span>
        </div>

        <p className="text-[14.5px] font-bold leading-snug tracking-tight">{reel.caption || reel.title}</p>

        <p className="mt-1 text-[12px] font-medium text-white/85">
          {(reel.ingredients || []).map((ing) => `#${ing}`).join(' ')}
          {reel.views != null && <span> · {compact(reel.views)} 조회</span>}
        </p>

        {/* 재료 칩 — 카탈로그 매칭 시 식재료 상세로 바로, 아니면 검색 폴백 */}
        {(reel.ingredientRefs?.length > 0 || reel.ingredients?.length > 0) && (
          <div className="mt-2.5 flex flex-wrap gap-1.5">
            {(reel.ingredientRefs || reel.ingredients.map((name) => ({ id: null, name }))).map((ing) => (
              <Link
                key={ing.name}
                href={ing.id != null ? `/ingredients/${ing.id}` : `/search?q=${encodeURIComponent(ing.name)}`}
                className="tap inline-flex items-center gap-1.5 rounded-full border border-white/25 bg-white/15 py-1.5 pl-3 pr-2 backdrop-blur-xl"
              >
                <span className="text-[12px] font-bold text-white">{ing.name}</span>
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

// 릴스 댓글 바텀시트 — 목록 조회 + 작성. 작성자 프로필(아바타·닉네임)을 함께 보여준다.
function CommentsSheet({ reel, open, onClose }) {
  const router = useRouter();
  const toast = useToast();
  const { isAuthenticated } = useAuth();
  const reelId = reel?.id;
  // 열렸을 때만 조회한다(닫혀 있으면 id=undefined → 비활성화).
  const { data: comments = [], isLoading } = useReelComments(open ? reelId : undefined);
  const commentMut = useCommentReel(reelId);
  const [text, setText] = useState('');

  const submit = (e) => {
    e.preventDefault();
    const content = text.trim();
    if (!content || commentMut.isPending) return;
    if (!isAuthenticated) {
      toast.show('로그인이 필요해요', { type: 'error' });
      const back = typeof window !== 'undefined' ? window.location.pathname + window.location.search : '/reels';
      router.push('/login?next=' + encodeURIComponent(back));
      return;
    }
    commentMut.mutate(content, {
      onSuccess: () => setText(''),
      onError: () => toast.show('댓글을 등록하지 못했어요', { type: 'error' }),
    });
  };

  return (
    <Sheet open={open} onClose={onClose} title={`댓글 ${comments.length || ''}`.trim()} className="h-[72dvh] !pb-0">
      {/* 댓글 목록 — 이 영역만 스크롤 */}
      <div className="min-h-0 flex-1 space-y-5 overflow-y-auto phone-scroll pb-3 pt-1">
        {isLoading && <p className="py-8 text-center text-[13px] text-ink-soft">댓글을 불러오는 중…</p>}
        {!isLoading && comments.length === 0 && (
          <p className="py-10 text-center text-[13px] text-ink-soft">아직 댓글이 없어요. 첫 댓글을 남겨보세요!</p>
        )}
        {comments.map((c) => (
          <CommentRow key={c.id} comment={c} />
        ))}
      </div>

      {/* 입력 — 시트 하단 고정(스크롤 영역 밖). 위로 댓글이 비치지 않는다. */}
      <form
        onSubmit={submit}
        className="-mx-5 flex shrink-0 items-center gap-2 border-t border-line bg-white px-5 pb-[max(0.875rem,env(safe-area-inset-bottom))] pt-3"
      >
        <input
          value={text}
          onChange={(e) => setText(e.target.value)}
          placeholder={isAuthenticated ? '댓글 달기…' : '로그인하고 댓글 달기'}
          maxLength={1000}
          className="h-11 flex-1 rounded-full bg-surface-soft px-4 text-[14px] text-ink outline-none placeholder:text-ink-soft"
        />
        <button
          type="submit"
          disabled={!text.trim() || commentMut.isPending}
          aria-label="댓글 등록"
          className="tap grid h-11 w-11 shrink-0 place-items-center rounded-full bg-brand text-white transition disabled:opacity-40"
        >
          <Send size={18} />
        </button>
      </form>
    </Sheet>
  );
}

function CommentRow({ comment }) {
  const name = comment.nickname || comment.author || '익명';
  return (
    <div className="flex gap-3">
      <CommentAvatar src={comment.profileImageUrl} name={name} />
      <div className="min-w-0 flex-1">
        <div className="flex items-center gap-2">
          <span className="truncate text-[13px] font-extrabold text-ink">{name}</span>
          <span className="shrink-0 text-[11px] text-ink-soft">{relativeTime(comment.createdAt)}</span>
        </div>
        <p className="mt-0.5 whitespace-pre-wrap break-words text-[14px] leading-snug text-ink">
          {comment.content || comment.body}
        </p>
      </div>
    </div>
  );
}

function CommentAvatar({ src, name }) {
  return (
    <div className="grid h-9 w-9 shrink-0 place-items-center overflow-hidden rounded-full bg-line text-[13px] font-bold text-ink-mid">
      {src ? <img src={src} alt={name} className="h-full w-full object-cover" /> : <span>{(name || '?').slice(0, 1)}</span>}
    </div>
  );
}

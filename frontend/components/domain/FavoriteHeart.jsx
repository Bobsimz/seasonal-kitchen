'use client';

import { useRouter } from 'next/navigation';
import { Heart } from 'lucide-react';
import { useFavorites, useToggleFavorite } from '@/lib/queries';
import { useAuth } from '@/lib/auth';
import { useToast } from '@/components/ui/Toast';
import { cn } from '@/lib/cn';

// 찜(즐겨찾기) 토글 하트 — 기존 /favorites(useToggleFavorite) 재사용.
// 비로그인 시 로그인 유도, 성공/실패 토스트, 진행 중 비활성화.
// 카드처럼 <Link> 내부에서 쓸 때 클릭이 네비게이션으로 새지 않도록 기본 stop=true.
//   className     : 버튼(터치 영역) 스타일
//   iconClassName : 평소 하트 색
//   fillClassName : 찜 상태(채워진) 하트 색
//   nextHref      : 비로그인 시 로그인 후 돌아올 경로
export function FavoriteHeart({
  targetType = 'INGREDIENT',
  targetId,
  size = 20,
  className,
  iconClassName,
  fillClassName = 'fill-hot text-hot',
  nextHref,
  stop = true,
}) {
  const router = useRouter();
  const toast = useToast();
  const { isAuthenticated } = useAuth();
  const { data: favorites = [] } = useFavorites();
  const toggleFavorite = useToggleFavorite();

  const fav = favorites.find(
    (f) => f.targetType === targetType && Number(f.targetId) === Number(targetId),
  );
  const isFav = !!fav;

  const onClick = (e) => {
    if (stop) {
      e.preventDefault();
      e.stopPropagation();
    }
    if (!isAuthenticated) {
      toast.show('로그인이 필요해요', { type: 'error' });
      const back = nextHref || (typeof window !== 'undefined' ? window.location.pathname : '/');
      router.push('/login?next=' + encodeURIComponent(back));
      return;
    }
    toggleFavorite.mutate(
      isFav
        ? { action: 'remove', favoriteId: fav.id }
        : { action: 'add', targetType, targetId },
      {
        onSuccess: () => toast.show(isFav ? '찜을 해제했어요' : '찜했어요', { type: 'success' }),
        onError: () => toast.show('잠시 후 다시 시도해 주세요', { type: 'error' }),
      },
    );
  };

  return (
    <button
      type="button"
      onClick={onClick}
      disabled={toggleFavorite.isPending}
      aria-label={isFav ? '찜 해제' : '찜하기'}
      aria-pressed={isFav}
      className={cn('tap disabled:opacity-50', className)}
    >
      <Heart size={size} className={cn(iconClassName, isFav && fillClassName)} />
    </button>
  );
}

'use client';

import { useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { Heart, ChevronRight, Carrot, ChefHat, Sprout } from 'lucide-react';
import { useFavorites, useToggleFavorite } from '@/lib/queries';
import { useAuth } from '@/lib/auth';
import { AppHeader } from '@/components/layout';
import { Button } from '@/components/ui/Button';
import { SegmentedToggle } from '@/components/ui/SegmentedToggle';
import { LoadingScreen } from '@/components/ui/Spinner';
import { ErrorState, EmptyState } from '@/components/ui/States';
import { useToast } from '@/components/ui/Toast';
import { cn } from '@/lib/cn';

// 찜 항목은 id 만 갖고 있어(상세 데이터는 없음) 타입별 메타로 단순 행을 렌더한다.
const TYPE_META = {
  INGREDIENT: { label: '식재료', icon: Carrot, href: (id) => `/ingredients/${id}`, noun: '식재료' },
  RECIPE: { label: '레시피', icon: ChefHat, href: (id) => `/recipes/${id}`, noun: '레시피' },
  PRODUCER: { label: '농가', icon: Sprout, href: (id) => `/producers/${id}`, noun: '농가' },
};

const TABS = [
  { value: 'INGREDIENT', label: '식재료' },
  { value: 'RECIPE', label: '레시피' },
  { value: 'PRODUCER', label: '농가' },
];

export default function WishlistPage() {
  const [tab, setTab] = useState('INGREDIENT');
  const { data: favorites = [], isLoading, error, refetch } = useFavorites();

  const filtered = favorites.filter((f) => (f.targetType || '').toUpperCase() === tab);

  return (
    <>
      <AppHeader title="찜 목록" back />

      <div className="px-4 pb-2 pt-2">
        <SegmentedToggle options={TABS} value={tab} onChange={setTab} />
      </div>

      {isLoading && <LoadingScreen />}
      {error && <ErrorState onRetry={refetch} />}

      {!isLoading && !error && (
        <div className="animate-fade-up pb-6">
          {filtered.length === 0 ? (
            <EmptyTab tab={tab} />
          ) : (
            <div className="px-4 pt-3">
              <div className="overflow-hidden rounded-2xl border border-line-soft bg-white">
                {filtered.map((fav, i) => (
                  <FavoriteRow key={fav.id} favorite={fav} divider={i < filtered.length - 1} />
                ))}
              </div>
            </div>
          )}
        </div>
      )}
    </>
  );
}

function FavoriteRow({ favorite, divider }) {
  const router = useRouter();
  const toast = useToast();
  const { isAuthenticated } = useAuth();
  const toggle = useToggleFavorite();

  const meta = TYPE_META[(favorite.targetType || '').toUpperCase()] || TYPE_META.INGREDIENT;
  const Icon = meta.icon;

  const onRemove = (e) => {
    e.preventDefault();
    e.stopPropagation();
    if (!isAuthenticated) {
      toast.show('로그인이 필요해요', { type: 'error' });
      router.push('/login?next=/my/wishlist');
      return;
    }
    toggle.mutate(
      { action: 'remove', favoriteId: favorite.id },
      {
        onSuccess: () => toast.show('찜을 해제했어요'),
        onError: () => toast.show('잠시 후 다시 시도해 주세요', { type: 'error' }),
      },
    );
  };

  return (
    <Link
      href={meta.href(favorite.targetId)}
      className={cn('tap flex items-center gap-3 px-4 py-3', divider && 'border-b border-line-soft')}
    >
      <div className="flex h-12 w-12 shrink-0 items-center justify-center rounded-xl bg-brand-bg text-brand">
        <Icon size={22} />
      </div>
      <div className="min-w-0 flex-1">
        <p className="text-[14px] font-bold text-ink">
          {meta.label} <span className="text-ink-mid">#{favorite.targetId}</span>
        </p>
        <p className="mt-0.5 text-[11.5px] font-medium text-ink-soft">찜한 {meta.noun}</p>
      </div>
      <button
        onClick={onRemove}
        aria-label="찜 해제"
        disabled={toggle.isPending}
        className="tap -mr-1 flex h-9 w-9 items-center justify-center rounded-full text-hot disabled:opacity-50"
      >
        <Heart size={20} className="fill-current" />
      </button>
      <ChevronRight size={16} className="shrink-0 text-ink-soft/70" />
    </Link>
  );
}

function EmptyTab({ tab }) {
  const meta = TYPE_META[tab] || TYPE_META.INGREDIENT;
  const Icon = meta.icon;
  const ctaHref =
    tab === 'RECIPE' ? '/info?tab=recipe' : tab === 'PRODUCER' ? '/producers' : '/info';

  return (
    <EmptyState
      icon={<Icon size={40} />}
      title={`찜한 ${meta.noun}가 없어요`}
      description={`마음에 드는 ${meta.noun}을 하트로 찜해두면 여기 모여요.`}
      action={
        <Link href={ctaHref}>
          <Button variant="soft" size="sm">
            {meta.noun} 둘러보기
          </Button>
        </Link>
      }
    />
  );
}

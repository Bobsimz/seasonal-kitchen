'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import {
  ShoppingCart,
  Package,
  Heart,
  BellRing,
  Star,
  Bell,
  Store,
  Settings,
  ChevronRight,
  LogIn,
} from 'lucide-react';
import { useMySummary } from '@/lib/queries';
import { useAuth } from '@/lib/auth';
import { cn } from '@/lib/cn';
import { wonLabel } from '@/lib/format';
import { AppHeader, HeaderIconButton } from '@/components/layout';
import { Card, Section } from '@/components/ui/Card';
import { Button } from '@/components/ui/Button';
import { LoadingScreen } from '@/components/ui/Spinner';
import { ErrorState } from '@/components/ui/States';
import { IngredientCard } from '@/components/domain/IngredientCard';

export default function MyPage() {
  const { user: authUser, isAuthenticated, ready } = useAuth();
  const { data, isLoading, error, refetch } = useMySummary();

  // 비로그인 상태 — 통계 대신 로그인 유도 카드.
  const showLoginPrompt = ready && !isAuthenticated;

  return (
    <>
      <AppHeader
        title="마이페이지"
        right={<HeaderIconButton icon={ShoppingCart} href="/cart" label="장바구니" badge={3} />}
      />

      {isLoading && !showLoginPrompt && <LoadingScreen />}
      {error && !showLoginPrompt && <ErrorState onRetry={refetch} />}

      {(showLoginPrompt || data) && (
        <div className="animate-fade-up pb-6">
          {/* 프로필 블록 */}
          <ProfileBlock
            user={authUser || data?.user}
            authenticated={!showLoginPrompt}
          />

          {showLoginPrompt ? (
            <LoginPromptCard />
          ) : (
            data && (
              <>
                {/* 통계 카드 행 */}
                <StatsRow stats={data.stats} />

                {/* 메뉴 리스트 */}
                <MenuList counts={data.counts} />

                {/* 개인화 제철 추천 */}
                {data.personalized?.length > 0 && (
                  <Section title="민지님 맞춤 제철 추천">
                    <div className="flex gap-3 overflow-x-auto phone-scroll px-4 pb-1">
                      {data.personalized.map((i) => (
                        <IngredientCard key={i.id} ingredient={i} />
                      ))}
                    </div>
                  </Section>
                )}
              </>
            )
          )}
        </div>
      )}
    </>
  );
}

function ProfileBlock({ user, authenticated }) {
  const nickname = authenticated ? user?.nickname || '제철러버' : '로그인이 필요해요';
  const email = authenticated ? user?.email : '로그인하고 맞춤 추천을 받아보세요';
  const photoUrl = user?.photoUrl;

  return (
    <div className="flex items-center gap-3 px-4 pb-1 pt-1">
      {photoUrl ? (
        <img
          src={photoUrl}
          alt={nickname}
          className="h-[60px] w-[60px] rounded-full border-2 border-brand object-cover"
        />
      ) : (
        <div className="grid h-[60px] w-[60px] place-items-center rounded-full border-2 border-line bg-brand-bg text-[22px] font-extrabold text-brand-dark">
          {nickname.charAt(0)}
        </div>
      )}
      <div className="min-w-0 flex-1">
        <p className="text-[17px] font-extrabold tracking-tight text-ink">{nickname}</p>
        <p className="mt-0.5 truncate text-[12.5px] text-ink-soft">{email}</p>
      </div>
    </div>
  );
}

function LoginPromptCard() {
  const pathname = usePathname();
  const href = `/login?next=${encodeURIComponent(pathname || '/my')}`;
  return (
    <div className="px-4 pt-4">
      <Card className="flex flex-col items-center gap-3 p-6 text-center">
        <div className="grid h-12 w-12 place-items-center rounded-2xl bg-brand-bg text-brand-dark">
          <LogIn size={24} />
        </div>
        <div>
          <p className="text-[15px] font-bold text-ink">로그인하고 모두 이용하세요</p>
          <p className="mt-1 text-[13px] leading-relaxed text-ink-soft">
            절약액 · 주문 내역 · 찜 목록 · 가격 알림을
            <br />
            한곳에서 관리할 수 있어요.
          </p>
        </div>
        <Link href={href} className="w-full">
          <Button block size="lg" className="!mt-1">
            로그인 / 가입하기
          </Button>
        </Link>
      </Card>
    </div>
  );
}

function StatsRow({ stats }) {
  const items = [
    { value: wonLabel(stats?.savedAmount ?? 0), label: '절약액' },
    { value: `${stats?.orderCount ?? 0}`, label: '주문' },
    { value: `${stats?.reviewCount ?? 0}`, label: '리뷰' },
  ];
  return (
    <div className="mt-4 grid grid-cols-3 gap-2 px-4">
      {items.map((s) => (
        <div key={s.label} className="rounded-2xl bg-surface-soft px-2 py-3.5 text-center">
          <p className="text-[17px] font-extrabold tabular text-ink">{s.value}</p>
          <p className="mt-1 text-[11.5px] text-ink-soft">{s.label}</p>
        </div>
      ))}
    </div>
  );
}

function MenuList({ counts }) {
  const rows = [
    { icon: Package, label: '주문 내역', href: '/my/orders', count: counts?.orders },
    { icon: Heart, label: '찜 목록', href: '/my/wishlist', count: counts?.favorites },
    { icon: BellRing, label: '가격 알림', href: '/my/price-alerts', count: counts?.priceAlerts },
    { icon: Star, label: '내 리뷰', href: '/my/reviews', count: counts?.reviews },
    { icon: Bell, label: '알림', href: '/notifications' },
    { icon: Store, label: '판매자 센터', href: '/my/seller/dashboard' },
    { icon: Settings, label: '설정', href: '/my/settings' },
  ];
  return (
    <div className="mt-5 px-4">
      <Card className="overflow-hidden">
        {rows.map((r, i) => (
          <Link
            key={r.label}
            href={r.href}
            className={cn(
              'tap flex items-center gap-3 px-4 py-3.5',
              i < rows.length - 1 && 'border-b border-line-soft'
            )}
          >
            <div className="grid h-9 w-9 shrink-0 place-items-center rounded-xl bg-surface-soft text-ink-mid">
              <r.icon size={18} />
            </div>
            <span className="flex-1 text-[14.5px] font-semibold text-ink">{r.label}</span>
            {r.count != null && r.count > 0 && (
              <span className="text-[13px] font-bold tabular text-ink-soft">{r.count}</span>
            )}
            <ChevronRight size={16} className="text-ink-soft" />
          </Link>
        ))}
      </Card>
    </div>
  );
}

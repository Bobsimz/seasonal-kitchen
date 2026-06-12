'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { Home, LayoutList, Store, Play, User } from 'lucide-react';
import { cn } from '@/lib/cn';

// 하단 탭 — 홈 / 정보 / 상품(강조) / 릴스 / 마이.
// '상품'은 커머스 핵심 동선이라 가운데 띄움 버튼으로 강조합니다.
const TABS = [
  { href: '/', label: '홈', icon: Home, match: (p) => p === '/' || p.startsWith('/curation') || p.startsWith('/search') },
  { href: '/info', label: '정보', icon: LayoutList, match: (p) => p.startsWith('/info') || p.startsWith('/ingredients') || p.startsWith('/recipes') || p.startsWith('/producers') },
  { href: '/products', label: '상품', icon: Store, emphasis: true, match: (p) => p.startsWith('/products') || p.startsWith('/cart') || p.startsWith('/checkout') },
  { href: '/reels', label: '릴스', icon: Play, match: (p) => p.startsWith('/reels') },
  { href: '/my', label: '마이', icon: User, match: (p) => p.startsWith('/my') || p.startsWith('/orders') || p.startsWith('/notifications') },
];

export function BottomTabNav() {
  const pathname = usePathname() || '/';

  return (
    <nav className="relative z-50 flex shrink-0 items-stretch border-t border-line-soft bg-white/95 pb-[max(8px,env(safe-area-inset-bottom))] pt-2.5 backdrop-blur-xl shadow-nav">
      {TABS.map((tab) => {
        const active = tab.match(pathname);
        const Icon = tab.icon;

        if (tab.emphasis) {
          return (
            <Link key={tab.href} href={tab.href} className="tap flex flex-1 flex-col items-center justify-end gap-1">
              <span
                className={cn(
                  'grid h-12 w-12 -translate-y-4 place-items-center rounded-full border-[3px] border-white bg-gradient-to-br from-brand to-brand-dark text-white transition-shadow',
                  active ? 'shadow-[0_6px_16px_rgba(22,193,114,0.5)]' : 'shadow-[0_2px_6px_rgba(0,0,0,0.14)]',
                )}
              >
                <Icon size={22} strokeWidth={2.2} />
              </span>
              <span className={cn('-mt-2.5 text-[10.5px] font-bold', active ? 'text-brand-dark' : 'text-ink-soft')}>
                {tab.label}
              </span>
            </Link>
          );
        }

        return (
          <Link key={tab.href} href={tab.href} className="tap flex flex-1 flex-col items-center justify-center gap-1">
            <Icon size={22} strokeWidth={active ? 2.4 : 1.9} className={active ? 'text-brand' : 'text-ink-soft'} />
            <span className={cn('text-[10.5px]', active ? 'font-bold text-brand' : 'font-medium text-ink-soft')}>
              {tab.label}
            </span>
          </Link>
        );
      })}
    </nav>
  );
}

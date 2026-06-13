'use client';

import Link from 'next/link';
import { useEffect, useRef } from 'react';
import { Bell, Search, ShoppingCart } from 'lucide-react';
import { cn } from '@/lib/cn';

// 홈 전용 헤더.
// 최상단(히어로 위)에서는 배경 투명 + 글래스 원형 버튼(알림·검색·장바구니, 흰 아이콘)으로 떠 있고,
// 스크롤을 내리면 일반 헤더(흰 배경 + "제철식탁" + 같은 3버튼, 잉크 아이콘)로 "사사삭" 전환된다.
//
// 전환은 헤더 루트의 CSS 변수 `--p`(0→1, 스크롤 진행도) 하나로 구동한다.
// 스크롤 핸들러에서 --p 만 갱신하므로 무거운 홈 본문을 매 프레임 리렌더하지 않는다.
// 각 레이어는 inline style 의 calc() 로 --p 를 읽어 opacity 만 크로스페이드한다.
// floating=false(로딩/에러 등 히어로가 없을 때)면 투명 대신 일반 흰 헤더로 고정한다.
export function HomeHeader({ unreadCount = 0, cartCount = 0, floating = true }) {
  const headerRef = useRef(null);

  useEffect(() => {
    const header = headerRef.current;
    if (!header) return;
    // 히어로가 없으면(로딩/에러/빈 히어로) 흰 아이콘이 묻히므로 일반 헤더(--p=1)로 고정.
    if (!floating) {
      header.style.setProperty('--p', '1');
      return;
    }
    // 스크롤 컨테이너는 ScreenScroll(<main overflow-y-auto>). 헤더는 그 안의 sticky 자식.
    const scroller = header.closest('main') ?? header.parentElement;
    if (!scroller) return;

    const FADE_END = 180; // 이 픽셀만큼 내리면 일반 헤더로 완전히 전환
    let raf = 0;
    const apply = () => {
      raf = 0;
      const p = Math.min(1, Math.max(0, scroller.scrollTop / FADE_END));
      header.style.setProperty('--p', p.toFixed(3));
    };
    const onScroll = () => {
      if (!raf) raf = requestAnimationFrame(apply);
    };
    scroller.addEventListener('scroll', onScroll, { passive: true });
    apply(); // 진입 시 현재 스크롤 위치 반영(뒤로가기·새로고침 복원 대비)
    return () => {
      scroller.removeEventListener('scroll', onScroll);
      if (raf) cancelAnimationFrame(raf);
    };
  }, [floating]);

  return (
    <header
      ref={headerRef}
      // --p 초기값: floating 이면 0(투명), 아니면 1(흰 헤더). SSR/하이드레이션 전에도 calc 유효.
      style={{ '--p': floating ? 0 : 1 }}
      className="sticky top-0 z-30 flex min-h-14 items-center gap-1 px-2 sm:pt-3"
    >
      {/* 흰 배경 레이어 — 스크롤할수록 진해진다 */}
      <div
        aria-hidden
        className="absolute inset-0 border-b border-line-soft bg-white/95 backdrop-blur-xl"
        style={{ opacity: 'var(--p)' }}
      />

      {/* 제목 — 최상단에선 숨고, 스크롤하면 페이드 인 */}
      <span className="w-2" />
      <h1
        className="relative min-w-0 flex-1 truncate pl-2 text-[17px] font-extrabold tracking-tight text-ink"
        style={{ opacity: 'var(--p)' }}
      >
        <span className="font-display">제철식탁</span>
      </h1>

      {/* 우측 액션 — 알림·검색·장바구니 모두 글래스↔플랫으로 모핑 */}
      <div className="relative flex shrink-0 items-center gap-1.5 pr-1">
        <MorphIconButton href="/notifications" label="알림" icon={Bell} badge={unreadCount} />
        <MorphIconButton href="/search" label="검색" icon={Search} />
        <MorphIconButton href="/cart" label="장바구니" icon={ShoppingCart} badge={cartCount} />
      </div>
    </header>
  );
}

// 글래스 원형(흰 아이콘) ↔ 플랫(잉크 아이콘)으로 모핑되는 헤더 버튼.
function MorphIconButton({ href, label, icon: Icon, badge }) {
  return (
    <Link href={href} aria-label={label} className="tap relative grid h-10 w-10 place-items-center rounded-full">
      {/* 글래스 배경 — 최상단에서만 보이고 스크롤하면 사라진다 */}
      <span
        aria-hidden
        className="absolute inset-0 rounded-full border border-white/30 bg-white/20 backdrop-blur-md"
        style={{ opacity: 'calc(1 - var(--p))' }}
      />
      {/* 두 아이콘을 같은 칸에 겹쳐 두고 흰↔잉크로 크로스페이드 */}
      <span className="relative grid place-items-center">
        <Icon size={21} className="[grid-area:1/1] text-white" style={{ opacity: 'calc(1 - var(--p))' }} />
        <Icon size={21} className="[grid-area:1/1] text-ink" style={{ opacity: 'var(--p)' }} />
      </span>
      {badge ? (
        <span
          className={cn(
            'absolute right-1 top-1 grid h-4 min-w-4 place-items-center rounded-full',
            'border-[1.5px] border-white bg-hot px-1 text-[9px] font-bold text-white',
          )}
        >
          {badge > 99 ? '99+' : badge}
        </span>
      ) : null}
    </Link>
  );
}

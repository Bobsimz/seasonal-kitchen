'use client';

import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { useEffect, useRef, useState } from 'react';
import { ChevronLeft } from 'lucide-react';
import { cn } from '@/lib/cn';

// 인앱 상단 헤더 (sticky). 뒤로가기 + 제목 + 우측 액션 슬롯.
// transparent: 히어로 이미지 위에 얹을 때 (배경 투명 + 흰 텍스트).
// scrollAware: 투명 헤더가 스크롤 시 흰 배경 + 어두운 텍스트로 전환되며 상단에 고정.
//   right 를 함수 (scrolled) => JSX 로 주면 우측 슬롯 아이콘 색도 함께 전환할 수 있다.
export function AppHeader({ title, back = false, onBack, right, transparent = false, scrollAware = false, solidAt = 120, center = false, className }) {
  const router = useRouter();
  const handleBack = () => (onBack ? onBack() : router.back());

  const headerRef = useRef(null);
  const [scrolled, setScrolled] = useState(false);

  // 스크롤 컨테이너(ScreenScroll 의 <main>)의 스크롤 위치를 추적해 임계값을 넘으면 solid 로 전환.
  useEffect(() => {
    if (!scrollAware) return;
    const scroller = headerRef.current?.closest('main');
    if (!scroller) return;
    const onScroll = () => setScrolled(scroller.scrollTop > solidAt);
    onScroll();
    scroller.addEventListener('scroll', onScroll, { passive: true });
    return () => scroller.removeEventListener('scroll', onScroll);
  }, [scrollAware, solidAt]);

  // solid = 흰 배경 + 어두운 텍스트. (불투명 헤더이거나, scrollAware 헤더가 임계값을 넘은 경우)
  const solid = !transparent || (scrollAware && scrolled);

  return (
    <header
      ref={headerRef}
      className={cn(
        // 데스크탑(sm+)에서는 둥근 프레임 상단 코너에서 살짝 내려오도록 위쪽 패딩을 더한다.
        'sticky top-0 z-30 flex min-h-14 items-center gap-1 px-2 transition-colors duration-200 sm:pt-3',
        // 투명 헤더는 히어로 위에 얹히므로, 헤더 영역의 탭이 아래 콘텐츠(예: 찜 하트)로 통과되도록
        // 컨테이너는 pointer-events-none, 실제 버튼만 pointer-events-auto 로 되살린다.
        // solid 로 전환되면 헤더가 탭을 받아 아래로 통과되지 않게 한다.
        solid ? 'border-b border-line-soft bg-white/95 text-ink backdrop-blur-xl' : 'pointer-events-none bg-transparent text-white',
        className,
      )}
    >
      {back ? (
        <button onClick={handleBack} aria-label="뒤로" className="tap pointer-events-auto grid h-10 w-10 shrink-0 place-items-center">
          <ChevronLeft size={24} className={solid ? 'text-ink' : 'text-white'} />
        </button>
      ) : (
        <span className="w-2" />
      )}
      <h1
        className={cn(
          'min-w-0 flex-1 truncate text-[17px] font-extrabold tracking-tight',
          center && 'text-center',
          !back && !center && 'pl-2',
        )}
      >
        {title}
      </h1>
      {right && (
        <div className="pointer-events-auto flex shrink-0 items-center gap-0.5 pr-1">
          {typeof right === 'function' ? right(scrolled) : right}
        </div>
      )}
    </header>
  );
}

// 헤더 우측 아이콘 버튼 (배지 옵션). href 면 Link, 아니면 button.
export function HeaderIconButton({ icon: Icon, onClick, href, badge, label, transparent }) {
  const inner = (
    <>
      <Icon size={22} className={transparent ? 'text-white' : 'text-ink'} />
      {badge ? (
        <span className="absolute right-1.5 top-1.5 grid h-4 min-w-4 place-items-center rounded-full bg-hot px-1 text-[9px] font-bold text-white">
          {badge > 99 ? '99+' : badge}
        </span>
      ) : null}
    </>
  );
  const cls = 'tap relative grid h-10 w-10 place-items-center';
  if (href) {
    return (
      <Link href={href} aria-label={label} className={cls}>
        {inner}
      </Link>
    );
  }
  return (
    <button onClick={onClick} aria-label={label} className={cls}>
      {inner}
    </button>
  );
}

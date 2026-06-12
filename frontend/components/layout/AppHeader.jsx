'use client';

import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { ChevronLeft } from 'lucide-react';
import { cn } from '@/lib/cn';

// 인앱 상단 헤더 (sticky). 뒤로가기 + 제목 + 우측 액션 슬롯.
// transparent: 히어로 이미지 위에 얹을 때 (배경 투명 + 흰 텍스트).
export function AppHeader({ title, back = false, onBack, right, transparent = false, center = false, className }) {
  const router = useRouter();
  const handleBack = () => (onBack ? onBack() : router.back());

  return (
    <header
      className={cn(
        // 데스크탑(sm+)에서는 둥근 프레임 상단 코너에서 살짝 내려오도록 위쪽 패딩을 더한다.
        'sticky top-0 z-30 flex min-h-14 items-center gap-1 px-2 sm:pt-3',
        transparent ? 'bg-transparent text-white' : 'border-b border-line-soft bg-white/95 text-ink backdrop-blur-xl',
        className,
      )}
    >
      {back ? (
        <button onClick={handleBack} aria-label="뒤로" className="tap grid h-10 w-10 shrink-0 place-items-center">
          <ChevronLeft size={24} className={transparent ? 'text-white' : 'text-ink'} />
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
      {right && <div className="flex shrink-0 items-center gap-0.5 pr-1">{right}</div>}
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

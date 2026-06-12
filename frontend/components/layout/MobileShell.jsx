import { AmbientBackground } from './AmbientBackground';
import { cn } from '@/lib/cn';

// 앱 전체를 감싸는 "모바일 디바이스" 프레임.
// - 모바일 폭: 화면 꽉 채움 (full-bleed)
// - 데스크탑: 디자인된 배경 위에 가운데 정렬된 디바이스 카드로 표시
// children 은 세로 flex 컬럼을 채웁니다 (스크롤 영역 + 하단바는 각 레이아웃이 배치).
export function MobileShell({ children, className }) {
  return (
    <>
      <AmbientBackground />
      <div className="flex min-h-[100dvh] w-full justify-center sm:items-center">
        <div
          className={cn(
            'relative flex h-[100dvh] w-full max-w-phone flex-col overflow-hidden bg-surface',
            'sm:h-[min(880px,calc(100dvh-48px))] sm:rounded-[44px] sm:shadow-device',
            className,
          )}
        >
          {children}
        </div>
      </div>
    </>
  );
}

// 스크롤되는 본문 영역 — 헤더(sticky) + 콘텐츠를 담습니다.
export function ScreenScroll({ children, className }) {
  return <main className={cn('relative flex min-h-0 flex-1 flex-col overflow-y-auto phone-scroll', className)}>{children}</main>;
}

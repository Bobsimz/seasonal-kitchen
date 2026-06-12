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
            // [transform:translateZ(0)] 로 프레임을 fixed 자식들의 컨테이닝 블록으로 만든다.
            // → 데스크탑/태블릿에서 position:fixed 요소(판매 등록 FAB 등)가 뷰포트가 아닌
            //   이 폰 프레임 기준으로 고정되어 프레임 안에 머문다. (모바일에선 프레임=뷰포트라 무영향)
            'relative flex h-[100dvh] w-full max-w-phone flex-col overflow-hidden bg-surface [transform:translateZ(0)]',
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

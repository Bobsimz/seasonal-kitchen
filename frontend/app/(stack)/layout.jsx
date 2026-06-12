import { MobileShell, ScreenScroll } from '@/components/layout';

// 스택 그룹 레이아웃 — 탭바 없이 뒤로가기로 진입하는 상세/플로우 화면들.
// 하단 CTA(BottomBar)는 각 페이지가 직접 배치합니다.
export default function StackLayout({ children }) {
  return (
    <MobileShell>
      <ScreenScroll>{children}</ScreenScroll>
    </MobileShell>
  );
}

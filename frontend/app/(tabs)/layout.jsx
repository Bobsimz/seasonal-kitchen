import { MobileShell, ScreenScroll, BottomTabNav } from '@/components/layout';

// 탭 그룹 레이아웃 — 하단 탭바가 보이는 화면들 (홈/정보/상품/릴스/마이 + 목록형 하위 페이지).
export default function TabsLayout({ children }) {
  return (
    <MobileShell>
      <ScreenScroll>{children}</ScreenScroll>
      <BottomTabNav />
    </MobileShell>
  );
}

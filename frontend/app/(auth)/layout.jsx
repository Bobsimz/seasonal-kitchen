import { MobileShell, ScreenScroll } from '@/components/layout';

// 인증/온보딩 그룹 — 탭바·뒤로가기 없이 단독 플로우.
export default function AuthLayout({ children }) {
  return (
    <MobileShell>
      <ScreenScroll>{children}</ScreenScroll>
    </MobileShell>
  );
}

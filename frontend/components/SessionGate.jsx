'use client';

import { useEffect } from 'react';
import { usePathname, useRouter } from 'next/navigation';
import { AnimatePresence, motion } from 'framer-motion';
import { LogIn } from 'lucide-react';
import { useAuth } from '@/lib/auth';
import { Button } from '@/components/ui/Button';

// 로그인 화면에서는 띄우지 않는다(로그인 시도 실패 등은 폼이 처리, 리다이렉트 루프 방지).
const AUTH_ROUTES = ['/login', '/signup', '/onboarding'];

// 백엔드가 인증 호출에 401 을 돌려주면(토큰 만료/무효) 뜨는 전역 안내 모달.
// 강제 이동 대신 "로그인하기 / 나중에 할게요" 선택지를 준다.
// Toast 처럼 fixed inset-0 + mx-auto max-w-phone 로 폰 프레임 안에 정렬된다
// (Providers 가 MobileShell 바깥이라 Sheet 의 컨테이닝 블록 트릭을 못 써서 직접 정렬).
export function SessionGate() {
  const { sessionExpired, expiryReason, dismissSessionExpired } = useAuth();
  const router = useRouter();
  const pathname = usePathname();

  const onAuthRoute = AUTH_ROUTES.some((p) => pathname?.startsWith(p));
  const open = sessionExpired && !onAuthRoute;

  // ESC 로 닫기 (열려 있을 때만).
  useEffect(() => {
    if (!open) return undefined;
    const onKey = (e) => {
      if (e.key === 'Escape') dismissSessionExpired();
    };
    window.addEventListener('keydown', onKey);
    return () => window.removeEventListener('keydown', onKey);
  }, [open, dismissSessionExpired]);

  const goLogin = () => {
    const here =
      typeof window !== 'undefined'
        ? window.location.pathname + window.location.search
        : pathname || '/';
    dismissSessionExpired();
    router.push(`/login?next=${encodeURIComponent(here)}`);
  };

  const message =
    expiryReason === 'expired'
      ? '로그인 세션이 만료됐어요.\n다시 로그인하면 이어서 이용할 수 있어요.'
      : '이 기능은 로그인이 필요해요.\n로그인하고 계속 이용해 보세요.';

  return (
    <AnimatePresence>
      {open && (
        <div className="fixed inset-0 z-[210] mx-auto flex max-w-phone items-center justify-center px-8">
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            onClick={dismissSessionExpired}
            className="absolute inset-0 bg-black/40"
          />
          <motion.div
            role="dialog"
            aria-modal="true"
            aria-label="로그인이 필요해요"
            initial={{ opacity: 0, y: 12, scale: 0.96 }}
            animate={{ opacity: 1, y: 0, scale: 1 }}
            exit={{ opacity: 0, scale: 0.96 }}
            transition={{ type: 'spring', stiffness: 360, damping: 32 }}
            className="relative w-full rounded-3xl bg-white p-6 text-center shadow-float"
          >
            <div className="mx-auto grid h-12 w-12 place-items-center rounded-2xl bg-brand-bg text-brand-dark">
              <LogIn size={24} />
            </div>
            <h3 className="mt-4 text-[17px] font-extrabold tracking-tight text-ink">
              로그인이 필요해요
            </h3>
            <p className="mt-1.5 whitespace-pre-line text-[13.5px] leading-relaxed text-ink-soft">
              {message}
            </p>
            <Button block size="lg" className="!mt-5" onClick={goLogin}>
              로그인하기
            </Button>
            <button
              type="button"
              onClick={dismissSessionExpired}
              className="tap mt-2 py-1.5 text-[13px] font-semibold text-ink-soft"
            >
              나중에 할게요
            </button>
          </motion.div>
        </div>
      )}
    </AnimatePresence>
  );
}

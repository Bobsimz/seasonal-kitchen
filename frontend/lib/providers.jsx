'use client';

import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { useState } from 'react';
import { AuthProvider } from './auth';
import { ToastProvider } from '@/components/ui/Toast';
import { SessionGate } from '@/components/SessionGate';

// 앱 전역 프로바이더 묶음 — 루트 레이아웃에서 한 번만 감쌉니다.
export function Providers({ children }) {
  const [client] = useState(
    () =>
      new QueryClient({
        defaultOptions: {
          queries: {
            staleTime: 60_000,
            // 401(인증 만료/무효)은 재시도가 무의미하므로 즉시 처리한다.
            retry: (count, err) => err?.status !== 401 && count < 1,
            refetchOnWindowFocus: false,
            // 쿼리 실패는 전역 에러 경계(app/error.jsx)로 전파한다.
            // 단 401 은 onUnauthorized → SessionGate(로그인 모달)가 처리하므로 throw 하지 않는다.
            throwOnError: (err) => err?.status !== 401,
          },
        },
      }),
  );

  return (
    <QueryClientProvider client={client}>
      <AuthProvider>
        <ToastProvider>{children}</ToastProvider>
        <SessionGate />
      </AuthProvider>
    </QueryClientProvider>
  );
}

'use client';

// 앱 전역 에러 경계 — 렌더링/데이터 호출 중 던져진 에러를 잡아 보여줍니다.
// react-query 쿼리 실패는 providers 의 throwOnError(401 제외) 설정으로 이 경계까지 전파됩니다.

import { useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { MobileShell } from '@/components/layout';
import { EmptyState } from '@/components/ui/States';
import { Button } from '@/components/ui/Button';

export default function Error({ error, reset }) {
  const router = useRouter();

  useEffect(() => {
    // 운영 모니터링이 붙으면 여기서 보고. 지금은 콘솔에만 남긴다.
    console.error(error);
  }, [error]);

  return (
    <MobileShell>
      <div className="flex min-h-0 flex-1 flex-col items-center justify-center">
        <EmptyState
          icon={<span className="text-5xl">🥲</span>}
          title="문제가 발생했어요"
          description="잠시 후 다시 시도하거나 홈으로 돌아가 주세요."
          action={
            <div className="flex flex-col items-center gap-2">
              <Button variant="primary" size="md" onClick={() => reset()}>
                다시 시도
              </Button>
              <Button variant="ghost" size="sm" onClick={() => router.push('/')}>
                홈으로
              </Button>
            </div>
          }
        />
      </div>
    </MobileShell>
  );
}

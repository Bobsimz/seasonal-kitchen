'use client';

// 404 — 존재하지 않는 경로로 들어왔을 때 보여줍니다.

import { useRouter } from 'next/navigation';
import { MobileShell } from '@/components/layout';
import { EmptyState } from '@/components/ui/States';
import { Button } from '@/components/ui/Button';

export default function NotFound() {
  const router = useRouter();
  return (
    <MobileShell>
      <div className="flex min-h-0 flex-1 flex-col items-center justify-center">
        <EmptyState
          icon={<span className="text-5xl">🧺</span>}
          title="페이지를 찾을 수 없어요"
          description="주소가 바뀌었거나 사라진 페이지예요."
          action={
            <Button variant="primary" size="md" onClick={() => router.push('/')}>
              홈으로
            </Button>
          }
        />
      </div>
    </MobileShell>
  );
}

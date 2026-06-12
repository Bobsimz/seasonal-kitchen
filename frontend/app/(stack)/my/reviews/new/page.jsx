'use client';

import { Suspense, useEffect, useState } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import { Plus } from 'lucide-react';
import { useAuth } from '@/lib/auth';
import { useProducer, useCreateReview } from '@/lib/queries';
import { AppHeader, BottomBar } from '@/components/layout';
import { Button } from '@/components/ui/Button';
import { RatingStars } from '@/components/ui/Misc';
import { LoadingScreen } from '@/components/ui/Spinner';
import { useToast } from '@/components/ui/Toast';
import { ProducerAvatar } from '@/components/domain/ProducerCard';

function WriteReviewInner() {
  const router = useRouter();
  const params = useSearchParams();
  const producerId = params.get('producerId');
  const toast = useToast();
  const { isAuthenticated, ready } = useAuth();

  const { data: producer, isLoading } = useProducer(producerId);
  const createReview = useCreateReview();

  const [rating, setRating] = useState(5);
  const [item, setItem] = useState('');
  const [body, setBody] = useState('');

  // 대상 농가가 로드되면 구매 상품을 대표 품목으로 미리 채워줍니다.
  useEffect(() => {
    if (producer && !item) setItem(producer.specialties?.[0] || '');
  }, [producer]); // eslint-disable-line react-hooks/exhaustive-deps

  const onSubmit = async () => {
    if (ready && !isAuthenticated) {
      toast.show('로그인이 필요해요', { type: 'error' });
      router.push(`/login?next=/my/reviews/new?producerId=${producerId || ''}`);
      return;
    }
    if (!body.trim()) {
      toast.show('리뷰 내용을 입력해 주세요', { type: 'error' });
      return;
    }
    try {
      await createReview.mutateAsync({ producerId, rating, item: item.trim(), body: body.trim() });
      toast.show('리뷰가 등록되었어요', { type: 'success' });
      router.back();
    } catch {
      toast.show('등록에 실패했어요', { type: 'error' });
    }
  };

  if (isLoading) return <LoadingScreen />;

  return (
    <>
      <div className="animate-fade-up pb-28">
        {/* 대상 농가 */}
        {producer && (
          <div className="px-4 pt-3.5">
            <div className="flex items-center gap-3 rounded-2xl bg-surface-soft px-3.5 py-3">
              <ProducerAvatar producer={producer} size={44} />
              <div className="min-w-0">
                <p className="truncate text-[13.5px] font-extrabold text-ink">
                  {producer.region} {producer.name}
                </p>
                <p className="mt-0.5 truncate text-[11.5px] text-ink-soft">
                  {item || producer.specialties?.[0]} · 배송완료
                </p>
              </div>
            </div>
          </div>
        )}

        {/* 별점 */}
        <div className="px-4 pt-6 text-center">
          <p className="text-[13px] font-bold text-ink">농가는 어떠셨나요?</p>
          <div className="mt-3 flex justify-center">
            <RatingStars editable value={rating} onChange={setRating} size={34} className="gap-1.5" />
          </div>
        </div>

        {/* 구매한 상품 */}
        <div className="px-4 pt-6">
          <p className="mb-2 text-[12.5px] font-extrabold text-ink">구매한 상품</p>
          <input
            value={item}
            onChange={(e) => setItem(e.target.value)}
            placeholder="예: 봄동, 시금치"
            className="h-12 w-full rounded-2xl border border-line bg-surface-soft px-4 text-[14px] font-medium text-ink placeholder:text-ink-soft focus:border-brand focus:bg-white focus:outline-none focus:ring-2 focus:ring-brand/20"
          />
        </div>

        {/* 사진 첨부 (목업) */}
        <div className="px-4 pt-6">
          <p className="mb-2 text-[12.5px] font-extrabold text-ink">사진 첨부</p>
          <button
            type="button"
            onClick={() => toast.show('사진 첨부는 준비 중이에요')}
            className="tap grid h-20 w-20 place-items-center gap-1 rounded-2xl border-[1.5px] border-dashed border-line bg-surface-soft text-ink-soft"
          >
            <Plus size={20} />
            <span className="text-[10.5px] font-bold">0/5</span>
          </button>
        </div>

        {/* 상세 리뷰 */}
        <div className="px-4 pt-6">
          <p className="mb-2 text-[12.5px] font-extrabold text-ink">상세 리뷰</p>
          <textarea
            value={body}
            onChange={(e) => setBody(e.target.value)}
            placeholder="농가의 신선도, 맛, 포장, 배송 등 솔직한 후기를 남겨주세요."
            className="min-h-[120px] w-full resize-none rounded-xl border border-line bg-surface-soft px-3.5 py-3 text-[13.5px] leading-relaxed text-ink placeholder:text-ink-soft focus:border-brand focus:bg-white focus:outline-none focus:ring-2 focus:ring-brand/20"
          />
        </div>
      </div>

      <BottomBar>
        <Button block size="lg" loading={createReview.isPending} onClick={onSubmit}>
          등록
        </Button>
      </BottomBar>
    </>
  );
}

export default function WriteReviewPage() {
  return (
    <>
      <AppHeader title="리뷰 작성" back />
      <Suspense fallback={<LoadingScreen />}>
        <WriteReviewInner />
      </Suspense>
    </>
  );
}

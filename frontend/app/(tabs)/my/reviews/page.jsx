'use client';

import { useState } from 'react';
import Link from 'next/link';
import { MessageSquare } from 'lucide-react';
import { AppHeader } from '@/components/layout';
import { Card } from '@/components/ui/Card';
import { Button } from '@/components/ui/Button';
import { SegmentedToggle } from '@/components/ui/SegmentedToggle';
import { RatingStars } from '@/components/ui/Misc';
import { EmptyState } from '@/components/ui/States';
import { date } from '@/lib/format';

const TABS = [
  { value: 'writable', label: '작성 가능' },
  { value: 'written', label: '작성한 리뷰' },
];

// my-reviews 전용 훅이 없어 작성한 리뷰는 로컬 샘플 데이터로 구성.
const WRITTEN = [
  {
    producer: '해남 봄동 햇살농원',
    item: '봄동',
    rating: 5,
    body: '봄동이 정말 싱싱하고 달았어요. 데쳐서 무쳐 먹으니 식구들이 다 좋아하네요. 다음 제철에도 또 주문할게요!',
    date: '2026-05-30',
  },
  {
    producer: '강진 시금치 들녘농가',
    item: '시금치',
    rating: 4,
    body: '시금치 잎이 두툼하고 향이 좋습니다. 배송도 빨랐어요. 양이 조금만 더 많았으면 좋겠어요.',
    date: '2026-05-16',
  },
];

function WrittenCard({ review }) {
  return (
    <Card className="p-4">
      <div className="flex items-center justify-between">
        <span className="text-[13px] font-extrabold text-ink">{review.producer}</span>
        <span className="text-[11px] text-ink-soft">{date(review.date)}</span>
      </div>
      <div className="mt-1.5 flex items-center gap-1.5">
        <RatingStars value={review.rating} size={14} />
        <span className="text-[11px] text-ink-soft">{review.item} 구매</span>
      </div>
      <p className="mt-2 text-[12.5px] leading-relaxed text-ink-mid">{review.body}</p>
      <div className="mt-3 flex gap-2">
        {['수정', '삭제'].map((b) => (
          <Button key={b} variant="outline" size="sm">
            {b}
          </Button>
        ))}
      </div>
    </Card>
  );
}

export default function MyReviewsPage() {
  const [tab, setTab] = useState('writable');

  return (
    <>
      <AppHeader title="내 리뷰" back />

      <div className="px-4 pb-3 pt-1">
        <SegmentedToggle options={TABS} value={tab} onChange={setTab} />
      </div>

      <div className="pb-6">
        {tab === 'writable' && (
          <EmptyState
            icon={<MessageSquare size={40} strokeWidth={1.6} />}
            title="작성 가능한 리뷰가 없어요"
            description="배송 완료된 주문이 생기면 이곳에서 리뷰를 남길 수 있어요."
            action={
              <Link href="/my/reviews/new?producerId=1">
                <Button variant="soft" size="sm">
                  리뷰 쓰기
                </Button>
              </Link>
            }
          />
        )}

        {tab === 'written' &&
          (WRITTEN.length ? (
            <div className="space-y-3 px-4">
              {WRITTEN.map((rv, i) => (
                <WrittenCard key={i} review={rv} />
              ))}
            </div>
          ) : (
            <EmptyState
              icon={<MessageSquare size={40} strokeWidth={1.6} />}
              title="작성한 리뷰가 없어요"
              description="구매한 상품에 첫 리뷰를 남겨보세요."
            />
          ))}
      </div>
    </>
  );
}

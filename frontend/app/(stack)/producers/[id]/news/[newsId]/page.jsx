'use client';

import { Megaphone } from 'lucide-react';
import { useProducer, useProducerNews } from '@/lib/queries';
import { AppHeader } from '@/components/layout';
import { LoadingScreen } from '@/components/ui/Spinner';
import { ErrorState, EmptyState } from '@/components/ui/States';

// 농가 스토어 소식 상세. 단건 API가 없어 농가 소식 목록에서 해당 id를 찾아 보여준다.
export default function ProducerNewsDetailPage({ params }) {
  const { id, newsId } = params;
  const { data: news = [], isLoading, error, refetch } = useProducerNews(id);
  const { data: producer } = useProducer(id);

  if (isLoading) {
    return (
      <>
        <AppHeader title="소식" back />
        <LoadingScreen />
      </>
    );
  }
  if (error) {
    return (
      <>
        <AppHeader title="소식" back />
        <ErrorState onRetry={refetch} />
      </>
    );
  }

  const item = news.find((n) => String(n.id) === String(newsId));

  if (!item) {
    return (
      <>
        <AppHeader title="소식" back />
        <EmptyState title="소식을 찾을 수 없어요" description="삭제되었거나 잘못된 주소예요." />
      </>
    );
  }

  return (
    <>
      <AppHeader title="스토어 소식" back />
      <div className="animate-fade-up px-5 pb-10 pt-2">
        <div className="flex items-center gap-2 text-[11px] text-ink-soft">
          <span className="inline-flex items-center gap-1 font-extrabold tracking-wide text-brand-dark">
            <Megaphone size={13} /> NEWS
          </span>
          {item.date && <span>{item.date}</span>}
        </div>

        <h1 className="mt-2 text-[20px] font-extrabold leading-tight tracking-tight text-ink">
          {item.title}
        </h1>

        {producer?.name && (
          <p className="mt-1 text-[12.5px] text-ink-soft">
            {producer.region ? `${producer.region} ` : ''}
            {producer.name}
          </p>
        )}

        {item.imageUrl && (
          <div className="mt-4 overflow-hidden rounded-2xl border border-line-soft">
            <img src={item.imageUrl} alt={item.title} className="w-full object-cover" />
          </div>
        )}

        {item.body && (
          <p className="mt-4 whitespace-pre-line text-[14px] leading-relaxed text-ink-mid">
            {item.body}
          </p>
        )}
      </div>
    </>
  );
}

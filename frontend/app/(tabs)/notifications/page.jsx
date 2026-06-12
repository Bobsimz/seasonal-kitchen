'use client';

import { useState } from 'react';
import { TrendingDown, Package, Heart, Bell } from 'lucide-react';
import { useNotifications, useReadNotification } from '@/lib/queries';
import { AppHeader } from '@/components/layout';
import { ChipTabs } from '@/components/ui/SegmentedToggle';
import { LoadingScreen } from '@/components/ui/Spinner';
import { ErrorState, EmptyState } from '@/components/ui/States';
import { relativeTime } from '@/lib/format';
import { cn } from '@/lib/cn';

const TYPE_META = {
  PRICE: { icon: TrendingDown, iconCls: 'bg-brand-soft text-brand' },
  ORDER: { icon: Package, iconCls: 'bg-info/10 text-info' },
  COMMUNITY: { icon: Heart, iconCls: 'bg-warn-bg text-warn' },
};

const TABS = [
  { value: 'ALL', label: '전체' },
  { value: 'PRICE', label: '가격' },
  { value: 'ORDER', label: '주문' },
  { value: 'COMMUNITY', label: '소식' },
];

function NotificationRow({ item, onRead }) {
  const meta = TYPE_META[item.type] ?? TYPE_META.PRICE;
  const Icon = meta.icon;
  return (
    <button
      onClick={() => !item.read && onRead(item.id)}
      className="tap flex w-full items-start gap-3 px-4 py-3.5 text-left"
    >
      <div className={cn('grid h-9 w-9 shrink-0 place-items-center rounded-xl', meta.iconCls)}>
        <Icon size={18} />
      </div>
      <div className="min-w-0 flex-1">
        <p className="text-[13.5px] font-bold leading-snug tracking-tight text-ink">{item.title}</p>
        <p className="mt-0.5 text-[12px] leading-relaxed text-ink-mid">{item.body}</p>
        <p className="mt-1 text-[11px] text-ink-soft">{relativeTime(item.createdAt)}</p>
      </div>
      {!item.read && <span className="mt-1.5 h-[7px] w-[7px] shrink-0 rounded-full bg-brand" />}
    </button>
  );
}

export default function NotificationsPage() {
  const { data, isLoading, error, refetch } = useNotifications();
  const readNotification = useReadNotification();
  const [tab, setTab] = useState('ALL');

  const counts = data?.tabCounts ?? {};
  const tabOptions = TABS.map((tb) => ({
    value: tb.value,
    label: counts[tb.value] ? `${tb.label} ${counts[tb.value]}` : tb.label,
  }));

  const items = data?.items ?? [];
  const filtered = tab === 'ALL' ? items : items.filter((it) => it.type === tab);
  const hasUnread = items.some((it) => !it.read);

  return (
    <>
      <AppHeader
        title="알림"
        back
        right={
          <button
            onClick={() => hasUnread && readNotification.mutate({ all: true })}
            disabled={!hasUnread || readNotification.isPending}
            className={cn(
              'tap px-2.5 py-1.5 text-[12.5px] font-bold',
              hasUnread ? 'text-brand' : 'text-ink-soft',
            )}
          >
            모두 읽음
          </button>
        }
      />

      {isLoading && <LoadingScreen />}
      {error && <ErrorState onRetry={refetch} />}

      {data && (
        <div className="animate-fade-up pb-6">
          <div className="sticky top-14 z-10 border-b border-line-soft bg-surface pt-2">
            <ChipTabs options={tabOptions} value={tab} onChange={setTab} />
            <div className="h-2" />
          </div>

          {filtered.length === 0 ? (
            <EmptyState
              icon={<Bell size={32} strokeWidth={1.5} />}
              title="알림이 없어요"
              description="가격 변동·주문·소식 알림이 도착하면 여기에 표시돼요."
            />
          ) : (
            <div className="divide-y divide-line-soft">
              {filtered.map((item) => (
                <NotificationRow key={item.id} item={item} onRead={(id) => readNotification.mutate({ id })} />
              ))}
            </div>
          )}
        </div>
      )}
    </>
  );
}

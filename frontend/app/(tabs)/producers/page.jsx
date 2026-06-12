'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { useProducers } from '@/lib/queries';
import { AppHeader } from '@/components/layout';
import { SearchBar } from '@/components/ui/SearchBar';
import { Section } from '@/components/ui/Card';
import { ChipTabs } from '@/components/ui/SegmentedToggle';
import { LoadingScreen } from '@/components/ui/Spinner';
import { ErrorState } from '@/components/ui/States';
import { EmptyState } from '@/components/ui/States';
import { ProducerRow, ProducerCircle } from '@/components/domain/ProducerCard';

// 필터 칩 → (honorary | style) 조건. 클라이언트에서 useProducers() 결과를 거름.
const FILTERS = [
  { value: 'ALL', label: '전체' },
  { value: 'HONORARY', label: '명예농가' },
  { value: 'ORGANIC', label: '유기농' },
  { value: 'PREMIUM', label: '프리미엄' },
  { value: 'VALUE', label: '실속' },
];

function matchFilter(producer, filter) {
  if (filter === 'ALL') return true;
  if (filter === 'HONORARY') return !!producer.honorary;
  return String(producer.style || '').toUpperCase() === filter;
}

export default function ProducersPage() {
  const router = useRouter();
  const [filter, setFilter] = useState('ALL');
  const { data: producers = [], isLoading, error, refetch } = useProducers();

  const honorary = producers.filter((p) => p.honorary);
  const filtered = producers.filter((p) => matchFilter(p, filter));

  return (
    <>
      <AppHeader title="농가" back />

      <div className="px-4 pb-3 pt-1">
        <SearchBar readOnly onClick={() => router.push('/search')} placeholder="농가 이름·지역으로 검색" />
      </div>

      {isLoading && <LoadingScreen />}
      {error && <ErrorState onRetry={refetch} />}

      {!isLoading && !error && (
        <div className="animate-fade-up pb-6">
          {/* 명예 농가 하이라이트 */}
          {honorary.length > 0 && (
            <Section title="믿고 사는 명예 농가">
              <div className="flex gap-4 overflow-x-auto phone-scroll px-4 pb-1">
                {honorary.slice(0, 8).map((p) => (
                  <ProducerCircle key={p.id} producer={p} />
                ))}
              </div>
            </Section>
          )}

          {/* 필터 칩 */}
          <div className="pt-1">
            <ChipTabs options={FILTERS} value={filter} onChange={setFilter} />
          </div>

          {/* 농가 목록 */}
          <div className="mt-2">
            {filtered.length === 0 ? (
              <EmptyState
                title="조건에 맞는 농가가 없어요"
                description="다른 필터를 선택해 보세요."
              />
            ) : (
              filtered.map((p) => <ProducerRow key={p.id} producer={p} />)
            )}
          </div>
        </div>
      )}
    </>
  );
}

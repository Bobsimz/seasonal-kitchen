import { Skeleton } from '@/components/ui/Skeleton';
import { Section } from '@/components/ui/Card';

// 가로 캐러셀 행
function Row({ children, className }) {
  return <div className={`flex gap-3 overflow-x-auto phone-scroll px-4 pb-1 ${className || ''}`}>{children}</div>;
}

// ── 홈 스켈레톤 ── (실제 홈 레이아웃과 동일한 섹션 구성/높이)
export function HomeSkeleton() {
  return (
    <div className="pb-6" aria-busy="true">
      {/* 히어로 */}
      <div className="-mt-14">
        <Skeleton className="h-[clamp(320px,46svh,400px)] w-full" rounded="rounded-none" />
      </div>

      {/* 지금 제철 식재료 */}
      <Section title={<Skeleton className="h-5 w-32" />}>
        <Row>
          {Array.from({ length: 4 }).map((_, i) => (
            <div key={i} className="w-[126px] shrink-0">
              <Skeleton className="h-[126px] w-full" rounded="rounded-2xl" />
              <Skeleton className="mt-2 h-3.5 w-20" />
              <Skeleton className="mt-1.5 h-3.5 w-16" />
            </div>
          ))}
        </Row>
      </Section>

      {/* 요즘 뜨는 레시피 */}
      <Section title={<Skeleton className="h-5 w-28" />}>
        <Row>
          {Array.from({ length: 3 }).map((_, i) => (
            <div key={i} className="w-[168px] shrink-0">
              <Skeleton className="aspect-square w-full" rounded="rounded-2xl" />
              <Skeleton className="mt-2 h-3.5 w-32" />
              <Skeleton className="mt-1.5 h-3 w-20" />
            </div>
          ))}
        </Row>
      </Section>

      {/* 레시피 릴스 */}
      <Section title={<Skeleton className="h-5 w-24" />}>
        <Row>
          {Array.from({ length: 3 }).map((_, i) => (
            <Skeleton key={i} className="aspect-[9/16] w-[132px] shrink-0" rounded="rounded-2xl" />
          ))}
        </Row>
      </Section>

      {/* 믿고 사는 명예 농가 */}
      <Section title={<Skeleton className="h-5 w-36" />}>
        <div className="flex gap-4 overflow-x-auto phone-scroll px-4 pb-1">
          {Array.from({ length: 5 }).map((_, i) => (
            <div key={i} className="shrink-0 text-center" style={{ width: 94 }}>
              <Skeleton className="mx-auto h-[72px] w-[72px]" rounded="rounded-full" />
              <Skeleton className="mx-auto mt-2 h-3 w-14" />
            </div>
          ))}
        </div>
      </Section>
    </div>
  );
}

// 상품 상세정보 섹션만의 스켈레톤 — 상세 데이터(useProduct)가 메인보다 늦게 와서
// 갑자기 튀어나오는 걸 막기 위해 그 자리에 미리 깔아둔다.
export function DetailSectionsSkeleton() {
  return (
    <div className="px-4 pt-6" aria-busy="true">
      <Skeleton className="mb-3 h-5 w-28" />
      <div className="rounded-2xl border border-line-soft bg-white p-4">
        <Skeleton className="aspect-[16/10] w-full" rounded="rounded-xl" />
        <Skeleton className="mt-3 h-3 w-full" />
        <Skeleton className="mt-2 h-3 w-5/6" />
        <Skeleton className="mt-2 h-3 w-2/3" />
      </div>
    </div>
  );
}

// ── 상품 상세 스켈레톤 (본문만 — 헤더는 페이지에서 별도 렌더) ──
export function ProductDetailSkeleton() {
  return (
    <div className="bg-surface-soft pb-28" aria-busy="true">
      {/* 농가 헤더 */}
      <div className="px-4 pt-3">
        <div className="flex items-center gap-3 rounded-2xl border border-line-soft bg-white p-4">
          <Skeleton className="h-12 w-12" rounded="rounded-full" />
          <div className="min-w-0 flex-1">
            <Skeleton className="h-4 w-32" />
            <Skeleton className="mt-2 h-3 w-24" />
          </div>
          <Skeleton className="h-4 w-10" />
        </div>
      </div>

      {/* 상품 hero + 가격 */}
      <div className="px-4 pt-3">
        <div className="flex gap-3.5 rounded-2xl border border-line-soft bg-white p-4">
          <Skeleton className="h-[84px] w-[84px]" rounded="rounded-xl" />
          <div className="min-w-0 flex-1">
            <Skeleton className="h-5 w-28" />
            <div className="mt-2.5 flex gap-1.5">
              <Skeleton className="h-6 w-20" rounded="rounded-full" />
              <Skeleton className="h-6 w-16" rounded="rounded-full" />
            </div>
            <Skeleton className="mt-3 h-6 w-32" />
          </div>
        </div>
      </div>

      {/* 배송 안내 */}
      <div className="px-4 pt-3">
        <div className="rounded-2xl border border-line-soft bg-white px-4 py-1">
          {[0, 1, 2].map((i) => (
            <div key={i} className="flex items-center gap-3 py-3">
              <Skeleton className="h-[17px] w-[17px]" />
              <Skeleton className="h-3 w-12" />
              <Skeleton className="h-3 flex-1" />
            </div>
          ))}
        </div>
      </div>

      {/* 상품 상세정보 */}
      <div className="px-4 pt-6">
        <Skeleton className="mb-3 h-5 w-28" />
        <div className="rounded-2xl border border-line-soft bg-white p-4">
          <Skeleton className="aspect-[16/10] w-full" rounded="rounded-xl" />
          <Skeleton className="mt-3 h-3 w-full" />
          <Skeleton className="mt-2 h-3 w-5/6" />
          <Skeleton className="mt-2 h-3 w-2/3" />
        </div>
      </div>
    </div>
  );
}

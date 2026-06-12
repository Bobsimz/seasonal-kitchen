import Link from 'next/link';
import { cn } from '@/lib/cn';
import { won } from '@/lib/format';
import { VegImage } from './VegImage';
import { TrendBadge } from '@/components/ui/Misc';
import { Chip } from '@/components/ui/Chip';

// 식재료 가로 리스트 행.
export function IngredientRow({ ingredient: i, divider = true }) {
  return (
    <Link href={`/ingredients/${i.id}`} className={cn('tap flex items-center gap-3 px-4 py-3', divider && 'border-b border-line-soft')}>
      <VegImage name={i.name} src={i.imageUrl} size={52} />
      <div className="min-w-0 flex-1">
        <div className="flex items-center gap-1.5">
          <span className="text-[15px] font-bold text-ink">{i.name}</span>
          {i.hot && <Chip tone="hot">인기</Chip>}
          {i.seasonal && <Chip tone="brand">제철</Chip>}
        </div>
        {i.category && <p className="mt-0.5 text-[11.5px] text-ink-soft">{i.category}</p>}
      </div>
      <div className="shrink-0 text-right">
        <p className="text-[15px] font-extrabold text-ink tabular">
          {won(i.currentPrice)}
          <span className="ml-0.5 text-[11px] font-medium text-ink-soft">원/{i.unit}</span>
        </p>
        {i.priceChangeLabel && (
          <TrendBadge direction={i.trendDirection} label={i.priceChangeLabel} className="mt-0.5 justify-end" />
        )}
      </div>
    </Link>
  );
}

// 식재료 세로 카드 (홈 캐러셀/그리드).
export function IngredientCard({ ingredient: i, className }) {
  return (
    <Link href={`/ingredients/${i.id}`} className={cn('tap block w-[126px] shrink-0', className)}>
      <div className="relative">
        <VegImage name={i.name} src={i.imageUrl} size={126} rounded="rounded-2xl" className="!h-[126px] !w-full" />
        {i.hot && (
          <span className="absolute left-2 top-2 rounded-full bg-hot px-2 py-0.5 text-[10px] font-bold text-white shadow">
            인기 ↑
          </span>
        )}
      </div>
      <p className="mt-2 text-[13.5px] font-bold text-ink">{i.name}</p>
      <div className="mt-0.5 flex items-baseline gap-1">
        <span className="text-[14px] font-extrabold text-ink tabular">{won(i.currentPrice)}</span>
        <span className="text-[10.5px] text-ink-soft">원/{i.unit}</span>
      </div>
      {i.priceChangeLabel && <TrendBadge direction={i.trendDirection} label={i.priceChangeLabel} className="mt-0.5" />}
    </Link>
  );
}

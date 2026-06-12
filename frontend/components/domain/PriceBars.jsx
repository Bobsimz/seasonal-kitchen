import { won } from '@/lib/format';

// 가격 이력 막대 차트 (식재료 상세). data: [{ label, price }]
// 마지막 막대를 브랜드 그린으로 강조합니다.
export function PriceBars({ data = [], unit }) {
  if (!data.length) return null;
  const max = Math.max(...data.map((d) => d.price));
  return (
    <div>
      <div className="flex h-32 items-end justify-between gap-1.5">
        {data.map((d, idx) => {
          const last = idx === data.length - 1;
          const h = Math.max(8, Math.round((d.price / max) * 100));
          return (
            <div key={d.label} className="flex flex-1 flex-col items-center justify-end gap-1">
              {last && <span className="text-[10px] font-bold text-brand-dark tabular">{won(d.price)}</span>}
              <div
                className={'w-full rounded-t-md ' + (last ? 'bg-brand' : 'bg-chart-green')}
                style={{ height: `${h}%` }}
              />
            </div>
          );
        })}
      </div>
      <div className="mt-1.5 flex justify-between gap-1.5">
        {data.map((d) => (
          <span key={d.label} className="flex-1 text-center text-[10px] text-ink-soft">
            {d.label}
          </span>
        ))}
      </div>
      {unit && <p className="mt-2 text-right text-[11px] text-ink-soft">단위: 원/{unit}</p>}
    </div>
  );
}

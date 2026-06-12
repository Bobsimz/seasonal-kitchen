import Link from 'next/link';
import { Heart, Play } from 'lucide-react';
import { cn } from '@/lib/cn';
import { compact } from '@/lib/format';

// 릴스 세로 썸네일 (9:16). 홈/검색 캐러셀용.
export function ReelThumb({ reel: r, className, width = 132 }) {
  return (
    <Link href={`/reels?id=${r.id}`} className={cn('tap block shrink-0', className)} style={{ width }}>
      <div className="relative aspect-[9/16] w-full overflow-hidden rounded-2xl bg-ink">
        {r.thumbnailUrl && <img src={r.thumbnailUrl} alt={r.title} className="h-full w-full object-cover" />}
        <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent" />
        <span className="absolute right-2 top-2 grid h-7 w-7 place-items-center rounded-full bg-black/40 text-white backdrop-blur">
          <Play size={13} className="fill-white" />
        </span>
        <div className="absolute bottom-2 left-2 right-2">
          <p className="line-clamp-2 text-[12px] font-bold leading-tight text-white">{r.title}</p>
          <div className="mt-1 flex items-center gap-1 text-[11px] font-semibold text-white/90">
            <Heart size={11} className="fill-white" /> {compact(r.likes)}
          </div>
        </div>
      </div>
    </Link>
  );
}

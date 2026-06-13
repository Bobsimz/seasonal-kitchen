'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import Link from 'next/link';
import { Sprout, ChevronRight, Plus, Check, X } from 'lucide-react';
import { useMyProducer, useRegisterProducer } from '@/lib/queries';
import { useAuth } from '@/lib/auth';
import { AppHeader, BottomBar } from '@/components/layout';
import { Button } from '@/components/ui/Button';
import { Card } from '@/components/ui/Card';
import { LoadingScreen } from '@/components/ui/Spinner';
import { ErrorState } from '@/components/ui/States';
import { useToast } from '@/components/ui/Toast';
import { styleMeta } from '@/components/domain';
import { cn } from '@/lib/cn';

const STYLE_OPTIONS = ['VALUE', 'ORGANIC', 'PREMIUM'];
const SPECIALTY_PRESET = ['무', '봄동', '배추', '시금치', '감귤', '대파', '고구마', '브로콜리'];
const BADGE_PRESET = ['산지직송', '당일수확', '유기농 인증', '무농약', '대량 할인'];
const LEVEL_LABELS = ['저렴', '보통', '적정', '높음', '프리미엄'];

// 입력 라벨 + 텍스트 인풋
function FormField({ label, value, onChange, placeholder, required }) {
  return (
    <label className="block">
      <span className="mb-1.5 flex items-center gap-1.5 text-[12.5px] font-extrabold text-ink">
        {label}
        {required && (
          <span className="rounded-full bg-brand-bg px-1.5 py-0.5 text-[10px] font-bold text-brand-dark">필수</span>
        )}
      </span>
      <input
        value={value}
        onChange={(e) => onChange(e.target.value)}
        placeholder={placeholder}
        className="h-12 w-full rounded-2xl border border-line bg-surface-soft px-4 text-[14px] font-medium text-ink placeholder:text-ink-soft focus:border-brand focus:bg-white focus:outline-none focus:ring-2 focus:ring-brand/20"
      />
    </label>
  );
}

// 자유 입력 태그 — 텍스트로 직접 입력 후 추가, 칩 클릭(X)으로 제거.
function TagInput({ items, setItems, placeholder }) {
  const [text, setText] = useState('');
  const add = () => {
    const v = text.trim();
    if (!v) return;
    if (!items.includes(v)) setItems([...items, v]);
    setText('');
  };
  return (
    <div>
      <div className="flex gap-2">
        <input
          value={text}
          onChange={(e) => setText(e.target.value)}
          onKeyDown={(e) => {
            if (e.key === 'Enter') {
              e.preventDefault();
              add();
            }
          }}
          placeholder={placeholder}
          className="h-12 flex-1 rounded-2xl border border-line bg-surface-soft px-4 text-[14px] font-medium text-ink placeholder:text-ink-soft focus:border-brand focus:bg-white focus:outline-none focus:ring-2 focus:ring-brand/20"
        />
        <button
          type="button"
          onClick={add}
          className="tap shrink-0 rounded-2xl border border-brand bg-brand-bg px-4 text-[13px] font-extrabold text-brand-dark"
        >
          추가
        </button>
      </div>
      {items.length > 0 && (
        <div className="mt-2 flex flex-wrap gap-2">
          {items.map((it) => (
            <button
              key={it}
              type="button"
              onClick={() => setItems(items.filter((x) => x !== it))}
              className="tap inline-flex items-center gap-1 rounded-full border border-brand bg-brand-bg py-1.5 pl-3 pr-2 text-[13px] font-bold text-brand-dark"
            >
              {it}
              <X size={13} />
            </button>
          ))}
        </div>
      )}
    </div>
  );
}

// 섹션 제목 + 본문 (입력 폼 전용, Section 과 달리 좌측 정렬 라벨 톤)
function FieldGroup({ label, hint, children }) {
  return (
    <div>
      <div className="mb-2 flex items-baseline gap-2">
        <span className="text-[12.5px] font-extrabold text-ink">{label}</span>
        {hint && <span className="text-[11px] font-medium text-ink-soft">{hint}</span>}
      </div>
      {children}
    </div>
  );
}

// 1~5 레벨 알약 선택기
function LevelPills({ value, onChange }) {
  return (
    <div className="flex gap-2">
      {[1, 2, 3, 4, 5].map((lv) => {
        const on = value === lv;
        return (
          <button
            key={lv}
            type="button"
            onClick={() => onChange(lv)}
            className={cn(
              'tap flex flex-1 flex-col items-center gap-0.5 rounded-2xl border py-2.5 text-[15px] font-extrabold',
              on ? 'border-brand bg-brand-bg text-brand-dark' : 'border-line bg-white text-ink-soft',
            )}
          >
            {lv}
            <span className={cn('text-[10px] font-bold', on ? 'text-brand-dark' : 'text-ink-soft')}>
              {LEVEL_LABELS[lv - 1]}
            </span>
          </button>
        );
      })}
    </div>
  );
}

// 다중 선택 칩 토글
function ToggleChip({ active, children, onClick, icon: Icon }) {
  return (
    <button
      type="button"
      onClick={onClick}
      className={cn(
        'tap inline-flex items-center gap-1 rounded-full border px-4 py-2 text-[13px] font-bold',
        active ? 'border-brand bg-brand-bg text-brand-dark' : 'border-line bg-white text-ink-mid',
      )}
    >
      {Icon && <Icon size={13} />}
      {children}
    </button>
  );
}

export default function SellerRegisterPage() {
  const router = useRouter();
  const toast = useToast();
  const { isAuthenticated } = useAuth();
  const { data: myProducer, isLoading, error, refetch } = useMyProducer();
  const register = useRegisterProducer();

  const [form, setForm] = useState({
    name: '',
    region: '',
    tagline: '',
    style: 'VALUE',
    priceLevel: 3,
    freshnessLevel: 4,
  });
  const [specialties, setSpecialties] = useState([]);
  const [badges, setBadges] = useState([]);

  const set = (k, v) => setForm((f) => ({ ...f, [k]: v }));
  const toggle = (list, setList, value) =>
    setList(list.includes(value) ? list.filter((x) => x !== value) : [...list, value]);

  const canSubmit = form.name.trim() && form.region.trim();

  const onSubmit = async () => {
    if (!isAuthenticated) {
      toast.show('로그인이 필요해요', { type: 'error' });
      router.push('/login?next=/my/seller/register');
      return;
    }
    if (!canSubmit) {
      toast.show('농가명과 지역을 입력해주세요', { type: 'error' });
      return;
    }
    try {
      await register.mutateAsync({
        ...form,
        name: form.name.trim(),
        region: form.region.trim(),
        tagline: form.tagline.trim(),
        specialties,
        badges,
      });
      toast.show('농가 등록이 완료됐어요', { type: 'success' });
      router.replace('/my/seller/dashboard');
    } catch (e) {
      toast.show(e?.message || '등록에 실패했어요', { type: 'error' });
    }
  };

  return (
    <>
      <AppHeader title="농가 등록" back />

      {isLoading && <LoadingScreen />}
      {error && <ErrorState onRetry={refetch} />}

      {!isLoading && !error && myProducer && (
        <div className="px-4 pt-4">
          <Card className="p-5">
            <div className="grid h-12 w-12 place-items-center rounded-2xl bg-brand-bg text-brand-dark">
              <Check size={24} />
            </div>
            <h2 className="mt-4 font-display text-[18px] font-bold text-ink">이미 등록된 농가가 있어요</h2>
            <p className="mt-1.5 text-[13px] leading-relaxed text-ink-mid">
              <span className="font-bold text-ink">{myProducer.name}</span> 농가로 등록되어 있어요. 판매 통계와 상품
              관리는 대시보드에서 확인하세요.
            </p>
            <Link href="/my/seller/dashboard" className="mt-4 block">
              <Button block size="lg">
                농가 대시보드로 이동 <ChevronRight size={18} />
              </Button>
            </Link>
          </Card>
        </div>
      )}

      {!isLoading && !error && !myProducer && (
        <>
          <div className="animate-fade-up pb-28">
            {/* 안내 카드 */}
            <div className="px-4 pt-3.5">
              <div className="relative overflow-hidden rounded-3xl bg-gradient-to-br from-brand to-brand-dark p-5 text-white">
                <Sprout size={88} className="absolute -right-3 -top-3 opacity-15" />
                <div className="text-[12px] font-extrabold tracking-wide text-white/90">농가 신청</div>
                <div className="mt-1 text-[18px] font-extrabold leading-snug tracking-tight">
                  내 농가 상품을
                  <br />
                  직접 판매해보세요
                </div>
                <p className="mt-1.5 text-[11.5px] leading-relaxed text-white/90">
                  등록 후 상품 탭에서 바로 판매 상품을 올릴 수 있어요
                </p>
              </div>
            </div>

            {/* 입력 폼 */}
            <div className="space-y-5 px-4 pt-5">
              <FormField
                label="농가명"
                value={form.name}
                onChange={(v) => set('name', v)}
                placeholder="예) 해남 송지농원"
                required
              />
              <FormField
                label="지역"
                value={form.region}
                onChange={(v) => set('region', v)}
                placeholder="예) 전남 해남"
                required
              />
              <FormField
                label="한줄 소개"
                value={form.tagline}
                onChange={(v) => set('tagline', v)}
                placeholder="예) 30년 무 농사, 햇무만 보냅니다"
              />

              {/* 판매 스타일 */}
              <FieldGroup label="판매 스타일">
                <div className="flex gap-2">
                  {STYLE_OPTIONS.map((s) => {
                    const meta = styleMeta(s);
                    const on = form.style === s;
                    return (
                      <button
                        key={s}
                        type="button"
                        onClick={() => set('style', s)}
                        className={cn(
                          'tap flex-1 rounded-2xl border px-2 py-3 text-[12.5px] font-bold leading-tight',
                          on ? 'border-brand bg-brand-bg text-brand-dark' : 'border-line bg-white text-ink-mid',
                        )}
                      >
                        {meta.label}
                      </button>
                    );
                  })}
                </div>
              </FieldGroup>

              {/* 가격대 */}
              <FieldGroup label="가격대" hint="1 저렴 · 5 프리미엄">
                <LevelPills value={form.priceLevel} onChange={(v) => set('priceLevel', v)} />
              </FieldGroup>

              {/* 신선도 */}
              <FieldGroup label="신선도" hint="1 보통 · 5 최상">
                <LevelPills value={form.freshnessLevel} onChange={(v) => set('freshnessLevel', v)} />
              </FieldGroup>

              {/* 주력 품목 — 직접 입력 */}
              <FieldGroup label="주력 품목" hint={specialties.length ? `${specialties.length}개 입력` : '직접 입력 후 추가'}>
                <TagInput items={specialties} setItems={setSpecialties} placeholder="예) 무, 봄동, 시금치" />
              </FieldGroup>

              {/* 배지 */}
              <FieldGroup label="배지" hint="농가를 알리는 특징">
                <div className="flex flex-wrap gap-2">
                  {BADGE_PRESET.map((b) => (
                    <ToggleChip
                      key={b}
                      active={badges.includes(b)}
                      onClick={() => toggle(badges, setBadges, b)}
                      icon={badges.includes(b) ? Check : Plus}
                    >
                      {b}
                    </ToggleChip>
                  ))}
                </div>
              </FieldGroup>
            </div>
          </div>

          <BottomBar>
            <Button block size="lg" loading={register.isPending} disabled={!canSubmit} onClick={onSubmit}>
              등록하기
            </Button>
          </BottomBar>
        </>
      )}
    </>
  );
}

'use client';

import { Suspense, useState } from 'react';
import Link from 'next/link';
import { useRouter, useSearchParams } from 'next/navigation';
import { ChefHat } from 'lucide-react';
import { useAuth } from '@/lib/auth';
import { Button } from '@/components/ui/Button';
import { useToast } from '@/components/ui/Toast';

function LoginInner() {
  const router = useRouter();
  const params = useSearchParams();
  // 내부 경로만 허용 (open-redirect 방지: '//evil.com' 같은 값 차단).
  const rawNext = params.get('next') || '/';
  const next = rawNext.startsWith('/') && !rawNext.startsWith('//') ? rawNext : '/';
  const { login } = useAuth();
  const toast = useToast();

  const [form, setForm] = useState({ email: '', password: '' });
  const [loading, setLoading] = useState(false);
  const [err, setErr] = useState(null);

  const onSubmit = async (e) => {
    e.preventDefault();
    setErr(null);
    setLoading(true);
    try {
      await login(form);
      toast.show('로그인되었어요', { type: 'success' });
      router.replace(next);
    } catch (e2) {
      setErr(e2?.message || '로그인에 실패했어요.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="flex min-h-full flex-1 flex-col px-7 pb-8 pt-16">
      <div className="grid h-14 w-14 place-items-center rounded-2xl bg-brand text-white">
        <ChefHat size={30} />
      </div>
      <h1 className="mt-5 font-display text-[24px] font-bold leading-tight tracking-tight text-ink">
        다시 오셨네요!
        <br />
        제철식탁에 로그인하세요
      </h1>

      <form onSubmit={onSubmit} className="mt-8 space-y-3">
        <Field label="이메일" type="email" value={form.email} onChange={(v) => setForm({ ...form, email: v })} placeholder="example@email.com" autoComplete="email" />
        <Field label="비밀번호" type="password" value={form.password} onChange={(v) => setForm({ ...form, password: v })} placeholder="비밀번호" autoComplete="current-password" />
        {err && <p className="text-[13px] font-semibold text-danger">{err}</p>}
        <Button type="submit" block size="lg" loading={loading} className="!mt-5">
          로그인
        </Button>
      </form>

      <p className="mt-3 text-center text-[12px] text-ink-soft">
        백엔드가 꺼져 있어도 데모 계정으로 자동 로그인됩니다.
      </p>

      <div className="mt-auto pt-8 text-center text-[14px] text-ink-soft">
        아직 회원이 아니신가요? <Link href="/signup" className="font-bold text-brand">가입하기</Link>
      </div>
    </div>
  );
}

export function Field({ label, type = 'text', value, onChange, placeholder, autoComplete, ...rest }) {
  return (
    <label className="block">
      <span className="mb-1.5 block text-[13px] font-bold text-ink-mid">{label}</span>
      <input
        type={type}
        value={value}
        onChange={(e) => onChange(e.target.value)}
        placeholder={placeholder}
        autoComplete={autoComplete}
        className="h-12 w-full rounded-2xl border border-line bg-white px-4 text-[15px] font-medium text-ink placeholder:text-ink-soft focus:border-brand focus:outline-none focus:ring-2 focus:ring-brand/20"
        {...rest}
      />
    </label>
  );
}

export default function LoginPage() {
  return (
    <Suspense>
      <LoginInner />
    </Suspense>
  );
}

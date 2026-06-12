'use client';

import { useEffect, useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { Bell, TrendingDown, Megaphone, FileText, ShieldCheck, LogIn, LogOut, ChevronRight } from 'lucide-react';
import { useUpdateMe } from '@/lib/queries';
import { useAuth } from '@/lib/auth';
import { cn } from '@/lib/cn';
import { AppHeader } from '@/components/layout';
import { Card, Section } from '@/components/ui/Card';
import { Button } from '@/components/ui/Button';
import { useToast } from '@/components/ui/Toast';

export default function SettingsPage() {
  const router = useRouter();
  const { user, isAuthenticated, ready, logout, setUser } = useAuth();
  const toast = useToast();
  const updateMe = useUpdateMe();

  const [nickname, setNickname] = useState('');
  // 푸시/가격/마케팅 — 로컬 상태 토글 (백엔드 미연동, UI 데모)
  const [toggles, setToggles] = useState({ push: true, price: true, marketing: false });

  // 인증 정보가 준비되면 닉네임 프리필
  useEffect(() => {
    if (user?.nickname) setNickname(user.nickname);
  }, [user?.nickname]);

  const showLoginPrompt = ready && !isAuthenticated;

  const onSave = async () => {
    const trimmed = nickname.trim();
    if (!trimmed) {
      toast.show('닉네임을 입력해 주세요', { type: 'error' });
      return;
    }
    try {
      await updateMe.mutateAsync({ nickname: trimmed });
      setUser?.({ ...user, nickname: trimmed });
      toast.show('프로필을 저장했어요', { type: 'success' });
    } catch (e) {
      toast.show(e?.message || '저장에 실패했어요', { type: 'error' });
    }
  };

  const onLogout = () => {
    logout();
    toast.show('로그아웃되었어요', { type: 'success' });
    router.replace('/');
  };

  return (
    <>
      <AppHeader title="설정" back />

      {showLoginPrompt ? (
        <div className="animate-fade-up px-4 pt-4">
          <Card className="flex flex-col items-center gap-3 p-6 text-center">
            <div className="grid h-12 w-12 place-items-center rounded-2xl bg-brand-bg text-brand-dark">
              <LogIn size={24} />
            </div>
            <div>
              <p className="text-[15px] font-bold text-ink">로그인이 필요해요</p>
              <p className="mt-1 text-[13px] leading-relaxed text-ink-soft">
                프로필과 알림 설정은 로그인 후
                <br />
                이용할 수 있어요.
              </p>
            </div>
            <Link href="/login?next=/my/settings" className="w-full">
              <Button block size="lg" className="!mt-1">
                로그인 / 가입하기
              </Button>
            </Link>
          </Card>
        </div>
      ) : (
        <div className="animate-fade-up pb-10">
          {/* 프로필 수정 */}
          <Section title="프로필">
            <div className="px-4">
              <Card className="p-4">
                <label className="block">
                  <span className="mb-1.5 block text-[13px] font-bold text-ink-mid">닉네임</span>
                  <input
                    type="text"
                    value={nickname}
                    onChange={(e) => setNickname(e.target.value)}
                    placeholder="제철러버"
                    maxLength={20}
                    className="h-12 w-full rounded-2xl border border-line bg-white px-4 text-[15px] font-medium text-ink placeholder:text-ink-soft focus:border-brand focus:outline-none focus:ring-2 focus:ring-brand/20"
                  />
                </label>
                <label className="mt-3 block">
                  <span className="mb-1.5 block text-[13px] font-bold text-ink-mid">이메일</span>
                  <input
                    type="email"
                    value={user?.email || ''}
                    readOnly
                    className="h-12 w-full cursor-not-allowed rounded-2xl border border-line bg-surface-soft px-4 text-[15px] font-medium text-ink-soft focus:outline-none"
                  />
                </label>
                <Button
                  block
                  size="lg"
                  loading={updateMe.isPending}
                  onClick={onSave}
                  className="!mt-4"
                >
                  저장하기
                </Button>
              </Card>
            </div>
          </Section>

          {/* 알림 설정 */}
          <Section title="알림 설정">
            <div className="px-4">
              <Card className="overflow-hidden">
                <ToggleRow
                  icon={Bell}
                  label="푸시 알림"
                  desc="주문·배송 등 주요 소식을 받아요"
                  checked={toggles.push}
                  onChange={(v) => setToggles((t) => ({ ...t, push: v }))}
                  border
                />
                <ToggleRow
                  icon={TrendingDown}
                  label="가격 알림"
                  desc="찜한 재료가 목표가에 도달하면 알려드려요"
                  checked={toggles.price}
                  onChange={(v) => setToggles((t) => ({ ...t, price: v }))}
                  border
                />
                <ToggleRow
                  icon={Megaphone}
                  label="마케팅 수신"
                  desc="혜택·이벤트 소식을 받아볼게요"
                  checked={toggles.marketing}
                  onChange={(v) => setToggles((t) => ({ ...t, marketing: v }))}
                />
              </Card>
            </div>
          </Section>

          {/* 계정 */}
          <Section title="계정">
            <div className="px-4">
              <Card className="overflow-hidden">
                <LinkRow icon={FileText} label="이용약관" href="/legal/terms" border />
                <LinkRow icon={ShieldCheck} label="개인정보처리방침" href="/legal/privacy" />
              </Card>

              <button
                onClick={onLogout}
                className="tap mt-3 flex h-12 w-full items-center justify-center gap-2 rounded-2xl text-[15px] font-bold text-danger"
              >
                <LogOut size={18} />
                로그아웃
              </button>
            </div>
          </Section>
        </div>
      )}
    </>
  );
}

function ToggleRow({ icon: Icon, label, desc, checked, onChange, border }) {
  return (
    <div className={cn('flex items-center gap-3 px-4 py-3.5', border && 'border-b border-line-soft')}>
      <div className="grid h-9 w-9 shrink-0 place-items-center rounded-xl bg-surface-soft text-ink-mid">
        <Icon size={18} />
      </div>
      <div className="min-w-0 flex-1">
        <p className="text-[14.5px] font-semibold text-ink">{label}</p>
        {desc && <p className="mt-0.5 truncate text-[12px] text-ink-soft">{desc}</p>}
      </div>
      <button
        type="button"
        role="switch"
        aria-checked={checked}
        aria-label={label}
        onClick={() => onChange(!checked)}
        className={cn(
          'tap relative h-7 w-12 shrink-0 rounded-full transition-colors',
          checked ? 'bg-brand' : 'bg-line'
        )}
      >
        <span
          className={cn(
            'absolute top-0.5 h-6 w-6 rounded-full bg-white shadow-sm transition-all',
            checked ? 'left-[22px]' : 'left-0.5'
          )}
        />
      </button>
    </div>
  );
}

function LinkRow({ icon: Icon, label, href, border }) {
  return (
    <Link
      href={href}
      className={cn('tap flex items-center gap-3 px-4 py-3.5', border && 'border-b border-line-soft')}
    >
      <div className="grid h-9 w-9 shrink-0 place-items-center rounded-xl bg-surface-soft text-ink-mid">
        <Icon size={18} />
      </div>
      <span className="flex-1 text-[14.5px] font-semibold text-ink">{label}</span>
      <ChevronRight size={16} className="text-ink-soft" />
    </Link>
  );
}

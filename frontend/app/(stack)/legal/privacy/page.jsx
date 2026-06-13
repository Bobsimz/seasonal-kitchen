import { AppHeader } from '@/components/layout';

// 개인정보처리방침 — 정적 문서. (실서비스 출시 전 법무 검토 후 내용 확정 필요)
const SECTIONS = [
  {
    title: '1. 수집하는 개인정보 항목',
    body: '회원가입 및 서비스 이용 과정에서 이메일, 닉네임, 가구원 수·선호·알레르기 등 설문 정보, 주문·배송 정보를 수집합니다.',
  },
  {
    title: '2. 개인정보의 이용 목적',
    body: '수집한 정보는 회원 식별·인증, 맞춤 제철 식재료/레시피 추천, 농가 직거래 주문 처리 및 배송, 가격 알림 발송, 서비스 개선을 위해 이용됩니다.',
  },
  {
    title: '3. 개인정보의 보유 및 이용 기간',
    body: '회원 탈퇴 시 지체 없이 파기합니다. 다만 관계 법령에 따라 보존이 필요한 경우(전자상거래 등에서의 소비자 보호에 관한 법률 등) 해당 기간 동안 보관합니다.',
  },
  {
    title: '4. 개인정보의 제3자 제공',
    body: '농가 직거래 주문 처리를 위해 배송에 필요한 최소한의 정보를 해당 농가에게 제공할 수 있으며, 그 외에는 이용자의 동의 없이 제3자에게 제공하지 않습니다.',
  },
  {
    title: '5. 이용자의 권리',
    body: '이용자는 언제든지 마이페이지 > 설정에서 본인의 개인정보를 조회·수정하거나 회원 탈퇴를 통해 개인정보의 처리 정지를 요청할 수 있습니다.',
  },
];

export default function PrivacyPage() {
  return (
    <>
      <AppHeader title="개인정보처리방침" back />
      <div className="px-5 pb-10 pt-4">
        <p className="text-[12px] text-ink-soft">시행일 2026.06.01 · 본 문서는 데모용 예시입니다.</p>
        <div className="mt-5 space-y-6">
          {SECTIONS.map((s) => (
            <section key={s.title}>
              <h2 className="text-[14px] font-extrabold text-ink">{s.title}</h2>
              <p className="mt-1.5 text-[13px] leading-relaxed text-ink-mid">{s.body}</p>
            </section>
          ))}
        </div>
      </div>
    </>
  );
}

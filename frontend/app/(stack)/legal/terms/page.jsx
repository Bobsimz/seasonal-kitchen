import { AppHeader } from '@/components/layout';

// 이용약관 — 정적 문서. (실서비스 출시 전 법무 검토 후 내용 확정 필요)
const SECTIONS = [
  {
    title: '제1조 (목적)',
    body: '본 약관은 제철식탁(이하 "회사")이 제공하는 제철 식재료 정보, 레시피, 농가 직거래 등 모든 서비스(이하 "서비스")의 이용과 관련하여 회사와 이용자의 권리·의무 및 책임사항을 규정함을 목적으로 합니다.',
  },
  {
    title: '제2조 (정의)',
    body: '"이용자"란 본 약관에 따라 회사가 제공하는 서비스를 이용하는 회원 및 비회원을 말합니다. "농가"란 본인의 농산물을 서비스에 등록하여 판매하는 이용자를 말합니다.',
  },
  {
    title: '제3조 (서비스의 제공)',
    body: '회사는 제철 식재료 정보 및 시세, 레시피·숏폼 콘텐츠, 농가 직거래 중개, 가격 알림 등의 서비스를 제공합니다. 서비스의 내용은 운영상·기술상 필요에 따라 변경될 수 있습니다.',
  },
  {
    title: '제4조 (거래의 책임)',
    body: '회사는 농가와 구매자 간 거래의 중개자이며, 농산물의 품질·배송·환불에 대한 1차적 책임은 해당 농가에 있습니다. 회사는 분쟁 발생 시 합리적 범위에서 조정에 협조합니다.',
  },
  {
    title: '제5조 (회원의 의무)',
    body: '이용자는 타인의 정보를 도용하거나, 서비스 운영을 방해하거나, 허위 정보를 등록하여서는 안 됩니다. 위반 시 회사는 이용을 제한할 수 있습니다.',
  },
];

export default function TermsPage() {
  return (
    <>
      <AppHeader title="이용약관" back />
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

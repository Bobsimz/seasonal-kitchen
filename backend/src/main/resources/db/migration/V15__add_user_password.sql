-- 이메일/비밀번호 회원가입·로그인 지원. OAuth는 추후(oauth_accounts 별도).
-- 기존/OAuth/데모 사용자는 password_hash가 없을 수 있으므로 nullable.
ALTER TABLE users ADD COLUMN password_hash VARCHAR(255);

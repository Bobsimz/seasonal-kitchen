# 릴스 미디어 S3 업로드

레시피 릴스 영상/썸네일을 S3에 올리는 일회성 도구. 영상 메타데이터는 Flyway 시드(`V32__seed_reels.sql`)가 DB에 적재한다.

## 구조
- 영상: `s3://<bucket>/reels/{youtubeId}.mp4`
- 썸네일: `s3://<bucket>/thumbnails/{youtubeId}.webp`
- DB(`reels.video_url`/`thumbnail_url`)에는 **상대 key**(`reels/{id}.mp4`)만 저장한다.
  응답 시 `MediaUrlResolver`가 `app.uploads.public-base-url`(CloudFront 도메인)을 prepend한다 → 환경 독립적.

## 실행
```bash
cd backend/tools/reels
ENV_FILE=../../../env REELS_DIR=~/babsimz/seasonal-kitchen-reels ./upload_reels.sh --dry-run  # 미리보기
ENV_FILE=../../../env REELS_DIR=~/babsimz/seasonal-kitchen-reels ./upload_reels.sh            # 실제 업로드
```
`aws s3 sync`라 재실행해도 변경분만 올린다(idempotent).

## env 필수 키
`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`(=`ap-northeast-2`), `S3_BUCKET`.
IAM 최소권한: `s3:PutObject`/`s3:GetObject`.

> 주의: `AWS_REGION`이 `ap-northeast-2`가 아니면(예: 오타 `am-northeast-2`) 백엔드 앱의 S3 업로드도 실패한다.
> 스크립트는 비정상 리전을 `ap-northeast-2`로 보정하지만, 앱을 위해 env 자체를 바로잡아야 한다.

#!/bin/bash
# 릴스 영상/썸네일을 S3에 업로드한다 (앱 업로드 API는 5MB 캡이라 대량 영상은 이 스크립트로 직접 올린다).
#   영상  {dir}/{id}.mp4  → s3://$S3_BUCKET/reels/{id}.mp4       (Content-Type video/mp4)
#   썸네일 {dir}/{id}.webp → s3://$S3_BUCKET/thumbnails/{id}.webp (Content-Type image/webp)
# DB(V32)에는 상대 key(reels/{id}.mp4)만 저장하고, 응답 시 MediaUrlResolver가 CloudFront 도메인을 붙인다.
#
# 사용법:
#   REELS_DIR=~/babsimz/seasonal-kitchen-reels ENV_FILE=./env ./upload_reels.sh [--dry-run]
# 필요한 env 키: AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_REGION(ap-northeast-2), S3_BUCKET
set -euo pipefail

ENV_FILE="${ENV_FILE:-$(git rev-parse --show-toplevel)/env}"
REELS_DIR="${REELS_DIR:-$HOME/babsimz/seasonal-kitchen-reels}"
DRY=""; [ "${1:-}" = "--dry-run" ] && DRY="--dryrun"

# env 파일에서 필요한 키만 안전 추출(전체 source는 특수문자 값에서 깨질 수 있음)
getval() { grep -E "^$1=" "$ENV_FILE" | head -1 | cut -d= -f2-; }
export AWS_ACCESS_KEY_ID="$(getval AWS_ACCESS_KEY_ID)"
export AWS_SECRET_ACCESS_KEY="$(getval AWS_SECRET_ACCESS_KEY)"
export AWS_REGION="$(getval AWS_REGION)"; export AWS_DEFAULT_REGION="$AWS_REGION"
BUCKET="$(getval S3_BUCKET)"

# 리전 오타 방어: 버킷명에 ap-northeast-2가 들어가면 그 값으로 보정
case "$AWS_REGION" in ap-*) ;; *) echo "[warn] AWS_REGION='$AWS_REGION' 비정상 → ap-northeast-2로 보정"; export AWS_REGION=ap-northeast-2; export AWS_DEFAULT_REGION=ap-northeast-2;; esac

[ -n "$BUCKET" ] || { echo "S3_BUCKET 미설정 ($ENV_FILE)"; exit 1; }
aws sts get-caller-identity >/dev/null || { echo "AWS 자격증명 인증 실패"; exit 1; }

echo "[upload] videos → s3://$BUCKET/reels/"
aws s3 sync "$REELS_DIR" "s3://$BUCKET/reels/" $DRY \
  --exclude "*" --include "*.mp4" --exclude "_excluded/*" --content-type video/mp4 --no-progress
echo "[upload] thumbnails → s3://$BUCKET/thumbnails/"
aws s3 sync "$REELS_DIR" "s3://$BUCKET/thumbnails/" $DRY \
  --exclude "*" --include "*.webp" --exclude "_excluded/*" --content-type image/webp --no-progress
echo "[done] reels=$(aws s3 ls s3://$BUCKET/reels/ --recursive | grep -c '\.mp4'), thumbnails=$(aws s3 ls s3://$BUCKET/thumbnails/ --recursive | grep -c '\.webp')"

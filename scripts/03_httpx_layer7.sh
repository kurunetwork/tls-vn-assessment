#!/bin/bash
set -euo pipefail

HTTPX_BIN="/home/hop/go/bin/httpx"
INPUT_TXT="domains_for_httpx.txt"
OUTPUT_JSON="httpx.json"
TMP_FILE="httpx_raw.tmp"

echo "================================================="
echo "🚀 BƯỚC 3: QUÉT HẠ TẦNG & HSTS (HTTPX TURBO)"
echo "================================================="

# -p 443: Bỏ qua port 80, chỉ đánh thẳng vào HTTPS (Tiết kiệm 50% thời gian)
# -threads 200 -rate-limit 1500: Mở tối đa công suất máy
# -timeout 5: Giảm thời gian chờ những web bị sập
# -stats: Hiển thị tiến độ % ra màn hình cho đỡ sốt ruột
# -irh: BẮT BUỘC để lấy HSTS
cat "$INPUT_TXT" | $HTTPX_BIN \
  -p 443 \
  -ip -status-code -title -web-server -cdn -asn -irh -json -silent \
  -threads 200 -rate-limit 1500 -timeout 5 -retries 1 -follow-redirects -stats \
  > "$TMP_FILE" || true

echo "🧹 Đang lọc trùng lặp dữ liệu..."
jq -s 'unique_by(.input // .host // .url)[]' "$TMP_FILE" > "$OUTPUT_JSON" || true
rm -f "$TMP_FILE"

echo "✅ Đã quét xong Layer 7 bằng HTTPX"

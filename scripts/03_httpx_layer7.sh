#!/bin/bash
set -euo pipefail

HTTPX_BIN="/home/hop/go/bin/httpx"
INPUT_TXT="domains_for_httpx.txt"
OUTPUT_JSON="httpx.json"
TMP_FILE="httpx_raw.tmp"

echo "================================================="
echo "🚀 BƯỚC 3: QUÉT HẠ TẦNG & HSTS"
echo "================================================="

# Đã điều chỉnh cho mạng bình thường:
# -l: Đọc trực tiếp từ file (chuẩn và tối ưu hơn dùng cat)
# -threads 50 -rate-limit 150: Chậm lại để tránh rớt gói tin và lách WAF chặn IP
# -timeout 10: Tăng thời gian chờ lên 10s để không bỏ sót các server phản hồi chậm
# -retries 2: Nếu request đầu thất bại do nghẽn mạng, httpx sẽ thử lại thêm lần nữa
$HTTPX_BIN -l "$INPUT_TXT" \
  -p 443 \
  -ip -status-code -title -web-server -cdn -asn -irh -json -silent \
  -threads 50 -rate-limit 150 -timeout 10 -retries 2 -follow-redirects -stats \
  -o "$TMP_FILE" || true

echo "🧹 Đang lọc trùng lặp dữ liệu..."
# Kiểm tra xem file tmp có tồn tại và có dữ liệu không trước khi dùng jq
if [ -s "$TMP_FILE" ]; then
    jq -s 'unique_by(.input // .host // .url)[]' "$TMP_FILE" > "$OUTPUT_JSON" || true
    rm -f "$TMP_FILE"
    echo "✅ Đã quét xong Layer 7 bằng HTTPX. Kết quả lưu tại: $OUTPUT_JSON"
else
    echo "⚠️ HTTPX không trả về dữ liệu nào hoặc file đầu vào bị trống."
fi

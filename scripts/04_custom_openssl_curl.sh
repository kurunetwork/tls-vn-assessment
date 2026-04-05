#!/bin/bash
set -euo pipefail

# Nạp đường dẫn phòng trường hợp Ubuntu quên lệnh tls_checker
export PATH="$HOME/.local/bin:$PATH"

INPUT_TXT="domains_for_httpx.txt"
RAW_OUT="alpn_raw.txt"
CSV_OUT="alpn_parsed.csv"
DICT_JSON="custom_dict.json"

echo "================================================="
echo "🚀 BƯỚC 4: QUÉT ALPN BẰNG TLS_CHECKER"
echo "================================================="

echo "⏳ Đang chạy 50 luồng cùng lúc, vui lòng đợi vài phút..."
tls_checker -i "$INPUT_TXT" -t 50 --timeout 5s --retries 2 --no-asn -o "$RAW_OUT" || true

echo "🧹 Đang bóc tách dữ liệu ALPN từ log..."

# Đã sửa lỗi grep "CN:" để loại bỏ dòng Summary rác
grep "CN:" "$RAW_OUT" | awk '{
    domain = $2;
    sub(/:[0-9]+$/, "", domain);
    alpn = "N/A";
    for (i=1; i<=NF; i++) {
        if ($i ~ /^ALPN:/) {
            alpn = substr($i, 6);
            break;
        }
    }
    print domain "," alpn;
}' > "$CSV_OUT"

echo "🧩 Đang chuyển đổi thành định dạng JSON để gộp dữ liệu..."
jq -R -s '
  split("\n") | map(select(length > 0) | split(",") | {key: .[0], value: {alpn: .[1]}}) | from_entries
' "$CSV_OUT" > "$DICT_JSON"

rm -f "$RAW_OUT" "$CSV_OUT"
echo "✅ Đã trích xuất xong dữ liệu ALPN siêu tốc!"

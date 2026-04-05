#!/bin/bash
set -euo pipefail

INPUT_CSV="domain.csv"
OUTPUT_TXT="domain_vn.txt"

echo "================================================="
echo "🔎 BƯỚC 1: LỌC TÊN MIỀN .VN"
echo "================================================="

if [ ! -f "$INPUT_CSV" ]; then
    echo "❌ LỖI: Không tìm thấy file $INPUT_CSV"
    exit 1
fi

cut -d',' -f2 "$INPUT_CSV" | tr -d '\r' | grep -E '\.vn$' | sort -u > "$OUTPUT_TXT" || true

total_vn=$(wc -l < "$OUTPUT_TXT")
echo "✅ Đã lọc thành công $total_vn domain .vn"
if [ "$total_vn" -eq 0 ]; then
    echo "❌ Không có domain nào. Dừng lại!"
    exit 1
fi

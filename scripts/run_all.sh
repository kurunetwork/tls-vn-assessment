#!/bin/bash
# File tổng chỉ huy

START_TIME=$(date)
echo "🚀 KHỞI ĐỘNG HỆ THỐNG QUÉT (Time: $START_TIME)"

# Cấp quyền cho toàn bộ file (chỉ cần chạy lần đầu)
chmod +x 01_filter_vn.sh 02_zgrab_tls.sh 03_httpx_layer7.sh 04_custom_openssl_curl.sh 05_final_merge.sh

./01_filter_vn.sh
./02_zgrab_tls.sh
./03_httpx_layer7.sh
./04_custom_openssl_curl.sh
./05_final_merge.sh

echo "🕒 Kết thúc lúc: $(date)"

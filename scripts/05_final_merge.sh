#!/bin/bash
set -euo pipefail

HTTPX_JSON="httpx.json"
TLS_DICT="tls_dict.json"
CUSTOM_DICT="custom_dict.json"
RESULT_CSV="result.csv"

echo "================================================="
echo "🧹 BƯỚC 5: TỔNG HỢP & XUẤT KẾT QUẢ BÁO CÁO"
echo "================================================="

echo "Domain,Status_Code,Title,Webserver,Final_CDN,TLS_Version,Cipher_Suite,Certificate_Issuer,ALPN,HSTS" > "$RESULT_CSV"

jq -r --slurpfile tls "$TLS_DICT" --slurpfile cust "$CUSTOM_DICT" '
  select(.input != null or .host != null or .url != null) |
  
  # Lấy domain thô (chỉ bỏ protocol và dấu / cuối)
  (.input // .host // .url | tostring | sub("^https?://"; "") | sub("/$"; "")) as $raw_domain |
  # Lấy domain chuẩn hóa (bỏ thêm www.)
  ($raw_domain | sub("^www\\."; "")) as $norm_domain |
  select($raw_domain != "") |
  
  # CƠ CHẾ FALLBACK MAPPING: Tìm bản normalize trước, nếu null thì tìm bản raw
  ($tls[0][$norm_domain] // $tls[0][$raw_domain]) as $t | select($t != null) |
  ($cust[0][$norm_domain] // $cust[0][$raw_domain] // {alpn: "N/A"}) as $c |
  
  (.webserver // "" | ascii_downcase) as $ws |
  (.asn.asn // "" | tostring | ascii_downcase) as $asn |
  
  (if ($ws | test("cloudflare|akamai|fastly|cloudfront")) then "YES"
   elif ($asn | test("cloudflare|akamai|fastly|amazon|cdnetworks")) then "YES"
   elif .cdn == true then "YES"
   else "NO" end) as $final_cdn |
   
  # CƠ CHẾ BẮT HSTS AN TOÀN (Bao phủ cả .header và .headers)
  (if (
    (.header != null and (
        .header["strict-transport-security"] != null or 
        .header["Strict-Transport-Security"] != null or 
        .header["strict_transport_security"] != null
    )) or
    (.headers != null and (
        .headers["strict-transport-security"] != null or 
        .headers["Strict-Transport-Security"] != null or
        .headers["strict_transport_security"] != null
    ))
  ) then "YES" else "NO" end) as $hsts |
  
  [
    $norm_domain, (.status_code // "N/A"), (.title // "N/A" | tostring | gsub(","; " ")),
    (.webserver // "N/A" | tostring | gsub(","; " ")), $final_cdn,
    ($t.tls // "N/A" | tostring | gsub(","; " ")), ($t.cipher // "N/A" | tostring | gsub(","; " ")),
    ($t.issuer // "N/A" | tostring | gsub(","; " ")), ($c.alpn // "N/A" | tostring | gsub(","; " ")),
    $hsts
  ] | @csv
' "$HTTPX_JSON" >> "$RESULT_CSV"

# ------------------------------------------------------------------------------
# 6. THỐNG KÊ
# ------------------------------------------------------------------------------
echo "=========================================================================="
echo "📊 THỐNG KÊ KẾT QUẢ NGHIÊN CỨU"
echo "=========================================================================="

valid_scanned=$(($(wc -l < "$RESULT_CSV") - 1))

tls13=$(awk -F, 'NR>1 && $6 ~ /TLSv1\.3/ {c++} END {print c+0}' "$RESULT_CSV")
tls12=$(awk -F, 'NR>1 && $6 ~ /TLSv1\.2/ {c++} END {print c+0}' "$RESULT_CSV")
tls11=$(awk -F, 'NR>1 && $6 ~ /TLSv1\.1/ {c++} END {print c+0}' "$RESULT_CSV")
tls10=$(awk -F, 'NR>1 && $6 ~ /TLSv1\.0/ {c++} END {print c+0}' "$RESULT_CSV")

h2=$(awk -F, 'NR>1 && $9=="\"h2\"" {c++} END {print c+0}' "$RESULT_CSV")
h2_pct=$(awk -v c="$h2" -v t="$valid_scanned" 'BEGIN {printf "%.2f", (t>0 ? c/t*100 : 0)}')
http11=$(awk -F, 'NR>1 && $9=="\"http/1.1\"" {c++} END {print c+0}' "$RESULT_CSV")
http11_pct=$(awk -v c="$http11" -v t="$valid_scanned" 'BEGIN {printf "%.2f", (t>0 ? c/t*100 : 0)}')

# Thêm thống kê HSTS
hsts_yes=$(awk -F, 'NR>1 && $10=="\"YES\"" {c++} END {print c+0}' "$RESULT_CSV")
hsts_pct=$(awk -v c="$hsts_yes" -v t="$valid_scanned" 'BEGIN {printf "%.2f", (t>0 ? c/t*100 : 0)}')

cdn_detected=$(awk -F, 'NR>1 && $5=="\"YES\"" {c++} END {print c+0}' "$RESULT_CSV")
percent_cdn=$(awk -v c="$cdn_detected" -v t="$valid_scanned" 'BEGIN {printf "%.2f", (t>0 ? c/t*100 : 0)}')

cloudflare=$(awk -F, 'NR>1 && (tolower($4) ~ /cloudflare/ || tolower($3) ~ /cloudflare/) {c++} END {print c+0}' "$RESULT_CSV")
akamai=$(awk -F, 'NR>1 && (tolower($4) ~ /akamai/ || tolower($3) ~ /akamai/) {c++} END {print c+0}' "$RESULT_CSV")
fastly=$(awk -F, 'NR>1 && (tolower($4) ~ /fastly/ || tolower($3) ~ /fastly/) {c++} END {print c+0}' "$RESULT_CSV")
cloudfront=$(awk -F, 'NR>1 && (tolower($4) ~ /cloudfront/ || tolower($3) ~ /amazon/) {c++} END {print c+0}' "$RESULT_CSV")
vn_infra=$(awk -F, 'NR>1 && (tolower($4) ~ /vnpt|viettel|fpt/ || tolower($3) ~ /vnpt|viettel|fpt/) {c++} END {print c+0}' "$RESULT_CSV")

echo "🔒 PHÂN BỔ TLS VERSION:"
echo "   - TLS 1.3 : $tls13"
echo "   - TLS 1.2 : $tls12"
echo "   - TLS 1.1 : $tls11"
echo "   - TLS 1.0 : $tls10"
echo "--------------------------------------------------------------------------"
echo "🛡️ CHỈ SỐ BẢO MẬT & HIỆU NĂNG NÂNG CAO:"
echo "   - Kích hoạt HSTS (HTTPX)     : $hsts_yes ($hsts_pct%)"
echo "   - Hỗ trợ HTTP/2 (ALPN: h2)   : $h2 ($h2_pct%)"
echo "   - Hỗ trợ HTTP/1.1            : $http11 ($http11_pct%)"
echo "--------------------------------------------------------------------------"
echo "🌐 MỨC ĐỘ ÁP DỤNG CDN:"
echo "   - Tổng domain hợp lệ phân tích : $valid_scanned"
echo "   - Bắt được CDN (Global Edge)   : $cdn_detected ($percent_cdn %)"
echo "--------------------------------------------------------------------------"
echo "🔐 TOP 5 CIPHER SUITES (ĐỘ PHỔ BIẾN):"
awk -F',' 'NR>1 {gsub(/"/, "", $7); print $7}' "$RESULT_CSV" | sort | uniq -c | sort -nr | head -n 5 | awk -v total="$valid_scanned" '{ count=$1; $1=""; name=substr($0,2); printf "   - %-40s : %5d (%.2f%%)\n", name, count, (count/total)*100 }'
echo "--------------------------------------------------------------------------"
echo "📜 TOP 5 CERTIFICATE ISSUERS (ĐỘ PHỔ BIẾN):"
awk -F',' 'NR>1 {gsub(/"/, "", $8); print $8}' "$RESULT_CSV" | sort | uniq -c | sort -nr | head -n 5 | awk -v total="$valid_scanned" '{ count=$1; $1=""; name=substr($0,2); printf "   - %-40s : %5d (%.2f%%)\n", name, count, (count/total)*100 }'
echo "--------------------------------------------------------------------------"
echo "🏭 TOP PROVIDERS / INFRASTRUCTURE:"
echo "   - Cloudflare : $cloudflare"
echo "   - Akamai     : $akamai"
echo "   - Fastly     : $fastly"
echo "   - CloudFront : $cloudfront"
echo "   - VN Infra   : $vn_infra (ISP/Hosting nội địa - Không tính vào CDN)"
echo "=========================================================================="
echo "🏁 HOÀN TẤT!"
echo "🕒 Thời gian kết thúc: $(date)"
echo "📊 File báo cáo: $RESULT_CSV"

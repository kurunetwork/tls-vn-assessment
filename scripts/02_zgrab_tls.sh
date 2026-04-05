#!/bin/bash
set -euo pipefail

INPUT_TXT="domain_vn.txt"
SCAN_JSON="scan.json"
VALID_TXT="domains_for_httpx.txt"
DICT_JSON="tls_dict.json"

echo "================================================="
echo "🚀 BƯỚC 2: QUÉT TLS BẰNG ZGRAB2"
echo "================================================="

total=$(wc -l < "$INPUT_TXT")
echo "Đang quét $total domain..."
cat "$INPUT_TXT" | zgrab2 tls --port 443 --senders 50 -o "$SCAN_JSON"

echo "🧹 Đang trích xuất chứng chỉ hợp lệ..."
jq -r 'select(.data.tls.result.handshake_log.server_certificates.certificate.parsed != null) | 
       .domain | sub("^www\\."; "")' "$SCAN_JSON" | sort -u > "$VALID_TXT"

total_valid=$(wc -l < "$VALID_TXT")
echo "✅ Có $total_valid domain sở hữu chứng chỉ hợp lệ."

# Tạo file từ điển TLS
jq -s '
  map(select(.data.tls.result.handshake_log.server_certificates.certificate.parsed != null) |
      {
        ((.domain | tostring | sub("^https?://"; "") | sub("/$"; "") | sub("^www\\."; ""))): {
          tls: ((.data.tls.result.handshake_log.server_hello.supported_versions.selected_version.name // .data.tls.result.handshake_log.server_hello.version.name // "N/A") | tostring | sub("TLS_"; "TLSv") | gsub("_"; ".")),
          cipher: (.data.tls.result.handshake_log.server_hello.cipher_suite.name // "N/A"),
          issuer: (.data.tls.result.handshake_log.server_certificates.certificate.parsed.issuer.common_name[0] // "N/A")
        }
      }) | add
' "$SCAN_JSON" > "$DICT_JSON"

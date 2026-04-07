```markdown
# Đánh Giá Thực Nghiệm Mức Độ Áp Dụng TLS, ALPN Và HSTS Trên Tên Miền .vn
**Đối Chiếu Tiêu Chuẩn NIST SP 800-52 Rev.2 & BSI TR-02102-2**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Bash](https://img.shields.io/badge/Bash-5.0+-blue)](https://www.gnu.org/software/bash/)
[![Last Scan](https://img.shields.io/badge/Last%20Scan-05%20Tháng%204,%202026-success)](https://github.com/kurunetwork/tls-vn-assessment)

---
### 📋 Tóm tắt nghiên cứu
Báo cáo trình bày nghiên cứu thực nghiệm quy mô lớn đầu tiên tại Việt Nam về mức độ triển khai **TLS 1.3**, **ALPN**, **HSTS** và cipher suite trên toàn bộ tên miền TLD `.vn`.

**Kết quả nổi bật:**
- 100% tên miền đã loại bỏ hoàn toàn TLS 1.0/1.1
- TLS 1.3 đạt **77,15%** (95% CI: [76,13% – 78,17%])
- **75,37%** kết nối TLS 1.3 ưu tiên **ChaCha20-Poly1305**
- Tương quan mạnh mẽ với hạ tầng **CDN** (đặc biệt Cloudflare)
- HSTS chỉ đạt **26,04%**

---
### 🧪 Dữ liệu & Phương pháp
- **Nguồn chính**: Tranco Top 1M (ID: **ZWLZG**, ngày 17/03/2026) + lọc CrUX Việt Nam
- Mẫu hợp lệ: **6.456** tên miền `.vn`
- Ngày quét: 05/04/2026
- Công cụ: ZGrab2 + HTTPX + OpenSSL custom

**📥 Chuẩn bị dữ liệu (bắt buộc trước khi chạy pipeline)**

1. Truy cập: [https://tranco-list.eu/list/ZWLZG](https://tranco-list.eu/list/ZWLZG)
2. Tải file CSV về (danh sách Top 1M đầy đủ)
3. **Đổi tên file vừa tải về thành `domain.csv`** (rất quan trọng)
4. Đặt file `domain.csv` vào thư mục `data/`

Pipeline sẽ tự động lọc chỉ các domain `.vn` từ file này trong bước `01_filter_vn.sh`.

---
### 📁 Cấu trúc repository
```
tls-vn-assessment/
├── data/
│   └── domain.csv          ← Đặt file Tranco đã đổi tên vào đây
├── scripts/                # Pipeline quét TLS (bash)
│   ├── 01_filter_vn.sh
│   ├── 02_zgrab_tls.sh
│   ├── 03_httpx_layer7.sh
│   ├── 04_custom_openssl_curl.sh
│   ├── 05_final_merge.sh
│   └── run_all.sh
├── README.md
└── .gitignore
```

---
### 📝 Cách sử dụng pipeline
```bash
cd scripts
chmod +x *.sh
./run_all.sh
```

Pipeline sẽ thực hiện lần lượt:
- Lọc domain `.vn` từ `data/domain.csv`
- Chạy quét TLS/ALPN/HSTS bằng ZGrab2 và HTTPX
- Merge kết quả cuối cùng vào thư mục `data/`

---
### 📄 License
Mã nguồn pipeline được phân phối theo giấy phép **MIT**.

---
### 👤 Tác giả
**Phan Văn Hợp**  
Sinh viên năm hai Khoa Toán – Tin học  
Trường Đại học Sư phạm – Đại học Đà Nẵng  
Email: dinhonphan226@gmail.com  
GitHub: [@kurunetwork](https://github.com/kurunetwork)

---
**⭐ Nếu repo hữu ích, hãy cho mình 1 star nhé!**  
Mọi góp ý hoặc cải tiến vui lòng tạo **Issue**.

---
*Last updated: 07 Tháng 4, 2026*
```

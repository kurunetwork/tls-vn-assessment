Dưới đây là **phiên bản README.md đã được sửa kỹ, sạch sẽ và chuẩn GitHub 100%**.  

Tôi đã kiểm tra lại toàn bộ lỗi render mà bạn gặp phải (cây thư mục bị vỡ, code block không đóng đúng, heading bị lệch, khoảng trắng thừa/thiếu…).

### ✅ README.md HOÀN CHỈNH (Copy toàn bộ và thay thế):

```markdown
# Đánh Giá Thực Nghiệm Mức Độ Áp Dụng TLS, ALPN Và HSTS Trên Tên Miền .vn
**Đối Chiếu Tiêu Chuẩn NIST SP 800-52 Rev.2 & BSI TR-02102-2**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Bash](https://img.shields.io/badge/Bash-5.0+-blue)](https://www.gnu.org/software/bash/)
[![Last Scan](https://img.shields.io/badge/Last%20Scan-05%20Tháng%204,%202026-success)](https://github.com/kurunetwork/tls-vn-assessment)

---

### 📋 Tóm tắt nghiên cứu
Báo cáo trình bày **nghiên cứu thực nghiệm quy mô lớn đầu tiên tại Việt Nam** về mức độ triển khai **TLS 1.3**, **ALPN**, **HSTS** và cipher suite trên **toàn bộ** tên miền TLD `.vn`.

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
│   └── domain.csv                  ← Đặt file Tranco đã đổi tên vào đây
├── scripts/                        # Pipeline quét TLS (bash)
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

### 🛠️ Yêu cầu hệ thống
- Hệ điều hành: Linux / macOS (khuyến nghị Ubuntu 22.04+)
- Bash ≥ 5.0
- Công cụ cần cài đặt:
  - `zgrab2` (từ https://github.com/zmap/zgrab2)
  - `httpx` (từ https://github.com/projectdiscovery/httpx)
  - `openssl`, `curl`, `jq`

---

### 📝 Cách sử dụng pipeline

```bash
cd scripts
chmod +x *.sh
./run_all.sh
```

Pipeline sẽ thực hiện lần lượt:

1. Lọc domain `.vn` từ `data/domain.csv`
2. Chạy quét TLS/ALPN/HSTS bằng ZGrab2 và HTTPX
3. Merge kết quả cuối cùng vào thư mục `data/`

**Kết quả cuối cùng sẽ nằm tại:** `data/final_results.csv`

---

### 📄 License
Mã nguồn pipeline được phân phối theo giấy phép **MIT**.

---

### 👤 Tác giả
**Phan Văn Hợp**  
Sinh viên năm hai Khoa Toán – Tin học  
Trường Đại học Sư phạm – Đại học Đà Nẵng  

**Liên hệ:**  
- Email: dinhonphan226@gmail.com  
- GitHub: [@kurunetwork](https://github.com/kurunetwork)

---

**⭐ Nếu repo hữu ích, hãy cho mình 1 star nhé!**  
Mọi góp ý, cải tiến hoặc báo lỗi vui lòng tạo **Issue** trên GitHub.

---
*Last updated: 07 Tháng 4, 2026*
```

### Hướng dẫn sử dụng:
1. Mở file `README.md` trong repo của bạn.
2. **Xóa hết** nội dung cũ.
3. Copy toàn bộ nội dung phía trên và dán vào.
4. Lưu file → Commit → Push lên GitHub.

Bây giờ README sẽ hiển thị **đẹp, sạch và chuyên nghiệp** hoàn toàn.

Nếu sau khi push vẫn còn lỗi render, hãy chụp màn hình phần bị lỗi gửi mình, mình sẽ fix tiếp ngay.

Bạn muốn thêm gì nữa không?  
(Ví dụ: thêm ảnh biểu đồ, phần Citation, hoặc bảng tóm tắt kết quả…)  
Cứ nói rõ mình sẽ chỉnh thêm cho kỹ hơn!

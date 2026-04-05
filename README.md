
# Đánh Giá Thực Nghiệm Mức Độ Áp Dụng TLS, ALPN Và HSTS Trên Tên Miền .vn

**Đối Chiếu Tiêu Chuẩn NIST SP 800-52 Rev.2 & BSI TR-02102-2**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python](https://img.shields.io/badge/Python-3.10%2B-blue)](https://www.python.org/)
[![Last Scan](https://img.shields.io/badge/Last%20Scan-05%20Tháng%204,%202026-success)](https://github.com/KuruuCrypto/tls-vn-assessment)

---

### 📋 Tóm tắt nghiên cứu

Báo cáo trình bày nghiên cứu thực nghiệm quy mô lớn đầu tiên tại Việt Nam về mức độ triển khai **TLS 1.3**, **ALPN**, **HSTS** và cipher suite trên toàn bộ tên miền TLD `.vn` (dữ liệu Tranco tháng 3/2026).

**Kết quả nổi bật:**
- 100% tên miền đã loại bỏ hoàn toàn TLS 1.0/1.1
- TLS 1.3 đạt **77,15%** (95% CI: [76,13% – 78,17%])
- **75,37%** kết nối TLS 1.3 ưu tiên **ChaCha20-Poly1305** (Non-FIPS theo NIST)
- Tương quan mạnh mẽ với hạ tầng **CDN** (đặc biệt Cloudflare): Cramér’s V = 0.62, p < 0.001
- HSTS chỉ đạt **26,04%** → khoảng trống lớn về bảo vệ chống downgrade attack

Nghiên cứu chỉ ra sự phân nhánh rõ rệt giữa tiêu chuẩn **de facto** (CDN) và tiêu chuẩn **de jure** (NIST).

---

### 🧪 Dữ liệu & Phương pháp
- Nguồn: Tranco Top 1M (ID: ZWLZG, 17/03/2026) + lọc CrUX Việt Nam
- Mẫu hợp lệ: **6.456** tên miền .vn
- Công cụ: ZGrab2, TLS_Checker, HTTPX
- Ngày quét: 05/04/2026 (tại Việt Nam)
- Phân tích thống kê: Chi-square test + Cramér’s V + 95% Confidence Interval

---

### 📁 Cấu trúc repository

```
tls-vn-assessment/
├── paper/                  # Bài báo LaTeX (IEEE format)
│   ├── main.tex
│   ├── main.pdf
│   └── figures/
│       ├── pie_cipher_tls13.pdf
│       └── bar_chacha_cdn.pdf
├── src/                    # Mã nguồn pipeline quét
│   ├── zgrab_scan.py
│   ├── analyze_tls.py
│   └── detect_cdn.py
├── data/                   # Dữ liệu tóm tắt (anonymized)
│   ├── summary_stats.csv
│   └── cdn_breakdown.csv
├── requirements.txt
├── LICENSE
└── README.md
```

---

### 📊 Hình ảnh minh họa trong bài báo

- **Biểu đồ tròn**: Phân bố cipher suite TLS 1.3  
- **Biểu đồ cột**: Tỷ lệ ChaCha20-Poly1305 theo nhóm CDN / non-CDN

---

### 📝 Cách trích dẫn (BibTeX)

```bibtex
@article{phan2026tlsvn,
  author  = {Phan Văn Hợp},
  title   = {Đánh Giá Thực Nghiệm Mức Độ Áp Dụng TLS, ALPN Và HSTS Trên Tên Miền .vn: Đối Chiếu Tiêu Chuẩn NIST Và BSI},
  journal = {IEEE Access (đang xem xét)},
  year    = {2026},
  month   = {4},
  note    = {Preprint available at https://github.com/KuruuCrypto/tls-vn-assessment}
}
```

---

### 📄 License
Phân phối theo giấy phép **MIT** — bạn được tự do sử dụng, sửa đổi và phân phối mã nguồn.  
Dữ liệu tóm tắt được cấp phép **CC-BY-4.0**.

---

### 👤 Tác giả
**Phan Văn Hợp**  
Sinh viên năm hai Khoa Toán – Tin học  
Trường Đại học Sư phạm – Đại học Đà Nẵng  
Email: 3120224064@ued.udn.vn  
GitHub: [@KuruuCrypto](https://github.com/KuruuCrypto)

---

### 🙏 Cảm ơn
- ZMap Project (ZGrab2)
- ProjectDiscovery (HTTPX)
- Tranco Top Sites Ranking
- Cộng đồng an ninh mạng Việt Nam

---

**⭐ Nếu bạn thấy repo hữu ích, hãy cho mình 1 star nhé!**  
Mọi góp ý hoặc hợp tác vui lòng tạo Issue hoặc Pull Request.

---
*Last updated: 05 Tháng 4, 2026*
```

Xong! Repo của bạn giờ sẽ nhìn rất chuyên nghiệp luôn.

Bạn muốn mình làm thêm gì tiếp không?  
- Thêm ảnh preview (screenshot) vào README?  
- Tạo file `LICENSE`?  
- Hoặc hướng dẫn commit các file LaTeX + figures luôn?  

Cứ nói nhé! 🚀

# Bookingtourdulich
# ✈️ SMART TOUR

Ứng dụng đặt tour du lịch thông minh bằng **Python + Streamlit + MySQL**.

## 1. Chức năng

### Khách hàng
- Đăng ký / đăng nhập.
- Tìm tour theo điểm đến.
- Nhập ngày đi, số người, ngân sách.
- Tính tiền tour + tiền phòng + tổng chi phí.
- Cảnh báo vượt ngân sách.
- Gợi ý phương án tiết kiệm.
- Đặt tour và thanh toán mô phỏng.
- Xem lịch sử đơn.

### Admin
- Dashboard khách hàng, tour, booking, doanh thu.
- Thêm/xóa tour.
- Thêm khách sạn và phòng.
- Xem và xác nhận/hủy booking.
- Theo dõi số phòng còn lại.

### Smart Tour
Có ô nhập nhu cầu tự nhiên, ví dụ:

> Tôi có 5 triệu, muốn đi Vũng Tàu 3 ngày 2 đêm, 2 người, thích biển + ăn uống

Bản mặc định dùng bộ phân tích chuỗi bằng Python nên **không cần API AI**. Có thể thay thế `parse_smart_request()` bằng OpenAI API sau này.

## 2. Yêu cầu

- Python 3.10+
- MySQL 8+
- Git

## 3. Cài đặt

```bash
git clone <URL_REPOSITORY_CUA_BAN>
cd smart-tour

python -m venv .venv
```

Windows:

```bash
.venv\\Scripts\\activate
```

macOS/Linux:

```bash
source .venv/bin/activate
```

Cài thư viện:

```bash
pip install -r requirements.txt
```

## 4. Tạo database

Đăng nhập MySQL:

```bash
mysql -u root -p
```

Sau đó:

```sql
SOURCE schema.sql;
```

Hoặc chạy file `schema.sql` bằng MySQL Workbench.

## 5. Cấu hình tài khoản MySQL

Copy:

```text
.env.example
```

thành:

```text
.env
```

Ví dụ:

```env
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=mat_khau_mysql_cua_ban
DB_NAME=smart_tour
```

**Không commit `.env` lên GitHub.** File `.gitignore` đã có `.env`.

## 6. Tạo tài khoản Admin

1. Chạy ứng dụng.
2. Đăng ký một tài khoản.
3. Trong MySQL chạy:

```sql
USE smart_tour;

UPDATE customers
SET role='admin'
WHERE username='TEN_DANG_NHAP_ADMIN';
```

Sau đó đăng xuất/đăng nhập lại.

## 7. Chạy ứng dụng

```bash
streamlit run app.py
```

Mở địa chỉ mà Streamlit hiển thị, thường là:

```text
http://localhost:8501
```

## 8. Đưa lên GitHub

```bash
git init
git add .
git commit -m "Initial SMART TOUR application"
git branch -M main
git remote add origin <URL_GITHUB_CUA_BAN>
git push -u origin main
```

### Lưu ý bảo mật

- Không ghi username/password MySQL trực tiếp trong source code.
- Không đưa `.env` lên GitHub.
- Đây là bản demo/đồ án. Phần thanh toán hiện chỉ mô phỏng.
- Với môi trường thật nên dùng password hashing mạnh như Argon2/bcrypt, session management an toàn, CSRF protection, validation sâu hơn và cổng thanh toán thật.

## 9. Cấu trúc

```text
smart-tour/
├── app.py
├── database.py
├── auth.py
├── customer.py
├── admin.py
├── smart_tour.py
├── schema.sql
├── requirements.txt
├── .env.example
├── .gitignore
└── README.md
```


import hashlib
import hmac
from database import fetch_one, execute

def hash_password(password: str) -> str:
    return hashlib.sha256(password.encode("utf-8")).hexdigest()

def register_user(full_name, email, phone, username, password):
    if not all([full_name, email, username, password]):
        return False, "Vui lòng nhập đầy đủ thông tin bắt buộc."

    if fetch_one("SELECT id FROM customers WHERE username=%s", (username,)):
        return False, "Tên đăng nhập đã tồn tại."

    if fetch_one("SELECT id FROM customers WHERE email=%s", (email,)):
        return False, "Email đã được sử dụng."

    execute(
        """INSERT INTO customers(full_name,email,phone,username,password_hash)
           VALUES(%s,%s,%s,%s,%s)""",
        (full_name, email, phone, username, hash_password(password)),
    )
    return True, "Đăng ký thành công. Bạn có thể đăng nhập."

def login_user(username, password):
    row = fetch_one(
        """SELECT id, full_name, email, phone, username, password_hash, role, is_active
           FROM customers WHERE username=%s""",
        (username,),
    )
    if not row or not row["is_active"]:
        # Admin is stored in the same table with role=admin in this starter.
        return None

    if hmac.compare_digest(row["password_hash"], hash_password(password)):
        row.pop("password_hash", None)
        return row
    return None

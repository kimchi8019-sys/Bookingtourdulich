import streamlit as st
from auth import register_user, login_user
from customer import render_customer
from admin import render_admin
from database import init_db

st.set_page_config(page_title="SMART TOUR", page_icon="✈️", layout="wide")

@st.cache_resource
def initialize_database():
    return init_db()

try:
    initialize_database()
except Exception as e:
    st.error("Không thể kết nối MySQL. Kiểm tra file .env và cấu hình MySQL trong README.")
    st.code(str(e))
    st.stop()

if "user" not in st.session_state:
    st.session_state.user = None

st.sidebar.title("✈️ SMART TOUR")

if st.session_state.user:
    user = st.session_state.user
    st.sidebar.success(f"Xin chào, {user['full_name']}")
    if st.sidebar.button("Đăng xuất"):
        st.session_state.user = None
        st.rerun()

    if user["role"] == "admin":
        render_admin()
    else:
        render_customer()
else:
    tab_login, tab_register = st.tabs(["Đăng nhập", "Đăng ký"])

    with tab_login:
        st.subheader("Đăng nhập")
        username = st.text_input("Tên đăng nhập", key="login_username")
        password = st.text_input("Mật khẩu", type="password", key="login_password")
        if st.button("Đăng nhập", type="primary"):
            user = login_user(username, password)
            if user:
                st.session_state.user = user
                st.rerun()
            else:
                st.error("Tên đăng nhập hoặc mật khẩu không đúng.")

    with tab_register:
        st.subheader("Tạo tài khoản khách hàng")
        full_name = st.text_input("Họ và tên", key="reg_name")
        email = st.text_input("Email", key="reg_email")
        phone = st.text_input("Số điện thoại", key="reg_phone")
        username = st.text_input("Tên đăng nhập", key="reg_username")
        password = st.text_input("Mật khẩu", type="password", key="reg_password")
        password2 = st.text_input("Nhập lại mật khẩu", type="password", key="reg_password2")
        if st.button("Đăng ký"):
            if password != password2:
                st.error("Hai mật khẩu không khớp.")
            else:
                ok, msg = register_user(full_name, email, phone, username, password)
                (st.success if ok else st.error)(msg)


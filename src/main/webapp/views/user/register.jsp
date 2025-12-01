<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <%@ include file="/common/taglib.jsp" %>
            <%@ include file="/common/headlink.jsp" %>
                <%@ include file="/common/loginregisterlink.jsp" %>
                    <meta charset="UTF-8">
                    <title>Register</title>
                    <meta content="width=device-width, initial-scale=1.0" name="viewport">
                    <meta content="" name="keywords">
                    <meta content="" name="description">
    </head>

    <body>
        <%@ include file="/common/header.jsp" %>


            <div class="container-fluid py-12 mb-12 hero-header">
                <div class="container py-12">
                    <div class="row g-12 align-items-center">
                        <div class="main">

                            <!-- Sign up form -->
                            <section class="signup">
                                <div class="container">
                                    <div class="signup-content d-flex">
                                        <div class="signup-form">
                                            <h2 class="form-title">ĐĂNG KÝ TÀI KHOẢN</h2>
                                            <form method="POST" class="register-form" id="register-form">
                                                <div class="form-group">
                                                    <label for="name"><i
                                                            class="zmdi zmdi-account material-icons-name"></i></label>
                                                    <input type="text" name="username" id="username"
                                                        placeholder="Tên Tài Khoản" />
                                                </div>
                                                <div class="form-group">
                                                    <label for="email"><i class="zmdi zmdi-email"></i></label>
                                                    <input type="email" name="email" id="email"
                                                        placeholder="Email Của Bạn" />
                                                </div>
                                                <div class="form-group">
                                                    <label for="pass"><i class="zmdi zmdi-lock"></i></label>
                                                    <input type="password" name="password" id="password"
                                                        placeholder="Nhập Mật Khẩu" />
                                                </div>
                                                <div class="form-group">
                                                    <label for="re-pass"><i class="zmdi zmdi-lock-outline"></i></label>
                                                    <input type="password" name="re_pass" id="re_pass"
                                                        placeholder="Xác Nhận Mật Khẩu" />
                                                </div>
                                                <div class="form-group form-button">
                                                    <input type="submit" name="signup" id="signup" class="form-submit"
                                                        value="Đăng Ký" />
                                                </div>
                                            </form>
                                        </div>
                                        <div class="signup-image">
                                            <figure><img
                                                    src="<c:url value='templates/login_register/images/signup-image.png' />"
                                                    alt="sing up image"></figure>
                                            <a href="<c:url value ='login'/>" class="signup-image-link">TÔI ĐÃ CÓ TÀI
                                                KHOẢN ?</a>
                                        </div>
                                    </div>
                                </div>
                            </section>
                        </div>
                    </div>
                </div>



                <%@ include file="/common/footer.jsp" %>
                    <%@ include file="/common/lastBodyScript.jsp" %>
                        <jsp:include page="/common/chatbot.jsp" />
                        <script src="<c:url value='templates/login_register/vendor/jquery/jquery.min.js' />"></script>

                        <!-- JavaScript Validation cho Đăng ký (Câu 1b - Phần 1) -->
                        <script>
                            document.getElementById('register-form').addEventListener('submit', function (e) {
                                // Lấy giá trị từ form
                                const username = document.getElementById('username').value.trim();
                                const email = document.getElementById('email').value.trim();
                                const password = document.getElementById('password').value;
                                const rePassword = document.getElementById('re_pass').value;

                                // 1. Kiểm tra username không được rỗng
                                if (username === '') {
                                    e.preventDefault();
                                    alert('❌ Tên tài khoản không được để trống!');
                                    document.getElementById('username').focus();
                                    return false;
                                }

                                // 2. Kiểm tra username phải có ít nhất 3 ký tự
                                if (username.length < 3) {
                                    e.preventDefault();
                                    alert('❌ Tên tài khoản phải có ít nhất 3 ký tự!');
                                    document.getElementById('username').focus();
                                    return false;
                                }

                                // 3. Kiểm tra email không được rỗng
                                if (email === '') {
                                    e.preventDefault();
                                    alert('❌ Email không được để trống!');
                                    document.getElementById('email').focus();
                                    return false;
                                }

                                // 4. Kiểm tra định dạng email hợp lệ
                                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                                if (!emailRegex.test(email)) {
                                    e.preventDefault();
                                    alert('❌ Email không đúng định dạng! Vui lòng nhập email hợp lệ (ví dụ: example@gmail.com)');
                                    document.getElementById('email').focus();
                                    return false;
                                }

                                // 5. Kiểm tra mật khẩu không được rỗng
                                if (password === '') {
                                    e.preventDefault();
                                    alert('❌ Mật khẩu không được để trống!');
                                    document.getElementById('password').focus();
                                    return false;
                                }

                                // 6. Kiểm tra độ dài mật khẩu (tối thiểu 6 ký tự)
                                if (password.length < 6) {
                                    e.preventDefault();
                                    alert('❌ Mật khẩu phải có ít nhất 6 ký tự!');
                                    document.getElementById('password').focus();
                                    return false;
                                }

                                // 7. Kiểm tra mật khẩu xác nhận không được rỗng
                                if (rePassword === '') {
                                    e.preventDefault();
                                    alert('❌ Vui lòng xác nhận mật khẩu!');
                                    document.getElementById('re_pass').focus();
                                    return false;
                                }

                                // 8. Kiểm tra mật khẩu và xác nhận mật khẩu phải trùng khớp
                                if (password !== rePassword) {
                                    e.preventDefault();
                                    alert('❌ Mật khẩu xác nhận không khớp! Vui lòng kiểm tra lại.');
                                    document.getElementById('re_pass').focus();
                                    return false;
                                }

                                // Nếu tất cả đều hợp lệ
                                console.log('✅ Form validation passed!');
                                return true;
                            });

                            // Thêm hiệu ứng real-time validation cho email
                            document.getElementById('email').addEventListener('blur', function () {
                                const email = this.value.trim();
                                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                                if (email !== '' && !emailRegex.test(email)) {
                                    this.style.borderColor = 'red';
                                } else {
                                    this.style.borderColor = '';
                                }
                            });

                            // Thêm hiệu ứng real-time validation cho password matching
                            document.getElementById('re_pass').addEventListener('input', function () {
                                const password = document.getElementById('password').value;
                                const rePassword = this.value;
                                if (rePassword !== '' && password !== rePassword) {
                                    this.style.borderColor = 'red';
                                } else {
                                    this.style.borderColor = '';
                                }
                            });
                        </script>
    </body>

    </html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <%@ include file="/common/taglib.jsp" %>
            <%@ include file="/common/headlink.jsp" %>
                <%@ include file="/common/loginregisterlink.jsp" %>
                    <meta charset="UTF-8">
                    <title>Xác Thực Email</title>
                    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    </head>

    <body>
        <%@ include file="/common/header.jsp" %>

            <div class="container-fluid py-12 mb-12 hero-header">
                <div class="container py-12">
                    <div class="row g-12 align-items-center">
                        <div class="main">

                            <!-- Verify form -->
                            <section class="signup">
                                <div class="container">
                                    <div class="signup-content d-flex" style="justify-content: center;">
                                        <div class="signup-form" style="width: 50%;">
                                            <h2 class="form-title">XÁC THỰC EMAIL</h2>
                                            <p class="text-center mb-4">Mã xác thực đã được gửi đến email của bạn.</p>

                                            <c:if test="${not empty alert}">
                                                <div class="alert alert-danger">${alert}</div>
                                            </c:if>

                                            <form method="POST" class="register-form" id="verify-form" action="verify">
                                                <div class="form-group">
                                                    <label for="code"><i class="zmdi zmdi-lock-outline"></i></label>
                                                    <input type="text" name="code" id="code"
                                                        placeholder="Nhập mã xác thực (6 số)" required />
                                                </div>
                                                <div class="form-group form-button">
                                                    <input type="submit" name="verify" id="verify" class="form-submit"
                                                        value="Xác Nhận" />
                                                </div>
                                            </form>
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
    </body>

    </html>
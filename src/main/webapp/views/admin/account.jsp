<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/common/taglib.jsp"%>
    <%@ include file="/common/admin/headlink.jsp"%>
    
    <meta charset="UTF-8">
    <title>Quản Lý Tài Khoản - Fruitables</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <style>
        /* --- 1. CẤU HÌNH LAYOUT --- */
        :root { --sidebar-width: 220px; --primary: #28a745; }
        
        body {
            background-color: #f4f6f9;
            font-family: 'Segoe UI', sans-serif;
            font-size: 0.9rem; color: #495057;
            overflow-x: hidden;
        }

        .main-content-wrapper {
            margin-left: var(--sidebar-width);
            padding: 25px;
            min-height: 100vh;
            transition: margin-left 0.3s;
        }

        @media (max-width: 768px) {
            .main-content-wrapper { margin-left: 0; }
        }

        /* --- 2. HEADER & STATS --- */
        .page-header {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border-radius: 15px; padding: 1.5rem; color: white; text-align: center;
            margin-bottom: 25px; box-shadow: 0 4px 15px rgba(40,167,69,0.2);
        }
        .page-header h2 { font-weight: 700; font-size: 1.6rem; margin-bottom: 5px; text-transform: uppercase; letter-spacing: 1px; }
        .page-header p { margin: 0; opacity: 0.9; }

        /* Stats Card */
        .stats-card {
            background: white; border-radius: 12px; padding: 1.5rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05); border-left: 4px solid var(--primary);
            text-align: center; height: 100%; transition: 0.3s;
        }
        .stats-card:hover { transform: translateY(-5px); box-shadow: 0 8px 20px rgba(0,0,0,0.1); }
        .stats-number { font-size: 2rem; font-weight: 700; color: var(--primary); line-height: 1; margin-bottom: 5px; }
        .stats-label { color: #6c757d; font-weight: 600; font-size: 0.8rem; text-transform: uppercase; }
        .stats-icon { color: #e9ecef; margin-top: 10px; }

        /* --- 3. FORM SECTIONS --- */
        .form-card {
            background: white; border-radius: 15px; padding: 25px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05); height: 100%;
        }
        .section-title {
            font-size: 1.1rem; font-weight: 700; color: #333;
            margin-bottom: 20px; padding-bottom: 10px; border-bottom: 2px solid #f0f0f0;
            display: flex; align-items: center; justify-content: space-between;
        }

        /* Avatar Upload */
        .avatar-wrapper { text-align: center; position: relative; margin-bottom: 20px; }
        .avatar-img {
            width: 140px; height: 140px; border-radius: 50%; object-fit: cover;
            border: 4px solid #f8f9fa; box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transition: 0.3s;
        }
        .avatar-wrapper:hover .avatar-img { border-color: var(--primary); transform: scale(1.05); }
        
        .btn-upload {
            margin-top: 15px; background: #333; color: white; border: none;
            padding: 8px 20px; border-radius: 20px; font-size: 0.85rem; font-weight: 600; transition: 0.3s;
        }
        .btn-upload:hover { background: black; transform: translateY(-2px); }

        /* Form Controls */
        .form-label { font-weight: 700; font-size: 0.75rem; color: #6c757d; text-transform: uppercase; letter-spacing: 0.5px; }
        .form-control-custom, .form-select-custom {
            border: 1px solid #ced4da; border-radius: 8px; padding: 10px 15px;
            background-color: #fbfbfb; width: 100%; transition: 0.3s;
        }
        .form-control-custom:focus, .form-select-custom:focus {
            background: white; border-color: var(--primary); box-shadow: 0 0 0 3px rgba(40,167,69,0.1); outline: none;
        }

        /* Buttons */
        .btn-action {
            padding: 12px; border-radius: 8px; font-weight: 700; border: none; width: 100%;
            text-transform: uppercase; font-size: 0.9rem; transition: 0.3s; letter-spacing: 0.5px;
        }
        .btn-update { background: linear-gradient(135deg, #007bff 0%, #0056b3 100%); color: white; box-shadow: 0 4px 15px rgba(0,123,255,0.3); }
        .btn-update:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(0,123,255,0.4); color: white; }
        
        .btn-delete { background: linear-gradient(135deg, #dc3545 0%, #c82333 100%); color: white; box-shadow: 0 4px 15px rgba(220,53,69,0.3); }
        .btn-delete:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(220,53,69,0.4); color: white; }

        .btn-add-new {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%); color: white; 
            border: none; padding: 8px 15px; border-radius: 50px; font-weight: 600; font-size: 0.85rem;
            box-shadow: 0 3px 10px rgba(40,167,69,0.3); text-decoration: none; display: inline-block;
        }
        .btn-add-new:hover { transform: translateY(-2px); color: white; box-shadow: 0 5px 15px rgba(40,167,69,0.4); }

        /* Badge */
        .role-badge { font-size: 0.7rem; padding: 2px 6px; border-radius: 4px; margin-left: 5px; vertical-align: middle; }
        .bg-admin { background: #cfe2ff; color: #084298; }
        .bg-user { background: #e2e3e5; color: #41464b; }
        .bg-inactive { background: #f8d7da; color: #842029; }
    </style>
</head>
<body>

    <%@ include file="/common/admin/header.jsp"%>

    <div class="main-content-wrapper">
        <div class="container-fluid px-0">
            
            <div class="row mb-4">
                <div class="col-12">
                    <div class="page-header">
                        <h2><i class="fas fa-users-cog me-2"></i>QUẢN LÝ TÀI KHOẢN</h2>
                        <p>Phân quyền và quản lý thông tin người dùng hệ thống</p>
                    </div>
                </div>
            </div>

            <div class="row mb-4 g-3">
                <div class="col-xl-3 col-md-6">
                    <div class="stats-card">
                        <div class="stats-number">${not empty userlist ? userlist.size() : 0}</div>
                        <div class="stats-label">Tổng Tài Khoản</div>
                        <i class="fas fa-users fa-2x stats-icon"></i>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="stats-card" style="border-left-color: #0d6efd;">
                        <div class="stats-number" style="color: #0d6efd;">
                            <c:set var="adminCount" value="0" />
                            <c:forEach items="${userlist}" var="user"><c:if test="${user.admin}"><c:set var="adminCount" value="${adminCount + 1}" /></c:if></c:forEach>
                            ${adminCount}
                        </div>
                        <div class="stats-label">Quản Trị Viên</div>
                        <i class="fas fa-user-shield fa-2x stats-icon"></i>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="stats-card" style="border-left-color: #28a745;">
                        <div class="stats-number" style="color: #28a745;">
                            <c:set var="activeCount" value="0" />
                            <c:forEach items="${userlist}" var="user"><c:if test="${user.active}"><c:set var="activeCount" value="${activeCount + 1}" /></c:if></c:forEach>
                            ${activeCount}
                        </div>
                        <div class="stats-label">Đang Hoạt Động</div>
                        <i class="fas fa-check-circle fa-2x stats-icon"></i>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="stats-card" style="border-left-color: #dc3545;">
                        <div class="stats-number" style="color: #dc3545;">
                            ${not empty userlist ? userlist.size() - activeCount : 0}
                        </div>
                        <div class="stats-label">Đã Khóa</div>
                        <i class="fas fa-user-lock fa-2x stats-icon"></i>
                    </div>
                </div>
            </div>

            <div class="row g-4">
                
                <div class="col-lg-4">
                    <div class="form-card">
                        <div class="mb-4">
                            <div class="section-title">
                                <span><i class="fas fa-list me-2 text-success"></i>Chọn Tài Khoản</span>
                                <a href="${pageContext.request.contextPath}/admin/addaccount" class="btn-add-new"><i class="fas fa-plus"></i></a>
                            </div>
                            <select id="account-select" class="form-select-custom" style="height: 50px; font-weight: 600;">
                                <option value="0">-- Chọn người dùng --</option>
                                <c:forEach items="${userlist}" var="user">
                                    <option value="${user.id}">
                                        ${user.username} 
                                        ${user.admin ? '(Admin)' : ''}
                                        ${!user.active ? '(Khóa)' : ''}
                                    </option>
                                </c:forEach>
                            </select>
                            <div class="mt-2 text-muted small"><i class="fas fa-info-circle me-1"></i> Chọn để xem hoặc sửa thông tin.</div>
                        </div>

                        <hr class="my-4 text-muted opacity-25">

                        <div class="avatar-wrapper">
                            <img id="avatar-img" src="${pageContext.request.contextPath}/templates/admin/img/avatar.png" alt="Avatar" class="avatar-img" />
                            
                            <form id="avatar-form" enctype="multipart/form-data">
                                <input id="fileInput" type="file" name="image" style="display: none;" accept="image/*" onchange="previewAvatar(this)" />
                                <div>
                                    <button type="button" class="btn-upload" onclick="document.getElementById('fileInput').click();">
                                        <i class="fas fa-camera me-2"></i>Đổi Ảnh
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="col-lg-8">
                    <div class="form-card">
                        <div class="section-title">
                            <span><i class="fas fa-user-edit me-2 text-primary"></i>Thông Tin Chi Tiết</span>
                        </div>

                        <form id="account-form" action="${pageContext.request.contextPath}/admin/updateaccount" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="id" id="id" value="" />
                            
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">Tên Tài Khoản</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-end-0"><i class="fas fa-user text-muted"></i></span>
                                        <input id="name" name="username" type="text" class="form-control border-start-0 form-control-custom" placeholder="Username" required />
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label">Email</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-end-0"><i class="fas fa-envelope text-muted"></i></span>
                                        <input id="email" name="email" type="email" class="form-control border-start-0 form-control-custom" placeholder="example@gmail.com" required />
                                    </div>
                                </div>

                                <div class="col-md-12">
                                    <label class="form-label">Mật Khẩu Mới</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-end-0"><i class="fas fa-lock text-muted"></i></span>
                                        <input id="password" name="password" type="password" class="form-control border-start-0 form-control-custom" placeholder="Để trống nếu không đổi mật khẩu..." />
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label">Quyền Hạn</label>
                                    <select id="role-select" class="form-select-custom" name="isAdmin">
                                        <option value="0">Người Dùng (User)</option>
                                        <option value="1">Quản Trị Viên (Admin)</option>
                                    </select>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label">Trạng Thái</label>
                                    <select id="status-select" class="form-select-custom" name="isActive">
                                        <option value="1">Đang Hoạt Động</option>
                                        <option value="0">Ngừng Hoạt Động (Khóa)</option>
                                    </select>
                                </div>
                            </div>

                            <div class="row mt-5">
                                <div class="col-md-6">
                                    <button type="button" onclick="deleteAccount()" class="btn-action btn-delete">
                                        <i class="fas fa-trash-alt me-2"></i>Xóa Tài Khoản
                                    </button>
                                </div>
                                <div class="col-md-6">
                                    <button type="submit" class="btn-action btn-update">
                                        <i class="fas fa-save me-2"></i>Cập Nhật Thông Tin
                                    </button>
                                </div>
                            </div>

                        </form>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <%@ include file="/common/admin/footer.jsp"%>
    <%@ include file="/common/admin/lastBodyScript.jsp"%>
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        $(document).ready(function() {
            // Xử lý khi chọn user từ dropdown
            $('#account-select').change(function() {
                var accountId = $(this).val();
                if (accountId != '0') {
                    $.ajax({
                        url: '${pageContext.request.contextPath}/admin/account',
                        type: 'POST',
                        data: { Id: accountId },
                        success: function(response) {
                            // Fill data
                            $('#id').val(response.id);
                            $('#name').val(response.username);
                            $('#email').val(response.email);
                            $('#password').val(''); // Reset pass
                            $('#role-select').val(response.admin ? '1' : '0');
                            $('#status-select').val(response.active ? '1' : '0');
                            
                            // Update Avatar
                            if(response.avatar && response.avatar !== '') {
                                $('#avatar-img').attr('src', '${pageContext.request.contextPath}/' + response.avatar);
                            } else {
                                $('#avatar-img').attr('src', '${pageContext.request.contextPath}/templates/admin/img/avatar.png');
                            }
                        },
                        error: function() { alert('Lỗi tải dữ liệu!'); }
                    });
                }
            });
        });

        // Preview Avatar khi chọn file
        function previewAvatar(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    $('#avatar-img').attr('src', e.target.result);
                }
                reader.readAsDataURL(input.files[0]);
            }
        }

        // Xóa tài khoản
        function deleteAccount() {
            var userID = $('#id').val();
            if(userID && userID != '') {
                if(confirm('CẢNH BÁO: Bạn có chắc muốn xóa tài khoản này không? Hành động này không thể hoàn tác!')) {
                    $.ajax({
                        url: '${pageContext.request.contextPath}/admin/deleteaccount?Id=' + userID,
                        type: 'POST',
                        success: function() {
                            alert('Đã xóa tài khoản thành công!');
                            window.location.reload();
                        },
                        error: function() { alert('Lỗi: Không thể xóa tài khoản này.'); }
                    });
                }
            } else {
                alert('Vui lòng chọn tài khoản cần xóa trong danh sách bên trái trước.');
            }
        }
    </script>

</body>
</html>
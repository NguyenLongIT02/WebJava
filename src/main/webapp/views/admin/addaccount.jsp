<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/common/taglib.jsp"%>
    <%@ include file="/common/admin/headlink.jsp"%>
    
    <meta charset="UTF-8">
    <title>Thêm Tài Khoản Mới</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <style>
        /* --- LAYOUT --- */
        :root { --sidebar-width: 220px; --primary: #28a745; --bg: #f4f7f6; }
        body { background-color: var(--bg); font-family: 'Segoe UI', sans-serif; font-size: 0.9rem; color: #555; overflow-x: hidden; }
        .main-content-wrapper { margin-left: var(--sidebar-width); padding: 30px; min-height: 100vh; transition: 0.3s; }
        @media (max-width: 768px) { .main-content-wrapper { margin-left: 0; } }

        /* --- CARD CONTAINER --- */
        .add-card {
            background: white; border-radius: 20px; box-shadow: 0 10px 40px rgba(0,0,0,0.05);
            border: none; overflow: hidden; max-width: 900px; margin: 0 auto;
        }

        /* --- HEADER --- */
        .card-header-custom {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            padding: 25px; text-align: center; color: white;
        }
        .card-header-custom h2 { font-weight: 800; font-size: 1.5rem; margin-bottom: 5px; text-transform: uppercase; letter-spacing: 1px; }
        .card-header-custom p { margin: 0; opacity: 0.9; font-size: 0.9rem; }

        /* --- AVATAR UPLOAD (LEFT) --- */
        .avatar-section {
            background: #fdfdfd; border-right: 1px solid #f0f0f0;
            display: flex; flex-direction: column; align-items: center; justify-content: center;
            padding: 40px 20px; height: 100%;
        }
        .avatar-wrapper {
            position: relative; width: 180px; height: 180px; margin-bottom: 20px;
        }
        .avatar-img {
            width: 100%; height: 100%; object-fit: cover; border-radius: 50%;
            border: 5px solid white; box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            transition: 0.3s;
        }
        .avatar-overlay {
            position: absolute; bottom: 5px; right: 5px;
            background: white; width: 40px; height: 40px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1); color: var(--primary);
            cursor: pointer; transition: 0.3s;
        }
        .avatar-overlay:hover { background: var(--primary); color: white; transform: scale(1.1); }

        /* --- FORM INPUTS (RIGHT) --- */
        .form-section { padding: 40px; }
        
        .form-label { font-weight: 700; font-size: 0.75rem; color: #666; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 8px; }
        .form-control-modern {
            background: #f8f9fa; border: 2px solid #eee; border-radius: 12px; padding: 12px 15px; font-weight: 600; transition: 0.3s;
        }
        .form-control-modern:focus { background: white; border-color: var(--primary); box-shadow: 0 0 0 4px rgba(40, 167, 69, 0.1); }

        /* Toggle Switch Style for Roles */
        .role-selector { display: flex; gap: 15px; }
        .role-option {
            flex: 1; text-align: center; padding: 10px; border: 2px solid #eee; border-radius: 10px;
            cursor: pointer; transition: 0.3s; font-weight: 600; color: #aaa;
        }
        .role-option:hover { border-color: var(--primary); color: var(--primary); }
        
        /* Radio ẩn để style label */
        .role-radio:checked + .role-option {
            background: #f0fff4; border-color: var(--primary); color: var(--primary);
            box-shadow: 0 4px 10px rgba(40,167,69,0.15);
        }

        /* Buttons */
        .btn-create {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none; padding: 12px; width: 100%; border-radius: 50px;
            font-weight: 700; color: white; text-transform: uppercase; letter-spacing: 1px;
            box-shadow: 0 5px 15px rgba(40,167,69,0.3); transition: 0.3s;
        }
        .btn-create:hover { transform: translateY(-2px); box-shadow: 0 8px 25px rgba(40,167,69,0.4); color: white; }
        
        .btn-back {
            background: white; border: 1px solid #ddd; color: #666; padding: 12px; width: 100%;
            border-radius: 50px; font-weight: 600; transition: 0.3s; text-align: center; text-decoration: none; display: block;
        }
        .btn-back:hover { background: #f8f9fa; color: #333; }

    </style>
</head>
<body>

    <%@ include file="/common/admin/header.jsp"%>

    <div class="main-content-wrapper">
        <div class="container-fluid">
            
            <div class="mb-4 text-center">
                <a href="${pageContext.request.contextPath}/admin/account" class="text-decoration-none text-muted small fw-bold">
                    <i class="fas fa-arrow-left me-1"></i> QUAY LẠI DANH SÁCH
                </a>
            </div>

            <div class="add-card">
                <div class="card-header-custom">
                    <h2><i class="fas fa-user-plus me-2"></i>THÊM TÀI KHOẢN</h2>
                    <p>Tạo tài khoản mới cho Quản trị viên hoặc Người dùng</p>
                </div>

                <form action="${pageContext.request.contextPath}/admin/addaccount" method="post" enctype="multipart/form-data">
                    <div class="row g-0">
                        
                        <div class="col-md-4">
                            <div class="avatar-section">
                                <div class="avatar-wrapper">
                                    <img id="avatarPreview" src="${pageContext.request.contextPath}/templates/admin/img/avatar.png" class="avatar-img">
                                    <label for="fileInput" class="avatar-overlay" title="Chọn ảnh">
                                        <i class="fas fa-camera"></i>
                                    </label>
                                </div>
                                <input id="fileInput" type="file" name="image" style="display: none;" accept="image/*" onchange="previewImage(this)">
                                <p class="text-muted small text-center mt-2">
                                    Hỗ trợ: JPG, PNG<br>Kích thước tối ưu: 500x500px
                                </p>
                            </div>
                        </div>

                        <div class="col-md-8">
                            <div class="form-section">
                                <div class="row g-3">
                                    
                                    <div class="col-12">
                                        <label class="form-label">Tên Tài Khoản <span class="text-danger">*</span></label>
                                        <input name="username" type="text" class="form-control form-control-modern" placeholder="Ví dụ: nguyenvan_a" required>
                                    </div>

                                    <div class="col-12">
                                        <label class="form-label">Email <span class="text-danger">*</span></label>
                                        <input name="email" type="email" class="form-control form-control-modern" placeholder="example@gmail.com" required>
                                    </div>

                                    <div class="col-12">
                                        <label class="form-label">Mật Khẩu <span class="text-danger">*</span></label>
                                        <input name="password" type="password" class="form-control form-control-modern" placeholder="••••••••" required>
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label">Quyền Truy Cập</label>
                                        <div class="role-selector">
                                            <label style="flex:1">
                                                <input type="radio" name="isAdmin" value="0" class="d-none role-radio" checked>
                                                <div class="role-option"><i class="fas fa-user me-2"></i>User</div>
                                            </label>
                                            <label style="flex:1">
                                                <input type="radio" name="isAdmin" value="1" class="d-none role-radio">
                                                <div class="role-option"><i class="fas fa-user-shield me-2"></i>Admin</div>
                                            </label>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label">Trạng Thái</label>
                                        <select name="isActive" class="form-control form-control-modern">
                                            <option value="1">Đang Hoạt Động</option>
                                            <option value="0">Ngừng Hoạt Động</option>
                                        </select>
                                    </div>

                                    <div class="col-12 mt-4 d-flex gap-3">
                                        <div style="flex: 1;">
                                            <a href="${pageContext.request.contextPath}/admin/account" class="btn-back">Hủy bỏ</a>
                                        </div>
                                        <div style="flex: 2;">
                                            <button type="submit" class="btn-create">
                                                <i class="fas fa-check-circle me-2"></i> Tạo Tài Khoản
                                            </button>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>

                    </div>
                </form>
            </div>

        </div>
    </div>

    <%@ include file="/common/admin/footer.jsp"%>
    <%@ include file="/common/admin/lastBodyScript.jsp"%>

    <script>
        function previewImage(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('avatarPreview').src = e.target.result;
                }
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>

</body>
</html>
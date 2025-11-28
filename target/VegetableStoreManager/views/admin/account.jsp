<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/common/taglib.jsp"%>
<%@ include file="/common/admin/headlink.jsp"%>
<meta charset="UTF-8">
<title>Quản Lý Tài Khoản - Fruitables</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<meta content="" name="keywords">
<meta content="" name="description">

<style>
.account-management {
    background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
    min-height: 100vh;
}

/* FIX MÀU CHỮ - ĐẢM BẢO TẤT CẢ CHỮ ĐỀU MÀU TỐI */
.account-management * {
    color: #2c3e50 !important;
}

.account-card {
    background: white;
    border-radius: 20px;
    box-shadow: 0 8px 30px rgba(0,0,0,0.12);
    border: none;
    transition: all 0.3s ease;
    overflow: hidden;
}

.account-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 15px 40px rgba(0,0,0,0.15);
}

.account-header {
    background: linear-gradient(135deg, #667eea 0%, #20c997 100%);
    color: white !important;
    padding: 2rem;
    border-radius: 20px 20px 0 0;
}

.account-header * {
    color: white !important;
}

.avatar-section {
    background: white;
    border-radius: 20px;
    padding: 2rem;
    box-shadow: 0 8px 30px rgba(0,0,0,0.12);
    text-align: center;
    height: fit-content;
}

.avatar-container {
    position: relative;
    display: inline-block;
    margin-bottom: 1.5rem;
}

.avatar-img {
    width: 150px;
    height: 150px;
    border-radius: 50%;
    object-fit: cover;
    border: 5px solid #e9ecef;
    transition: all 0.3s ease;
}

.avatar-img:hover {
    border-color: #667eea;
    transform: scale(1.05);
}

.avatar-upload {
    background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
    color: white !important;
    border: none;
    padding: 0.75rem 1.5rem;
    border-radius: 10px;
    font-weight: 600;
    transition: all 0.3s ease;
    cursor: pointer;
    box-shadow: 0 4px 15px rgba(40,167,69,0.3);
    width: 100%;
}

.avatar-upload:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(40,167,69,0.4);
    color: white !important;
}

.form-section {
    background: white;
    border-radius: 20px;
    padding: 2rem;
    box-shadow: 0 8px 30px rgba(0,0,0,0.12);
    height: fit-content;
}

.form-header {
    color: #2c3e50 !important;
    font-weight: 700;
    margin-bottom: 1.5rem;
    font-size: 1.3rem;
    border-bottom: 2px solid #e9ecef;
    padding-bottom: 0.5rem;
}

.form-label {
    color: #2c3e50 !important;
    font-weight: 600;
    margin-bottom: 0.8rem;
    font-size: 0.95rem;
    display: block;
}

.form-group {
    margin-bottom: 1.5rem;
}

.form-control-custom {
    border: 2px solid #e9ecef;
    border-radius: 12px;
    padding: 0.75rem 1rem;
    font-size: 1rem;
    transition: all 0.3s ease;
    background: #f8f9fa;
    color: #2c3e50 !important;
    width: 100%;
    height: 48px;
}

.form-control-custom:focus {
    border-color: #667eea;
    box-shadow: 0 0 0 0.3rem rgba(102, 126, 234, 0.1);
    background: white;
    color: #2c3e50 !important;
}

.form-control-custom::placeholder {
    color: #6c757d !important;
}

.select-custom {
    border: 2px solid #e9ecef;
    border-radius: 12px;
    padding: 0.75rem 1rem;
    font-size: 1rem;
    transition: all 0.3s ease;
    background: #f8f9fa;
    color: #2c3e50 !important;
    width: 100%;
    height: 48px;
}

.select-custom:focus {
    border-color: #667eea;
    box-shadow: 0 0 0 0.3rem rgba(102, 126, 234, 0.1);
    background: white;
}

/* CÂN BẰNG FORM LAYOUT */
.form-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 1.5rem;
}

.form-full-width {
    grid-column: 1 / -1;
}

.form-actions {
    grid-column: 1 / -1;
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 1rem;
    margin-top: 1rem;
}

.btn-primary-custom {
    background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
    color: white !important;
    border: none;
    padding: 1rem 1.5rem;
    border-radius: 12px;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    transition: all 0.3s ease;
    box-shadow: 0 6px 20px rgba(0,123,255,0.3);
    width: 100%;
    height: 52px;
    font-size: 0.95rem;
}

.btn-primary-custom:hover {
    transform: translateY(-3px);
    box-shadow: 0 10px 30px rgba(0,123,255,0.4);
    color: white !important;
}

.btn-danger-custom {
    background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
    color: white !important;
    border: none;
    padding: 1rem 1.5rem;
    border-radius: 12px;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    transition: all 0.3s ease;
    box-shadow: 0 6px 20px rgba(220,53,69,0.3);
    width: 100%;
    height: 52px;
    font-size: 0.95rem;
}

.btn-danger-custom:hover {
    transform: translateY(-3px);
    box-shadow: 0 10px 30px rgba(220,53,69,0.4);
    color: white !important;
}

.btn-success-custom {
    background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
    color: white !important;
    border: none;
    padding: 1rem 2rem;
    border-radius: 12px;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    transition: all 0.3s ease;
    box-shadow: 0 6px 20px rgba(40,167,69,0.3);
}

.btn-success-custom:hover {
    transform: translateY(-3px);
    box-shadow: 0 10px 30px rgba(40,167,69,0.4);
    color: white !important;
}

.account-selector {
    background: white;
    border-radius: 15px;
    padding: 1.5rem;
    box-shadow: 0 4px 20px rgba(0,0,0,0.08);
    margin-bottom: 2rem;
}

.stats-card {
    background: white;
    border-radius: 15px;
    padding: 1.5rem;
    box-shadow: 0 4px 20px rgba(0,0,0,0.08);
    text-align: center;
    border-left: 5px solid #667eea;
    transition: all 0.3s ease;
    margin-bottom: 1.5rem;
}

.stats-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 8px 25px rgba(0,0,0,0.12);
}

.stats-number {
    font-size: 2.5rem;
    font-weight: 700;
    color: #667eea !important;
    margin-bottom: 0.5rem;
}

.stats-label {
    color: #6c757d !important;
    font-weight: 600;
    text-transform: uppercase;
    font-size: 0.9rem;
    letter-spacing: 0.5px;
}

.status-badge {
    padding: 0.5rem 1rem;
    border-radius: 20px;
    font-weight: 600;
    font-size: 0.8rem;
}

.status-active {
    background: #d4edda;
    color: #155724 !important;
}

.status-inactive {
    background: #f8d7da;
    color: #721c24 !important;
}

.role-badge {
    padding: 0.5rem 1rem;
    border-radius: 20px;
    font-weight: 600;
    font-size: 0.8rem;
}

.role-admin {
    background: #d1ecf1;
    color: #0c5460 !important;
}

.role-user {
    background: #e2e3e5;
    color: #383d41 !important;
}

.help-text {
    color: #6c757d !important;
    font-size: 0.8rem;
    margin-top: 0.5rem;
    display: block;
}

.form-row {
    display: flex;
    gap: 1.5rem;
    margin-bottom: 1.5rem;
}

.form-row .form-group {
    flex: 1;
    margin-bottom: 0;
}

@media (max-width: 992px) {
    .form-grid {
        grid-template-columns: 1fr;
        gap: 1rem;
    }
    
    .form-actions {
        grid-template-columns: 1fr;
        gap: 0.75rem;
    }
    
    .form-row {
        flex-direction: column;
        gap: 1rem;
    }
}

@media (max-width: 768px) {
    .avatar-img {
        width: 120px;
        height: 120px;
    }
    
    .form-section {
        padding: 1.5rem;
    }
    
    .account-header {
        padding: 1.5rem;
    }
    
    .form-control-custom,
    .select-custom {
        height: 44px;
        font-size: 0.9rem;
    }
    
    .btn-primary-custom,
    .btn-danger-custom {
        height: 48px;
        font-size: 0.9rem;
        padding: 0.875rem 1rem;
    }
}
</style>
</head>
<body class="account-management">
	<%@ include file="/common/admin/header.jsp"%>
	
	<div class="container-fluid py-4">
        <!-- Header Section -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="account-card">
                    <div class="account-header text-center">
                        <h1 class="h2 mb-3">
                            <i class="fas fa-users me-3"></i>
                            QUẢN LÝ TÀI KHOẢN
                        </h1>
                        <p class="mb-0 opacity-75">Quản lý thông tin và quyền truy cập của người dùng trong hệ thống</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Stats Section -->
        <div class="row mb-4">
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="stats-card">
                    <div class="stats-number">${not empty userlist ? userlist.size() : 0}</div>
                    <div class="stats-label">Tổng Tài Khoản</div>
                    <i class="fas fa-user-friends fa-2x text-muted mt-2"></i>
                </div>
            </div>
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="stats-card">
                    <div class="stats-number">
                        <c:set var="adminCount" value="0" />
                        <c:forEach items="${userlist}" var="user">
                            <c:if test="${user.admin}">
                                <c:set var="adminCount" value="${adminCount + 1}" />
                            </c:if>
                        </c:forEach>
                        ${adminCount}
                    </div>
                    <div class="stats-label">Quản Trị Viên</div>
                    <i class="fas fa-user-shield fa-2x text-muted mt-2"></i>
                </div>
            </div>
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="stats-card">
                    <div class="stats-number">
                        <c:set var="activeCount" value="0" />
                        <c:forEach items="${userlist}" var="user">
                            <c:if test="${user.active}">
                                <c:set var="activeCount" value="${activeCount + 1}" />
                            </c:if>
                        </c:forEach>
                        ${activeCount}
                    </div>
                    <div class="stats-label">Đang Hoạt Động</div>
                    <i class="fas fa-check-circle fa-2x text-muted mt-2"></i>
                </div>
            </div>
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="stats-card">
                    <div class="stats-number">
                        ${not empty userlist ? userlist.size() - activeCount : 0}
                    </div>
                    <div class="stats-label">Ngừng Hoạt Động</div>
                    <i class="fas fa-pause-circle fa-2x text-muted mt-2"></i>
                </div>
            </div>
        </div>

        <!-- Account Selector -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="account-selector">
                    <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
                        <div class="flex-grow-1">
                            <h3 class="form-header mb-3">
                                <i class="fas fa-list me-2"></i>
                                Chọn Tài Khoản Để Quản Lý
                            </h3>
                            <select id="account-select" class="select-custom w-100">
                                <option value="0">-- Chọn tài khoản --</option>
                                <c:forEach items="${userlist}" var="user">
                                    <option value="${user.id}" 
                                            data-role="${user.admin ? 'admin' : 'user'}"
                                            data-status="${user.active ? 'active' : 'inactive'}">
                                        ${user.username} 
                                        <c:if test="${user.admin}">
                                            <span class="role-badge role-admin ms-2">ADMIN</span>
                                        </c:if>
                                        <c:if test="${not user.admin}">
                                            <span class="role-badge role-user ms-2">USER</span>
                                        </c:if>
                                        <c:if test="${not user.active}">
                                            <span class="status-badge status-inactive ms-2">NGỪNG HOẠT ĐỘNG</span>
                                        </c:if>
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <button class="btn btn-success-custom" 
                                onclick="window.location.href='${pageContext.request.contextPath}/admin/addaccount'">
                            <i class="fas fa-plus-circle me-2"></i>
                            THÊM TÀI KHOẢN MỚI
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <!-- Avatar Section -->
            <div class="col-lg-4 mb-4">
                <div class="avatar-section">
                    <h3 class="form-header">
                        <i class="fas fa-user-circle me-2"></i>
                        Ảnh Đại Diện
                    </h3>
                    <div class="avatar-container">
                        <img id="avatar-img"
                            src="${pageContext.request.contextPath}/templates/admin/img/avatar.png"
                            alt="Avatar" class="avatar-img" />
                    </div>
                    <form id="avatar-form" enctype="multipart/form-data">
                        <input id="fileInput" type="file" name="image" style="display: none;" 
                               accept="image/*" onchange="previewAvatar(this)" />
                        <button type="button" class="avatar-upload"
                            onclick="document.getElementById('fileInput').click();">
                            <i class="fas fa-cloud-upload-alt me-2"></i>
                            TẢI HÌNH ẢNH LÊN
                        </button>
                    </form>
                </div>
            </div>

            <!-- Account Settings Section -->
            <div class="col-lg-8 mb-4">
                <div class="form-section">
                    <h3 class="form-header">
                        <i class="fas fa-cogs me-2"></i>
                        Thông Tin Tài Khoản
                    </h3>
                    <form id="account-form" enctype="multipart/form-data" action="${pageContext.request.contextPath}/admin/updateaccount" method="post">
                        <input type="hidden" name="id" id="id" value="" />
                        
                        <!-- CÂN BẰNG FORM LAYOUT VỚI GRID -->
                        <div class="form-grid">
                            <!-- Hàng 1: Username & Email -->
                            <div class="form-group">
                                <label class="form-label">TÊN TÀI KHOẢN</label>
                                <input id="name" name="username" type="text" 
                                       class="form-control-custom" 
                                       placeholder="Nhập tên tài khoản..." 
                                       required />
                            </div>

                            <div class="form-group">
                                <label class="form-label">EMAIL</label>
                                <input id="email" name="email" type="email" 
                                       class="form-control-custom" 
                                       placeholder="Nhập địa chỉ email..." 
                                       required />
                            </div>

                            <!-- Hàng 2: Password & Role -->
                            <div class="form-group">
                                <label class="form-label">MẬT KHẨU</label>
                                <input id="password" name="password" type="password" 
                                       class="form-control-custom" 
                                       placeholder="Nhập mật khẩu mới..." />
                                <span class="help-text">Để trống nếu không muốn thay đổi mật khẩu</span>
                            </div>

                            <div class="form-group">
                                <label class="form-label">QUYỀN TRUY CẬP</label>
                                <select id="role-select" class="select-custom" name="isAdmin">
                                    <option value="0">Người Dùng</option>
                                    <option value="1">Quản Trị Viên</option>
                                </select>
                            </div>

                            <!-- Hàng 3: Status (full width) -->
                            <div class="form-group form-full-width">
                                <label class="form-label">TRẠNG THÁI TÀI KHOẢN</label>
                                <select id="status-select" class="select-custom" name="isActive">
                                    <option value="0">Ngừng Hoạt Động</option>
                                    <option value="1">Đang Hoạt Động</option>
                                </select>
                                <span class="help-text">Tài khoản ngừng hoạt động sẽ không thể đăng nhập vào hệ thống</span>
                            </div>

                            <!-- Hàng 4: Action Buttons -->
                            <div class="form-actions">
                                <button type="submit" class="btn btn-primary-custom">
                                    <i class="fas fa-save me-2"></i>
                                    CẬP NHẬT
                                </button>
                                <button type="button" onclick="deleteAccount()" 
                                        class="btn btn-danger-custom">
                                    <i class="fas fa-trash me-2"></i>
                                    XÓA TÀI KHOẢN
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

	<%@ include file="/common/admin/footer.jsp"%>
	<%@ include file="/common/admin/lastBodyScript.jsp"%>

	<script>
		$(document).ready(function() {
		    $('#account-select').change(function() {
		        var accountId = $(this).val();
		        if (accountId != '0') {
		            $.ajax({
		                url: '${pageContext.request.contextPath}/admin/account',
		                type: 'POST',
		                data: {
		                    Id: accountId
		                },
		                success: function(response) {
		                    // Cập nhật thông tin tài khoản
		                    $('#id').val(response.id);
		                    $('#name').val(response.username);
		                    $('#email').val(response.email);
		                    $('#password').val(''); // Clear password for security

		                    // Cập nhật role
		                    $('#role-select').val(response.admin ? '1' : '0');
		                    
		                    // Cập nhật status
		                    $('#status-select').val(response.active ? '1' : '0');
		                    
		                    // Cập nhật avatar
		                    if(response.avatar != null && response.avatar != ''){
		                    	$('#avatar-img').attr('src', '${pageContext.request.contextPath}/' + response.avatar);
		                    } else {
		                    	$('#avatar-img').attr('src', '${pageContext.request.contextPath}/templates/admin/img/avatar.png');
		                    }

		                    showNotification('Đã tải thông tin tài khoản thành công!', 'success');
		                },
		                error: function() {
		                    showNotification('Có lỗi xảy ra, vui lòng thử lại!', 'error');
		                }
		            });
		        }
		    });
		});
		
		function previewAvatar(input) {
			const file = input.files[0];
			if (file) {
				const reader = new FileReader();
				reader.onload = function(e) {
					$('#avatar-img').attr('src', e.target.result);
				}
				reader.readAsDataURL(file);
				showNotification('Đã chọn ảnh đại diện mới!', 'success');
			}
		}
		
		function deleteAccount() {
			var userID = $('#id').val();
		    if(userID && userID != '') {
		    	if(confirm('Bạn có chắc muốn xóa tài khoản này? Hành động này không thể hoàn tác.')) {
			    	$.ajax({
				        url: '${pageContext.request.contextPath}/admin/deleteaccount?Id=' + userID,
				        type: 'POST',
				        success: function() {
				            showNotification('Đã xóa tài khoản thành công!', 'success');
				            setTimeout(function() {
				                window.location.reload();
				            }, 1500);
				        },
				        error: function() { 
				            showNotification('Không thể xóa tài khoản này!', 'error');
				        }
				    });
			    }
		    } else {
		    	showNotification('Vui lòng chọn tài khoản cần xóa!', 'error');
		    }
		}

		function showNotification(message, type) {
			const alertClass = type === 'success' ? 'alert-success' : 'alert-danger';
			const notification = $('<div class="alert ' + alertClass + ' alert-dismissible fade show position-fixed" style="top: 20px; right: 20px; z-index: 9999;">' +
								'<strong>' + message + '</strong>' +
								'<button type="button" class="close" data-dismiss="alert">&times;</button>' +
								'</div>');
			$('body').append(notification);
			setTimeout(function() {
				notification.alert('close');
			}, 3000);
		}

		// Form validation
		$('#account-form').on('submit', function(e) {
			const username = $('#name').val().trim();
			const email = $('#email').val().trim();
			
			if (!username) {
				e.preventDefault();
				showNotification('Vui lòng nhập tên tài khoản!', 'error');
				$('#name').focus();
				return;
			}
			
			if (!email) {
				e.preventDefault();
				showNotification('Vui lòng nhập địa chỉ email!', 'error');
				$('#email').focus();
				return;
			}
			
			if (!validateEmail(email)) {
				e.preventDefault();
				showNotification('Vui lòng nhập địa chỉ email hợp lệ!', 'error');
				$('#email').focus();
				return;
			}
		});

		function validateEmail(email) {
			const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
			return re.test(email);
		}
	</script>
</body>
</html>
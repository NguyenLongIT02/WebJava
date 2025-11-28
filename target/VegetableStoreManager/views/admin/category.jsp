<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/common/taglib.jsp"%>
<%@ include file="/common/admin/headlink.jsp"%>
<meta charset="UTF-8">
<title>Quản Lý Danh Mục - Fruitables</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<meta content="" name="keywords">
<meta content="" name="description">

<style>

.category-management {
    background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
    min-height: 100vh;
}

/* Đảm bảo tất cả text đều màu tối */
.category-management * {
    color: #2c3e50 !important;
}

/* Riêng các phần tử cần màu khác */
.category-header,
.modal-header {
    color: white !important;
}

.category-header *,
.modal-header * {
    color: white !important;
}

.category-card {
    background: white;
    border-radius: 20px;
    box-shadow: 0 8px 30px rgba(0,0,0,0.12);
    border: none;
    transition: all 0.3s ease;
    overflow: hidden;
}

.category-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 15px 40px rgba(0,0,0,0.15);
}

.category-header {
    background: linear-gradient(135deg, #667eea 0%, #20c997 100%);
    color: white !important;
    padding: 2rem;
    border-radius: 20px 20px 0 0;
}

.category-list {
    background: white;
    border-radius: 15px;
    box-shadow: 0 4px 20px rgba(0,0,0,0.08);
}

.category-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 1.5rem;
    border-bottom: 1px solid #f1f3f4;
    transition: all 0.3s ease;
    cursor: pointer;
}

.category-item:last-child {
    border-bottom: none;
}

.category-item:hover {
    background: linear-gradient(135deg, #f8f9ff 0%, #f0f2ff 100%);
    transform: translateX(5px);
}

.category-info {
    display: flex;
    align-items: center;
    gap: 1rem;
}

.category-icon {
    width: 50px;
    height: 50px;
    border-radius: 12px;
    background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
    display: flex;
    align-items: center;
    justify-content: center;
    color: white !important;
    font-size: 1.2rem;
}

.category-details h4 {
    color: #2c3e50 !important;
    font-weight: 600;
    margin: 0;
    font-size: 1.1rem;
}

.category-details span {
    color: #6c757d !important;
    font-size: 0.9rem;
}

.category-actions {
    display: flex;
    gap: 0.5rem;
}

.btn-category {
    padding: 0.6rem 1.2rem;
    border-radius: 10px;
    font-weight: 600;
    text-transform: uppercase;
    font-size: 0.85rem;
    letter-spacing: 0.5px;
    transition: all 0.3s ease;
    border: none;
}

.btn-edit {
    background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
    color: white !important;
}

.btn-edit:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(0,123,255,0.3);
    color: white !important;
}

.btn-delete {
    background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
    color: white !important;
}

.btn-delete:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(220,53,69,0.3);
    color: white !important;
}

.btn-add {
    background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
    color: white !important;
    padding: 1rem 2rem;
    border-radius: 15px;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    transition: all 0.3s ease;
    border: none;
    box-shadow: 0 6px 20px rgba(40,167,69,0.3);
}

.btn-add:hover {
    transform: translateY(-3px);
    box-shadow: 0 10px 30px rgba(40,167,69,0.4);
    color: white !important;
}

.form-container {
    background: white;
    border-radius: 20px;
    padding: 2rem;
    box-shadow: 0 8px 30px rgba(0,0,0,0.12);
}

.form-header {
    color: #2c3e50 !important;
    font-weight: 700;
    margin-bottom: 1.5rem;
    font-size: 1.3rem;
}

.form-label {
    color: #2c3e50 !important;
    font-weight: 600;
    margin-bottom: 0.5rem;
}

/* FIX INPUT TEXT MÀU ĐEN */
.form-control-custom {
    border: 2px solid #e9ecef;
    border-radius: 12px;
    padding: 0.75rem 1rem;
    font-size: 1rem;
    transition: all 0.3s ease;
    background: #f8f9fa;
    color: #2c3e50 !important; /* QUAN TRỌNG: Màu chữ đen */
}

.form-control-custom:focus {
    border-color: #667eea;
    box-shadow: 0 0 0 0.3rem rgba(102, 126, 234, 0.1);
    background: white;
    color: #2c3e50 !important;
}

/* Fix placeholder màu */
.form-control-custom::placeholder {
    color: #6c757d !important;
    opacity: 1;
}

/* Fix select text color */
.form-control-custom option {
    color: #2c3e50 !important;
    background: white;
}

.stats-card {
    background: white;
    border-radius: 15px;
    padding: 1.5rem;
    box-shadow: 0 4px 20px rgba(0,0,0,0.08);
    text-align: center;
    border-left: 5px solid #667eea;
    transition: all 0.3s ease;
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

.empty-state {
    text-align: center;
    padding: 3rem;
    color: #6c757d !important;
}

.empty-state i {
    font-size: 4rem;
    margin-bottom: 1rem;
    color: #dee2e6 !important;
}

.empty-state h4 {
    color: #6c757d !important;
}

.empty-state p {
    color: #6c757d !important;
}

.modal-content {
    border: none;
    border-radius: 20px;
    box-shadow: 0 20px 60px rgba(0,0,0,0.2);
}

.modal-header {
    background: linear-gradient(135deg, #667eea 0%, #20c997 100%);
    color: white !important;
    border-radius: 20px 20px 0 0;
    border: none;
    padding: 1.5rem 2rem;
}

.modal-title {
    font-weight: 600;
    font-size: 1.3rem;
    color: white !important;
}

.modal-body {
    padding: 2rem;
}

/* Fix modal form text color */
.modal-body .form-label {
    color: #2c3e50 !important;
}

.modal-body .form-control-custom {
    color: #2c3e50 !important;
}

.modal-body .form-control-custom::placeholder {
    color: #6c757d !important;
}

.close {
    color: white !important;
    opacity: 0.8;
    font-size: 1.5rem;
}

.close:hover {
    color: white !important;
    opacity: 1;
}

/* Fix text trong các phần tử khác */
.text-muted {
    color: #6c757d !important;
}

.help-text {
    color: #6c757d !important;
    font-size: 0.875rem;
    margin-top: 0.25rem;
}

/* Fix button text trong form */
.form-container button {
    color: white !important;
}

/* Đảm bảo tất cả text input đều màu đen */
input, select, textarea {
    color: #2c3e50 !important;
}

input::placeholder, select::placeholder, textarea::placeholder {
    color: #6c757d !important;
}

@media (max-width: 768px) {
    .category-item {
        flex-direction: column;
        align-items: flex-start;
        gap: 1rem;
    }
    
    .category-actions {
        width: 100%;
        justify-content: flex-end;
    }
    
    .form-container {
        padding: 1.5rem;
    }
}
</style>
</head>
<body class="category-management">
	<%@ include file="/common/admin/header.jsp"%>
	
	<div class="container-fluid py-4">
        <!-- Header Section -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="category-card">
                    <div class="category-header text-center">
                        <h1 class="h2 mb-3" style="color: white !important;">
                            <i class="fas fa-tags me-3"></i>
                            QUẢN LÝ DANH MỤC
                        </h1>
                        <p class="mb-0 opacity-75" style="color: white !important;">Quản lý và tổ chức các danh mục sản phẩm trong hệ thống</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Stats Section -->
        <div class="row mb-4">
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="stats-card">
                    <div class="stats-number">${not empty categoryList ? categoryList.size() : 0}</div>
                    <div class="stats-label">Tổng Danh Mục</div>
                    <i class="fas fa-folder fa-2x text-muted mt-2"></i>
                </div>
            </div>
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="stats-card">
                    <div class="stats-number">156</div>
                    <div class="stats-label">Sản Phẩm</div>
                    <i class="fas fa-cube fa-2x text-muted mt-2"></i>
                </div>
            </div>
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="stats-card">
                    <div class="stats-number">12</div>
                    <div class="stats-label">Đang Hoạt Động</div>
                    <i class="fas fa-check-circle fa-2x text-muted mt-2"></i>
                </div>
            </div>
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="stats-card">
                    <div class="stats-number">4</div>
                    <div class="stats-label">Danh Mục Chính</div>
                    <i class="fas fa-layer-group fa-2x text-muted mt-2"></i>
                </div>
            </div>
        </div>

        <div class="row">
            <!-- Categories List -->
            <div class="col-lg-6 mb-4">
                <div class="category-card">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h3 class="form-header">
                                <i class="fas fa-list me-2"></i>
                                Danh Sách Danh Mục
                            </h3>
                            <button type="button" class="btn btn-add" data-toggle="modal" data-target="#addCategoryModal">
                                <i class="fas fa-plus-circle me-2"></i>
                                THÊM MỚI
                            </button>
                        </div>
                        
                        <div class="category-list">
                            <c:if test="${not empty categoryList && categoryList.size() > 0}">
                                <c:forEach items="${categoryList}" var="category">
                                    <div class="category-item" data-category-id="${category.id}">
                                        <div class="category-info">
                                            <div class="category-icon">
                                                <i class="fas fa-folder"></i>
                                            </div>
                                            <div class="category-details">
                                                <h4 style="color: #2c3e50 !important;">${category.name}</h4>
                                                <span style="color: #6c757d !important;">ID: #${category.id}</span>
                                            </div>
                                        </div>
                                        <div class="category-actions">
                                            <button class="btn btn-category btn-edit" 
                                                    onclick="editCategory(${category.id}, '${category.name}')">
                                                <i class="fas fa-edit me-1"></i>Sửa
                                            </button>
                                            <button class="btn btn-category btn-delete" 
                                                    onclick="deleteCategory(${category.id}, '${category.name}')">
                                                <i class="fas fa-trash me-1"></i>Xóa
                                            </button>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:if>
                            <c:if test="${empty categoryList || categoryList.size() == 0}">
                                <div class="empty-state">
                                    <i class="fas fa-inbox"></i>
                                    <h4 style="color: #6c757d !important;">Chưa có danh mục nào</h4>
                                    <p style="color: #6c757d !important;">Hãy thêm danh mục đầu tiên để bắt đầu</p>
                                    <button type="button" class="btn btn-add mt-3" data-toggle="modal" data-target="#addCategoryModal">
                                        <i class="fas fa-plus-circle me-2"></i>
                                        THÊM DANH MỤC ĐẦU TIÊN
                                    </button>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Edit Category Form -->
            <div class="col-lg-6 mb-4">
                <div class="form-container">
                    <h3 class="form-header">
                        <i class="fas fa-edit me-2"></i>
                        Chỉnh Sửa Danh Mục
                    </h3>
                    <form action="${pageContext.request.contextPath}/admin/editcategory" method="post" class="tm-login-form">
                        <div class="form-group">
                            <label class="form-label">CHỌN DANH MỤC ĐỂ CHỈNH SỬA</label>
                            <select id="category-select" class="form-control form-control-custom" name="Id">
                                <option value="0">-- Chọn danh mục --</option>
                                <c:forEach items="${categoryList}" var="category">
                                    <option value="${category.id}">${category.name} (#${category.id})</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group mt-4">
                            <label class="form-label">TÊN DANH MỤC</label>
                            <input name="categoryname" type="text" 
                                   class="form-control form-control-custom" 
                                   id="categoryname" 
                                   placeholder="Nhập tên danh mục mới..." 
                                   required />
                        </div>
                        <div class="form-group mt-4">
                            <button type="submit" class="btn btn-category btn-edit w-100">
                                <i class="fas fa-save me-2"></i>
                                CẬP NHẬT DANH MỤC
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

	<!-- Add Category Modal -->
	<div class="modal fade" id="addCategoryModal" tabindex="-1" role="dialog" aria-labelledby="addCategoryModalLabel" aria-hidden="true">
	    <div class="modal-dialog modal-dialog-centered" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title" style="color: white !important;">
	                    <i class="fas fa-plus-circle me-2"></i>
	                    Thêm Danh Mục Mới
	                </h5>
	                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	                    <span aria-hidden="true" style="color: white !important;">&times;</span>
	                </button>
	            </div>
	            <div class="modal-body">
	                <form action="${pageContext.request.contextPath}/admin/addcategory" method="post">
	                    <div class="form-group">
	                        <label class="form-label">TÊN DANH MỤC MỚI</label>
	                        <input name="newCategoryName" type="text" 
	                               class="form-control form-control-custom" 
	                               id="new-category-name" 
	                               placeholder="Nhập tên danh mục..." 
	                               required />
	                    </div>
	                    <button type="submit" class="btn btn-add w-100">
	                        <i class="fas fa-check me-2"></i>
	                        THÊM DANH MỤC
	                    </button>
	                </form>
	            </div>
	        </div>
	    </div>
	</div>

	<%@ include file="/common/admin/footer.jsp"%>
	<%@ include file="/common/admin/lastBodyScript.jsp"%>

	<script>
		$(document).ready(function() {
			// Auto-fill form when category is selected
			$('#category-select').change(function() {
				var categoryId = $(this).val();
				if (categoryId != '0') {
					$.ajax({
						url : '${pageContext.request.contextPath}/admin/category',
						type : 'POST',
						data : {
							Id : categoryId
						},
						success : function(response) {
							$('#categoryname').val(response.name);
						},
						error : function() {
							showNotification('Có lỗi xảy ra, vui lòng thử lại!', 'error');
						}
					});
				}
			});

			// Add click effect to category items
			$('.category-item').click(function() {
				var categoryId = $(this).data('category-id');
				$('#category-select').val(categoryId).trigger('change');
			});
		});

		function editCategory(id, name) {
			$('#category-select').val(id);
			$('#categoryname').val(name);
			$('html, body').animate({
				scrollTop: $('.form-container').offset().top - 100
			}, 500);
		}

		function deleteCategory(id, name) {
			if (confirm('Bạn có chắc muốn xóa danh mục "' + name + '"?')) {
				$.ajax({
					url : '${pageContext.request.contextPath}/admin/deletecategory?Id=' + id,
					type : 'POST',
					success : function() {
						showNotification('Đã xóa danh mục thành công!', 'success');
						setTimeout(function() {
							window.location.reload();
						}, 1500);
					},
					error : function() {
						showNotification('Không thể xóa danh mục này!', 'error');
					}
				});
			}
		}

		function showNotification(message, type) {
			const alertClass = type === 'success' ? 'alert-success' : 'alert-danger';
			const notification = $('<div class="alert ' + alertClass + ' alert-dismissible fade show position-fixed" style="top: 20px; right: 20px; z-index: 9999;">' +
								'<strong style="color: #2c3e50 !important;">' + message + '</strong>' +
								'<button type="button" class="close" data-dismiss="alert">&times;</button>' +
								'</div>');
			$('body').append(notification);
			setTimeout(function() {
				notification.alert('close');
			}, 3000);
		}

		// Form validation
		$('form').on('submit', function(e) {
			const categoryName = $('#categoryname').val();
			if (!categoryName.trim()) {
				e.preventDefault();
				showNotification('Vui lòng nhập tên danh mục!', 'error');
				$('#categoryname').focus();
			}
		});
	</script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/common/taglib.jsp"%>
    <%@ include file="/common/admin/headlink.jsp"%>
    
    <meta charset="UTF-8">
    <title>Chỉnh Sửa Sản Phẩm</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <style>
        :root { --sidebar-width: 220px; }
        
        body {
            background-color: #f4f6f9;
            font-family: 'Segoe UI', sans-serif;
            font-size: 0.85rem; /* Font nhỏ gọn */
            color: #495057;
        }

        .main-content-wrapper {
            margin-left: var(--sidebar-width);
            padding: 20px; /* Giảm padding tổng thể */
            min-height: 100vh;
            transition: margin-left 0.3s;
        }

        @media (max-width: 768px) {
            .main-content-wrapper { margin-left: 0; }
        }

        /* --- EDIT CARD COMPACT --- */
        .edit-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.03);
            border: 1px solid #eef0f3;
            overflow: hidden;
            max-width: 900px; /* Giới hạn chiều rộng tối đa để không bị bè */
            margin: 0 auto; /* Căn giữa */
        }

        .card-header-custom {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            padding: 12px 20px; /* Header mỏng hơn */
            color: white;
        }
        
        .card-header-custom h5 { font-size: 1rem; font-weight: 700; margin: 0; }

        .form-label {
            font-weight: 600; font-size: 0.8rem; color: #6c757d;
            text-transform: uppercase; margin-bottom: 5px;
        }

        .form-control, .form-select {
            border-radius: 6px; border: 1px solid #dee2e6;
            padding: 8px 12px; /* Input nhỏ gọn hơn */
            font-size: 0.9rem;
        }
        
        .form-control:focus { border-color: #28a745; box-shadow: 0 0 0 2px rgba(40,167,69,0.1); }

        /* --- ẢNH THU NHỎ --- */
        .img-upload-container {
            background: #fcfcfc; border: 1px dashed #ccc;
            border-radius: 10px; padding: 15px;
            text-align: center;
        }
        
        .preview-img {
            width: 100%; height: 200px; /* Giảm chiều cao ảnh */
            object-fit: contain;
            border-radius: 8px; margin-bottom: 10px;
            background: white; border: 1px solid #eee;
        }

        .btn-upload {
            background: #333; color: white; border-radius: 20px;
            padding: 5px 15px; font-size: 0.8rem; border: none;
        }
        .btn-upload:hover { background: #000; }

        .btn-save {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none; padding: 10px; font-weight: 600; font-size: 0.9rem;
            border-radius: 6px; color: white; box-shadow: 0 2px 8px rgba(40,167,69,0.3);
        }
        .btn-save:hover { transform: translateY(-1px); box-shadow: 0 4px 12px rgba(40,167,69,0.4); }
    </style>
</head>
<body>

    <%@ include file="/common/admin/header.jsp"%>

    <div class="main-content-wrapper">
        <div class="container-fluid">
            
            <div class="mb-3 text-center" style="max-width: 900px; margin: 0 auto;">
                <div class="d-flex justify-content-start">
                    <a href="${pageContext.request.contextPath}/admin/productlist" class="text-decoration-none text-secondary small">
                        <i class="fas fa-chevron-left me-1"></i> Quay lại danh sách
                    </a>
                </div>
            </div>

            <div class="edit-card">
                
                <div class="card-header-custom d-flex justify-content-between align-items-center">
                    <h5><i class="fas fa-pen-to-square me-2"></i>CHỈNH SỬA SẢN PHẨM</h5>
                    <span class="badge bg-white text-success fw-bold" style="font-size: 0.75rem;">ID: #${product.id}</span>
                </div>

                <div class="card-body p-4">
                    <form action="" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="id" value="${product.id}" />
                        
                        <div class="row g-4"> <div class="col-lg-8">
                                <div class="mb-3">
                                    <label for="name" class="form-label">Tên Sản Phẩm</label>
                                    <input id="name" name="name" value="${product.name}" type="text" class="form-control" required />
                                </div>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="price" class="form-label">Giá Bán ($)</label>
                                        <div class="input-group input-group-sm"> <span class="input-group-text bg-light fw-bold">$</span>
                                            <input id="price" name="price" value="${product.price}" type="number" step="0.01" class="form-control" required />
                                        </div>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="category" class="form-label">Danh Mục</label>
                                        <select class="form-select form-select-sm" id="category" name="category"> <c:forEach items="${categories}" var="category">
                                                <option value="${category.id}" ${category.id == product.category.id ? 'selected' : ''}>
                                                    ${category.name}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>

                                <div class="mb-2">
                                    <label for="description" class="form-label">Mô Tả</label>
                                    <textarea id="description" name="description" class="form-control" rows="5" required>${product.des}</textarea>
                                </div>
                            </div>

                            <div class="col-lg-4">
                                <label class="form-label text-center w-100">Hình Ảnh</label>
                                <div class="img-upload-container">
                                    <img id="previewImage" class="preview-img" 
                                         src="${pageContext.request.contextPath}/templates/user/img/${product.image}" 
                                         onerror="this.src='https://via.placeholder.com/200x200?text=No+Image'" />
                                    
                                    <input id="fileInput" type="file" name="image" style="display: none;" accept="image/*" onchange="previewFile(this);" />
                                    
                                    <button type="button" class="btn-upload mt-2" onclick="document.getElementById('fileInput').click();">
                                        <i class="fas fa-camera me-1"></i> Đổi ảnh
                                    </button>
                                </div>
                            </div>

                        </div>

                        <div class="row mt-4 pt-3 border-top">
                            <div class="col-12 text-end">
                                <a href="${pageContext.request.contextPath}/admin/productlist" class="btn btn-light btn-sm border px-3 me-2">Hủy bỏ</a>
                                <button type="submit" class="btn btn-save px-4">
                                    <i class="fas fa-check me-1"></i> LƯU LẠI
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
        function previewFile(input) {
            var file = input.files[0];
            if(file){
                var reader = new FileReader();
                reader.onload = function(){
                    var output = document.getElementById('previewImage');
                    output.src = reader.result;
                };
                reader.readAsDataURL(file);
            }
        }
    </script>

</body>
</html>
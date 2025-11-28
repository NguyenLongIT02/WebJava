<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/common/taglib.jsp"%>
    <%@ include file="/common/admin/headlink.jsp"%>
    
    <meta charset="UTF-8">
    <title>Thêm Sản Phẩm Mới</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <style>
        /* --- 1. CẤU HÌNH LAYOUT CHUNG --- */
        :root { --sidebar-width: 220px; }
        
        body {
            background-color: #f4f6f9;
            font-family: 'Segoe UI', sans-serif;
            font-size: 0.85rem; color: #495057;
        }

        .main-content-wrapper {
            margin-left: var(--sidebar-width);
            padding: 20px;
            min-height: 100vh;
            transition: margin-left 0.3s;
        }

        @media (max-width: 768px) {
            .main-content-wrapper { margin-left: 0; }
        }

        /* --- 2. CARD FORM NHỎ GỌN --- */
        .add-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            border: none;
            overflow: hidden;
            max-width: 900px; /* Giới hạn chiều rộng */
            margin: 0 auto;   /* Căn giữa màn hình */
        }

        .card-header-custom {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            padding: 15px 25px;
            color: white;
        }
        
        .card-header-custom h5 { font-size: 1.1rem; font-weight: 700; margin: 0; text-transform: uppercase; }

        /* Input Styles */
        .form-label {
            font-weight: 600; font-size: 0.8rem; color: #6c757d;
            text-transform: uppercase; margin-bottom: 5px;
        }

        .form-control, .form-select {
            border-radius: 6px; border: 1px solid #dee2e6;
            padding: 8px 12px; font-size: 0.9rem;
        }
        .form-control:focus { border-color: #28a745; box-shadow: 0 0 0 2px rgba(40, 167, 69, 0.15); }

        /* --- 3. ẢNH PREVIEW --- */
        .img-upload-box {
            background: #f8f9fa; border: 2px dashed #dee2e6;
            border-radius: 10px; padding: 20px; text-align: center;
            height: 100%; display: flex; flex-direction: column;
            align-items: center; justify-content: center;
            transition: 0.3s;
        }
        .img-upload-box:hover { border-color: #28a745; background: #f0fff4; }

        .preview-img {
            max-width: 100%; max-height: 180px; object-fit: contain;
            margin-bottom: 15px; border-radius: 5px; display: none; /* Ẩn mặc định */
        }
        
        .upload-placeholder { color: #adb5bd; margin-bottom: 15px; }
        .upload-placeholder i { font-size: 3rem; margin-bottom: 10px; }

        .btn-upload {
            background: #333; color: white; border-radius: 20px;
            padding: 6px 15px; font-size: 0.8rem; border: none; cursor: pointer;
        }
        .btn-upload:hover { background: #000; }

        /* Button Save */
        .btn-save {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none; padding: 10px 30px; font-weight: 700;
            border-radius: 6px; color: white; box-shadow: 0 4px 10px rgba(40,167,69,0.3);
        }
        .btn-save:hover { transform: translateY(-2px); box-shadow: 0 6px 15px rgba(40,167,69,0.4); }
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

            <div class="add-card">
                
                <div class="card-header-custom text-center">
                    <h5><i class="fas fa-plus-circle me-2"></i>Thêm Sản Phẩm Mới</h5>
                </div>

                <div class="card-body p-4">
                    <form action="" method="post" enctype="multipart/form-data">
                        
                        <div class="row g-4">
                            
                            <div class="col-lg-8">
                                <div class="mb-3">
                                    <label for="name" class="form-label">Tên Sản Phẩm</label>
                                    <input id="name" name="name" type="text" class="form-control" placeholder="Ví dụ: Táo Envy Mỹ" required spellcheck="false" />
                                </div>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="price" class="form-label">Giá Bán ($)</label>
                                        <div class="input-group input-group-sm">
                                            <span class="input-group-text bg-white fw-bold text-success">$</span>
                                            <input name="price" type="number" step="0.01" class="form-control" placeholder="0.00" required />
                                        </div>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="category" class="form-label">Danh Mục</label>
                                        <select class="form-select form-select-sm" id="category" name="category">
                                            <c:forEach items="${categories}" var="category">
                                                <option value="${category.id}">${category.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>

                                <div class="mb-2">
                                    <label for="description" class="form-label">Mô Tả Chi Tiết</label>
                                    <textarea id="description" name="description" class="form-control" rows="5" placeholder="Nhập thông tin sản phẩm..." required spellcheck="false"></textarea>
                                </div>
                            </div>

                            <div class="col-lg-4">
                                <label class="form-label w-100 text-center">Hình Ảnh</label>
                                <div class="img-upload-box">
                                    <div id="uploadPlaceholder" class="upload-placeholder">
                                        <i class="fas fa-cloud-upload-alt"></i>
                                        <p class="small mb-0">Chưa có ảnh nào</p>
                                    </div>
                                    
                                    <img id="previewImage" class="preview-img" src="#" alt="Preview" />
                                    
                                    <input id="fileInput" type="file" name="image" style="display: none;" accept="image/*" onchange="previewFile(this);" required/>
                                    
                                    <button type="button" class="btn-upload mt-2" onclick="document.getElementById('fileInput').click();">
                                        Chọn Ảnh
                                    </button>
                                    <small class="text-muted d-block mt-2" style="font-size: 0.7rem;">JPG, PNG, WEBP (Max 2MB)</small>
                                </div>
                            </div>

                        </div>

                        <div class="row mt-4 pt-3 border-top">
                            <div class="col-12 text-end">
                                <a href="${pageContext.request.contextPath}/admin/productlist" class="btn btn-light btn-sm border px-3 me-2">Hủy bỏ</a>
                                <button type="submit" class="btn btn-save text-uppercase">
                                    <i class="fas fa-check me-2"></i> Thêm Sản Phẩm
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
                    var placeholder = document.getElementById('uploadPlaceholder');
                    
                    output.src = reader.result;
                    output.style.display = "block"; // Hiện ảnh
                    placeholder.style.display = "none"; // Ẩn icon placeholder
                };
                reader.readAsDataURL(file);
            }
        }
    </script>

</body>
</html>
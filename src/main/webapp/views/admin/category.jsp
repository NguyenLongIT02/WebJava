<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/common/taglib.jsp"%>
    <%@ include file="/common/admin/headlink.jsp"%>
    
    <meta charset="UTF-8">
    <title>Quản Lý Danh Mục</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <style>
        /* --- LAYOUT --- */
        :root { --sidebar-width: 220px; --primary: #28a745; --bg: #f4f7f6; }
        body { background-color: var(--bg); font-family: 'Segoe UI', sans-serif; font-size: 0.9rem; color: #555; overflow-x: hidden; }
        .main-content-wrapper { margin-left: var(--sidebar-width); padding: 25px; min-height: 100vh; transition: 0.3s; }
        @media (max-width: 768px) { .main-content-wrapper { margin-left: 0; } }

        /* --- NEW HEADER (XANH LÁ ĐỒNG BỘ) --- */
        .page-header {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%); /* Gradient Xanh */
            border-radius: 15px;
            padding: 0.7rem 1rem; /* Padding rộng hơn cho thoáng */
            margin-bottom: 25px;
            box-shadow: 0 5px 20px rgba(40, 167, 69, 0.2);
            text-align: center;
            position: relative; /* Để căn chỉnh nút Back */
            color: white;
        }

        .page-header h2 {
            font-size: 1.8rem; font-weight: 800; margin-bottom: 5px;
            text-transform: uppercase; letter-spacing: 1px;
        }
        
        .page-header p {
            font-size: 0.95rem; opacity: 0.9; margin: 0; font-weight: 500;
        }

        /* Nút Back trên nền xanh */
        .btn-back-custom {
            position: absolute; left: 20px; top: 50%; transform: translateY(-50%);
            background: rgba(255, 255, 255, 0.2); /* Trắng mờ */
            color: white; border: 1px solid rgba(255, 255, 255, 0.3);
            width: 40px; height: 40px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            transition: 0.3s; text-decoration: none;
        }
        .btn-back-custom:hover { background: white; color: #28a745; }

        /* --- LEFT PANEL (LIST) --- */
        .list-panel {
            background: white; border-radius: 20px; padding: 20px; height: calc(100vh - 180px); /* Điều chỉnh chiều cao */
            box-shadow: 0 5px 20px rgba(0,0,0,0.03); display: flex; flex-direction: column;
        }
        .list-title { font-weight: 800; color: #333; text-transform: uppercase; font-size: 0.85rem; margin-bottom: 15px; padding-bottom: 10px; border-bottom: 2px solid #f0f0f0; }
        .cat-scroll-area { flex-grow: 1; overflow-y: auto; padding-right: 5px; }
        
        .mini-cat-item {
            display: flex; align-items: center; padding: 10px; border-radius: 12px;
            background: #fff; border: 1px solid #eee; margin-bottom: 10px; transition: 0.2s;
        }
        .mini-cat-item:hover { border-color: var(--primary); transform: translateX(3px); box-shadow: 0 3px 10px rgba(0,0,0,0.05); }
        .mini-icon {
            width: 40px; height: 40px; border-radius: 10px; background: #f0fff4; color: var(--primary);
            display: flex; align-items: center; justify-content: center; font-size: 1.2rem; margin-right: 12px;
        }
        .mini-info h6 { font-size: 0.9rem; font-weight: 700; color: #444; margin: 0; }
        .mini-info span { font-size: 0.75rem; color: #999; }

        /* --- RIGHT PANEL (CREATOR) --- */
        .creator-panel {
            background: white; border-radius: 20px; padding: 30px;
            box-shadow: 0 10px 40px rgba(40,167,69,0.08); border: 1px solid rgba(40,167,69,0.1);
        }

        /* Icon Selector */
        .icon-select-box { display: flex; gap: 12px; flex-wrap: wrap; margin-top: 10px; }
        .icon-radio { display: none; }
        .icon-option {
            width: 45px; height: 45px; border-radius: 10px; background: #f8f9fa; border: 2px solid #eee;
            display: flex; align-items: center; justify-content: center; font-size: 1.1rem; color: #aaa;
            cursor: pointer; transition: 0.3s;
        }
        .icon-option:hover { transform: translateY(-2px); color: var(--primary); border-color: var(--primary); }
        .icon-radio:checked + .icon-option { background: var(--primary); border-color: var(--primary); color: white; box-shadow: 0 4px 10px rgba(40,167,69,0.3); }

        /* Inputs */
        .form-label { font-weight: 700; font-size: 0.75rem; color: #666; text-transform: uppercase; letter-spacing: 0.5px; }
        .form-control-modern { background: #fbfbfb; border: 2px solid #eee; border-radius: 10px; padding: 10px 15px; font-weight: 600; transition: 0.3s; }
        .form-control-modern:focus { background: white; border-color: var(--primary); box-shadow: 0 0 0 4px rgba(40, 167, 69, 0.1); }

        /* Preview Box */
        .preview-box {
            background: linear-gradient(135deg, #ffffff 0%, #f9fff9 100%);
            border: 2px dashed var(--primary); border-radius: 15px;
            padding: 20px; text-align: center; margin-bottom: 20px;
        }
        .preview-icon { font-size: 3rem; color: var(--primary); margin-bottom: 10px; transition: 0.3s; }
        .preview-name { font-size: 1.1rem; font-weight: 800; color: #333; }
        .typing-anim { animation: pop 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275); }
        @keyframes pop { 0% { transform: scale(1); } 50% { transform: scale(1.1); } 100% { transform: scale(1); } }

        /* Scrollbar */
        ::-webkit-scrollbar { width: 5px; }
        ::-webkit-scrollbar-thumb { background: #ccc; border-radius: 10px; }
        
        /* Toggle Switch Nhỏ */
        .form-check-input { width: 2.5em; height: 1.25em; cursor: pointer; margin-top: 0; }
        .form-check-input:checked { background-color: var(--primary); border-color: var(--primary); }
    </style>
</head>
<body>

    <%@ include file="/common/admin/header.jsp"%>

    <div class="main-content-wrapper">
        <div class="container-fluid px-0">
            
            <div class="page-header">
                <h3><i class="fas fa-layer-group me-2"></i>QUẢN LÝ DANH MỤC</h3>
                <p>Thêm mới & Quản lý thư viện phân loại sản phẩm</p>
            </div>

            <div class="row g-4">
                
                <div class="col-lg-4">
                    <div class="list-panel">
                        <div class="list-title">
                            <i class="fas fa-list-ul me-2 text-success"></i>DANH SÁCH HIỆN CÓ
                        </div>
                        <div class="cat-scroll-area">
                            <c:if test="${not empty categoryList}">
                                <c:forEach items="${categoryList}" var="cat">
                                    <div class="mini-cat-item">
                                        <div class="mini-icon">
                                            <c:choose>
                                                <c:when test="${cat.name.toLowerCase().contains('rau')}"><i class="fas fa-carrot"></i></c:when>
                                                <c:when test="${cat.name.toLowerCase().contains('quả')}"><i class="fas fa-apple-alt"></i></c:when>
                                                <c:when test="${cat.name.toLowerCase().contains('thịt')}"><i class="fas fa-drumstick-bite"></i></c:when>
                                                <c:otherwise><i class="fas fa-leaf"></i></c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="mini-info">
                                            <h6>${cat.name}</h6>
                                            <span>ID: #${cat.id}</span>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:if>
                            <c:if test="${empty categoryList}">
                                <div class="text-center py-5 text-muted opacity-50"><i class="fas fa-ghost fa-2x mb-2"></i><p class="small">Chưa có dữ liệu</p></div>
                            </c:if>
                        </div>
                    </div>
                </div>

                <div class="col-lg-8">
                    <div class="creator-panel">
                        <form action="${pageContext.request.contextPath}/admin/addcategory" method="post">
                            <div class="row">
                                <div class="col-md-7">
                                    <h6 class="fw-bold text-success mb-4"><i class="fas fa-pen-fancy me-2"></i>NHẬP THÔNG TIN</h6>
                                    
                                    <div class="mb-4">
                                        <label class="form-label">Tên Danh Mục <span class="text-danger">*</span></label>
                                        <input name="newCategoryName" id="catNameInput" type="text" class="form-control form-control-modern" 
                                               placeholder="Ví dụ: Rau Củ, Trái Cây..." required oninput="updatePreview()">
                                    </div>

                                    <div class="mb-4">
                                        <label class="form-label">Chọn Biểu Tượng</label>
                                        <div class="icon-select-box">
                                            <label><input type="radio" name="icon" value="fas fa-leaf" class="icon-radio" checked onchange="updateIcon(this)"><div class="icon-option"><i class="fas fa-leaf"></i></div></label>
                                            <label><input type="radio" name="icon" value="fas fa-carrot" class="icon-radio" onchange="updateIcon(this)"><div class="icon-option"><i class="fas fa-carrot"></i></div></label>
                                            <label><input type="radio" name="icon" value="fas fa-apple-alt" class="icon-radio" onchange="updateIcon(this)"><div class="icon-option"><i class="fas fa-apple-alt"></i></div></label>
                                            <label><input type="radio" name="icon" value="fas fa-lemon" class="icon-radio" onchange="updateIcon(this)"><div class="icon-option"><i class="fas fa-lemon"></i></div></label>
                                            <label><input type="radio" name="icon" value="fas fa-pepper-hot" class="icon-radio" onchange="updateIcon(this)"><div class="icon-option"><i class="fas fa-pepper-hot"></i></div></label>
                                            <label><input type="radio" name="icon" value="fas fa-fish" class="icon-radio" onchange="updateIcon(this)"><div class="icon-option"><i class="fas fa-fish"></i></div></label>
                                            <label><input type="radio" name="icon" value="fas fa-drumstick-bite" class="icon-radio" onchange="updateIcon(this)"><div class="icon-option"><i class="fas fa-drumstick-bite"></i></div></label>
                                            <label><input type="radio" name="icon" value="fas fa-cheese" class="icon-radio" onchange="updateIcon(this)"><div class="icon-option"><i class="fas fa-cheese"></i></div></label>
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label">Mô Tả (SEO)</label>
                                        <textarea name="description" class="form-control form-control-modern" rows="3" placeholder="Mô tả ngắn..."></textarea>
                                    </div>
                                </div>

                                <div class="col-md-5 border-start ps-4 d-flex flex-column justify-content-center">
                                    <div class="text-center mb-3">
                                        <small class="fw-bold text-muted text-uppercase">Xem Trước (Preview)</small>
                                    </div>
                                    
                                    <div class="preview-box" id="previewBox">
                                        <i id="prevIcon" class="fas fa-leaf preview-icon"></i>
                                        <div id="prevName" class="preview-name">Tên Danh Mục</div>
                                        <small class="text-muted d-block mt-1">0 sản phẩm</small>
                                    </div>

                                    <div class="d-flex align-items-center justify-content-center mb-4">
                                        <div class="form-check form-switch">
                                            <input class="form-check-input" type="checkbox" id="statusSwitch" checked>
                                            <label class="form-check-label fw-bold text-dark ms-2" for="statusSwitch" style="cursor:pointer;">Kích hoạt ngay</label>
                                        </div>
                                    </div>

                                    <button type="submit" class="btn btn-success w-100 rounded-pill py-2 fw-bold shadow-sm text-uppercase">
                                        <i class="fas fa-check me-2"></i> Lưu Danh Mục
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

    <script>
        function updatePreview() {
            var val = document.getElementById('catNameInput').value;
            var display = document.getElementById('prevName');
            
            if(val.trim() === "") display.innerText = "Tên Danh Mục";
            else display.innerText = val;

            var icon = document.getElementById('prevIcon');
            icon.classList.remove('typing-anim');
            void icon.offsetWidth; 
            icon.classList.add('typing-anim');
        }

        function updateIcon(radio) {
            var iconClass = radio.value;
            var prevIcon = document.getElementById('prevIcon');
            prevIcon.className = iconClass + " preview-icon typing-anim";
        }
    </script>

</body>
</html>
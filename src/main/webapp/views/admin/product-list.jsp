<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/common/taglib.jsp"%>
    <%@ include file="/common/admin/headlink.jsp"%>
    <meta charset="UTF-8">
    <title>Quản Lý Sản Phẩm - Fruitables</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">

    <style>
        /* --- 1. FIX LAYOUT CHO SIDEBAR --- */
        :root { --sidebar-width: 220px; }
        
        body.product-management {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            min-height: 100vh;
            overflow-x: hidden;
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
        /* --- END FIX LAYOUT --- */

        /* --- 2. HEADER THU NHỎ --- */
        .product-header {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 1rem; /* Giảm padding */
            border-radius: 15px 15px 0 0;
        }
        .product-header h1 {
            font-size: 1.5rem; /* Giảm cỡ chữ tiêu đề */
            margin-bottom: 0.25rem !important;
        }
        .product-header p {
            font-size: 0.9rem;
            margin-bottom: 0;
        }

        /* --- 3. THẺ THỐNG KÊ THU NHỎ --- */
        .stats-card {
            background: white;
            border-radius: 12px;
            padding: 1rem; /* Giảm padding */
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            border-left: 4px solid #28a745;
            margin-bottom: 1rem;
            height: 100%; /* Để các thẻ cao bằng nhau */
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        .stats-number {
            font-size: 1.8rem; /* Giảm cỡ số */
            font-weight: 700;
            color: #28a745;
            margin-bottom: 0.2rem;
            line-height: 1;
        }
        .stats-label {
            color: #6c757d;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.75rem; /* Giảm cỡ chữ label */
            letter-spacing: 0.5px;
        }
        .stats-icon-small {
            font-size: 1.5rem !important; /* Giảm cỡ icon */
            margin-top: 0.5rem !important;
        }

        /* --- CÁC STYLE CŨ GIỮ NGUYÊN --- */
        .product-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            border: none;
            transition: all 0.3s ease;
            overflow: hidden;
        }

        .product-table {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        }

        .product-table thead {
            background: linear-gradient(135deg, #343a40 0%, #495057 100%);
            color: white;
        }

        .product-table th {
            border: none; padding: 1rem; font-weight: 600;
            text-transform: uppercase; font-size: 0.85rem; letter-spacing: 0.5px;
        }

        .product-table td {
            padding: 1rem; vertical-align: middle; border-color: #f1f3f4;
        }

        .product-row { transition: all 0.3s ease; cursor: pointer; }
        .product-row:hover { background-color: #f8f9fa; transform: scale(1.01); }

        .product-image {
            width: 60px; height: 60px; /* Thu nhỏ ảnh chút cho gọn bảng */
            object-fit: cover; border-radius: 8px;
            border: 2px solid #e9ecef; transition: all 0.3s ease;
        }
        .product-row:hover .product-image { border-color: #28a745; transform: scale(1.1); }

        .product-name { font-weight: 600; color: #2c3e50; font-size: 0.95rem; }
        .product-price { font-weight: 700; color: #28a745; font-size: 1rem; }

        .product-category {
            background: #e3f2fd; color: #1976d2;
            padding: 0.3rem 0.6rem; border-radius: 20px;
            font-size: 0.75rem; font-weight: 600; text-transform: uppercase;
        }

        .product-description {
            color: #6c757d; font-size: 0.85rem; line-height: 1.4;
            display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
        }

        .action-buttons { display: flex; gap: 0.5rem; justify-content: center; }
        .btn-action {
            width: 35px; height: 35px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            border: none; transition: all 0.3s ease; font-size: 0.9rem;
        }

        .btn-edit { background: linear-gradient(135deg, #007bff 0%, #0056b3 100%); color: white; }
        .btn-edit:hover { transform: scale(1.1); box-shadow: 0 4px 12px rgba(0,123,255,0.3); }

        .btn-delete { background: linear-gradient(135deg, #dc3545 0%, #c82333 100%); color: white; }
        .btn-delete:hover { transform: scale(1.1); box-shadow: 0 4px 12px rgba(220,53,69,0.3); }

        .add-product-btn {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none; padding: 0.8rem 1.5rem; border-radius: 50px;
            font-weight: 600; font-size: 1rem; text-transform: uppercase;
            letter-spacing: 0.5px; transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(40,167,69,0.3); color: white; 
        }
        .add-product-btn:hover { transform: translateY(-3px); box-shadow: 0 8px 25px rgba(40,167,69,0.4); }

        .search-box {
            background: white; border-radius: 50px; padding: 0.5rem 1.5rem;
            border: 2px solid #e9ecef; transition: all 0.3s ease;
        }
        .search-box:focus { border-color: #28a745; box-shadow: 0 0 0 0.2rem rgba(40,167,69,0.25); }

        .filter-select {
            border-radius: 10px; border: 2px solid #e9ecef; padding: 0.5rem 1rem; transition: all 0.3s ease;
        }
        .filter-select:focus { border-color: #28a745; box-shadow: 0 0 0 0.2rem rgba(40,167,69,0.25); }

        .empty-state { text-align: center; padding: 3rem; color: #6c757d; }
        .empty-state i { font-size: 4rem; margin-bottom: 1rem; color: #dee2e6; }
    </style>
</head>
<body class="product-management">
    
    <%@ include file="/common/admin/header.jsp"%>
    
    <div class="main-content-wrapper">
        
        <div class="container-fluid py-3"> <div class="row mb-3"> <div class="col-12">
                    <div class="product-card">
                        <div class="product-header text-center">
                            <h1 class="h3 mb-1 fw-bold"> <i class="fas fa-shopping-basket me-2"></i>
                                QUẢN LÝ SẢN PHẨM
                            </h1>
                            <p class="mb-0 opacity-75 small">Quản lý và theo dõi tất cả sản phẩm trong hệ thống</p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-xl-3 col-md-6 mb-3 mb-xl-0">
                    <div class="stats-card">
                        <div class="stats-number">${not empty products ? products.size() : 0}</div>
                        <div class="stats-label">Tổng Sản Phẩm</div>
                        <i class="fas fa-cube stats-icon-small text-muted"></i>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6 mb-3 mb-xl-0">
                    <div class="stats-card">
                        <div class="stats-number">12</div>
                        <div class="stats-label">Đã Bán Hôm Nay</div>
                        <i class="fas fa-chart-line stats-icon-small text-muted"></i>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6 mb-3 mb-md-0">
                    <div class="stats-card">
                        <div class="stats-number">8</div>
                        <div class="stats-label">Sản Phẩm Mới</div>
                        <i class="fas fa-star stats-icon-small text-muted"></i>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="stats-card">
                        <div class="stats-number">4</div>
                        <div class="stats-label">Danh Mục</div>
                        <i class="fas fa-tags stats-icon-small text-muted"></i>
                    </div>
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-8">
                    <div class="d-flex gap-2 flex-wrap">
                        <div class="flex-grow-1">
                            <input type="text" id="searchInput" class="form-control search-box" placeholder="🔍 Tìm kiếm sản phẩm...">
                        </div>
                        <select class="form-select filter-select" style="width: 180px;">
                            <option value="">Tất cả danh mục</option>
                            <option value="1">Rau Sạch</option>
                            <option value="2">Quả Tươi Sạch</option>
                            <option value="3">Củ Sạch</option>
                        </select>
                        <select class="form-select filter-select" style="width: 140px;">
                            <option value="">Sắp xếp</option>
                            <option value="name">Tên A-Z</option>
                            <option value="price_asc">Giá tăng dần</option>
                            <option value="price_desc">Giá giảm dần</option>
                        </select>
                    </div>
                </div>
                <div class="col-md-4 text-end mt-2 mt-md-0">
                    <a href="${pageContext.request.contextPath}/admin/addproduct" 
                       class="btn add-product-btn">
                        <i class="fas fa-plus-circle me-2"></i>
                        THÊM MỚI
                    </a>
                </div>
            </div>

            <div class="row">
                <div class="col-12">
                    <div class="product-card">
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0 product-table">
                                    <thead>
                                        <tr>
                                            <th scope="col" style="width: 60px;">ID</th>
                                            <th scope="col" style="width: 200px;">SẢN PHẨM</th>
                                            <th scope="col" style="width: 120px;">GIÁ</th>
                                            <th scope="col" style="width: 140px;">DANH MỤC</th>
                                            <th scope="col" style="width: 90px;">ẢNH</th>
                                            <th scope="col">MÔ TẢ</th>
                                            <th scope="col" style="width: 100px;">THAO TÁC</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:if test="${not empty products && products.size() > 0}">
                                            <c:forEach items="${products}" var="product">
                                                <c:url value="/templates/user/img/${product.image}" var="imgUrl"></c:url>
                                                <tr class="product-row" data-product-id="${product.id}">
                                                    <td><span class="badge bg-secondary">#${product.id}</span></td>
                                                    <td><div class="product-name">${product.name}</div></td>
                                                    <td><div class="product-price"><fmt:formatNumber value="${product.price}" pattern="#,###"/> ₫</div></td>
                                                    <td><span class="product-category">${product.category.name}</span></td>
                                                    <td>
                                                        <img src="${imgUrl}" alt="${product.name}" class="product-image" onerror="this.src='https://via.placeholder.com/80x80?text=No+Image'">
                                                    </td>
                                                    <td><div class="product-description" title="${product.des}">${product.des}</div></td>
                                                    <td>
                                                        <div class="action-buttons">
                                                            <a href="${pageContext.request.contextPath}/admin/editproduct?pId=${product.id}" class="btn btn-action btn-edit" title="Sửa"><i class="fas fa-edit"></i></a>
                                                            <a href="${pageContext.request.contextPath}/admin/deleteproduct?pId=${product.id}" class="btn btn-action btn-delete" title="Xóa" onclick="return confirm('Xóa sản phẩm này?')"><i class="fas fa-trash"></i></a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:if>
                                        <c:if test="${empty products || products.size() == 0}">
                                            <tr>
                                                <td colspan="7">
                                                    <div class="empty-state">
                                                        <i class="fas fa-box-open text-muted mb-3" style="font-size: 3rem;"></i>
                                                        <h5 class="text-muted">Chưa có sản phẩm nào</h5>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <c:if test="${not empty products && products.size() > 0}">
                <div class="row mt-3">
                    <div class="col-12">
                        <nav aria-label="Page navigation">
                            <ul class="pagination justify-content-center pagination-sm">
                                <li class="page-item disabled"><a class="page-link" href="#"><i class="fas fa-chevron-left"></i></a></li>
                                <li class="page-item active"><a class="page-link" href="#">1</a></li>
                                <li class="page-item"><a class="page-link" href="#">2</a></li>
                                <li class="page-item"><a class="page-link" href="#">3</a></li>
                                <li class="page-item"><a class="page-link" href="#"><i class="fas fa-chevron-right"></i></a></li>
                            </ul>
                        </nav>
                    </div>
                </div>
            </c:if>
        </div>
    
    </div> <%@ include file="/common/admin/footer.jsp"%>
    <%@ include file="/common/admin/lastBodyScript.jsp"%>

    <script>
    $(document).ready(function() {
        $(".product-row").on("click", function(e) {
            if (!$(e.target).closest('.action-buttons').length && !$(e.target).closest('a').length) {
                var productId = $(this).data("product-id");
                window.location.href = '${pageContext.request.contextPath}/admin/editproduct?pId=' + productId;
            }
        });

        $('#searchInput').on('input', function() {
            var searchText = $(this).val().toLowerCase();
            $('.product-row').each(function() {
                var productName = $(this).find('.product-name').text().toLowerCase();
                var productDesc = $(this).find('.product-description').text().toLowerCase();
                if (productName.includes(searchText) || productDesc.includes(searchText)) {
                    $(this).show();
                } else {
                    $(this).hide();
                }
            });
        });
    });
    </script>
</body>
</html>
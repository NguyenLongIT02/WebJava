<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav class="sidebar-wrapper bg-white shadow-sm d-flex flex-column justify-content-between">
    
    <div class="sidebar-header p-4 border-bottom">
        <a href="${pageContext.request.contextPath}/admin/statistics" class="text-decoration-none d-flex align-items-center">
            <i class="fas fa-seedling text-success fa-2x me-2"></i>
            <div>
                <h1 class="h5 fw-bold text-success mb-0" style="letter-spacing: 1px;">FRUITABLES</h1>
                <small class="text-muted" style="font-size: 11px;">Admin Dashboard</small>
            </div>
        </a>
    </div>

    <div class="sidebar-menu flex-grow-1 p-3 overflow-auto">
        <c:set var="currentURL" value="${pageContext.request.requestURI}" />
        <c:set var="currentPath" value="${pageContext.request.servletPath}" />

        <ul class="nav nav-pills flex-column">

            <li class="nav-item mb-1">
                <a href="${pageContext.request.contextPath}/admin/statistics" 
                   class="nav-link ${currentURL.contains('statistics') || currentURL.contains('dashboard') ? 'active' : ''}">
                    <i class="fas fa-tachometer-alt me-3 width-20"></i> 
                    Dashboard
                </a>
            </li>

            <li class="nav-item mb-1">
                <a href="${pageContext.request.contextPath}/admin/order" 
                   class="nav-link ${currentURL.contains('order') ? 'active' : ''}">
                    <i class="fas fa-receipt me-3 width-20"></i> 
                    Đơn Hàng
                </a>
            </li>

            <li class="nav-item mb-1">
                <a href="${pageContext.request.contextPath}/admin/productlist" 
                   class="nav-link ${currentURL.contains('product') ? 'active' : ''}">
                    <i class="fas fa-shopping-basket me-3 width-20"></i> 
                    Sản Phẩm
                </a>
            </li>

            <li class="nav-item mb-1">
                <a href="${pageContext.request.contextPath}/admin/category" 
                   class="nav-link ${currentURL.contains('category') ? 'active' : ''}">
                    <i class="fas fa-tags me-3 width-20"></i> 
                    Danh Mục
                </a>
            </li>

            <li class="nav-item mb-1">
                <a href="${pageContext.request.contextPath}/admin/account" 
                   class="nav-link ${currentURL.contains('account') ? 'active' : ''}">
                    <i class="fas fa-users me-3 width-20"></i> 
                    Tài Khoản
                </a>
            </li>
        </ul>
    </div>

    <div class="sidebar-footer p-3 border-top bg-light">
        <div class="d-flex align-items-center">
            <div class="flex-shrink-0">
                <c:if test="${not empty sessionScope.currentUser.avatar}">
                    <img src="${pageContext.request.contextPath}/${sessionScope.currentUser.avatar}" 
                         alt="User" class="rounded-circle border border-2 border-white shadow-sm" 
                         style="width: 40px; height: 40px; object-fit: cover;">
                </c:if>
                <c:if test="${empty sessionScope.currentUser.avatar}">
                    <div class="rounded-circle bg-success d-flex align-items-center justify-content-center text-white shadow-sm" 
                         style="width: 40px; height: 40px;">
                        <i class="fas fa-user"></i>
                    </div>
                </c:if>
            </div>
            
            <div class="flex-grow-1 ms-2 overflow-hidden">
                <div class="fw-bold text-dark text-truncate" style="font-size: 14px;">
                    ${sessionScope.currentUser.username}
                </div>
                <small class="text-muted">Admin</small>
            </div>

            <a href="${pageContext.request.contextPath}/logout" 
               class="btn btn-light btn-sm text-danger border-0" 
               title="Đăng xuất"
               onclick="return confirm('Bạn chắc chắn muốn đăng xuất?')">
                <i class="fas fa-sign-out-alt"></i>
            </a>
        </div>
    </div>
</nav>

<style>
    /* 1. Cấu trúc cố định Sidebar */
    .sidebar-wrapper {
        position: fixed;
        top: 0;
        left: 0;
        width: 220px; 
        height: 100vh;
        z-index: 1000;
        background-color: #fff;
        border-right: 1px solid rgba(0,0,0,0.08);
        transition: all 0.3s ease-in-out;
        display: flex;
        flex-direction: column;
    }

    /* 2. Style cho từng Link Menu (QUAN TRỌNG NHẤT) */
    .sidebar-menu .nav-link {
        color: #5e6e82;
        font-weight: 600; /* Chữ đậm hơn chút cho dễ đọc */
        padding: 12px 20px; /* Khoảng cách thoáng hơn */
        border-radius: 8px;
        margin-bottom: 4px;
        
        /* BẮT BUỘC NẰM NGANG */
        display: flex !important;
        flex-direction: row !important;
        align-items: center !important; /* Căn giữa theo chiều dọc */
        justify-content: flex-start !important; /* Căn trái */
        text-align: left !important;
    }

    /* 3. Chỉnh Icon nằm bên trái chữ */
    .sidebar-menu .nav-link i {
        width: 25px; /* Chiều rộng cố định cho icon để chữ thẳng hàng */
        text-align: center;
        margin-right: 10px !important; /* Cách chữ ra 10px */
        margin-bottom: 0 !important; /* Không cho margin dưới */
        font-size: 1.1rem;
    }
    
    /* 4. Chỉnh chữ bên cạnh */
    .sidebar-menu .nav-link span, 
    .sidebar-menu .nav-link div {
        line-height: 1.2; /* Chỉnh dòng chữ gọn lại */
    }

    /* 5. Hiệu ứng Hover */
    .sidebar-menu .nav-link:hover {
        color: #28a745;
        background-color: #e9f7ef; /* Màu nền xanh nhạt khi di chuột */
        transform: translateX(5px); /* Hiệu ứng đẩy nhẹ sang phải */
    }

    /* 6. Trạng thái Active (Đang chọn) */
    .sidebar-menu .nav-link.active {
        background: linear-gradient(45deg, #28a745, #20c997) !important;
        color: #fff !important;
        box-shadow: 0 4px 10px rgba(40, 167, 69, 0.3);
    }

    .sidebar-menu .nav-link.active i {
        color: #fff !important;
    }

    /* Badge New (nếu có) */
    .badge {
        margin-left: auto; /* Đẩy badge sang tận cùng bên phải */
    }
    
    /* Responsive: Ẩn trên mobile */
    @media (max-width: 992px) {
        .sidebar-wrapper {
            transform: translateX(-100%);
        }
    }
</style>
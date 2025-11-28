<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<nav class="navbar navbar-expand-xl navbar-light bg-light shadow-sm">
	<div class="container h-100">
		<!-- Brand logo -->
		<a class="navbar-brand" href="${pageContext.request.contextPath}/admin-dashboard">
			<div class="d-flex align-items-center">
				<i class="fas fa-seedling text-success fa-2x me-2"></i>
				<h1 class="tm-site-title mb-0 fs-3 fw-bold text-success">FRUITABLES</h1>
			</div>
		</a>
		
		<button class="navbar-toggler" type="button"
			data-toggle="collapse" data-target="#navbarSupportedContent"
			aria-controls="navbarSupportedContent" aria-expanded="false"
			aria-label="Toggle navigation">
			<i class="fas fa-bars tm-nav-icon"></i>
		</button>
	
		<c:set var="currentURL" value="${pageContext.request.requestURI}" />
		<c:set var="currentPath" value="${pageContext.request.servletPath}" />
		
		<div class="collapse navbar-collapse" id="navbarSupportedContent">
    		<ul class="navbar-nav mx-auto h-100">
        		<!-- Dashboard -->
        		<li class="nav-item mx-1">
            		<a class="nav-link px-3 py-2 rounded ${currentURL.contains('dashboard') || currentPath.contains('dashboard') || currentURL.contains('statistics') ? 'active' : ''}" 
               		   href="${pageContext.request.contextPath}/admin/statistics">
                		<i class="fas fa-tachometer-alt me-2"></i> 
                		<span class="fw-semibold">Dashboard</span>
            		</a>
        		</li>

        		<!-- Đơn hàng -->
        		<li class="nav-item mx-1">
            		<a class="nav-link px-3 py-2 rounded ${currentURL.contains('order') || currentPath.contains('order') || currentURL.contains('cart') ? 'active' : ''}" 
               		   href="${pageContext.request.contextPath}/admin">
                		<i class="fas fa-receipt me-2"></i> 
                		<span class="fw-semibold">Đơn Hàng</span>
            		</a>
        		</li>

        		<!-- Sản phẩm -->
        		<li class="nav-item mx-1">
            		<a class="nav-link px-3 py-2 rounded ${currentURL.contains('product') || currentPath.contains('product') ? 'active' : ''}" 
               		   href="${pageContext.request.contextPath}/admin/productlist">
                		<i class="fas fa-shopping-basket me-2"></i> 
                		<span class="fw-semibold">Sản Phẩm</span>
            		</a>
        		</li>

        		<!-- Danh mục -->
        		<li class="nav-item mx-1">
            		<a class="nav-link px-3 py-2 rounded ${currentURL.contains('category') || currentPath.contains('category') ? 'active' : ''}" 
               		   href="${pageContext.request.contextPath}/admin/category">
                		<i class="fas fa-tags me-2"></i> 
                		<span class="fw-semibold">Danh Mục</span>
            		</a>
        		</li>

        		<!-- Tài khoản -->
        		<li class="nav-item mx-1">
            		<a class="nav-link px-3 py-2 rounded ${currentURL.contains('account') || currentPath.contains('account') ? 'active' : ''}" 
               		   href="${pageContext.request.contextPath}/admin/account">
                		<i class="fas fa-users me-2"></i> 
                		<span class="fw-semibold">Tài Khoản</span>
            		</a>
        		</li>
    		</ul>
		</div>
		
		<!-- User info -->
		<ul class="navbar-nav">
			<li class="nav-item">
				<div class="d-flex align-items-center">
					<c:if test="${not empty sessionScope.currentUser.avatar}">
						<img src="${pageContext.request.contextPath}/${sessionScope.currentUser.avatar}" 
							 alt="Avatar" 
							 class="rounded-circle me-2" 
							 style="width: 40px; height: 40px; object-fit: cover;">
					</c:if>
					<c:if test="${empty sessionScope.currentUser.avatar}">
						<div class="rounded-circle bg-success d-flex align-items-center justify-content-center me-2" 
							 style="width: 40px; height: 40px;">
							<i class="fas fa-user text-white"></i>
						</div>
					</c:if>
					<div class="user-info me-3">
						<small class="text-muted d-block">Xin chào</small>
						<strong class="text-dark">${sessionScope.currentUser.username}</strong>
					</div>
					<a href="${pageContext.request.contextPath}/logout" 
					   class="btn btn-outline-danger btn-sm logout-btn" 
					   title="Đăng xuất"
					   onclick="return confirm('Bạn có chắc muốn đăng xuất?')">
						<i class="fas fa-sign-out-alt me-1"></i>
						<span>Thoát</span>
					</a>
				</div>
			</li>
		</ul>
	</div>
</nav>

<style>
.navbar {
    background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%) !important;
    border-bottom: 3px solid #28a745 !important;
    padding: 0.8rem 0;
}

.nav-link {
    color: #495057 !important;
    transition: all 0.3s ease;
    border: 1px solid transparent;
    font-weight: 500;
}

.nav-link:hover {
    color: #28a745 !important;
    background-color: #e9f7ef !important;
    border-color: #28a745;
    transform: translateY(-2px);
}

.nav-link.active {
    background: linear-gradient(135deg, #28a745 0%, #20c997 100%) !important;
    color: white !important;
    border-color: #28a745;
    box-shadow: 0 4px 8px rgba(40, 167, 69, 0.3);
}

.navbar-brand {
    transition: transform 0.3s ease;
}

.navbar-brand:hover {
    transform: scale(1.05);
}

.user-info {
    font-size: 0.9rem;
    line-height: 1.2;
}

.logout-btn {
    border-width: 2px;
    font-weight: 500;
    padding: 0.375rem 0.75rem;
    transition: all 0.3s ease;
}

.logout-btn:hover {
    transform: scale(1.05);
    background-color: #dc3545;
    color: white;
}

/* Responsive */
@media (max-width: 1200px) {
    .navbar-nav .nav-item {
        margin: 0.2rem 0;
    }
    
    .nav-link {
        padding: 0.5rem 1rem !important;
    }
}

/* Animation */
@keyframes fadeIn {
    from { opacity: 0; transform: translateY(-10px); }
    to { opacity: 1; transform: translateY(0); }
}

.navbar {
    animation: fadeIn 0.5s ease-out;
}
</style>
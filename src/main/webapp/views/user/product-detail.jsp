<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
		<!DOCTYPE html>
		<html lang="vi">

		<head>
			<%@ include file="/common/taglib.jsp" %>
				<%@ include file="/common/headlink.jsp" %>
					<meta charset="utf-8">
					<title>Chi Tiết Sản Phẩm - Fruitables</title>
					<meta content="width=device-width, initial-scale=1.0" name="viewport">

					<!-- Custom CSS cho trang chi tiết -->
					<style>
						.product-image-wrapper {
							border-radius: 15px;
							overflow: hidden;
							box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
							border: 1px solid #eee;
						}

						.product-title {
							font-weight: 700;
							color: #45595b;
							font-size: 2rem;
						}

						.product-price {
							font-size: 1.8rem;
							font-weight: 700;
							color: #81c408;
							/* Fruitables Green */
						}

						.star-rating i {
							color: #ffb524;
							/* Star Yellow */
						}

						.quantity-wrapper {
							display: flex;
							align-items: center;
							gap: 10px;
							background: #f8f9fa;
							padding: 5px;
							border-radius: 30px;
							width: fit-content;
							border: 1px solid #e9ecef;
						}

						.btn-qty {
							width: 35px;
							height: 35px;
							border-radius: 50% !important;
							display: flex;
							align-items: center;
							justify-content: center;
							border: none;
							background: white;
							color: #333;
							box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
							transition: all 0.2s;
						}

						.btn-qty:hover {
							background: #81c408;
							color: white;
							transform: translateY(-2px);
						}

						.qty-input {
							width: 50px;
							text-align: center;
							border: none;
							background: transparent;
							font-weight: 700;
							font-size: 1.1rem;
							color: #45595b;
						}

						.qty-input:focus {
							outline: none;
						}

						.btn-add-cart {
							background: #81c408;
							color: white;
							border: none;
							padding: 12px 30px;
							border-radius: 30px;
							font-weight: 600;
							text-transform: uppercase;
							transition: all 0.3s;
							box-shadow: 0 4px 15px rgba(129, 196, 8, 0.3);
						}

						.btn-add-cart:hover {
							background: #6fa806;
							transform: translateY(-2px);
							box-shadow: 0 6px 20px rgba(129, 196, 8, 0.4);
							color: white;
						}

						.stock-badge {
							background: #e9ecef;
							color: #6c757d;
							padding: 5px 12px;
							border-radius: 20px;
							font-size: 0.85rem;
							font-weight: 600;
						}

						/* Toast Notification */
						.toast-notification {
							position: fixed;
							top: 20px;
							right: 20px;
							background: white;
							padding: 15px 25px;
							border-radius: 10px;
							box-shadow: 0 5px 20px rgba(0, 0, 0, 0.15);
							display: flex;
							align-items: center;
							gap: 15px;
							z-index: 9999;
							transform: translateX(120%);
							transition: transform 0.3s ease-out;
							border-left: 5px solid #81c408;
						}

						.toast-notification.show {
							transform: translateX(0);
						}

						.toast-notification.error {
							border-left-color: #dc3545;
						}

						.toast-notification.warning {
							border-left-color: #ffc107;
						}

						.toast-icon {
							font-size: 1.5rem;
						}

						.toast-content h6 {
							margin: 0;
							font-weight: 700;
							font-size: 0.95rem;
						}

						.toast-content p {
							margin: 0;
							font-size: 0.85rem;
							color: #666;
						}
					</style>
		</head>

		<body>
			<%@ include file="/common/header.jsp" %>

				<!-- Breadcrumb -->
				<div class="container-fluid page-header py-5">
					<h1 class="text-center text-white display-6">${product.name}</h1>
					<ol class="breadcrumb justify-content-center mb-0">
						<li class="breadcrumb-item"><a href="<c:url value='/home'/>">Trang chủ</a></li>
						<li class="breadcrumb-item"><a href="#">${product.category.name}</a></li>
						<li class="breadcrumb-item active text-white">${product.name}</li>
					</ol>
				</div>

				<!-- Product Detail Start -->
				<div class="container-fluid py-5 mt-5">
					<div class="container py-5">
						<div class="row g-4 mb-5">
							<div class="col-lg-8 col-xl-9">
								<div class="row g-4">
									<!-- Product Image -->
									<div class="col-lg-6">
										<div class="product-image-wrapper">
											<a href="#">
												<img src="<c:url value='/templates/user/img/${product.image}'/>"
													class="img-fluid w-100" alt="${product.name}">
											</a>
										</div>
									</div>

									<!-- Product Info -->
									<div class="col-lg-6">
										<h4 class="fw-bold mb-3 text-secondary">Sản phẩm nổi bật</h4>
										<h1 class="product-title mb-3">${product.name}</h1>
										<p class="mb-3 text-muted">Danh mục: <span
												class="text-dark fw-bold">${product.category.name}</span></p>

										<div class="d-flex align-items-center mb-3">
											<h5 class="product-price me-4">$${product.price}</h5>
											<div class="star-rating">
												<i class="fa fa-star"></i>
												<i class="fa fa-star"></i>
												<i class="fa fa-star"></i>
												<i class="fa fa-star"></i>
												<i class="fa fa-star"></i>
											</div>
										</div>

										<p class="mb-4 text-muted">${product.des}</p>

										<!-- Stock Info -->
										<div class="mb-4">
											<span class="stock-badge">
												<i class="fas fa-box-open me-2"></i>Còn lại:
												<span id="stockDisplay">${product.quantity != null ? product.quantity :
													999}</span>
											</span>
										</div>

										<form action="<c:url value='product'/>" method="get" id="addToCartForm">
											<input type="hidden" name="action" value="add">
											<input type="hidden" name="pId" value="${product.id}">

											<div class="d-flex align-items-center gap-4 mb-4">
												<!-- Quantity Controller -->
												<div class="quantity-wrapper">
													<button type="button" class="btn-qty" id="btnMinus">
														<i class="fa fa-minus"></i>
													</button>
													<input type="text" class="qty-input" name="quantity" value="1"
														id="quantityInput">
													<button type="button" class="btn-qty" id="btnPlus">
														<i class="fa fa-plus"></i>
													</button>
												</div>

												<!-- Add Button -->
												<button type="submit" class="btn-add-cart">
													<i class="fa fa-shopping-bag me-2"></i>Thêm vào giỏ
												</button>
											</div>
										</form>
									</div>

									<!-- Description Tab -->
									<div class="col-lg-12">
										<nav>
											<div class="nav nav-tabs mb-3">
												<button class="nav-link active border-white border-bottom-0"
													type="button" role="tab" id="nav-about-tab" data-bs-toggle="tab"
													data-bs-target="#nav-about" aria-controls="nav-about"
													aria-selected="true">Mô tả chi tiết</button>
											</div>
										</nav>
										<div class="tab-content mb-5">
											<div class="tab-pane active" id="nav-about" role="tabpanel"
												aria-labelledby="nav-about-tab">
												<p>${product.des}</p>

												<div class="px-2">
													<div class="row g-4">
														<div class="col-6">
															<div
																class="row bg-light align-items-center text-center justify-content-center py-2">
																<div class="col-6">
																	<p class="mb-0">Trọng lượng</p>
																</div>
																<div class="col-6">
																	<p class="mb-0">1 kg</p>
																</div>
															</div>
															<div
																class="row text-center align-items-center justify-content-center py-2">
																<div class="col-6">
																	<p class="mb-0">Xuất xứ</p>
																</div>
																<div class="col-6">
																	<p class="mb-0">Organic Farm</p>
																</div>
															</div>
															<div
																class="row bg-light text-center align-items-center justify-content-center py-2">
																<div class="col-6">
																	<p class="mb-0">Chất lượng</p>
																</div>
																<div class="col-6">
																	<p class="mb-0">Hữu cơ</p>
																</div>
															</div>
														</div>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>

							<!-- Sidebar (Banner) -->
							<div class="col-lg-4 col-xl-3">
								<div class="row g-4 fruite">
									<div class="col-lg-12">
										<div class="position-relative rounded overflow-hidden">
											<img src="<c:url value='/templates/user/img/banner-fruits.jpg'/>"
												class="img-fluid w-100 rounded" alt="">
											<div class="position-absolute"
												style="top: 50%; right: 10px; transform: translateY(-50%);">
												<h3 class="text-secondary fw-bold">Fresh <br> Fruits <br> Banner</h3>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>

						<!-- Related Products -->
						<h1 class="fw-bold mb-0">Sản phẩm liên quan</h1>
						<div class="vesitable">
							<div class="owl-carousel vegetable-carousel justify-content-center">
								<c:forEach items="${relatedProducts}" var="relatedProduct">
									<div class="border border-primary rounded position-relative vesitable-item"
										style="height: 100%;">
										<div class="vesitable-img">
											<a href="<c:url value='product?action=detail&id=${relatedProduct.id}'/>">
												<img src="<c:url value='/templates/user/img/${relatedProduct.image}'/>"
													class="img-fluid w-100 rounded-top" alt="">
											</a>
										</div>
										<div class="text-white bg-primary px-3 py-1 rounded position-absolute"
											style="top: 10px; right: 10px;">
											${relatedProduct.category.name}
										</div>
										<div class="p-4 pb-0 rounded-bottom">
											<h4>${relatedProduct.name}</h4>
											<p class="text-truncate">${relatedProduct.des}</p>
											<div class="d-flex justify-content-between flex-lg-wrap">
												<p class="text-dark fs-5 fw-bold">$${relatedProduct.price}</p>
												<a href="<c:url value='product?action=detail&id=${relatedProduct.id}'/>"
													class="btn border border-secondary rounded-pill px-3 py-1 mb-4 text-primary">
													<i class="fa fa-shopping-bag me-2 text-primary"></i> Thêm
												</a>
											</div>
										</div>
									</div>
								</c:forEach>
							</div>
						</div>
					</div>
				</div>

				<!-- Toast Notification Element -->
				<div id="toast" class="toast-notification">
					<div class="toast-icon" id="toastIcon">✅</div>
					<div class="toast-content">
						<h6 id="toastTitle">Thành công</h6>
						<p id="toastMessage">Đã thêm vào giỏ hàng</p>
					</div>
				</div>

				<%@ include file="/common/footer.jsp" %>
					<%@ include file="/common/lastBodyScript.jsp" %>
						<jsp:include page="/common/chatbot.jsp" />

						<!-- Script xử lý logic -->
						<script>
							document.addEventListener('DOMContentLoaded', function () {
								// 1. Khởi tạo biến
								const stock = parseInt('${product.quantity != null ? product.quantity : 999}');
								const price = parseFloat('${product.price}');
								const productName = '${product.name}';

								const btnMinus = document.getElementById('btnMinus');
								const btnPlus = document.getElementById('btnPlus');
								const inputQty = document.getElementById('quantityInput');
								const form = document.getElementById('addToCartForm');

								// Toast elements
								const toast = document.getElementById('toast');
								const toastIcon = document.getElementById('toastIcon');
								const toastTitle = document.getElementById('toastTitle');
								const toastMessage = document.getElementById('toastMessage');

								// 2. Hàm hiển thị Toast
								function showToast(type, title, message) {
									// Reset classes
									toast.className = 'toast-notification';

									// Set content
									toastTitle.textContent = title;
									toastMessage.textContent = message;

									// Set type specific styles
									if (type === 'success') {
										toastIcon.textContent = '✅';
										toast.style.borderLeftColor = '#81c408';
									} else if (type === 'error') {
										toastIcon.textContent = '❌';
										toast.classList.add('error');
									} else if (type === 'warning') {
										toastIcon.textContent = '⚠️';
										toast.classList.add('warning');
									}

									// Show toast
									toast.classList.add('show');

									// Hide after 3s
									setTimeout(() => {
										toast.classList.remove('show');
									}, 3000);
								}

								// 3. Xử lý tăng giảm
								btnMinus.addEventListener('click', function () {
									let currentVal = parseInt(inputQty.value) || 1;
									if (currentVal > 1) {
										inputQty.value = currentVal - 1;
									} else {
										showToast('warning', 'Thông báo', 'Số lượng tối thiểu là 1');
									}
								});

								btnPlus.addEventListener('click', function () {
									let currentVal = parseInt(inputQty.value) || 1;
									if (currentVal < stock) {
										inputQty.value = currentVal + 1;
									} else {
										showToast('warning', 'Hết hàng', 'Chỉ còn ' + stock + ' sản phẩm trong kho');
									}
								});

								// 4. Validate input trực tiếp
								inputQty.addEventListener('input', function () {
									// Chỉ cho nhập số
									this.value = this.value.replace(/[^0-9]/g, '');
								});

								inputQty.addEventListener('blur', function () {
									let val = parseInt(this.value);
									if (isNaN(val) || val < 1) {
										this.value = 1;
										showToast('warning', 'Điều chỉnh', 'Số lượng không hợp lệ, đã đặt về 1');
									} else if (val > stock) {
										this.value = stock;
										showToast('warning', 'Điều chỉnh', 'Số lượng vượt quá tồn kho, đã đặt về tối đa');
									}
								});

								// 5. Xử lý Submit Form
								form.addEventListener('submit', function (e) {
									const qty = parseInt(inputQty.value);

									if (isNaN(qty) || qty < 1) {
										e.preventDefault();
										showToast('error', 'Lỗi', 'Vui lòng nhập số lượng hợp lệ');
										return;
									}

									if (qty > stock) {
										e.preventDefault();
										showToast('error', 'Lỗi', 'Số lượng vượt quá tồn kho');
										return;
									}

									// Nếu hợp lệ, form sẽ submit bình thường
									
								});
							});
						</script>
		</body>

		</html>
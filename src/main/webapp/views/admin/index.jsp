<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <%@ include file="/common/taglib.jsp" %>
                        <%@ include file="/common/admin/headlink.jsp" %>

                            <meta charset="UTF-8">
                            <title>Quản Lý Đơn Hàng</title>
                            <meta content="width=device-width, initial-scale=1.0" name="viewport">

                            <link
                                href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap"
                                rel="stylesheet">
                            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
                                rel="stylesheet">
                            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
                                rel="stylesheet">

                            <style>
                                :root {
                                    --sidebar-width: 220px;
                                    --bg-body: #f0f2f5;
                                }

                                body {
                                    background-color: var(--bg-body);
                                    font-family: 'Poppins', sans-serif;
                                    font-size: 0.9rem;
                                }

                                .main-content {
                                    margin-left: var(--sidebar-width);
                                    padding: 25px;
                                    min-height: 100vh;
                                }

                                .page-header {
                                    background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                                    border-radius: 12px;
                                    padding: 1.5rem;
                                    color: white;
                                    text-align: center;
                                    box-shadow: 0 4px 15px rgba(40, 167, 69, 0.2);
                                    margin-bottom: 25px;
                                }

                                .page-header h4 {
                                    font-size: 1.5rem;
                                    font-weight: 800;
                                    margin-bottom: 5px;
                                }

                                .order-card {
                                    background: white;
                                    border-radius: 12px;
                                    padding: 20px;
                                    margin-bottom: 15px;
                                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
                                    border-left: 4px solid #28a745;
                                    transition: all 0.3s;
                                }

                                .order-card:hover {
                                    transform: translateY(-3px);
                                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.12);
                                }

                                .order-card.status-new {
                                    border-left-color: #ffc107;
                                }

                                .order-card.status-shipping {
                                    border-left-color: #0d6efd;
                                }

                                .order-card.status-completed {
                                    border-left-color: #28a745;
                                }

                                .order-card.status-cancelled {
                                    border-left-color: #dc3545;
                                }

                                .order-id {
                                    font-weight: 700;
                                    color: #333;
                                    font-size: 1rem;
                                }

                                .status-badge {
                                    padding: 5px 12px;
                                    border-radius: 20px;
                                    font-size: 0.8rem;
                                    font-weight: 600;
                                }

                                .badge-new {
                                    background: #fff3cd;
                                    color: #856404;
                                }

                                .badge-shipping {
                                    background: #cfe2ff;
                                    color: #084298;
                                }

                                .badge-completed {
                                    background: #d1e7dd;
                                    color: #0f5132;
                                }

                                .badge-cancelled {
                                    background: #f8d7da;
                                    color: #842029;
                                }

                                .action-buttons {
                                    display: flex;
                                    flex-wrap: nowrap;
                                    gap: 5px;
                                    align-items: center;
                                }

                                .btn-action {
                                    padding: 6px 12px;
                                    border-radius: 6px;
                                    font-size: 0.8rem;
                                    font-weight: 600;
                                    border: none;
                                    transition: all 0.2s;
                                    white-space: nowrap;
                                    flex-shrink: 0;
                                }

                                .btn-confirm {
                                    background: #28a745;
                                    color: white;
                                }

                                .btn-confirm:hover {
                                    background: #218838;
                                    color: white;
                                }

                                .btn-cancel {
                                    background: #ffc107;
                                    color: #333;
                                }

                                .btn-cancel:hover {
                                    background: #e0a800;
                                }

                                .btn-delete {
                                    background: #dc3545;
                                    color: white;
                                }

                                .btn-delete:hover {
                                    background: #c82333;
                                    color: white;
                                }

                                .btn-view {
                                    background: #6c757d;
                                    color: white;
                                }

                                .btn-view:hover {
                                    background: #5a6268;
                                    color: white;
                                }
                            </style>
                </head>

                <body>

                    <%@ include file="/common/admin/header.jsp" %>

                        <div class="main-content">

                            <div class="page-header">
                                <h4><i class="fas fa-shopping-cart me-2"></i>Quản Lý Đơn Hàng</h4>
                                <span>Theo dõi và xử lý đơn hàng</span>
                            </div>

                            <div class="order-list">
                                <c:choose>
                                    <c:when test="${not empty cartDetailList}">
                                        <c:forEach items="${cartDetailList}" var="order">
                                            <c:if test="${not empty order.id and not empty order.buyer}">

                                                <%-- Determine status class and badge --%>
                                                    <c:set var="statusClass" value="status-new" />
                                                    <c:set var="statusBadge" value="badge-new" />
                                                    <c:set var="statusText" value="Chờ xác nhận" />

                                                    <c:if test="${order.status == 0}">
                                                        <c:set var="statusClass" value="status-cancelled" />
                                                        <c:set var="statusBadge" value="badge-cancelled" />
                                                        <c:set var="statusText" value="Đã hủy" />
                                                    </c:if>
                                                    <c:if test="${order.status == 2}">
                                                        <c:set var="statusClass" value="status-shipping" />
                                                        <c:set var="statusBadge" value="badge-shipping" />
                                                        <c:set var="statusText" value="Đang giao" />
                                                    </c:if>
                                                    <c:if test="${order.status == 3}">
                                                        <c:set var="statusClass" value="status-completed" />
                                                        <c:set var="statusBadge" value="badge-completed" />
                                                        <c:set var="statusText" value="Hoàn thành" />
                                                    </c:if>

                                                    <div class="order-card ${statusClass}">
                                                        <div class="row align-items-center">
                                                            <div class="col-md-3">
                                                                <div class="order-id">#${fn:substring(order.id, 0,
                                                                    8)}...</div>
                                                                <div class="text-muted small">${order.buyer}</div>
                                                                <div class="text-muted small">${order.email}</div>
                                                            </div>

                                                            <div class="col-md-2">
                                                                <div class="text-muted small">Ngày đặt</div>
                                                                <div>
                                                                    <c:choose>
                                                                        <c:when test="${not empty order.orderDate}">
                                                                            <fmt:formatDate value="${order.orderDate}"
                                                                                pattern="dd/MM/yyyy HH:mm" />
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="text-muted">--/--/----</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                            </div>

                                                            <div class="col-md-2">
                                                                <div class="text-muted small">Tổng tiền</div>
                                                                <div class="fw-bold text-success">
                                                                    <fmt:formatNumber
                                                                        value="${order.sumToTal != null ? order.sumToTal : 0}"
                                                                        pattern="#,###" /> ₫
                                                                </div>
                                                            </div>

                                                            <div class="col-md-2">
                                                                <span
                                                                    class="status-badge ${statusBadge}">${statusText}</span>
                                                            </div>

                                                            <div class="col-md-3 text-end">
                                                                <div class="action-buttons justify-content-end">
                                                                    <button class="btn-action btn-view"
                                                                        title="Xem chi tiết">
                                                                        <i class="fas fa-eye"></i>
                                                                    </button>

                                                                    <c:if
                                                                        test="${order.status == 1 or empty order.status}">
                                                                        <form action="<c:url value='/admin/order'/>"
                                                                            method="POST" style="display:inline;">
                                                                            <input type="hidden" name="action"
                                                                                value="confirm">
                                                                            <input type="hidden" name="id"
                                                                                value="${order.id}">
                                                                            <button type="submit"
                                                                                class="btn-action btn-confirm"
                                                                                title="Xác nhận">
                                                                                <i class="fas fa-check"></i> Duyệt
                                                                            </button>
                                                                        </form>
                                                                        <form action="<c:url value='/admin/order'/>"
                                                                            method="POST" style="display:inline;"
                                                                            onsubmit="return confirm('Hủy đơn này?');">
                                                                            <input type="hidden" name="action"
                                                                                value="cancel">
                                                                            <input type="hidden" name="id"
                                                                                value="${order.id}">
                                                                            <button type="submit"
                                                                                class="btn-action btn-cancel"
                                                                                title="Hủy">
                                                                                <i class="fas fa-ban"></i> Hủy
                                                                            </button>
                                                                        </form>
                                                                    </c:if>

                                                                    <c:if test="${order.status == 2}">
                                                                        <form action="<c:url value='/admin/order'/>"
                                                                            method="POST" style="display:inline;">
                                                                            <input type="hidden" name="action"
                                                                                value="complete">
                                                                            <input type="hidden" name="id"
                                                                                value="${order.id}">
                                                                            <button type="submit"
                                                                                class="btn-action btn-confirm"
                                                                                title="Hoàn thành">
                                                                                <i class="fas fa-check-double"></i> Xong
                                                                            </button>
                                                                        </form>
                                                                    </c:if>

                                                                    <form action="<c:url value='/admin/order'/>"
                                                                        method="POST" style="display:inline;"
                                                                        onsubmit="return confirm('Xóa vĩnh viễn đơn hàng này?');">
                                                                        <input type="hidden" name="action"
                                                                            value="delete">
                                                                        <input type="hidden" name="id"
                                                                            value="${order.id}">
                                                                        <button type="submit"
                                                                            class="btn-action btn-delete" title="Xóa">
                                                                            <i class="fas fa-trash"></i>
                                                                        </button>
                                                                    </form>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                            </c:if>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-5">
                                            <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                            <h5 class="text-muted">Chưa có đơn hàng nào</h5>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                        </div>

                        <script
                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>
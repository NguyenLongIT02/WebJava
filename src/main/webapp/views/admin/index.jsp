<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/common/taglib.jsp"%>
    <%@ include file="/common/admin/headlink.jsp"%>
    
    <meta charset="UTF-8">
    <title>Quản Lý Đơn Hàng</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <style>
        :root { --sidebar-width: 220px; --bg-body: #f0f2f5; --primary-grad: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }

        body {
            background-color: var(--bg-body);
            font-family: 'Poppins', sans-serif;
            font-size: 0.85rem; color: #444;
        }

        .main-content {
            margin-left: var(--sidebar-width);
            padding: 25px; min-height: 100vh;
            display: flex; flex-direction: column; gap: 20px; /* Giảm khoảng cách giữa các phần */
        }

        /* --- HEADER ĐỒNG BỘ --- */
        .page-header {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border-radius: 12px; /* Bo góc nhỏ hơn */
            padding: 1.5rem 1rem; /* Thu nhỏ padding header */
            color: white;
            text-align: center;
            box-shadow: 0 4px 15px rgba(40, 167, 69, 0.2);
        }
        .page-header h4 { font-size: 1.5rem; font-weight: 800; margin-bottom: 2px; text-transform: uppercase; letter-spacing: 1px; }
        .page-header span { font-size: 0.85rem; opacity: 0.9; font-weight: 500; }

        /* FILTER BOX */
        .filter-box {
            background: white; padding: 15px 20px; border-radius: 12px; /* Padding gọn hơn */
            box-shadow: 0 3px 10px rgba(0,0,0,0.03); border: 1px solid rgba(0,0,0,0.02);
        }

        /* --- ORDER CARD (BẢN COMPACT) --- */
        .order-card {
            background: white; border-radius: 12px; 
            padding: 12px 20px; /* GIẢM PADDING ĐỂ THẺ THẤP HƠN */
            box-shadow: 0 2px 5px rgba(0,0,0,0.02); border: 1px solid #f1f1f1; 
            position: relative; transition: all 0.3s;
            overflow: hidden; margin-bottom: 10px; /* Giảm khoảng cách giữa các thẻ */
        }
        .order-card:hover { transform: translateY(-3px); box-shadow: 0 10px 20px rgba(0,0,0,0.06); }

        .status-strip { position: absolute; top: 0; left: 0; width: 5px; height: 100%; } /* Viền mảnh hơn */
        .ord-id { font-weight: 700; font-size: 0.9rem; color: #333; }

        .user-avatar {
            width: 38px; height: 38px; /* THU NHỎ AVATAR */
            border-radius: 10px;
            background: linear-gradient(45deg, #eef2f3, #8e9eab);
            color: #333; display: flex; align-items: center; justify-content: center;
            font-weight: 700; font-size: 1rem; box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        /* TIMELINE COMPACT */
        .timeline-area { position: relative; padding: 0; margin-top: 5px; } /* Bỏ padding thừa */
        .tl-line { position: absolute; top: 12px; left: 0; width: 100%; height: 3px; background: #e9ecef; z-index: 0; border-radius: 4px; }
        .tl-progress { position: absolute; top: 12px; left: 0; height: 3px; background: #28a745; z-index: 0; border-radius: 4px; width: 0%; transition: width 0.5s; }
        
        .tl-items { display: flex; justify-content: space-between; position: relative; z-index: 1; }
        .tl-item { text-align: center; background: white; padding: 0 5px; }
        .tl-icon {
            width: 26px; height: 26px; /* Thu nhỏ icon timeline */
            border-radius: 50%; background: #fff; border: 2px solid #e9ecef;
            display: flex; align-items: center; justify-content: center; color: #ccc; margin: 0 auto 3px;
            transition: all 0.3s; font-size: 10px;
        }
        .tl-text { font-size: 0.65rem; font-weight: 600; color: #ccc; transition: all 0.3s; }

        .tl-item.active .tl-icon {
            background: #28a745; border-color: #28a745; color: white;
            box-shadow: 0 0 0 3px rgba(40, 167, 69, 0.2); transform: scale(1.1);
        }
        .tl-item.active .tl-text { color: #28a745; }

        @keyframes pulse-green {
            0% { box-shadow: 0 0 0 0 rgba(40, 167, 69, 0.7); }
            70% { box-shadow: 0 0 0 6px rgba(40, 167, 69, 0); }
            100% { box-shadow: 0 0 0 0 rgba(40, 167, 69, 0); }
        }
        .tl-item.processing .tl-icon { animation: pulse-green 2s infinite; }

        /* PRICE & BTN */
        .price-tag {
            font-size: 1rem; font-weight: 800; /* Font giá nhỏ lại chút */
            background: linear-gradient(45deg, #11998e, #38ef7d);
            -webkit-background-clip: text; -webkit-text-fill-color: transparent;
        }
        .btn-action { border: none; border-radius: 6px; padding: 6px 12px; font-weight: 600; font-size: 0.75rem; transition: 0.2s; }
        .btn-detail { background: #eef2f6; color: #555; }
        .btn-detail:hover { background: #dce4eb; }
        
        /* Nút tạo đơn */
        .btn-create-order {
            background: #28a745; color: white; border: none; 
            font-weight: 700; border-radius: 8px; padding: 8px 20px;
            box-shadow: 0 3px 8px rgba(40,167,69,0.3);
        }
        .btn-create-order:hover { transform: translateY(-2px); box-shadow: 0 5px 12px rgba(40,167,69,0.4); color: white; }
        
        .btn-process { background: var(--primary-grad); color: white; box-shadow: 0 3px 8px rgba(118, 75, 162, 0.3); }
        .btn-process:hover { transform: translateY(-2px); color: white; }
        
        /* PAGINATION */
        .page-link { border: none; border-radius: 6px; margin: 0 2px; color: #555; font-weight: 600; font-size: 0.8rem; padding: 5px 10px; }
        .page-item.active .page-link { background: #28a745; color: white; box-shadow: 0 2px 8px rgba(40, 167, 69, 0.3); }
    </style>
</head>
<body>

    <%@ include file="/common/admin/header.jsp" %>

    <div class="main-content">
        
        <div class="page-header">
            <h4><i class="fas fa-truck-loading me-2"></i>Quản Lý Đơn Hàng</h4>
            <span>Theo dõi và xử lý đơn hàng theo thời gian thực</span>
        </div>

        <form action="order" method="get" id="searchForm" class="filter-box">
            <input type="hidden" name="page" id="pageInput" value="${tag != null ? tag : 1}">
            
            <div class="row g-2 align-items-end"> <div class="col-md-3">
                    <label class="fw-bold small text-muted mb-1">Tìm kiếm</label>
                    <div class="input-group input-group-sm"> <span class="input-group-text bg-light border-end-0"><i class="fas fa-search text-secondary"></i></span>
                        <input type="text" class="form-control bg-light border-start-0" name="keyword" value="${param.keyword}" placeholder="Mã đơn, tên khách...">
                    </div>
                </div>
                <div class="col-md-2">
                    <label class="fw-bold small text-muted mb-1">Trạng thái</label>
                    <select class="form-select form-select-sm bg-light" name="status">
                        <option value="">Tất cả</option>
                        <option value="0" ${param.status=='0'?'selected':''}>Đang chờ</option>
                        <option value="1" ${param.status=='1'?'selected':''}>Đang giao</option>
                        <option value="2" ${param.status=='2'?'selected':''}>Hoàn thành</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="fw-bold small text-muted mb-1">Ngày tạo</label>
                    <input type="date" class="form-control form-control-sm bg-light" name="date" value="${param.date}">
                </div>
                <div class="col-md-2">
                    <button type="button" onclick="submitFilter()" class="btn btn-dark btn-sm w-100 fw-bold" style="border:none;">
                        <i class="fas fa-filter me-1"></i> Lọc
                    </button>
                </div>
                
                <div class="col-md-3 text-end">
                    <a href="#" class="btn btn-create-order w-100 btn-sm py-2"> <i class="fas fa-plus-circle me-2"></i> TẠO ĐƠN MỚI
                    </a>
                </div>
            </div>
        </form>

        <div class="order-list">
            <c:forEach items="${cartDetailList}" var="item">
                
                <c:set var="stripColor" value="#ffc107" /> 
                <c:set var="progressWidth" value="25%" />
                
                <div class="order-card">
                    <div class="status-strip" style="background: ${stripColor};"></div>
                    
                    <div class="row align-items-center g-0"> <div class="col-lg-3 border-end pe-3">
                            <div class="d-flex align-items-center gap-2">
                                <div class="user-avatar">
                                    ${item.buyer.length() > 0 ? item.buyer.substring(0,1).toUpperCase() : 'U'}
                                </div>
                                <div style="line-height: 1.2;">
                                    <div class="ord-id text-primary">#${item.id}</div>
                                    <div class="fw-bold text-dark text-truncate" style="max-width: 120px; font-size: 0.85rem;">${item.buyer}</div>
                                    <small class="text-muted" style="font-size: 0.7rem;"><fmt:formatDate value="${item.orderDate}" pattern="dd/MM/yy HH:mm"/></small>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-5 px-3">
                            <div class="timeline-area">
                                <div class="tl-line"></div>
                                <div class="tl-progress" style="width: ${progressWidth};"></div> 
                                <div class="tl-items">
                                    <div class="tl-item active">
                                        <div class="tl-icon"><i class="fas fa-receipt"></i></div>
                                        <div class="tl-text">Đã đặt</div>
                                    </div>
                                    <div class="tl-item active processing">
                                        <div class="tl-icon"><i class="fas fa-box-open"></i></div>
                                        <div class="tl-text">Xử lý</div>
                                    </div>
                                    <div class="tl-item">
                                        <div class="tl-icon"><i class="fas fa-truck"></i></div>
                                        <div class="tl-text">Ship</div>
                                    </div>
                                    <div class="tl-item">
                                        <div class="tl-icon"><i class="fas fa-check"></i></div>
                                        <div class="tl-text">Xong</div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-4 d-flex justify-content-between align-items-center ps-3 border-start">
                            <div>
                                <div class="text-muted small text-uppercase fw-bold" style="font-size: 0.65rem;">Tổng tiền</div>
                                <div class="price-tag">
                                    <fmt:formatNumber value="${item.sumToTal}" type="currency" currencySymbol="$"/>
                                </div>
                            </div>
                            <div class="d-flex gap-2">
                                <button class="btn-action btn-detail" title="Chi tiết"><i class="fas fa-eye"></i></button>
                                <button class="btn-action btn-process">Cập nhật</button>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
            
            <c:if test="${empty cartDetailList}">
                <div class="text-center py-4"> <img src="https://cdn-icons-png.flaticon.com/512/7486/7486744.png" width="80" class="mb-2 opacity-50">
                    <h6 class="text-muted small">Chưa có đơn hàng nào</h6>
                </div>
            </c:if>
        </div>

        <c:if test="${not empty cartDetailList}">
            <div class="d-flex justify-content-center mt-2">
                <nav>
                    <ul class="pagination pagination-sm mb-0"> <li class="page-item ${tag <= 1 ? 'disabled' : ''}">
                            <a class="page-link" href="javascript:void(0)" onclick="changePage(1)"><i class="fas fa-chevron-left"></i></a>
                        </li>
                        <c:forEach begin="1" end="${endP}" var="i">
                            <li class="page-item ${tag == i ? 'active' : ''}">
                                <a class="page-link" href="javascript:void(0)" onclick="changePage(${i})">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${tag >= endP ? 'disabled' : ''}">
                            <a class="page-link" href="javascript:void(0)" onclick="changePage(${endP})"><i class="fas fa-chevron-right"></i></a>
                        </li>
                    </ul>
                </nav>
            </div>
        </c:if>

    </div>

    <script>
        function submitFilter() {
            document.getElementById('pageInput').value = 1;
            document.getElementById('searchForm').submit();
        }
        function changePage(page) {
            document.getElementById('pageInput').value = page;
            document.getElementById('searchForm').submit();
        }
    </script>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
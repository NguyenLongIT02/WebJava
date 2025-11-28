
<%@ page import="java.util.*" %>
<html>
<head>
    <title>Thống kê bán Rau - Củ - Quả</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body { background-color: #f8f9fa; }
        .card { min-height: 140px; }
        .chart-container {
            position: relative;
            height: 350px; /* phù hợp màn 15.6 inch */
        }
        h2 { font-size: 1.8rem; font-weight: 600; }
    </style>
</head>
<body>
<%@ include file="/common/admin/header.jsp"%>

<div class="container-fluid mt-4 px-4">
    <h2 class="mb-4">📊 Thống kê bán Rau - Củ - Quả</h2>

    <!-- Hàng 3 box thống kê -->
    <div class="row g-3">
        <div class="col-md-4">
            <div class="card text-white bg-success shadow-sm rounded">
                <div class="card-body text-center">
                    <h5 class="card-title">Tổng số Rau</h5>
                    <p class="card-text fs-3 fw-bold"><%= request.getAttribute("vegetableCount") %></p>
                    <a href="#" class="text-white small">Chi tiết</a>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card text-dark bg-warning shadow-sm rounded">
                <div class="card-body text-center">
                    <h5 class="card-title">Tổng số Củ</h5>
                    <p class="card-text fs-3 fw-bold"><%= request.getAttribute("rootCount") %></p>
                    <a href="#" class="text-dark small">Chi tiết</a>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card text-white bg-danger shadow-sm rounded">
                <div class="card-body text-center">
                    <h5 class="card-title">Tổng số Quả</h5>
                    <p class="card-text fs-3 fw-bold"><%= request.getAttribute("fruitCount") %></p>
                    <a href="#" class="text-white small">Chi tiết</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Hàng 2 biểu đồ -->
    <div class="row mt-4 g-3">
        <div class="col-md-6">
            <div class="card shadow-sm rounded">
                <div class="card-header fw-bold">📈 Doanh thu theo tháng</div>
                <div class="card-body chart-container">
                    <canvas id="revenueChart"></canvas>
                </div>
            </div>
        </div>

        <div class="col-md-6">
            <div class="card shadow-sm rounded">
                <div class="card-header fw-bold">📊 So sánh số lượng bán</div>
                <div class="card-body chart-container">
                    <canvas id="compareChart"></canvas>
                </div>
            </div>
        </div>
    </div>
</div>

<%
    Map<String, Integer> revenueByMonth = (Map<String, Integer>) request.getAttribute("revenueByMonth");
    Map<String, Integer> salesByCategory = (Map<String, Integer>) request.getAttribute("salesByCategory");

    StringBuilder labelBuilder = new StringBuilder("[");
    StringBuilder valueBuilder = new StringBuilder("[");
    boolean first = true;
    for (Map.Entry<String, Integer> e : revenueByMonth.entrySet()) {
        if (!first) { labelBuilder.append(","); valueBuilder.append(","); }
        labelBuilder.append("\"").append(e.getKey()).append("\"");
        valueBuilder.append(e.getValue());
        first = false;
    }
    labelBuilder.append("]");
    valueBuilder.append("]");

    String categories = "[\"Rau\", \"Củ\", \"Quả\"]";
    String categoryValues = "[" 
        + salesByCategory.getOrDefault("Rau", 0) + "," 
        + salesByCategory.getOrDefault("Củ", 0) + "," 
        + salesByCategory.getOrDefault("Quả", 0) + "]";
%>

<script>
    // Line Chart - Doanh thu
    new Chart(document.getElementById("revenueChart"), {
        type: 'line',
        data: {
            labels: <%= labelBuilder.toString() %>,
            datasets: [{
                label: 'Doanh thu (VND)',
                data: <%= valueBuilder.toString() %>,
                fill: true,
                borderColor: '#28a745',
                backgroundColor: 'rgba(40,167,69,0.2)',
                tension: 0.4,
                pointRadius: 4,
                pointBackgroundColor: '#28a745'
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false
        }
    });

    // Bar Chart - Số lượng bán
    new Chart(document.getElementById("compareChart"), {
        type: 'bar',
        data: {
            labels: <%= categories %>,
            datasets: [{
                label: 'Số lượng bán',
                data: <%= categoryValues %>,
                backgroundColor: ['#28a745', '#ffc107', '#dc3545']
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false
        }
    });
</script>

</body>
</html>

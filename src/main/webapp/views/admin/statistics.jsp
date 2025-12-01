<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <%@ include file="/common/taglib.jsp" %>
                <%@ include file="/common/admin/headlink.jsp" %>

                    <meta charset="UTF-8">
                    <title>Bảng Điều Khiển - Fruitables</title>
                    <meta content="width=device-width, initial-scale=1.0" name="viewport">
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
                        rel="stylesheet">

                    <style>
                        :root {
                            --sidebar-width: 220px;
                            --bg-color: #f8f9fa;
                            --card-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
                            --card-radius: 8px;
                        }

                        body {
                            background: var(--bg-color);
                            font-family: 'Segoe UI', sans-serif;
                            height: 100vh;
                            overflow: hidden;
                            font-size: 0.75rem;
                            color: #333;
                        }

                        .main-content {
                            margin-left: var(--sidebar-width);
                            height: 100vh;
                            padding: 15px;
                            display: flex;
                            flex-direction: column;
                            gap: 12px;
                            overflow: hidden;
                        }

                        /* HEADER */
                        .top-bar {
                            height: 45px;
                            flex-shrink: 0;
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            background: #fff;
                            padding: 0 20px;
                            border-radius: var(--card-radius);
                            box-shadow: var(--card-shadow);
                            border-left: 5px solid #28a745;
                        }

                        /* KPI CARDS */
                        .row-kpi {
                            height: 85px;
                            display: flex;
                            gap: 12px;
                            flex-shrink: 0;
                        }

                        .kpi-box {
                            flex: 1;
                            background: #fff;
                            border-radius: var(--card-radius);
                            padding: 10px 15px;
                            display: flex;
                            flex-direction: column;
                            justify-content: center;
                            box-shadow: var(--card-shadow);
                            transition: transform 0.2s;
                        }

                        .kpi-box:hover {
                            transform: translateY(-2px);
                        }

                        .kpi-label {
                            font-size: 0.65rem;
                            color: #888;
                            text-transform: uppercase;
                            font-weight: 600;
                            margin-bottom: 5px;
                        }

                        .kpi-value {
                            font-size: 1.5rem;
                            font-weight: 700;
                        }

                        /* CHART CARDS */
                        .chart-card {
                            background: white;
                            border-radius: var(--card-radius);
                            padding: 12px;
                            box-shadow: var(--card-shadow);
                            display: flex;
                            flex-direction: column;
                            position: relative;
                            overflow: hidden;
                        }

                        .card-title-box {
                            font-size: 0.7rem;
                            font-weight: 700;
                            text-transform: uppercase;
                            color: #555;
                            margin-bottom: 8px;
                            border-bottom: 1px solid #eee;
                            padding-bottom: 6px;
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                        }

                        .chart-area {
                            flex-grow: 1;
                            position: relative;
                            min-height: 0;
                        }

                        /* GAUGE */
                        .gauge-container {
                            display: flex;
                            flex-direction: column;
                            align-items: center;
                            justify-content: center;
                            height: 100%;
                        }

                        .gauge-value {
                            font-size: 18px;
                            font-weight: 700;
                            color: #28a745;
                            margin-top: -10px;
                        }

                        /* TABLE */
                        .table-clean {
                            font-size: 0.7rem;
                        }

                        .table-clean th {
                            background: #f8f9fa;
                            font-weight: 700;
                            text-transform: uppercase;
                            font-size: 0.65rem;
                            color: #555;
                            padding: 8px 10px;
                        }

                        .table-clean td {
                            padding: 6px 10px;
                            vertical-align: middle;
                        }

                        /* ROWS - Cân đối layout */
                        .content-wrapper {
                            flex: 1;
                            display: flex;
                            flex-direction: column;
                            gap: 12px;
                            min-height: 0;
                            overflow: hidden;
                        }

                        .row-charts-top {
                            display: flex;
                            gap: 12px;
                            height: 48%;
                            flex-shrink: 0;
                        }

                        .row-charts-bottom {
                            display: flex;
                            gap: 12px;
                            height: 48%;
                            flex-shrink: 0;
                        }
                    </style>
        </head>

        <body>
            <%@ include file="/common/admin/header.jsp" %>

                <div class="main-content">
                    <!-- TOP BAR -->
                    <div class="top-bar">
                        <div>
                            <h6 class="mb-0" style="font-weight: 700; color: #28a745; font-size: 0.95rem;">
                                <i class="fas fa-chart-line me-2"></i>Executive Dashboard
                            </h6>
                        </div>
                        <div style="font-size: 0.7rem; color: #888;">
                            <i class="fas fa-calendar-alt me-1"></i>
                            <span id="currentDate"></span>
                        </div>
                    </div>

                    <!-- KPI ROW -->
                    <div class="row-kpi">
                        <div class="kpi-box" style="border-left: 4px solid #28a745;">
                            <div class="kpi-label">Doanh thu</div>
                            <div class="kpi-value text-success" id="kpiRevenue">$0</div>
                        </div>
                        <div class="kpi-box" style="border-left: 4px solid #20c997;">
                            <div class="kpi-label">Lợi nhuận gộp</div>
                            <div class="kpi-value text-info">$0</div>
                        </div>
                        <div class="kpi-box" style="border-left: 4px solid #17a2b8;">
                            <div class="kpi-label">Tổng đơn hàng</div>
                            <div class="kpi-value" style="color: #17a2b8;">0</div>
                        </div>
                        <div class="kpi-box" style="border-left: 4px solid #ffc107;">
                            <div class="kpi-label">Khách hàng mới</div>
                            <div class="kpi-value text-warning">0</div>
                        </div>
                        <div class="kpi-box" style="border-left: 4px solid #6c757d;">
                            <div class="kpi-label">Giá trị tồn kho</div>
                            <div class="kpi-value text-secondary">$0</div>
                        </div>
                        <div class="kpi-box" style="border-left: 4px solid #dc3545;">
                            <div class="kpi-label">Tỷ lệ hủy</div>
                            <div class="kpi-value text-danger">0%</div>
                        </div>
                    </div>

                    <!-- CONTENT WRAPPER -->
                    <div class="content-wrapper">
                        <!-- ROW 1: Revenue + Top Products + Weekly -->
                        <div class="row-charts-top">
                            <div class="chart-card" style="flex: 1.5;">
                                <div class="card-title-box">
                                    <span><i class="fas fa-chart-bar me-2"></i>Doanh thu theo tháng</span>
                                </div>
                                <div class="chart-area"><canvas id="comboChart"></canvas></div>
                            </div>
                            <div class="chart-card" style="flex: 1;">
                                <div class="card-title-box">
                                    <span><i class="fas fa-trophy me-2"></i>Top sản phẩm</span>
                                </div>
                                <div class="chart-area"><canvas id="categoryBarChart"></canvas></div>
                            </div>
                            <div class="chart-card" style="flex: 1.5;">
                                <div class="card-title-box">
                                    <span><i class="fas fa-calendar-week me-2"></i>Doanh thu tuần</span>
                                </div>
                                <div class="chart-area"><canvas id="weeklyChart"></canvas></div>
                            </div>
                        </div>

                        <!-- ROW 2: Gauges + Funnel + Recent Orders -->
                        <div class="row-charts-bottom">
                            <div class="chart-card" style="flex: 0.8;">
                                <div class="card-title-box">
                                    <span><i class="fas fa-bullseye me-2"></i>Mục tiêu bán hàng</span>
                                </div>
                                <div class="chart-area">
                                    <div class="gauge-container">
                                        <canvas id="gaugeSales" style="max-height: 100px;"></canvas>
                                        <div class="gauge-value">0%</div>
                                    </div>
                                </div>
                            </div>
                            <div class="chart-card" style="flex: 0.8;">
                                <div class="card-title-box">
                                    <span><i class="fas fa-smile me-2"></i>Đánh giá</span>
                                </div>
                                <div class="chart-area">
                                    <div class="gauge-container">
                                        <canvas id="gaugeSat" style="max-height: 100px;"></canvas>
                                        <div class="gauge-value" style="color: #0d6efd;">0.0</div>
                                    </div>
                                </div>
                            </div>
                            <div class="chart-card" style="flex: 1.2;">
                                <div class="card-title-box">
                                    <span><i class="fas fa-filter me-2"></i>Phễu chuyển đổi</span>
                                </div>
                                <div class="chart-area"><canvas id="funnelChart"></canvas></div>
                            </div>

                            <div class="chart-card" style="flex: 2.2; overflow: hidden;">
                                <div class="card-title-box">
                                    <span><i class="fas fa-list-ul me-2"></i>Đơn hàng gần đây</span>
                                    <a href="#" class="text-decoration-none text-primary"
                                        style="font-size: 0.65rem;">Xem tất cả</a>
                                </div>
                                <div style="overflow-y: auto; flex-grow: 1;">
                                    <table class="table table-clean w-100 mb-0 table-hover" id="recentOrdersTable">
                                        <thead>
                                            <tr>
                                                <th>Khách hàng</th>
                                                <th>Email</th>
                                                <th>Tổng ($)</th>
                                                <th>Ngày</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <!-- Data will be populated here -->
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
                <script>
                    async function loadDashboardData() {
                        try {
                            const response = await fetch('<c:url value="/api/admin/dashboard-stats" />');
                            if (!response.ok) throw new Error('Network response was not ok');
                            const data = await response.json();

                            // 1. Update KPIs
                            document.getElementById('kpiRevenue').innerText = '$' + data.totalRevenue.toLocaleString();

                            // Update Gross Profit
                            const kpiProfit = document.querySelectorAll('.kpi-box')[1].querySelector('.kpi-value');
                            if (kpiProfit) kpiProfit.innerText = '$' + data.grossProfit.toLocaleString(undefined, { maximumFractionDigits: 0 });

                            // Update Total Orders
                            const kpiOrders = document.querySelectorAll('.kpi-box')[2].querySelector('.kpi-value');
                            if (kpiOrders) kpiOrders.innerText = data.totalOrders;

                            // Update New Customers (Total Customers for now)
                            const kpiCustomers = document.querySelectorAll('.kpi-box')[3].querySelector('.kpi-value');
                            if (kpiCustomers) kpiCustomers.innerText = data.totalCustomers;

                            // Update Inventory Value
                            const kpiInventory = document.querySelectorAll('.kpi-box')[4].querySelector('.kpi-value');
                            if (kpiInventory) kpiInventory.innerText = '$' + data.inventoryValue.toLocaleString(undefined, { maximumFractionDigits: 0 });

                            // Update Cancellation Rate
                            const kpiCancel = document.querySelectorAll('.kpi-box')[5].querySelector('.kpi-value');
                            if (kpiCancel) kpiCancel.innerText = data.cancellationRate + '%';

                            // 2. Revenue Chart (Combo Chart)
                            const revenueData = Array.from({ length: 12 }, (_, i) => data.revenueByMonth[i + 1] || 0);
                            new Chart(document.getElementById('comboChart'), {
                                type: 'bar',
                                data: {
                                    labels: ['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10', 'T11', 'T12'],
                                    datasets: [
                                        {
                                            label: 'Doanh thu',
                                            data: revenueData,
                                            backgroundColor: '#28a745',
                                            borderRadius: 4
                                        }
                                    ]
                                },
                                options: {
                                    responsive: true,
                                    maintainAspectRatio: false,
                                    plugins: { legend: { display: false } },
                                    scales: { y: { beginAtZero: true } }
                                }
                            });

                            // 3. Top Products Chart - Green Theme
                            const topProducts = data.topProducts;
                            const greenGradient = [
                                '#28a745',  // Xanh lá đậm
                                '#20c997',  // Xanh ngọc
                                '#5cb85c',  // Xanh lá nhạt
                                '#17a2b8',  // Xanh dương nhạt
                                '#6c757d'   // Xám
                            ];

                            new Chart(document.getElementById('categoryBarChart'), {
                                type: 'bar',
                                data: {
                                    labels: topProducts.map(p => p.name),
                                    datasets: [{
                                        label: 'Đã bán',
                                        data: topProducts.map(p => p.totalSold),
                                        backgroundColor: topProducts.map((_, i) => greenGradient[i % greenGradient.length]),
                                        borderRadius: 4
                                    }]
                                },
                                options: {
                                    indexAxis: 'y',
                                    responsive: true,
                                    maintainAspectRatio: false,
                                    plugins: { legend: { display: false } }
                                }
                            });

                            // 4. Recent Orders Table
                            const tableBody = document.querySelector('#recentOrdersTable tbody');
                            tableBody.innerHTML = '';
                            data.recentOrders.forEach(order => {
                                const row = `
                        <tr>
                            <td><b>\${order.buyer}</b></td>
                            <td class="text-muted">\${order.email}</td>
                            <td class="fw-bold text-success">$\${order.sumToTal}</td>
                            <td>\${new Date(order.orderDate).toLocaleDateString('vi-VN')}</td>
                        </tr>
                    `;
                                tableBody.innerHTML += row;
                            });

                            // 5. Weekly Chart (Dynamic Date Range)
                            const days = [];
                            const weeklyData = [];

                            // Determine anchor date: use the latest date from data, or today if no data
                            let anchorDate = new Date();
                            const availableDates = Object.keys(data.weeklyRevenue || {}).sort();
                            if (availableDates.length > 0) {
                                const lastDateInData = new Date(availableDates[availableDates.length - 1]);
                                // If data is in the past (older than 7 days from today), use data's max date
                                // Otherwise use today to keep it looking "current"
                                if ((new Date() - lastDateInData) > 7 * 24 * 60 * 60 * 1000) {
                                    anchorDate = lastDateInData;
                                }
                            }

                            for (let i = 6; i >= 0; i--) {
                                const d = new Date(anchorDate);
                                d.setDate(d.getDate() - i);
                                const dateStr = d.toISOString().split('T')[0]; // YYYY-MM-DD
                                days.push(d.toLocaleDateString('vi-VN', { weekday: 'short' }));
                                weeklyData.push(data.weeklyRevenue[dateStr] || 0);
                            }

                            new Chart(document.getElementById('weeklyChart'), {
                                type: 'line',
                                data: {
                                    labels: days,
                                    datasets: [
                                        {
                                            label: 'Doanh thu',
                                            data: weeklyData,
                                            borderColor: '#28a745', // Green theme
                                            borderWidth: 2,
                                            tension: 0.4,
                                            pointRadius: 3,
                                            fill: true,
                                            backgroundColor: 'rgba(40, 167, 69, 0.1)' // Green theme
                                        }
                                    ]
                                },
                                options: {
                                    responsive: true,
                                    maintainAspectRatio: false,
                                    plugins: {
                                        legend: {
                                            display: true,
                                            position: 'top',
                                            align: 'end',
                                            labels: { boxWidth: 10, font: { size: 9 } }
                                        }

                                    }
                                }
                            });

                            // 6. Gauge Charts
                            // Sales Target
                            const percent = data.salesTargetPercent || 85;
                            new Chart(document.getElementById('gaugeSales'), {
                                type: 'doughnut',
                                data: {
                                    datasets: [{
                                        data: [percent, 100 - percent],
                                        backgroundColor: ['#28a745', '#e9ecef'],
                                        borderWidth: 0,
                                        circumference: 180,
                                        rotation: 270
                                    }]
                                },
                                options: {
                                    responsive: true,
                                    maintainAspectRatio: false,
                                    cutout: '80%',
                                    plugins: { tooltip: { enabled: false } }
                                }
                            });

                            // Satisfaction (Avg Rating)
                            const rating = data.avgRating || 5.0;
                            new Chart(document.getElementById('gaugeSat'), {
                                type: 'doughnut',
                                data: {
                                    datasets: [{
                                        data: [rating, 5 - rating],
                                        backgroundColor: ['#0d6efd', '#e9ecef'],
                                        borderWidth: 0,
                                        circumference: 180,
                                        rotation: 270
                                    }]
                                },
                                options: {
                                    responsive: true,
                                    maintainAspectRatio: false,
                                    cutout: '80%',
                                    plugins: { tooltip: { enabled: false } }
                                }
                            });

                            // 7. Funnel Chart - SỬ DỤNG DỮ LIỆU THỰC
                            const views = data.totalViews || 0;
                            // Ước tính 'Thêm giỏ hàng' dựa trên lượt xem (khoảng 20%)
                            const addToCart = Math.round(views * 0.2);
                            // SỬ DỤNG DỮ LIỆU THỰC cho số đơn hàng
                            const orders = data.totalOrders || 0;

                            new Chart(document.getElementById('funnelChart'), {
                                type: 'bar',
                                data: {
                                    labels: ['Lượt xem', 'Thêm giỏ hàng', 'Đơn hàng'],
                                    datasets: [{
                                        label: 'Số lượng',
                                        data: [views, addToCart, orders],
                                        backgroundColor: [
                                            '#a3e4d7', // Light Teal/Green
                                            '#20c997', // Medium Teal/Green
                                            '#28a745'  // Strong Green
                                        ],
                                        borderRadius: 4,
                                        barPercentage: 0.6,
                                        minBarLength: 35 // Đảm bảo các thanh luôn hiển thị
                                    }]
                                },
                                options: {
                                    indexAxis: 'y',
                                    responsive: true,
                                    maintainAspectRatio: false,
                                    plugins: { legend: { display: false } },
                                    scales: { x: { beginAtZero: true } }
                                }
                            });

                            // Update text for gauges
                            const gaugeValSales = document.querySelector('#gaugeSales').nextElementSibling;
                            if (gaugeValSales) gaugeValSales.innerText = Math.round(percent) + '%';

                            const gaugeValSat = document.querySelector('#gaugeSat').nextElementSibling;
                            if (gaugeValSat) gaugeValSat.innerText = rating.toFixed(1);

                        } catch (error) {
                            console.error("Error loading dashboard data:", error);
                        }
                    }

                    // Update current date
                    const dateOptions = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
                    document.getElementById('currentDate').innerText = new Date().toLocaleDateString('vi-VN', dateOptions);

                    document.addEventListener("DOMContentLoaded", loadDashboardData);
                </script>
        </body>

        </html>
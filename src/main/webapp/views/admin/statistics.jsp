<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <%@ include file="/common/taglib.jsp" %>
                <%@ include file="/common/admin/headlink.jsp" %>

                    <meta charset="UTF-8">
                    <title>Executive Dashboard - Fruitables</title>
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
                            height: 11vh;
                            display: flex;
                            gap: 12px;
                            flex-shrink: 0;
                        }

                        .kpi-box {
                            flex: 1;
                            background: #fff;
                            border-radius: var(--card-radius);
                            padding: 0 15px;
                            display: flex;
                            flex-direction: column;
                            justify-content: center;
                            box-shadow: var(--card-shadow);
                            transition: transform 0.2s;
                        }

                        .kpi-box:hover {
                            transform: translateY(-3px);
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
                        }

                        .card-title-box {
                            font-size: 10px;
                            font-weight: 800;
                            text-transform: uppercase;
                            color: #555;
                            margin-bottom: 8px;
                            border-bottom: 1px solid #eee;
                            padding-bottom: 5px;
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                        }

                        .chart-area {
                            flex-grow: 1;
                            position: relative;
                            width: 100%;
                            min-height: 0;
                        }

                        /* LAYOUT */
                        .row-middle {
                            height: 40vh;
                            display: flex;
                            gap: 12px;
                            flex-shrink: 0;
                        }

                        .row-bottom {
                            flex-grow: 1;
                            display: flex;
                            gap: 12px;
                            min-height: 0;
                        }

                        /* GAUGE */
                        .gauge-wrapper {
                            display: flex;
                            justify-content: space-around;
                            align-items: center;
                            height: 100%;
                        }

                        .gauge-item {
                            width: 45%;
                            position: relative;
                            text-align: center;
                        }

                        .gauge-val {
                            position: absolute;
                            bottom: 15%;
                            left: 50%;
                            transform: translateX(-50%);
                            font-size: 16px;
                            font-weight: 800;
                        }

                        .gauge-lbl {
                            position: absolute;
                            bottom: -5px;
                            left: 50%;
                            transform: translateX(-50%);
                            font-size: 9px;
                            color: #888;
                            white-space: nowrap;
                        }

                        /* TABLE */
                        .table-clean th {
                            background: #f1f3f5;
                            border: none;
                            font-size: 9px;
                            padding: 8px;
                            font-weight: 700;
                            color: #666;
                        }

                        .table-clean td {
                            border-bottom: 1px solid #f1f1f1;
                            font-size: 10px;
                            padding: 8px;
                            vertical-align: middle;
                        }

                        .table-clean tr:last-child td {
                            border-bottom: none;
                        }
                    </style>
        </head>

        <body>

            <%@ include file="/common/admin/header.jsp" %>

                <div class="main-content">

                    <div class="top-bar">
                        <div class="fw-bold text-dark"><i class="fas fa-chart-pie text-success me-2"></i>BÁO CÁO QUẢN
                            TRỊ
                            (EXECUTIVE VIEW)</div>
                        <div class="d-flex gap-2">
                            <span class="badge bg-light text-dark border px-3 py-2">Đơn vị: USD ($)</span>
                            <button class="btn btn-success btn-sm px-3"><i class="fas fa-download me-1"></i> Xuất
                                Excel</button>
                        </div>
                    </div>

                    <div class="row-kpi">
                        <div class="kpi-box">
                            <span class="text-muted fw-bold" style="font-size:9px; color: #28a745;">DOANH THU
                                THUẦN</span>
                            <div class="d-flex align-items-baseline gap-2">
                                <span id="kpiRevenue" class="fw-bold fs-4 text-dark">...</span> <span
                                    class="badge bg-success bg-opacity-10 text-success">▲ 15%</span>
                            </div>
                        </div>
                        <div class="kpi-box">
                            <span class="text-muted fw-bold" style="font-size:9px; color: #20c997;">LỢI NHUẬN GỘP</span>
                            <div class="d-flex align-items-baseline gap-2">
                                <span class="fw-bold fs-4 text-dark">$4,200</span> <span
                                    class="badge bg-info bg-opacity-10 text-info">33% Margin</span>
                            </div>
                        </div>
                        <div class="kpi-box">
                            <span class="text-muted fw-bold" style="font-size:9px; color: #0d6efd;">TỔNG ĐƠN HÀNG</span>
                            <div class="d-flex align-items-baseline gap-2">
                                <span class="fw-bold fs-4 text-dark">850</span> <span class="text-muted"
                                    style="font-size:10px;">Avg $14.7</span>
                            </div>
                        </div>
                        <div class="kpi-box">
                            <span class="text-muted fw-bold" style="font-size:9px; color: #6610f2;">KHÁCH HÀNG
                                MỚI</span>
                            <div class="d-flex align-items-baseline gap-2">
                                <span class="fw-bold fs-4 text-dark">125</span> <span
                                    class="badge bg-primary bg-opacity-10 text-primary">+12</span>
                            </div>
                        </div>
                        <div class="kpi-box">
                            <span class="text-muted fw-bold" style="font-size:9px; color: #fd7e14;">GIÁ TRỊ TỒN
                                KHO</span>
                            <div class="d-flex align-items-baseline gap-2">
                                <span class="fw-bold fs-4 text-dark">$3,400</span> <span class="text-danger fw-bold"
                                    style="font-size:10px;">Cao</span>
                            </div>
                        </div>
                        <div class="kpi-box">
                            <span class="text-muted fw-bold" style="font-size:9px; color: #dc3545;">TỶ LỆ HỦY</span>
                            <div class="d-flex align-items-baseline gap-2">
                                <span class="fw-bold fs-4 text-dark">2.1%</span> <span class="text-success fw-bold"
                                    style="font-size:10px;">▼ Tốt</span>
                            </div>
                        </div>
                    </div>

                    <div class="row-middle">

                        <div class="chart-card" style="flex: 2;">
                            <div class="card-title-box">
                                <span><i class="fas fa-chart-bar me-2 text-primary"></i>HIỆU QUẢ TÀI CHÍNH (FINANCIAL
                                    PERFORMANCE)</span>
                            </div>
                            <div class="chart-area"><canvas id="comboChart"></canvas></div>
                        </div>

                        <div class="chart-card" style="flex: 1.2;">
                            <div class="card-title-box">
                                <span><i class="fas fa-tachometer-alt me-2 text-success"></i>TIẾN ĐỘ KPI (MỤC
                                    TIÊU)</span>
                            </div>
                            <div class="gauge-wrapper">
                                <div class="gauge-item">
                                    <canvas id="gaugeSales"></canvas>
                                    <div class="gauge-val text-success">85%</div>
                                    <div class="gauge-lbl">Doanh Số</div>
                                </div>
                                <div class="gauge-item">
                                    <canvas id="gaugeSat"></canvas>
                                    <div class="gauge-val text-primary">4.8</div>
                                    <div class="gauge-lbl">Hài Lòng</div>
                                </div>
                            </div>
                        </div>

                        <div class="chart-card" style="flex: 1;">
                            <div class="card-title-box">
                                <span><i class="fas fa-chart-line me-2 text-info"></i>TỐC ĐỘ BÁN HÀNG (TUẦN NÀY VS
                                    TRƯỚC)</span>
                            </div>
                            <div class="chart-area"><canvas id="weeklyChart"></canvas></div>
                        </div>

                    </div>

                    <div class="row-bottom">

                        <div class="chart-card" style="flex: 1.2;">
                            <div class="card-title-box">
                                <span><i class="fas fa-trophy me-2 text-warning"></i>XẾP HẠNG DANH MỤC (TOP
                                    CATEGORIES)</span>
                            </div>
                            <div class="chart-area"><canvas id="categoryBarChart"></canvas></div>
                        </div>

                        <div class="chart-card" style="flex: 0.8;">
                            <div class="card-title-box">
                                <span><i class="fas fa-filter me-2 text-secondary"></i>PHỄU CHUYỂN ĐỔI</span>
                            </div>
                            <div class="chart-area"><canvas id="funnelChart"></canvas></div>
                        </div>

                        <div class="chart-card" style="flex: 2; overflow: hidden;">
                            <div class="card-title-box">
                                <span><i class="fas fa-list-ul me-2"></i>GIAO DỊCH MỚI NHẤT</span>
                                <a href="#" class="text-decoration-none text-primary">Chi tiết</a>
                            </div>
                            <div style="overflow-y: auto; flex-grow: 1;">
                                <table class="table table-clean w-100 mb-0 table-hover" id="recentOrdersTable">
                                    <thead>
                                        <tr>
                                            <th>KHÁCH HÀNG</th>
                                            <th>EMAIL</th>
                                            <th>TỔNG ($)</th>
                                            <th>NGÀY MUA</th>
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

                <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
                <script>
                    async function loadDashboardData() {
                        try {
                            const response = await fetch('<c:url value="/api/admin/dashboard-stats"/>');
                            if (!response.ok) throw new Error('Network response was not ok');
                            const data = await response.json();

                            // 1. Update Total Revenue
                            document.getElementById('kpiRevenue').innerText = '$' + data.totalRevenue.toLocaleString();

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

                            // 3. Top Products Chart
                            const topProducts = data.topProducts;
                            new Chart(document.getElementById('categoryBarChart'), {
                                type: 'bar',
                                data: {
                                    labels: topProducts.map(p => p.name),
                                    datasets: [{
                                        label: 'Đã bán',
                                        data: topProducts.map(p => p.totalSold),
                                        backgroundColor: '#ffc107',
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
                            <td>\${new Date(order.orderDate).toLocaleDateString()}</td>
                        </tr>
                    `;
                                tableBody.innerHTML += row;
                            });

                            // 5. Weekly Chart (Dummy Data for now as API doesn't provide it yet)
                            new Chart(document.getElementById('weeklyChart'), {
                                type: 'line',
                                data: {
                                    labels: ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'],
                                    datasets: [
                                        {
                                            label: 'Tuần này',
                                            data: [120, 150, 180, 220, 190, 250, 300],
                                            borderColor: '#6610f2',
                                            borderWidth: 2,
                                            tension: 0.4,
                                            pointRadius: 0
                                        },
                                        {
                                            label: 'Tuần trước',
                                            data: [100, 130, 140, 160, 180, 200, 210],
                                            borderColor: '#ced4da',
                                            borderWidth: 2,
                                            borderDash: [5, 5],
                                            tension: 0.4,
                                            pointRadius: 0
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
                                    },
                                    scales: { y: { display: false }, x: { grid: { display: false } } }
                                }
                            });

                            // 6. Funnel Chart (Dummy Data)
                            new Chart(document.getElementById('funnelChart'), {
                                type: 'doughnut',
                                data: {
                                    labels: ['Xem', 'Giỏ hàng', 'Thanh toán', 'Mua'],
                                    datasets: [{
                                        data: [1000, 400, 200, 150],
                                        backgroundColor: ['#e9ecef', '#dee2e6', '#adb5bd', '#495057']
                                    }]
                                },
                                options: {
                                    responsive: true,
                                    maintainAspectRatio: false,
                                    plugins: { legend: { position: 'right', labels: { boxWidth: 10, font: { size: 9 } } } }
                                }
                            });

                            // 7. Gauges (Dummy Data)
                            new Chart(document.getElementById('gaugeSales'), {
                                type: 'doughnut',
                                data: {
                                    datasets: [{
                                        data: [85, 15],
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

                            new Chart(document.getElementById('gaugeSat'), {
                                type: 'doughnut',
                                data: {
                                    datasets: [{
                                        data: [4.8, 0.2],
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


                        } catch (error) {
                            console.error("Error loading dashboard data:", error);
                        }
                    }

                    document.addEventListener("DOMContentLoaded", loadDashboardData);
                </script>
        </body>

        </html>
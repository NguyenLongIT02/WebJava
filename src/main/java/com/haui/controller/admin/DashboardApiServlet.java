package com.haui.controller.admin;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.haui.dao.OrderDao;
import com.haui.dao.impl.OrderDaoImpl;
import com.haui.dto.ProductStat;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/api/admin/dashboard-stats")
public class DashboardApiServlet extends HttpServlet {

    private final OrderDao orderDao = new OrderDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println("DashboardApiServlet: doGet called");
        try {
            // CORS headers
            resp.setHeader("Access-Control-Allow-Origin", "*");
            resp.setHeader("Access-Control-Allow-Methods", "GET, OPTIONS");
            resp.setHeader("Access-Control-Allow-Headers", "Content-Type");
            // Content type
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");

            Map<String, Object> stats = new HashMap<>();

            // 1. Revenue by Month
            Map<Integer, Double> revenueByMonth = orderDao.getRevenueByMonth();
            if (revenueByMonth == null)
                revenueByMonth = new HashMap<>();
            stats.put("revenueByMonth", revenueByMonth);

            // 2. Top Selling Products
            List<ProductStat> topProducts = orderDao.getTopSellingProducts(5);
            if (topProducts == null)
                topProducts = List.of();
            stats.put("topProducts", topProducts);

            // 3. Recent Orders
            List<com.haui.dto.CartDetails> recentOrders = orderDao.getRecentOrders(6);
            if (recentOrders == null)
                recentOrders = List.of();
            stats.put("recentOrders", recentOrders);

            // 4. Top Customers
            List<ProductStat> topCustomers = orderDao.getTopCustomers(5);
            if (topCustomers == null)
                topCustomers = List.of();
            stats.put("topCustomers", topCustomers);

            // 5. Recent Customers
            List<com.haui.entity.User> recentCustomers = orderDao.getRecentCustomers(5);
            if (recentCustomers == null)
                recentCustomers = List.of();
            stats.put("recentCustomers", recentCustomers);

            // 6. Summary Stats
            double totalRevenue = revenueByMonth.values().stream().mapToDouble(Double::doubleValue).sum();
            stats.put("totalRevenue", totalRevenue);

            int totalOrders = orderDao.getTotalOrders();
            stats.put("totalOrders", totalOrders);

            int totalCustomers = orderDao.getTotalCustomers();
            stats.put("totalCustomers", totalCustomers);

            // 7. Weekly Revenue
            Map<String, Double> weeklyRevenue = orderDao.getWeeklyRevenue();
            if (weeklyRevenue == null)
                weeklyRevenue = new HashMap<>();
            stats.put("weeklyRevenue", weeklyRevenue);

            // 8. Funnel & Satisfaction (Real Data)
            int totalViews = orderDao.getTotalProductViews();
            stats.put("totalViews", totalViews);

            double avgRating = orderDao.getAverageRating();
            stats.put("avgRating", avgRating);

            // 9. Additional KPIs
            double grossProfit = orderDao.getGrossProfit();
            stats.put("grossProfit", grossProfit);

            double inventoryValue = orderDao.getInventoryValue();
            stats.put("inventoryValue", inventoryValue);

            double cancellationRate = orderDao.getCancellationRate();
            stats.put("cancellationRate", cancellationRate);

            // Write JSON response
            ObjectMapper mapper = new ObjectMapper();
            String json = mapper.writeValueAsString(stats);
            System.out.println("DashboardApiServlet: Response JSON: " + json);
            resp.getWriter().write(json);
        } catch (Exception e) {
            System.err.println("DashboardApiServlet: Error processing request");
            e.printStackTrace();
            // Return empty JSON instead of 500 to prevent frontend crash
            resp.setContentType("application/json");
            resp.getWriter().write("{}");
        }
    }

    @Override
    protected void doOptions(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setHeader("Access-Control-Allow-Origin", "*");
        resp.setHeader("Access-Control-Allow-Methods", "GET, OPTIONS");
        resp.setHeader("Access-Control-Allow-Headers", "Content-Type");
        resp.setStatus(HttpServletResponse.SC_OK);
    }
}

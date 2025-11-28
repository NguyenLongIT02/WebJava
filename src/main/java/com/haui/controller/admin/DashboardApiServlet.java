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
        stats.put("revenueByMonth", revenueByMonth);

        // 2. Top Selling Products
        List<ProductStat> topProducts = orderDao.getTopSellingProducts(5);
        stats.put("topProducts", topProducts);

        // 3. Recent Orders
        List<com.haui.dto.CartDetails> recentOrders = orderDao.getRecentOrders(6);
        stats.put("recentOrders", recentOrders);

        // 4. Top Customers
        List<ProductStat> topCustomers = orderDao.getTopCustomers(5);
        stats.put("topCustomers", topCustomers);

        // 5. Recent Customers
        List<com.haui.entity.User> recentCustomers = orderDao.getRecentCustomers(5);
        stats.put("recentCustomers", recentCustomers);

        // 6. Summary Stats
        double totalRevenue = revenueByMonth.values().stream().mapToDouble(Double::doubleValue).sum();
        stats.put("totalRevenue", totalRevenue);

        // Write JSON response
        ObjectMapper mapper = new ObjectMapper();
        mapper.writeValue(resp.getOutputStream(), stats);
    }

    @Override
    protected void doOptions(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setHeader("Access-Control-Allow-Origin", "*");
        resp.setHeader("Access-Control-Allow-Methods", "GET, OPTIONS");
        resp.setHeader("Access-Control-Allow-Headers", "Content-Type");
        resp.setStatus(HttpServletResponse.SC_OK);
    }
}

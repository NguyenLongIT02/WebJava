package com.haui.controller.admin;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.haui.dao.OrderDao;
import com.haui.dao.impl.OrderDaoImpl;
import com.haui.dto.ProductStat;
import com.haui.dto.CartDetails;
import com.haui.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Servlet dùng để kiểm thử nhanh các API nội bộ.
 * Các endpoint trả về dữ liệu JSON đơn giản để bạn có thể dùng curl/Postman
 * hoặc viết test tự động (JUnit, RestAssured) mà không cần phải qua UI.
 *
 * Các đường dẫn:
 * - /api/test/recent-orders → danh sách 5 đơn hàng gần nhất
 * - /api/test/top-products → top 5 sản phẩm bán chạy
 * - /api/test/top-customers → top 5 khách hàng (theo số đơn)
 * - /api/test/recent-customers → 5 người dùng mới đăng ký
 */
@WebServlet("/api/test/*")
public class TestApiServlet extends HttpServlet {

    private final OrderDao orderDao = new OrderDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // CORS để có thể gọi từ bất kỳ origin nào (trình duyệt, Postman, CI)
        resp.setHeader("Access-Control-Allow-Origin", "*");
        resp.setHeader("Access-Control-Allow-Methods", "GET, OPTIONS");
        resp.setHeader("Access-Control-Allow-Headers", "Content-Type");
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        String pathInfo = req.getPathInfo(); // ví dụ: "/recent-orders"
        Map<String, Object> result = new HashMap<>();

        if ("/recent-orders".equals(pathInfo)) {
            List<CartDetails> recentOrders = orderDao.getRecentOrders(5);
            result.put("recentOrders", recentOrders);
        } else if ("/top-products".equals(pathInfo)) {
            List<ProductStat> topProducts = orderDao.getTopSellingProducts(5);
            result.put("topProducts", topProducts);
        } else if ("/top-customers".equals(pathInfo)) {
            List<ProductStat> topCustomers = orderDao.getTopCustomers(5);
            result.put("topCustomers", topCustomers);
        } else if ("/recent-customers".equals(pathInfo)) {
            List<User> recentCustomers = orderDao.getRecentCustomers(5);
            result.put("recentCustomers", recentCustomers);
        } else {
            resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
            result.put("error", "Endpoint not found: " + pathInfo);
        }

        // Ghi JSON ra response
        ObjectMapper mapper = new ObjectMapper();
        mapper.writeValue(resp.getOutputStream(), result);
    }

    @Override
    protected void doOptions(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setHeader("Access-Control-Allow-Origin", "*");
        resp.setHeader("Access-Control-Allow-Methods", "GET, OPTIONS");
        resp.setHeader("Access-Control-Allow-Headers", "Content-Type");
        resp.setStatus(HttpServletResponse.SC_OK);
    }
}

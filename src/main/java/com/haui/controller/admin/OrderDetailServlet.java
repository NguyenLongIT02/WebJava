package com.haui.controller.admin;

import com.haui.dao.CartItemDao;
import com.haui.dao.impl.CartItemDaoImpl;
import com.haui.entity.CartItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(urlPatterns = "/admin/order/details")
public class OrderDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final CartItemDao cartItemDao = new CartItemDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setContentType("text/html;charset=UTF-8");
        String orderId = req.getParameter("orderId");

        if (orderId == null || orderId.isEmpty()) {
            resp.getWriter().write("<div class='alert alert-danger'>Mã đơn hàng không hợp lệ</div>");
            return;
        }

        // Lấy danh sách sản phẩm trong đơn hàng
        List<CartItem> items = cartItemDao.getByCartId(orderId);

        PrintWriter out = resp.getWriter();

        if (items == null || items.isEmpty()) {
            out.write("<div class='alert alert-warning'>Không có sản phẩm nào trong đơn hàng này</div>");
            return;
        }

        // Tạo HTML hiển thị chi tiết
        out.write("<ul class='item-list'>");
        long totalAmount = 0;

        for (CartItem item : items) {
            long lineTotal = item.getUnitPrice() * item.getQuantity();
            totalAmount += lineTotal;

            out.write("<li>");
            out.write("<div>");
            out.write("<strong>" + item.getProduct().getName() + "</strong><br>");
            out.write("<small class='text-muted'>Số lượng: " + item.getQuantity() + " × " +
                    String.format("%,d", item.getUnitPrice()) + "₫</small>");
            out.write("</div>");
            out.write("<div class='text-end'>");
            out.write("<strong>" + String.format("%,d", lineTotal) + "₫</strong>");
            out.write("</div>");
            out.write("</li>");
        }

        out.write("</ul>");
        out.write("<div class='total-amount'>");
        out.write("Tổng cộng: " + String.format("%,d", totalAmount) + "₫");
        out.write("</div>");
    }
}

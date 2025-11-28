package com.haui.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/admin/statistics")
public class StatisticsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // ----- Thống kê số lượng sản phẩm theo loại -----
        // (thay bằng query SELECT COUNT(*) FROM SanPham WHERE loai = 'Rau' ...)
        int vegetableCount = 50;
        int rootCount = 30;
        int fruitCount = 40;
        request.setAttribute("vegetableCount", vegetableCount);
        request.setAttribute("rootCount", rootCount);
        request.setAttribute("fruitCount", fruitCount);

        // ----- Doanh thu theo tháng -----
        // (thay bằng query GROUP BY MONTH(ngayDat))
        Map<String, Integer> revenueByMonth = new LinkedHashMap<>();
        revenueByMonth.put("Jan", 1000000);
        revenueByMonth.put("Feb", 1500000);
        revenueByMonth.put("Mar", 2000000);
        revenueByMonth.put("Apr", 1200000);
        revenueByMonth.put("May", 2500000);
        request.setAttribute("revenueByMonth", revenueByMonth);

        // ----- Số lượng bán theo loại -----
        // (thay bằng query SELECT loai, SUM(soLuong) FROM ChiTietDonHang JOIN SanPham GROUP BY loai)
        Map<String, Integer> salesByCategory = new HashMap<>();
        salesByCategory.put("Rau", 120);
        salesByCategory.put("Củ", 80);
        salesByCategory.put("Quả", 150);
        request.setAttribute("salesByCategory", salesByCategory);

        // Forward sang JSP
        request.getRequestDispatcher("/views/admin/statistics.jsp").forward(request, response);
    }
}

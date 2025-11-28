package com.haui.controller.admin;

import java.io.IOException;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.haui.dto.CartDetails;
import com.haui.service.CartDetailsService;
import com.haui.service.Impl.CartDetailsServiceImpl;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = "/admin", name = "HomeControllerOfAdmin")
public class HomeController extends HttpServlet {

	private static final long serialVersionUID = 1L;
	CartDetailsService cartDetailsService = new CartDetailsServiceImpl();
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		List<CartDetails> cartDetailList = cartDetailsService.getAll();
		 int vegetableCount = 50;
	        int rootCount = 30;
	        int fruitCount = 40;
	        req.setAttribute("vegetableCount", vegetableCount);
	        req.setAttribute("rootCount", rootCount);
	        req.setAttribute("fruitCount", fruitCount);

	        // ----- Doanh thu theo tháng -----
	        // (thay bằng query GROUP BY MONTH(ngayDat))
	        Map<String, Integer> revenueByMonth = new LinkedHashMap<>();
	        revenueByMonth.put("Jan", 1000000);
	        revenueByMonth.put("Feb", 1500000);
	        revenueByMonth.put("Mar", 2000000);
	        revenueByMonth.put("Apr", 1200000);
	        revenueByMonth.put("May", 2500000);
	        req.setAttribute("revenueByMonth", revenueByMonth);

	        // ----- Số lượng bán theo loại -----
	        // (thay bằng query SELECT loai, SUM(soLuong) FROM ChiTietDonHang JOIN SanPham GROUP BY loai)
	        Map<String, Integer> salesByCategory = new HashMap<>();
	        salesByCategory.put("Rau", 120);
	        salesByCategory.put("Củ", 80);
	        salesByCategory.put("Quả", 150);
	        req.setAttribute("salesByCategory", salesByCategory);

		RequestDispatcher dispatcher = req.getRequestDispatcher("/views/admin/statistics.jsp");
		req.setAttribute("cartDetailList", cartDetailList);
		dispatcher.forward(req, resp);
	}
}

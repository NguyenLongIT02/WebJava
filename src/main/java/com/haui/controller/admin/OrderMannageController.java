package com.haui.controller.admin;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.haui.dao.OrderDao;
import com.haui.dao.impl.OrderDaoImpl;
import com.haui.dto.CartDetails;
import com.haui.service.CartDetailsService;
import com.haui.service.Impl.CartDetailsServiceImpl;

@WebServlet(urlPatterns = "/admin/order", name = "OrderControllerOfAdmin")
public class OrderMannageController extends HttpServlet {

	private static final long serialVersionUID = 1L;
	CartDetailsService cartDetailsService = new CartDetailsServiceImpl();
	private final OrderDao orderDao = new OrderDaoImpl();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse response) throws ServletException, IOException {
		// Lấy danh sách đơn hàng (nên update service để lấy cả status, nhưng tạm thời
		// dùng cái cũ nếu nó gọi DAO)
		// Tuy nhiên, CartDetailsServiceImpl.getAll() có thể chưa lấy status.
		// Để chắc chắn, mình sẽ dùng orderDao.getRecentOrders(100) thay thế hoặc đảm
		// bảo service gọi đúng.
		// Kiểm tra CartDetailsServiceImpl sau. Tạm thời cứ để nguyên logic lấy list cũ,
		// nhưng mình hy vọng CartDetailsServiceImpl gọi OrderDao hoặc tương tự.

		// UPDATE: Để đảm bảo có status, mình sẽ dùng orderDao.getRecentOrders(100)
		// vì mình vừa sửa hàm này để lấy status.
		List<CartDetails> cartDetailList = orderDao.getRecentOrders(100);
		System.out.println("DEBUG: Fetched " + (cartDetailList != null ? cartDetailList.size() : "null") + " orders.");
		if (cartDetailList != null) {
			for (CartDetails d : cartDetailList) {
				System.out.println("Order: " + d.getId() + " - " + d.getBuyer() + " - Status: " + d.getStatus());
			}
		}
		req.setAttribute("cartDetailList", cartDetailList);
		RequestDispatcher dispatcher = req.getRequestDispatcher("/views/admin/index.jsp");
		dispatcher.forward(req, response);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String action = req.getParameter("action");
		String id = req.getParameter("id");

		if (id != null && !id.isEmpty()) {
			if ("confirm".equals(action)) {
				orderDao.updateStatus(id, 2); // 2: Shipping
			} else if ("complete".equals(action)) {
				orderDao.updateStatus(id, 3); // 3: Completed
			} else if ("cancel".equals(action)) {
				orderDao.updateStatus(id, 0); // 0: Cancelled
			} else if ("delete".equals(action)) {
				orderDao.delete(id);
			}
		}
		resp.sendRedirect(req.getContextPath() + "/admin/order");
	}
}

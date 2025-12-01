package com.haui.controller;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.HashMap;
import java.util.Map;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.haui.entity.Cart;
import com.haui.entity.CartItem;
import com.haui.entity.User;
import com.haui.service.CartItemService;
import com.haui.service.CartService;
import com.haui.service.UserService;
import com.haui.service.Impl.CartItemServiceImpl;
import com.haui.service.Impl.CartServiceImpl;
import com.haui.service.Impl.UserServiceImpl;
import com.haui.tools.RandomUserUID;
import com.haui.tools.sendEmail;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(urlPatterns = "/finalOrder")
public class FinalOrderControler extends HttpServlet {

	private static final long serialVersionUID = 1L;

	UserService userService = new UserServiceImpl();
	CartService cartService = new CartServiceImpl();
	CartItemService cartItemService = new CartItemServiceImpl();
	long time = System.currentTimeMillis();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession();
		Object obj = session.getAttribute("currentUser");
		User buyer = (User) obj;
		Cart cart = new Cart();
		cart.setBuyer(buyer);
		cart.setBuyDate(new java.sql.Date(time));

		// Add delivery info
		String deliveryDateStr = req.getParameter("deliveryDate");
		String deliveryTime = req.getParameter("deliveryTime");
		if (deliveryDateStr != null && !deliveryDateStr.isEmpty()) {
			try {
				cart.setDeliveryDate(java.sql.Date.valueOf(deliveryDateStr));
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		cart.setDeliveryTime(deliveryTime);

		cart.setId(RandomUserUID.getRandomID());

		cartService.insert(cart);
		// Lấy giá trị của cookie "cartItem" nếu có
		Cookie[] cookies = req.getCookies();
		String cartItemJson = null;
		if (cookies != null) {
			for (Cookie cookie : cookies) {
				if (cookie.getName().equals("cartItem")) {
					cartItemJson = URLDecoder.decode(cookie.getValue(), "UTF-8");
					break;
				}
			}
		}

		// Kiểm tra và xử lý dữ liệu từ cookie
		Map<Integer, CartItem> cartItemMap = new HashMap<>();
		ObjectMapper mapper = new ObjectMapper();

		if (cartItemJson != null && !cartItemJson.isEmpty()) {
			try {
				// Giải mã JSON thành một map các CartItem
				TypeReference<Map<Integer, CartItem>> typeRef = new TypeReference<Map<Integer, CartItem>>() {
				};
				cartItemMap = mapper.readValue(cartItemJson, typeRef);
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		Object discountObj = session.getAttribute("discount");
		long discount = 0;

		if (discountObj instanceof Integer) {
			discount = ((Integer) discountObj).longValue();
		} else if (discountObj instanceof Long) {
			discount = (Long) discountObj;
		}
		if (cartItemMap != null) {
			for (CartItem cartItem : cartItemMap.values()) {
				cartItem.setUnitPrice(cartItem.getUnitPrice() * (100 - discount) / 100);
				;
				cartItem.setCart(cart);
				cartItem.setId(RandomUserUID.getRandomID());
				cartItemService.insert(cartItem);
			}
			StringBuilder emailBuilder = new StringBuilder();
			emailBuilder.append("Xin chào ").append(cart.getBuyer().getUsername()).append(",\n\n");
			emailBuilder.append("Cảm ơn bạn đã đặt hàng tại Fruitables.\n");
			emailBuilder.append("Đơn hàng của bạn đã được ghi nhận và đang được xử lý.\n\n");
			if (cart.getDeliveryDate() != null) {
				emailBuilder.append("Ngày giao: ").append(cart.getDeliveryDate()).append("\n");
			}
			if (cart.getDeliveryTime() != null && !cart.getDeliveryTime().isEmpty()) {
				emailBuilder.append("Giờ giao: ").append(cart.getDeliveryTime()).append("\n");
			}
			emailBuilder.append("\nChi tiết đơn hàng:\n");
			long totalAmount = 0L;
			for (CartItem ci : cartItemMap.values()) {
				long lineTotal = ci.getUnitPrice() * ci.getQuantity();
				totalAmount += lineTotal;
				emailBuilder.append("- ")
						.append(ci.getProduct().getName())
						.append(" x ")
						.append(ci.getQuantity())
						.append(" = ")
						.append(lineTotal)
						.append("₫\n");
			}
			emailBuilder.append("\nTổng cộng: ").append(totalAmount).append("₫\n\n");
			emailBuilder.append("Chúng tôi sẽ liên hệ với bạn sớm nhất để giao hàng.\n\n");
			emailBuilder.append("Trân trọng,\nĐội ngũ Fruitables");
			String emailContent = emailBuilder.toString();
			sendEmail.sendMail(cart.getBuyer().getEmail(), "Xác nhận đơn hàng - Fruitables", emailContent);
		}
		session.removeAttribute("cart");
		session.removeAttribute("discount");
		for (Cookie cookie : cookies) {
			cookie.setMaxAge(0);
			resp.addCookie(cookie);
		}
		Cookie cookie = new Cookie("cartItem", null);
		cookie.setMaxAge(0);
		cookie.setPath("/");
		resp.addCookie(cookie);
		resp.sendRedirect("redirect.jsp");
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doGet(req, resp);
	}

}

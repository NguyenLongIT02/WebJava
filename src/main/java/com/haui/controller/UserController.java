package com.haui.controller;

import java.io.IOException;

import com.haui.constant.Path;
import com.haui.constant.SessionAttr;
import com.haui.entity.User;
import com.haui.service.UserService;
import com.haui.service.Impl.UserServiceImpl;
import com.haui.tools.sendEmail;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(urlPatterns = { "/login", "/logout", "/register", "/verify" })
public class UserController extends HttpServlet {

	private static final long serialVersionUID = 1L;

	private UserService userService = new UserServiceImpl();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession();
		String path = req.getServletPath();
		switch (path) {
			case "/login":
				doGetLogin(req, resp);
				break;
			case "/register":
				doGetRegister(req, resp);
				break;
			case "/logout":
				doGetLogout(session, req, resp);
				break;
			case "/verify":
				doGetVerify(req, resp);
				break;
		}
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession();
		String path = req.getServletPath();
		switch (path) {
			case "/login":
				doPostLogin(session, req, resp);
				break;
			case "/register":
				doPostRegister(session, req, resp);
				break;
			case "/verify":
				doPostVerify(session, req, resp);
				break;
		}
	}

	private void doGetLogin(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		RequestDispatcher dispatcher = req.getRequestDispatcher(Path.LOGIN);
		dispatcher.forward(req, resp);
	}

	private void doGetRegister(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		RequestDispatcher dispatcher = req.getRequestDispatcher(Path.REGISTER);
		dispatcher.forward(req, resp);
	}

	private void doGetLogout(HttpSession session, HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		session.removeAttribute(SessionAttr.CURRENT_USER);
		resp.sendRedirect("index");
	}

	private void doPostLogin(HttpSession session, HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		String username = req.getParameter("username");
		String password = req.getParameter("password");

		User user = userService.login(username, password);
		if (user != null) {
			session.setAttribute(SessionAttr.CURRENT_USER, user);
			if (user.isAdmin() == false) {
				resp.sendRedirect("index");
			} else {
				resp.sendRedirect("admin");
			}
		} else {
			// Login thất bại, hiển thị thông báo
			req.setAttribute("alert", "Tên đăng nhập hoặc mật khẩu không đúng.");
			RequestDispatcher dispatcher = req.getRequestDispatcher(Path.LOGIN);
			dispatcher.forward(req, resp);
		}
	}

	private void doGetVerify(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession();
		String codeParam = req.getParameter("code");
		String sessionCode = (String) session.getAttribute("verificationCode");
		if (codeParam != null && sessionCode != null && codeParam.equals(sessionCode)) {
			// Verification successful, create user from session temp data
			String email = (String) session.getAttribute("tempEmail");
			String username = (String) session.getAttribute("tempUsername");
			String password = (String) session.getAttribute("tempPassword");
			User user = userService.register(email, username, password);
			if (user != null) {
				// Clear temp session attributes
				session.removeAttribute("verificationCode");
				session.removeAttribute("tempEmail");
				session.removeAttribute("tempUsername");
				session.removeAttribute("tempPassword");
				// Log in user
				session.setAttribute(SessionAttr.CURRENT_USER, user);
				resp.sendRedirect("index");
				return;
			} else {
				req.setAttribute("alert", "Đăng ký thất bại. Vui lòng thử lại.");
			}
		}
		// Nếu không có code hoặc không khớp, hiển thị trang verify
		RequestDispatcher dispatcher = req.getRequestDispatcher(Path.VERIFY);
		dispatcher.forward(req, resp);
	}

	private void doPostVerify(HttpSession session, HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		String code = req.getParameter("code");
		String sessionCode = (String) session.getAttribute("verificationCode");

		if (code != null && code.equals(sessionCode)) {
			// Code matched, register user
			String email = (String) session.getAttribute("tempEmail");
			String username = (String) session.getAttribute("tempUsername");
			String password = (String) session.getAttribute("tempPassword");

			User user = userService.register(email, username, password);
			if (user != null) {
				// Clear session temp attributes
				session.removeAttribute("verificationCode");
				session.removeAttribute("tempEmail");
				session.removeAttribute("tempUsername");
				session.removeAttribute("tempPassword");

				// Send welcome email (optional, since we already sent code)
				sendEmail.sendMail(email, "Welcome to Fruitables", "Registration successful! Welcome to our store.");

				// Login user
				session.setAttribute(SessionAttr.CURRENT_USER, user);
				resp.sendRedirect("index");
			} else {
				req.setAttribute("alert", "Registration failed. Username might already exist.");
				req.getRequestDispatcher("/views/user/verify.jsp").forward(req, resp);
			}
		} else {
			req.setAttribute("alert", "Invalid verification code!");
			req.getRequestDispatcher("/views/user/verify.jsp").forward(req, resp);
		}
	}

	private void doPostRegister(HttpSession session, HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		String email = req.getParameter("email");
		String username = req.getParameter("username");
		String password = req.getParameter("password");

		if (userService.checkExistEmail(email)) {
			String alertMsg = "Email already exist!";
			req.setAttribute("alert", alertMsg);
			req.getRequestDispatcher(Path.REGISTER).forward(req, resp);
			return;
		}
		if (userService.checkExistUsername(username)) {
			String alertMsg = "Username already exist!";
			req.setAttribute("alert", alertMsg);
			req.getRequestDispatcher(Path.REGISTER).forward(req, resp);
			return;
		}

		// Generate 6-digit code
		java.util.Random rnd = new java.util.Random();
		int number = rnd.nextInt(999999);
		String code = String.format("%06d", number);

		// Gửi email xác nhận với link chứa mã xác thực
		String verificationLink = "http://localhost:8080/VegetableStoreManager/verify?code=" + code;
		String emailContent = "Xin chào,\n\nBạn đã đăng ký tài khoản trên Fruitables. Vui lòng nhấp vào link dưới đây để xác nhận email của bạn:\n"
				+ verificationLink + "\n\nNếu bạn không đăng ký, vui lòng bỏ qua email này.";
		boolean emailSent = sendEmail.sendMail(email, "Fruitables Xác nhận Email", emailContent);
		if (!emailSent) {
			req.setAttribute("alert", "Gửi email xác nhận thất bại. Vui lòng thử lại.");
			req.getRequestDispatcher(Path.REGISTER).forward(req, resp);
			return;
		}

		// Store in session
		session.setAttribute("verificationCode", code);
		session.setAttribute("tempEmail", email);
		session.setAttribute("tempUsername", username);
		session.setAttribute("tempPassword", password);

		// Thông báo thành công và chuyển tới trang xác thực
		req.setAttribute("alert", "Đăng ký thành công! Vui lòng kiểm tra email để xác nhận.");
		RequestDispatcher dispatcher = req.getRequestDispatcher(Path.VERIFY);
		dispatcher.forward(req, resp);
		return;
	}

}

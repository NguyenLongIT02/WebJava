package com.haui.controller.admin;

import java.io.IOException;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.haui.dto.CartDetails;
import com.haui.service.CartDetailsService;
import com.haui.service.Impl.CartDetailsServiceImpl;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.annotation.WebServlet;

@WebServlet(urlPatterns = "/admin/order", name = "OrderControllerOfAdmin")
public class OrderMannageController extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	CartDetailsService cartDetailsService = new CartDetailsServiceImpl();
	
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse response) throws ServletException, IOException {
    	List<CartDetails> cartDetailList = cartDetailsService.getAll();
    	req.setAttribute("cartDetailList", cartDetailList);
    	RequestDispatcher dispatcher = req.getRequestDispatcher("/views/admin/index.jsp");
		dispatcher.forward(req, response);
        
    }
}

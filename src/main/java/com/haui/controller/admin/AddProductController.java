package com.haui.controller.admin;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;

import org.apache.commons.fileupload2.core.DiskFileItemFactory;
import org.apache.commons.fileupload2.core.FileItem;
import org.apache.commons.fileupload2.jakarta.servlet6.JakartaServletFileUpload;

import com.haui.entity.Category;
import com.haui.entity.Product;
import com.haui.service.CategoryService;
import com.haui.service.ProductService;
import com.haui.service.Impl.CategoryServiceImpl;
import com.haui.service.Impl.ProductServiceImpl;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = "/admin/addproduct")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class AddProductController extends HttpServlet {

	private static final long serialVersionUID = 1L;

	CategoryService categoryService = new CategoryServiceImpl();
	ProductService productService = new ProductServiceImpl();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		List<Category> cateList = categoryService.getAll();
		req.setAttribute("categories", cateList);
		RequestDispatcher dispatcher = req.getRequestDispatcher("/views/admin/addproduct.jsp");
		dispatcher.forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");
		resp.setCharacterEncoding("UTF-8");
		Product product = new Product();
		DiskFileItemFactory factory = DiskFileItemFactory.builder().get();
		JakartaServletFileUpload upload = new JakartaServletFileUpload(factory);
		try {
			List<FileItem> items = upload.parseRequest(req);
			for (FileItem item : items) {
				if (item.getFieldName().equals("id")) {
					product.setId(Integer.parseInt(item.getString()));
				} else if (item.getFieldName().equals("name")) {
					product.setName(item.getString(StandardCharsets.UTF_8));
				} else if (item.getFieldName().equals("category")) {
					Category category = categoryService.get(Integer.parseInt(item.getString()));
					product.setCategory(category);
				} else if (item.getFieldName().equals("description")) {
					product.setDes(item.getString(StandardCharsets.UTF_8));
				} else if (item.getFieldName().equals("price")) {
					product.setPrice(Long.parseLong(item.getString()));
				} else if (item.getFieldName().equals("image")) {
					if (item.getSize() > 0) {
						final String uploadDir = getServletContext().getRealPath("/templates/user/img");
						String originalFileName = item.getName();

						// Tạo thư mục nếu chưa tồn tại
						Path uploadPath = Paths.get(uploadDir);
						if (!Files.exists(uploadPath)) {
							Files.createDirectories(uploadPath);
						}

						Path filePath = Paths.get(uploadDir, originalFileName);

						// Ghi file
						try (InputStream input = item.getInputStream()) {
							Files.copy(input, filePath, StandardCopyOption.REPLACE_EXISTING);
							System.out.println("File uploaded successfully to: " + filePath.toString());
						} catch (IOException e) {
							System.err.println("Error uploading file: " + e.getMessage());
							e.printStackTrace();
						}

						product.setImage(originalFileName);
					} else {
						product.setImage(null);
					}
				}
			}

			productService.insert(product);
			resp.sendRedirect(req.getContextPath() + "/admin/productlist");
		} catch (Exception e) {
			System.err.println("Error adding product: " + e.getMessage());
			e.printStackTrace();
			req.setAttribute("error", "Không thể thêm sản phẩm: " + e.getMessage());
			req.getRequestDispatcher("/views/admin/addproduct.jsp").forward(req, resp);
		}
	}

}

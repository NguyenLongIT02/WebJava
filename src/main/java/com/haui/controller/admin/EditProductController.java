package com.haui.controller.admin;

import java.io.File;
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

@WebServlet(urlPatterns = "/admin/editproduct")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, 
                 maxFileSize = 1024 * 1024 * 10, 
                 maxRequestSize = 1024 * 1024 * 50)
public class EditProductController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String SAVE_DIR = "Upload";  // thư mục lưu ảnh upload

    ProductService productService = new ProductServiceImpl();
    CategoryService categoryService = new CategoryServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        
        String id = req.getParameter("pId");
        Product product = productService.get(Integer.parseInt(id));
        List<Category> cateList = categoryService.getAll();
        req.setAttribute("categories", cateList);
        req.setAttribute("product", product);
        RequestDispatcher dispatcher = req.getRequestDispatcher("/views/admin/editproduct.jsp");
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
                if (item.isFormField()) {
                    // các field text
                    String fieldName = item.getFieldName();
                    String fieldValue = item.getString(StandardCharsets.UTF_8);
                    switch (fieldName) {
                        case "id":
                            product.setId(Integer.parseInt(fieldValue));
                            break;
                        case "name":
                            product.setName(fieldValue);
                            break;
                        case "category":
                            Category category = categoryService.get(Integer.parseInt(fieldValue));
                            product.setCategory(category);
                            break;
                        case "description":
                            product.setDes(fieldValue);
                            break;
                        case "price":
                            product.setPrice(Long.parseLong(fieldValue));
                            break;
                    }
                } else {
                    // field file (image)
                    String originalFileName = item.getName();
                    if (originalFileName != null && !originalFileName.isEmpty()) {
                        // Thư mục upload nằm trong webapp
                        String uploadDir = getServletContext().getRealPath("") + File.separator + SAVE_DIR;
                        File uploadFolder = new File(uploadDir);
                        if (!uploadFolder.exists()) {
                            uploadFolder.mkdir();
                        }

                        Path filePath = Paths.get(uploadDir, originalFileName);
                        try (InputStream input = item.getInputStream()) {
                            Files.copy(input, filePath, StandardCopyOption.REPLACE_EXISTING);
                        }
                        // Lưu đường dẫn tương đối để dùng trong JSP
                        product.setImage(originalFileName);
                    } else {
                        // Nếu không upload ảnh mới → giữ ảnh cũ
                        product.setImage(productService.get(product.getId()).getImage());
                    }
                }
            }

            productService.edit(product);
            resp.sendRedirect(req.getContextPath() + "/admin/productlist");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

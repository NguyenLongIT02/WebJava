# HƯỚNG DẪN BÁO CÁO BÀI TẬP LỚN WEB JAVA

## MỤC LỤC
1. [Kịch bản thuyết trình video](#1-kịch-bản-thuyết-trình-video)
2. [Giải thích chi tiết các module](#2-giải-thích-chi-tiết-các-module)
3. [Cấu hình project](#3-cấu-hình-project)
4. [Kiểm thử API với Postman](#4-kiểm-thử-api-với-postman)
5. [Cấu hình Chatbot AI](#5-cấu-hình-chatbot-ai)
6. [Cấu hình Email](#6-cấu-hình-email)

---

## 1. KỊCH BẢN THUYẾT TRÌNH VIDEO

### Phần 1: Giới thiệu & Cấu hình (0.5 điểm)
*(Thao tác: Mở IDE, show cây thư mục dự án)*

**Lời thoại:**
> "Xin chào thầy và các bạn. Sau đây em xin trình bày bài tập lớn của mình, bao gồm việc thiết kế giao diện và lập trình các chức năng theo yêu cầu.
>
> Về tổng quan, dự án được xây dựng theo mô hình **MVC (Model-View-Controller)** tiêu chuẩn. Cấu trúc source code được tổ chức và quản lý rõ ràng theo từng package chức năng:
> - **Package `com.haui.entity`**: Chứa các lớp thực thể (POJO) ánh xạ với các bảng trong cơ sở dữ liệu.
> - **Package `com.haui.dao`**: Chứa các Interface và lớp cài đặt để truy xuất dữ liệu.
> - **Package `com.haui.service`**: Chứa các Interface và lớp xử lý nghiệp vụ logic.
> - **Package `com.haui.controller`**: Chứa các Servlet đóng vai trò điều hướng.
>
> *(Click mở file `ConnectionPoolImpl.java`)*
> Đặc biệt, để đáp ứng yêu cầu kỹ thuật, em đã cấu hình **JDBC** sử dụng kỹ thuật **Connection Pooling**. Thay vì tạo mới kết nối liên tục gây tốn tài nguyên, hệ thống sẽ lấy kết nối từ một bể (Pool) có sẵn, giúp tối ưu hóa hiệu suất."

---

### Phần 2: Chức năng Xem Chi tiết Sản phẩm (User)

#### 2.1. Demo Giao diện
*(Chuyển sang Trình duyệt → Trang chủ → Click vào một sản phẩm)*

**Lời thoại:**
> "Đầu tiên là chức năng phía người dùng: **Xem chi tiết sản phẩm**.
> Giao diện được thiết kế bằng **Bootstrap**, đảm bảo Responsive. Bố cục gồm ảnh sản phẩm, thông tin giá, mô tả và danh sách sản phẩm liên quan."

#### 2.2. Giải thích Code Frontend
*(Mở file `product-detail.jsp`)*

**Lời thoại:**
> "Về code Frontend, em sử dụng **JSTL** để hiển thị dữ liệu động từ Server.
> *(Scroll xuống đoạn Script)*
> Đặc biệt, em sử dụng **JavaScript** để xử lý logic giỏ hàng ngay tại client: kiểm tra số lượng tồn kho và hiển thị thông báo (Toast Notification) ngay lập tức."

#### 2.3. Giải thích Code Backend
*(Mở `ProductDetailController.java` → `ProductServiceImpl.java` → `ProductDaoImpl.java`)*

**Lời thoại:**
> "Về xử lý Backend:
> - Khi người dùng chọn sản phẩm, Request gửi đến `ProductDetailController`. Tại đây, em lấy tham số `id` và gọi sang Service.
> - Đồng thời, em gọi hàm `updateViewCount` để tăng lượt xem.
> - Tại tầng DAO (`ProductDaoImpl`), em sử dụng câu lệnh SQL `SELECT` kết hợp `INNER JOIN` để lấy đầy đủ thông tin sản phẩm và danh mục."

---

### Phần 3: Chức năng Dashboard & Quản lý Tài khoản (Admin)

#### 3.1. Demo Dashboard
*(Chuyển sang Trình duyệt → Đăng nhập Admin → Trang Dashboard)*

**Lời thoại:**
> "Tiếp theo là phân hệ Quản trị. Trang đầu tiên là **Dashboard**.
> Tại đây hiển thị trực quan các biểu đồ doanh thu, thống kê đơn hàng mới và các chỉ số KPI quan trọng."

#### 3.2. Giải thích Code Dashboard
*(Mở `DashboardApiServlet.java` và `statistics.jsp`)*

**Lời thoại:**
> "Để làm được điều này, em viết một API riêng là `DashboardApiServlet`.
> Servlet này gọi xuống DAO để tổng hợp dữ liệu, sau đó trả về dưới dạng **JSON**.
> Bên phía giao diện, em dùng **AJAX** để gọi API này và sử dụng thư viện **Chart.js** để vẽ biểu đồ động."

#### 3.3. Demo Quản lý Tài khoản
*(Chuyển sang Trình duyệt → Menu Quản lý tài khoản)*

**Lời thoại:**
> "Chức năng tiếp theo là **Quản lý tài khoản**.
> Admin có thể xem danh sách User, tìm kiếm và thực hiện Thêm/Sửa/Xóa.
> *(Thao tác: Click chọn 1 user → Form tự điền)*
> Khi em chọn một tài khoản, thông tin sẽ tự động điền vào form mà không cần tải lại trang."

#### 3.4. Giải thích Code Quản lý Tài khoản
*(Mở `AccountController.java` → `AddAccountController.java` → `UserDaoImpl.java`)*

**Lời thoại:**
> "Về code xử lý:
> - Tại `AccountController`, phương thức `doPost` trả về dữ liệu User dạng **JSON** để phục vụ tính năng 'Xem nhanh' bằng AJAX.
> - Với chức năng **Thêm/Sửa**, em sử dụng thư viện **Apache Commons FileUpload** để xử lý upload ảnh Avatar.
> - *(Mở `UserServiceImpl.java`)*: Trong Service, em có xử lý logic: Nếu Admin cập nhật ảnh mới, hệ thống sẽ tự động **xóa file ảnh cũ** trên server.
> - Cuối cùng, `UserDaoImpl` thực thi các câu lệnh SQL trực tiếp xuống Database."

---

## 2. GIẢI THÍCH CHI TIẾT CÁC MODULE

### Module 1: Xem Chi tiết Sản phẩm

#### A. Khai báo Interface

**1. Tầng DAO (`ProductDao.java`)**
```java
public interface ProductDao {
    Product get(int id);
    void updateViewCount(int id);
    // ... các phương thức khác
}
```

**2. Tầng Service (`ProductService.java`)**
```java
public interface ProductService {
    Product get(int id);
    // ... các phương thức khác
}
```

#### B. Cài đặt phương thức

**1. ProductDaoImpl.java**
- Sử dụng **Connection Pool** để lấy kết nối
- Câu lệnh SQL: `SELECT * FROM Product INNER JOIN Category ... WHERE id = ?`
- Sử dụng `PreparedStatement` để truyền tham số an toàn
- Mapping `ResultSet` vào đối tượng `Product`

**2. ProductServiceImpl.java**
- Gọi `dao.get(id)` để lấy dữ liệu
- Gọi `updateViewCount(id)` để tăng lượt xem (logic nghiệp vụ)

**3. ProductDetailController.java**
- Nhận request, lấy `id` từ URL
- Gọi Service để lấy dữ liệu
- Forward sang `product-detail.jsp`

---

### Module 2: Dashboard (Admin)

#### A. Khai báo Interface

**OrderDao.java**
```java
public interface OrderDao {
    Map<String, Object> getRevenueByMonth();
    List<Product> getTopSellingProducts();
    List<Order> getRecentOrders();
}
```

#### B. Cài đặt phương thức

**1. OrderDaoImpl.java**
- Sử dụng SQL Aggregation: `SELECT MONTH(order_date), SUM(total_amount) ... GROUP BY MONTH`
- Trả về `Map` hoặc `List` chứa dữ liệu thống kê

**2. DashboardApiServlet.java**
- Gọi Service/DAO để lấy số liệu
- Sử dụng **Jackson ObjectMapper** để chuyển đổi sang JSON
- Trả về response dạng JSON

**3. statistics.jsp**
- Sử dụng **AJAX (fetch API)** để gọi API
- Sử dụng **Chart.js** để vẽ biểu đồ

---

### Module 3: Quản lý Tài khoản (Admin)

#### A. Khai báo Interface

**UserDao.java**
```java
public interface UserDao {
    void insert(User user);
    void edit(User user);
    void delete(int id);
    List<User> getAll();
}
```

#### B. Cài đặt phương thức

**1. UserDaoImpl.java**
- Thực thi SQL: `INSERT`, `UPDATE`, `DELETE`
- Quản lý Transaction: `setAutoCommit(false)`, `commit()`, `rollback()`

**2. UserServiceImpl.java**
- Logic xử lý file ảnh: Xóa ảnh cũ khi cập nhật ảnh mới

**3. AddAccountController.java**
- Sử dụng **Apache Commons FileUpload** để parse `multipart/form-data`
- Lưu file ảnh vào thư mục `Upload`

---

## 3. CẤU HÌNH PROJECT

### Cấu trúc Package
```
com.haui
├── entity/          # Các lớp POJO (User, Product, Order...)
├── dao/             # Interface và Implementation truy xuất DB
├── service/         # Interface và Implementation xử lý nghiệp vụ
├── controller/      # Các Servlet điều hướng
├── JDBCUtil/        # Connection Pool
└── tools/           # Các tiện ích (sendEmail...)
```

### Thư viện sử dụng (pom.xml hoặc WEB-INF/lib)
- **JSTL**: Hiển thị dữ liệu trên JSP
- **MySQL/SQL Server Driver**: Kết nối Database
- **Apache Commons FileUpload**: Upload file
- **Jackson**: Xử lý JSON

### Connection Pooling
- File: `com.haui.JDBCUtil.ConnectionPoolImpl`
- Mục đích: Tái sử dụng kết nối DB, giảm tải tài nguyên

---

## 4. KIỂM THỬ API VỚI POSTMAN

### API 1: Dashboard Statistics
- **Method**: GET
- **URL**: `http://localhost:8080/VegetableStoreManager/api/admin/dashboard-stats`
- **Response**: JSON chứa dữ liệu thống kê

### API 2: Get Account Detail
- **Method**: POST
- **URL**: `http://localhost:8080/VegetableStoreManager/admin/account`
- **Body (x-www-form-urlencoded)**:
  - Key: `Id`
  - Value: `1` (ID của user)
- **Response**: JSON thông tin user

### Lưu ý
- Thay `/VegetableStoreManager` bằng Context Path thực tế của bạn
- Có thể cần đăng nhập trước (hoặc tắt Filter kiểm tra session)

---

## 5. CẤU HÌNH CHATBOT AI

### Chatbot đã được tích hợp với Groq AI (Miễn phí)

**File**: `com.haui.controller.ChatbotServlet.java`

**Cấu hình hiện tại**:
- API Provider: **Groq AI** (https://console.groq.com/)
- Model: `llama-3.3-70b-versatile`
- API Key: `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`

**Chức năng**:
- Trả lời thông minh bằng AI (tiếng Việt)
- Fallback về Rule-based nếu AI lỗi

**Nếu muốn đổi sang AI khác**:
1. **OpenAI ChatGPT**: Cần thẻ tín dụng, API Key từ platform.openai.com
2. **Google Gemini**: Miễn phí nhưng hiện tại có vấn đề với model availability

---

## 6. CẤU HÌNH EMAIL

### Email đã được tích hợp sẵn

**File**: `com.haui.tools.sendEmail.java`

**Chức năng**:
1. **Email chào mừng** khi đăng ký tài khoản (`UserController.java`)
2. **Email xác nhận mã code** để verify email
3. **Email xác nhận đơn hàng** khi mua hàng (`FinalOrderControler.java`)

### ⚠️ Cần cấu hình lại

**Vấn đề**: Gmail không còn cho phép đăng nhập bằng mật khẩu thường.

**Giải pháp**:
1. Vào: https://myaccount.google.com/apppasswords
2. Đăng nhập Gmail
3. Tạo **App Password** mới
4. Copy mật khẩu 16 ký tự
5. Thay đổi trong `sendEmail.java` (dòng 23):
```java
return new PasswordAuthentication("email-cua-ban@gmail.com", "xxxx xxxx xxxx xxxx");
```

---

## 7. CHECKLIST TRƯỚC KHI BẢO VỆ

- [ ] Đã test tất cả chức năng trên trình duyệt
- [ ] Database có đủ dữ liệu mẫu
- [ ] Chatbot hoạt động (AI hoặc Rule-based)
- [ ] Email đã cấu hình đúng App Password
- [ ] Đã chuẩn bị kịch bản thuyết trình
- [ ] Đã hiểu rõ luồng dữ liệu MVC
- [ ] Đã test API bằng Postman (nếu cần)

---

**Chúc bạn bảo vệ thành công! 🎉**

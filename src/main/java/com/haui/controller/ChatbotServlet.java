package com.haui.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.concurrent.*;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.haui.entity.Product;
import com.haui.entity.Category;
import com.haui.service.ProductService;
import com.haui.service.CategoryService;
import com.haui.service.Impl.ProductServiceImpl;
import com.haui.service.Impl.CategoryServiceImpl;

@WebServlet("/chatbot")
public class ChatbotServlet extends HttpServlet {

    // Groq API Key
    private static final String API_KEY = "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";
    private static final String API_URL = "https://api.groq.com/openai/v1/chat/completions";
    private static final int AI_TIMEOUT_SECONDS = 5; // Timeout 5 giây

    // Services để lấy dữ liệu từ database
    private ProductService productService = new ProductServiceImpl();
    private CategoryService categoryService = new CategoryServiceImpl();

    // Cache context (refresh mỗi 5 phút)
    private static String cachedContext = null;
    private static long lastCacheTime = 0;
    private static final long CACHE_DURATION = 5 * 60 * 1000;

    // Thread pool cho AI calls
    private static final ExecutorService aiExecutor = Executors.newFixedThreadPool(3);

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain; charset=UTF-8");

        String msg = request.getParameter("message");
        String reply = "Xin lỗi, tôi chưa hiểu câu hỏi.";

        if (msg != null && !msg.trim().isEmpty()) {
            System.out.println("📩 Chatbot nhận tin nhắn: " + msg);

            // 1. Gọi AI với timeout
            String aiReply = callGroqAIWithTimeout(msg);

            if (aiReply != null && !aiReply.isEmpty()) {
                System.out.println("✅ AI trả lời: " + aiReply);
                reply = aiReply;
            } else {
                // 2. Fallback về rule-based nếu AI lỗi/timeout
                System.out.println("⚠️ AI không phản hồi, chuyển sang rule-based");
                reply = getRuleBasedReplyWithData(msg.toLowerCase().trim());
            }
        }

        response.getWriter().write(reply);
    }

    /**
     * Gọi AI với timeout để tránh chờ lâu
     */
    private String callGroqAIWithTimeout(String userQuestion) {
        Future<String> future = aiExecutor.submit(() -> callGroqAIWithData(userQuestion));

        try {
            return future.get(AI_TIMEOUT_SECONDS, TimeUnit.SECONDS);
        } catch (TimeoutException e) {
            System.err.println("⏱️ AI timeout sau " + AI_TIMEOUT_SECONDS + " giây");
            future.cancel(true);
            return null;
        } catch (Exception e) {
            System.err.println("❌ Lỗi khi gọi AI: " + e.getMessage());
            return null;
        }
    }

    /**
     * Lấy dữ liệu từ database với cache
     */
    private String buildDatabaseContext() {
        long currentTime = System.currentTimeMillis();

        // Dùng cache nếu còn hiệu lực
        if (cachedContext != null && (currentTime - lastCacheTime) < CACHE_DURATION) {
            return cachedContext;
        }

        StringBuilder context = new StringBuilder();

        try {
            List<Product> products = productService.getAll();
            List<Category> categories = categoryService.getAll();

            context.append("THÔNG TIN CỬA HÀNG FRUITABLES:\n\n");

            // Thông tin danh mục
            context.append("DANH MỤC SẢN PHẨM:\n");
            for (Category cat : categories) {
                context.append("- ").append(cat.getName()).append("\n");
            }
            context.append("\n");

            // Thông tin sản phẩm chi tiết
            context.append("DANH SÁCH SẢN PHẨM CÓ SẴN:\n");
            for (Product p : products) {
                context.append(String.format("• %s (ID: %d)\n", p.getName(), p.getId()));
                context.append(String.format("  - Giá: $%.2f\n", (double) p.getPrice()));
                context.append(String.format("  - Danh mục: %s\n", p.getCategory().getName()));
                context.append(String.format("  - Số lượng còn: %d\n", p.getQuantity()));
                if (p.getDes() != null && !p.getDes().isEmpty()) {
                    context.append(String.format("  - Mô tả: %s\n", p.getDes()));
                }
                context.append("\n");
            }

            // Thông tin chung
            context.append("\nTHÔNG TIN LIÊN HỆ:\n");
            context.append("- Hotline: 0988 123 456\n");
            context.append("- Địa chỉ: Số 5 Văn Trì, Hà Nội\n");
            context.append("- Giờ mở cửa: 7h sáng - 9h tối mỗi ngày\n");
            context.append("- Giao hàng: Nội thành Hà Nội trong 2h\n");
            context.append("- Thanh toán: Tiền mặt, thẻ, ví điện tử\n");
            context.append("- Khuyến mãi: Giảm 10% cho đơn hàng trên $200\n");

            // Cache lại
            cachedContext = context.toString();
            lastCacheTime = currentTime;

        } catch (Exception e) {
            System.err.println("Lỗi khi lấy dữ liệu từ database: " + e.getMessage());
            if (cachedContext != null)
                return cachedContext; // Dùng cache cũ nếu lỗi
        }

        return context.toString();
    }

    /**
     * Gọi Groq AI với dữ liệu từ database
     */
    private String callGroqAIWithData(String userQuestion) {
        if (API_KEY.equals("YOUR_GROQ_API_KEY") || API_KEY.isEmpty()) {
            System.err.println("Groq API Key chưa được cấu hình.");
            return null;
        }

        try {
            String databaseContext = buildDatabaseContext();

            URL url = new URL(API_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("Authorization", "Bearer " + API_KEY);
            conn.setDoOutput(true);
            conn.setConnectTimeout(3000); // 3 giây
            conn.setReadTimeout(5000); // 5 giây

            ObjectMapper mapper = new ObjectMapper();
            com.fasterxml.jackson.databind.node.ObjectNode rootNode = mapper.createObjectNode();
            rootNode.put("model", "llama-3.3-70b-versatile");

            com.fasterxml.jackson.databind.node.ArrayNode messagesArray = mapper.createArrayNode();

            // System message với dữ liệu từ database
            com.fasterxml.jackson.databind.node.ObjectNode systemMessage = mapper.createObjectNode();
            systemMessage.put("role", "system");
            systemMessage.put("content",
                    "Bạn là trợ lý ảo thông minh, thân thiện của cửa hàng Fruitables - chuyên bán rau củ quả sạch. " +
                            "Hãy trò chuyện tự nhiên và hữu ích với khách hàng.\n\n" +

                            "NGUYÊN TẮC TRẢ LỜI:\n" +
                            "1. 🎯 Về sản phẩm/giá cả: Dùng CHÍNH XÁC dữ liệu bên dưới. KHÔNG bịa đặt sản phẩm không có.\n"
                            +
                            "2. 💡 Gợi ý thông minh: Có thể đề xuất sản phẩm phù hợp, công thức nấu ăn, lợi ích sức khỏe.\n"
                            +
                            "3. 🌟 Câu hỏi chung: Trả lời tự nhiên về dinh dưỡng, nấu ăn, sức khỏe, hoặc bất kỳ chủ đề nào.\n"
                            +
                            "4. 😊 Phong cách: Thân thiện, nhiệt tình, hữu ích. Có thể dùng emoji phù hợp.\n" +
                            "5. 📝 Độ dài: Ngắn gọn nhưng đầy đủ thông tin. Có thể dài hơn nếu cần giải thích.\n\n" +

                            databaseContext);
            messagesArray.add(systemMessage);

            // User message
            com.fasterxml.jackson.databind.node.ObjectNode userMessage = mapper.createObjectNode();
            userMessage.put("role", "user");
            userMessage.put("content", userQuestion);
            messagesArray.add(userMessage);

            rootNode.set("messages", messagesArray);

            String jsonInputString = mapper.writeValueAsString(rootNode);

            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonInputString.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            int code = conn.getResponseCode();
            if (code == 200) {
                try (BufferedReader br = new BufferedReader(
                        new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                    StringBuilder response = new StringBuilder();
                    String responseLine;
                    while ((responseLine = br.readLine()) != null) {
                        response.append(responseLine.trim());
                    }

                    JsonNode responseNode = mapper.readTree(response.toString());
                    return responseNode.path("choices").get(0).path("message").path("content").asText();
                }
            } else {
                System.err.println("Groq API Error Code: " + code);
            }

        } catch (Exception e) {
            System.err.println("Lỗi AI: " + e.getMessage());
        }
        return null;
    }

    /**
     * Fallback rule-based với dữ liệu từ database
     */
    private String getRuleBasedReplyWithData(String msg) {
        try {
            // Tìm kiếm sản phẩm theo từ khóa
            if (msg.contains("giá") || msg.contains("bao nhiêu")) {
                // Tìm sản phẩm cụ thể
                List<Product> allProducts = productService.getAll();
                for (Product p : allProducts) {
                    if (msg.contains(p.getName().toLowerCase())) {
                        return String.format("Giá %s là $%.2f. Hiện còn %d sản phẩm.",
                                p.getName(), (double) p.getPrice(), p.getQuantity());
                    }
                }
                return "Giá sản phẩm dao động từ $12 - $35. Bạn muốn hỏi giá sản phẩm nào?";
            }

            // Tìm theo danh mục
            List<Category> categories = categoryService.getAll();
            for (Category cat : categories) {
                if (msg.contains(cat.getName().toLowerCase())) {
                    List<Product> products = productService.seachByCategory(cat.getId());
                    StringBuilder reply = new StringBuilder();
                    reply.append("Các sản phẩm ").append(cat.getName()).append(":\n");
                    for (Product p : products) {
                        reply.append(String.format("• %s - $%.2f (còn %d)\n",
                                p.getName(), (double) p.getPrice(), p.getQuantity()));
                    }
                    return reply.toString();
                }
            }

            // Tìm sản phẩm theo tên
            List<Product> allProducts = productService.getAll();
            for (Product p : allProducts) {
                if (msg.contains(p.getName().toLowerCase())) {
                    return String.format("%s - Giá: $%.2f\n%s\nCòn lại: %d sản phẩm",
                            p.getName(), (double) p.getPrice(), p.getDes(), p.getQuantity());
                }
            }

        } catch (Exception e) {
            System.err.println("Lỗi rule-based: " + e.getMessage());
        }

        // Các câu trả lời chung
        if (msg.contains("ship") || msg.contains("giao hàng")) {
            return "Chúng tôi giao hàng trong nội thành Hà Nội trong vòng 2h.";
        } else if (msg.contains("thanh toán")) {
            return "Bạn có thể thanh toán bằng tiền mặt, thẻ hoặc ví điện tử.";
        } else if (msg.contains("khuyến mãi") || msg.contains("giảm giá")) {
            return "Hiện có chương trình giảm giá 10% cho đơn hàng trên $200.";
        } else if (msg.contains("giờ mở cửa") || msg.contains("hoạt động")) {
            return "Cửa hàng mở cửa từ 7h sáng đến 9h tối mỗi ngày.";
        } else if (msg.contains("liên hệ") || msg.contains("tư vấn")
                || msg.contains("số điện thoại") || msg.contains("địa chỉ")) {
            return "Bạn có thể liên hệ với chúng tôi qua:\n" +
                    "- 📞 Hotline: 0988 123 456\n" +
                    "- 🏪 Địa chỉ: Số 5 Văn Trì, Hà Nội\n" +
                    "- 🌐 Fanpage: fb.com/raucuquasach";
        }

        return "Xin lỗi, tôi chưa hiểu câu hỏi. Bạn có thể hỏi về sản phẩm, giá cả, hoặc giao hàng.";
    }

    @Override
    public void destroy() {
        aiExecutor.shutdown();
        try {
            if (!aiExecutor.awaitTermination(5, TimeUnit.SECONDS)) {
                aiExecutor.shutdownNow();
            }
        } catch (InterruptedException e) {
            aiExecutor.shutdownNow();
        }
        super.destroy();
    }
}

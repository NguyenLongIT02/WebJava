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

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@WebServlet("/chatbot")
public class ChatbotServlet extends HttpServlet {

    // Groq API Key
    // Lấy key tại: https://console.groq.com/keys
    private static final String API_KEY = "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";
    private static final String API_URL = "https://api.groq.com/openai/v1/chat/completions";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain; charset=UTF-8");

        String msg = request.getParameter("message");
        String reply = "Xin lỗi, tôi chưa hiểu câu hỏi.";

        if (msg != null && !msg.trim().isEmpty()) {
            System.out.println("📩 Chatbot nhận tin nhắn: " + msg);

            // 1. Ưu tiên gọi Groq AI trước
            String aiReply = callGroqAI(msg);

            if (aiReply != null && !aiReply.isEmpty()) {
                System.out.println("✅ AI trả lời: " + aiReply);
                reply = aiReply;
            } else {
                // 2. Fallback về rule-based nếu AI lỗi hoặc không có key
                System.out.println("⚠️ AI không phản hồi, chuyển sang rule-based");
                reply = getRuleBasedReply(msg.toLowerCase().trim());
            }
        }

        response.getWriter().write(reply);
    }

    private String callGroqAI(String text) {
        if (API_KEY.equals("YOUR_GROQ_API_KEY") || API_KEY.isEmpty()) {
            System.err.println("Groq API Key chưa được cấu hình.");
            return null;
        }

        try {
            URL url = new URL(API_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("Authorization", "Bearer " + API_KEY);
            conn.setDoOutput(true);

            // Cấu trúc JSON cho Groq (OpenAI compatible)
            ObjectMapper mapper = new ObjectMapper();

            // Tạo request body bằng Jackson Node
            com.fasterxml.jackson.databind.node.ObjectNode rootNode = mapper.createObjectNode();
            rootNode.put("model", "llama-3.3-70b-versatile");

            com.fasterxml.jackson.databind.node.ArrayNode messagesArray = mapper.createArrayNode();

            com.fasterxml.jackson.databind.node.ObjectNode systemMessage = mapper.createObjectNode();
            systemMessage.put("role", "system");
            systemMessage.put("content",
                    "Bạn là một trợ lý ảo của cửa hàng Fruitables, chuyên bán rau củ quả sạch. Hãy trả lời ngắn gọn, thân thiện và hữu ích bằng tiếng Việt.");
            messagesArray.add(systemMessage);

            com.fasterxml.jackson.databind.node.ObjectNode userMessage = mapper.createObjectNode();
            userMessage.put("role", "user");
            userMessage.put("content", text);
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

                    // Parse JSON response
                    JsonNode responseNode = mapper.readTree(response.toString());
                    return responseNode.path("choices").get(0).path("message").path("content").asText();
                }
            } else {
                System.err.println("Groq API Error Code: " + code);
                try (BufferedReader br = new BufferedReader(
                        new InputStreamReader(conn.getErrorStream(), StandardCharsets.UTF_8))) {
                    StringBuilder response = new StringBuilder();
                    String responseLine;
                    while ((responseLine = br.readLine()) != null) {
                        response.append(responseLine.trim());
                    }
                    System.err.println("Error Body: " + response.toString());
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private String getRuleBasedReply(String msg) {
        if (msg.contains("rau")) {
            return "Chúng tôi có nhiều loại rau tươi: rau muống, cải xanh, xà lách...";
        } else if (msg.contains("củ")) {
            return "Các loại củ quả sạch gồm: cà rốt, khoai tây, khoai lang...";
        } else if (msg.contains("hoa quả") || msg.contains("trái cây")) {
            return "Hoa quả tươi theo mùa: cam, táo, nho, dưa hấu...";
        } else if (msg.contains("giá") || msg.contains("bao nhiêu")) {
            return "Giá sản phẩm dao động từ 20.000đ - 50.000đ/kg tuỳ loại.";
        } else if (msg.contains("ship") || msg.contains("giao hàng")) {
            return "Chúng tôi giao hàng trong nội thành Hà Nội trong vòng 2h.";
        } else if (msg.contains("thanh toán")) {
            return "Bạn có thể thanh toán bằng tiền mặt, thẻ hoặc ví điện tử.";
        } else if (msg.contains("khuyến mãi") || msg.contains("giảm giá")) {
            return "Hiện có chương trình giảm giá 10% cho đơn hàng trên 200k.";
        } else if (msg.contains("giờ mở cửa") || msg.contains("hoạt động")) {
            return "Cửa hàng mở cửa từ 7h sáng đến 9h tối mỗi ngày.";
        } else if (msg.contains("công thức") || msg.contains("nấu ăn")) {
            return "Bạn muốn nấu món gì? Ví dụ: Rau muống xào tỏi, canh cải xanh...";
        } else if (msg.contains("cam kết") || msg.contains("an toàn")) {
            return "Sản phẩm đều là rau củ quả sạch, có chứng nhận VietGAP.";
        } else if (msg.contains("liên hệ") || msg.contains("tư vấn")
                || msg.contains("số điện thoại") || msg.contains("địa chỉ")) {
            return "Bạn có thể liên hệ với chúng tôi qua:\n" +
                    "- 📞 Hotline: 0988 123 456\n" +
                    "- 🏪 Địa chỉ: Số 5 Văn Trì, Hà Nội\n" +
                    "- 🌐 Fanpage: fb.com/raucuquasach";
        }
        return "Xin lỗi, tôi chưa hiểu câu hỏi. Bạn có thể hỏi về sản phẩm, giá cả, hoặc giao hàng.";
    }
}

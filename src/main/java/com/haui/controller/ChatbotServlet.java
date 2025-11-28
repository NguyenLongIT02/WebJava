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

    // Replace with your Gemini API key (leave empty or start with YOUR_ to use
    // fallback)
    private static final String API_KEY = "YOUR_API_KEY_HERE";
    private static final String API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key="
            + API_KEY;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain; charset=UTF-8");

        String msg = request.getParameter("message");
        String reply = "Xin lỗi, tôi chưa hiểu câu hỏi.";

        if (msg != null && !msg.trim().isEmpty()) {
            // Try AI first
            String aiReply = callGeminiAI(msg);
            if (aiReply != null && !aiReply.isEmpty()) {
                reply = aiReply;
            } else {
                // Fallback to rule‑based answers
                reply = getRuleBasedReply(msg.toLowerCase().trim());
            }
        }
        response.getWriter().write(reply);
    }

    /** Call Gemini API, return answer or null if not usable */
    private String callGeminiAI(String text) {
        // If API key not configured, skip AI call
        if (API_KEY == null || API_KEY.isEmpty() || API_KEY.startsWith("YOUR_")) {
            return null;
        }
        try {
            URL url = new URL(API_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);

            String json = "{\"contents\":[{\"parts\":[{\"text\": \"" + escapeJson(text) + "\"}]}}";
            try (OutputStream os = conn.getOutputStream()) {
                os.write(json.getBytes(StandardCharsets.UTF_8));
            }

            int code = conn.getResponseCode();
            if (code == 200) {
                try (BufferedReader br = new BufferedReader(
                        new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                    StringBuilder sb = new StringBuilder();
                    String line;
                    while ((line = br.readLine()) != null) {
                        sb.append(line.trim());
                    }
                    ObjectMapper mapper = new ObjectMapper();
                    JsonNode root = mapper.readTree(sb.toString());
                    return root.path("candidates").get(0).path("content").path("parts").get(0).path("text").asText();
                }
            } else {
                System.err.println("AI API error code: " + code);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /** Simple JSON escaping */
    private String escapeJson(String txt) {
        return txt.replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }

    /** Rule‑based fallback answers */
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

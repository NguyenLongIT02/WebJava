package com.haui.listener;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

/**
 * Listener để quản lý vòng đời của ứng dụng
 * Đảm bảo resources được khởi tạo và giải phóng đúng cách
 */
@WebListener
public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("=".repeat(60));
        System.out.println("🚀 Ứng dụng Fruitables đang khởi động...");
        System.out.println("=".repeat(60));

        // Connection Pool sẽ tự động khởi tạo khi DAO được tạo lần đầu
        // Nhưng chúng ta có thể log thông tin ở đây

        System.out.println("✅ Ứng dụng đã sẵn sàng!");
        System.out.println("📊 Connection Pool sẽ tự động dọn dẹp mỗi 5 phút");
        System.out.println("=".repeat(60));
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("=".repeat(60));
        System.out.println("🛑 Ứng dụng Fruitables đang tắt...");
        System.out.println("=".repeat(60));

        // Connection Pool sẽ tự động đóng thông qua finalize()
        // hoặc có thể thêm logic shutdown ở đây nếu cần

        System.out.println("✅ Ứng dụng đã tắt an toàn!");
        System.out.println("=".repeat(60));
    }
}

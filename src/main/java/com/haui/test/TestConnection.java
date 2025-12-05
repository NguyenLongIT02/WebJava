package com.haui.test;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class TestConnection {
    public static void main(String[] args) {
        String driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
        String url = "jdbc:sqlserver://LAPTOP-7A6K0SSP\\SQLEXPRESS:1433;"
                + "databaseName=Fruitables;"
                + "encrypt=true;trustServerCertificate=true;"
                + "loginTimeout=30;";
        String username = "sa";
        String password = "12345";

        System.out.println("=== BẮT ĐẦU TEST KẾT NỐI DATABASE ===");

        // Test 1: Nạp driver
        try {
            Class.forName(driver);
            System.out.println("✓ Driver SQL Server đã được nạp thành công!");
        } catch (ClassNotFoundException e) {
            System.err.println("✗ KHÔNG TÌM THẤY DRIVER SQL SERVER!");
            e.printStackTrace();
            return;
        }

        // Test 2: Kết nối database
        Connection con = null;
        try {
            System.out.println("\nĐang thử kết nối tới database...");
            System.out.println("URL: " + url);
            System.out.println("Username: " + username);

            con = DriverManager.getConnection(url, username, password);
            System.out.println("✓ KẾT NỐI DATABASE THÀNH CÔNG!");

            // Test 3: Thực hiện query
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) as total FROM Product");

            if (rs.next()) {
                int count = rs.getInt("total");
                System.out.println("✓ Đã truy vấn thành công! Số lượng sản phẩm: " + count);
            }

            rs.close();
            stmt.close();

        } catch (Exception e) {
            System.err.println("✗ LỖI KẾT NỐI DATABASE!");
            System.err.println("Chi tiết lỗi: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (con != null && !con.isClosed()) {
                    con.close();
                    System.out.println("\n✓ Đã đóng connection.");
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        System.out.println("\n=== KẾT THÚC TEST ===");
    }
}

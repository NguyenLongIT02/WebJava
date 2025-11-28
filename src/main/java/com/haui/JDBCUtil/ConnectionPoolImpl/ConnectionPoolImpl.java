package com.haui.JDBCUtil.ConnectionPoolImpl;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Stack;
import com.haui.JDBCUtil.ConnectionPool;

public class ConnectionPoolImpl implements ConnectionPool {
    private String driver;
    private String url;
    private String username;
    private String userpass;
    private Stack<Connection> pool;
    private final int MAX_POOL_SIZE = 10;

    public ConnectionPoolImpl() {
        // Nạp driver SQL Server
        this.driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
        try {
            Class.forName(this.driver);
        } catch (ClassNotFoundException e) {
            System.err.println("Không tìm thấy driver SQL Server!");
            e.printStackTrace();
        }

  
        this.url = "jdbc:sqlserver://LAPTOP-7A6K0SSP\\SQLEXPRESS:1433;"
                 + "databaseName=Fruitables;"
                 + "encrypt=true;trustServerCertificate=true;"
                 + "loginTimeout=30;";

        this.username = "sa";
        this.userpass = "12345";

        this.pool = new Stack<>();
    }

    @Override
    public synchronized Connection getConnection(String objectName) throws SQLException {
        Connection con = null;

        // Nếu pool trống thì tạo mới
        if (pool.isEmpty()) {
            con = createNewConnection(objectName);
        } else {
            // Lấy ra connection có sẵn
            con = pool.pop();
            // Kiểm tra connection còn dùng được không
            if (con == null || con.isClosed() || !con.isValid(3)) {
                System.out.println(objectName + " lấy connection cũ bị lỗi → tạo mới");
                con = createNewConnection(objectName);
            } else {
                System.out.println(objectName + " tái sử dụng connection từ pool");
            }
        }

        return con;
    }

    @Override
    public synchronized void releaseConnection(Connection con, String objectName) throws SQLException {
        if (con != null && !con.isClosed()) {
            if (pool.size() < MAX_POOL_SIZE) {
                pool.push(con);
                System.out.println(objectName + " trả connection về pool (hiện có: " + pool.size() + ")");
            } else {
                con.close(); // nếu pool đã đầy thì đóng bớt
                System.out.println(objectName + " pool đầy → đóng connection thừa");
            }
        }
    }

    private Connection createNewConnection(String objectName) throws SQLException {
        System.out.println(objectName + " tạo connection MỚI");
        return DriverManager.getConnection(url, username, userpass);
    }

    @Override
    protected void finalize() throws Throwable {
        // Đóng toàn bộ connection khi ứng dụng kết thúc
        for (Connection con : pool) {
            if (con != null && !con.isClosed()) con.close();
        }
        pool.clear();
        System.out.println("Đã đóng toàn bộ connection trong pool.");
    }
}

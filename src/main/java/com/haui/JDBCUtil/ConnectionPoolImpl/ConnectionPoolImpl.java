package com.haui.JDBCUtil.ConnectionPoolImpl;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Stack;
import java.util.Timer;
import java.util.TimerTask;
import com.haui.JDBCUtil.ConnectionPool;

public class ConnectionPoolImpl implements ConnectionPool {
    private String driver;
    private String url;
    private String username;
    private String userpass;
    private Stack<Connection> pool;
    private final int MAX_POOL_SIZE = 10;
    private final int MIN_POOL_SIZE = 2; // Luôn giữ tối thiểu 2 connection
    private final int CONNECTION_TIMEOUT = 5; // Timeout khi validate (giây)
    private final long CLEANUP_INTERVAL = 5 * 60 * 1000; // Dọn dẹp mỗi 5 phút
    private Timer cleanupTimer;

    public ConnectionPoolImpl() {
        // Nạp driver SQL Server
        this.driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
        try {
            Class.forName(this.driver);
        } catch (ClassNotFoundException e) {
            System.err.println("Không tìm thấy driver SQL Server!");
            e.printStackTrace();
        }

        // Cấu hình URL với các tham số chống timeout
        this.url = "jdbc:sqlserver://LAPTOP-7A6K0SSP\\SQLEXPRESS:1433;"
                + "databaseName=Fruitables;"
                + "encrypt=true;trustServerCertificate=true;"
                + "loginTimeout=30;"
                + "socketTimeout=0;" // Không timeout khi đọc dữ liệu
                + "connectRetryCount=3;" // Thử kết nối lại 3 lần
                + "connectRetryInterval=10;"; // Mỗi lần cách nhau 10 giây

        this.username = "sa";
        this.userpass = "12345";

        this.pool = new Stack<>();

        // Khởi tạo sẵn MIN_POOL_SIZE connections
        initializePool();

        // Bắt đầu background task dọn dẹp connection
        startCleanupTask();
    }

    /**
     * Khởi tạo sẵn một số connection trong pool
     */
    private void initializePool() {
        System.out.println("🔧 Đang khởi tạo Connection Pool...");
        for (int i = 0; i < MIN_POOL_SIZE; i++) {
            try {
                Connection con = DriverManager.getConnection(url, username, userpass);
                pool.push(con);
                System.out.println("✓ Đã tạo connection " + (i + 1) + "/" + MIN_POOL_SIZE);
            } catch (SQLException e) {
                System.err.println("✗ Lỗi khi khởi tạo connection: " + e.getMessage());
            }
        }
        System.out.println("✅ Connection Pool đã sẵn sàng với " + pool.size() + " connections");
    }

    /**
     * Bắt đầu background task để dọn dẹp và làm mới connection định kỳ
     */
    private void startCleanupTask() {
        cleanupTimer = new Timer("ConnectionPoolCleaner", true);
        cleanupTimer.scheduleAtFixedRate(new TimerTask() {
            @Override
            public void run() {
                cleanupPool();
            }
        }, CLEANUP_INTERVAL, CLEANUP_INTERVAL);
        System.out.println("🧹 Connection Pool Cleaner đã được kích hoạt (chạy mỗi 5 phút)");
    }

    /**
     * Dọn dẹp các connection không hợp lệ và đảm bảo pool luôn có MIN_POOL_SIZE
     */
    private synchronized void cleanupPool() {
        System.out.println("🧹 Bắt đầu dọn dẹp Connection Pool...");
        Stack<Connection> validConnections = new Stack<>();
        int removedCount = 0;

        // Kiểm tra từng connection
        while (!pool.isEmpty()) {
            Connection con = pool.pop();
            if (isConnectionValid(con)) {
                validConnections.push(con);
            } else {
                closeQuietly(con);
                removedCount++;
            }
        }

        // Đưa các connection hợp lệ trở lại pool
        pool = validConnections;

        if (removedCount > 0) {
            System.out.println("🗑️ Đã loại bỏ " + removedCount + " connection không hợp lệ");
        }

        // Đảm bảo pool luôn có đủ MIN_POOL_SIZE connections
        while (pool.size() < MIN_POOL_SIZE) {
            try {
                Connection newCon = DriverManager.getConnection(url, username, userpass);
                pool.push(newCon);
                System.out.println("➕ Đã thêm connection mới vào pool");
            } catch (SQLException e) {
                System.err.println("⚠️ Không thể tạo connection mới: " + e.getMessage());
                break;
            }
        }

        System.out.println("✅ Dọn dẹp hoàn tất. Pool hiện có: " + pool.size() + " connections");
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
            if (!isConnectionValid(con)) {
                System.out.println("⚠️ " + objectName + " - Connection cũ không hợp lệ → tạo mới");
                closeQuietly(con); // Đóng connection cũ
                con = createNewConnection(objectName);
            } else {
                System.out.println("♻️ " + objectName + " - Tái sử dụng connection từ pool");
            }
        }

        return con;
    }

    @Override
    public synchronized void releaseConnection(Connection con, String objectName) throws SQLException {
        if (con == null) {
            return;
        }

        // Kiểm tra connection trước khi trả về pool
        if (!isConnectionValid(con)) {
            System.out.println("⚠️ " + objectName + " - Connection không hợp lệ, không trả về pool");
            closeQuietly(con);
            return;
        }

        // Reset trạng thái connection
        try {
            if (!con.getAutoCommit()) {
                con.rollback(); // Rollback các transaction chưa commit
            }
            con.setAutoCommit(true); // Reset về auto-commit
        } catch (SQLException e) {
            System.err.println("⚠️ Lỗi khi reset connection: " + e.getMessage());
            closeQuietly(con);
            return;
        }

        // Trả về pool nếu chưa đầy
        if (pool.size() < MAX_POOL_SIZE) {
            pool.push(con);
            System.out.println("✓ " + objectName + " - Trả connection về pool (hiện có: " + pool.size() + ")");
        } else {
            closeQuietly(con);
            System.out.println("⚠️ " + objectName + " - Pool đầy → đóng connection thừa");
        }
    }

    /**
     * Kiểm tra connection có hợp lệ không
     */
    private boolean isConnectionValid(Connection con) {
        if (con == null) {
            return false;
        }

        try {
            // Kiểm tra connection chưa đóng và còn hoạt động
            return !con.isClosed() && con.isValid(CONNECTION_TIMEOUT);
        } catch (SQLException e) {
            return false;
        }
    }

    /**
     * Đóng connection một cách an toàn (không throw exception)
     */
    private void closeQuietly(Connection con) {
        if (con != null) {
            try {
                if (!con.isClosed()) {
                    con.close();
                }
            } catch (SQLException e) {
                // Bỏ qua lỗi khi đóng
            }
        }
    }

    private Connection createNewConnection(String objectName) throws SQLException {
        System.out.println("🆕 " + objectName + " - Tạo connection MỚI");
        return DriverManager.getConnection(url, username, userpass);
    }

    /**
     * Dừng cleanup task và đóng pool
     */
    public void shutdown() {
        if (cleanupTimer != null) {
            cleanupTimer.cancel();
            System.out.println("🛑 Connection Pool Cleaner đã dừng");
        }

        // Đóng toàn bộ connection
        System.out.println("🔒 Đang đóng Connection Pool...");
        for (Connection con : pool) {
            closeQuietly(con);
        }
        pool.clear();
        System.out.println("✅ Đã đóng toàn bộ connection trong pool.");
    }

    @Override
    protected void finalize() throws Throwable {
        shutdown();
    }
}

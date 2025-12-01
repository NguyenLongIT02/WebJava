package com.haui.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.haui.JDBCUtil.ConnectionPool;
import com.haui.JDBCUtil.ConnectionPoolImpl.ConnectionPoolImpl;
import com.haui.dao.OrderDao;
import com.haui.dto.ProductStat;

public class OrderDaoImpl implements OrderDao {
    private Connection con;
    private ConnectionPool pool;

    public OrderDaoImpl() {
        this.pool = new ConnectionPoolImpl();
        try {
            this.con = pool.getConnection("OrderDaoImpl");
            if (this.con.getAutoCommit()) {
                this.con.setAutoCommit(false);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Map<Integer, Double> getRevenueByMonth() {
        Map<Integer, Double> revenueMap = new HashMap<>();
        // Initialize all months to 0
        for (int i = 1; i <= 12; i++) {
            revenueMap.put(i, 0.0);
        }

        String sql = "SELECT MONTH(c.buyDate) as month, SUM(ci.quantity * ci.unitPrice) as total " +
                "FROM Cart c " +
                "JOIN CartItem ci ON c.id = ci.cat_id " +
                "WHERE c.status != 0 " +
                "GROUP BY MONTH(c.buyDate)";

        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int month = rs.getInt("month");
                double total = rs.getDouble("total");
                revenueMap.put(month, total);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return revenueMap;
    }

    @Override
    public List<ProductStat> getTopSellingProducts(int limit) {
        List<ProductStat> list = new ArrayList<>();
        String sql = "SELECT TOP (?) p.name, SUM(ci.quantity) as totalSold " +
                "FROM CartItem ci " +
                "JOIN Product p ON ci.pro_id = p.id " +
                "JOIN Cart c ON c.id = ci.cat_id " +
                "GROUP BY p.name " +
                "ORDER BY totalSold DESC";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new ProductStat(rs.getString("name"), rs.getInt("totalSold")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<com.haui.dto.CartDetails> getRecentOrders(int limit) {
        List<com.haui.dto.CartDetails> list = new ArrayList<>();
        String sql = "SELECT TOP (?) c.id AS id, u.username AS buyer, u.email AS email, " +
                "SUM(ci.quantity * ci.unitPrice) AS sumToTal, c.buyDate AS orderDate, c.status " +
                "FROM Cart c " +
                "JOIN [User] u ON c.u_id = u.id " +
                "JOIN CartItem ci ON c.id = ci.cat_id " +
                "GROUP BY c.id, u.username, u.email, c.buyDate, c.status " +
                "ORDER BY c.buyDate DESC";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                com.haui.dto.CartDetails details = new com.haui.dto.CartDetails();
                details.setId(rs.getString("id"));
                details.setBuyer(rs.getString("buyer"));
                details.setEmail(rs.getString("email"));
                details.setSumToTal(rs.getLong("sumToTal"));
                details.setOrderDate(rs.getDate("orderDate"));
                details.setStatus(rs.getInt("status"));
                list.add(details);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<ProductStat> getTopCustomers(int limit) {
        List<ProductStat> list = new ArrayList<>();
        String sql = "SELECT TOP (?) u.username, COUNT(c.id) as orderCount " +
                "FROM [User] u " +
                "JOIN Cart c ON u.id = c.u_id " +
                "GROUP BY u.username " +
                "ORDER BY orderCount DESC";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new ProductStat(rs.getString("username"), rs.getInt("orderCount")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<com.haui.entity.User> getRecentCustomers(int limit) {
        List<com.haui.entity.User> list = new ArrayList<>();
        String sql = "SELECT TOP (?) * FROM [User] ORDER BY id DESC";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                com.haui.entity.User user = new com.haui.entity.User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                list.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public int getTotalOrders() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Cart";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    @Override
    public int getTotalCustomers() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM [User] WHERE isAdmin = 0";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    @Override
    public Map<String, Double> getWeeklyRevenue() {
        Map<String, Double> map = new HashMap<>();
        // Use the latest date in the database as the anchor, so charts work with any
        // data range
        String sql = "DECLARE @MaxDate DATE = (SELECT MAX(buyDate) FROM Cart WHERE status != 0); " +
                "SELECT FORMAT(c.buyDate, 'yyyy-MM-dd') as date, SUM(ci.quantity * ci.unitPrice) as total " +
                "FROM Cart c " +
                "JOIN CartItem ci ON c.id = ci.cat_id " +
                "WHERE c.buyDate >= DATEADD(day, -6, @MaxDate) " +
                "AND c.buyDate <= @MaxDate " +
                "AND c.status != 0 " +
                "GROUP BY c.buyDate";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                map.put(rs.getString("date"), rs.getDouble("total"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return map;
    }

    @Override
    public int getTotalProductViews() {
        int count = 0;
        String sql = "SELECT SUM(view_count) FROM Product";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    @Override
    public double getAverageRating() {
        double rating = 0;
        String sql = "SELECT AVG(CAST(rating AS FLOAT)) FROM Reviews";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                rating = rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rating > 0 ? rating : 5.0;
    }

    @Override
    public double getGrossProfit() {
        double profit = 0;
        // Calculate profit: (Selling Price - Import Price) * Quantity
        // Only for orders that are NOT cancelled (status != 0)
        String sql = "SELECT SUM((ci.unitPrice - p.import_price) * ci.quantity) " +
                "FROM CartItem ci " +
                "JOIN Product p ON ci.pro_id = p.id " +
                "JOIN Cart c ON ci.cat_id = c.id " +
                "WHERE c.status != 0";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                profit = rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return profit;
    }

    @Override
    public double getInventoryValue() {
        double totalValue = 0;
        String sql = "SELECT SUM(quantity * import_price) FROM Product";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                totalValue = rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return totalValue;
    }

    @Override
    public double getCancellationRate() {
        double rate = 0;
        String sqlTotal = "SELECT COUNT(*) FROM Cart";
        String sqlCancel = "SELECT COUNT(*) FROM Cart WHERE status = 0";

        try {
            int total = 0;
            int cancelled = 0;

            PreparedStatement psTotal = con.prepareStatement(sqlTotal);
            ResultSet rsTotal = psTotal.executeQuery();
            if (rsTotal.next())
                total = rsTotal.getInt(1);

            if (total == 0)
                return 0;

            PreparedStatement psCancel = con.prepareStatement(sqlCancel);
            ResultSet rsCancel = psCancel.executeQuery();
            if (rsCancel.next())
                cancelled = rsCancel.getInt(1);

            rate = ((double) cancelled / total) * 100;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Math.round(rate * 100.0) / 100.0;
    }

    @Override
    public void updateStatus(String id, int status) {
        String sql = "UPDATE Cart SET status = ? WHERE id = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, status);
            ps.setString(2, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void delete(String id) {
        // Delete items first due to FK constraint
        String sqlItems = "DELETE FROM CartItem WHERE cat_id = ?";
        String sqlCart = "DELETE FROM Cart WHERE id = ?";
        try {
            con.setAutoCommit(false); // Transaction

            PreparedStatement psItems = con.prepareStatement(sqlItems);
            psItems.setString(1, id);
            psItems.executeUpdate();

            PreparedStatement psCart = con.prepareStatement(sqlCart);
            psCart.setString(1, id);
            psCart.executeUpdate();

            con.commit();
        } catch (SQLException e) {
            try {
                con.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                con.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}

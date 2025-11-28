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
                "SUM(ci.quantity * ci.unitPrice) AS sumToTal, c.buyDate AS orderDate " +
                "FROM Cart c " +
                "JOIN [User] u ON c.u_id = u.id " +
                "JOIN CartItem ci ON c.id = ci.cat_id " +
                "GROUP BY c.id, u.username, u.email, c.buyDate " +
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
                list.add(details);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<ProductStat> getTopCustomers(int limit) {
        // Reusing ProductStat for Customer Stat (Name = Username, TotalSold =
        // TotalMoney)
        // Or create a new DTO. For simplicity, let's use ProductStat but treat
        // totalSold as int (maybe not ideal for money)
        // Let's create a new DTO or just map to Map<String, Double> or similar.
        // Actually ProductStat has int totalSold.
        // Let's just return List<ProductStat> where name is username and totalSold is
        // number of orders for now?
        // Or better: Create a simple inner class or just use ProductStat for "Top
        // Buying Customers" by Order Count.
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
        String sql = "SELECT TOP (?) * FROM [User] ORDER BY id DESC"; // Assuming id is auto inc or there is created_at.
                                                                      // User entity check needed.
        // Let's check User entity. If no date, use ID DESC.
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                com.haui.entity.User user = new com.haui.entity.User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                // Set other fields if needed
                list.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}

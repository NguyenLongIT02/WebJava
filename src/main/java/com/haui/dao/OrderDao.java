package com.haui.dao;

import java.util.List;
import java.util.Map;
import com.haui.dto.ProductStat;

public interface OrderDao {
    Map<Integer, Double> getRevenueByMonth();

    List<ProductStat> getTopSellingProducts(int limit);

    List<com.haui.dto.CartDetails> getRecentOrders(int limit);

    List<com.haui.dto.ProductStat> getTopCustomers(int limit);

    List<com.haui.entity.User> getRecentCustomers(int limit);
}

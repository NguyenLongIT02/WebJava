package com.haui.dto;

public class ProductStat {
    private String name;
    private int totalSold;

    public ProductStat(String name, int totalSold) {
        this.name = name;
        this.totalSold = totalSold;
    }

    public String getName() {
        return name;
    }

    public int getTotalSold() {
        return totalSold;
    }
}

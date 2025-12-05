package com.haui.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.haui.JDBCUtil.ConnectionPool;
import com.haui.JDBCUtil.ConnectionPoolImpl.ConnectionPoolImpl;
import com.haui.dao.CategoryDao;
import com.haui.entity.Category;

public class CategoryDaoImpl implements CategoryDao {

	private ConnectionPool pool;

	public CategoryDaoImpl() {
		// Xác định bộ quản lý kết nối
		this.pool = new ConnectionPoolImpl();
	}

	// Lấy connection mới cho mỗi operation
	private Connection getConnection() throws SQLException {
		Connection con = pool.getConnection("CategoryDaoImpl");
		if (con != null && con.getAutoCommit()) {
			con.setAutoCommit(false);
		}
		return con;
	}

	// Trả connection về pool
	private void releaseConnection(Connection con) {
		if (con != null) {
			try {
				pool.releaseConnection(con, "CategoryDaoImpl");
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

	@Override
	public void insert(Category category) {
		Connection con = null;
		String sql = "INSERT INTO category(cate_name) VALUES (?)";
		try {
			con = getConnection();
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setString(1, category.getName());
			ps.executeUpdate();
			con.commit();
		} catch (SQLException e) {
			e.printStackTrace();
			try {
				if (con != null)
					con.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
		} finally {
			releaseConnection(con);
		}

	}

	@Override
	public void edit(Category category) {
		Connection con = null;
		String sql = "UPDATE category SET cate_name = ? WHERE cate_id = ?";
		try {
			con = getConnection();
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setString(1, category.getName());
			ps.setInt(2, category.getId());
			ps.executeUpdate();
			con.commit();
		} catch (SQLException e) {
			e.printStackTrace();
			try {
				if (con != null)
					con.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
		} finally {
			releaseConnection(con);
		}

	}

	@Override
	public void delete(int id) {
		Connection con = null;
		String sql = "DELETE FROM category WHERE cate_id = ?";

		try {
			con = getConnection();
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setInt(1, id);
			ps.executeUpdate();
			con.commit();
		} catch (SQLException e) {
			e.printStackTrace();
			try {
				if (con != null)
					con.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
		} finally {
			releaseConnection(con);
		}
	}

	@Override
	public Category get(int id) {
		Connection con = null;
		String sql = "SELECT * FROM category WHERE cate_id = ? ";
		try {
			con = getConnection();
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setInt(1, id);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				Category category = new Category();

				category.setId(rs.getInt("cate_id"));
				category.setName(rs.getString("cate_name"));

				return category;

			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			releaseConnection(con);
		}
		return null;
	}

	@Override
	public Category get(String name) {
		Connection con = null;
		String sql = "SELECT * FROM Category WHERE cate_name = ? ";
		try {
			con = getConnection();
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setString(1, name);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				Category category = new Category();

				category.setId(rs.getInt("cate_id"));
				category.setName(rs.getString("cate_name"));

				return category;

			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			releaseConnection(con);
		}
		return null;
	}

	@Override
	public List<Category> getAll() {
		Connection con = null;
		List<Category> categories = new ArrayList<Category>();
		String sql = "SELECT * FROM Category";
		try {
			con = getConnection();
			PreparedStatement ps = con.prepareStatement(sql);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				Category category = new Category();

				category.setId(rs.getInt("cate_id"));
				category.setName(rs.getString("cate_name"));

				categories.add(category);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			releaseConnection(con);
		}

		return categories;
	}

	@Override
	public List<Category> search(String username) {
		Connection con = null;
		List<Category> categories = new ArrayList<Category>();
		String sql = "SELECT * FROM category WHERE name LIKE ? ";
		try {
			con = getConnection();
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setString(1, "%" + username + "%");
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				Category category = new Category();

				category.setId(rs.getInt("id"));
				category.setName(rs.getString("name"));

				categories.add(category);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			releaseConnection(con);
		}

		return categories;
	}
}

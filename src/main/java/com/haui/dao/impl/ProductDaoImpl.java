package com.haui.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.haui.JDBCUtil.ConnectionPool;
import com.haui.JDBCUtil.ConnectionPoolImpl.ConnectionPoolImpl;
import com.haui.dao.ProductDao;
import com.haui.entity.Category;
import com.haui.entity.Product;
import com.haui.service.CategoryService;
import com.haui.service.Impl.CategoryServiceImpl;

public class ProductDaoImpl implements ProductDao {

	private ConnectionPool pool;
	CategoryService categoryService = new CategoryServiceImpl();

	public ProductDaoImpl() {
		// Xác định bộ quản lý kết nối
		this.pool = new ConnectionPoolImpl();
	}

	// Lấy connection mới cho mỗi operation
	private Connection getConnection() throws SQLException {
		Connection con = pool.getConnection("ProductDaoImpl");
		if (con != null && con.getAutoCommit()) {
			con.setAutoCommit(false);
		}
		return con;
	}

	// Trả connection về pool
	private void releaseConnection(Connection con) {
		if (con != null) {
			try {
				pool.releaseConnection(con, "ProductDaoImpl");
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

	@Override
	public void insert(Product product) {
		Connection con = null;
		String sql = "INSERT INTO Product(name, price, image, cate_id, des, quantity) VALUES (?,?,?,?,?,?)";
		try {
			con = getConnection();
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setString(1, product.getName());
			ps.setLong(2, product.getPrice());
			ps.setString(3, product.getImage());
			ps.setInt(4, product.getCategory().getId());
			ps.setString(5, product.getDes());
			ps.setInt(6, product.getQuantity());
			ps.executeUpdate();
			con.commit();
		} catch (Exception e) {
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
	public void edit(Product product) {
		Connection con = null;
		String sql = "UPDATE Product SET name = ? , price = ?, image = ?,cate_id=?, des=?, quantity=?  WHERE id = ?";
		try {
			con = getConnection();
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setString(1, product.getName());
			ps.setDouble(2, product.getPrice());
			ps.setString(3, product.getImage());
			ps.setInt(4, product.getCategory().getId());
			ps.setString(5, product.getDes());
			ps.setInt(6, product.getQuantity());
			ps.setInt(7, product.getId());
			ps.executeUpdate();
			con.commit();
		} catch (Exception e) {
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
		String sql = "DELETE FROM Product WHERE id=?";
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
	public Product get(int id) {
		Connection con = null;
		String sql = "SELECT product.id, product.name AS p_name, product.price, product.image,product.des, product.quantity, category.cate_name AS c_name, "
				+ "category.cate_id AS c_id " + "FROM product INNER JOIN category "
				+ "ON product.cate_id = category.cate_id WHERE product.id=?";
		try {
			con = getConnection();
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setInt(1, id);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				Category category = categoryService.get(rs.getInt("c_id"));

				Product product = new Product();
				product.setId(rs.getInt("id"));
				product.setName(rs.getString("p_name"));
				product.setPrice(rs.getLong("price"));
				product.setImage(rs.getString("image"));
				product.setDes(rs.getString("des"));
				product.setQuantity(rs.getInt("quantity"));
				product.setCategory(category);

				return product;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			releaseConnection(con);
		}
		return null;
	}

	@Override
	public List<Product> getAll() {
		Connection con = null;
		List<Product> productList = new ArrayList<Product>();
		String sql = "SELECT product.id, product.name AS p_name, product.price, product.image, product.des, product.quantity,"
				+ " category.cate_name AS c_name, category.cate_id AS c_id  " + "FROM product INNER JOIN category "
				+ "ON product.cate_id = category.cate_id";
		try {
			con = getConnection();
			PreparedStatement ps = con.prepareStatement(sql);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				Category category = categoryService.get(rs.getInt("c_id"));
				Product product = new Product();
				product.setId(rs.getInt("id"));
				product.setName(rs.getString("p_name"));
				product.setPrice(rs.getLong("price"));
				product.setImage(rs.getString("image"));
				product.setDes(rs.getString("des"));
				product.setQuantity(rs.getInt("quantity"));
				product.setCategory(category);

				productList.add(product);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			releaseConnection(con);
		}

		return productList;
	}

	@Override
	public List<Product> search(String keyword) {
		Connection con = null;
		List<Product> productList = new ArrayList<Product>();
		String sql = "SELECT * FROM product WHERE name LIKE ? ";
		try {
			con = getConnection();
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setString(1, "%" + keyword + "%");
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				Product product = new Product();

				product.setId(rs.getInt("id"));
				product.setName(rs.getString("name"));
				product.setPrice(rs.getLong("price"));
				product.setImage(rs.getString("image"));
				product.setDes(rs.getString("des"));
				product.setQuantity(rs.getInt("quantity"));

				// Note: Category might be missing here if simple select *
				// But keeping original logic structure
				Category category = new Category();
				category.setId(rs.getInt("cate_id"));
				// category.setName(rs.getString("c_name")); // c_name not in simple select *
				// from product

				product.setCategory(category);

				productList.add(product);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			releaseConnection(con);
		}

		return productList;
	}

	@Override
	public List<Product> seachByCategory(int cate_id) {
		Connection con = null;
		List<Product> productList = new ArrayList<Product>();
		String sql = "SELECT product.id, product.name AS p_name, "
				+ "product.price, product.image, product.des, product.quantity, "
				+ "category.cate_name AS c_name, category.cate_id AS c_id "
				+ " FROM Product , Category where product.cate_id = category.cate_id " + "and Category.cate_id=?";

		try {
			con = getConnection();
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setInt(1, cate_id);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				Category category = categoryService.get(rs.getInt("c_id"));
				Product product = new Product();
				product.setId(rs.getInt("id"));
				product.setName(rs.getString("p_name"));
				product.setPrice(rs.getLong("price"));
				product.setImage(rs.getString("image"));
				product.setDes(rs.getString("des"));
				product.setQuantity(rs.getInt("quantity"));
				product.setCategory(category);

				productList.add(product);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			releaseConnection(con);
		}

		return productList;
	}

	@Override
	public List<Product> seachByName(String productName) {
		Connection con = null;
		List<Product> productList = new ArrayList<Product>();
		String sql = "SELECT product.id, product.name AS p_name, "
				+ "product.price, product.image, product.des, product.quantity, "
				+ "category.cate_name AS c_name, category.cate_id AS c_id " + " FROM Product , Category   "
				+ "where product.cate_id = category.cate_id and Product.name like ? ";

		try {
			con = getConnection();
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setString(1, "%" + productName + "%");
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				Category category = categoryService.get(rs.getInt("c_id"));
				Product product = new Product();
				product.setId(rs.getInt("id"));
				product.setName(rs.getString("p_name"));
				product.setPrice(rs.getLong("price"));
				product.setImage(rs.getString("image"));
				product.setDes(rs.getString("des"));
				product.setQuantity(rs.getInt("quantity"));
				product.setCategory(category);

				productList.add(product);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			releaseConnection(con);
		}

		return productList;
	}

	@Override
	public List<Product> getAllProducts(int pageNumber, int pageSize) {
		Connection con = null;
		List<Product> products = new ArrayList<Product>();
		String sql = "SELECT product.id, product.name AS p_name, product.price, product.image, product.des, product.quantity, "
				+
				"category.cate_name AS c_name, category.cate_id AS c_id " +
				"FROM product " +
				"INNER JOIN category ON product.cate_id = category.cate_id " +
				"ORDER BY product.id " +
				"OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
		try {
			con = getConnection();
			PreparedStatement ps = con.prepareStatement(sql);
			int offset = (pageNumber - 1) * pageSize;
			ps.setInt(1, offset);
			ps.setInt(2, pageSize);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				Category category = categoryService.get(rs.getInt("c_id"));
				Product product = new Product();
				product.setId(rs.getInt("id"));
				product.setName(rs.getString("p_name"));
				product.setPrice(rs.getLong("price"));
				product.setImage(rs.getString("image"));
				product.setDes(rs.getString("des"));
				product.setQuantity(rs.getInt("quantity"));
				product.setCategory(category);

				products.add(product);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			releaseConnection(con);
		}
		return products;
	}

	@Override
	public List<Product> seachByName(String productName, int pageNumber, int pageSize) {
		Connection con = null;
		List<Product> products = new ArrayList<>();
		String sql = "SELECT product.id, product.name AS p_name, product.price, product.image, product.des, product.quantity, "
				+
				"category.cate_name AS c_name, category.cate_id AS c_id " +
				"FROM product " +
				"INNER JOIN category ON product.cate_id = category.cate_id " +
				"WHERE product.name LIKE ? " +
				"ORDER BY product.id " +
				"OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

		try {
			con = getConnection();
			PreparedStatement ps = con.prepareStatement(sql);
			int offset = (pageNumber - 1) * pageSize;
			ps.setString(1, "%" + productName + "%");
			ps.setInt(2, offset);
			ps.setInt(3, pageSize);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				Category category = new Category(rs.getInt("c_id"), rs.getString("c_name"));
				Product product = new Product();
				product.setId(rs.getInt("id"));
				product.setName(rs.getString("p_name"));
				product.setPrice(rs.getLong("price"));
				product.setImage(rs.getString("image"));
				product.setDes(rs.getString("des"));
				product.setQuantity(rs.getInt("quantity"));
				product.setCategory(category);
				products.add(product);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			releaseConnection(con);
		}
		return products;
	}

	@Override
	public void updateViewCount(int id) {
		Connection con = null;
		String sql = "UPDATE Product SET view_count = view_count + 1 WHERE id = ?";
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
}

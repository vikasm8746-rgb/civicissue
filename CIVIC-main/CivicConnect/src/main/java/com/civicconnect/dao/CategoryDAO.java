package com.civicconnect.dao;

import com.civicconnect.model.Category;
import com.civicconnect.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for Category management.
 */
public class CategoryDAO {

    private static final Logger LOGGER = Logger.getLogger(CategoryDAO.class.getName());

    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT c.*, d.name AS department_name FROM categories c " +
                     "LEFT JOIN departments d ON c.department_id = d.id ORDER BY c.name ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapCategory(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching all categories", e);
        }
        return list;
    }

    public List<Category> getActiveCategories() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT c.*, d.name AS department_name FROM categories c " +
                     "LEFT JOIN departments d ON c.department_id = d.id " +
                     "WHERE c.status = 'ACTIVE' ORDER BY c.name ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapCategory(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching active categories", e);
        }
        return list;
    }

    public Category getCategoryById(int id) {
        String sql = "SELECT c.*, d.name AS department_name FROM categories c " +
                     "LEFT JOIN departments d ON c.department_id = d.id WHERE c.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapCategory(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching category by id: " + id, e);
        }
        return null;
    }

    public List<Category> getCategoriesByDepartment(int departmentId) {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT c.*, d.name AS department_name FROM categories c " +
                     "LEFT JOIN departments d ON c.department_id = d.id " +
                     "WHERE c.department_id = ? AND c.status = 'ACTIVE' ORDER BY c.name ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, departmentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapCategory(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching categories by department: " + departmentId, e);
        }
        return list;
    }

    public boolean addCategory(Category category) {
        String sql = "INSERT INTO categories (department_id, name, description, status) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            if (category.getDepartmentId() != null && category.getDepartmentId() > 0) {
                ps.setInt(1, category.getDepartmentId());
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setString(2, category.getName());
            ps.setString(3, category.getDescription());
            ps.setString(4, category.getStatus() != null ? category.getStatus() : "ACTIVE");

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        category.setId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding category: " + category.getName(), e);
        }
        return false;
    }

    public boolean updateCategory(Category category) {
        String sql = "UPDATE categories SET department_id = ?, name = ?, description = ?, status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (category.getDepartmentId() != null && category.getDepartmentId() > 0) {
                ps.setInt(1, category.getDepartmentId());
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setString(2, category.getName());
            ps.setString(3, category.getDescription());
            ps.setString(4, category.getStatus());
            ps.setInt(5, category.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating category: " + category.getId(), e);
        }
        return false;
    }

    public boolean deleteCategory(int id) {
        String sql = "DELETE FROM categories WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting category: " + id, e);
        }
        return false;
    }

    public int countCategories() {
        String sql = "SELECT COUNT(*) FROM categories";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting categories", e);
        }
        return 0;
    }

    private Category mapCategory(ResultSet rs) throws SQLException {
        Category c = new Category();
        c.setId(rs.getInt("id"));
        int deptId = rs.getInt("department_id");
        if (!rs.wasNull()) {
            c.setDepartmentId(deptId);
        }
        c.setDepartmentName(rs.getString("department_name"));
        c.setName(rs.getString("name"));
        c.setDescription(rs.getString("description"));
        c.setStatus(rs.getString("status"));
        c.setCreatedAt(rs.getTimestamp("created_at"));
        return c;
    }
}

package com.civicconnect.dao;

import com.civicconnect.model.Department;
import com.civicconnect.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for Department management.
 */
public class DepartmentDAO {

    private static final Logger LOGGER = Logger.getLogger(DepartmentDAO.class.getName());

    public List<Department> getAllDepartments() {
        List<Department> list = new ArrayList<>();
        String sql = "SELECT d.*, " +
                     "(SELECT COUNT(*) FROM users u WHERE u.department_id = d.id AND u.role = 'STAFF') AS total_staff, " +
                     "(SELECT COUNT(*) FROM complaints c WHERE c.department_id = d.id) AS total_complaints " +
                     "FROM departments d ORDER BY d.name ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Department d = new Department();
                d.setId(rs.getInt("id"));
                d.setName(rs.getString("name"));
                d.setDescription(rs.getString("description"));
                d.setStatus(rs.getString("status"));
                d.setCreatedAt(rs.getTimestamp("created_at"));
                d.setTotalStaff(rs.getInt("total_staff"));
                d.setTotalComplaints(rs.getInt("total_complaints"));
                list.add(d);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching all departments", e);
        }
        return list;
    }

    public List<Department> getActiveDepartments() {
        List<Department> list = new ArrayList<>();
        String sql = "SELECT * FROM departments WHERE status = 'ACTIVE' ORDER BY name ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Department d = new Department();
                d.setId(rs.getInt("id"));
                d.setName(rs.getString("name"));
                d.setDescription(rs.getString("description"));
                d.setStatus(rs.getString("status"));
                d.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(d);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching active departments", e);
        }
        return list;
    }

    public Department getDepartmentById(int id) {
        String sql = "SELECT * FROM departments WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Department d = new Department();
                    d.setId(rs.getInt("id"));
                    d.setName(rs.getString("name"));
                    d.setDescription(rs.getString("description"));
                    d.setStatus(rs.getString("status"));
                    d.setCreatedAt(rs.getTimestamp("created_at"));
                    return d;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching department by id: " + id, e);
        }
        return null;
    }

    public boolean addDepartment(Department dept) {
        String sql = "INSERT INTO departments (name, description, status) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, dept.getName());
            ps.setString(2, dept.getDescription());
            ps.setString(3, dept.getStatus() != null ? dept.getStatus() : "ACTIVE");

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        dept.setId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding department: " + dept.getName(), e);
        }
        return false;
    }

    public boolean updateDepartment(Department dept) {
        String sql = "UPDATE departments SET name = ?, description = ?, status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, dept.getName());
            ps.setString(2, dept.getDescription());
            ps.setString(3, dept.getStatus());
            ps.setInt(4, dept.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating department: " + dept.getId(), e);
        }
        return false;
    }

    public boolean deleteDepartment(int id) {
        String sql = "DELETE FROM departments WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting department: " + id, e);
        }
        return false;
    }

    public int countDepartments() {
        String sql = "SELECT COUNT(*) FROM departments";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting departments", e);
        }
        return 0;
    }
}

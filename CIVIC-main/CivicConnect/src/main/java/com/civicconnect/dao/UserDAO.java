package com.civicconnect.dao;

import com.civicconnect.model.User;
import com.civicconnect.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for User operations.
 */
public class UserDAO {

    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());

    public boolean register(User user) {
        String sql = "INSERT INTO users (full_name, email, phone, username, password, role, department_id, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getUsername());
            ps.setString(5, user.getPassword());
            ps.setString(6, user.getRole() != null ? user.getRole() : "CITIZEN");
            if (user.getDepartmentId() != null && user.getDepartmentId() > 0) {
                ps.setInt(7, user.getDepartmentId());
            } else {
                ps.setNull(7, Types.INTEGER);
            }
            ps.setString(8, user.getStatus() != null ? user.getStatus() : "ACTIVE");

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        user.setId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error registering user: " + user.getUsername(), e);
        }
        return false;
    }

    public User authenticate(String username, String hashedPassword) {
        String sql = "SELECT u.*, d.name AS department_name FROM users u " +
                     "LEFT JOIN departments d ON u.department_id = d.id " +
                     "WHERE (u.username = ? OR u.email = ?) AND u.password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, username);
            ps.setString(3, hashedPassword);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Authentication error for username: " + username, e);
        }
        return null;
    }

    public User getUserById(int id) {
        String sql = "SELECT u.*, d.name AS department_name FROM users u " +
                     "LEFT JOIN departments d ON u.department_id = d.id WHERE u.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching user by id: " + id, e);
        }
        return null;
    }

    public User getUserByUsername(String username) {
        String sql = "SELECT u.*, d.name AS department_name FROM users u " +
                     "LEFT JOIN departments d ON u.department_id = d.id WHERE u.username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching user by username: " + username, e);
        }
        return null;
    }

    public User getUserByEmail(String email) {
        String sql = "SELECT u.*, d.name AS department_name FROM users u " +
                     "LEFT JOIN departments d ON u.department_id = d.id WHERE u.email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching user by email: " + email, e);
        }
        return null;
    }

    public List<User> getAllUsersByRole(String role) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.*, d.name AS department_name FROM users u " +
                     "LEFT JOIN departments d ON u.department_id = d.id " +
                     "WHERE u.role = ? ORDER BY u.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, role);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapUser(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching users by role: " + role, e);
        }
        return list;
    }

    public List<User> getStaffByDepartment(int departmentId) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.*, d.name AS department_name FROM users u " +
                     "LEFT JOIN departments d ON u.department_id = d.id " +
                     "WHERE u.role = 'STAFF' AND u.department_id = ? AND u.status = 'ACTIVE' ORDER BY u.full_name ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, departmentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapUser(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching staff by department: " + departmentId, e);
        }
        return list;
    }

    public List<User> getAllStaff() {
        return getAllUsersByRole("STAFF");
    }

    public List<User> getAllCitizens() {
        return getAllUsersByRole("CITIZEN");
    }

    public boolean updateUser(User user) {
        String sql = "UPDATE users SET full_name = ?, email = ?, phone = ?, department_id = ?, status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            if (user.getDepartmentId() != null && user.getDepartmentId() > 0) {
                ps.setInt(4, user.getDepartmentId());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            ps.setString(5, user.getStatus());
            ps.setInt(6, user.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating user: " + user.getId(), e);
        }
        return false;
    }

    public boolean updatePassword(int userId, String newHashedPassword) {
        String sql = "UPDATE users SET password = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newHashedPassword);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating password for user: " + userId, e);
        }
        return false;
    }

    public boolean toggleUserStatus(int userId, String newStatus) {
        String sql = "UPDATE users SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newStatus);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error toggling status for user: " + userId, e);
        }
        return false;
    }

    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting user: " + userId, e);
        }
        return false;
    }

    public int countUsersByRole(String role) {
        String sql = "SELECT COUNT(*) FROM users WHERE role = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, role);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting users by role: " + role, e);
        }
        return 0;
    }

    private User mapUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setFullName(rs.getString("full_name"));
        u.setEmail(rs.getString("email"));
        u.setPhone(rs.getString("phone"));
        u.setUsername(rs.getString("username"));
        u.setPassword(rs.getString("password"));
        u.setRole(rs.getString("role"));

        int deptId = rs.getInt("department_id");
        if (!rs.wasNull()) {
            u.setDepartmentId(deptId);
        }

        try {
            u.setDepartmentName(rs.getString("department_name"));
        } catch (SQLException ignored) {
            // Column may not be in projection
        }

        u.setStatus(rs.getString("status"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        return u;
    }
}

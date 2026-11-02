package com.civicconnect.dao;

import com.civicconnect.model.Notification;
import com.civicconnect.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for User Notifications.
 */
public class NotificationDAO {

    private static final Logger LOGGER = Logger.getLogger(NotificationDAO.class.getName());

    public boolean createNotification(Notification n) {
        String sql = "INSERT INTO notifications (user_id, complaint_id, message, is_read) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, n.getUserId());
            if (n.getComplaintId() != null && n.getComplaintId() > 0) {
                ps.setInt(2, n.getComplaintId());
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            ps.setString(3, n.getMessage());
            ps.setBoolean(4, n.isRead());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        n.setId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating notification for user: " + n.getUserId(), e);
        }
        return false;
    }

    public List<Notification> getNotificationsByUserId(int userId, boolean unreadOnly) {
        List<Notification> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT n.*, c.complaint_code FROM notifications n ")
                .append("LEFT JOIN complaints c ON n.complaint_id = c.id ")
                .append("WHERE n.user_id = ? ");
        if (unreadOnly) {
            sql.append("AND n.is_read = FALSE ");
        }
        sql.append("ORDER BY n.created_at DESC LIMIT 30");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Notification n = new Notification();
                    n.setId(rs.getInt("id"));
                    n.setUserId(rs.getInt("user_id"));
                    int cId = rs.getInt("complaint_id");
                    if (!rs.wasNull()) {
                        n.setComplaintId(cId);
                    }
                    n.setComplaintCode(rs.getString("complaint_code"));
                    n.setMessage(rs.getString("message"));
                    n.setRead(rs.getBoolean("is_read"));
                    n.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(n);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching notifications for user: " + userId, e);
        }
        return list;
    }

    public int getUnreadCount(int userId) {
        String sql = "SELECT COUNT(*) FROM notifications WHERE user_id = ? AND is_read = FALSE";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting unread count for user: " + userId, e);
        }
        return 0;
    }

    public boolean markAsRead(int notificationId) {
        String sql = "UPDATE notifications SET is_read = TRUE WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, notificationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error marking notification as read: " + notificationId, e);
        }
        return false;
    }

    public boolean markAllAsRead(int userId) {
        String sql = "UPDATE notifications SET is_read = TRUE WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error marking all notifications read for user: " + userId, e);
        }
        return false;
    }
}

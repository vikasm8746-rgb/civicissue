package com.civicconnect.dao;

import com.civicconnect.model.Feedback;
import com.civicconnect.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for Citizen Ratings and Feedback.
 */
public class FeedbackDAO {

    private static final Logger LOGGER = Logger.getLogger(FeedbackDAO.class.getName());

    public boolean addFeedback(Feedback feedback) {
        String sql = "INSERT INTO feedback (complaint_id, user_id, rating, comment) VALUES (?, ?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE rating = VALUES(rating), comment = VALUES(comment)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, feedback.getComplaintId());
            ps.setInt(2, feedback.getUserId());
            ps.setInt(3, feedback.getRating());
            ps.setString(4, feedback.getComment());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        feedback.setId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error saving feedback for complaint: " + feedback.getComplaintId(), e);
        }
        return false;
    }

    public Feedback getFeedbackByComplaintId(int complaintId) {
        String sql = "SELECT f.*, c.complaint_code, u.full_name AS citizen_name FROM feedback f " +
                     "LEFT JOIN complaints c ON f.complaint_id = c.id " +
                     "LEFT JOIN users u ON f.user_id = u.id WHERE f.complaint_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, complaintId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Feedback f = new Feedback();
                    f.setId(rs.getInt("id"));
                    f.setComplaintId(rs.getInt("complaint_id"));
                    f.setComplaintCode(rs.getString("complaint_code"));
                    f.setUserId(rs.getInt("user_id"));
                    f.setCitizenName(rs.getString("citizen_name"));
                    f.setRating(rs.getInt("rating"));
                    f.setComment(rs.getString("comment"));
                    f.setCreatedAt(rs.getTimestamp("created_at"));
                    return f;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching feedback for complaint: " + complaintId, e);
        }
        return null;
    }

    public List<Feedback> getAllFeedbacks(int limit) {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT f.*, c.complaint_code, u.full_name AS citizen_name FROM feedback f " +
                     "LEFT JOIN complaints c ON f.complaint_id = c.id " +
                     "LEFT JOIN users u ON f.user_id = u.id ORDER BY f.created_at DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit > 0 ? limit : 50);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Feedback f = new Feedback();
                    f.setId(rs.getInt("id"));
                    f.setComplaintId(rs.getInt("complaint_id"));
                    f.setComplaintCode(rs.getString("complaint_code"));
                    f.setUserId(rs.getInt("user_id"));
                    f.setCitizenName(rs.getString("citizen_name"));
                    f.setRating(rs.getInt("rating"));
                    f.setComment(rs.getString("comment"));
                    f.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(f);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching feedbacks", e);
        }
        return list;
    }
}

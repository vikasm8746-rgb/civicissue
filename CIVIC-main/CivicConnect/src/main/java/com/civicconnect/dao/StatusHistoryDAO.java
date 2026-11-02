package com.civicconnect.dao;

import com.civicconnect.model.StatusHistory;
import com.civicconnect.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for Complaint Status Audit Timeline.
 */
public class StatusHistoryDAO {

    private static final Logger LOGGER = Logger.getLogger(StatusHistoryDAO.class.getName());

    public boolean addHistory(StatusHistory history) {
        String sql = "INSERT INTO complaint_status_history (complaint_id, old_status, new_status, changed_by, remarks) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, history.getComplaintId());
            ps.setString(2, history.getOldStatus());
            ps.setString(3, history.getNewStatus());
            if (history.getChangedBy() != null && history.getChangedBy() > 0) {
                ps.setInt(4, history.getChangedBy());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            ps.setString(5, history.getRemarks());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        history.setId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding status history for complaint: " + history.getComplaintId(), e);
        }
        return false;
    }

    public List<StatusHistory> getHistoryByComplaintId(int complaintId) {
        List<StatusHistory> list = new ArrayList<>();
        String sql = "SELECT h.*, u.full_name AS changed_by_name FROM complaint_status_history h " +
                     "LEFT JOIN users u ON h.changed_by = u.id " +
                     "WHERE h.complaint_id = ? ORDER BY h.changed_at ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, complaintId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    StatusHistory h = new StatusHistory();
                    h.setId(rs.getInt("id"));
                    h.setComplaintId(rs.getInt("complaint_id"));
                    h.setOldStatus(rs.getString("old_status"));
                    h.setNewStatus(rs.getString("new_status"));
                    int changedBy = rs.getInt("changed_by");
                    if (!rs.wasNull()) {
                        h.setChangedBy(changedBy);
                    }
                    h.setChangedByName(rs.getString("changed_by_name"));
                    h.setRemarks(rs.getString("remarks"));
                    h.setChangedAt(rs.getTimestamp("changed_at"));
                    list.add(h);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching status history for complaint: " + complaintId, e);
        }
        return list;
    }
}

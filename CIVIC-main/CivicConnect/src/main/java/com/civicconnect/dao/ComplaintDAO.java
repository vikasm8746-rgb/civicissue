package com.civicconnect.dao;

import com.civicconnect.model.Complaint;
import com.civicconnect.model.DashboardStats;
import com.civicconnect.util.DBConnection;

import java.sql.*;
import java.time.Year;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for Complaint lifecycle, queries, and analytics.
 */
public class ComplaintDAO {

    private static final Logger LOGGER = Logger.getLogger(ComplaintDAO.class.getName());

    public synchronized String generateComplaintCode() {
        int currentYear = Year.now().getValue();
        String prefix = "CIV-" + currentYear + "-";
        String sql = "SELECT complaint_code FROM complaints WHERE complaint_code LIKE ? ORDER BY id DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, prefix + "%");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String lastCode = rs.getString("complaint_code");
                    String sequenceStr = lastCode.substring(lastCode.lastIndexOf("-") + 1);
                    int nextSeq = Integer.parseInt(sequenceStr) + 1;
                    return String.format("CIV-%d-%05d", currentYear, nextSeq);
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Could not compute sequence from DB, falling back to count: " + e.getMessage());
        }
        // Fallback calculation
        int count = countTotalComplaints() + 1;
        return String.format("CIV-%d-%05d", currentYear, count);
    }

    public boolean createComplaint(Complaint complaint) {
        String sql = "INSERT INTO complaints (complaint_code, user_id, category_id, title, description, location, landmark, city, pincode, image_path, priority, status, department_id) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            if (complaint.getComplaintCode() == null || complaint.getComplaintCode().trim().isEmpty()) {
                complaint.setComplaintCode(generateComplaintCode());
            }

            ps.setString(1, complaint.getComplaintCode());
            ps.setInt(2, complaint.getUserId());
            ps.setInt(3, complaint.getCategoryId());
            ps.setString(4, complaint.getTitle());
            ps.setString(5, complaint.getDescription());
            ps.setString(6, complaint.getLocation());
            ps.setString(7, complaint.getLandmark());
            ps.setString(8, complaint.getCity() != null ? complaint.getCity() : "Metro City");
            ps.setString(9, complaint.getPincode());
            ps.setString(10, complaint.getImagePath());
            ps.setString(11, complaint.getPriority() != null ? complaint.getPriority() : "MEDIUM");
            ps.setString(12, complaint.getStatus() != null ? complaint.getStatus() : "SUBMITTED");

            if (complaint.getDepartmentId() != null && complaint.getDepartmentId() > 0) {
                ps.setInt(13, complaint.getDepartmentId());
            } else {
                ps.setNull(13, Types.INTEGER);
            }

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        complaint.setId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating complaint: " + complaint.getTitle(), e);
        }
        return false;
    }

    public Complaint getComplaintById(int id) {
        String sql = getBaseSelectQuery() + " WHERE c.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapComplaint(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching complaint by id: " + id, e);
        }
        return null;
    }

    public Complaint getComplaintByCode(String complaintCode) {
        String sql = getBaseSelectQuery() + " WHERE c.complaint_code = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, complaintCode.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapComplaint(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching complaint by code: " + complaintCode, e);
        }
        return null;
    }

    public List<Complaint> getComplaintsByUserId(int userId) {
        List<Complaint> list = new ArrayList<>();
        String sql = getBaseSelectQuery() + " WHERE c.user_id = ? ORDER BY c.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapComplaint(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching complaints for user: " + userId, e);
        }
        return list;
    }

    public List<Complaint> getComplaintsByStaffId(int staffId) {
        List<Complaint> list = new ArrayList<>();
        String sql = getBaseSelectQuery() + " WHERE c.assigned_staff_id = ? ORDER BY c.updated_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, staffId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapComplaint(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching complaints for staff: " + staffId, e);
        }
        return list;
    }

    public List<Complaint> getRecentComplaints(int limit) {
        List<Complaint> list = new ArrayList<>();
        String sql = getBaseSelectQuery() + " ORDER BY c.created_at DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapComplaint(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching recent complaints", e);
        }
        return list;
    }

    public List<Complaint> getFilteredComplaints(String status, Integer departmentId, String priority, String search, int offset, int limit) {
        List<Complaint> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(getBaseSelectQuery()).append(" WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (status != null && !status.trim().isEmpty() && !status.equalsIgnoreCase("ALL")) {
            sql.append(" AND c.status = ? ");
            params.add(status.trim());
        }
        if (departmentId != null && departmentId > 0) {
            sql.append(" AND c.department_id = ? ");
            params.add(departmentId);
        }
        if (priority != null && !priority.trim().isEmpty() && !priority.equalsIgnoreCase("ALL")) {
            sql.append(" AND c.priority = ? ");
            params.add(priority.trim());
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (c.complaint_code LIKE ? OR c.title LIKE ? OR c.location LIKE ? OR u.full_name LIKE ?) ");
            String wild = "%" + search.trim() + "%";
            params.add(wild);
            params.add(wild);
            params.add(wild);
            params.add(wild);
        }

        sql.append(" ORDER BY c.created_at DESC LIMIT ? OFFSET ?");
        params.add(limit > 0 ? limit : 20);
        params.add(Math.max(offset, 0));

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapComplaint(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching filtered complaints", e);
        }
        return list;
    }

    public int countFilteredComplaints(String status, Integer departmentId, String priority, String search) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM complaints c " +
                "LEFT JOIN users u ON c.user_id = u.id WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (status != null && !status.trim().isEmpty() && !status.equalsIgnoreCase("ALL")) {
            sql.append(" AND c.status = ? ");
            params.add(status.trim());
        }
        if (departmentId != null && departmentId > 0) {
            sql.append(" AND c.department_id = ? ");
            params.add(departmentId);
        }
        if (priority != null && !priority.trim().isEmpty() && !priority.equalsIgnoreCase("ALL")) {
            sql.append(" AND c.priority = ? ");
            params.add(priority.trim());
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (c.complaint_code LIKE ? OR c.title LIKE ? OR c.location LIKE ? OR u.full_name LIKE ?) ");
            String wild = "%" + search.trim() + "%";
            params.add(wild);
            params.add(wild);
            params.add(wild);
            params.add(wild);
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting filtered complaints", e);
        }
        return 0;
    }

    public boolean assignComplaint(int complaintId, int departmentId, Integer staffId, String adminRemarks) {
        String sql = "UPDATE complaints SET department_id = ?, assigned_staff_id = ?, admin_remarks = ?, status = 'ASSIGNED' WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, departmentId);
            if (staffId != null && staffId > 0) {
                ps.setInt(2, staffId);
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            ps.setString(3, adminRemarks);
            ps.setInt(4, complaintId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error assigning complaint: " + complaintId, e);
        }
        return false;
    }

    public boolean updateStatus(int complaintId, String newStatus, String adminRemarks, String staffRemarks, String resolutionImagePath) {
        StringBuilder sql = new StringBuilder("UPDATE complaints SET status = ? ");
        List<Object> params = new ArrayList<>();
        params.add(newStatus);

        if (adminRemarks != null) {
            sql.append(", admin_remarks = ? ");
            params.add(adminRemarks);
        }
        if (staffRemarks != null) {
            sql.append(", staff_remarks = ? ");
            params.add(staffRemarks);
        }
        if (resolutionImagePath != null && !resolutionImagePath.trim().isEmpty()) {
            sql.append(", resolution_image_path = ? ");
            params.add(resolutionImagePath);
        }
        if ("RESOLVED".equalsIgnoreCase(newStatus)) {
            sql.append(", resolved_at = CURRENT_TIMESTAMP ");
        }

        sql.append(" WHERE id = ?");
        params.add(complaintId);

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating status for complaint: " + complaintId, e);
        }
        return false;
    }

    public boolean deleteComplaint(int complaintId) {
        String sql = "DELETE FROM complaints WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, complaintId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting complaint: " + complaintId, e);
        }
        return false;
    }

    public DashboardStats getDashboardStats(Integer citizenUserId, Integer staffUserId) {
        DashboardStats stats = new DashboardStats();

        // 1. Status Counts
        StringBuilder statusSql = new StringBuilder("SELECT status, COUNT(*) AS cnt FROM complaints WHERE 1=1 ");
        if (citizenUserId != null) {
            statusSql.append(" AND user_id = ").append(citizenUserId);
        } else if (staffUserId != null) {
            statusSql.append(" AND assigned_staff_id = ").append(staffUserId);
        }
        statusSql.append(" GROUP BY status");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(statusSql.toString());
             ResultSet rs = ps.executeQuery()) {

            int total = 0;
            while (rs.next()) {
                String st = rs.getString("status");
                int cnt = rs.getInt("cnt");
                total += cnt;
                stats.getComplaintsByStatus().put(st, cnt);

                switch (st.toUpperCase()) {
                    case "SUBMITTED":
                        stats.setSubmittedCount(cnt);
                        break;
                    case "UNDER_REVIEW":
                        stats.setUnderReviewCount(cnt);
                        break;
                    case "ASSIGNED":
                        stats.setAssignedCount(cnt);
                        break;
                    case "IN_PROGRESS":
                        stats.setInProgressCount(cnt);
                        break;
                    case "RESOLVED":
                        stats.setResolvedCount(cnt);
                        break;
                    case "REJECTED":
                        stats.setRejectedCount(cnt);
                        break;
                }
            }
            stats.setTotalComplaints(total);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error computing status stats", e);
        }

        // 2. Global counts for Admin
        if (citizenUserId == null && staffUserId == null) {
            try (Connection conn = DBConnection.getConnection()) {
                try (PreparedStatement ps = conn.prepareStatement("SELECT role, COUNT(*) AS cnt FROM users GROUP BY role");
                     ResultSet rs = ps.executeQuery()) {
                    int totalU = 0;
                    while (rs.next()) {
                        String r = rs.getString("role");
                        int c = rs.getInt("cnt");
                        totalU += c;
                        if ("CITIZEN".equalsIgnoreCase(r)) stats.setTotalCitizens(c);
                        if ("STAFF".equalsIgnoreCase(r)) stats.setTotalStaff(c);
                    }
                    stats.setTotalUsers(totalU);
                }

                try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM departments WHERE status='ACTIVE'");
                     ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) stats.setTotalDepartments(rs.getInt(1));
                }

                try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM categories WHERE status='ACTIVE'");
                     ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) stats.setTotalCategories(rs.getInt(1));
                }

                // Category aggregate breakdown
                try (PreparedStatement ps = conn.prepareStatement(
                        "SELECT cat.name, COUNT(c.id) AS cnt FROM categories cat " +
                        "LEFT JOIN complaints c ON c.category_id = cat.id " +
                        "GROUP BY cat.id, cat.name ORDER BY cnt DESC");
                     ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        stats.getComplaintsByCategory().put(rs.getString("name"), rs.getInt("cnt"));
                    }
                }

                // Department aggregate breakdown
                try (PreparedStatement ps = conn.prepareStatement(
                        "SELECT d.name, COUNT(c.id) AS cnt FROM departments d " +
                        "LEFT JOIN complaints c ON c.department_id = d.id " +
                        "GROUP BY d.id, d.name ORDER BY cnt DESC");
                     ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        stats.getComplaintsByDepartment().put(rs.getString("name"), rs.getInt("cnt"));
                    }
                }

                // Monthly trends
                try (PreparedStatement ps = conn.prepareStatement(
                        "SELECT DATE_FORMAT(created_at, '%b %Y') AS mth, COUNT(*) AS cnt " +
                        "FROM complaints GROUP BY DATE_FORMAT(created_at, '%b %Y'), YEAR(created_at), MONTH(created_at) " +
                        "ORDER BY YEAR(created_at) ASC, MONTH(created_at) ASC LIMIT 12");
                     ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        stats.getMonthlyComplaints().put(rs.getString("mth"), rs.getInt("cnt"));
                    }
                }
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error building admin analytics dashboard stats", e);
            }
        }

        return stats;
    }

    public int countTotalComplaints() {
        String sql = "SELECT COUNT(*) FROM complaints";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting total complaints", e);
        }
        return 0;
    }

    private String getBaseSelectQuery() {
        return "SELECT c.*, " +
               "u.full_name AS citizen_name, u.email AS citizen_email, u.phone AS citizen_phone, " +
               "cat.name AS category_name, " +
               "d.name AS department_name, " +
               "s.full_name AS staff_name, s.phone AS staff_phone, " +
               "f.rating AS feedback_rating, f.comment AS feedback_comment " +
               "FROM complaints c " +
               "LEFT JOIN users u ON c.user_id = u.id " +
               "LEFT JOIN categories cat ON c.category_id = cat.id " +
               "LEFT JOIN departments d ON c.department_id = d.id " +
               "LEFT JOIN users s ON c.assigned_staff_id = s.id " +
               "LEFT JOIN feedback f ON f.complaint_id = c.id ";
    }

    private Complaint mapComplaint(ResultSet rs) throws SQLException {
        Complaint c = new Complaint();
        c.setId(rs.getInt("id"));
        c.setComplaintCode(rs.getString("complaint_code"));
        c.setUserId(rs.getInt("user_id"));
        c.setCitizenName(rs.getString("citizen_name"));
        c.setCitizenEmail(rs.getString("citizen_email"));
        c.setCitizenPhone(rs.getString("citizen_phone"));

        c.setCategoryId(rs.getInt("category_id"));
        c.setCategoryName(rs.getString("category_name"));

        c.setTitle(rs.getString("title"));
        c.setDescription(rs.getString("description"));
        c.setLocation(rs.getString("location"));
        c.setLandmark(rs.getString("landmark"));
        c.setCity(rs.getString("city"));
        c.setPincode(rs.getString("pincode"));
        c.setImagePath(rs.getString("image_path"));
        c.setResolutionImagePath(rs.getString("resolution_image_path"));

        c.setPriority(rs.getString("priority"));
        c.setStatus(rs.getString("status"));

        int deptId = rs.getInt("department_id");
        if (!rs.wasNull()) {
            c.setDepartmentId(deptId);
        }
        c.setDepartmentName(rs.getString("department_name"));

        int staffId = rs.getInt("assigned_staff_id");
        if (!rs.wasNull()) {
            c.setAssignedStaffId(staffId);
        }
        c.setStaffName(rs.getString("staff_name"));
        c.setStaffPhone(rs.getString("staff_phone"));

        c.setAdminRemarks(rs.getString("admin_remarks"));
        c.setStaffRemarks(rs.getString("staff_remarks"));

        c.setCreatedAt(rs.getTimestamp("created_at"));
        c.setUpdatedAt(rs.getTimestamp("updated_at"));
        c.setResolvedAt(rs.getTimestamp("resolved_at"));

        int rating = rs.getInt("feedback_rating");
        if (!rs.wasNull()) {
            c.setFeedbackRating(rating);
        }
        c.setFeedbackComment(rs.getString("feedback_comment"));

        return c;
    }
}

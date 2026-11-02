package com.civicconnect.service;

import com.civicconnect.dao.CategoryDAO;
import com.civicconnect.dao.ComplaintDAO;
import com.civicconnect.dao.NotificationDAO;
import com.civicconnect.dao.StatusHistoryDAO;
import com.civicconnect.model.*;
import com.civicconnect.util.ValidationUtil;

import java.util.List;

/**
 * Service orchestrating Complaint workflows, state transitions, timeline logging, and notifications.
 */
public class ComplaintService {

    private final ComplaintDAO complaintDAO;
    private final StatusHistoryDAO statusHistoryDAO;
    private final NotificationDAO notificationDAO;
    private final CategoryDAO categoryDAO;

    public ComplaintService() {
        this.complaintDAO = new ComplaintDAO();
        this.statusHistoryDAO = new StatusHistoryDAO();
        this.notificationDAO = new NotificationDAO();
        this.categoryDAO = new CategoryDAO();
    }

    public ComplaintService(ComplaintDAO complaintDAO, StatusHistoryDAO statusHistoryDAO,
                            NotificationDAO notificationDAO, CategoryDAO categoryDAO) {
        this.complaintDAO = complaintDAO;
        this.statusHistoryDAO = statusHistoryDAO;
        this.notificationDAO = notificationDAO;
        this.categoryDAO = categoryDAO;
    }

    public String submitComplaint(Complaint complaint) {
        if (!ValidationUtil.isNotEmpty(complaint.getTitle())) {
            return "Please provide a descriptive Issue Title.";
        }
        if (complaint.getCategoryId() <= 0) {
            return "Please select a valid Issue Category.";
        }
        if (!ValidationUtil.isNotEmpty(complaint.getDescription())) {
            return "Please provide a detailed description of the problem.";
        }
        if (!ValidationUtil.isNotEmpty(complaint.getLocation())) {
            return "Location / Street address is required.";
        }
        if (!ValidationUtil.isValidPincode(complaint.getPincode())) {
            return "Please enter a valid 6-digit PIN code.";
        }
        if (!ValidationUtil.isValidPriority(complaint.getPriority())) {
            complaint.setPriority("MEDIUM");
        }

        // Fetch category to auto-assign default department if known
        Category cat = categoryDAO.getCategoryById(complaint.getCategoryId());
        if (cat != null && cat.getDepartmentId() != null && cat.getDepartmentId() > 0) {
            complaint.setDepartmentId(cat.getDepartmentId());
        }

        complaint.setStatus("SUBMITTED");
        boolean created = complaintDAO.createComplaint(complaint);
        if (created) {
            // Log initial status history
            StatusHistory history = new StatusHistory(
                    complaint.getId(),
                    null,
                    "SUBMITTED",
                    complaint.getUserId(),
                    "Complaint submitted by citizen."
            );
            statusHistoryDAO.addHistory(history);

            // Create notification for citizen
            Notification notif = new Notification(
                    complaint.getUserId(),
                    complaint.getId(),
                    "Your complaint " + complaint.getComplaintCode() + " has been successfully submitted."
            );
            notificationDAO.createNotification(notif);

            return "SUCCESS";
        }
        return "Failed to submit complaint. Please try again.";
    }

    public Complaint getComplaintById(int id) {
        return complaintDAO.getComplaintById(id);
    }

    public Complaint getComplaintByCode(String code) {
        if (!ValidationUtil.isNotEmpty(code)) return null;
        return complaintDAO.getComplaintByCode(code.trim());
    }

    public List<Complaint> getComplaintsByUser(int userId) {
        return complaintDAO.getComplaintsByUserId(userId);
    }

    public List<Complaint> getComplaintsByStaff(int staffId) {
        return complaintDAO.getComplaintsByStaffId(staffId);
    }

    public List<Complaint> getFilteredComplaints(String status, Integer deptId, String priority, String search, int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        return complaintDAO.getFilteredComplaints(status, deptId, priority, search, offset, pageSize);
    }

    public int countFilteredComplaints(String status, Integer deptId, String priority, String search) {
        return complaintDAO.countFilteredComplaints(status, deptId, priority, search);
    }

    public List<Complaint> getRecentComplaints(int limit) {
        return complaintDAO.getRecentComplaints(limit);
    }

    public List<StatusHistory> getStatusHistory(int complaintId) {
        return statusHistoryDAO.getHistoryByComplaintId(complaintId);
    }

    public boolean assignComplaint(int complaintId, int departmentId, Integer staffId, String adminRemarks, int adminUserId) {
        Complaint c = complaintDAO.getComplaintById(complaintId);
        if (c == null) return false;

        String oldStatus = c.getStatus();
        boolean assigned = complaintDAO.assignComplaint(complaintId, departmentId, staffId, adminRemarks);
        if (assigned) {
            // Log History
            String remarkMsg = adminRemarks != null && !adminRemarks.trim().isEmpty() ? adminRemarks : "Assigned to department.";
            StatusHistory h = new StatusHistory(complaintId, oldStatus, "ASSIGNED", adminUserId, remarkMsg);
            statusHistoryDAO.addHistory(h);

            // Notify citizen
            Notification cNotif = new Notification(
                    c.getUserId(),
                    c.getId(),
                    "Your complaint " + c.getComplaintCode() + " has been assigned to department for resolution."
            );
            notificationDAO.createNotification(cNotif);

            // Notify staff if assigned
            if (staffId != null && staffId > 0) {
                Notification sNotif = new Notification(
                        staffId,
                        c.getId(),
                        "New complaint " + c.getComplaintCode() + " has been assigned to you: " + c.getTitle()
                );
                notificationDAO.createNotification(sNotif);
            }
            return true;
        }
        return false;
    }

    public boolean updateStatus(int complaintId, String newStatus, String adminRemarks, String staffRemarks,
                                String resolutionImagePath, int changedByUserId) {
        Complaint c = complaintDAO.getComplaintById(complaintId);
        if (c == null) return false;

        String oldStatus = c.getStatus();
        boolean updated = complaintDAO.updateStatus(complaintId, newStatus, adminRemarks, staffRemarks, resolutionImagePath);
        if (updated) {
            String note = staffRemarks != null && !staffRemarks.trim().isEmpty() ? staffRemarks : adminRemarks;
            if (note == null || note.trim().isEmpty()) {
                note = "Status changed to " + newStatus;
            }
            StatusHistory h = new StatusHistory(complaintId, oldStatus, newStatus, changedByUserId, note);
            statusHistoryDAO.addHistory(h);

            // Notify citizen
            String msg = "Your complaint " + c.getComplaintCode() + " status is now " + newStatus + ".";
            if ("RESOLVED".equalsIgnoreCase(newStatus)) {
                msg = "Your complaint " + c.getComplaintCode() + " has been RESOLVED. Please view details and leave your feedback!";
            } else if ("REJECTED".equalsIgnoreCase(newStatus)) {
                msg = "Your complaint " + c.getComplaintCode() + " has been closed/rejected. Remarks: " + (note != null ? note : "");
            }
            Notification n = new Notification(c.getUserId(), c.getId(), msg);
            notificationDAO.createNotification(n);

            return true;
        }
        return false;
    }

    public boolean deleteComplaint(int complaintId) {
        return complaintDAO.deleteComplaint(complaintId);
    }

    public DashboardStats getDashboardStats(Integer citizenUserId, Integer staffUserId) {
        return complaintDAO.getDashboardStats(citizenUserId, staffUserId);
    }
}

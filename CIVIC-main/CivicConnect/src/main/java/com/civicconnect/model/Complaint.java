package com.civicconnect.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

/**
 * Model representing a Citizen Complaint / Civic Issue.
 */
public class Complaint implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String complaintCode; // e.g. CIV-2026-00001
    private int userId;
    private String citizenName;   // Joined field
    private String citizenEmail;  // Joined field
    private String citizenPhone;  // Joined field

    private int categoryId;
    private String categoryName;  // Joined field

    private String title;
    private String description;
    private String location;
    private String landmark;
    private String city;
    private String pincode;
    private String imagePath;
    private String resolutionImagePath;

    private String priority; // LOW, MEDIUM, HIGH, CRITICAL
    private String status;   // SUBMITTED, UNDER_REVIEW, ASSIGNED, IN_PROGRESS, RESOLVED, REJECTED

    private Integer departmentId;
    private String departmentName; // Joined field

    private Integer assignedStaffId;
    private String staffName;      // Joined field
    private String staffPhone;     // Joined field

    private String adminRemarks;
    private String staffRemarks;

    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Timestamp resolvedAt;

    // Feedback fields if resolved
    private Integer feedbackRating;
    private String feedbackComment;

    public Complaint() {
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getComplaintCode() {
        return complaintCode;
    }

    public void setComplaintCode(String complaintCode) {
        this.complaintCode = complaintCode;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getCitizenName() {
        return citizenName;
    }

    public void setCitizenName(String citizenName) {
        this.citizenName = citizenName;
    }

    public String getCitizenEmail() {
        return citizenEmail;
    }

    public void setCitizenEmail(String citizenEmail) {
        this.citizenEmail = citizenEmail;
    }

    public String getCitizenPhone() {
        return citizenPhone;
    }

    public void setCitizenPhone(String citizenPhone) {
        this.citizenPhone = citizenPhone;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getLandmark() {
        return landmark;
    }

    public void setLandmark(String landmark) {
        this.landmark = landmark;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getPincode() {
        return pincode;
    }

    public void setPincode(String pincode) {
        this.pincode = pincode;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public String getResolutionImagePath() {
        return resolutionImagePath;
    }

    public void setResolutionImagePath(String resolutionImagePath) {
        this.resolutionImagePath = resolutionImagePath;
    }

    public String getPriority() {
        return priority;
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(Integer departmentId) {
        this.departmentId = departmentId;
    }

    public String getDepartmentName() {
        return departmentName;
    }

    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
    }

    public Integer getAssignedStaffId() {
        return assignedStaffId;
    }

    public void setAssignedStaffId(Integer assignedStaffId) {
        this.assignedStaffId = assignedStaffId;
    }

    public String getStaffName() {
        return staffName;
    }

    public void setStaffName(String staffName) {
        this.staffName = staffName;
    }

    public String getStaffPhone() {
        return staffPhone;
    }

    public void setStaffPhone(String staffPhone) {
        this.staffPhone = staffPhone;
    }

    public String getAdminRemarks() {
        return adminRemarks;
    }

    public void setAdminRemarks(String adminRemarks) {
        this.adminRemarks = adminRemarks;
    }

    public String getStaffRemarks() {
        return staffRemarks;
    }

    public void setStaffRemarks(String staffRemarks) {
        this.staffRemarks = staffRemarks;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public Timestamp getResolvedAt() {
        return resolvedAt;
    }

    public void setResolvedAt(Timestamp resolvedAt) {
        this.resolvedAt = resolvedAt;
    }

    public Integer getFeedbackRating() {
        return feedbackRating;
    }

    public void setFeedbackRating(Integer feedbackRating) {
        this.feedbackRating = feedbackRating;
    }

    public String getFeedbackComment() {
        return feedbackComment;
    }

    public void setFeedbackComment(String feedbackComment) {
        this.feedbackComment = feedbackComment;
    }

    // Helper Display Methods
    public String getFormattedCreatedAt() {
        if (createdAt == null) return "N/A";
        return new SimpleDateFormat("dd MMM yyyy, hh:mm a").format(createdAt);
    }

    public String getFormattedResolvedAt() {
        if (resolvedAt == null) return "N/A";
        return new SimpleDateFormat("dd MMM yyyy, hh:mm a").format(resolvedAt);
    }

    public String getStatusBadgeClass() {
        if (status == null) return "bg-secondary";
        switch (status.toUpperCase()) {
            case "SUBMITTED":
                return "badge-submitted";
            case "UNDER_REVIEW":
                return "badge-under-review";
            case "ASSIGNED":
                return "badge-assigned";
            case "IN_PROGRESS":
                return "badge-in-progress";
            case "RESOLVED":
                return "badge-resolved";
            case "REJECTED":
                return "badge-rejected";
            default:
                return "bg-secondary";
        }
    }

    public String getPriorityBadgeClass() {
        if (priority == null) return "bg-secondary";
        switch (priority.toUpperCase()) {
            case "LOW":
                return "badge-priority-low";
            case "MEDIUM":
                return "badge-priority-medium";
            case "HIGH":
                return "badge-priority-high";
            case "CRITICAL":
                return "badge-priority-critical";
            default:
                return "bg-secondary";
        }
    }

    public int getWorkflowStep() {
        if (status == null) return 1;
        switch (status.toUpperCase()) {
            case "SUBMITTED":
                return 1;
            case "UNDER_REVIEW":
                return 2;
            case "ASSIGNED":
                return 3;
            case "IN_PROGRESS":
                return 4;
            case "RESOLVED":
                return 5;
            case "REJECTED":
                return -1;
            default:
                return 1;
        }
    }
}

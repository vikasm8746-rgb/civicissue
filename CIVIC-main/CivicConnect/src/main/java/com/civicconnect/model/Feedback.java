package com.civicconnect.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

/**
 * Model representing Citizen Feedback on resolved complaints.
 */
public class Feedback implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int complaintId;
    private String complaintCode; // Joined field
    private int userId;
    private String citizenName;    // Joined field
    private int rating;            // 1 to 5
    private String comment;
    private Timestamp createdAt;

    public Feedback() {
    }

    public Feedback(int complaintId, int userId, int rating, String comment) {
        this.complaintId = complaintId;
        this.userId = userId;
        this.rating = rating;
        this.comment = comment;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getComplaintId() {
        return complaintId;
    }

    public void setComplaintId(int complaintId) {
        this.complaintId = complaintId;
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

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getFormattedCreatedAt() {
        if (createdAt == null) return "N/A";
        return new SimpleDateFormat("dd MMM yyyy, hh:mm a").format(createdAt);
    }
}

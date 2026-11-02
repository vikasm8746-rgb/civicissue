package com.civicconnect.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

/**
 * Model representing a state transition record in complaint status history.
 */
public class StatusHistory implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int complaintId;
    private String oldStatus;
    private String newStatus;
    private Integer changedBy;
    private String changedByName; // Joined field
    private String remarks;
    private Timestamp changedAt;

    public StatusHistory() {
    }

    public StatusHistory(int complaintId, String oldStatus, String newStatus, Integer changedBy, String remarks) {
        this.complaintId = complaintId;
        this.oldStatus = oldStatus;
        this.newStatus = newStatus;
        this.changedBy = changedBy;
        this.remarks = remarks;
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

    public String getOldStatus() {
        return oldStatus;
    }

    public void setOldStatus(String oldStatus) {
        this.oldStatus = oldStatus;
    }

    public String getNewStatus() {
        return newStatus;
    }

    public void setNewStatus(String newStatus) {
        this.newStatus = newStatus;
    }

    public Integer getChangedBy() {
        return changedBy;
    }

    public void setChangedBy(Integer changedBy) {
        this.changedBy = changedBy;
    }

    public String getChangedByName() {
        return changedByName;
    }

    public void setChangedByName(String changedByName) {
        this.changedByName = changedByName;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    public Timestamp getChangedAt() {
        return changedAt;
    }

    public void setChangedAt(Timestamp changedAt) {
        this.changedAt = changedAt;
    }

    public String getFormattedChangedAt() {
        if (changedAt == null) return "N/A";
        return new SimpleDateFormat("dd MMM yyyy, hh:mm a").format(changedAt);
    }
}

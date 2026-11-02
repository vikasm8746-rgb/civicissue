package com.civicconnect.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Model representing a Civic Complaint Category.
 */
public class Category implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private Integer departmentId;
    private String departmentName; // Joined field
    private String name;
    private String description;
    private String status; // ACTIVE, INACTIVE
    private Timestamp createdAt;

    public Category() {
    }

    public Category(int id, Integer departmentId, String name, String description, String status) {
        this.id = id;
        this.departmentId = departmentId;
        this.name = name;
        this.description = description;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
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

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}

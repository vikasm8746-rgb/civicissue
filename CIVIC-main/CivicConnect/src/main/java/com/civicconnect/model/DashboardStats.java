package com.civicconnect.model;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

/**
 * Encapsulates KPI metrics and aggregated analytical data for charts and dashboard cards.
 */
public class DashboardStats implements Serializable {
    private static final long serialVersionUID = 1L;

    // Overall Counts
    private int totalUsers;
    private int totalCitizens;
    private int totalStaff;
    private int totalDepartments;
    private int totalCategories;

    // Complaint Counts by Status
    private int totalComplaints;
    private int submittedCount;
    private int underReviewCount;
    private int assignedCount;
    private int inProgressCount;
    private int resolvedCount;
    private int rejectedCount;

    // Staff Specific Counts
    private int myAssignedCount;
    private int myInProgressCount;
    private int myResolvedCount;

    // Aggregates for Chart.js
    private Map<String, Integer> complaintsByCategory = new HashMap<>();
    private Map<String, Integer> complaintsByStatus = new HashMap<>();
    private Map<String, Integer> complaintsByDepartment = new HashMap<>();
    private Map<String, Integer> monthlyComplaints = new HashMap<>();

    public DashboardStats() {
    }

    public int getTotalUsers() {
        return totalUsers;
    }

    public void setTotalUsers(int totalUsers) {
        this.totalUsers = totalUsers;
    }

    public int getTotalCitizens() {
        return totalCitizens;
    }

    public void setTotalCitizens(int totalCitizens) {
        this.totalCitizens = totalCitizens;
    }

    public int getTotalStaff() {
        return totalStaff;
    }

    public void setTotalStaff(int totalStaff) {
        this.totalStaff = totalStaff;
    }

    public int getTotalDepartments() {
        return totalDepartments;
    }

    public void setTotalDepartments(int totalDepartments) {
        this.totalDepartments = totalDepartments;
    }

    public int getTotalCategories() {
        return totalCategories;
    }

    public void setTotalCategories(int totalCategories) {
        this.totalCategories = totalCategories;
    }

    public int getTotalComplaints() {
        return totalComplaints;
    }

    public void setTotalComplaints(int totalComplaints) {
        this.totalComplaints = totalComplaints;
    }

    public int getSubmittedCount() {
        return submittedCount;
    }

    public void setSubmittedCount(int submittedCount) {
        this.submittedCount = submittedCount;
    }

    public int getUnderReviewCount() {
        return underReviewCount;
    }

    public void setUnderReviewCount(int underReviewCount) {
        this.underReviewCount = underReviewCount;
    }

    public int getAssignedCount() {
        return assignedCount;
    }

    public void setAssignedCount(int assignedCount) {
        this.assignedCount = assignedCount;
    }

    public int getInProgressCount() {
        return inProgressCount;
    }

    public void setInProgressCount(int inProgressCount) {
        this.inProgressCount = inProgressCount;
    }

    public int getResolvedCount() {
        return resolvedCount;
    }

    public void setResolvedCount(int resolvedCount) {
        this.resolvedCount = resolvedCount;
    }

    public int getRejectedCount() {
        return rejectedCount;
    }

    public void setRejectedCount(int rejectedCount) {
        this.rejectedCount = rejectedCount;
    }

    public int getPendingCount() {
        return submittedCount + underReviewCount + assignedCount;
    }

    public int getMyAssignedCount() {
        return myAssignedCount;
    }

    public void setMyAssignedCount(int myAssignedCount) {
        this.myAssignedCount = myAssignedCount;
    }

    public int getMyInProgressCount() {
        return myInProgressCount;
    }

    public void setMyInProgressCount(int myInProgressCount) {
        this.myInProgressCount = myInProgressCount;
    }

    public int getMyResolvedCount() {
        return myResolvedCount;
    }

    public void setMyResolvedCount(int myResolvedCount) {
        this.myResolvedCount = myResolvedCount;
    }

    public Map<String, Integer> getComplaintsByCategory() {
        return complaintsByCategory;
    }

    public void setComplaintsByCategory(Map<String, Integer> complaintsByCategory) {
        this.complaintsByCategory = complaintsByCategory;
    }

    public Map<String, Integer> getComplaintsByStatus() {
        return complaintsByStatus;
    }

    public void setComplaintsByStatus(Map<String, Integer> complaintsByStatus) {
        this.complaintsByStatus = complaintsByStatus;
    }

    public Map<String, Integer> getComplaintsByDepartment() {
        return complaintsByDepartment;
    }

    public void setComplaintsByDepartment(Map<String, Integer> complaintsByDepartment) {
        this.complaintsByDepartment = complaintsByDepartment;
    }

    public Map<String, Integer> getMonthlyComplaints() {
        return monthlyComplaints;
    }

    public void setMonthlyComplaints(Map<String, Integer> monthlyComplaints) {
        this.monthlyComplaints = monthlyComplaints;
    }

    public double getResolutionRate() {
        if (totalComplaints == 0) return 0.0;
        return Math.round(((double) resolvedCount / totalComplaints * 100.0) * 10.0) / 10.0;
    }
}

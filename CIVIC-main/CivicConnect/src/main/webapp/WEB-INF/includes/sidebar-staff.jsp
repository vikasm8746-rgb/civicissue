<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<aside class="sidebar">
    <div class="sidebar-header">
        <div class="sidebar-user-avatar" style="border-color: #38bdf8;">
            <i class="bi bi-person-badge"></i>
        </div>
        <div class="overflow-hidden">
            <h6 class="mb-0 text-white text-truncate fw-bold">${sessionScope.currentUser.fullName}</h6>
            <small class="text-white-50">${sessionScope.currentUser.departmentName != null ? sessionScope.currentUser.departmentName : 'Municipal Staff'}</small>
        </div>
    </div>
    <div class="sidebar-nav">
        <a href="${pageContext.request.contextPath}/staff/dashboard" class="sidebar-link ${param.activePage == 'dashboard' ? 'active' : ''}">
            <i class="bi bi-speedometer2"></i>
            <span>Staff Dashboard</span>
        </a>
        <a href="${pageContext.request.contextPath}/staff/assigned-complaints" class="sidebar-link ${param.activePage == 'assigned' ? 'active' : ''}">
            <i class="bi bi-card-checklist"></i>
            <span>Assigned Complaints</span>
        </a>
        <a href="${pageContext.request.contextPath}/profile" class="sidebar-link ${param.activePage == 'profile' ? 'active' : ''}">
            <i class="bi bi-person-gear"></i>
            <span>My Profile</span>
        </a>
        <hr class="border-secondary my-3 opacity-25">
        <a href="${pageContext.request.contextPath}/logout" class="sidebar-link text-danger">
            <i class="bi bi-box-arrow-right"></i>
            <span>Logout</span>
        </a>
    </div>
</aside>

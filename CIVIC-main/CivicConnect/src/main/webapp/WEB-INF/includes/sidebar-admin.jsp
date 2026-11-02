<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<aside class="sidebar">
    <div class="sidebar-header">
        <div class="sidebar-user-avatar" style="border-color: #ef4444;">
            <i class="bi bi-shield-lock"></i>
        </div>
        <div class="overflow-hidden">
            <h6 class="mb-0 text-white text-truncate fw-bold">${sessionScope.currentUser.fullName}</h6>
            <small class="text-white-50">System Administrator</small>
        </div>
    </div>
    <div class="sidebar-nav">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-link ${param.activePage == 'dashboard' ? 'active' : ''}">
            <i class="bi bi-speedometer"></i>
            <span>Admin Dashboard</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/manage-complaints" class="sidebar-link ${param.activePage == 'complaints' ? 'active' : ''}">
            <i class="bi bi-list-task"></i>
            <span>Manage Complaints</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/manage-users" class="sidebar-link ${param.activePage == 'users' ? 'active' : ''}">
            <i class="bi bi-people"></i>
            <span>Manage Citizens</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/manage-staff" class="sidebar-link ${param.activePage == 'staff' ? 'active' : ''}">
            <i class="bi bi-person-badge"></i>
            <span>Manage Staff</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/manage-departments" class="sidebar-link ${param.activePage == 'departments' ? 'active' : ''}">
            <i class="bi bi-building"></i>
            <span>Departments</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/manage-categories" class="sidebar-link ${param.activePage == 'categories' ? 'active' : ''}">
            <i class="bi bi-tags"></i>
            <span>Issue Categories</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/reports" class="sidebar-link ${param.activePage == 'reports' ? 'active' : ''}">
            <i class="bi bi-bar-chart-line"></i>
            <span>Reports & Analytics</span>
        </a>
        <hr class="border-secondary my-3 opacity-25">
        <a href="${pageContext.request.contextPath}/logout" class="sidebar-link text-danger">
            <i class="bi bi-box-arrow-right"></i>
            <span>Logout</span>
        </a>
    </div>
</aside>

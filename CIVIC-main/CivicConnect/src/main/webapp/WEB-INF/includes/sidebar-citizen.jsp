<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<aside class="sidebar">
    <div class="sidebar-header">
        <div class="sidebar-user-avatar">
            <i class="bi bi-person"></i>
        </div>
        <div class="overflow-hidden">
            <h6 class="mb-0 text-white text-truncate fw-bold">${sessionScope.currentUser.fullName}</h6>
            <small class="text-white-50">Citizen Portal</small>
        </div>
    </div>
    <div class="sidebar-nav">
        <a href="${pageContext.request.contextPath}/citizen/dashboard" class="sidebar-link ${param.activePage == 'dashboard' ? 'active' : ''}">
            <i class="bi bi-grid-1x2"></i>
            <span>Dashboard</span>
        </a>
        <a href="${pageContext.request.contextPath}/citizen/report-issue" class="sidebar-link ${param.activePage == 'report' ? 'active' : ''}">
            <i class="bi bi-plus-circle"></i>
            <span>Report New Issue</span>
        </a>
        <a href="${pageContext.request.contextPath}/citizen/my-complaints" class="sidebar-link ${param.activePage == 'complaints' ? 'active' : ''}">
            <i class="bi bi-file-earmark-text"></i>
            <span>My Complaints</span>
        </a>
        <a href="${pageContext.request.contextPath}/citizen/notifications" class="sidebar-link ${param.activePage == 'notifications' ? 'active' : ''}">
            <i class="bi bi-bell"></i>
            <span>Notifications</span>
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

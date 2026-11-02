<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav class="navbar navbar-expand-lg public-navbar sticky-top">
    <div class="container-fluid px-lg-4">
        <a class="brand-logo" href="${pageContext.request.contextPath}/index.jsp">
            <i class="bi bi-shield-check"></i>
            <span>Civic<span style="color: var(--civic-accent);">Connect</span></span>
        </a>
        
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#topNavContent">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="topNavContent">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-4">
                <li class="nav-item">
                    <a class="nav-link fw-semibold" href="${pageContext.request.contextPath}/index.jsp">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link fw-semibold" href="${pageContext.request.contextPath}/track">Track Issue</a>
                </li>
            </ul>

            <div class="d-flex align-items-center gap-3">
                <c:choose>
                    <c:when test="${not empty sessionScope.currentUser}">
                        <!-- Logged In User Navigation Elements -->
                        <c:if test="${sessionScope.currentUser.citizen}">
                            <a href="${pageContext.request.contextPath}/citizen/report-issue" class="btn btn-civic-accent btn-sm d-none d-md-inline-flex align-items-center gap-1">
                                <i class="bi bi-plus-circle"></i> Report Issue
                            </a>
                            <a href="${pageContext.request.contextPath}/citizen/notifications" class="btn btn-light btn-sm position-relative rounded-circle p-2" title="Notifications">
                                <i class="bi bi-bell fs-5 text-secondary"></i>
                            </a>
                        </c:if>

                        <div class="dropdown">
                            <button class="btn btn-light dropdown-toggle d-flex align-items-center gap-2 border" type="button" data-bs-toggle="dropdown">
                                <span class="badge ${sessionScope.currentUser.admin ? 'bg-danger' : (sessionScope.currentUser.staff ? 'bg-primary' : 'bg-success')} rounded-pill text-uppercase">
                                    ${sessionScope.currentUser.role}
                                </span>
                                <span class="fw-semibold text-truncate" style="max-width: 140px;">${sessionScope.currentUser.fullName}</span>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end shadow-sm">
                                <li>
                                    <h6 class="dropdown-header text-muted">${sessionScope.currentUser.username}</h6>
                                </li>
                                <li>
                                    <c:choose>
                                        <c:when test="${sessionScope.currentUser.admin}">
                                            <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-speedometer2 me-2"></i> Admin Dashboard</a>
                                        </c:when>
                                        <c:when test="${sessionScope.currentUser.staff}">
                                            <a class="dropdown-item" href="${pageContext.request.contextPath}/staff/dashboard"><i class="bi bi-speedometer2 me-2"></i> Staff Dashboard</a>
                                        </c:when>
                                        <c:otherwise>
                                            <a class="dropdown-item" href="${pageContext.request.contextPath}/citizen/dashboard"><i class="bi bi-speedometer2 me-2"></i> Citizen Dashboard</a>
                                        </c:otherwise>
                                    </c:choose>
                                </li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile"><i class="bi bi-person-gear me-2"></i> My Profile</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item text-danger fw-semibold" href="${pageContext.request.contextPath}/logout">
                                        <i class="bi bi-box-arrow-right me-2"></i> Logout
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Public Guest Options -->
                        <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-outline-dark fw-semibold">Login</a>
                        <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-civic-accent">Citizen Register</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>

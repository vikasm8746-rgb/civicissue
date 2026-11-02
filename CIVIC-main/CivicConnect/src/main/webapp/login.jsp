<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="pageTitle" value="Login – CivicConnect Portal"/>
</jsp:include>

<jsp:include page="/WEB-INF/includes/navbar.jsp"/>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-5">
            <div class="civic-card p-4 p-md-5 shadow-lg">
                <div class="text-center mb-4">
                    <div class="stat-card-icon bg-primary bg-opacity-10 text-primary mx-auto mb-3" style="width: 56px; height: 56px;">
                        <i class="bi bi-shield-lock-fill fs-3"></i>
                    </div>
                    <h3 class="fw-bold brand-font mb-1">Account Login</h3>
                    <p class="text-muted small">Access your Citizen, Staff, or Admin Portal</p>
                </div>

                <jsp:include page="/WEB-INF/includes/alerts.jsp"/>

                <form action="${pageContext.request.contextPath}/login" method="POST">
                    <div class="mb-3">
                        <label for="username" class="form-label fw-semibold small text-uppercase text-muted">Username or Email</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="bi bi-person"></i></span>
                            <input type="text" class="form-control" id="username" name="username" value="${enteredUsername}" placeholder="Enter username or email" required autofocus>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label for="password" class="form-label fw-semibold small text-uppercase text-muted">Password</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="bi bi-key"></i></span>
                            <input type="password" class="form-control" id="password" name="password" placeholder="Enter password" required>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-civic-primary w-100 py-2 mb-3 shadow-sm">
                        <i class="bi bi-box-arrow-in-right me-1"></i> Sign In to Portal
                    </button>
                </form>

                <!-- Quick Demo Login Helpers -->
                <div class="p-3 bg-light rounded border mt-3">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <small class="fw-bold text-muted text-uppercase" style="font-size: 0.75rem;">1-Click Demo Fill</small>
                        <small class="text-muted" style="font-size: 0.75rem;">Click to Autofill</small>
                    </div>
                    <div class="d-flex flex-wrap gap-2">
                        <span class="demo-pill" onclick="fillDemoCredentials('admin', 'admin123')">
                            <span class="badge bg-danger">ADMIN</span> admin
                        </span>
                        <span class="demo-pill" onclick="fillDemoCredentials('staff_roads', 'staff123')">
                            <span class="badge bg-primary">STAFF</span> staff_roads
                        </span>
                        <span class="demo-pill" onclick="fillDemoCredentials('citizen', 'citizen123')">
                            <span class="badge bg-success">CITIZEN</span> citizen
                        </span>
                    </div>
                </div>

                <div class="text-center mt-4 pt-3 border-top">
                    <p class="text-muted small mb-0">Don't have an account? <a href="${pageContext.request.contextPath}/register.jsp" class="fw-bold text-success text-decoration-none">Register as Citizen</a></p>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="pageTitle" value="Staff Profile – CivicConnect"/>
</jsp:include>

<jsp:include page="/WEB-INF/includes/navbar.jsp"/>

<div class="dashboard-wrapper">
    <jsp:include page="/WEB-INF/includes/sidebar-staff.jsp">
        <jsp:param name="activePage" value="profile"/>
    </jsp:include>

    <main class="main-content">
        <div class="container-fluid">
            <div class="mb-4">
                <h2 class="fw-bold brand-font mb-1">Staff Officer Profile</h2>
                <p class="text-muted small mb-0">Department: <span class="fw-bold text-dark">${user.departmentName != null ? user.departmentName : 'General'}</span></p>
            </div>

            <jsp:include page="/WEB-INF/includes/alerts.jsp"/>

            <div class="row g-4">
                <div class="col-lg-7">
                    <div class="civic-card p-4 h-100">
                        <h5 class="fw-bold brand-font mb-3"><i class="bi bi-person-circle text-primary me-2"></i>Officer Information</h5>
                        <form action="${pageContext.request.contextPath}/profile" method="POST">
                            <input type="hidden" name="action" value="updateProfile">

                            <div class="mb-3">
                                <label class="form-label small fw-semibold text-muted text-uppercase">Username</label>
                                <input type="text" class="form-control bg-light" value="${user.username}" readonly>
                            </div>

                            <div class="mb-3">
                                <label for="fullName" class="form-label small fw-semibold text-muted text-uppercase">Full Name</label>
                                <input type="text" class="form-control" id="fullName" name="fullName" value="${user.fullName}" required>
                            </div>

                            <div class="mb-3">
                                <label for="email" class="form-label small fw-semibold text-muted text-uppercase">Official Email</label>
                                <input type="email" class="form-control" id="email" name="email" value="${user.email}" required>
                            </div>

                            <div class="mb-4">
                                <label for="phone" class="form-label small fw-semibold text-muted text-uppercase">Contact Number</label>
                                <input type="tel" class="form-control" id="phone" name="phone" value="${user.phone}" pattern="[0-9]{10}" required>
                            </div>

                            <button type="submit" class="btn btn-civic-primary px-4">
                                <i class="bi bi-save me-1"></i> Save Changes
                            </button>
                        </form>
                    </div>
                </div>

                <div class="col-lg-5">
                    <div class="civic-card p-4 h-100">
                        <h5 class="fw-bold brand-font mb-3"><i class="bi bi-key-fill text-warning me-2"></i>Change Password</h5>
                        <form action="${pageContext.request.contextPath}/profile" method="POST">
                            <input type="hidden" name="action" value="changePassword">

                            <div class="mb-3">
                                <label for="currentPassword" class="form-label small fw-semibold text-muted text-uppercase">Current Password</label>
                                <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                            </div>

                            <div class="mb-3">
                                <label for="newPassword" class="form-label small fw-semibold text-muted text-uppercase">New Password</label>
                                <input type="password" class="form-control" id="newPassword" name="newPassword" minlength="6" required>
                            </div>

                            <div class="mb-4">
                                <label for="confirmPassword" class="form-label small fw-semibold text-muted text-uppercase">Confirm New Password</label>
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" minlength="6" required>
                            </div>

                            <button type="submit" class="btn btn-outline-danger w-100 fw-semibold">
                                <i class="bi bi-lock me-1"></i> Update Password
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="pageTitle" value="Citizen Registration – CivicConnect"/>
</jsp:include>

<jsp:include page="/WEB-INF/includes/navbar.jsp"/>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-9 col-lg-7">
            <div class="civic-card p-4 p-md-5 shadow-lg">
                <div class="text-center mb-4">
                    <div class="stat-card-icon bg-success bg-opacity-10 text-success mx-auto mb-3" style="width: 56px; height: 56px;">
                        <i class="bi bi-person-plus-fill fs-3"></i>
                    </div>
                    <h3 class="fw-bold brand-font mb-1">Citizen Registration</h3>
                    <p class="text-muted small">Join CivicConnect to report civic issues and track resolutions in your ward</p>
                </div>

                <jsp:include page="/WEB-INF/includes/alerts.jsp"/>

                <form action="${pageContext.request.contextPath}/register" method="POST" class="needs-validation">
                    <div class="row g-3">
                        <div class="col-md-12">
                            <label for="fullName" class="form-label fw-semibold small text-muted text-uppercase">Full Name</label>
                            <input type="text" class="form-control" id="fullName" name="fullName" value="${fullName}" placeholder="e.g. Rahul Sharma" required>
                        </div>

                        <div class="col-md-6">
                            <label for="email" class="form-label fw-semibold small text-muted text-uppercase">Email Address</label>
                            <input type="email" class="form-control" id="email" name="email" value="${email}" placeholder="rahul@example.com" required>
                        </div>

                        <div class="col-md-6">
                            <label for="phone" class="form-label fw-semibold small text-muted text-uppercase">Mobile Number</label>
                            <input type="tel" class="form-control" id="phone" name="phone" value="${phone}" placeholder="10-digit mobile number" pattern="[0-9]{10}" title="Please enter a valid 10-digit phone number" required>
                        </div>

                        <div class="col-md-12">
                            <label for="username" class="form-label fw-semibold small text-muted text-uppercase">Username</label>
                            <input type="text" class="form-control" id="username" name="username" value="${username}" placeholder="Choose a unique username" minlength="3" required>
                        </div>

                        <div class="col-md-6">
                            <label for="password" class="form-label fw-semibold small text-muted text-uppercase">Password</label>
                            <input type="password" class="form-control" id="password" name="password" placeholder="At least 6 characters" minlength="6" required>
                        </div>

                        <div class="col-md-6">
                            <label for="confirmPassword" class="form-label fw-semibold small text-muted text-uppercase">Confirm Password</label>
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Re-enter password" minlength="6" required>
                        </div>
                    </div>

                    <div class="form-check my-3">
                        <input class="form-check-input" type="checkbox" id="termsCheck" required checked>
                        <label class="form-check-label small text-muted" for="termsCheck">
                            I agree to the municipal citizen code of conduct and grievance reporting policies.
                        </label>
                    </div>

                    <button type="submit" class="btn btn-civic-accent w-100 py-2 shadow-sm mb-3">
                        <i class="bi bi-check2-circle me-1"></i> Register My Account
                    </button>
                </form>

                <div class="text-center mt-3 pt-3 border-top">
                    <p class="text-muted small mb-0">Already registered? <a href="${pageContext.request.contextPath}/login.jsp" class="fw-bold text-primary text-decoration-none">Sign In Here</a></p>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp"/>

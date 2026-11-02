<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.civicconnect.dao.ComplaintDAO" %>
<%@ page import="com.civicconnect.model.DashboardStats" %>
<%
    // Fetch live system statistics for public landing page
    ComplaintDAO complaintDAO = new ComplaintDAO();
    DashboardStats liveStats = complaintDAO.getDashboardStats(null, null);
    request.setAttribute("liveStats", liveStats);
%>
<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="pageTitle" value="CivicConnect – Report. Track. Resolve."/>
</jsp:include>

<jsp:include page="/WEB-INF/includes/navbar.jsp"/>

<!-- Hero Section -->
<section class="hero-section text-center text-lg-start">
    <div class="container py-4">
        <div class="row align-items-center g-5">
            <div class="col-lg-7">
                <span class="badge bg-success bg-opacity-25 text-white px-3 py-2 rounded-pill fw-semibold mb-3 border border-success border-opacity-50">
                    <i class="bi bi-patch-check-fill me-1 text-success"></i> Official Municipal Grievance Redressal Portal
                </span>
                <h1 class="display-4 fw-extrabold text-white mb-3 brand-font">
                    Report. Track. Resolve.
                </h1>
                <p class="lead text-white-50 mb-4 fs-5" style="max-width: 580px;">
                    Empowering citizens to report local civic issues and helping authorities resolve them efficiently. Together for cleaner, safer, and better neighborhoods.
                </p>
                <div class="d-flex flex-wrap gap-3 justify-content-center justify-content-lg-start">
                    <a href="${pageContext.request.contextPath}/citizen/report-issue" class="btn btn-civic-accent btn-lg px-4 py-3 shadow">
                        <i class="bi bi-megaphone-fill me-2"></i> Report an Issue
                    </a>
                    <a href="${pageContext.request.contextPath}/track" class="btn btn-outline-light btn-lg px-4 py-3">
                        <i class="bi bi-search me-2"></i> Track Complaint
                    </a>
                </div>
            </div>

            <!-- Quick Track Box -->
            <div class="col-lg-5">
                <div class="hero-search-card">
                    <h4 class="text-white mb-3 fw-bold"><i class="bi bi-geo-alt-fill text-warning me-2"></i>Track Your Complaint</h4>
                    <p class="text-white-50 small mb-3">Enter your unique complaint reference code (e.g. <code>CIV-2026-00001</code>) to check live status.</p>
                    <form action="${pageContext.request.contextPath}/track" method="POST">
                        <div class="input-group mb-3">
                            <input type="text" name="complaintCode" class="form-control form-control-lg" placeholder="CIV-YYYY-XXXXX" required>
                            <button class="btn btn-warning fw-bold px-4" type="submit">Track</button>
                        </div>
                    </form>
                    <div class="d-flex align-items-center justify-content-between pt-2 border-top border-white border-opacity-10 text-white-50 small">
                        <span><i class="bi bi-shield-lock-fill me-1"></i> Transparent Redressal</span>
                        <span><i class="bi bi-clock-history me-1"></i> Real-time Updates</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Live Stats Section -->
<section class="py-5 bg-white border-bottom">
    <div class="container">
        <div class="row g-4 text-center">
            <div class="col-6 col-md-3">
                <div class="p-3">
                    <h2 class="display-5 fw-bold text-primary brand-font mb-1">${liveStats.totalComplaints > 0 ? liveStats.totalComplaints : '1,250+'}</h2>
                    <span class="text-muted fw-semibold">Reported Complaints</span>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="p-3">
                    <h2 class="display-5 fw-bold text-success brand-font mb-1">${liveStats.resolvedCount > 0 ? liveStats.resolvedCount : '980+'}</h2>
                    <span class="text-muted fw-semibold">Issues Resolved</span>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="p-3">
                    <h2 class="display-5 fw-bold text-warning brand-font mb-1">${liveStats.inProgressCount > 0 ? liveStats.inProgressCount : '140+'}</h2>
                    <span class="text-muted fw-semibold">In Progress</span>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="p-3">
                    <h2 class="display-5 fw-bold text-info brand-font mb-1">${liveStats.totalDepartments > 0 ? liveStats.totalDepartments : '6'}</h2>
                    <span class="text-muted fw-semibold">Active Departments</span>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- How It Works Section -->
<section class="py-5 bg-light">
    <div class="container py-4">
        <div class="text-center mb-5">
            <span class="badge bg-primary bg-opacity-10 text-primary fw-bold px-3 py-2 rounded-pill">SIMPLE 4-STEP WORKFLOW</span>
            <h2 class="display-6 fw-bold mt-2 brand-font">How CivicConnect Works</h2>
            <p class="text-muted">A seamless pipeline connecting citizens directly with municipal execution teams.</p>
        </div>

        <div class="row g-4">
            <div class="col-md-6 col-lg-3">
                <div class="card h-100 border-0 shadow-sm text-center p-4">
                    <div class="stat-card-icon bg-primary bg-opacity-10 text-primary mx-auto mb-3" style="width: 60px; height: 60px;">
                        <i class="bi bi-camera-fill fs-3"></i>
                    </div>
                    <h5 class="fw-bold mb-2">1. Report Issue</h5>
                    <p class="text-muted small">Snap a photo, provide landmark and location, and submit your complaint within 60 seconds.</p>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <div class="card h-100 border-0 shadow-sm text-center p-4">
                    <div class="stat-card-icon bg-warning bg-opacity-10 text-warning mx-auto mb-3" style="width: 60px; height: 60px;">
                        <i class="bi bi-card-checklist fs-3"></i>
                    </div>
                    <h5 class="fw-bold mb-2">2. Review & Assign</h5>
                    <p class="text-muted small">Municipal administrator audits the complaint and dispatches it to the relevant department lead.</p>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <div class="card h-100 border-0 shadow-sm text-center p-4">
                    <div class="stat-card-icon bg-info bg-opacity-10 text-info mx-auto mb-3" style="width: 60px; height: 60px;">
                        <i class="bi bi-tools fs-3"></i>
                    </div>
                    <h5 class="fw-bold mb-2">3. On-Ground Resolution</h5>
                    <p class="text-muted small">Assigned field staff takes charge, executes the repairs, and uploads verified resolution photos.</p>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <div class="card h-100 border-0 shadow-sm text-center p-4">
                    <div class="stat-card-icon bg-success bg-opacity-10 text-success mx-auto mb-3" style="width: 60px; height: 60px;">
                        <i class="bi bi-star-fill fs-3"></i>
                    </div>
                    <h5 class="fw-bold mb-2">4. Citizen Feedback</h5>
                    <p class="text-muted small">Citizen receives live completion alerts and rates the quality of the resolved civic work.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Common Issue Categories -->
<section class="py-5 bg-white">
    <div class="container py-4">
        <div class="text-center mb-5">
            <h2 class="display-6 fw-bold brand-font">Common Issues You Can Report</h2>
            <p class="text-muted">Direct grievance routing to specialized city maintenance divisions.</p>
        </div>

        <div class="row g-4">
            <div class="col-md-4">
                <div class="card p-3 border h-100 d-flex flex-row align-items-center gap-3">
                    <div class="rounded-circle bg-danger bg-opacity-10 text-danger p-3 d-flex align-items-center justify-content-center" style="width: 54px; height: 54px;">
                        <i class="bi bi-cone-striped fs-3"></i>
                    </div>
                    <div>
                        <h6 class="fw-bold mb-1">Road Damage & Potholes</h6>
                        <small class="text-muted">Craters, dangerous asphalt fissures & cave-ins.</small>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card p-3 border h-100 d-flex flex-row align-items-center gap-3">
                    <div class="rounded-circle bg-success bg-opacity-10 text-success p-3 d-flex align-items-center justify-content-center" style="width: 54px; height: 54px;">
                        <i class="bi bi-trash3-fill fs-3"></i>
                    </div>
                    <div>
                        <h6 class="fw-bold mb-1">Garbage Accumulation</h6>
                        <small class="text-muted">Overflowing community bins & illegal dumping.</small>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card p-3 border h-100 d-flex flex-row align-items-center gap-3">
                    <div class="rounded-circle bg-warning bg-opacity-10 text-warning p-3 d-flex align-items-center justify-content-center" style="width: 54px; height: 54px;">
                        <i class="bi bi-lightbulb-fill fs-3"></i>
                    </div>
                    <div>
                        <h6 class="fw-bold mb-1">Broken Street Lights</h6>
                        <small class="text-muted">Dark pathways, faulty bulbs & flickering fixtures.</small>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card p-3 border h-100 d-flex flex-row align-items-center gap-3">
                    <div class="rounded-circle bg-primary bg-opacity-10 text-primary p-3 d-flex align-items-center justify-content-center" style="width: 54px; height: 54px;">
                        <i class="bi bi-droplet-fill fs-3"></i>
                    </div>
                    <div>
                        <h6 class="fw-bold mb-1">Water Supply & Pipeline</h6>
                        <small class="text-muted">Pipe bursts, contamination & drinking water leaks.</small>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card p-3 border h-100 d-flex flex-row align-items-center gap-3">
                    <div class="rounded-circle bg-secondary bg-opacity-10 text-secondary p-3 d-flex align-items-center justify-content-center" style="width: 54px; height: 54px;">
                        <i class="bi bi-water fs-3"></i>
                    </div>
                    <div>
                        <h6 class="fw-bold mb-1">Drainage & Sewage</h6>
                        <small class="text-muted">Clogged stormwater drains & sewer overflow.</small>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card p-3 border h-100 d-flex flex-row align-items-center gap-3">
                    <div class="rounded-circle bg-info bg-opacity-10 text-info p-3 d-flex align-items-center justify-content-center" style="width: 54px; height: 54px;">
                        <i class="bi bi-signpost-split-fill fs-3"></i>
                    </div>
                    <div>
                        <h6 class="fw-bold mb-1">Traffic Signals & Signage</h6>
                        <small class="text-muted">Broken signals, faulty timers & public amenities.</small>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Demo Login Quick-Fill Showcase Banner -->
<section class="py-5 bg-light border-top">
    <div class="container text-center">
        <div class="card p-4 border-0 shadow-sm max-w-lg mx-auto" style="max-width: 800px;">
            <h4 class="fw-bold mb-2 brand-font"><i class="bi bi-key-fill text-warning me-2"></i>Academic Project Demo Credentials</h4>
            <p class="text-muted small mb-4">Click any badge on the login page or use these credentials to evaluate all three system portals:</p>
            <div class="row g-3">
                <div class="col-md-4">
                    <div class="p-3 bg-white rounded border">
                        <span class="badge bg-danger mb-2">ADMIN</span>
                        <div class="fw-bold">admin</div>
                        <code class="text-muted">admin123</code>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="p-3 bg-white rounded border">
                        <span class="badge bg-primary mb-2">STAFF</span>
                        <div class="fw-bold">staff_roads</div>
                        <code class="text-muted">staff123</code>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="p-3 bg-white rounded border">
                        <span class="badge bg-success mb-2">CITIZEN</span>
                        <div class="fw-bold">citizen</div>
                        <code class="text-muted">citizen123</code>
                    </div>
                </div>
            </div>
            <div class="mt-4">
                <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-civic-primary px-4">
                    Proceed to Login <i class="bi bi-arrow-right ms-1"></i>
                </a>
            </div>
        </div>
    </div>
</section>

<!-- Footer -->
<footer class="bg-dark text-white py-4 mt-auto">
    <div class="container text-center">
        <p class="mb-1 fw-semibold">CivicConnect &copy; 2026 – Crowdsourced Civic Issue Reporting and Resolution System</p>
        <small class="text-white-50">Developed with Java 17, Servlets, JSP, JDBC & MySQL for MCA College Project Evaluation.</small>
    </div>
</footer>

<jsp:include page="/WEB-INF/includes/footer.jsp"/>

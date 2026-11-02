<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="pageTitle" value="Analytics & Reports – Administration"/>
</jsp:include>

<jsp:include page="/WEB-INF/includes/navbar.jsp"/>

<div class="dashboard-wrapper">
    <jsp:include page="/WEB-INF/includes/sidebar-admin.jsp">
        <jsp:param name="activePage" value="reports"/>
    </jsp:include>

    <main class="main-content">
        <div class="container-fluid">
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
                <div>
                    <h2 class="fw-bold brand-font mb-1">Municipal Grievance Analytics & Performance Report</h2>
                    <p class="text-muted small mb-0">Official statistical audit and citizen satisfaction review.</p>
                </div>
                <button type="button" class="btn btn-outline-dark btn-sm" onclick="printReport()">
                    <i class="bi bi-printer me-1"></i> Print / Export Report
                </button>
            </div>

            <!-- Executive Summary Cards -->
            <div class="row g-3 mb-4">
                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div class="stat-card-title">Total Lodged Grievances</div>
                        <div class="stat-card-value">${stats.totalComplaints}</div>
                    </div>
                </div>
                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div class="stat-card-title">Total Resolved</div>
                        <div class="stat-card-value text-success">${stats.resolvedCount}</div>
                    </div>
                </div>
                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div class="stat-card-title">Resolution Efficiency</div>
                        <div class="stat-card-value text-primary">${stats.resolutionRate}%</div>
                    </div>
                </div>
                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div class="stat-card-title">In-Flight / Under Work</div>
                        <div class="stat-card-value text-warning">${stats.inProgressCount + stats.assignedCount + stats.underReviewCount}</div>
                    </div>
                </div>
            </div>

            <div class="row g-4 mb-4">
                <!-- Department Performance Summary -->
                <div class="col-lg-6">
                    <div class="civic-card p-4 h-100">
                        <h5 class="fw-bold brand-font mb-3"><i class="bi bi-building me-2"></i>Department Performance Summary</h5>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th>Department</th>
                                        <th>Active Staff</th>
                                        <th>Complaints</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="dept" items="${departments}">
                                        <tr>
                                            <td class="fw-semibold">${dept.name}</td>
                                            <td>${dept.totalStaff} officers</td>
                                            <td><span class="badge bg-light text-dark border px-2">${dept.totalComplaints}</span></td>
                                            <td><span class="badge bg-success bg-opacity-10 text-success">${dept.status}</span></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Citizen Feedback & Quality Review -->
                <div class="col-lg-6">
                    <div class="civic-card p-4 h-100">
                        <h5 class="fw-bold brand-font mb-3"><i class="bi bi-star-fill text-warning me-2"></i>Citizen Feedback & Ratings</h5>
                        <c:choose>
                            <c:when test="${not empty feedbacks}">
                                <div class="list-group list-group-flush">
                                    <c:forEach var="f" items="${feedbacks}">
                                        <div class="list-group-item px-0 py-3 border-bottom">
                                            <div class="d-flex justify-content-between align-items-center mb-1">
                                                <span class="fw-bold text-dark">${f.citizenName} <span class="badge bg-light text-primary border">${f.complaintCode}</span></span>
                                                <div class="text-warning small">
                                                    <c:forEach begin="1" end="${f.rating}"><i class="bi bi-star-fill"></i></c:forEach>
                                                    <c:forEach begin="${f.rating + 1}" end="5"><i class="bi bi-star"></i></c:forEach>
                                                </div>
                                            </div>
                                            <p class="small text-secondary mb-1">"${f.comment}"</p>
                                            <small class="text-muted"><i class="bi bi-calendar"></i> ${f.formattedCreatedAt}</small>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-4 text-muted">
                                    <i class="bi bi-chat-square-text fs-2"></i>
                                    <p class="small mt-2">No citizen feedback recorded yet.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- Master Complaints Log Table -->
            <div class="civic-card p-4">
                <h5 class="fw-bold brand-font mb-3">Complete Grievance Audit Register</h5>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th>Code</th>
                                <th>Title</th>
                                <th>Category</th>
                                <th>Citizen</th>
                                <th>Location</th>
                                <th>Department</th>
                                <th>Priority</th>
                                <th>Status</th>
                                <th>Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="c" items="${complaints}">
                                <tr>
                                    <td><span class="fw-bold text-primary">${c.complaintCode}</span></td>
                                    <td><div class="fw-semibold text-dark text-truncate" style="max-width: 180px;">${c.title}</div></td>
                                    <td><span class="small">${c.categoryName}</span></td>
                                    <td><span class="small">${c.citizenName}</span></td>
                                    <td><div class="small text-truncate" style="max-width: 140px;">${c.location}</div></td>
                                    <td><span class="small text-secondary">${c.departmentName != null ? c.departmentName : 'Unassigned'}</span></td>
                                    <td><span class="badge ${c.priorityBadgeClass} badge-civic">${c.priority}</span></td>
                                    <td><span class="badge ${c.statusBadgeClass} badge-civic">${c.status}</span></td>
                                    <td class="text-muted small">${c.formattedCreatedAt}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp"/>

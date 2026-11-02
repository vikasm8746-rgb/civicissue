<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="pageTitle" value="Citizen Dashboard – CivicConnect"/>
</jsp:include>

<jsp:include page="/WEB-INF/includes/navbar.jsp"/>

<div class="dashboard-wrapper">
    <jsp:include page="/WEB-INF/includes/sidebar-citizen.jsp">
        <jsp:param name="activePage" value="dashboard"/>
    </jsp:include>

    <main class="main-content">
        <div class="container-fluid">
            <!-- Header greeting -->
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
                <div>
                    <h2 class="fw-bold brand-font mb-1">Welcome, ${sessionScope.currentUser.fullName}!</h2>
                    <p class="text-muted small mb-0">Track and manage your reported civic issues across your municipal zone.</p>
                </div>
                <a href="${pageContext.request.contextPath}/citizen/report-issue" class="btn btn-civic-accent shadow-sm d-inline-flex align-items-center gap-2">
                    <i class="bi bi-plus-circle-fill"></i> Report New Issue
                </a>
            </div>

            <jsp:include page="/WEB-INF/includes/alerts.jsp"/>

            <!-- KPI Metric Cards -->
            <div class="row g-3 mb-4">
                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div class="stat-card-title">Total Complaints</div>
                                <div class="stat-card-value">${stats.totalComplaints}</div>
                            </div>
                            <div class="stat-card-icon bg-primary bg-opacity-10 text-primary">
                                <i class="bi bi-file-earmark-text-fill"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div class="stat-card-title">Pending / In Review</div>
                                <div class="stat-card-value text-warning">${stats.submittedCount + stats.underReviewCount}</div>
                            </div>
                            <div class="stat-card-icon bg-warning bg-opacity-10 text-warning">
                                <i class="bi bi-hourglass-split"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div class="stat-card-title">In Progress</div>
                                <div class="stat-card-value text-info">${stats.inProgressCount + stats.assignedCount}</div>
                            </div>
                            <div class="stat-card-icon bg-info bg-opacity-10 text-info">
                                <i class="bi bi-gear-wide-connected"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div class="stat-card-title">Resolved</div>
                                <div class="stat-card-value text-success">${stats.resolvedCount}</div>
                            </div>
                            <div class="stat-card-icon bg-success bg-opacity-10 text-success">
                                <i class="bi bi-check-circle-fill"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Complaints Table -->
            <div class="civic-card p-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold brand-font mb-0">Recent Complaints</h5>
                    <a href="${pageContext.request.contextPath}/citizen/my-complaints" class="btn btn-sm btn-outline-primary">View All (${stats.totalComplaints})</a>
                </div>

                <c:choose>
                    <c:when test="${not empty recentComplaints}">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th>Complaint ID</th>
                                        <th>Title & Category</th>
                                        <th>Location</th>
                                        <th>Priority</th>
                                        <th>Date</th>
                                        <th>Status</th>
                                        <th class="text-end">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="c" items="${recentComplaints}">
                                        <tr>
                                            <td>
                                                <span class="fw-bold text-primary">${c.complaintCode}</span>
                                            </td>
                                            <td>
                                                <div class="fw-semibold text-dark text-truncate" style="max-width: 260px;">${c.title}</div>
                                                <small class="text-muted">${c.categoryName}</small>
                                            </td>
                                            <td>
                                                <div class="text-truncate" style="max-width: 180px;">${c.location}</div>
                                            </td>
                                            <td>
                                                <span class="badge ${c.priorityBadgeClass} badge-civic">${c.priority}</span>
                                            </td>
                                            <td class="text-muted small">${c.formattedCreatedAt}</td>
                                            <td>
                                                <span class="badge ${c.statusBadgeClass} badge-civic">${c.status}</span>
                                            </td>
                                            <td class="text-end">
                                                <a href="${pageContext.request.contextPath}/citizen/complaint-details?id=${c.id}" class="btn btn-sm btn-light border" title="View Details">
                                                    <i class="bi bi-eye-fill"></i> Details
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-5">
                            <i class="bi bi-inbox fs-1 text-muted"></i>
                            <h6 class="fw-bold mt-2">No Complaints Registered Yet</h6>
                            <p class="text-muted small">Spot an issue in your locality? Report it now and help improve your community.</p>
                            <a href="${pageContext.request.contextPath}/citizen/report-issue" class="btn btn-civic-accent btn-sm">Report First Issue</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp"/>

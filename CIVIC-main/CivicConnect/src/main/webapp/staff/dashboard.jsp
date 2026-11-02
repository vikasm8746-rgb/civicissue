<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="pageTitle" value="Staff Dashboard – CivicConnect"/>
</jsp:include>

<jsp:include page="/WEB-INF/includes/navbar.jsp"/>

<div class="dashboard-wrapper">
    <jsp:include page="/WEB-INF/includes/sidebar-staff.jsp">
        <jsp:param name="activePage" value="dashboard"/>
    </jsp:include>

    <main class="main-content">
        <div class="container-fluid">
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
                <div>
                    <h2 class="fw-bold brand-font mb-1">Staff Workload Dashboard</h2>
                    <p class="text-muted small mb-0">Officer: <span class="fw-bold text-dark">${sessionScope.currentUser.fullName}</span> &bull; ${sessionScope.currentUser.departmentName != null ? sessionScope.currentUser.departmentName : 'Municipal Department'}</p>
                </div>
            </div>

            <jsp:include page="/WEB-INF/includes/alerts.jsp"/>

            <!-- Metric Cards -->
            <div class="row g-3 mb-4">
                <div class="col-sm-6 col-xl-4">
                    <div class="stat-card">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div class="stat-card-title">Assigned (New)</div>
                                <div class="stat-card-value text-primary">${stats.assignedCount}</div>
                            </div>
                            <div class="stat-card-icon bg-primary bg-opacity-10 text-primary">
                                <i class="bi bi-inbox-fill"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-4">
                    <div class="stat-card">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div class="stat-card-title">In Progress / On Site</div>
                                <div class="stat-card-value text-warning">${stats.inProgressCount}</div>
                            </div>
                            <div class="stat-card-icon bg-warning bg-opacity-10 text-warning">
                                <i class="bi bi-tools"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-4">
                    <div class="stat-card">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div class="stat-card-title">Resolved By Me</div>
                                <div class="stat-card-value text-success">${stats.resolvedCount}</div>
                            </div>
                            <div class="stat-card-icon bg-success bg-opacity-10 text-success">
                                <i class="bi bi-patch-check-fill"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Assigned Complaints Workload Table -->
            <div class="civic-card p-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold brand-font mb-0">Assigned Complaints Workload</h5>
                    <a href="${pageContext.request.contextPath}/staff/assigned-complaints" class="btn btn-sm btn-outline-primary">View All Assigned</a>
                </div>

                <c:choose>
                    <c:when test="${not empty recentAssigned}">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th>Complaint ID</th>
                                        <th>Title & Category</th>
                                        <th>Citizen Details</th>
                                        <th>Location</th>
                                        <th>Priority</th>
                                        <th>Status</th>
                                        <th class="text-end">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="c" items="${recentAssigned}">
                                        <tr>
                                            <td>
                                                <span class="fw-bold text-primary">${c.complaintCode}</span>
                                            </td>
                                            <td>
                                                <div class="fw-semibold text-dark text-truncate" style="max-width: 240px;">${c.title}</div>
                                                <small class="text-muted">${c.categoryName}</small>
                                            </td>
                                            <td>
                                                <div class="fw-semibold">${c.citizenName}</div>
                                                <small class="text-muted"><i class="bi bi-telephone"></i> ${c.citizenPhone}</small>
                                            </td>
                                            <td>
                                                <div class="text-truncate" style="max-width: 170px;">${c.location}</div>
                                                <small class="text-muted">PIN: ${c.pincode}</small>
                                            </td>
                                            <td>
                                                <span class="badge ${c.priorityBadgeClass} badge-civic">${c.priority}</span>
                                            </td>
                                            <td>
                                                <span class="badge ${c.statusBadgeClass} badge-civic">${c.status}</span>
                                            </td>
                                            <td class="text-end">
                                                <a href="${pageContext.request.contextPath}/staff/complaint-details?id=${c.id}" class="btn btn-sm btn-civic-primary">
                                                    <i class="bi bi-pencil-square me-1"></i> Update / Resolve
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
                            <i class="bi bi-check2-all fs-1 text-success"></i>
                            <h5 class="fw-bold mt-2">No Pending Assigned Work</h5>
                            <p class="text-muted small">You have resolved all assigned tasks or none are currently assigned.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="pageTitle" value="Assigned Complaints – Staff Portal"/>
</jsp:include>

<jsp:include page="/WEB-INF/includes/navbar.jsp"/>

<div class="dashboard-wrapper">
    <jsp:include page="/WEB-INF/includes/sidebar-staff.jsp">
        <jsp:param name="activePage" value="assigned"/>
    </jsp:include>

    <main class="main-content">
        <div class="container-fluid">
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
                <div>
                    <h2 class="fw-bold brand-font mb-1">Assigned Grievances</h2>
                    <p class="text-muted small mb-0">List of civic complaints delegated to you for on-ground inspection and resolution.</p>
                </div>
            </div>

            <jsp:include page="/WEB-INF/includes/alerts.jsp"/>

            <!-- Search Filter -->
            <div class="civic-card p-3 mb-4">
                <div class="row g-3">
                    <div class="col-md-5">
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="bi bi-search"></i></span>
                            <input type="text" id="tableSearchInput" class="form-control" placeholder="Search by ID, title, or citizen name..." data-target-table="#staffComplaintsTable">
                        </div>
                    </div>
                </div>
            </div>

            <!-- Complaints Table -->
            <div class="civic-card p-4">
                <c:choose>
                    <c:when test="${not empty complaints}">
                        <div class="table-responsive">
                            <table id="staffComplaintsTable" class="table table-hover table-searchable align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th>Complaint ID</th>
                                        <th>Title & Category</th>
                                        <th>Citizen</th>
                                        <th>Location & PIN</th>
                                        <th>Priority</th>
                                        <th>Assigned Date</th>
                                        <th>Status</th>
                                        <th class="text-end">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="c" items="${complaints}">
                                        <tr>
                                            <td>
                                                <span class="fw-bold text-primary">${c.complaintCode}</span>
                                            </td>
                                            <td>
                                                <div class="fw-semibold text-dark text-truncate" style="max-width: 250px;">${c.title}</div>
                                                <small class="text-muted">${c.categoryName}</small>
                                            </td>
                                            <td>
                                                <div class="fw-semibold">${c.citizenName}</div>
                                                <small class="text-muted"><i class="bi bi-phone"></i> ${c.citizenPhone}</small>
                                            </td>
                                            <td>
                                                <div class="text-truncate" style="max-width: 170px;">${c.location}</div>
                                                <small class="text-muted">PIN: ${c.pincode}</small>
                                            </td>
                                            <td>
                                                <span class="badge ${c.priorityBadgeClass} badge-civic">${c.priority}</span>
                                            </td>
                                            <td class="text-muted small">${c.formattedCreatedAt}</td>
                                            <td>
                                                <span class="badge ${c.statusBadgeClass} badge-civic">${c.status}</span>
                                            </td>
                                            <td class="text-end">
                                                <a href="${pageContext.request.contextPath}/staff/complaint-details?id=${c.id}" class="btn btn-sm btn-civic-primary">
                                                    <i class="bi bi-gear-fill me-1"></i> Update Status
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
                            <h5 class="fw-bold mt-2">No Complaints Assigned</h5>
                            <p class="text-muted small">You do not have any complaints in your queue.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp"/>

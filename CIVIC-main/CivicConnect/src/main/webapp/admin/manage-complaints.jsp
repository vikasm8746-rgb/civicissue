<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="pageTitle" value="Manage Complaints – Administration"/>
</jsp:include>

<jsp:include page="/WEB-INF/includes/navbar.jsp"/>

<div class="dashboard-wrapper">
    <jsp:include page="/WEB-INF/includes/sidebar-admin.jsp">
        <jsp:param name="activePage" value="complaints"/>
    </jsp:include>

    <main class="main-content">
        <div class="container-fluid">
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
                <div>
                    <h2 class="fw-bold brand-font mb-1">Manage All Complaints</h2>
                    <p class="text-muted small mb-0">Total records: <span class="fw-bold text-dark">${totalRecords}</span> complaints found.</p>
                </div>
            </div>

            <jsp:include page="/WEB-INF/includes/alerts.jsp"/>

            <!-- Filters Card -->
            <div class="civic-card p-4 mb-4">
                <form action="${pageContext.request.contextPath}/admin/manage-complaints" method="GET" class="row g-3">
                    <div class="col-md-3">
                        <label class="form-label small text-muted fw-semibold">Status</label>
                        <select name="status" class="form-select form-select-sm">
                            <option value="ALL">All Statuses</option>
                            <option value="SUBMITTED" ${selectedStatus == 'SUBMITTED' ? 'selected' : ''}>SUBMITTED</option>
                            <option value="UNDER_REVIEW" ${selectedStatus == 'UNDER_REVIEW' ? 'selected' : ''}>UNDER REVIEW</option>
                            <option value="ASSIGNED" ${selectedStatus == 'ASSIGNED' ? 'selected' : ''}>ASSIGNED</option>
                            <option value="IN_PROGRESS" ${selectedStatus == 'IN_PROGRESS' ? 'selected' : ''}>IN PROGRESS</option>
                            <option value="RESOLVED" ${selectedStatus == 'RESOLVED' ? 'selected' : ''}>RESOLVED</option>
                            <option value="REJECTED" ${selectedStatus == 'REJECTED' ? 'selected' : ''}>REJECTED</option>
                        </select>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label small text-muted fw-semibold">Department</label>
                        <select name="departmentId" class="form-select form-select-sm">
                            <option value="0">All Departments</option>
                            <c:forEach var="d" items="${departments}">
                                <option value="${d.id}" ${selectedDept == d.id ? 'selected' : ''}>${d.name}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-md-2">
                        <label class="form-label small text-muted fw-semibold">Priority</label>
                        <select name="priority" class="form-select form-select-sm">
                            <option value="ALL">All Priorities</option>
                            <option value="LOW" ${selectedPriority == 'LOW' ? 'selected' : ''}>LOW</option>
                            <option value="MEDIUM" ${selectedPriority == 'MEDIUM' ? 'selected' : ''}>MEDIUM</option>
                            <option value="HIGH" ${selectedPriority == 'HIGH' ? 'selected' : ''}>HIGH</option>
                            <option value="CRITICAL" ${selectedPriority == 'CRITICAL' ? 'selected' : ''}>CRITICAL</option>
                        </select>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label small text-muted fw-semibold">Search Keywords</label>
                        <div class="input-group input-group-sm">
                            <input type="text" name="search" class="form-control" value="${searchQuery}" placeholder="ID, Title, Citizen, Location...">
                            <button type="submit" class="btn btn-primary"><i class="bi bi-filter"></i> Apply</button>
                            <a href="${pageContext.request.contextPath}/admin/manage-complaints" class="btn btn-outline-secondary">Reset</a>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Complaints Master Table -->
            <div class="civic-card p-4">
                <c:choose>
                    <c:when test="${not empty complaints}">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th>Complaint ID</th>
                                        <th>Title & Category</th>
                                        <th>Citizen</th>
                                        <th>Location</th>
                                        <th>Priority</th>
                                        <th>Department</th>
                                        <th>Status</th>
                                        <th>Reported</th>
                                        <th class="text-end">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="c" items="${complaints}">
                                        <tr>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/admin/complaint-details?id=${c.id}" class="fw-bold text-primary text-decoration-none">
                                                    ${c.complaintCode}
                                                </a>
                                            </td>
                                            <td>
                                                <div class="fw-semibold text-dark text-truncate" style="max-width: 220px;">${c.title}</div>
                                                <small class="text-muted">${c.categoryName}</small>
                                            </td>
                                            <td>
                                                <div class="small fw-semibold">${c.citizenName}</div>
                                                <small class="text-muted"><i class="bi bi-phone"></i> ${c.citizenPhone}</small>
                                            </td>
                                            <td>
                                                <div class="text-truncate small" style="max-width: 150px;">${c.location}</div>
                                                <small class="text-muted">PIN: ${c.pincode}</small>
                                            </td>
                                            <td>
                                                <span class="badge ${c.priorityBadgeClass} badge-civic">${c.priority}</span>
                                            </td>
                                            <td>
                                                <span class="small text-secondary">${c.departmentName != null ? c.departmentName : 'Unassigned'}</span>
                                            </td>
                                            <td>
                                                <span class="badge ${c.statusBadgeClass} badge-civic">${c.status}</span>
                                            </td>
                                            <td class="text-muted small">${c.formattedCreatedAt}</td>
                                            <td class="text-end">
                                                <div class="btn-group btn-group-sm">
                                                    <a href="${pageContext.request.contextPath}/admin/complaint-details?id=${c.id}" class="btn btn-light border" title="Manage & Assign">
                                                        <i class="bi bi-sliders"></i>
                                                    </a>
                                                    <button type="button" class="btn btn-outline-danger" title="Delete" data-bs-toggle="modal" data-bs-target="#deleteModal${c.id}">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </div>

                                                <!-- Delete Confirmation Modal -->
                                                <div class="modal fade" id="deleteModal${c.id}" tabindex="-1" aria-hidden="true">
                                                    <div class="modal-dialog modal-dialog-centered">
                                                        <div class="modal-content">
                                                            <div class="modal-header">
                                                                <h5 class="modal-title fw-bold text-danger"><i class="bi bi-exclamation-triangle-fill me-2"></i>Confirm Deletion</h5>
                                                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                            </div>
                                                            <div class="modal-body text-start">
                                                                Are you sure you want to permanently delete complaint <strong>${c.complaintCode}</strong> ("${c.title}")? This action cannot be undone.
                                                            </div>
                                                            <div class="modal-footer">
                                                                <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                                                                <form action="${pageContext.request.contextPath}/admin/delete-complaint" method="POST">
                                                                    <input type="hidden" name="complaintId" value="${c.id}">
                                                                    <button type="submit" class="btn btn-danger">Delete Complaint</button>
                                                                </form>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination Controls -->
                        <c:if test="${totalPages > 1}">
                            <nav class="mt-4 d-flex justify-content-center">
                                <ul class="pagination pagination-sm">
                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                        <a class="page-link" href="${pageContext.request.contextPath}/admin/manage-complaints?page=${currentPage - 1}&status=${selectedStatus}&departmentId=${selectedDept}&priority=${selectedPriority}&search=${searchQuery}">Previous</a>
                                    </li>
                                    <c:forEach begin="1" end="${totalPages}" var="p">
                                        <li class="page-item ${currentPage == p ? 'active' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/admin/manage-complaints?page=${p}&status=${selectedStatus}&departmentId=${selectedDept}&priority=${selectedPriority}&search=${searchQuery}">${p}</a>
                                        </li>
                                    </c:forEach>
                                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                        <a class="page-link" href="${pageContext.request.contextPath}/admin/manage-complaints?page=${currentPage + 1}&status=${selectedStatus}&departmentId=${selectedDept}&priority=${selectedPriority}&search=${searchQuery}">Next</a>
                                    </li>
                                </ul>
                            </nav>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-5">
                            <i class="bi bi-search fs-1 text-muted"></i>
                            <h5 class="fw-bold mt-2">No Complaints Matched Your Filter</h5>
                            <p class="text-muted small">Try changing the status, department, or keyword search criteria.</p>
                            <a href="${pageContext.request.contextPath}/admin/manage-complaints" class="btn btn-outline-primary btn-sm">Reset Filters</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp"/>

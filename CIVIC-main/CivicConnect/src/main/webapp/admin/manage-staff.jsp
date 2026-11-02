<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="pageTitle" value="Manage Staff – Administration"/>
</jsp:include>

<jsp:include page="/WEB-INF/includes/navbar.jsp"/>

<div class="dashboard-wrapper">
    <jsp:include page="/WEB-INF/includes/sidebar-admin.jsp">
        <jsp:param name="activePage" value="staff"/>
    </jsp:include>

    <main class="main-content">
        <div class="container-fluid">
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
                <div>
                    <h2 class="fw-bold brand-font mb-1">Municipal Field Staff Roster</h2>
                    <p class="text-muted small mb-0">Total Staff Officers: <span class="fw-bold text-dark">${staffList.size()}</span> members.</p>
                </div>
                <button type="button" class="btn btn-civic-accent shadow-sm" data-bs-toggle="modal" data-bs-target="#addStaffModal">
                    <i class="bi bi-person-plus-fill me-1"></i> Add New Staff Member
                </button>
            </div>

            <jsp:include page="/WEB-INF/includes/alerts.jsp"/>

            <!-- Search Filter -->
            <div class="civic-card p-3 mb-4">
                <div class="row g-3">
                    <div class="col-md-5">
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="bi bi-search"></i></span>
                            <input type="text" id="tableSearchInput" class="form-control" placeholder="Search staff by name, department, email..." data-target-table="#staffTable">
                        </div>
                    </div>
                </div>
            </div>

            <!-- Staff Roster Table -->
            <div class="civic-card p-4">
                <c:choose>
                    <c:when test="${not empty staffList}">
                        <div class="table-responsive">
                            <table id="staffTable" class="table table-hover table-searchable align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Officer Name</th>
                                        <th>Username</th>
                                        <th>Department</th>
                                        <th>Official Email</th>
                                        <th>Phone</th>
                                        <th>Status</th>
                                        <th class="text-end">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="s" items="${staffList}">
                                        <tr>
                                            <td class="text-muted">#${s.id}</td>
                                            <td>
                                                <div class="fw-bold text-dark">${s.fullName}</div>
                                            </td>
                                            <td><code>${s.username}</code></td>
                                            <td>
                                                <span class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-25 px-2 py-1">
                                                    ${s.departmentName != null ? s.departmentName : 'General'}
                                                </span>
                                            </td>
                                            <td>${s.email}</td>
                                            <td>${s.phone}</td>
                                            <td>
                                                <span class="badge ${s.status == 'ACTIVE' ? 'bg-success' : 'bg-secondary'} rounded-pill">
                                                    ${s.status}
                                                </span>
                                            </td>
                                            <td class="text-end">
                                                <div class="btn-group btn-group-sm">
                                                    <!-- Toggle Status -->
                                                    <form action="${pageContext.request.contextPath}/admin/toggle-user-status" method="POST" class="d-inline">
                                                        <input type="hidden" name="userId" value="${s.id}">
                                                        <input type="hidden" name="status" value="${s.status == 'ACTIVE' ? 'INACTIVE' : 'ACTIVE'}">
                                                        <input type="hidden" name="returnTo" value="staff">
                                                        <button type="submit" class="btn btn-light border" title="${s.status == 'ACTIVE' ? 'Deactivate' : 'Activate'}">
                                                            <i class="bi ${s.status == 'ACTIVE' ? 'bi-person-slash text-warning' : 'bi-person-check text-success'}"></i>
                                                        </button>
                                                    </form>

                                                    <!-- Delete Button -->
                                                    <button type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#deleteStaffModal${s.id}" title="Delete Staff">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </div>

                                                <!-- Delete Modal -->
                                                <div class="modal fade" id="deleteStaffModal${s.id}" tabindex="-1" aria-hidden="true">
                                                    <div class="modal-dialog modal-dialog-centered">
                                                        <div class="modal-content">
                                                            <div class="modal-header">
                                                                <h5 class="modal-title fw-bold text-danger"><i class="bi bi-exclamation-triangle-fill me-2"></i>Delete Staff Member</h5>
                                                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                            </div>
                                                            <div class="modal-body text-start">
                                                                Are you sure you want to remove staff officer <strong>${s.fullName}</strong> (${s.username})?
                                                            </div>
                                                            <div class="modal-footer">
                                                                <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                                                                <form action="${pageContext.request.contextPath}/admin/delete-user" method="POST">
                                                                    <input type="hidden" name="userId" value="${s.id}">
                                                                    <input type="hidden" name="returnTo" value="staff">
                                                                    <button type="submit" class="btn btn-danger">Delete Staff</button>
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
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-5">
                            <i class="bi bi-person-badge fs-1 text-muted"></i>
                            <h5 class="fw-bold mt-2">No Staff Members Registered</h5>
                            <p class="text-muted small">Add your first municipal field officer using the button above.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>
</div>

<!-- Add New Staff Modal -->
<div class="modal fade" id="addStaffModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold"><i class="bi bi-person-plus-fill text-success me-2"></i>Onboard New Staff Member</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/add-staff" method="POST">
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label for="staffFullName" class="form-label small fw-semibold text-muted text-uppercase">Full Name <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="staffFullName" name="fullName" placeholder="e.g. Vikram Verma" required>
                        </div>
                        <div class="col-md-6">
                            <label for="staffDepartment" class="form-label small fw-semibold text-muted text-uppercase">Department <span class="text-danger">*</span></label>
                            <select class="form-select" id="staffDepartment" name="departmentId" required>
                                <option value="">-- Assign Department --</option>
                                <c:forEach var="d" items="${departments}">
                                    <option value="${d.id}">${d.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label for="staffEmail" class="form-label small fw-semibold text-muted text-uppercase">Official Email <span class="text-danger">*</span></label>
                            <input type="email" class="form-control" id="staffEmail" name="email" placeholder="vikram.roads@civicconnect.gov" required>
                        </div>
                        <div class="col-md-6">
                            <label for="staffPhone" class="form-label small fw-semibold text-muted text-uppercase">Mobile Phone <span class="text-danger">*</span></label>
                            <input type="tel" class="form-control" id="staffPhone" name="phone" placeholder="10-digit number" pattern="[0-9]{10}" required>
                        </div>
                        <div class="col-md-6">
                            <label for="staffUsername" class="form-label small fw-semibold text-muted text-uppercase">Staff Username <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="staffUsername" name="username" placeholder="e.g. staff_vikram" minlength="3" required>
                        </div>
                        <div class="col-md-6">
                            <label for="staffPassword" class="form-label small fw-semibold text-muted text-uppercase">Initial Password <span class="text-danger">*</span></label>
                            <input type="password" class="form-control" id="staffPassword" name="password" placeholder="At least 6 characters" minlength="6" required>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-civic-accent">Add Staff Member</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp"/>

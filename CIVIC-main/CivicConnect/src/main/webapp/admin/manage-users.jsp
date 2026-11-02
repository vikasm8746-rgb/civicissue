<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="pageTitle" value="Manage Citizens – Administration"/>
</jsp:include>

<jsp:include page="/WEB-INF/includes/navbar.jsp"/>

<div class="dashboard-wrapper">
    <jsp:include page="/WEB-INF/includes/sidebar-admin.jsp">
        <jsp:param name="activePage" value="users"/>
    </jsp:include>

    <main class="main-content">
        <div class="container-fluid">
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
                <div>
                    <h2 class="fw-bold brand-font mb-1">Registered Citizens</h2>
                    <p class="text-muted small mb-0">Total Citizens: <span class="fw-bold text-dark">${citizens.size()}</span> registered users.</p>
                </div>
            </div>

            <jsp:include page="/WEB-INF/includes/alerts.jsp"/>

            <!-- Search Filter -->
            <div class="civic-card p-3 mb-4">
                <div class="row g-3">
                    <div class="col-md-5">
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="bi bi-search"></i></span>
                            <input type="text" id="tableSearchInput" class="form-control" placeholder="Search citizens by name, email, phone, or username..." data-target-table="#usersTable">
                        </div>
                    </div>
                </div>
            </div>

            <!-- Citizens Table -->
            <div class="civic-card p-4">
                <c:choose>
                    <c:when test="${not empty citizens}">
                        <div class="table-responsive">
                            <table id="usersTable" class="table table-hover table-searchable align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Full Name</th>
                                        <th>Username</th>
                                        <th>Email Address</th>
                                        <th>Phone Number</th>
                                        <th>Status</th>
                                        <th class="text-end">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="u" items="${citizens}">
                                        <tr>
                                            <td class="text-muted">#${u.id}</td>
                                            <td>
                                                <div class="fw-bold text-dark">${u.fullName}</div>
                                            </td>
                                            <td><code>${u.username}</code></td>
                                            <td>${u.email}</td>
                                            <td>${u.phone}</td>
                                            <td>
                                                <span class="badge ${u.status == 'ACTIVE' ? 'bg-success' : 'bg-secondary'} rounded-pill">
                                                    ${u.status}
                                                </span>
                                            </td>
                                            <td class="text-end">
                                                <div class="btn-group btn-group-sm">
                                                    <!-- Toggle Status Form -->
                                                    <form action="${pageContext.request.contextPath}/admin/toggle-user-status" method="POST" class="d-inline">
                                                        <input type="hidden" name="userId" value="${u.id}">
                                                        <input type="hidden" name="status" value="${u.status == 'ACTIVE' ? 'INACTIVE' : 'ACTIVE'}">
                                                        <button type="submit" class="btn btn-light border" title="${u.status == 'ACTIVE' ? 'Deactivate' : 'Activate'}">
                                                            <i class="bi ${u.status == 'ACTIVE' ? 'bi-person-slash text-warning' : 'bi-person-check text-success'}"></i>
                                                        </button>
                                                    </form>

                                                    <!-- Delete Button -->
                                                    <button type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#deleteUserModal${u.id}" title="Delete User">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </div>

                                                <!-- Delete Confirmation Modal -->
                                                <div class="modal fade" id="deleteUserModal${u.id}" tabindex="-1" aria-hidden="true">
                                                    <div class="modal-dialog modal-dialog-centered">
                                                        <div class="modal-content">
                                                            <div class="modal-header">
                                                                <h5 class="modal-title fw-bold text-danger"><i class="bi bi-exclamation-triangle-fill me-2"></i>Delete Citizen Account</h5>
                                                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                            </div>
                                                            <div class="modal-body text-start">
                                                                Are you sure you want to permanently delete citizen <strong>${u.fullName}</strong> (${u.username})? All associated complaints will also be deleted.
                                                            </div>
                                                            <div class="modal-footer">
                                                                <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                                                                <form action="${pageContext.request.contextPath}/admin/delete-user" method="POST">
                                                                    <input type="hidden" name="userId" value="${u.id}">
                                                                    <input type="hidden" name="returnTo" value="users">
                                                                    <button type="submit" class="btn btn-danger">Delete Citizen</button>
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
                            <i class="bi bi-people fs-1 text-muted"></i>
                            <h5 class="fw-bold mt-2">No Registered Citizens</h5>
                            <p class="text-muted small">Citizens will appear here once they register on the public portal.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp"/>

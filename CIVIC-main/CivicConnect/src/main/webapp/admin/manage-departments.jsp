<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="pageTitle" value="Manage Departments – Administration"/>
</jsp:include>

<jsp:include page="/WEB-INF/includes/navbar.jsp"/>

<div class="dashboard-wrapper">
    <jsp:include page="/WEB-INF/includes/sidebar-admin.jsp">
        <jsp:param name="activePage" value="departments"/>
    </jsp:include>

    <main class="main-content">
        <div class="container-fluid">
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
                <div>
                    <h2 class="fw-bold brand-font mb-1">Municipal Departments</h2>
                    <p class="text-muted small mb-0">Configure operational civic divisions and work allocation units.</p>
                </div>
                <button type="button" class="btn btn-civic-accent shadow-sm" data-bs-toggle="modal" data-bs-target="#addDeptModal">
                    <i class="bi bi-plus-circle me-1"></i> Add New Department
                </button>
            </div>

            <jsp:include page="/WEB-INF/includes/alerts.jsp"/>

            <div class="civic-card p-4">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Department Name</th>
                                <th>Description</th>
                                <th>Total Staff</th>
                                <th>Total Complaints</th>
                                <th>Status</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="d" items="${departments}">
                                <tr>
                                    <td class="text-muted">#${d.id}</td>
                                    <td>
                                        <div class="fw-bold text-dark">${d.name}</div>
                                    </td>
                                    <td>
                                        <div class="text-muted small text-truncate" style="max-width: 280px;">${d.description}</div>
                                    </td>
                                    <td>
                                        <span class="badge bg-light text-dark border px-2 py-1"><i class="bi bi-people me-1"></i> ${d.totalStaff} Staff</span>
                                    </td>
                                    <td>
                                        <span class="badge bg-light text-dark border px-2 py-1"><i class="bi bi-inbox me-1"></i> ${d.totalComplaints} Complaints</span>
                                    </td>
                                    <td>
                                        <span class="badge ${d.status == 'ACTIVE' ? 'bg-success' : 'bg-secondary'} rounded-pill">${d.status}</span>
                                    </td>
                                    <td class="text-end">
                                        <div class="btn-group btn-group-sm">
                                            <!-- Edit Button -->
                                            <button type="button" class="btn btn-light border" data-bs-toggle="modal" data-bs-target="#editDeptModal${d.id}" title="Edit">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <!-- Delete Button -->
                                            <button type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#deleteDeptModal${d.id}" title="Delete">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </div>

                                        <!-- Edit Modal -->
                                        <div class="modal fade" id="editDeptModal${d.id}" tabindex="-1" aria-hidden="true">
                                            <div class="modal-dialog modal-dialog-centered">
                                                <div class="modal-content text-start">
                                                    <div class="modal-header">
                                                        <h5 class="modal-title fw-bold">Edit Department</h5>
                                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                    </div>
                                                    <form action="${pageContext.request.contextPath}/admin/update-department" method="POST">
                                                        <input type="hidden" name="id" value="${d.id}">
                                                        <div class="modal-body">
                                                            <div class="mb-3">
                                                                <label class="form-label small text-muted fw-semibold">Department Name</label>
                                                                <input type="text" class="form-control" name="name" value="${d.name}" required>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label class="form-label small text-muted fw-semibold">Description</label>
                                                                <textarea class="form-control" name="description" rows="3">${d.description}</textarea>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label class="form-label small text-muted fw-semibold">Status</label>
                                                                <select class="form-select" name="status">
                                                                    <option value="ACTIVE" ${d.status == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                                                                    <option value="INACTIVE" ${d.status == 'INACTIVE' ? 'selected' : ''}>INACTIVE</option>
                                                                </select>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                                                            <button type="submit" class="btn btn-civic-primary">Save Changes</button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Delete Modal -->
                                        <div class="modal fade" id="deleteDeptModal${d.id}" tabindex="-1" aria-hidden="true">
                                            <div class="modal-dialog modal-dialog-centered">
                                                <div class="modal-content text-start">
                                                    <div class="modal-header">
                                                        <h5 class="modal-title fw-bold text-danger"><i class="bi bi-exclamation-triangle-fill me-2"></i>Delete Department</h5>
                                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                    </div>
                                                    <div class="modal-body">
                                                        Are you sure you want to delete <strong>${d.name}</strong>?
                                                    </div>
                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                                                        <form action="${pageContext.request.contextPath}/admin/delete-department" method="POST">
                                                            <input type="hidden" name="id" value="${d.id}">
                                                            <button type="submit" class="btn btn-danger">Delete</button>
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
            </div>
        </div>
    </main>
</div>

<!-- Add Department Modal -->
<div class="modal fade" id="addDeptModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold"><i class="bi bi-building-add text-primary me-2"></i>Add Department</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/add-department" method="POST">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="deptName" class="form-label small fw-semibold text-muted text-uppercase">Department Name <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="deptName" name="name" placeholder="e.g. Horticulture & City Parks" required>
                    </div>
                    <div class="mb-3">
                        <label for="deptDesc" class="form-label small fw-semibold text-muted text-uppercase">Description</label>
                        <textarea class="form-control" id="deptDesc" name="description" rows="3" placeholder="Scope of responsibility..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-civic-accent">Create Department</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp"/>

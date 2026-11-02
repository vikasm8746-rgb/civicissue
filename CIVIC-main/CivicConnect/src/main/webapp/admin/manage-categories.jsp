<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="pageTitle" value="Manage Categories – Administration"/>
</jsp:include>

<jsp:include page="/WEB-INF/includes/navbar.jsp"/>

<div class="dashboard-wrapper">
    <jsp:include page="/WEB-INF/includes/sidebar-admin.jsp">
        <jsp:param name="activePage" value="categories"/>
    </jsp:include>

    <main class="main-content">
        <div class="container-fluid">
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
                <div>
                    <h2 class="fw-bold brand-font mb-1">Issue Categories</h2>
                    <p class="text-muted small mb-0">Configure complaint problem types and route them to relevant municipal departments.</p>
                </div>
                <button type="button" class="btn btn-civic-accent shadow-sm" data-bs-toggle="modal" data-bs-target="#addCatModal">
                    <i class="bi bi-tag me-1"></i> Add New Category
                </button>
            </div>

            <jsp:include page="/WEB-INF/includes/alerts.jsp"/>

            <div class="civic-card p-4">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Category Name</th>
                                <th>Mapped Department</th>
                                <th>Description</th>
                                <th>Status</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="cat" items="${categories}">
                                <tr>
                                    <td class="text-muted">#${cat.id}</td>
                                    <td>
                                        <div class="fw-bold text-dark">${cat.name}</div>
                                    </td>
                                    <td>
                                        <span class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-25 px-2 py-1">
                                            ${cat.departmentName != null ? cat.departmentName : 'General / Unmapped'}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="text-muted small text-truncate" style="max-width: 280px;">${cat.description}</div>
                                    </td>
                                    <td>
                                        <span class="badge ${cat.status == 'ACTIVE' ? 'bg-success' : 'bg-secondary'} rounded-pill">${cat.status}</span>
                                    </td>
                                    <td class="text-end">
                                        <div class="btn-group btn-group-sm">
                                            <!-- Edit Button -->
                                            <button type="button" class="btn btn-light border" data-bs-toggle="modal" data-bs-target="#editCatModal${cat.id}" title="Edit">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <!-- Delete Button -->
                                            <button type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#deleteCatModal${cat.id}" title="Delete">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </div>

                                        <!-- Edit Modal -->
                                        <div class="modal fade" id="editCatModal${cat.id}" tabindex="-1" aria-hidden="true">
                                            <div class="modal-dialog modal-dialog-centered">
                                                <div class="modal-content text-start">
                                                    <div class="modal-header">
                                                        <h5 class="modal-title fw-bold">Edit Category</h5>
                                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                    </div>
                                                    <form action="${pageContext.request.contextPath}/admin/update-category" method="POST">
                                                        <input type="hidden" name="id" value="${cat.id}">
                                                        <div class="modal-body">
                                                            <div class="mb-3">
                                                                <label class="form-label small text-muted fw-semibold">Category Name</label>
                                                                <input type="text" class="form-control" name="name" value="${cat.name}" required>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label class="form-label small text-muted fw-semibold">Default Department</label>
                                                                <select class="form-select" name="departmentId" required>
                                                                    <c:forEach var="d" items="${departments}">
                                                                        <option value="${d.id}" ${cat.departmentId == d.id ? 'selected' : ''}>${d.name}</option>
                                                                    </c:forEach>
                                                                </select>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label class="form-label small text-muted fw-semibold">Description</label>
                                                                <textarea class="form-control" name="description" rows="3">${cat.description}</textarea>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label class="form-label small text-muted fw-semibold">Status</label>
                                                                <select class="form-select" name="status">
                                                                    <option value="ACTIVE" ${cat.status == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                                                                    <option value="INACTIVE" ${cat.status == 'INACTIVE' ? 'selected' : ''}>INACTIVE</option>
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
                                        <div class="modal fade" id="deleteCatModal${cat.id}" tabindex="-1" aria-hidden="true">
                                            <div class="modal-dialog modal-dialog-centered">
                                                <div class="modal-content text-start">
                                                    <div class="modal-header">
                                                        <h5 class="modal-title fw-bold text-danger"><i class="bi bi-exclamation-triangle-fill me-2"></i>Delete Category</h5>
                                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                    </div>
                                                    <div class="modal-body">
                                                        Are you sure you want to delete category <strong>${cat.name}</strong>?
                                                    </div>
                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                                                        <form action="${pageContext.request.contextPath}/admin/delete-category" method="POST">
                                                            <input type="hidden" name="id" value="${cat.id}">
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

<!-- Add Category Modal -->
<div class="modal fade" id="addCatModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold"><i class="bi bi-tag text-primary me-2"></i>Add Issue Category</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/add-category" method="POST">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="catName" class="form-label small fw-semibold text-muted text-uppercase">Category Name <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="catName" name="name" placeholder="e.g. Broken Traffic Signal" required>
                    </div>
                    <div class="mb-3">
                        <label for="catDept" class="form-label small fw-semibold text-muted text-uppercase">Responsible Department <span class="text-danger">*</span></label>
                        <select class="form-select" id="catDept" name="departmentId" required>
                            <option value="">-- Map to Department --</option>
                            <c:forEach var="d" items="${departments}">
                                <option value="${d.id}">${d.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="catDesc" class="form-label small fw-semibold text-muted text-uppercase">Description</label>
                        <textarea class="form-control" id="catDesc" name="description" rows="3" placeholder="Category definition and scope..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-civic-accent">Create Category</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp"/>

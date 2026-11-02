<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="pageTitle" value="Complaint Audit – ${complaint.complaintCode}"/>
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
                    <a href="${pageContext.request.contextPath}/admin/manage-complaints" class="text-decoration-none text-muted small">
                        <i class="bi bi-arrow-left"></i> Back to Complaints Master List
                    </a>
                    <h2 class="fw-bold brand-font mb-0 mt-1">Audit Grievance: ${complaint.complaintCode}</h2>
                </div>
                <div class="d-flex gap-2">
                    <span class="badge ${complaint.priorityBadgeClass} badge-civic fs-6">${complaint.priority} PRIORITY</span>
                    <span class="badge ${complaint.statusBadgeClass} badge-civic fs-6">${complaint.status}</span>
                </div>
            </div>

            <jsp:include page="/WEB-INF/includes/alerts.jsp"/>

            <div class="row g-4">
                <!-- Left: Full Complaint Details & Photos -->
                <div class="col-lg-7">
                    <div class="civic-card p-4 mb-4">
                        <h4 class="fw-bold brand-font mb-2">${complaint.title}</h4>
                        <div class="text-muted small mb-4">
                            <span><i class="bi bi-person-fill me-1"></i> Citizen: <span class="fw-bold text-dark">${complaint.citizenName}</span> (${complaint.citizenEmail}, ${complaint.citizenPhone})</span>
                            <br>
                            <span><i class="bi bi-calendar-event me-1"></i> Reported: ${complaint.formattedCreatedAt}</span>
                        </div>

                        <div class="row g-3 mb-4">
                            <div class="col-sm-6">
                                <label class="text-muted text-uppercase small fw-bold">Category</label>
                                <div class="fw-semibold">${complaint.categoryName}</div>
                            </div>
                            <div class="col-sm-6">
                                <label class="text-muted text-uppercase small fw-bold">Assigned Department</label>
                                <div class="fw-semibold text-primary">${complaint.departmentName != null ? complaint.departmentName : 'Unassigned'}</div>
                            </div>
                            <div class="col-sm-6">
                                <label class="text-muted text-uppercase small fw-bold">Assigned Staff</label>
                                <div class="fw-semibold">${complaint.staffName != null ? complaint.staffName : 'Unassigned'}</div>
                            </div>
                            <div class="col-sm-6">
                                <label class="text-muted text-uppercase small fw-bold">Location & Pincode</label>
                                <div class="fw-semibold">${complaint.location}, PIN: ${complaint.pincode}</div>
                                <small class="text-muted">Landmark: ${complaint.landmark != null ? complaint.landmark : 'N/A'}</small>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="text-muted text-uppercase small fw-bold">Problem Description</label>
                            <div class="p-3 bg-light rounded border text-secondary">${complaint.description}</div>
                        </div>

                        <div class="row g-3">
                            <c:if test="${not empty complaint.imagePath}">
                                <div class="col-md-6">
                                    <label class="text-muted text-uppercase small fw-bold mb-2">Complaint Photo (Before)</label>
                                    <img src="${pageContext.request.contextPath}/${complaint.imagePath}" alt="Reported Photo" class="img-fluid rounded border shadow-sm" style="max-height: 200px; width: 100%; object-fit: cover;">
                                </div>
                            </c:if>
                            <c:if test="${not empty complaint.resolutionImagePath}">
                                <div class="col-md-6">
                                    <label class="text-success text-uppercase small fw-bold mb-2">Resolution Proof (After)</label>
                                    <img src="${pageContext.request.contextPath}/${complaint.resolutionImagePath}" alt="Resolution Proof" class="img-fluid rounded border shadow-sm" style="max-height: 200px; width: 100%; object-fit: cover;">
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <!-- Status History -->
                    <div class="civic-card p-4">
                        <h5 class="fw-bold brand-font mb-3"><i class="bi bi-clock-history text-secondary me-2"></i>Status History Audit Log</h5>
                        <div class="history-audit-list">
                            <c:forEach var="item" items="${timeline}">
                                <div class="history-item">
                                    <div class="fw-bold text-dark">${item.newStatus}</div>
                                    <div class="text-muted small mb-1">${item.formattedChangedAt} &bull; Updated by: <span class="fw-semibold">${item.changedByName != null ? item.changedByName : 'Admin'}</span></div>
                                    <div class="text-secondary small bg-light p-2 rounded border">${item.remarks}</div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <!-- Right: Action Controls (Assign & Status Change) -->
                <div class="col-lg-5">
                    <!-- 1. Assignment Form -->
                    <div class="civic-card p-4 mb-4 border-primary shadow-sm">
                        <h5 class="fw-bold brand-font mb-3 text-primary"><i class="bi bi-person-check-fill me-2"></i>Assign Department & Staff</h5>
                        <form action="${pageContext.request.contextPath}/admin/assign-complaint" method="POST">
                            <input type="hidden" name="complaintId" value="${complaint.id}">

                            <div class="mb-3">
                                <label for="departmentId" class="form-label fw-semibold small text-muted text-uppercase">Department <span class="text-danger">*</span></label>
                                <select class="form-select" id="departmentId" name="departmentId" required>
                                    <option value="">-- Choose Department --</option>
                                    <c:forEach var="d" items="${departments}">
                                        <option value="${d.id}" ${complaint.departmentId == d.id ? 'selected' : ''}>${d.name}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label for="staffId" class="form-label fw-semibold small text-muted text-uppercase">Staff Member (Optional)</label>
                                <select class="form-select" id="staffId" name="staffId">
                                    <option value="0">-- Auto / General Department Pool --</option>
                                    <c:forEach var="s" items="${staffList}">
                                        <option value="${s.id}" ${complaint.assignedStaffId == s.id ? 'selected' : ''}>
                                            ${s.fullName} (${s.departmentName != null ? s.departmentName : 'Staff'})
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label for="adminRemarks" class="form-label fw-semibold small text-muted text-uppercase">Directives / Admin Remarks</label>
                                <textarea class="form-control" id="adminRemarks" name="adminRemarks" rows="2" placeholder="Instructions for field team...">${complaint.adminRemarks}</textarea>
                            </div>

                            <button type="submit" class="btn btn-civic-primary w-100 fw-bold">
                                <i class="bi bi-send-check me-1"></i> Confirm Assignment
                            </button>
                        </form>
                    </div>

                    <!-- 2. Status Transition Form -->
                    <div class="civic-card p-4 shadow-sm">
                        <h5 class="fw-bold brand-font mb-3"><i class="bi bi-arrow-repeat me-2"></i>Change Status / Reject</h5>
                        <form action="${pageContext.request.contextPath}/admin/update-status" method="POST">
                            <input type="hidden" name="complaintId" value="${complaint.id}">

                            <div class="mb-3">
                                <label for="newStatus" class="form-label fw-semibold small text-muted text-uppercase">New Status <span class="text-danger">*</span></label>
                                <select class="form-select" id="newStatus" name="newStatus" required>
                                    <option value="SUBMITTED" ${complaint.status == 'SUBMITTED' ? 'selected' : ''}>SUBMITTED</option>
                                    <option value="UNDER_REVIEW" ${complaint.status == 'UNDER_REVIEW' ? 'selected' : ''}>UNDER REVIEW</option>
                                    <option value="ASSIGNED" ${complaint.status == 'ASSIGNED' ? 'selected' : ''}>ASSIGNED</option>
                                    <option value="IN_PROGRESS" ${complaint.status == 'IN_PROGRESS' ? 'selected' : ''}>IN PROGRESS</option>
                                    <option value="RESOLVED" ${complaint.status == 'RESOLVED' ? 'selected' : ''}>RESOLVED</option>
                                    <option value="REJECTED" ${complaint.status == 'REJECTED' ? 'selected' : ''}>REJECTED (Close Complaint)</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label for="statusRemarks" class="form-label fw-semibold small text-muted text-uppercase">Reason / Remarks <span class="text-danger">*</span></label>
                                <textarea class="form-control" id="statusRemarks" name="adminRemarks" rows="2" placeholder="Provide note for citizen & audit..." required></textarea>
                            </div>

                            <button type="submit" class="btn btn-outline-dark w-100 fw-bold">
                                <i class="bi bi-check2-circle me-1"></i> Update Status
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp"/>

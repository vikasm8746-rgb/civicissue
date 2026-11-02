<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="pageTitle" value="Handle Complaint – ${complaint.complaintCode}"/>
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
                    <a href="${pageContext.request.contextPath}/staff/assigned-complaints" class="text-decoration-none text-muted small">
                        <i class="bi bi-arrow-left"></i> Back to Assigned List
                    </a>
                    <h2 class="fw-bold brand-font mb-0 mt-1">Handle Complaint: ${complaint.complaintCode}</h2>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <span class="badge ${complaint.priorityBadgeClass} badge-civic fs-6">${complaint.priority} PRIORITY</span>
                    <span class="badge ${complaint.statusBadgeClass} badge-civic fs-6">${complaint.status}</span>
                </div>
            </div>

            <jsp:include page="/WEB-INF/includes/alerts.jsp"/>

            <div class="row g-4">
                <!-- Left Column: Details & Images -->
                <div class="col-lg-7">
                    <div class="civic-card p-4 mb-4">
                        <h4 class="fw-bold brand-font mb-2">${complaint.title}</h4>
                        <p class="text-muted small mb-3">Reported by <span class="fw-bold text-dark">${complaint.citizenName}</span> &bull; <i class="bi bi-telephone"></i> ${complaint.citizenPhone} &bull; ${complaint.formattedCreatedAt}</p>

                        <div class="row g-3 mb-3">
                            <div class="col-sm-6">
                                <label class="text-muted text-uppercase small fw-bold">Category</label>
                                <div class="fw-semibold">${complaint.categoryName}</div>
                            </div>
                            <div class="col-sm-6">
                                <label class="text-muted text-uppercase small fw-bold">Department</label>
                                <div class="fw-semibold text-primary">${complaint.departmentName}</div>
                            </div>
                            <div class="col-12">
                                <label class="text-muted text-uppercase small fw-bold">Location & Landmark</label>
                                <div class="fw-semibold">${complaint.location} (PIN: ${complaint.pincode})</div>
                                <small class="text-muted">Landmark: ${complaint.landmark != null ? complaint.landmark : 'N/A'}</small>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="text-muted text-uppercase small fw-bold">Citizen's Description</label>
                            <div class="p-3 bg-light rounded border text-secondary">${complaint.description}</div>
                        </div>

                        <c:if test="${not empty complaint.adminRemarks}">
                            <div class="mb-4">
                                <label class="text-danger text-uppercase small fw-bold"><i class="bi bi-info-circle me-1"></i> Admin Instructions / Remarks</label>
                                <div class="p-3 bg-warning bg-opacity-10 rounded border border-warning text-dark">${complaint.adminRemarks}</div>
                            </div>
                        </c:if>

                        <div class="row g-3">
                            <c:if test="${not empty complaint.imagePath}">
                                <div class="col-md-6">
                                    <label class="text-muted text-uppercase small fw-bold mb-2">Reported Photo (Before)</label>
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
                        <h5 class="fw-bold brand-font mb-3"><i class="bi bi-clock-history text-secondary me-2"></i>Status History</h5>
                        <div class="history-audit-list">
                            <c:forEach var="item" items="${timeline}">
                                <div class="history-item">
                                    <div class="fw-bold text-dark">${item.newStatus}</div>
                                    <div class="text-muted small mb-1">${item.formattedChangedAt} &bull; ${item.changedByName != null ? item.changedByName : 'Staff'}</div>
                                    <div class="text-secondary small bg-light p-2 rounded border">${item.remarks}</div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <!-- Right Column: Action Form -->
                <div class="col-lg-5">
                    <div class="civic-card p-4 shadow-sm border-primary">
                        <h5 class="fw-bold brand-font mb-3 text-primary"><i class="bi bi-gear-fill me-2"></i>Update Status & Resolve</h5>
                        <form action="${pageContext.request.contextPath}/staff/update-status" method="POST" enctype="multipart/form-data">
                            <input type="hidden" name="complaintId" value="${complaint.id}">

                            <div class="mb-3">
                                <label for="newStatus" class="form-label fw-semibold small text-muted text-uppercase">Update Work Status <span class="text-danger">*</span></label>
                                <select class="form-select" id="newStatus" name="newStatus" required>
                                    <option value="IN_PROGRESS" ${complaint.status == 'IN_PROGRESS' ? 'selected' : ''}>IN PROGRESS (Crew Dispatched / Work Ongoing)</option>
                                    <option value="RESOLVED" ${complaint.status == 'RESOLVED' ? 'selected' : ''}>RESOLVED (Work Completed & Verified)</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label for="staffRemarks" class="form-label fw-semibold small text-muted text-uppercase">Staff Resolution Remarks <span class="text-danger">*</span></label>
                                <textarea class="form-control" id="staffRemarks" name="staffRemarks" rows="3" placeholder="Describe actions taken on-ground..." required>${complaint.staffRemarks}</textarea>
                            </div>

                            <div class="mb-3">
                                <label for="resolutionImage" class="form-label fw-semibold small text-muted text-uppercase">Attach Resolution Proof Photo (.jpg, .png)</label>
                                <input class="form-control" type="file" id="resolutionImage" name="resolutionImage" accept=".jpg,.jpeg,.png" data-preview-target="staffImagePreviewBox">
                                <small class="text-muted">Mandatory when marking as RESOLVED.</small>
                            </div>

                            <div class="mb-4">
                                <div id="staffImagePreviewBox" class="image-preview-container p-2 text-center" style="max-height: 160px;">
                                    <span class="text-muted small"><i class="bi bi-camera me-1"></i> Resolution preview</span>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-civic-accent w-100 py-2 fw-bold shadow-sm">
                                <i class="bi bi-check2-circle me-1"></i> Save Status Update
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp"/>

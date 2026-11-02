<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="pageTitle" value="Track Complaint Status – CivicConnect"/>
</jsp:include>

<jsp:include page="/WEB-INF/includes/navbar.jsp"/>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-9">
            <!-- Search Box Card -->
            <div class="civic-card p-4 mb-4 shadow-sm">
                <h4 class="fw-bold brand-font mb-2"><i class="bi bi-crosshair text-primary me-2"></i>Track Civic Complaint</h4>
                <p class="text-muted small mb-4">Enter your complaint reference code to check real-time progress and timeline status.</p>

                <jsp:include page="/WEB-INF/includes/alerts.jsp"/>

                <form action="${pageContext.request.contextPath}/track" method="POST" class="row g-2">
                    <div class="col-sm-9">
                        <input type="text" name="complaintCode" class="form-control form-control-lg" value="${searchedCode}" placeholder="e.g. CIV-2026-00001" required>
                    </div>
                    <div class="col-sm-3">
                        <button type="submit" class="btn btn-civic-primary btn-lg w-100">
                            <i class="bi bi-search me-1"></i> Track
                        </button>
                    </div>
                </form>
            </div>

            <!-- Complaint Details & Timeline Card -->
            <c:if test="${not empty complaint}">
                <div class="civic-card p-4 p-md-5 shadow-md">
                    <div class="d-flex flex-wrap justify-content-between align-items-start gap-3 border-bottom pb-3 mb-4">
                        <div>
                            <span class="badge ${complaint.statusBadgeClass} badge-civic mb-2">${complaint.status}</span>
                            <span class="badge ${complaint.priorityBadgeClass} badge-civic mb-2 ms-1">${complaint.priority} PRIORITY</span>
                            <h3 class="fw-bold brand-font mb-1">${complaint.title}</h3>
                            <div class="text-muted small">
                                <span class="fw-semibold text-primary">Ticket: ${complaint.complaintCode}</span> &bull; 
                                Reported on ${complaint.formattedCreatedAt}
                            </div>
                        </div>
                    </div>

                    <!-- Visual Stepper Progress Bar -->
                    <c:choose>
                        <c:when test="${complaint.status == 'REJECTED'}">
                            <div class="alert alert-danger d-flex align-items-center mb-4">
                                <i class="bi bi-x-circle-fill fs-3 me-3"></i>
                                <div>
                                    <h6 class="fw-bold mb-1">Complaint Closed / Rejected</h6>
                                    <p class="small mb-0">${complaint.adminRemarks != null ? complaint.adminRemarks : 'This issue does not meet municipal reporting criteria.'}</p>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="timeline-stepper">
                                <!-- 1. Submitted -->
                                <div class="timeline-step ${complaint.workflowStep >= 1 ? 'completed' : ''}">
                                    <div class="step-icon-circle">
                                        <i class="bi bi-check-lg"></i>
                                    </div>
                                    <span class="step-title">Submitted</span>
                                </div>

                                <!-- 2. Under Review -->
                                <div class="timeline-step ${complaint.workflowStep > 2 ? 'completed' : (complaint.workflowStep == 2 ? 'active' : '')}">
                                    <div class="step-icon-circle">
                                        <c:choose>
                                            <c:when test="${complaint.workflowStep > 2}"><i class="bi bi-check-lg"></i></c:when>
                                            <c:when test="${complaint.workflowStep == 2}"><i class="bi bi-search"></i></c:when>
                                            <c:otherwise>2</c:otherwise>
                                        </c:choose>
                                    </div>
                                    <span class="step-title">Under Review</span>
                                </div>

                                <!-- 3. Assigned -->
                                <div class="timeline-step ${complaint.workflowStep > 3 ? 'completed' : (complaint.workflowStep == 3 ? 'active' : '')}">
                                    <div class="step-icon-circle">
                                        <c:choose>
                                            <c:when test="${complaint.workflowStep > 3}"><i class="bi bi-check-lg"></i></c:when>
                                            <c:when test="${complaint.workflowStep == 3}"><i class="bi bi-person-check"></i></c:when>
                                            <c:otherwise>3</c:otherwise>
                                        </c:choose>
                                    </div>
                                    <span class="step-title">Assigned</span>
                                </div>

                                <!-- 4. In Progress -->
                                <div class="timeline-step ${complaint.workflowStep > 4 ? 'completed' : (complaint.workflowStep == 4 ? 'active' : '')}">
                                    <div class="step-icon-circle">
                                        <c:choose>
                                            <c:when test="${complaint.workflowStep > 4}"><i class="bi bi-check-lg"></i></c:when>
                                            <c:when test="${complaint.workflowStep == 4}"><i class="bi bi-gear-fill"></i></c:when>
                                            <c:otherwise>4</c:otherwise>
                                        </c:choose>
                                    </div>
                                    <span class="step-title">In Progress</span>
                                </div>

                                <!-- 5. Resolved -->
                                <div class="timeline-step ${complaint.workflowStep >= 5 ? 'completed' : ''}">
                                    <div class="step-icon-circle">
                                        <c:choose>
                                            <c:when test="${complaint.workflowStep >= 5}"><i class="bi bi-patch-check-fill"></i></c:when>
                                            <c:otherwise>5</c:otherwise>
                                        </c:choose>
                                    </div>
                                    <span class="step-title">Resolved</span>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <!-- Details Grid -->
                    <div class="row g-4 mb-4">
                        <div class="col-md-6">
                            <h6 class="fw-bold text-uppercase text-muted small">Category & Department</h6>
                            <p class="mb-1 fw-semibold">${complaint.categoryName}</p>
                            <p class="text-muted small">${complaint.departmentName != null ? complaint.departmentName : 'Pending Department Assignment'}</p>
                        </div>
                        <div class="col-md-6">
                            <h6 class="fw-bold text-uppercase text-muted small">Location & Landmark</h6>
                            <p class="mb-1 fw-semibold">${complaint.location}</p>
                            <p class="text-muted small">Landmark: ${complaint.landmark != null ? complaint.landmark : 'N/A'}, PIN: ${complaint.pincode}</p>
                        </div>
                        <div class="col-12">
                            <h6 class="fw-bold text-uppercase text-muted small">Description</h6>
                            <div class="p-3 bg-light rounded border text-secondary">${complaint.description}</div>
                        </div>
                    </div>

                    <!-- Images Section -->
                    <div class="row g-3 mb-4">
                        <c:if test="${not empty complaint.imagePath}">
                            <div class="col-md-6">
                                <h6 class="fw-bold text-uppercase text-muted small mb-2"><i class="bi bi-image me-1"></i> Reported Issue Photo</h6>
                                <img src="${pageContext.request.contextPath}/${complaint.imagePath}" alt="Reported Issue" class="img-fluid rounded border shadow-sm" style="max-height: 240px; width: 100%; object-fit: cover;">
                            </div>
                        </c:if>
                        <c:if test="${not empty complaint.resolutionImagePath}">
                            <div class="col-md-6">
                                <h6 class="fw-bold text-uppercase text-success small mb-2"><i class="bi bi-patch-check-fill me-1"></i> Resolution Proof Photo</h6>
                                <img src="${pageContext.request.contextPath}/${complaint.resolutionImagePath}" alt="Resolution Proof" class="img-fluid rounded border shadow-sm" style="max-height: 240px; width: 100%; object-fit: cover;">
                            </div>
                        </c:if>
                    </div>

                    <!-- Status History Audit Log -->
                    <h5 class="fw-bold brand-font mb-3"><i class="bi bi-clock-history text-secondary me-2"></i>Status History & Remarks</h5>
                    <div class="history-audit-list">
                        <c:forEach var="item" items="${timeline}">
                            <div class="history-item">
                                <div class="fw-bold text-dark">${item.newStatus}</div>
                                <div class="text-muted small mb-1">${item.formattedChangedAt} &bull; Updated by: <span class="fw-semibold">${item.changedByName != null ? item.changedByName : 'System Admin'}</span></div>
                                <div class="text-secondary small bg-light p-2 rounded border">${item.remarks}</div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:if>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp"/>

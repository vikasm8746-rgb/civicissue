<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="pageTitle" value="Complaint Details – ${complaint.complaintCode}"/>
</jsp:include>

<jsp:include page="/WEB-INF/includes/navbar.jsp"/>

<div class="dashboard-wrapper">
    <jsp:include page="/WEB-INF/includes/sidebar-citizen.jsp">
        <jsp:param name="activePage" value="complaints"/>
    </jsp:include>

    <main class="main-content">
        <div class="container-fluid">
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
                <div>
                    <a href="${pageContext.request.contextPath}/citizen/my-complaints" class="text-decoration-none text-muted small">
                        <i class="bi bi-arrow-left"></i> Back to Complaints
                    </a>
                    <h2 class="fw-bold brand-font mb-0 mt-1">Complaint: ${complaint.complaintCode}</h2>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <span class="badge ${complaint.priorityBadgeClass} badge-civic fs-6">${complaint.priority} PRIORITY</span>
                    <span class="badge ${complaint.statusBadgeClass} badge-civic fs-6">${complaint.status}</span>
                </div>
            </div>

            <jsp:include page="/WEB-INF/includes/alerts.jsp"/>

            <!-- Visual Stepper Progress Bar -->
            <div class="civic-card p-4 p-md-5 mb-4">
                <h5 class="fw-bold brand-font mb-2">Resolution Progress</h5>
                <c:choose>
                    <c:when test="${complaint.status == 'REJECTED'}">
                        <div class="alert alert-danger d-flex align-items-center mt-3 mb-0">
                            <i class="bi bi-x-circle-fill fs-3 me-3"></i>
                            <div>
                                <h6 class="fw-bold mb-1">Complaint Closed / Rejected</h6>
                                <p class="small mb-0">${complaint.adminRemarks != null ? complaint.adminRemarks : 'This issue has been closed.'}</p>
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
            </div>

            <!-- Complaint Details & Images -->
            <div class="row g-4 mb-4">
                <div class="col-lg-8">
                    <div class="civic-card p-4 h-100">
                        <h4 class="fw-bold brand-font mb-3">${complaint.title}</h4>
                        <div class="text-muted small mb-4">
                            <span><i class="bi bi-calendar-event me-1"></i> Reported on ${complaint.formattedCreatedAt}</span>
                            <c:if test="${not empty complaint.resolvedAt}">
                                <span class="ms-3 text-success"><i class="bi bi-check-circle-fill me-1"></i> Resolved on ${complaint.formattedResolvedAt}</span>
                            </c:if>
                        </div>

                        <div class="row g-3 mb-4">
                            <div class="col-sm-6">
                                <label class="text-muted text-uppercase small fw-bold">Category</label>
                                <div class="fw-semibold">${complaint.categoryName}</div>
                            </div>
                            <div class="col-sm-6">
                                <label class="text-muted text-uppercase small fw-bold">Assigned Department</label>
                                <div class="fw-semibold text-primary">${complaint.departmentName != null ? complaint.departmentName : 'Pending Department Assignment'}</div>
                            </div>
                            <div class="col-sm-6">
                                <label class="text-muted text-uppercase small fw-bold">Assigned Field Staff</label>
                                <div class="fw-semibold">${complaint.staffName != null ? complaint.staffName : 'Pending Staff Allocation'}</div>
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

                        <!-- Before and After Photos -->
                        <div class="row g-3">
                            <c:if test="${not empty complaint.imagePath}">
                                <div class="col-md-6">
                                    <label class="text-muted text-uppercase small fw-bold mb-2"><i class="bi bi-camera me-1"></i> Complaint Photo (Before)</label>
                                    <img src="${pageContext.request.contextPath}/${complaint.imagePath}" alt="Reported Photo" class="img-fluid rounded border shadow-sm" style="max-height: 220px; width: 100%; object-fit: cover;">
                                </div>
                            </c:if>
                            <c:if test="${not empty complaint.resolutionImagePath}">
                                <div class="col-md-6">
                                    <label class="text-success text-uppercase small fw-bold mb-2"><i class="bi bi-patch-check-fill me-1"></i> Resolution Proof Photo (After)</label>
                                    <img src="${pageContext.request.contextPath}/${complaint.resolutionImagePath}" alt="Resolution Proof" class="img-fluid rounded border shadow-sm" style="max-height: 220px; width: 100%; object-fit: cover;">
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>

                <!-- Right Column: Status History & Feedback -->
                <div class="col-lg-4">
                    <!-- Feedback Section -->
                    <c:if test="${complaint.status == 'RESOLVED'}">
                        <div class="civic-card p-4 mb-4 border-success">
                            <h5 class="fw-bold brand-font mb-2 text-success"><i class="bi bi-star-fill text-warning me-2"></i>Citizen Feedback</h5>
                            <c:choose>
                                <c:when test="${not empty complaint.feedbackRating and complaint.feedbackRating > 0}">
                                    <div class="p-3 bg-light rounded border">
                                        <div class="mb-2 text-warning fs-5">
                                            <c:forEach begin="1" end="${complaint.feedbackRating}"><i class="bi bi-star-fill"></i></c:forEach>
                                            <c:forEach begin="${complaint.feedbackRating + 1}" end="5"><i class="bi bi-star"></i></c:forEach>
                                            <span class="fs-6 text-dark ms-2 fw-bold">(${complaint.feedbackRating}/5 Stars)</span>
                                        </div>
                                        <p class="small text-secondary mb-0">"${complaint.feedbackComment}"</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <p class="small text-muted mb-3">Your complaint has been resolved. Please share your rating and feedback to help us evaluate service quality.</p>
                                    <form action="${pageContext.request.contextPath}/citizen/feedback" method="POST">
                                        <input type="hidden" name="complaintId" value="${complaint.id}">
                                        <div class="mb-3 text-center">
                                            <div class="star-rating">
                                                <input type="radio" id="star5" name="rating" value="5" required/><label for="star5" title="5 stars"><i class="bi bi-star-fill"></i></label>
                                                <input type="radio" id="star4" name="rating" value="4"/><label for="star4" title="4 stars"><i class="bi bi-star-fill"></i></label>
                                                <input type="radio" id="star3" name="rating" value="3"/><label for="star3" title="3 stars"><i class="bi bi-star-fill"></i></label>
                                                <input type="radio" id="star2" name="rating" value="2"/><label for="star2" title="2 stars"><i class="bi bi-star-fill"></i></label>
                                                <input type="radio" id="star1" name="rating" value="1"/><label for="star1" title="1 star"><i class="bi bi-star-fill"></i></label>
                                            </div>
                                        </div>
                                        <div class="mb-3">
                                            <textarea class="form-control" name="comment" rows="2" placeholder="Write brief feedback..." required></textarea>
                                        </div>
                                        <button type="submit" class="btn btn-success btn-sm w-100 fw-bold">Submit Feedback</button>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>

                    <!-- Status History Timeline List -->
                    <div class="civic-card p-4">
                        <h5 class="fw-bold brand-font mb-3"><i class="bi bi-clock-history text-secondary me-2"></i>Status History</h5>
                        <div class="history-audit-list">
                            <c:forEach var="item" items="${timeline}">
                                <div class="history-item">
                                    <div class="fw-bold text-dark">${item.newStatus}</div>
                                    <div class="text-muted small mb-1">${item.formattedChangedAt}</div>
                                    <div class="text-secondary small bg-light p-2 rounded border">${item.remarks}</div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp"/>

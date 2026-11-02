<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="pageTitle" value="Report Civic Issue – CivicConnect"/>
</jsp:include>

<jsp:include page="/WEB-INF/includes/navbar.jsp"/>

<div class="dashboard-wrapper">
    <jsp:include page="/WEB-INF/includes/sidebar-citizen.jsp">
        <jsp:param name="activePage" value="report"/>
    </jsp:include>

    <main class="main-content">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold brand-font mb-1">Report a Civic Issue</h2>
                    <p class="text-muted small mb-0">Submit complaints about damaged roads, garbage, broken street lights, or water leaks.</p>
                </div>
                <a href="${pageContext.request.contextPath}/citizen/my-complaints" class="btn btn-outline-secondary btn-sm">
                    <i class="bi bi-arrow-left me-1"></i> Back to My Complaints
                </a>
            </div>

            <jsp:include page="/WEB-INF/includes/alerts.jsp"/>

            <div class="row justify-content-center">
                <div class="col-lg-10">
                    <div class="civic-card p-4 p-md-5 shadow-sm">
                        <form action="${pageContext.request.contextPath}/citizen/report-issue" method="POST" enctype="multipart/form-data">
                            <div class="row g-4">
                                <!-- 1. Issue Title -->
                                <div class="col-md-8">
                                    <label for="title" class="form-label fw-semibold small text-muted text-uppercase">Issue Title <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="title" name="title" value="${enteredTitle}" placeholder="e.g. Deep Potholes causing traffic hazard" required>
                                </div>

                                <!-- 2. Priority -->
                                <div class="col-md-4">
                                    <label for="priority" class="form-label fw-semibold small text-muted text-uppercase">Urgency / Priority <span class="text-danger">*</span></label>
                                    <select class="form-select" id="priority" name="priority" required>
                                        <option value="LOW" ${enteredPriority == 'LOW' ? 'selected' : ''}>Low (Standard Attention)</option>
                                        <option value="MEDIUM" ${empty enteredPriority or enteredPriority == 'MEDIUM' ? 'selected' : ''}>Medium (Normal Priority)</option>
                                        <option value="HIGH" ${enteredPriority == 'HIGH' ? 'selected' : ''}>High (Urgent Resolution)</option>
                                        <option value="CRITICAL" ${enteredPriority == 'CRITICAL' ? 'selected' : ''}>Critical (Immediate Public Hazard)</option>
                                    </select>
                                </div>

                                <!-- 3. Category -->
                                <div class="col-md-6">
                                    <label for="categoryId" class="form-label fw-semibold small text-muted text-uppercase">Issue Category <span class="text-danger">*</span></label>
                                    <select class="form-select" id="categoryId" name="categoryId" required>
                                        <option value="">-- Select Problem Category --</option>
                                        <c:forEach var="cat" items="${categories}">
                                            <option value="${cat.id}" ${enteredCategoryId == cat.id ? 'selected' : ''}>
                                                ${cat.name} (${cat.departmentName != null ? cat.departmentName : 'General'})
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <!-- 4. Location / Street Address -->
                                <div class="col-md-6">
                                    <label for="location" class="form-label fw-semibold small text-muted text-uppercase">Location / Street Address <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="location" name="location" value="${enteredLocation}" placeholder="e.g. 100 Feet Road, 4th Block" required>
                                </div>

                                <!-- 5. Landmark -->
                                <div class="col-md-4">
                                    <label for="landmark" class="form-label fw-semibold small text-muted text-uppercase">Nearest Landmark</label>
                                    <input type="text" class="form-control" id="landmark" name="landmark" value="${enteredLandmark}" placeholder="e.g. Opp. Metro Pillar 140">
                                </div>

                                <!-- 6. City -->
                                <div class="col-md-4">
                                    <label for="city" class="form-label fw-semibold small text-muted text-uppercase">City / Ward</label>
                                    <input type="text" class="form-control" id="city" name="city" value="${not empty enteredCity ? enteredCity : 'Metro City'}" required>
                                </div>

                                <!-- 7. Pincode -->
                                <div class="col-md-4">
                                    <label for="pincode" class="form-label fw-semibold small text-muted text-uppercase">PIN Code (6 Digits) <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="pincode" name="pincode" value="${enteredPincode}" placeholder="e.g. 560001" pattern="[1-9][0-9]{5}" title="Please enter a valid 6-digit PIN code" required>
                                </div>

                                <!-- 8. Description -->
                                <div class="col-12">
                                    <label for="description" class="form-label fw-semibold small text-muted text-uppercase">Detailed Description <span class="text-danger">*</span></label>
                                    <textarea class="form-control" id="description" name="description" rows="4" placeholder="Provide accurate details about the problem, severity, time observed, and risks to public safety." required>${enteredDescription}</textarea>
                                </div>

                                <!-- 9. Image Upload with Live Preview -->
                                <div class="col-md-6">
                                    <label for="complaintImage" class="form-label fw-semibold small text-muted text-uppercase">Attach Photo of Issue (.jpg, .jpeg, .png)</label>
                                    <input class="form-control" type="file" id="complaintImage" name="complaintImage" accept=".jpg,.jpeg,.png" data-preview-target="imagePreviewBox">
                                    <small class="text-muted d-block mt-1">Maximum file size: 10MB.</small>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold small text-muted text-uppercase">Photo Preview</label>
                                    <div id="imagePreviewBox" class="image-preview-container p-3 text-center">
                                        <span class="text-muted"><i class="bi bi-image fs-4 d-block mb-1"></i> Preview will appear here upon selecting photo</span>
                                    </div>
                                </div>
                            </div>

                            <hr class="my-4">

                            <div class="d-flex justify-content-end gap-3">
                                <a href="${pageContext.request.contextPath}/citizen/dashboard" class="btn btn-light px-4">Cancel</a>
                                <button type="submit" class="btn btn-civic-accent px-5 py-2 fw-bold shadow-sm">
                                    <i class="bi bi-send-fill me-1"></i> Submit Complaint
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp"/>

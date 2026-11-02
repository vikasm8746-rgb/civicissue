<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="pageTitle" value="Admin Executive Dashboard – CivicConnect"/>
</jsp:include>

<jsp:include page="/WEB-INF/includes/navbar.jsp"/>

<div class="dashboard-wrapper">
    <jsp:include page="/WEB-INF/includes/sidebar-admin.jsp">
        <jsp:param name="activePage" value="dashboard"/>
    </jsp:include>

    <main class="main-content">
        <div class="container-fluid">
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
                <div>
                    <h2 class="fw-bold brand-font mb-1">Municipal Administration Dashboard</h2>
                    <p class="text-muted small mb-0">City-wide Grievance Analytics & Department Performance Monitor</p>
                </div>
                <div class="d-flex gap-2">
                    <a href="${pageContext.request.contextPath}/admin/reports" class="btn btn-outline-primary btn-sm">
                        <i class="bi bi-file-earmark-bar-graph me-1"></i> Full Analytics Report
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/manage-complaints" class="btn btn-civic-primary btn-sm">
                        <i class="bi bi-list-check me-1"></i> Manage All Complaints
                    </a>
                </div>
            </div>

            <jsp:include page="/WEB-INF/includes/alerts.jsp"/>

            <!-- Top Metric Cards -->
            <div class="row g-3 mb-4">
                <div class="col-sm-6 col-xl-2">
                    <div class="stat-card">
                        <div class="stat-card-title">Total Citizens</div>
                        <div class="stat-card-value text-dark">${stats.totalCitizens}</div>
                        <small class="text-muted"><i class="bi bi-people"></i> Registered</small>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-2">
                    <div class="stat-card">
                        <div class="stat-card-title">Total Complaints</div>
                        <div class="stat-card-value text-primary">${stats.totalComplaints}</div>
                        <small class="text-muted"><i class="bi bi-inbox"></i> All Time</small>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-2">
                    <div class="stat-card">
                        <div class="stat-card-title">Pending Review</div>
                        <div class="stat-card-value text-warning">${stats.submittedCount + stats.underReviewCount}</div>
                        <small class="text-muted"><i class="bi bi-hourglass-split"></i> Awaiting Action</small>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-2">
                    <div class="stat-card">
                        <div class="stat-card-title">In Progress</div>
                        <div class="stat-card-value text-info">${stats.inProgressCount + stats.assignedCount}</div>
                        <small class="text-muted"><i class="bi bi-tools"></i> Active Crews</small>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-2">
                    <div class="stat-card">
                        <div class="stat-card-title">Resolved</div>
                        <div class="stat-card-value text-success">${stats.resolvedCount}</div>
                        <small class="text-success fw-semibold"><i class="bi bi-check-all"></i> ${stats.resolutionRate}% Rate</small>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-2">
                    <div class="stat-card">
                        <div class="stat-card-title">Rejected</div>
                        <div class="stat-card-value text-danger">${stats.rejectedCount}</div>
                        <small class="text-muted"><i class="bi bi-x-circle"></i> Invalid/Closed</small>
                    </div>
                </div>
            </div>

            <!-- Dynamic Chart.js Analytics Section -->
            <div class="row g-4 mb-4">
                <!-- 1. Complaints by Category (Doughnut) -->
                <div class="col-lg-6 col-xl-4">
                    <div class="civic-card p-4 h-100">
                        <h5 class="fw-bold brand-font mb-3">Complaints by Category</h5>
                        <div style="position: relative; height: 260px;">
                            <canvas id="categoryChart"></canvas>
                        </div>
                    </div>
                </div>

                <!-- 2. Complaints by Status (Bar) -->
                <div class="col-lg-6 col-xl-4">
                    <div class="civic-card p-4 h-100">
                        <h5 class="fw-bold brand-font mb-3">Status Breakdown</h5>
                        <div style="position: relative; height: 260px;">
                            <canvas id="statusChart"></canvas>
                        </div>
                    </div>
                </div>

                <!-- 3. Monthly Complaints Trend (Line) -->
                <div class="col-lg-12 col-xl-4">
                    <div class="civic-card p-4 h-100">
                        <h5 class="fw-bold brand-font mb-3">Monthly Inflow Trend</h5>
                        <div style="position: relative; height: 260px;">
                            <canvas id="monthlyChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Department Workload & Recent Complaints -->
            <div class="row g-4">
                <div class="col-lg-5">
                    <div class="civic-card p-4 h-100">
                        <h5 class="fw-bold brand-font mb-3">Department Workload Distribution</h5>
                        <div style="position: relative; height: 300px;">
                            <canvas id="departmentChart"></canvas>
                        </div>
                    </div>
                </div>

                <div class="col-lg-7">
                    <div class="civic-card p-4 h-100">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="fw-bold brand-font mb-0">Recent Grievances</h5>
                            <a href="${pageContext.request.contextPath}/admin/manage-complaints" class="btn btn-sm btn-outline-primary">View All</a>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th>Code</th>
                                        <th>Title</th>
                                        <th>Citizen</th>
                                        <th>Priority</th>
                                        <th>Status</th>
                                        <th class="text-end">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="c" items="${recentComplaints}">
                                        <tr>
                                            <td><span class="fw-bold text-primary">${c.complaintCode}</span></td>
                                            <td>
                                                <div class="text-truncate fw-semibold" style="max-width: 180px;">${c.title}</div>
                                                <small class="text-muted">${c.categoryName}</small>
                                            </td>
                                            <td><span class="small">${c.citizenName}</span></td>
                                            <td><span class="badge ${c.priorityBadgeClass} badge-civic">${c.priority}</span></td>
                                            <td><span class="badge ${c.statusBadgeClass} badge-civic">${c.status}</span></td>
                                            <td class="text-end">
                                                <a href="${pageContext.request.contextPath}/admin/complaint-details?id=${c.id}" class="btn btn-sm btn-light border">
                                                    Manage
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<!-- Initialize Admin Charts with JSON data from AdminServlet -->
<script>
    document.addEventListener('DOMContentLoaded', () => {
        const categoryData = ${empty categoryChartJson ? '{}' : categoryChartJson};
        const statusData = ${empty statusChartJson ? '{}' : statusChartJson};
        const monthlyData = ${empty monthlyChartJson ? '{}' : monthlyChartJson};
        const departmentData = ${empty departmentChartJson ? '{}' : departmentChartJson};

        initAdminCharts(categoryData, statusData, monthlyData, departmentData);
    });
</script>

<jsp:include page="/WEB-INF/includes/footer.jsp"/>

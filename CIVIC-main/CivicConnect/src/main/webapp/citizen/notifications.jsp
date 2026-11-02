<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="pageTitle" value="My Notifications – CivicConnect"/>
</jsp:include>

<jsp:include page="/WEB-INF/includes/navbar.jsp"/>

<div class="dashboard-wrapper">
    <jsp:include page="/WEB-INF/includes/sidebar-citizen.jsp">
        <jsp:param name="activePage" value="notifications"/>
    </jsp:include>

    <main class="main-content">
        <div class="container-fluid">
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
                <div>
                    <h2 class="fw-bold brand-font mb-1">Notifications</h2>
                    <p class="text-muted small mb-0">Live status alerts and resolution updates for your grievances.</p>
                </div>
                <c:if test="${not empty notifications}">
                    <form action="${pageContext.request.contextPath}/notifications/mark-all-read" method="POST">
                        <button type="submit" class="btn btn-outline-secondary btn-sm">
                            <i class="bi bi-check2-all me-1"></i> Mark All as Read
                        </button>
                    </form>
                </c:if>
            </div>

            <jsp:include page="/WEB-INF/includes/alerts.jsp"/>

            <div class="civic-card p-4">
                <c:choose>
                    <c:when test="${not empty notifications}">
                        <div class="list-group list-group-flush">
                            <c:forEach var="n" items="${notifications}">
                                <div class="list-group-item list-group-item-action d-flex justify-content-between align-items-center py-3 px-3 rounded mb-2 border ${n.read ? 'bg-white' : 'bg-light border-primary'}">
                                    <div class="d-flex align-items-start gap-3">
                                        <div class="p-2 rounded-circle ${n.read ? 'bg-light text-muted' : 'bg-primary bg-opacity-10 text-primary'}">
                                            <i class="bi bi-bell-fill fs-5"></i>
                                        </div>
                                        <div>
                                            <p class="mb-1 text-dark ${n.read ? '' : 'fw-bold'}">${n.message}</p>
                                            <small class="text-muted"><i class="bi bi-clock me-1"></i>${n.formattedCreatedAt}</small>
                                        </div>
                                    </div>
                                    <div class="d-flex align-items-center gap-2">
                                        <c:if test="${not empty n.complaintId}">
                                            <a href="${pageContext.request.contextPath}/citizen/complaint-details?id=${n.complaintId}" class="btn btn-sm btn-outline-primary">
                                                View Issue
                                            </a>
                                        </c:if>
                                        <c:if test="${not n.read}">
                                            <a href="${pageContext.request.contextPath}/notifications/read?id=${n.id}" class="btn btn-sm btn-light border" title="Mark Read">
                                                <i class="bi bi-check-lg"></i>
                                            </a>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-5">
                            <i class="bi bi-bell-slash fs-1 text-muted"></i>
                            <h5 class="fw-bold mt-2">No Notifications</h5>
                            <p class="text-muted small">You are all caught up! Updates regarding your complaints will appear here.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp"/>

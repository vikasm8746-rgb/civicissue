package com.civicconnect.controller;

import com.civicconnect.model.*;
import com.civicconnect.service.ComplaintService;
import com.civicconnect.service.DepartmentService;
import com.civicconnect.service.FeedbackService;
import com.civicconnect.service.UserService;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * AdminServlet - Unified Controller for Administrator Operations:
 * Dashboard & Analytics, Complaint Management, User Management,
 * Staff Roster, Department & Category Setup, and System Reports.
 */
@WebServlet(name = "AdminServlet", urlPatterns = {
        "/admin/dashboard",
        "/admin/manage-complaints",
        "/admin/complaint-details",
        "/admin/assign-complaint",
        "/admin/update-status",
        "/admin/delete-complaint",
        "/admin/manage-users",
        "/admin/toggle-user-status",
        "/admin/delete-user",
        "/admin/manage-staff",
        "/admin/add-staff",
        "/admin/manage-departments",
        "/admin/add-department",
        "/admin/update-department",
        "/admin/delete-department",
        "/admin/manage-categories",
        "/admin/add-category",
        "/admin/update-category",
        "/admin/delete-category",
        "/admin/reports"
})
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ComplaintService complaintService;
    private DepartmentService departmentService;
    private UserService userService;
    private FeedbackService feedbackService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        this.complaintService = new ComplaintService();
        this.departmentService = new DepartmentService();
        this.userService = new UserService();
        this.feedbackService = new FeedbackService();
        this.gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case "/admin/dashboard":
                showDashboard(request, response);
                break;
            case "/admin/manage-complaints":
                showManageComplaints(request, response);
                break;
            case "/admin/complaint-details":
                showComplaintDetails(request, response);
                break;
            case "/admin/manage-users":
                showManageUsers(request, response);
                break;
            case "/admin/manage-staff":
                showManageStaff(request, response);
                break;
            case "/admin/manage-departments":
                showManageDepartments(request, response);
                break;
            case "/admin/manage-categories":
                showManageCategories(request, response);
                break;
            case "/admin/reports":
                showReports(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        User admin = (User) request.getSession().getAttribute("currentUser");

        switch (path) {
            case "/admin/assign-complaint":
                handleAssignComplaint(request, response, admin);
                break;
            case "/admin/update-status":
                handleUpdateStatus(request, response, admin);
                break;
            case "/admin/delete-complaint":
                handleDeleteComplaint(request, response);
                break;
            case "/admin/toggle-user-status":
                handleToggleUserStatus(request, response);
                break;
            case "/admin/delete-user":
                handleDeleteUser(request, response);
                break;
            case "/admin/add-staff":
                handleAddStaff(request, response);
                break;
            case "/admin/add-department":
                handleAddDepartment(request, response);
                break;
            case "/admin/update-department":
                handleUpdateDepartment(request, response);
                break;
            case "/admin/delete-department":
                handleDeleteDepartment(request, response);
                break;
            case "/admin/add-category":
                handleAddCategory(request, response);
                break;
            case "/admin/update-category":
                handleUpdateCategory(request, response);
                break;
            case "/admin/delete-category":
                handleDeleteCategory(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                break;
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DashboardStats stats = complaintService.getDashboardStats(null, null);
        List<Complaint> recent = complaintService.getRecentComplaints(6);

        request.setAttribute("stats", stats);
        request.setAttribute("recentComplaints", recent);

        // Serialize chart data to JSON for Chart.js
        request.setAttribute("categoryChartJson", gson.toJson(stats.getComplaintsByCategory()));
        request.setAttribute("statusChartJson", gson.toJson(stats.getComplaintsByStatus()));
        request.setAttribute("departmentChartJson", gson.toJson(stats.getComplaintsByDepartment()));
        request.setAttribute("monthlyChartJson", gson.toJson(stats.getMonthlyComplaints()));

        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }

    private void showManageComplaints(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String status = request.getParameter("status");
        String deptStr = request.getParameter("departmentId");
        String priority = request.getParameter("priority");
        String search = request.getParameter("search");
        String pageStr = request.getParameter("page");

        Integer deptId = null;
        try {
            if (deptStr != null && !deptStr.trim().isEmpty() && !"0".equals(deptStr)) {
                deptId = Integer.parseInt(deptStr.trim());
            }
        } catch (NumberFormatException ignored) {}

        int page = 1;
        int pageSize = 15;
        try {
            if (pageStr != null) page = Math.max(1, Integer.parseInt(pageStr.trim()));
        } catch (NumberFormatException ignored) {}

        List<Complaint> complaints = complaintService.getFilteredComplaints(status, deptId, priority, search, page, pageSize);
        int totalRecords = complaintService.countFilteredComplaints(status, deptId, priority, search);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        List<Department> departments = departmentService.getActiveDepartments();

        request.setAttribute("complaints", complaints);
        request.setAttribute("departments", departments);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("selectedDept", deptId);
        request.setAttribute("selectedPriority", priority);
        request.setAttribute("searchQuery", search);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);

        request.getRequestDispatcher("/admin/manage-complaints.jsp").forward(request, response);
    }

    private void showComplaintDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-complaints?error=Invalid+complaint+ID.");
            return;
        }

        int id = Integer.parseInt(idStr.trim());
        Complaint complaint = complaintService.getComplaintById(id);
        if (complaint == null) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-complaints?error=Complaint+not+found.");
            return;
        }

        List<StatusHistory> timeline = complaintService.getStatusHistory(id);
        List<Department> departments = departmentService.getActiveDepartments();
        List<User> allStaff = userService.getAllStaff();

        request.setAttribute("complaint", complaint);
        request.setAttribute("timeline", timeline);
        request.setAttribute("departments", departments);
        request.setAttribute("staffList", allStaff);

        request.getRequestDispatcher("/admin/complaint-details.jsp").forward(request, response);
    }

    private void handleAssignComplaint(HttpServletRequest request, HttpServletResponse response, User admin)
            throws IOException {
        int complaintId = Integer.parseInt(request.getParameter("complaintId"));
        int departmentId = Integer.parseInt(request.getParameter("departmentId"));
        String staffIdStr = request.getParameter("staffId");
        String adminRemarks = request.getParameter("adminRemarks");

        Integer staffId = null;
        try {
            if (staffIdStr != null && !staffIdStr.trim().isEmpty() && !"0".equals(staffIdStr)) {
                staffId = Integer.parseInt(staffIdStr.trim());
            }
        } catch (NumberFormatException ignored) {}

        boolean assigned = complaintService.assignComplaint(complaintId, departmentId, staffId, adminRemarks, admin.getId());
        if (assigned) {
            response.sendRedirect(request.getContextPath() + "/admin/complaint-details?id=" + complaintId + "&success=Complaint+assigned+successfully!");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/complaint-details?id=" + complaintId + "&error=Failed+to+assign+complaint.");
        }
    }

    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response, User admin)
            throws IOException {
        int complaintId = Integer.parseInt(request.getParameter("complaintId"));
        String newStatus = request.getParameter("newStatus");
        String remarks = request.getParameter("adminRemarks");

        boolean updated = complaintService.updateStatus(complaintId, newStatus, remarks, null, null, admin.getId());
        if (updated) {
            response.sendRedirect(request.getContextPath() + "/admin/complaint-details?id=" + complaintId + "&success=Status+updated+to+" + newStatus + "+successfully!");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/complaint-details?id=" + complaintId + "&error=Failed+to+update+status.");
        }
    }

    private void handleDeleteComplaint(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int complaintId = Integer.parseInt(request.getParameter("complaintId"));
        boolean deleted = complaintService.deleteComplaint(complaintId);
        if (deleted) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-complaints?success=Complaint+deleted+successfully.");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/manage-complaints?error=Failed+to+delete+complaint.");
        }
    }

    private void showManageUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<User> citizens = userService.getAllCitizens();
        request.setAttribute("citizens", citizens);
        request.getRequestDispatcher("/admin/manage-users.jsp").forward(request, response);
    }

    private void handleToggleUserStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String newStatus = request.getParameter("status");
        String returnTo = request.getParameter("returnTo");

        userService.toggleUserStatus(userId, newStatus);
        String target = "staff".equalsIgnoreCase(returnTo) ? "/admin/manage-staff" : "/admin/manage-users";
        response.sendRedirect(request.getContextPath() + target + "?success=User+status+updated+to+" + newStatus);
    }

    private void handleDeleteUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String returnTo = request.getParameter("returnTo");

        userService.deleteUser(userId);
        String target = "staff".equalsIgnoreCase(returnTo) ? "/admin/manage-staff" : "/admin/manage-users";
        response.sendRedirect(request.getContextPath() + target + "?success=User+account+deleted+successfully.");
    }

    private void showManageStaff(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<User> staffList = userService.getAllStaff();
        List<Department> departments = departmentService.getActiveDepartments();

        request.setAttribute("staffList", staffList);
        request.setAttribute("departments", departments);
        request.getRequestDispatcher("/admin/manage-staff.jsp").forward(request, response);
    }

    private void handleAddStaff(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        int departmentId = Integer.parseInt(request.getParameter("departmentId"));

        User staff = new User(fullName, email, phone, username, password, "STAFF");
        staff.setDepartmentId(departmentId);

        String result = userService.createStaffUser(staff, password);
        if ("SUCCESS".equals(result)) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-staff?success=Staff+member+added+successfully!");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/manage-staff?error=" + result);
        }
    }

    private void showManageDepartments(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Department> departments = departmentService.getAllDepartments();
        request.setAttribute("departments", departments);
        request.getRequestDispatcher("/admin/manage-departments.jsp").forward(request, response);
    }

    private void handleAddDepartment(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String name = request.getParameter("name");
        String description = request.getParameter("description");

        Department dept = new Department(0, name, description, "ACTIVE");
        boolean created = departmentService.addDepartment(dept);
        if (created) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-departments?success=Department+added+successfully!");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/manage-departments?error=Failed+to+add+department.+Name+may+already+exist.");
        }
    }

    private void handleUpdateDepartment(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String status = request.getParameter("status");

        Department dept = new Department(id, name, description, status);
        departmentService.updateDepartment(dept);
        response.sendRedirect(request.getContextPath() + "/admin/manage-departments?success=Department+updated+successfully!");
    }

    private void handleDeleteDepartment(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        departmentService.deleteDepartment(id);
        response.sendRedirect(request.getContextPath() + "/admin/manage-departments?success=Department+deleted+successfully.");
    }

    private void showManageCategories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> categories = departmentService.getAllCategories();
        List<Department> departments = departmentService.getActiveDepartments();

        request.setAttribute("categories", categories);
        request.setAttribute("departments", departments);
        request.getRequestDispatcher("/admin/manage-categories.jsp").forward(request, response);
    }

    private void handleAddCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        int departmentId = Integer.parseInt(request.getParameter("departmentId"));

        Category cat = new Category(0, departmentId, name, description, "ACTIVE");
        boolean created = departmentService.addCategory(cat);
        if (created) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-categories?success=Category+added+successfully!");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/manage-categories?error=Failed+to+add+category.");
        }
    }

    private void handleUpdateCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        int departmentId = Integer.parseInt(request.getParameter("departmentId"));
        String status = request.getParameter("status");

        Category cat = new Category(id, departmentId, name, description, status);
        departmentService.updateCategory(cat);
        response.sendRedirect(request.getContextPath() + "/admin/manage-categories?success=Category+updated+successfully!");
    }

    private void handleDeleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        departmentService.deleteCategory(id);
        response.sendRedirect(request.getContextPath() + "/admin/manage-categories?success=Category+deleted+successfully.");
    }

    private void showReports(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DashboardStats stats = complaintService.getDashboardStats(null, null);
        List<Complaint> allComplaints = complaintService.getFilteredComplaints(null, null, null, null, 1, 100);
        List<Feedback> feedbacks = feedbackService.getAllFeedbacks(20);
        List<Department> departments = departmentService.getAllDepartments();

        request.setAttribute("stats", stats);
        request.setAttribute("complaints", allComplaints);
        request.setAttribute("feedbacks", feedbacks);
        request.setAttribute("departments", departments);

        request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);
    }
}

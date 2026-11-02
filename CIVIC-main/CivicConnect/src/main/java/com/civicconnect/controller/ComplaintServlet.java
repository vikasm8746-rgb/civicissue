package com.civicconnect.controller;

import com.civicconnect.model.Category;
import com.civicconnect.model.Complaint;
import com.civicconnect.model.DashboardStats;
import com.civicconnect.model.StatusHistory;
import com.civicconnect.model.User;
import com.civicconnect.service.ComplaintService;
import com.civicconnect.service.DepartmentService;
import com.civicconnect.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * ComplaintServlet - Handles Citizen dashboard, complaint registration with file upload,
 * complaint listing, and complaint details with timeline tracking.
 */
@WebServlet(name = "ComplaintServlet", urlPatterns = {
        "/citizen/dashboard",
        "/citizen/report-issue",
        "/citizen/my-complaints",
        "/citizen/complaint-details"
})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,      // 1 MB
        maxFileSize = 1024 * 1024 * 10,       // 10 MB
        maxRequestSize = 1024 * 1024 * 15     // 15 MB
)
public class ComplaintServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(ComplaintServlet.class.getName());

    private ComplaintService complaintService;
    private DepartmentService departmentService;

    @Override
    public void init() throws ServletException {
        this.complaintService = new ComplaintService();
        this.departmentService = new DepartmentService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        User currentUser = (User) request.getSession().getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        switch (path) {
            case "/citizen/dashboard":
                showDashboard(request, response, currentUser);
                break;
            case "/citizen/report-issue":
                showReportIssueForm(request, response);
                break;
            case "/citizen/my-complaints":
                showMyComplaints(request, response, currentUser);
                break;
            case "/citizen/complaint-details":
                showComplaintDetails(request, response, currentUser);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/citizen/dashboard");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        User currentUser = (User) request.getSession().getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        if ("/citizen/report-issue".equals(path)) {
            handleReportIssueSubmission(request, response, currentUser);
        } else {
            response.sendRedirect(request.getContextPath() + "/citizen/dashboard");
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        DashboardStats stats = complaintService.getDashboardStats(user.getId(), null);
        List<Complaint> myComplaints = complaintService.getComplaintsByUser(user.getId());
        List<Complaint> recentComplaints = myComplaints.size() > 5 ? myComplaints.subList(0, 5) : myComplaints;

        request.setAttribute("stats", stats);
        request.setAttribute("recentComplaints", recentComplaints);
        request.getRequestDispatcher("/citizen/dashboard.jsp").forward(request, response);
    }

    private void showReportIssueForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> categories = departmentService.getActiveCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/citizen/report-issue.jsp").forward(request, response);
    }

    private void showMyComplaints(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        List<Complaint> complaints = complaintService.getComplaintsByUser(user.getId());
        List<Category> categories = departmentService.getActiveCategories();

        request.setAttribute("complaints", complaints);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/citizen/my-complaints.jsp").forward(request, response);
    }

    private void showComplaintDetails(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        String codeParam = request.getParameter("code");

        Complaint complaint = null;
        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                complaint = complaintService.getComplaintById(Integer.parseInt(idParam.trim()));
            } catch (NumberFormatException ignored) {}
        } else if (codeParam != null && !codeParam.trim().isEmpty()) {
            complaint = complaintService.getComplaintByCode(codeParam.trim());
        }

        if (complaint == null) {
            response.sendRedirect(request.getContextPath() + "/citizen/my-complaints?error=Complaint+not+found.");
            return;
        }

        // Security verification: Ensure the citizen owns this complaint or is staff/admin
        if (complaint.getUserId() != user.getId() && !user.isAdmin() && !user.isStaff()) {
            response.sendRedirect(request.getContextPath() + "/citizen/my-complaints?error=You+are+not+authorized+to+view+this+complaint.");
            return;
        }

        List<StatusHistory> timeline = complaintService.getStatusHistory(complaint.getId());
        request.setAttribute("complaint", complaint);
        request.setAttribute("timeline", timeline);
        request.getRequestDispatcher("/citizen/complaint-details.jsp").forward(request, response);
    }

    private void handleReportIssueSubmission(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String title = request.getParameter("title");
        String categoryIdStr = request.getParameter("categoryId");
        String description = request.getParameter("description");
        String location = request.getParameter("location");
        String landmark = request.getParameter("landmark");
        String city = request.getParameter("city");
        String pincode = request.getParameter("pincode");
        String priority = request.getParameter("priority");

        int categoryId = 0;
        try {
            if (categoryIdStr != null) categoryId = Integer.parseInt(categoryIdStr.trim());
        } catch (NumberFormatException ignored) {}

        // Handle Image Upload
        String uploadedImagePath = null;
        try {
            Part filePart = request.getPart("complaintImage");
            if (filePart != null && filePart.getSize() > 0) {
                String submittedFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                if (ValidationUtil.isAllowedImageExtension(submittedFileName)) {
                    String uploadDir = getServletContext().getRealPath("/uploads");
                    File uploadDirFile = new File(uploadDir);
                    if (!uploadDirFile.exists()) {
                        uploadDirFile.mkdirs();
                    }

                    String uniqueFileName = UUID.randomUUID().toString() + "_" + submittedFileName.replaceAll("\\s+", "_");
                    File targetFile = new File(uploadDirFile, uniqueFileName);

                    try (InputStream input = filePart.getInputStream()) {
                        Files.copy(input, targetFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                        uploadedImagePath = "uploads/" + uniqueFileName;
                    }
                } else {
                    request.setAttribute("errorMessage", "Invalid image format. Only JPG, JPEG, and PNG are allowed.");
                    showReportIssueForm(request, response);
                    return;
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Image upload failed or empty part: " + e.getMessage());
        }

        Complaint complaint = new Complaint();
        complaint.setUserId(user.getId());
        complaint.setCategoryId(categoryId);
        complaint.setTitle(title);
        complaint.setDescription(description);
        complaint.setLocation(location);
        complaint.setLandmark(landmark);
        complaint.setCity(city != null && !city.trim().isEmpty() ? city : "Metro City");
        complaint.setPincode(pincode);
        complaint.setPriority(priority);
        complaint.setImagePath(uploadedImagePath);

        String result = complaintService.submitComplaint(complaint);
        if ("SUCCESS".equals(result)) {
            response.sendRedirect(request.getContextPath() + "/citizen/my-complaints?success=Complaint+submitted+successfully!+Complaint+ID:+" + complaint.getComplaintCode());
        } else {
            request.setAttribute("errorMessage", result);
            request.setAttribute("enteredTitle", title);
            request.setAttribute("enteredCategoryId", categoryId);
            request.setAttribute("enteredDescription", description);
            request.setAttribute("enteredLocation", location);
            request.setAttribute("enteredLandmark", landmark);
            request.setAttribute("enteredCity", city);
            request.setAttribute("enteredPincode", pincode);
            request.setAttribute("enteredPriority", priority);
            showReportIssueForm(request, response);
        }
    }
}

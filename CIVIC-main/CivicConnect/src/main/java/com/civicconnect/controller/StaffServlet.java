package com.civicconnect.controller;

import com.civicconnect.model.Complaint;
import com.civicconnect.model.DashboardStats;
import com.civicconnect.model.StatusHistory;
import com.civicconnect.model.User;
import com.civicconnect.service.ComplaintService;
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
 * StaffServlet - Handles Staff Dashboard, assigned complaint management, status updates,
 * remarks, and resolution proof image uploads.
 */
@WebServlet(name = "StaffServlet", urlPatterns = {
        "/staff/dashboard",
        "/staff/assigned-complaints",
        "/staff/complaint-details",
        "/staff/update-status"
})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,      // 1 MB
        maxFileSize = 1024 * 1024 * 10,       // 10 MB
        maxRequestSize = 1024 * 1024 * 15     // 15 MB
)
public class StaffServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(StaffServlet.class.getName());

    private ComplaintService complaintService;

    @Override
    public void init() throws ServletException {
        this.complaintService = new ComplaintService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        User staff = (User) request.getSession().getAttribute("currentUser");

        if (staff == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        switch (path) {
            case "/staff/dashboard":
                showDashboard(request, response, staff);
                break;
            case "/staff/assigned-complaints":
                showAssignedComplaints(request, response, staff);
                break;
            case "/staff/complaint-details":
                showComplaintDetails(request, response, staff);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/staff/dashboard");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        User staff = (User) request.getSession().getAttribute("currentUser");

        if (staff == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        if ("/staff/update-status".equals(path)) {
            handleStatusUpdate(request, response, staff);
        } else {
            response.sendRedirect(request.getContextPath() + "/staff/dashboard");
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response, User staff)
            throws ServletException, IOException {
        DashboardStats stats = complaintService.getDashboardStats(null, staff.getId());
        List<Complaint> assignedList = complaintService.getComplaintsByStaff(staff.getId());
        List<Complaint> recentAssigned = assignedList.size() > 6 ? assignedList.subList(0, 6) : assignedList;

        request.setAttribute("stats", stats);
        request.setAttribute("recentAssigned", recentAssigned);
        request.getRequestDispatcher("/staff/dashboard.jsp").forward(request, response);
    }

    private void showAssignedComplaints(HttpServletRequest request, HttpServletResponse response, User staff)
            throws ServletException, IOException {
        List<Complaint> complaints = complaintService.getComplaintsByStaff(staff.getId());
        request.setAttribute("complaints", complaints);
        request.getRequestDispatcher("/staff/assigned-complaints.jsp").forward(request, response);
    }

    private void showComplaintDetails(HttpServletRequest request, HttpServletResponse response, User staff)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/staff/assigned-complaints?error=Invalid+complaint+ID.");
            return;
        }

        int id = Integer.parseInt(idStr.trim());
        Complaint complaint = complaintService.getComplaintById(id);

        if (complaint == null) {
            response.sendRedirect(request.getContextPath() + "/staff/assigned-complaints?error=Complaint+not+found.");
            return;
        }

        // Verify assignment
        if (complaint.getAssignedStaffId() == null || complaint.getAssignedStaffId() != staff.getId()) {
            response.sendRedirect(request.getContextPath() + "/staff/assigned-complaints?error=This+complaint+is+not+assigned+to+you.");
            return;
        }

        List<StatusHistory> timeline = complaintService.getStatusHistory(complaint.getId());
        request.setAttribute("complaint", complaint);
        request.setAttribute("timeline", timeline);
        request.getRequestDispatcher("/staff/complaint-details.jsp").forward(request, response);
    }

    private void handleStatusUpdate(HttpServletRequest request, HttpServletResponse response, User staff)
            throws ServletException, IOException {
        String idStr = request.getParameter("complaintId");
        String newStatus = request.getParameter("newStatus");
        String staffRemarks = request.getParameter("staffRemarks");

        if (idStr == null || newStatus == null) {
            response.sendRedirect(request.getContextPath() + "/staff/assigned-complaints?error=Missing+required+fields.");
            return;
        }

        int complaintId = Integer.parseInt(idStr.trim());
        Complaint complaint = complaintService.getComplaintById(complaintId);

        if (complaint == null || complaint.getAssignedStaffId() == null || complaint.getAssignedStaffId() != staff.getId()) {
            response.sendRedirect(request.getContextPath() + "/staff/assigned-complaints?error=Unauthorized+operation.");
            return;
        }

        // Handle Resolution Proof Image Upload
        String resolutionImagePath = null;
        try {
            Part filePart = request.getPart("resolutionImage");
            if (filePart != null && filePart.getSize() > 0) {
                String submittedFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                if (ValidationUtil.isAllowedImageExtension(submittedFileName)) {
                    String uploadDir = getServletContext().getRealPath("/uploads");
                    File uploadDirFile = new File(uploadDir);
                    if (!uploadDirFile.exists()) {
                        uploadDirFile.mkdirs();
                    }

                    String uniqueFileName = "res_" + UUID.randomUUID().toString() + "_" + submittedFileName.replaceAll("\\s+", "_");
                    File targetFile = new File(uploadDirFile, uniqueFileName);

                    try (InputStream input = filePart.getInputStream()) {
                        Files.copy(input, targetFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                        resolutionImagePath = "uploads/" + uniqueFileName;
                    }
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Resolution image upload exception: " + e.getMessage());
        }

        boolean updated = complaintService.updateStatus(complaintId, newStatus, null, staffRemarks, resolutionImagePath, staff.getId());
        if (updated) {
            response.sendRedirect(request.getContextPath() + "/staff/complaint-details?id=" + complaintId + "&success=Complaint+status+updated+to+" + newStatus + "+successfully!");
        } else {
            response.sendRedirect(request.getContextPath() + "/staff/complaint-details?id=" + complaintId + "&error=Failed+to+update+complaint+status.");
        }
    }
}

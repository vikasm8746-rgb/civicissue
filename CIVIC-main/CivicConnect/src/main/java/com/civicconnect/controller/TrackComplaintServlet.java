package com.civicconnect.controller;

import com.civicconnect.model.Complaint;
import com.civicconnect.model.StatusHistory;
import com.civicconnect.service.ComplaintService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * TrackComplaintServlet - Public & universal complaint tracking endpoint.
 */
@WebServlet(name = "TrackComplaintServlet", urlPatterns = {"/track", "/TrackComplaintServlet"})
public class TrackComplaintServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ComplaintService complaintService;

    @Override
    public void init() throws ServletException {
        this.complaintService = new ComplaintService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");
        if (code != null && !code.trim().isEmpty()) {
            lookupComplaint(code.trim(), request, response);
        } else {
            request.getRequestDispatcher("/track-complaint.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("complaintCode");
        lookupComplaint(code != null ? code.trim() : "", request, response);
    }

    private void lookupComplaint(String code, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (code.isEmpty()) {
            request.setAttribute("errorMessage", "Please enter a valid Complaint ID.");
            request.getRequestDispatcher("/track-complaint.jsp").forward(request, response);
            return;
        }

        Complaint complaint = complaintService.getComplaintByCode(code);
        if (complaint != null) {
            List<StatusHistory> timeline = complaintService.getStatusHistory(complaint.getId());
            request.setAttribute("complaint", complaint);
            request.setAttribute("timeline", timeline);
            request.setAttribute("searchedCode", code);
        } else {
            request.setAttribute("errorMessage", "No complaint found with ID: " + code + ". Please verify the number.");
            request.setAttribute("searchedCode", code);
        }
        request.getRequestDispatcher("/track-complaint.jsp").forward(request, response);
    }
}

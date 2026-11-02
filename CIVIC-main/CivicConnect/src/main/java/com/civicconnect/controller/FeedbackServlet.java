package com.civicconnect.controller;

import com.civicconnect.model.Feedback;
import com.civicconnect.model.User;
import com.civicconnect.service.FeedbackService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * FeedbackServlet - Handles Citizen feedback and ratings for resolved complaints.
 */
@WebServlet(name = "FeedbackServlet", urlPatterns = {"/citizen/feedback", "/FeedbackServlet"})
public class FeedbackServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private FeedbackService feedbackService;

    @Override
    public void init() throws ServletException {
        this.feedbackService = new FeedbackService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String complaintIdStr = request.getParameter("complaintId");
        String ratingStr = request.getParameter("rating");
        String comment = request.getParameter("comment");

        if (complaintIdStr == null || ratingStr == null) {
            response.sendRedirect(request.getContextPath() + "/citizen/my-complaints?error=Invalid+feedback+submission.");
            return;
        }

        try {
            int complaintId = Integer.parseInt(complaintIdStr.trim());
            int rating = Integer.parseInt(ratingStr.trim());

            Feedback feedback = new Feedback(complaintId, user.getId(), rating, comment != null ? comment.trim() : "");
            boolean saved = feedbackService.submitFeedback(feedback);

            if (saved) {
                response.sendRedirect(request.getContextPath() + "/citizen/complaint-details?id=" + complaintId + "&success=Thank+you!+Your+feedback+has+been+recorded.");
            } else {
                response.sendRedirect(request.getContextPath() + "/citizen/complaint-details?id=" + complaintId + "&error=Failed+to+save+feedback.");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/citizen/my-complaints?error=Invalid+input+parameters.");
        }
    }
}

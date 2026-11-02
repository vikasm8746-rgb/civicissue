package com.civicconnect.service;

import com.civicconnect.dao.FeedbackDAO;
import com.civicconnect.model.Feedback;

import java.util.List;

/**
 * Service managing citizen satisfaction feedback.
 */
public class FeedbackService {

    private final FeedbackDAO feedbackDAO;

    public FeedbackService() {
        this.feedbackDAO = new FeedbackDAO();
    }

    public boolean submitFeedback(Feedback feedback) {
        if (feedback == null || feedback.getRating() < 1 || feedback.getRating() > 5) {
            return false;
        }
        return feedbackDAO.addFeedback(feedback);
    }

    public Feedback getFeedbackByComplaintId(int complaintId) {
        return feedbackDAO.getFeedbackByComplaintId(complaintId);
    }

    public List<Feedback> getAllFeedbacks(int limit) {
        return feedbackDAO.getAllFeedbacks(limit);
    }
}

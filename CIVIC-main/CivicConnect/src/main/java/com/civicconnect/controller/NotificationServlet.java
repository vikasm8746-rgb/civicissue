package com.civicconnect.controller;

import com.civicconnect.dao.NotificationDAO;
import com.civicconnect.model.Notification;
import com.civicconnect.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * NotificationServlet - Handles User Notifications and Read State.
 */
@WebServlet(name = "NotificationServlet", urlPatterns = {
        "/citizen/notifications",
        "/notifications/read",
        "/notifications/mark-all-read"
})
public class NotificationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private NotificationDAO notificationDAO;

    @Override
    public void init() throws ServletException {
        this.notificationDAO = new NotificationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String path = request.getServletPath();
        if ("/citizen/notifications".equals(path)) {
            List<Notification> list = notificationDAO.getNotificationsByUserId(user.getId(), false);
            request.setAttribute("notifications", list);
            request.getRequestDispatcher("/citizen/notifications.jsp").forward(request, response);
        } else if ("/notifications/read".equals(path)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    notificationDAO.markAsRead(id);
                } catch (NumberFormatException ignored) {}
            }
            String redirectUrl = request.getParameter("redirect");
            if (redirectUrl != null && !redirectUrl.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + redirectUrl);
            } else {
                response.sendRedirect(request.getContextPath() + "/citizen/notifications");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String path = request.getServletPath();
        if ("/notifications/mark-all-read".equals(path)) {
            notificationDAO.markAllAsRead(user.getId());
            response.sendRedirect(request.getContextPath() + "/citizen/notifications?success=All+notifications+marked+as+read.");
        }
    }
}

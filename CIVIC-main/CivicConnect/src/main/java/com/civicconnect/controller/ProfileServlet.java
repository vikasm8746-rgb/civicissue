package com.civicconnect.controller;

import com.civicconnect.model.User;
import com.civicconnect.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * ProfileServlet - User Profile Management and Password Update.
 */
@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile", "/ProfileServlet"})
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private UserService userService;

    @Override
    public void init() throws ServletException {
        this.userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User freshUser = userService.getUserById(currentUser.getId());
        if (freshUser != null) {
            request.getSession().setAttribute("currentUser", freshUser);
            request.setAttribute("user", freshUser);
        } else {
            request.setAttribute("user", currentUser);
        }

        if (currentUser.isCitizen()) {
            request.getRequestDispatcher("/citizen/profile.jsp").forward(request, response);
        } else if (currentUser.isStaff()) {
            request.getRequestDispatcher("/staff/profile.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/citizen/profile.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("updateProfile".equalsIgnoreCase(action)) {
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");

            currentUser.setFullName(fullName);
            currentUser.setEmail(email);
            currentUser.setPhone(phone);

            boolean updated = userService.updateProfile(currentUser);
            if (updated) {
                request.getSession().setAttribute("currentUser", currentUser);
                response.sendRedirect(request.getContextPath() + "/profile?success=Profile+updated+successfully!");
            } else {
                response.sendRedirect(request.getContextPath() + "/profile?error=Failed+to+update+profile.");
            }
        } else if ("changePassword".equalsIgnoreCase(action)) {
            String currentPass = request.getParameter("currentPassword");
            String newPass = request.getParameter("newPassword");
            String confirmPass = request.getParameter("confirmPassword");

            if (newPass == null || !newPass.equals(confirmPass)) {
                response.sendRedirect(request.getContextPath() + "/profile?error=New+passwords+do+not+match.");
                return;
            }

            boolean changed = userService.changePassword(currentUser.getId(), currentPass, newPass);
            if (changed) {
                response.sendRedirect(request.getContextPath() + "/profile?success=Password+changed+successfully!");
            } else {
                response.sendRedirect(request.getContextPath() + "/profile?error=Current+password+incorrect+or+invalid+new+password.");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/profile");
        }
    }
}

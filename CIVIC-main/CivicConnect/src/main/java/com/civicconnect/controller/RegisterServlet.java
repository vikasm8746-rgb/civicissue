package com.civicconnect.controller;

import com.civicconnect.model.User;
import com.civicconnect.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * RegisterServlet - Citizen self-registration endpoint.
 */
@WebServlet(name = "RegisterServlet", urlPatterns = {"/register", "/RegisterServlet"})
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private UserService userService;

    @Override
    public void init() throws ServletException {
        this.userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (password == null || !password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match.");
            preserveFormFields(request, fullName, email, phone, username);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        User user = new User(fullName, email, phone, username, password, "CITIZEN");
        String result = userService.registerCitizen(user, password);

        if ("SUCCESS".equals(result)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?success=Registration+successful!+Please+login+with+your+credentials.");
        } else {
            request.setAttribute("errorMessage", result);
            preserveFormFields(request, fullName, email, phone, username);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }

    private void preserveFormFields(HttpServletRequest request, String fullName, String email, String phone, String username) {
        request.setAttribute("fullName", fullName);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
        request.setAttribute("username", username);
    }
}

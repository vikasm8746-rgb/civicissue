package com.civicconnect.filter;

import com.civicconnect.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * AuthenticationFilter - Intercepts requests to role-protected paths:
 * /citizen/*, /staff/*, /admin/* and ensures authorized session access.
 */
@WebFilter(filterName = "AuthenticationFilter", urlPatterns = {"/citizen/*", "/staff/*", "/admin/*", "/profile"})
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Prevent caching for secure pages
        httpResponse.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        httpResponse.setHeader("Pragma", "no-cache");
        httpResponse.setDateHeader("Expires", 0);

        HttpSession session = httpRequest.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        String uri = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = uri.substring(contextPath.length());

        if (currentUser == null) {
            // Not authenticated -> redirect to login
            httpResponse.sendRedirect(contextPath + "/login.jsp?error=Please+login+to+access+this+page");
            return;
        }

        // Role-based Access Control (RBAC)
        if (path.startsWith("/citizen/") && !currentUser.isCitizen()) {
            httpResponse.sendRedirect(contextPath + "/index.jsp?error=Access+denied.+Citizen+portal+only.");
            return;
        }

        if (path.startsWith("/staff/") && !currentUser.isStaff()) {
            httpResponse.sendRedirect(contextPath + "/index.jsp?error=Access+denied.+Staff+portal+only.");
            return;
        }

        if (path.startsWith("/admin/") && !currentUser.isAdmin()) {
            httpResponse.sendRedirect(contextPath + "/index.jsp?error=Access+denied.+Admin+portal+only.");
            return;
        }

        // Authorized -> continue filter chain
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup
    }
}

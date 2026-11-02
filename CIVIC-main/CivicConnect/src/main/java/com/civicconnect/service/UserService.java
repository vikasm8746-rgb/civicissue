package com.civicconnect.service;

import com.civicconnect.dao.UserDAO;
import com.civicconnect.model.User;
import com.civicconnect.util.PasswordUtil;
import com.civicconnect.util.ValidationUtil;

import java.util.List;

/**
 * Service handling User accounts, authentication, and staff rosters.
 */
public class UserService {

    private final UserDAO userDAO;

    public UserService() {
        this.userDAO = new UserDAO();
    }

    public UserService(UserDAO userDAO) {
        this.userDAO = userDAO;
    }

    public String registerCitizen(User user, String plainPassword) {
        if (!ValidationUtil.isNotEmpty(user.getFullName())) {
            return "Full Name is required.";
        }
        if (!ValidationUtil.isValidEmail(user.getEmail())) {
            return "Please provide a valid email address.";
        }
        if (!ValidationUtil.isValidPhone(user.getPhone())) {
            return "Please provide a valid 10-digit phone number.";
        }
        if (!ValidationUtil.isValidUsername(user.getUsername())) {
            return "Username must be 3-30 characters (letters, numbers, underscores).";
        }
        if (plainPassword == null || plainPassword.length() < 6) {
            return "Password must be at least 6 characters long.";
        }

        if (userDAO.getUserByUsername(user.getUsername()) != null) {
            return "Username is already taken. Please choose another.";
        }
        if (userDAO.getUserByEmail(user.getEmail()) != null) {
            return "Email is already registered. Please login or use a different email.";
        }

        user.setPassword(PasswordUtil.hashPassword(plainPassword));
        user.setRole("CITIZEN");
        user.setStatus("ACTIVE");

        boolean created = userDAO.register(user);
        return created ? "SUCCESS" : "An error occurred during registration. Please try again.";
    }

    public User authenticate(String usernameOrEmail, String plainPassword) {
        if (!ValidationUtil.isNotEmpty(usernameOrEmail) || !ValidationUtil.isNotEmpty(plainPassword)) {
            return null;
        }
        String hashedPassword = PasswordUtil.hashPassword(plainPassword);
        User user = userDAO.authenticate(usernameOrEmail.trim(), hashedPassword);
        if (user != null && user.isActive()) {
            return user;
        }
        return null;
    }

    public User getUserById(int id) {
        return userDAO.getUserById(id);
    }

    public boolean updateProfile(User user) {
        return userDAO.updateUser(user);
    }

    public boolean changePassword(int userId, String currentPlainPassword, String newPlainPassword) {
        User user = userDAO.getUserById(userId);
        if (user == null || newPlainPassword == null || newPlainPassword.length() < 6) {
            return false;
        }
        if (!PasswordUtil.verifyPassword(currentPlainPassword, user.getPassword())) {
            return false;
        }
        String newHashed = PasswordUtil.hashPassword(newPlainPassword);
        return userDAO.updatePassword(userId, newHashed);
    }

    public String createStaffUser(User staff, String plainPassword) {
        if (!ValidationUtil.isNotEmpty(staff.getFullName()) ||
            !ValidationUtil.isValidEmail(staff.getEmail()) ||
            !ValidationUtil.isValidPhone(staff.getPhone()) ||
            !ValidationUtil.isValidUsername(staff.getUsername())) {
            return "Invalid staff information provided.";
        }
        if (userDAO.getUserByUsername(staff.getUsername()) != null) {
            return "Staff username is already taken.";
        }
        if (userDAO.getUserByEmail(staff.getEmail()) != null) {
            return "Staff email is already registered.";
        }

        staff.setPassword(PasswordUtil.hashPassword(plainPassword));
        staff.setRole("STAFF");
        staff.setStatus("ACTIVE");

        boolean created = userDAO.register(staff);
        return created ? "SUCCESS" : "Failed to create staff account.";
    }

    public List<User> getAllCitizens() {
        return userDAO.getAllCitizens();
    }

    public List<User> getAllStaff() {
        return userDAO.getAllStaff();
    }

    public List<User> getStaffByDepartment(int departmentId) {
        return userDAO.getStaffByDepartment(departmentId);
    }

    public boolean toggleUserStatus(int userId, String newStatus) {
        return userDAO.toggleUserStatus(userId, newStatus);
    }

    public boolean deleteUser(int userId) {
        return userDAO.deleteUser(userId);
    }
}

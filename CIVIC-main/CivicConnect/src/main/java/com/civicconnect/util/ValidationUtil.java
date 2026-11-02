package com.civicconnect.util;

import java.util.regex.Pattern;

/**
 * ValidationUtil - Centralized Input and Server-Side Validation Helper.
 */
public class ValidationUtil {

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$");

    private static final Pattern PHONE_PATTERN =
            Pattern.compile("^[0-9]{10,12}$");

    private static final Pattern PINCODE_PATTERN =
            Pattern.compile("^[1-9][0-9]{5}$");

    private static final Pattern USERNAME_PATTERN =
            Pattern.compile("^[a-zA-Z0-9_]{3,30}$");

    private ValidationUtil() {
    }

    public static boolean isNotEmpty(String str) {
        return str != null && !str.trim().isEmpty();
    }

    public static boolean isValidEmail(String email) {
        return isNotEmpty(email) && EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    public static boolean isValidPhone(String phone) {
        if (!isNotEmpty(phone)) return false;
        String cleanPhone = phone.replaceAll("[\\s\\-\\(\\)\\+]", "");
        if (cleanPhone.startsWith("91") && cleanPhone.length() == 12) {
            cleanPhone = cleanPhone.substring(2);
        }
        return PHONE_PATTERN.matcher(cleanPhone).matches();
    }

    public static boolean isValidPincode(String pincode) {
        return isNotEmpty(pincode) && PINCODE_PATTERN.matcher(pincode.trim()).matches();
    }

    public static boolean isValidUsername(String username) {
        return isNotEmpty(username) && USERNAME_PATTERN.matcher(username.trim()).matches();
    }

    public static boolean isValidPriority(String priority) {
        if (!isNotEmpty(priority)) return false;
        String p = priority.trim().toUpperCase();
        return p.equals("LOW") || p.equals("MEDIUM") || p.equals("HIGH") || p.equals("CRITICAL");
    }

    public static boolean isAllowedImageExtension(String filename) {
        if (!isNotEmpty(filename)) return false;
        String lower = filename.toLowerCase();
        return lower.endsWith(".jpg") || lower.endsWith(".jpeg") || lower.endsWith(".png");
    }

    public static String sanitize(String input) {
        if (input == null) return "";
        return input.trim()
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#x27;");
    }
}

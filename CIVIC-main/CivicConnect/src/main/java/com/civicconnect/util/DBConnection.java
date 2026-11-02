package com.civicconnect.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * DBConnection - Centralized Database Connection Manager.
 * Provides thread-safe, reusable JDBC connection instances.
 */
public class DBConnection {

    private static final Logger LOGGER = Logger.getLogger(DBConnection.class.getName());
    private static final Properties properties = new Properties();

    private static String driver = "com.mysql.cj.jdbc.Driver";
    private static String url = "jdbc:mysql://localhost:3306/civicconnect_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8";
    private static String username = "root";
    private static String password = "root";

    static {
        try (InputStream input = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (input != null) {
                properties.load(input);
                driver = properties.getProperty("db.driver", driver);
                url = properties.getProperty("db.url", url);
                username = properties.getProperty("db.username", username);
                password = properties.getProperty("db.password", password);
            }
            Class.forName(driver);
            LOGGER.info("MySQL JDBC Driver successfully loaded.");
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "MySQL JDBC Driver not found in classpath!", e);
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "db.properties not found or error loading, using default settings.", e);
            try {
                Class.forName(driver);
            } catch (ClassNotFoundException ex) {
                LOGGER.log(Level.SEVERE, "Default driver loading failed!", ex);
            }
        }
    }

    private DBConnection() {
        // Private constructor for utility class
    }

    /**
     * Obtains a new database connection.
     *
     * @return Connection object
     * @throws SQLException if a database access error occurs
     */
    public static Connection getConnection() throws SQLException {
        try {
            return DriverManager.getConnection(url, username, password);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database connection failure! Please verify MySQL service and civicconnect_db database.", e);
            throw e;
        }
    }

    /**
     * Safely closes AutoCloseable resources (Connection, Statement, ResultSet).
     */
    public static void close(AutoCloseable... resources) {
        for (AutoCloseable res : resources) {
            if (res != null) {
                try {
                    res.close();
                } catch (Exception e) {
                    LOGGER.log(Level.FINE, "Error closing database resource: " + e.getMessage());
                }
            }
        }
    }

    /**
     * Diagnostic method to test DB connectivity.
     */
    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            return conn != null && !conn.isClosed();
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "DB Connection test failed: " + e.getMessage());
            return false;
        }
    }
}

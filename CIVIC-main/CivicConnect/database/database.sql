-- ==========================================================
-- CivicConnect - Crowdsourced Civic Issue Reporting System
-- Database Schema & Initial Seed Data
-- Target Database: MySQL 8.x
-- ==========================================================

CREATE DATABASE IF NOT EXISTS civicconnect_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE civicconnect_db;

-- ----------------------------------------------------------
-- 1. Table: departments
-- ----------------------------------------------------------
DROP TABLE IF EXISTS feedback;
DROP TABLE IF EXISTS notifications;
DROP TABLE IF EXISTS complaint_status_history;
DROP TABLE IF EXISTS complaints;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS departments;

CREATE TABLE departments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ----------------------------------------------------------
-- 2. Table: users
-- ----------------------------------------------------------
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('CITIZEN', 'STAFF', 'ADMIN') NOT NULL DEFAULT 'CITIZEN',
    department_id INT NULL,
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_users_department FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ----------------------------------------------------------
-- 3. Table: categories
-- ----------------------------------------------------------
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    department_id INT NULL,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_categories_department FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ----------------------------------------------------------
-- 4. Table: complaints
-- ----------------------------------------------------------
CREATE TABLE complaints (
    id INT AUTO_INCREMENT PRIMARY KEY,
    complaint_code VARCHAR(30) NOT NULL UNIQUE,
    user_id INT NOT NULL,
    category_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(255) NOT NULL,
    landmark VARCHAR(150),
    city VARCHAR(100) NOT NULL DEFAULT 'Metro City',
    pincode VARCHAR(10) NOT NULL,
    image_path VARCHAR(255) NULL,
    resolution_image_path VARCHAR(255) NULL,
    priority ENUM('LOW', 'MEDIUM', 'HIGH', 'CRITICAL') DEFAULT 'MEDIUM',
    status ENUM('SUBMITTED', 'UNDER_REVIEW', 'ASSIGNED', 'IN_PROGRESS', 'RESOLVED', 'REJECTED') DEFAULT 'SUBMITTED',
    department_id INT NULL,
    assigned_staff_id INT NULL,
    admin_remarks TEXT NULL,
    staff_remarks TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP NULL,
    CONSTRAINT fk_complaints_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_complaints_category FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT,
    CONSTRAINT fk_complaints_department FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE SET NULL,
    CONSTRAINT fk_complaints_staff FOREIGN KEY (assigned_staff_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ----------------------------------------------------------
-- 5. Table: complaint_status_history
-- ----------------------------------------------------------
CREATE TABLE complaint_status_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    complaint_id INT NOT NULL,
    old_status VARCHAR(50) NULL,
    new_status VARCHAR(50) NOT NULL,
    changed_by INT NULL,
    remarks TEXT NULL,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_history_complaint FOREIGN KEY (complaint_id) REFERENCES complaints(id) ON DELETE CASCADE,
    CONSTRAINT fk_history_user FOREIGN KEY (changed_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ----------------------------------------------------------
-- 6. Table: feedback
-- ----------------------------------------------------------
CREATE TABLE feedback (
    id INT AUTO_INCREMENT PRIMARY KEY,
    complaint_id INT NOT NULL UNIQUE,
    user_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_feedback_complaint FOREIGN KEY (complaint_id) REFERENCES complaints(id) ON DELETE CASCADE,
    CONSTRAINT fk_feedback_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ----------------------------------------------------------
-- 7. Table: notifications
-- ----------------------------------------------------------
CREATE TABLE notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    complaint_id INT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_notifications_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_notifications_complaint FOREIGN KEY (complaint_id) REFERENCES complaints(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ----------------------------------------------------------
-- Indexes for High Performance Querying
-- ----------------------------------------------------------
CREATE INDEX idx_complaints_status ON complaints(status);
CREATE INDEX idx_complaints_user ON complaints(user_id);
CREATE INDEX idx_complaints_dept ON complaints(department_id);
CREATE INDEX idx_complaints_staff ON complaints(assigned_staff_id);
CREATE INDEX idx_complaints_created ON complaints(created_at);
CREATE INDEX idx_notifications_user_unread ON notifications(user_id, is_read);

-- ==========================================================
-- SEED DATA
-- Pre-hashed SHA-256 Passwords:
-- 'admin123'   -> 240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa82280f1a82e3eb0
-- 'staff123'   -> 85b3bc79998df12727a2aa440b82f05a967f6b9c9f0b1279ba8588820c749007
-- 'citizen123' -> 51296c05d762e8477ff2218fbccca6d09cb8b9c6a1cf8d1323f46f345c22501a
-- ==========================================================

-- 1. Departments
INSERT INTO departments (id, name, description, status) VALUES
(1, 'Roads & Infrastructure Department', 'Responsible for road repairs, potholes, sidewalks, and paving.', 'ACTIVE'),
(2, 'Sanitation & Solid Waste Management', 'Handles garbage collection, waste dumping, and street cleanliness.', 'ACTIVE'),
(3, 'Water Supply Department', 'Maintains drinking water pipelines, leakages, and water tankers.', 'ACTIVE'),
(4, 'Electrical & Street Lighting', 'Manages street lights, transformers, and public electrical fixtures.', 'ACTIVE'),
(5, 'Drainage & Sewage Management', 'Maintains underground sewage pipelines, storm drains, and open gutters.', 'ACTIVE'),
(6, 'Traffic & Public Works', 'Oversees traffic signals, signage, and public amenities.', 'ACTIVE');

-- 2. Categories
INSERT INTO categories (id, department_id, name, description, status) VALUES
(1, 1, 'Road Damage & Potholes', 'Craters, asphalt peeling, and dangerous road fissures.', 'ACTIVE'),
(2, 2, 'Garbage Accumulation & Waste', 'Overflowing community bins, uncollected waste, and littered public spots.', 'ACTIVE'),
(3, 4, 'Broken Street Light', 'Non-functioning street lamps, flickering lights, or broken posts.', 'ACTIVE'),
(4, 3, 'Water Leakage & Pipeline Burst', 'Pipeline rupture, water wastage, low pressure, or contaminated supply.', 'ACTIVE'),
(5, 5, 'Drainage Overflow & Clogged Gutter', 'Stagnant wastewater, clogged culverts, and sewer overflow.', 'ACTIVE'),
(6, 6, 'Traffic Signal Malfunction', 'Broken traffic lights, faulty countdown timers, or obscured signs.', 'ACTIVE'),
(7, 1, 'Public Property Damage', 'Vandalized bus shelters, broken park benches, or damaged railings.', 'ACTIVE'),
(8, 2, 'Illegal Dumping & Debris', 'Unauthorized dumping of construction debris or commercial hazardous waste.', 'ACTIVE'),
(9, 6, 'Other Civic Issues', 'General civic grievances not falling into specific categories.', 'ACTIVE');

-- 3. Users (Admin, Staff, Citizens)
INSERT INTO users (id, full_name, email, phone, username, password, role, department_id, status) VALUES
-- Administrator
(1, 'Chief Municipal Administrator', 'admin@civicconnect.gov', '9876543210', 'admin', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa82280f1a82e3eb0', 'ADMIN', NULL, 'ACTIVE'),

-- Staff Members
(2, 'Rajesh Kumar (Roads Lead)', 'rajesh.roads@civicconnect.gov', '9876500001', 'staff_roads', '85b3bc79998df12727a2aa440b82f05a967f6b9c9f0b1279ba8588820c749007', 'STAFF', 1, 'ACTIVE'),
(3, 'Anita Sharma (Sanitation Officer)', 'anita.sanitation@civicconnect.gov', '9876500002', 'staff_sanitation', '85b3bc79998df12727a2aa440b82f05a967f6b9c9f0b1279ba8588820c749007', 'STAFF', 2, 'ACTIVE'),
(4, 'Vikram Singh (Water Engineer)', 'vikram.water@civicconnect.gov', '9876500003', 'staff_water', '85b3bc79998df12727a2aa440b82f05a967f6b9c9f0b1279ba8588820c749007', 'STAFF', 3, 'ACTIVE'),
(5, 'Suresh Patel (Electrical Inspector)', 'suresh.electrical@civicconnect.gov', '9876500004', 'staff_electrical', '85b3bc79998df12727a2aa440b82f05a967f6b9c9f0b1279ba8588820c749007', 'STAFF', 4, 'ACTIVE'),

-- Citizens
(6, 'Rahul Verma', 'citizen@gmail.com', '9123456780', 'citizen', '51296c05d762e8477ff2218fbccca6d09cb8b9c6a1cf8d1323f46f345c22501a', 'CITIZEN', NULL, 'ACTIVE'),
(7, 'Priya Nair', 'priya.nair@gmail.com', '9123456781', 'priya_n', '51296c05d762e8477ff2218fbccca6d09cb8b9c6a1cf8d1323f46f345c22501a', 'CITIZEN', NULL, 'ACTIVE'),
(8, 'Amit Joshi', 'amit.j@gmail.com', '9123456782', 'amit_j', '51296c05d762e8477ff2218fbccca6d09cb8b9c6a1cf8d1323f46f345c22501a', 'CITIZEN', NULL, 'ACTIVE');

-- 4. Initial Sample Complaints
INSERT INTO complaints (id, complaint_code, user_id, category_id, title, description, location, landmark, city, pincode, image_path, resolution_image_path, priority, status, department_id, assigned_staff_id, admin_remarks, staff_remarks, created_at, updated_at, resolved_at) VALUES
(1, 'CIV-2026-00001', 6, 1, 'Deep Potholes causing severe traffic slowdown on MG Road', 'Multiple large potholes have formed right near the intersection. Two-wheelers are slipping during rain.', 'MG Road, Near Central Metro Station', 'Metro Pillar 142', 'Bengaluru', '560001', NULL, NULL, 'HIGH', 'IN_PROGRESS', 1, 2, 'Assigned to Roads Division for urgent hot-mix asphalt patching.', 'Repair team dispatched on site with roller and asphalt mix.', DATE_SUB(NOW(), INTERVAL 3 DAY), NOW(), NULL),

(2, 'CIV-2026-00002', 6, 2, 'Overflowing garbage bin not cleared for 4 days', 'The primary waste disposal container in 4th Cross is completely overflowing onto the road. Foul smell and stray dogs.', '4th Cross, Indiranagar', 'Opposite Nilgiris Supermarket', 'Bengaluru', '560038', NULL, NULL, 'MEDIUM', 'RESOLVED', 2, 3, 'Sanitation truck routed on morning shift.', 'Waste cleared thoroughly, area sanitized with disinfectant powder.', DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY)),

(3, 'CIV-2026-00003', 7, 3, 'Dark stretch due to 4 non-functional street lights', 'Four consecutive LED street poles are non-functional for past one week, causing safety concerns for pedestrians.', '12th Main, Koramangala 5th Block', 'Near Community Park Gate 2', 'Bengaluru', '560095', NULL, NULL, 'HIGH', 'ASSIGNED', 4, 5, 'Forwarded to Electrical division for LED driver replacement.', NULL, DATE_SUB(NOW(), INTERVAL 2 DAY), NOW(), NULL),

(4, 'CIV-2026-00004', 7, 4, 'Major potable water pipeline burst and flooding street', 'High pressure drinking water leaking continuously from underground valve. Huge loss of water.', '80 Feet Road, HAL 2nd Stage', 'Near BSNL Telephone Exchange', 'Bengaluru', '560008', NULL, NULL, 'CRITICAL', 'UNDER_REVIEW', 3, NULL, 'Initial verification underway by ward inspector.', NULL, DATE_SUB(NOW(), INTERVAL 1 DAY), NOW(), NULL),

(5, 'CIV-2026-00005', 8, 5, 'Open gutter overflowing into residential pathway', 'Stormwater drainage blocked with plastic silt causing filthy water backflow.', '7th Main, BTM Layout 2nd Stage', 'Behind Water Tank', 'Bengaluru', '560076', NULL, NULL, 'MEDIUM', 'SUBMITTED', NULL, NULL, NULL, NULL, NOW(), NOW(), NULL);

-- 5. Complaint Status History
INSERT INTO complaint_status_history (complaint_id, old_status, new_status, changed_by, remarks, changed_at) VALUES
-- Complaint 1 History
(1, NULL, 'SUBMITTED', 6, 'Complaint registered by citizen Rahul Verma.', DATE_SUB(NOW(), INTERVAL 3 DAY)),
(1, 'SUBMITTED', 'UNDER_REVIEW', 1, 'Admin reviewed and verified location authenticity.', DATE_SUB(NOW(), INTERVAL 2 DAY)),
(1, 'UNDER_REVIEW', 'ASSIGNED', 1, 'Assigned to Roads Department (Staff: Rajesh Kumar).', DATE_SUB(NOW(), INTERVAL 2 DAY)),
(1, 'ASSIGNED', 'IN_PROGRESS', 2, 'Work crew mobilized with asphalt mix.', DATE_SUB(NOW(), INTERVAL 1 DAY)),

-- Complaint 2 History
(2, NULL, 'SUBMITTED', 6, 'Complaint registered by citizen Rahul Verma.', DATE_SUB(NOW(), INTERVAL 5 DAY)),
(2, 'SUBMITTED', 'ASSIGNED', 1, 'Assigned directly to Sanitation Officer Anita Sharma.', DATE_SUB(NOW(), INTERVAL 4 DAY)),
(2, 'ASSIGNED', 'IN_PROGRESS', 3, 'Sanitation truck assigned toIndiranagar route.', DATE_SUB(NOW(), INTERVAL 3 DAY)),
(2, 'IN_PROGRESS', 'RESOLVED', 3, 'Waste cleared and sanitized.', DATE_SUB(NOW(), INTERVAL 1 DAY)),

-- Complaint 3 History
(3, NULL, 'SUBMITTED', 7, 'Complaint registered by citizen Priya Nair.', DATE_SUB(NOW(), INTERVAL 2 DAY)),
(3, 'SUBMITTED', 'ASSIGNED', 1, 'Assigned to Electrical Dept (Staff: Suresh Patel).', DATE_SUB(NOW(), INTERVAL 1 DAY)),

-- Complaint 4 History
(4, NULL, 'SUBMITTED', 7, 'Complaint registered by citizen Priya Nair.', DATE_SUB(NOW(), INTERVAL 1 DAY)),
(4, 'SUBMITTED', 'UNDER_REVIEW', 1, 'Prioritized as CRITICAL for water engineering team.', NOW()),

-- Complaint 5 History
(5, NULL, 'SUBMITTED', 8, 'Complaint registered by citizen Amit Joshi.', NOW());

-- 6. Feedback for Resolved Complaint #2
INSERT INTO feedback (complaint_id, user_id, rating, comment, created_at) VALUES
(2, 6, 5, 'Prompt action taken by the sanitation team! The area is completely clean now. Thank you CivicConnect.', DATE_SUB(NOW(), INTERVAL 1 DAY));

-- 7. Notifications
INSERT INTO notifications (user_id, complaint_id, message, is_read, created_at) VALUES
(6, 1, 'Your complaint CIV-2026-00001 status changed to IN_PROGRESS. Assigned staff: Rajesh Kumar.', 0, DATE_SUB(NOW(), INTERVAL 1 DAY)),
(6, 2, 'Your complaint CIV-2026-00002 has been successfully RESOLVED. Please provide your feedback.', 1, DATE_SUB(NOW(), INTERVAL 1 DAY)),
(7, 3, 'Your complaint CIV-2026-00003 has been assigned to Electrical & Street Lighting department.', 0, DATE_SUB(NOW(), INTERVAL 1 DAY)),
(7, 4, 'Your complaint CIV-2026-00004 is currently UNDER_REVIEW by administration.', 0, NOW()),
(8, 5, 'Your complaint CIV-2026-00005 has been received. Ticket ID: CIV-2026-00005.', 0, NOW());

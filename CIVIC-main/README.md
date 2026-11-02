# CivicConnect – Crowdsourced Civic Issue Reporting and Resolution System

A professional, enterprise-grade Java Web Application built for MCA College Project Evaluation using **Core Java, Java Servlets (javax.servlet for Tomcat 9), JSP, JSTL, JDBC, and MySQL**.

---

## 🏛️ Project Overview

**CivicConnect** is an integrated municipal grievance management portal that empowers citizens to report locality problems (such as road damage, overflowing garbage, broken street lights, pipeline bursts, and sewage overflow), track resolution progress through a 5-stage interactive visual timeline, and submit citizen satisfaction feedback.

### Key Highlights
- **Role-Based Portals**: Dedicated, secure workflows for **Citizens**, **Department Staff Officers**, and **Municipal Administrators**.
- **Dynamic State Machine Workflow**:
  $$\text{SUBMITTED} \longrightarrow \text{UNDER REVIEW} \longrightarrow \text{ASSIGNED} \longrightarrow \text{IN PROGRESS} \longrightarrow \text{RESOLVED / REJECTED}$$
- **Automated Complaint Code**: Unique reference code generator (e.g. `CIV-2026-00001`).
- **Real-Time Analytics & Charts**: Interactive Chart.js charts for category distribution, status breakdowns, and monthly inflow trends driven entirely by MySQL queries.
- **Photo Evidence & Verification**: Multipart file upload supporting before-and-after resolution proof photos.
- **Enterprise Security**: SHA-256 salted password hashing, SQL injection prevention using `PreparedStatement`, XSS sanitation, and session authentication filters.

---

## 🛠️ Technology Stack

| Layer | Technologies Used |
|---|---|
| **Programming Language** | Java 17 (JDK 17+) |
| **Backend & Controllers** | Java Servlets 4.0 (`javax.servlet` API compatible with Tomcat 9) |
| **View Layer** | JavaServer Pages (JSP), JSTL 1.2, Expression Language (EL) |
| **Database & Persistence**| MySQL 8.x, JDBC with centralized `DBConnection` pooling |
| **Frontend Framework** | HTML5, CSS3, JavaScript (ES6+), Bootstrap 5.3.2, Bootstrap Icons |
| **Data Visualizations** | Chart.js 4.4 |
| **Build & Packaging** | Apache Maven (`war` package) |
| **Application Server** | Apache Tomcat 9 |

---

## 🔑 Demo Login Credentials

For demonstration and viva evaluation, the system comes pre-seeded with sample users:

| Role | Username | Password | Notes |
|---|---|---|---|
| **Admin** | `admin` | `admin123` | Full access to complaints, users, staff, departments, and analytics |
| **Staff (Roads)** | `staff_roads` | `staff123` | Roads & Infrastructure department officer |
| **Staff (Sanitation)**| `staff_sanitation`| `staff123`| Sanitation & Solid Waste Management officer |
| **Citizen** | `citizen` | `citizen123` | Standard citizen account with sample active complaints |
| **Citizen** | `priya_n` | `citizen123` | Citizen account with assigned street light grievance |

---

## 📂 Project Architecture

```text
CivicConnect/
│
├── pom.xml                                   # Maven dependencies & build config
├── README.md                                 # Complete documentation & setup guide
├── database/
│   └── database.sql                          # MySQL schema, indices, and seed data
│
└── src/
    └── main/
        ├── java/
        │   └── com/civicconnect/
        │       ├── controller/               # MVC Controllers (Servlets)
        │       │   ├── LoginServlet.java
        │       │   ├── RegisterServlet.java
        │       │   ├── LogoutServlet.java
        │       │   ├── ComplaintServlet.java
        │       │   ├── TrackComplaintServlet.java
        │       │   ├── StaffServlet.java
        │       │   ├── AdminServlet.java
        │       │   ├── FeedbackServlet.java
        │       │   ├── NotificationServlet.java
        │       │   ├── ProfileServlet.java
        │       │   └── ImageServlet.java
        │       │
        │       ├── model/                    # Domain POJOs / Data Transfer Objects
        │       │   ├── User.java
        │       │   ├── Department.java
        │       │   ├── Category.java
        │       │   ├── Complaint.java
        │       │   ├── StatusHistory.java
        │       │   ├── Feedback.java
        │       │   ├── Notification.java
        │       │   └── DashboardStats.java
        │       │
        │       ├── dao/                      # Data Access Object Layer (Pure JDBC)
        │       │   ├── UserDAO.java
        │       │   ├── DepartmentDAO.java
        │       │   ├── CategoryDAO.java
        │       │   ├── ComplaintDAO.java
        │       │   ├── StatusHistoryDAO.java
        │       │   ├── FeedbackDAO.java
        │       │   └── NotificationDAO.java
        │       │
        │       ├── service/                  # Business & Validation Service Layer
        │       │   ├── UserService.java
        │       │   ├── ComplaintService.java
        │       │   ├── DepartmentService.java
        │       │   └── FeedbackService.java
        │       │
        │       ├── filter/                   # Security & RBAC Guard
        │       │   └── AuthenticationFilter.java
        │       │
        │       └── util/                     # Centralized DB & Cryptographic Helpers
        │           ├── DBConnection.java
        │           ├── PasswordUtil.java
        │           └── ValidationUtil.java
        │
        ├── resources/
        │   └── db.properties                 # MySQL Connection Settings
        │
        └── webapp/
            ├── WEB-INF/
            │   ├── web.xml                   # Deployment Descriptor
            │   └── includes/                 # Reusable Modular JSP Partials
            │       ├── header.jsp
            │       ├── footer.jsp
            │       ├── navbar.jsp
            │       ├── sidebar-citizen.jsp
            │       ├── sidebar-staff.jsp
            │       ├── sidebar-admin.jsp
            │       └── alerts.jsp
            │
            ├── index.jsp                     # Public Portal Landing Page
            ├── login.jsp                     # Role Login with 1-Click Demo Fill
            ├── register.jsp                  # Citizen Registration Form
            ├── track-complaint.jsp           # Universal Complaint Status Tracker
            │
            ├── citizen/                      # Citizen Sub-Portal
            │   ├── dashboard.jsp
            │   ├── report-issue.jsp
            │   ├── my-complaints.jsp
            │   ├── complaint-details.jsp
            │   ├── notifications.jsp
            │   └── profile.jsp
            │
            ├── staff/                        # Staff Officer Sub-Portal
            │   ├── dashboard.jsp
            │   ├── assigned-complaints.jsp
            │   ├── complaint-details.jsp
            │   └── profile.jsp
            │
            ├── admin/                        # Administration Sub-Portal
            │   ├── dashboard.jsp
            │   ├── manage-complaints.jsp
            │   ├── complaint-details.jsp
            │   ├── manage-users.jsp
            │   ├── manage-staff.jsp
            │   ├── manage-departments.jsp
            │   ├── manage-categories.jsp
            │   └── reports.jsp
            │
            ├── css/
            │   └── style.css                 # GovTech Design System Stylesheet
            ├── js/
            │   ├── script.js                 # Image preview, auto-dismiss, table search
            │   └── charts.js                 # Chart.js dynamically mapped graphs
            └── uploads/                      # Uploaded complaint & proof photos
```

---

## 🚀 Setup & Execution Guide

### Step 1: MySQL Database Configuration
1. Start your **MySQL Server** (via MySQL Workbench, XAMPP, or command line).
2. Open your MySQL client and execute the SQL script located at:
   ```text
   database/database.sql
   ```
3. This creates the database `civicconnect_db`, sets up all 7 relational tables with foreign keys and indexes, and inserts sample seed data.
4. If your MySQL root password is not blank, update `src/main/resources/db.properties`:
   ```properties
   db.driver=com.mysql.cj.jdbc.Driver
   db.url=jdbc:mysql://localhost:3306/civicconnect_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8
   db.username=root
   db.password=your_mysql_password
   ```

---

### Step 2: Running in Eclipse IDE
1. Open **Eclipse IDE for Enterprise Java and Web Developers**.
2. Go to **File -> Import... -> Maven -> Existing Maven Projects**.
3. Browse and select the `CivicConnect` folder and click **Finish**.
4. Right-click the project -> **Properties -> Targeted Runtimes** -> Ensure **Apache Tomcat v9.0** is checked.
5. Right-click project -> **Run As -> Run on Server** -> Select **Apache Tomcat v9.0** -> **Finish**.
6. Open your browser and navigate to:
   ```text
   http://localhost:8080/CivicConnect/
   ```

---

### Step 3: Running in VS Code / Command Line with Maven
1. Open terminal inside the `CivicConnect` directory:
   ```bash
   mvn clean package
   ```
2. Copy the generated `target/CivicConnect.war` into your Tomcat `webapps/` folder:
   ```bash
   cp target/CivicConnect.war /path/to/apache-tomcat-9.0.x/webapps/
   ```
3. Start Apache Tomcat:
   - On Windows: `bin/startup.bat`
   - On Linux/Mac: `bin/startup.sh`
4. Access the web application at `http://localhost:8080/CivicConnect/`.

---

## 🧪 Comprehensive Evaluation Workflow

### 1. Citizen Workflow
1. Click **Citizen Register** or login as `citizen` / `citizen123`.
2. Click **+ Report New Issue**.
3. Fill in title, select category (e.g. *Road Damage*), location, landmark, PIN code, select priority (*HIGH*), and attach a photo.
4. Click **Submit Complaint**. A unique ID (e.g. `CIV-2026-00006`) is generated immediately.
5. View the complaint in **My Complaints** and open **Details** to see the real-time 5-stage progress stepper.

### 2. Administrator Workflow
1. Sign in as `admin` / `admin123`.
2. Inspect the **Admin Dashboard** with real-time KPI metrics and dynamic Chart.js charts (Category breakdown, Status distribution, Monthly trends).
3. Go to **Manage Complaints** -> Filter by status or search.
4. Open the new complaint -> Change status to `UNDER_REVIEW` -> Assign department (e.g. *Roads & Infrastructure*) and assign officer `staff_roads`.

### 3. Staff Officer Workflow
1. Sign in as `staff_roads` / `staff123`.
2. View assigned grievance on the **Staff Dashboard**.
3. Open the complaint -> Change status to `IN_PROGRESS` and enter remarks (*"Work crew dispatched with asphalt mixer"*).
4. Update to `RESOLVED`, upload a resolution proof photo, and click **Save Status Update**.

### 4. Resolution & Citizen Feedback
1. Sign back in as `citizen` / `citizen123`.
2. Click the **Notification** bell to see *"Your complaint CIV-2026-00006 has been RESOLVED"*.
3. Open the complaint details -> Review the before-and-after photo comparison.
4. Submit a **5-Star Rating** and comment in the citizen feedback form.
5. Admin can now view this feedback in **Reports & Analytics**.

---

## 📜 Project Evaluation Checklist

- [x] Pure Java MVC Architecture (No Spring Boot / Node / Python).
- [x] Complete MySQL Schema with Relational Foreign Keys & Audit Log.
- [x] Secure Centralized JDBC DAO Pattern with PreparedStatements.
- [x] SHA-256 Salted Password Encryption & Authentication Filter.
- [x] Multipart File Uploads for Before & After Resolution Images.
- [x] Dynamic Visual Stepper Progress Bar & Timeline Audit.
- [x] Role-Based Access Control (Citizen, Staff, Admin).
- [x] Live Chart.js Visualizations Driven by Database Queries.
- [x] 100% Complete Source Code without Placeholders.

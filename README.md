# CityCare - Smart City Civic Complaint Management System

**CityCare** is a web-based Smart City Complaint Management System designed to streamline reporting, routing, and tracking of civic grievances such as potholes, overflowing garbage bins, damaged streetlights, and water leakages.

Built with **Java Servlets**, **JSP**, **JDBC**, **MySQL**, and **Apache Tomcat 9**, with a responsive civic-tech interface built with **HTML5**, **CSS3**, and **JavaScript** using crisp SVG vector icons (no emojis).

---

## Technologies Used

- **Backend**: Java Servlets, JSP (JavaServer Pages), JDBC
- **Database**: MySQL 8.0
- **Web Application Server**: Apache Tomcat 9.0
- **Frontend**: HTML5, CSS3, JavaScript (Vanilla ES6, responsive, SVG icons)

---

## Key Features

1. **Public Portal Gateway**: Clean, modern landing page with municipal divisions, 24-48h SLA commitments, workflow overview, and emergency helplines.
2. **Citizen Portal** (Protected):
   - Lodge new grievances with location coordinates and priority.
   - Live 4-stage visual milestone stepper (`Submitted` ➔ `Under Review` ➔ `In Progress` ➔ `Resolved`).
   - Track complaints by tracking code (`BMCC-YYYY-SEC-XXXX`).
   - Resident feedback & satisfaction rating upon resolution.
3. **Municipal Officer Workspace** (Protected):
   - Department-specific complaint queues (Roads, Waste, Electrical, Water, Parks, Drains).
   - Update complaint status, assign field contractors, log repair materials used.
   - Re-route misassigned tickets to other departments.
4. **Administrator Command Console** (Protected):
   - Citywide KPI analytics (Total complaints, active dispatches, resolution percentage).
   - Category and zonal grievance distribution breakdowns.
   - Manage complaints, officers, and audit logs.

---

## Default User Accounts (MySQL Database)

| Role | Username | Password | Post-Login Workspace |
| :--- | :--- | :--- | :--- |
| **City Administrator** | `admin` | `admin123` | Executive Command Console & Analytics |
| **Roads Officer** | `officer_roads` | `officer123` | Roads & Pothole Workstation |
| **Sanitation Officer** | `officer_waste` | `officer123` | Waste & Bin Clearance Workstation |
| **Water Officer** | `officer_water` | `officer123` | Water Pipeline & Leakage Workstation |
| **Electrical Officer** | `officer_electrical` | `officer123` | Streetlights & Power Workstation |
| **Resident Citizen** | `citizen` | `citizen123` | Citizen Grievance Console & History |

---

## Project Setup & Deployment

1. **Database Setup**:
   - Create database and load tables: `mysql -u root -p < sql/schema.sql`
   - Or run `setup_database.bat`
2. **Build and Deploy**:
   - Run `build_and_deploy.bat` to compile Java sources and copy web assets to Tomcat `webapps/CityCare`.
3. **Start Server**:
   - Run `start_server.bat`
   - Open: `http://localhost:8080/CityCare/`

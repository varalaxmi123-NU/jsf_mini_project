-- ====================================================================
-- CityCare: Metropolitan Smart City Municipal Complaint Management System
-- Municipal Corporation Civic Redressal & Engineering Maintenance DB
-- ====================================================================

CREATE DATABASE IF NOT EXISTS citycare_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE citycare_db;

DROP TABLE IF EXISTS complaint_logs;
DROP TABLE IF EXISTS complaints;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS departments;

-- 1. Municipal Engineering & Services Departments
CREATE TABLE departments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    code VARCHAR(25) NOT NULL UNIQUE,
    contact_email VARCHAR(100),
    contact_phone VARCHAR(25),
    head_officer VARCHAR(100),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO departments (name, code, contact_email, contact_phone, head_officer, description) VALUES
('Roads Infrastructure & Bridges Division', 'ROADS', 'roads.pwd@citycare.gov.in', '+91 80 2297 5001', 'Er. K. S. Venkatesh, FIE (Chief Engineer)', 'Asphalt road surfacing, pothole patching, pedestrian footpath maintenance, bridges, and flyover civil repairs.'),
('Solid Waste Management & Sanitation Board', 'SANITATION', 'swm.sanitation@citycare.gov.in', '+91 80 2297 5002', 'Dr. Radhika Sen, MPH (Joint Commissioner SWM)', 'Primary door-to-door collection, secondary compactor transport, community bin clearing, and illegal dump clearance.'),
('Electrical Distribution & Street Lighting Dept', 'ELECTRICAL', 'streetlights@citycare.gov.in', '+91 80 2297 5003', 'Er. Anand Kulkarni, M.Tech (Superintending Engineer)', 'LED street fixture replacement, sodium vapour servicing, feeder pillar repairs, traffic signaling, and cable insulation.'),
('Water Supply & Underground Drainage Board', 'WATER', 'water.drainage@citycare.gov.in', '+91 80 2297 5004', 'Er. Suresh Deshmukh, BE (Executive Engineer)', 'Potable drinking water transmission mains, ruptured pipe repair, sewage pumping stations, and manhole desilting.'),
('Urban Forestry, Parks & Horticulture Dept', 'PARKS', 'horticulture@citycare.gov.in', '+91 80 2297 5005', 'Nalini Sundaram, IFS (Deputy Conservator)', 'Hazardous branch lopping, fallen tree clearing, municipal garden maintenance, and civic open green space care.'),
('Stormwater Drains & Flood Management Cell', 'DRAINAGE', 'swd.flood@citycare.gov.in', '+91 80 2297 5006', 'Er. Rajesh Sharma, M.Tech (Director SWD)', 'Primary and secondary stormwater drains, culvert declogging, monsoon inundation control, and retaining wall repair.');

-- 2. User Accounts (Citizens, Municipal Engineers, City Commissioner)
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    full_name VARCHAR(120) NOT NULL,
    role VARCHAR(20) NOT NULL, -- ADMIN, OFFICER, CITIZEN
    department_id INT NULL,
    designation VARCHAR(100) NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    address VARCHAR(255) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE SET NULL
);

INSERT INTO users (username, password, full_name, role, department_id, designation, email, phone, address) VALUES
('admin', 'admin123', 'Sanjay Singhania, IAS', 'ADMIN', NULL, 'Additional Municipal Commissioner (Grievance Cell)', 'commissioner.grievance@citycare.gov.in', '+91 80 2297 5000', 'Municipal Corporation Central HQ, Annex Wing'),
('officer_roads', 'officer123', 'Er. K. S. Venkatesh', 'OFFICER', 1, 'Executive Engineer (Roads Division - Central)', 'venkatesh.roads@citycare.gov.in', '+91 98450 11001', 'Zonal Civil Works Depot, Shanthinagar'),
('officer_sanitation', 'officer123', 'Dr. Radhika Sen', 'OFFICER', 2, 'Superintendent of Solid Waste Management', 'radhika.sen@citycare.gov.in', '+91 98450 11002', 'Central Waste Processing Terminal, Goraguntepalya'),
('officer_electrical', 'officer123', 'Er. Anand Kulkarni', 'OFFICER', 3, 'Assistant Executive Engineer (Public Illumination)', 'anand.kulkarni@citycare.gov.in', '+91 98450 11003', 'Electrical Sub-Station Yard, Indiranagar'),
('officer_water', 'officer123', 'Er. Suresh Deshmukh', 'OFFICER', 4, 'Executive Engineer (Water Distribution Network)', 'suresh.deshmukh@citycare.gov.in', '+91 98450 11004', 'Water Pumping & Metering Station, High Grounds'),
('officer_parks', 'officer123', 'Nalini Sundaram, IFS', 'OFFICER', 5, 'Assistant Conservator of Forests (Urban Ecology)', 'nalini.sundaram@citycare.gov.in', '+91 98450 11005', 'Horticultural Directorate, Cubbon Park Enclosure'),
('citizen', 'citizen123', 'Aarav Mehta', 'CITIZEN', NULL, 'Resident Citizen', 'aarav.mehta@gmail.com', '9820011223', 'Flat 402, Shanthi Heights, 8th Main, Malleshwaram'),
('citizen_pooja', 'citizen123', 'Pooja Hegde', 'CITIZEN', NULL, 'Resident Citizen', 'pooja.hegde@outlook.com', '9845566778', 'Villa 14, Palm Meadows, Whitefield Tech Zone');

-- 3. Civic Complaints Registry
CREATE TABLE complaints (
    id INT AUTO_INCREMENT PRIMARY KEY,
    complaint_code VARCHAR(40) NOT NULL UNIQUE,
    category VARCHAR(100) NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(255) NOT NULL,
    ward_zone VARCHAR(100) NOT NULL,
    latitude VARCHAR(30) NULL,
    longitude VARCHAR(30) NULL,
    citizen_name VARCHAR(100) NOT NULL,
    citizen_phone VARCHAR(20) NOT NULL,
    citizen_email VARCHAR(100),
    priority VARCHAR(20) DEFAULT 'MEDIUM',
    status VARCHAR(30) DEFAULT 'PENDING',
    department_id INT NULL,
    assigned_officer_id INT NULL,
    contractor_assigned VARCHAR(120) NULL,
    materials_used TEXT NULL,
    remarks TEXT,
    resolution_notes TEXT,
    citizen_rating INT DEFAULT 0,
    citizen_feedback TEXT,
    sla_hours INT DEFAULT 48,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP NULL,
    FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE SET NULL,
    FOREIGN KEY (assigned_officer_id) REFERENCES users(id) ON DELETE SET NULL
);

-- 4. Audit Trail & Timeline
CREATE TABLE complaint_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    complaint_id INT NOT NULL,
    action VARCHAR(120) NOT NULL,
    status_from VARCHAR(30),
    status_to VARCHAR(30),
    remarks TEXT,
    performed_by VARCHAR(120),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (complaint_id) REFERENCES complaints(id) ON DELETE CASCADE
);

-- 5. Real-World Seed Complaints
INSERT INTO complaints 
(complaint_code, category, title, description, location, ward_zone, latitude, longitude, citizen_name, citizen_phone, citizen_email, priority, status, department_id, assigned_officer_id, contractor_assigned, materials_used, remarks, resolution_notes, citizen_rating, citizen_feedback, sla_hours, created_at, resolved_at) 
VALUES
('BMCC-2026-RD-0482', 'Potholes & Roads', 'Dangerous asphalt cave-in and potholes on arterial carriageway', 'Multiple deep craters spanning 1.8 meters width and 15cm depth causing vehicular damage and two-wheeler skidding near metro junction.', 'Opposite Metro Pillar 142, Outer Ring Road, near Central Junction', 'Zone 4 - Whitefield & Mahadevapura', '12.9716', '77.5946', 'Aarav Mehta', '9820011223', 'aarav.mehta@gmail.com', 'HIGH', 'RESOLVED', 1, 2, 'Kaveri Infrastructure Engineering Works', 'Dense Bituminous Macadam (DBM) with VG-30 Bitumen grade, compacted using 8-ton vibratory roller', 'Work dispatched on priority under Monsoon Rapid Repair Scheme.', 'Milling of damaged road section completed. Dense bitumen hot mix laid, rolled, and sealed with tack coat. Traffic lane reopened successfully.', 5, 'Very impressed! Repair crew arrived within 24 hours and laid high quality asphalt patch.', 48, DATE_SUB(NOW(), INTERVAL 3 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY)),

('BMCC-2026-SW-0519', 'Overflowing Garbage', 'Community dry & wet waste bins overflowing for 4 days', 'Large waste spill spilling onto pedestrian pathway and stormwater drain. Emitting foul odor and attracting stray cattle near school zone.', 'Gate 2, Sri Krishna Public School Road, 5th Cross, Indiranagar', 'Zone 3 - Indiranagar & Domlur', '12.9784', '77.6408', 'Pooja Hegde', '9845566778', 'pooja.hegde@outlook.com', 'MEDIUM', 'IN_PROGRESS', 2, 3, 'City Hygiene & Cleantech Services Ltd', 'Twin 14m3 hydraulic compactor vehicle (KA-01-EA-4912)', 'Compactor vehicle scheduled on morning secondary route.', NULL, 0, NULL, 48, DATE_SUB(NOW(), INTERVAL 2 DAY), NULL),

('BMCC-2026-EL-0631', 'Damaged Streetlights', 'Cluster of four 90W LED streetlights unlit on main bus route', 'Total darkness spanning 300 meters along 12th Main connecting residential layout to hospital. Poses pedestrian safety hazard after 7:30 PM.', '12th Main Road, Between Cross 4 and Cross 7, Jayanagar 4th Block', 'Zone 5 - Jayanagar & JP Nagar', '12.9308', '77.5838', 'Karthik Rao', '9731122445', 'karthik.rao@bhel.in', 'HIGH', 'UNDER_REVIEW', 3, 4, 'Southern Power Maintenance Consortium', 'Replacement 90W Philips GreenLine LED luminaires and 4kA surge protection devices', 'Technician roster assigned. Night inspection completed on 17 Nov.', NULL, 0, NULL, 48, DATE_SUB(NOW(), INTERVAL 1 DAY), NULL),

('BMCC-2026-WT-0744', 'Water Leakage', 'Ruptured 200mm DI treated drinking water transmission pipe', 'Clean potable water gushing onto road at high pressure since 6:00 AM. Significant water wastage and flooding of basement parking of adjoining complex.', 'In front of Canara Bank Building, 8th Cross, Malleshwaram West', 'Zone 6 - Malleshwaram & Rajajinagar', '13.0031', '77.5643', 'Suma Ramesh', '9448833221', 'suma.ramesh@isro.gov.in', 'URGENT', 'PENDING', 4, 5, 'Metropolitan Water Utilities Taskforce', '200mm Ductile Iron pipe sleeve collar and EPDM rubber gasket sealing kit', 'Emergency transmission valve throttled to prevent further inundation. Repair gang mobilizing with trench shoring equipment.', NULL, 0, NULL, 24, DATE_SUB(NOW(), INTERVAL 4 HOUR), NULL),

('BMCC-2026-PK-0812', 'Fallen Tree / Parks', 'Heavy gulmohar tree limb snapped and resting across electrical wires', 'Fallen branch obstructing single lane traffic and pulling down municipal fiber optics line after evening thunderstorm.', 'Near Corporation Bank, 15th Cross, HSR Sector 2', 'Zone 2 - Koramangala & HSR Layout', '12.9121', '77.6446', 'Dr. Chetan Joshi', '9880022334', 'chetan.joshi@aiims.edu', 'HIGH', 'IN_PROGRESS', 5, 6, 'Urban Forestry Quick Response Team (QRT)', 'Stihl MS-382 petrol chainsaws, hydraulic cherry-picker crane, 5-ton haulage tipper', 'Forestry crew deployed with electrical department safety clearance.', NULL, 0, NULL, 24, DATE_SUB(NOW(), INTERVAL 8 HOUR), NULL);

-- Seed Real Audit Trail Logs
INSERT INTO complaint_logs (complaint_id, action, status_from, status_to, remarks, performed_by, created_at) VALUES
(1, 'Complaint Registered', NULL, 'PENDING', 'Grievance lodged via CityCare Portal with verified citizen mobile authentication.', 'Aarav Mehta', DATE_SUB(NOW(), INTERVAL 3 DAY)),
(1, 'Triage & Department Assignment', 'PENDING', 'UNDER_REVIEW', 'Assigned to Roads Infrastructure & Bridges Division (Central Zone).', 'Sanjay Singhania, IAS (Additional Commissioner)', DATE_SUB(NOW(), INTERVAL 3 DAY)),
(1, 'Field Inspection Completed', 'UNDER_REVIEW', 'IN_PROGRESS', 'Site inspected by Assistant Engineer. Work order issued to Kaveri Infrastructure Engineering Works.', 'Er. K. S. Venkatesh (Executive Engineer)', DATE_SUB(NOW(), INTERVAL 2 DAY)),
(1, 'Repair Certified & Resolved', 'IN_PROGRESS', 'RESOLVED', 'Dense Bituminous Macadam asphalt laid and compacted. Surface level verified flush with road profile.', 'Er. K. S. Venkatesh (Executive Engineer)', DATE_SUB(NOW(), INTERVAL 1 DAY)),

(2, 'Complaint Registered', NULL, 'PENDING', 'Grievance lodged via CityCare Portal.', 'Pooja Hegde', DATE_SUB(NOW(), INTERVAL 2 DAY)),
(2, 'Routed to Sanitation Cell', 'PENDING', 'UNDER_REVIEW', 'Assigned to Solid Waste Management Division for Indiranagar Ward.', 'Sanjay Singhania, IAS (Additional Commissioner)', DATE_SUB(NOW(), INTERVAL 2 DAY)),
(2, 'Compactor Unit Dispatched', 'UNDER_REVIEW', 'IN_PROGRESS', 'Hydraulic compactor vehicle KA-01-EA-4912 mobilized for mechanical lifting and sanitization.', 'Dr. Radhika Sen (Superintendent SWM)', DATE_SUB(NOW(), INTERVAL 1 DAY)),

(3, 'Complaint Registered', NULL, 'PENDING', 'Citizen lodged report regarding unlit LED streetlights.', 'Karthik Rao', DATE_SUB(NOW(), INTERVAL 1 DAY)),
(3, 'Technical Triage', 'PENDING', 'UNDER_REVIEW', 'Assigned to Public Illumination division. Feeder box circuit testing scheduled.', 'Er. Anand Kulkarni (AEE Electrical)', DATE_SUB(NOW(), INTERVAL 14 HOUR)),

(4, 'Emergency Registration', NULL, 'PENDING', 'Urgent potable water line rupture recorded. System flagged for 24-hour critical SLA.', 'Suma Ramesh', DATE_SUB(NOW(), INTERVAL 4 HOUR)),

(5, 'Complaint Registered', NULL, 'PENDING', 'Obstruction hazard reported with electrical wire contact.', 'Dr. Chetan Joshi', DATE_SUB(NOW(), INTERVAL 8 HOUR)),
(5, 'Forestry QRT Mobilized', 'PENDING', 'IN_PROGRESS', 'Hydraulic crane and chainsaw crew arrived on site. Power line deactivated for tree cutting.', 'Nalini Sundaram, IFS (ACF)', DATE_SUB(NOW(), INTERVAL 4 HOUR));

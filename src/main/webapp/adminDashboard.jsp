<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.citycare.model.User" %>
<%@ page import="com.citycare.model.Complaint" %>
<%@ page import="com.citycare.model.Department" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    User admin = (User) session.getAttribute("currentUser");
    if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    List<Complaint> complaints = (List<Complaint>) request.getAttribute("complaints");
    List<Department> departments = (List<Department>) request.getAttribute("departments");
    List<User> officers = (List<User>) request.getAttribute("officers");
    Map<String, Integer> stats = (Map<String, Integer>) request.getAttribute("stats");
    Map<String, Integer> categoryDist = (Map<String, Integer>) request.getAttribute("categoryDist");
    Map<String, Integer> wardDist = (Map<String, Integer>) request.getAttribute("wardDist");
    int resolutionRate = (Integer) request.getAttribute("resolutionRate");

    String selectedKeyword = (String) request.getAttribute("selectedKeyword");
    String selectedCategory = (String) request.getAttribute("selectedCategory");
    String selectedStatus = (String) request.getAttribute("selectedStatus");
    String selectedWard = (String) request.getAttribute("selectedWard");
    String selectedDeptId = (String) request.getAttribute("selectedDeptId");

    String success = request.getParameter("success");
    String error = request.getParameter("error");

    int total = stats != null ? stats.getOrDefault("TOTAL", 0) : 0;
    int pending = stats != null ? stats.getOrDefault("PENDING", 0) : 0;
    int underReview = stats != null ? stats.getOrDefault("UNDER_REVIEW", 0) : 0;
    int inProgress = stats != null ? stats.getOrDefault("IN_PROGRESS", 0) : 0;
    int resolved = stats != null ? stats.getOrDefault("RESOLVED", 0) : 0;
    int rejected = stats != null ? stats.getOrDefault("REJECTED", 0) : 0;
%>
<jsp:include page="/includes/header.jsp" />

<div class="container-fluid" style="padding-top: 2rem; padding-bottom: 4rem;">

    <!-- Admin Header -->
    <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem; margin-bottom: 2rem;">
        <div>
            <div style="display: flex; align-items: center; gap: 10px;">
                <h1 style="font-size: 1.85rem; font-weight: 800; color: #0f172a;">Metropolitan Municipal Executive Console</h1>
                <span class="user-role-badge role-admin">Municipal Commissioner</span>
            </div>
            <p style="color: #64748b; font-size: 0.925rem; margin-top: 2px;">
                Logged in: <strong><%= admin.getFullName() %></strong> &bull; Citywide civic oversight, departmental workload monitoring, triage routing, and SLA compliance.
            </p>
        </div>
        <div style="display: flex; gap: 10px;">
            <a href="<%= request.getContextPath() %>/admin/export-csv" class="btn btn-secondary btn-sm">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="7 10 12 15 17 10"></polyline><line x1="12" y1="15" x2="12" y2="3"></line></svg>
                Export CSV Data
            </a>
            <button onclick="window.print()" class="btn btn-secondary btn-sm">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"><polyline points="6 9 6 2 18 2 18 9"></polyline><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"></path><rect x="6" y="14" width="12" height="8"></rect></svg>
                Print Report
            </button>
            <a href="<%= request.getContextPath() %>/admin/dashboard" class="btn btn-primary btn-sm">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"><polyline points="23 4 23 10 17 10"></polyline><path d="M20.49 15a9 9 0 1 1-2.12-9.36L23 10"></path></svg>
                Refresh
            </a>
        </div>
    </div>

    <!-- Alert Notifications -->
    <% if ("Assigned".equalsIgnoreCase(success)) { %>
        <div class="alert alert-success">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
            Complaint successfully assigned to department and responsible engineer!
        </div>
    <% } else if ("Deleted".equalsIgnoreCase(success)) { %>
        <div class="alert alert-info">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg>
            Grievance case removed from municipal registry.
        </div>
    <% } else if ("StatusUpdated".equalsIgnoreCase(success)) { %>
        <div class="alert alert-success">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
            Status updated successfully.
        </div>
    <% } %>

    <!-- Executive KPI Grid -->
    <div class="stats-grid" style="grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));">
        <div class="stat-card">
            <div class="stat-icon" style="background: #eff6ff; color: #1d4ed8;">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M3 21h18"></path><path d="M5 21V7l8-4v18"></path><path d="M19 21V11l-6-3"></path></svg>
            </div>
            <div class="stat-info">
                <div class="stat-value"><%= total %></div>
                <div class="stat-label">Total City Grievances</div>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon" style="background: #fffbeb; color: #d97706;">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
            </div>
            <div class="stat-info">
                <div class="stat-value"><%= pending %></div>
                <div class="stat-label">Unassigned / Pending</div>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon" style="background: #f5f3ff; color: #7c3aed;">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
            </div>
            <div class="stat-info">
                <div class="stat-value"><%= underReview %></div>
                <div class="stat-label">Under Investigation</div>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon" style="background: #ecfeff; color: #0284c7;">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z"></path></svg>
            </div>
            <div class="stat-info">
                <div class="stat-value"><%= inProgress %></div>
                <div class="stat-label">Action In Progress</div>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon" style="background: #ecfdf5; color: #059669;">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
            </div>
            <div class="stat-info">
                <div class="stat-value"><%= resolved %></div>
                <div class="stat-label">Resolved (<%= resolutionRate %>%)</div>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon" style="background: #fef2f2; color: #dc2626;">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor"><circle cx="12" cy="12" r="10"></circle><line x1="4.93" y1="4.93" x2="19.07" y2="19.07"></line></svg>
            </div>
            <div class="stat-info">
                <div class="stat-value"><%= rejected %></div>
                <div class="stat-label">Rejected / Invalid</div>
            </div>
        </div>
    </div>

    <!-- Analytics Breakdown: Category & Ward Distribution -->
    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(350px, 1fr)); gap: 1.5rem; margin-bottom: 2rem;">
        
        <!-- Category Breakdown -->
        <div class="card">
            <div class="card-header">
                <div class="card-title">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M21.21 15.89A10 10 0 1 1 8 2.83"></path><path d="M22 12A10 10 0 0 0 12 2v10z"></path></svg>
                    Grievances by Municipal Sector
                </div>
            </div>
            <div>
                <% if (categoryDist != null && !categoryDist.isEmpty()) {
                    for (Map.Entry<String, Integer> entry : categoryDist.entrySet()) {
                        int count = entry.getValue();
                        int pct = total > 0 ? (count * 100) / total : 0;
                %>
                    <div style="margin-bottom: 12px;">
                        <div style="display: flex; justify-content: space-between; font-size: 0.85rem; font-weight: 600; margin-bottom: 4px;">
                            <span><%= entry.getKey() %></span>
                            <span style="color: #64748b;"><%= count %> issues (<%= pct %>%)</span>
                        </div>
                        <div style="height: 8px; background: #f1f5f9; border-radius: 4px; overflow: hidden;">
                            <div style="height: 100%; width: <%= pct %>%; background: #1d4ed8; border-radius: 4px;"></div>
                        </div>
                    </div>
                <%  }
                   } else { %>
                    <p style="color: #64748b;">No category distribution data.</p>
                <% } %>
            </div>
        </div>

        <!-- Ward / Zone Breakdown -->
        <div class="card">
            <div class="card-header">
                <div class="card-title">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"><circle cx="12" cy="12" r="10"></circle><line x1="2" y1="12" x2="22" y2="12"></line><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"></path></svg>
                    Grievances by Municipal Zone
                </div>
            </div>
            <div>
                <% if (wardDist != null && !wardDist.isEmpty()) {
                    for (Map.Entry<String, Integer> entry : wardDist.entrySet()) {
                        int count = entry.getValue();
                        int pct = total > 0 ? (count * 100) / total : 0;
                %>
                    <div style="margin-bottom: 12px;">
                        <div style="display: flex; justify-content: space-between; font-size: 0.85rem; font-weight: 600; margin-bottom: 4px;">
                            <span><%= entry.getKey() %></span>
                            <span style="color: #64748b;"><%= count %> issues (<%= pct %>%)</span>
                        </div>
                        <div style="height: 8px; background: #f1f5f9; border-radius: 4px; overflow: hidden;">
                            <div style="height: 100%; width: <%= pct %>%; background: #059669; border-radius: 4px;"></div>
                        </div>
                    </div>
                <%  }
                   } else { %>
                    <p style="color: #64748b;">No ward distribution data.</p>
                <% } %>
            </div>
        </div>
    </div>

    <!-- Filter & Search Toolbar -->
    <div class="card" style="margin-bottom: 1.5rem; padding: 1.25rem;">
        <form action="<%= request.getContextPath() %>/admin/dashboard" method="GET" style="display: flex; gap: 12px; flex-wrap: wrap; align-items: flex-end;">
            <div style="flex: 2; min-width: 180px;">
                <label class="form-label" style="font-size: 0.8rem;">Search Ledger</label>
                <input type="text" name="keyword" class="form-control" placeholder="Search by ID, keyword, citizen, phone..." value="<%= selectedKeyword != null ? selectedKeyword : "" %>">
            </div>

            <div style="flex: 1; min-width: 150px;">
                <label class="form-label" style="font-size: 0.8rem;">Department</label>
                <select name="deptId" class="form-control">
                    <option value="ALL">All Departments</option>
                    <% if (departments != null) {
                        for (Department d : departments) { %>
                            <option value="<%= d.getId() %>" <%= (selectedDeptId != null && selectedDeptId.equals(String.valueOf(d.getId()))) ? "selected" : "" %>><%= d.getName() %></option>
                    <%  }
                       } %>
                </select>
            </div>

            <div style="flex: 1; min-width: 130px;">
                <label class="form-label" style="font-size: 0.8rem;">Status</label>
                <select name="status" class="form-control">
                    <option value="ALL">All Statuses</option>
                    <option value="PENDING" <%= "PENDING".equalsIgnoreCase(selectedStatus) ? "selected" : "" %>>Pending</option>
                    <option value="UNDER_REVIEW" <%= "UNDER_REVIEW".equalsIgnoreCase(selectedStatus) ? "selected" : "" %>>Under Review</option>
                    <option value="IN_PROGRESS" <%= "IN_PROGRESS".equalsIgnoreCase(selectedStatus) ? "selected" : "" %>>In Progress</option>
                    <option value="RESOLVED" <%= "RESOLVED".equalsIgnoreCase(selectedStatus) ? "selected" : "" %>>Resolved</option>
                    <option value="REJECTED" <%= "REJECTED".equalsIgnoreCase(selectedStatus) ? "selected" : "" %>>Rejected</option>
                </select>
            </div>

            <div style="flex: 1; min-width: 130px;">
                <label class="form-label" style="font-size: 0.8rem;">Zone</label>
                <select name="ward" class="form-control">
                    <option value="ALL">All Zones</option>
                    <option value="Zone 1 - Central Business District" <%= "Zone 1 - Central Business District".equalsIgnoreCase(selectedWard) ? "selected" : "" %>>Zone 1 - Central Business District</option>
                    <option value="Zone 2 - Koramangala & HSR Layout" <%= "Zone 2 - Koramangala & HSR Layout".equalsIgnoreCase(selectedWard) ? "selected" : "" %>>Zone 2 - Koramangala &amp; HSR Layout</option>
                    <option value="Zone 3 - Indiranagar & Domlur" <%= "Zone 3 - Indiranagar & Domlur".equalsIgnoreCase(selectedWard) ? "selected" : "" %>>Zone 3 - Indiranagar &amp; Domlur</option>
                    <option value="Zone 4 - Whitefield & Mahadevapura" <%= "Zone 4 - Whitefield & Mahadevapura".equalsIgnoreCase(selectedWard) ? "selected" : "" %>>Zone 4 - Whitefield &amp; Mahadevapura</option>
                    <option value="Zone 5 - Jayanagar & JP Nagar" <%= "Zone 5 - Jayanagar & JP Nagar".equalsIgnoreCase(selectedWard) ? "selected" : "" %>>Zone 5 - Jayanagar &amp; JP Nagar</option>
                    <option value="Zone 6 - Malleshwaram & Rajajinagar" <%= "Zone 6 - Malleshwaram & Rajajinagar".equalsIgnoreCase(selectedWard) ? "selected" : "" %>>Zone 6 - Malleshwaram &amp; Rajajinagar</option>
                    <option value="Zone 7 - Hebbal & Yelahanka North" <%= "Zone 7 - Hebbal & Yelahanka North".equalsIgnoreCase(selectedWard) ? "selected" : "" %>>Zone 7 - Hebbal &amp; Yelahanka North</option>
                </select>
            </div>

            <div style="display: flex; gap: 8px;">
                <button type="submit" class="btn btn-primary" style="padding: 10px 18px;">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                    Filter
                </button>
                <a href="<%= request.getContextPath() %>/admin/dashboard" class="btn btn-secondary" style="padding: 10px 14px;">Reset</a>
            </div>
        </form>
    </div>

    <!-- Master Complaints Table -->
    <div class="card">
        <div class="card-header">
            <div class="card-title">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline></svg>
                Municipal Grievance Master Register (<%= complaints != null ? complaints.size() : 0 %>)
            </div>
        </div>

        <div class="table-responsive">
            <table class="table filterable-table">
                <thead>
                    <tr>
                        <th>Tracking ID</th>
                        <th>Sector &amp; Subject</th>
                        <th>Zone &amp; Coordinates</th>
                        <th>Citizen Details</th>
                        <th>Assigned Dept &amp; Officer</th>
                        <th>SLA Status</th>
                        <th>Status</th>
                        <th>Commissioner Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (complaints != null && !complaints.isEmpty()) {
                        for (Complaint c : complaints) { %>
                            <tr>
                                <td>
                                    <a href="<%= request.getContextPath() %>/complaint-details?id=<%= c.getId() %>" style="font-weight: 700; color: #1d4ed8;">
                                        <%= c.getComplaintCode() %>
                                    </a>
                                </td>
                                <td>
                                    <div style="font-weight: 600; color: #0f172a; max-width: 220px;"><%= c.getTitle() %></div>
                                    <div style="font-size: 0.775rem; color: #64748b;"><%= c.getCategory() %></div>
                                </td>
                                <td>
                                    <div style="font-size: 0.85rem;"><%= c.getWardZone() %></div>
                                    <div style="font-size: 0.75rem; color: #64748b; max-width: 180px;"><%= c.getLocation() %></div>
                                    <% if (c.getLatitude() != null && !c.getLatitude().isEmpty()) { %>
                                        <div style="font-size: 0.7rem; color: #94a3b8;"><%= c.getLatitude() %>, <%= c.getLongitude() %></div>
                                    <% } %>
                                </td>
                                <td>
                                    <div style="font-size: 0.85rem; font-weight: 600;"><%= c.getCitizenName() %></div>
                                    <div style="font-size: 0.775rem; color: #64748b; display: flex; align-items: center; gap: 4px;">
                                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path></svg>
                                        <%= c.getCitizenPhone() %>
                                    </div>
                                </td>
                                <td>
                                    <div style="font-size: 0.85rem; font-weight: 600; color: #1e3a8a;">
                                        <%= c.getDepartmentName() != null ? c.getDepartmentName() : "Unassigned" %>
                                    </div>
                                    <div style="font-size: 0.75rem; color: #64748b;">
                                        <%= c.getAssignedOfficerName() != null ? c.getAssignedOfficerName() : "Departmental Pool" %>
                                    </div>
                                </td>
                                <td>
                                    <span class="badge <%= c.getSlaRemainingClass() %>"><%= c.getSlaRemainingLabel() %></span>
                                </td>
                                <td><span class="badge <%= c.getStatusBadgeClass() %>"><%= c.getStatus() %></span></td>
                                <td>
                                    <div style="display: flex; gap: 6px; flex-wrap: nowrap;">
                                        <button type="button" class="btn btn-primary btn-sm" onclick="openAdminAssignModal('<%= c.getId() %>', '<%= c.getDepartmentId() != null ? c.getDepartmentId() : "" %>', '<%= c.getAssignedOfficerId() != null ? c.getAssignedOfficerId() : "" %>')" title="Assign Department &amp; Officer">
                                            Assign
                                        </button>
                                        <a href="<%= request.getContextPath() %>/complaint-details?id=<%= c.getId() %>" class="btn btn-secondary btn-sm" title="Inspect Full Complaint File">
                                            View
                                        </a>
                                        <form action="<%= request.getContextPath() %>/admin/action" method="POST" onsubmit="return confirm('Permanently remove complaint record <%= c.getComplaintCode() %>?');" style="display: inline;">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="complaintId" value="<%= c.getId() %>">
                                            <button type="submit" class="btn btn-danger btn-sm" title="Delete">
                                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg>
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                    <%  }
                       } else { %>
                            <tr>
                                <td colspan="8" style="text-align: center; color: #64748b; padding: 3rem;">
                                    No complaints found matching the criteria.
                                </td>
                            </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Modal: Assign Department & Officer -->
<div class="modal-overlay" id="adminAssignModal">
    <div class="modal">
        <form action="<%= request.getContextPath() %>/admin/action" method="POST">
            <input type="hidden" name="action" value="assign">
            <input type="hidden" name="complaintId" id="assignComplaintId">

            <div class="modal-header">
                <div class="modal-title">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="8.5" cy="7" r="4"></circle><polyline points="17 11 19 13 23 9"></polyline></svg>
                    Dispatch Grievance to Municipal Engineering Cell
                </div>
                <button type="button" class="modal-close" onclick="closeModal('adminAssignModal')">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                </button>
            </div>

            <div class="modal-body">
                <div class="form-group">
                    <label class="form-label" for="assignDeptSelect">Target Division <span class="required">*</span></label>
                    <select name="departmentId" id="assignDeptSelect" class="form-control" required>
                        <option value="">-- Choose Municipal Division --</option>
                        <% if (departments != null) {
                            for (Department d : departments) { %>
                                <option value="<%= d.getId() %>"><%= d.getName() %></option>
                        <%  }
                           } %>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label" for="assignOfficerSelect">Assign Engineer / Officer in Charge</label>
                    <select name="officerId" id="assignOfficerSelect" class="form-control">
                        <option value="0">-- General Zonal Pool --</option>
                        <% if (officers != null) {
                            for (User u : officers) {
                                if ("OFFICER".equalsIgnoreCase(u.getRole())) { %>
                                    <option value="<%= u.getId() %>"><%= u.getFullName() %> (<%= u.getDesignation() != null ? u.getDesignation() : u.getDepartmentName() %>)</option>
                        <%      }
                            }
                           } %>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label" for="assignRemarks">Executive Commissioner Directives</label>
                    <textarea name="remarks" id="assignRemarks" class="form-control" rows="3" placeholder="Directives for field execution, contractor mobilization, SLA priority..."></textarea>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('adminAssignModal')">Cancel</button>
                <button type="submit" class="btn btn-primary">Authorize &amp; Dispatch</button>
            </div>
        </form>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.citycare.model.User" %>
<%@ page import="com.citycare.model.Complaint" %>
<%@ page import="com.citycare.model.Department" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    List<Complaint> myComplaints = (List<Complaint>) request.getAttribute("myComplaints");
    List<Department> departments = (List<Department>) request.getAttribute("departments");

    int myTotal = (Integer) request.getAttribute("myTotal");
    int myPending = (Integer) request.getAttribute("myPending");
    int myInProgress = (Integer) request.getAttribute("myInProgress");
    int myResolved = (Integer) request.getAttribute("myResolved");
%>
<jsp:include page="/includes/header.jsp" />

<div class="container-fluid" style="padding-top: 2rem; padding-bottom: 4rem;">

    <!-- Dashboard Top Bar -->
    <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem; margin-bottom: 2rem;">
        <div>
            <div style="display: flex; align-items: center; gap: 10px;">
                <h1 style="font-size: 1.85rem; font-weight: 800; color: #0f172a;">Citizen Grievance Console</h1>
                <span class="user-role-badge" style="background: #e0f2fe; color: #0369a1; border: 1px solid #bae6fd;">Verified Resident</span>
            </div>
            <p style="color: #64748b; font-size: 0.925rem; margin-top: 2px;">
                Welcome, <strong><%= user.getFullName() %></strong> &bull; Track your filed civic grievances, lodge new reports, and review municipal action milestones.
            </p>
        </div>
        <div style="display: flex; gap: 10px;">
            <a href="<%= request.getContextPath() %>/track" class="btn btn-secondary btn-sm">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                Track by ID
            </a>
            <a href="<%= request.getContextPath() %>/lodgeComplaint.jsp" class="btn btn-primary btn-sm">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                Lodge New Grievance
            </a>
        </div>
    </div>

    <!-- Citizen KPI Metric Cards -->
    <div class="stats-grid" style="margin-bottom: 2rem;">
        <div class="stat-card">
            <div class="stat-icon" style="background: #eff6ff; color: #1d4ed8;">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline></svg>
            </div>
            <div class="stat-info">
                <div class="stat-value"><%= myTotal %></div>
                <div class="stat-label">Total Grievances Filed</div>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon" style="background: #fffbeb; color: #d97706;">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
            </div>
            <div class="stat-info">
                <div class="stat-value"><%= myPending %></div>
                <div class="stat-label">Pending Verification</div>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon" style="background: #f5f3ff; color: #7c3aed;">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z"></path></svg>
            </div>
            <div class="stat-info">
                <div class="stat-value"><%= myInProgress %></div>
                <div class="stat-label">Repair Work In Progress</div>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon" style="background: #ecfdf5; color: #059669;">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
            </div>
            <div class="stat-info">
                <div class="stat-value"><%= myResolved %></div>
                <div class="stat-label">Successfully Resolved</div>
            </div>
        </div>
    </div>

    <!-- Quick Grievance Submission / Quick Track Bar -->
    <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 1.5rem; margin-bottom: 2rem;">
        
        <!-- Track Box -->
        <div class="card" style="padding: 1.5rem;">
            <div class="card-header" style="margin-bottom: 1rem; padding-bottom: 0.75rem;">
                <div class="card-title" style="font-size: 1.05rem;">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                    Live Status Inquiry
                </div>
            </div>
            <form action="<%= request.getContextPath() %>/track" method="GET" style="display: flex; gap: 8px;">
                <input type="text" name="code" class="form-control" placeholder="Enter Complaint ID (e.g. CC-2026-1001)" required>
                <button type="submit" class="btn btn-primary" style="white-space: nowrap;">Track Progress</button>
            </form>
        </div>

        <!-- Quick Help Card -->
        <div class="card" style="padding: 1.5rem; background: #eff6ff; border-color: #bfdbfe;">
            <div style="font-weight: 700; color: #1e3a8a; font-size: 0.95rem; margin-bottom: 4px; display: flex; align-items: center; gap: 6px;">
                <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>
                24x7 Citizen Assistance
            </div>
            <p style="font-size: 0.82rem; color: #1e40af; line-height: 1.5;">
                Toll Free: <strong>1800-CITY-CARE</strong><br>
                For immediate pipeline bursts or power emergencies.
            </p>
        </div>
    </div>

    <!-- My Registered Grievances Table -->
    <div class="card">
        <div class="card-header">
            <div class="card-title">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline></svg>
                My Registered Grievance Records (<%= myComplaints != null ? myComplaints.size() : 0 %>)
            </div>
            <a href="<%= request.getContextPath() %>/lodgeComplaint.jsp" class="btn btn-primary btn-sm">
                &plus; Lodge Grievance
            </a>
        </div>

        <div class="table-responsive">
            <table class="table filterable-table">
                <thead>
                    <tr>
                        <th>Tracking ID</th>
                        <th>Category &amp; Issue Title</th>
                        <th>Ward / Location</th>
                        <th>Assigned Dept</th>
                        <th>Priority</th>
                        <th>Current Status</th>
                        <th>Lodged Date</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (myComplaints != null && !myComplaints.isEmpty()) {
                        for (Complaint c : myComplaints) { %>
                            <tr>
                                <td>
                                    <a href="<%= request.getContextPath() %>/track?code=<%= c.getComplaintCode() %>" style="font-weight: 700; color: #1d4ed8;">
                                        <%= c.getComplaintCode() %>
                                    </a>
                                </td>
                                <td>
                                    <div style="font-weight: 600; color: #0f172a; max-width: 240px;"><%= c.getTitle() %></div>
                                    <div style="font-size: 0.775rem; color: #64748b;"><%= c.getCategory() %></div>
                                </td>
                                <td>
                                    <div style="font-size: 0.85rem;"><%= c.getWardZone() %></div>
                                    <div style="font-size: 0.75rem; color: #64748b; max-width: 180px;"><%= c.getLocation() %></div>
                                </td>
                                <td>
                                    <span style="font-size: 0.85rem; font-weight: 600; color: #1e3a8a;">
                                        <%= c.getDepartmentName() != null ? c.getDepartmentName() : "In Triage" %>
                                    </span>
                                </td>
                                <td><span class="badge <%= c.getPriorityBadgeClass() %>"><%= c.getPriority() %></span></td>
                                <td><span class="badge <%= c.getStatusBadgeClass() %>"><%= c.getStatus() %></span></td>
                                <td style="font-size: 0.78rem; color: #64748b;"><%= c.getFormattedCreatedAt() %></td>
                                <td>
                                    <div style="display: flex; gap: 6px;">
                                        <a href="<%= request.getContextPath() %>/track?code=<%= c.getComplaintCode() %>" class="btn btn-primary btn-sm">
                                            Track
                                        </a>
                                        <% if ("RESOLVED".equalsIgnoreCase(c.getStatus()) && c.getCitizenRating() == 0) { %>
                                            <a href="<%= request.getContextPath() %>/track?code=<%= c.getComplaintCode() %>" class="btn btn-secondary btn-sm" style="color: #d97706; border-color: #fde68a;">
                                                Rate
                                            </a>
                                        <% } %>
                                    </div>
                                </td>
                            </tr>
                    <%  }
                       } else { %>
                            <tr>
                                <td colspan="8" style="text-align: center; color: #64748b; padding: 3rem;">
                                    You have not submitted any complaints yet. <a href="<%= request.getContextPath() %>/lodgeComplaint.jsp">Click here to lodge a complaint.</a>
                                </td>
                            </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />

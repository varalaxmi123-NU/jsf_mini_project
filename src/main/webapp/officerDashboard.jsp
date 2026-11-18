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

    List<Complaint> complaints = (List<Complaint>) request.getAttribute("complaints");
    List<Department> departments = (List<Department>) request.getAttribute("departments");

    int pendingCount = (Integer) request.getAttribute("pendingCount");
    int reviewCount = (Integer) request.getAttribute("reviewCount");
    int inProgressCount = (Integer) request.getAttribute("inProgressCount");
    int resolvedCount = (Integer) request.getAttribute("resolvedCount");
    int totalCount = (Integer) request.getAttribute("totalCount");

    String selectedKeyword = (String) request.getAttribute("selectedKeyword");
    String selectedCategory = (String) request.getAttribute("selectedCategory");
    String selectedStatus = (String) request.getAttribute("selectedStatus");
    String selectedWard = (String) request.getAttribute("selectedWard");

    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<jsp:include page="/includes/header.jsp" />

<div class="container-fluid" style="padding-top: 2rem; padding-bottom: 4rem;">

    <!-- Dashboard Top Bar -->
    <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem; margin-bottom: 2rem;">
        <div>
            <div style="display: flex; align-items: center; gap: 10px;">
                <h1 style="font-size: 1.85rem; font-weight: 800; color: #0f172a;">Municipal Engineering Workspace</h1>
                <span class="user-role-badge role-officer"><%= user.getDepartmentName() != null ? user.getDepartmentName() : "Civic Works" %></span>
            </div>
            <p style="color: #64748b; font-size: 0.925rem; margin-top: 2px;">
                Officer: <strong><%= user.getFullName() %></strong> (<%= user.getDesignation() != null ? user.getDesignation() : "Executive Engineer" %>) &bull; Field crew dispatch, contractor supervision &amp; resolution certification.
            </p>
        </div>
        <div style="display: flex; gap: 10px;">
            <a href="<%= request.getContextPath() %>/officer/dashboard" class="btn btn-secondary btn-sm">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"><polyline points="23 4 23 10 17 10"></polyline><path d="M20.49 15a9 9 0 1 1-2.12-9.36L23 10"></path></svg>
                Refresh
            </a>
            <a href="<%= request.getContextPath() %>/lodgeComplaint.jsp" class="btn btn-primary btn-sm">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                Lodge Internal Work Order
            </a>
        </div>
    </div>

    <!-- Alert Notifications -->
    <% if ("StatusUpdated".equalsIgnoreCase(success)) { %>
        <div class="alert alert-success">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
            Progress certified: status, contractor assignment, and resolution notes updated in Municipal Ledger!
        </div>
    <% } else if ("DepartmentReassigned".equalsIgnoreCase(success)) { %>
        <div class="alert alert-info">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
            Grievance successfully re-routed to appropriate engineering division!
        </div>
    <% } %>

    <!-- KPI Metric Cards -->
    <div class="stats-grid" style="margin-bottom: 2rem;">
        <div class="stat-card">
            <div class="stat-icon" style="background: #eff6ff; color: #1d4ed8;">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline></svg>
            </div>
            <div class="stat-info">
                <div class="stat-value"><%= totalCount %></div>
                <div class="stat-label">Total Assigned to Division</div>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon" style="background: #fffbeb; color: #d97706;">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
            </div>
            <div class="stat-info">
                <div class="stat-value"><%= pendingCount %></div>
                <div class="stat-label">Pending Initial Inspection</div>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon" style="background: #f5f3ff; color: #7c3aed;">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
            </div>
            <div class="stat-info">
                <div class="stat-value"><%= reviewCount %></div>
                <div class="stat-label">Under Investigation</div>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon" style="background: #ecfeff; color: #0284c7;">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z"></path></svg>
            </div>
            <div class="stat-info">
                <div class="stat-value"><%= inProgressCount %></div>
                <div class="stat-label">Field Execution Active</div>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon" style="background: #ecfdf5; color: #059669;">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
            </div>
            <div class="stat-info">
                <div class="stat-value"><%= resolvedCount %></div>
                <div class="stat-label">Completed &amp; Certified</div>
            </div>
        </div>
    </div>

    <!-- Filter & Search Toolbar -->
    <div class="card" style="margin-bottom: 1.5rem; padding: 1.25rem;">
        <form action="<%= request.getContextPath() %>/officer/dashboard" method="GET" style="display: flex; gap: 12px; flex-wrap: wrap; align-items: flex-end;">
            <div style="flex: 2; min-width: 200px;">
                <label class="form-label" style="font-size: 0.8rem;">Search Department Workload</label>
                <input type="text" name="keyword" class="form-control" placeholder="Search by ID, keyword, citizen, phone..." value="<%= selectedKeyword != null ? selectedKeyword : "" %>">
            </div>

            <div style="flex: 1; min-width: 150px;">
                <label class="form-label" style="font-size: 0.8rem;">Status</label>
                <select name="status" class="form-control">
                    <option value="ALL">All Statuses</option>
                    <option value="PENDING" <%= "PENDING".equalsIgnoreCase(selectedStatus) ? "selected" : "" %>>Pending Inspection</option>
                    <option value="UNDER_REVIEW" <%= "UNDER_REVIEW".equalsIgnoreCase(selectedStatus) ? "selected" : "" %>>Under Review</option>
                    <option value="IN_PROGRESS" <%= "IN_PROGRESS".equalsIgnoreCase(selectedStatus) ? "selected" : "" %>>In Progress</option>
                    <option value="RESOLVED" <%= "RESOLVED".equalsIgnoreCase(selectedStatus) ? "selected" : "" %>>Resolved &amp; Verified</option>
                    <option value="REJECTED" <%= "REJECTED".equalsIgnoreCase(selectedStatus) ? "selected" : "" %>>Rejected</option>
                </select>
            </div>

            <div style="flex: 1; min-width: 150px;">
                <label class="form-label" style="font-size: 0.8rem;">Category</label>
                <select name="category" class="form-control">
                    <option value="ALL">All Categories</option>
                    <option value="Potholes & Roads" <%= "Potholes & Roads".equalsIgnoreCase(selectedCategory) ? "selected" : "" %>>Potholes &amp; Roads</option>
                    <option value="Overflowing Garbage" <%= "Overflowing Garbage".equalsIgnoreCase(selectedCategory) ? "selected" : "" %>>Overflowing Garbage</option>
                    <option value="Damaged Streetlights" <%= "Damaged Streetlights".equalsIgnoreCase(selectedCategory) ? "selected" : "" %>>Damaged Streetlights</option>
                    <option value="Water Leakage" <%= "Water Leakage".equalsIgnoreCase(selectedCategory) ? "selected" : "" %>>Water Leakage</option>
                    <option value="Drainage & Sewage" <%= "Drainage & Sewage".equalsIgnoreCase(selectedCategory) ? "selected" : "" %>>Drainage &amp; Sewage</option>
                    <option value="Fallen Tree / Parks" <%= "Fallen Tree / Parks".equalsIgnoreCase(selectedCategory) ? "selected" : "" %>>Fallen Tree / Parks</option>
                </select>
            </div>

            <div style="display: flex; gap: 8px;">
                <button type="submit" class="btn btn-primary" style="padding: 10px 18px;">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                    Filter
                </button>
                <a href="<%= request.getContextPath() %>/officer/dashboard" class="btn btn-secondary" style="padding: 10px 14px;">Reset</a>
            </div>
        </form>
    </div>

    <!-- Complaints Master Table -->
    <div class="card">
        <div class="card-header">
            <div class="card-title">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline></svg>
                Active Department Work Orders (<%= complaints != null ? complaints.size() : 0 %>)
            </div>
        </div>

        <div class="table-responsive">
            <table class="table filterable-table">
                <thead>
                    <tr>
                        <th>Tracking ID</th>
                        <th>Sector &amp; Description</th>
                        <th>Location Landmark</th>
                        <th>Citizen Contact</th>
                        <th>SLA Status</th>
                        <th>Current Status</th>
                        <th>Lodged Date</th>
                        <th>Field Action</th>
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
                                    <div style="font-weight: 600; color: #0f172a; max-width: 240px;"><%= c.getTitle() %></div>
                                    <div style="font-size: 0.775rem; color: #64748b;"><%= c.getCategory() %></div>
                                </td>
                                <td>
                                    <div style="max-width: 200px; font-size: 0.85rem;"><%= c.getLocation() %></div>
                                    <div style="font-size: 0.75rem; color: #64748b;"><%= c.getWardZone() %></div>
                                </td>
                                <td>
                                    <div style="font-size: 0.85rem; font-weight: 600;"><%= c.getCitizenName() %></div>
                                    <div style="font-size: 0.775rem; color: #64748b; display: flex; align-items: center; gap: 4px;">
                                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path></svg>
                                        <%= c.getCitizenPhone() %>
                                    </div>
                                </td>
                                <td>
                                    <span class="badge <%= c.getSlaRemainingClass() %>"><%= c.getSlaRemainingLabel() %></span>
                                </td>
                                <td><span class="badge <%= c.getStatusBadgeClass() %>"><%= c.getStatus() %></span></td>
                                <td style="font-size: 0.78rem; color: #64748b;"><%= c.getFormattedCreatedAt() %></td>
                                <td>
                                    <div style="display: flex; gap: 6px; flex-wrap: nowrap;">
                                        <button type="button" class="btn btn-primary btn-sm" onclick="openOfficerModal('<%= c.getId() %>', '<%= c.getStatus() %>', '<%= c.getRemarks() != null ? c.getRemarks().replace("'", "\\'") : "" %>', '<%= c.getContractorAssigned() != null ? c.getContractorAssigned().replace("'", "\\'") : "" %>', '<%= c.getMaterialsUsed() != null ? c.getMaterialsUsed().replace("'", "\\'") : "" %>')">
                                            Update
                                        </button>
                                        <a href="<%= request.getContextPath() %>/complaint-details?id=<%= c.getId() %>" class="btn btn-secondary btn-sm" title="View Full File">
                                            View
                                        </a>
                                    </div>
                                </td>
                            </tr>
                    <%  }
                       } else { %>
                            <tr>
                                <td colspan="8" style="text-align: center; color: #64748b; padding: 3rem;">
                                    No complaints currently assigned to this division matching the filter criteria.
                                </td>
                            </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Modal: Update Complaint Status with Real-world Engineering details -->
<div class="modal-overlay" id="officerStatusModal">
    <div class="modal" style="max-width: 580px;">
        <form action="<%= request.getContextPath() %>/officer/action" method="POST">
            <input type="hidden" name="action" value="updateStatus">
            <input type="hidden" name="complaintId" id="modalComplaintId">

            <div class="modal-header">
                <div class="modal-title">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"><polyline points="9 11 12 14 22 4"></polyline><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path></svg>
                    Certify Progress &amp; Assign Engineering Resources
                </div>
                <button type="button" class="modal-close" onclick="closeModal('officerStatusModal')">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                </button>
            </div>

            <div class="modal-body">
                <div class="form-group">
                    <label class="form-label" for="modalNewStatus">Updated Status Milestone <span class="required">*</span></label>
                    <select name="newStatus" id="modalNewStatus" class="form-control" onchange="toggleResolutionNotes(this.value)" required>
                        <option value="UNDER_REVIEW">UNDER_REVIEW (Site Inspection &amp; Triage)</option>
                        <option value="IN_PROGRESS">IN_PROGRESS (Contractor / Crew Dispatched)</option>
                        <option value="RESOLVED">RESOLVED (Repair Completed &amp; Verified)</option>
                        <option value="REJECTED">REJECTED (Out of Jurisdiction / Invalid)</option>
                    </select>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="modalContractor">Contractor / Taskforce Unit</label>
                        <input type="text" name="contractor" id="modalContractor" class="form-control" placeholder="E.g., Kaveri Infrastructure / Unit 4">
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="modalMaterials">Materials / Equipment Used</label>
                        <input type="text" name="materials" id="modalMaterials" class="form-control" placeholder="E.g., DBM Bitumen mix / DI pipe sleeve">
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="modalRemarks">Officer Engineering Remarks <span class="required">*</span></label>
                    <textarea name="remarks" id="modalRemarks" class="form-control" rows="3" placeholder="Field inspection findings, site assessment notes, crew dispatch details..." required></textarea>
                </div>

                <div class="form-group" id="modalResolutionGroup" style="display: none;">
                    <label class="form-label" for="modalResolutionNotes">Official Resolution Certificate Notes <span class="required">*</span></label>
                    <textarea name="resolutionNotes" id="modalResolutionNotes" class="form-control" rows="3" placeholder="Describe the completed repair, quality test verification, and reopening date..."></textarea>
                    <div class="form-text">This certified statement is displayed directly to the citizen and published on the Municipal Transparency Ledger.</div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('officerStatusModal')">Cancel</button>
                <button type="submit" class="btn btn-primary">Certify &amp; Save Update</button>
            </div>
        </form>
    </div>
</div>

<script>
function openOfficerModal(id, st, rem, cont, mat) {
    document.getElementById('modalComplaintId').value = id;
    var statusSelect = document.getElementById('modalNewStatus');
    statusSelect.value = st;
    toggleResolutionNotes(st);

    document.getElementById('modalRemarks').value = rem || '';
    document.getElementById('modalContractor').value = cont || '';
    document.getElementById('modalMaterials').value = mat || '';

    window.openModal('officerStatusModal');
}
</script>

<jsp:include page="/includes/footer.jsp" />

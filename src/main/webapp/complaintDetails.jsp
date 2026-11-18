<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.citycare.model.User" %>
<%@ page import="com.citycare.model.Complaint" %>
<%@ page import="com.citycare.model.ComplaintLog" %>
<%@ page import="com.citycare.model.Department" %>
<%@ page import="java.util.List" %>
<%
    User sessionUser = (User) session.getAttribute("currentUser");
    if (sessionUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    Complaint c = (Complaint) request.getAttribute("complaint");
    List<ComplaintLog> logs = (List<ComplaintLog>) request.getAttribute("logs");
    List<Department> departments = (List<Department>) request.getAttribute("departments");
    List<User> officers = (List<User>) request.getAttribute("officers");

    if (c == null) {
        response.sendRedirect(request.getContextPath() + "/officer/dashboard");
        return;
    }
%>
<jsp:include page="/includes/header.jsp" />

<div class="container" style="padding-top: 2rem; padding-bottom: 4rem;">

    <!-- Back button & Header -->
    <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem; margin-bottom: 1.5rem;">
        <div>
            <a href="<%= "ADMIN".equalsIgnoreCase(sessionUser.getRole()) ? request.getContextPath() + "/admin/dashboard" : request.getContextPath() + "/officer/dashboard" %>" style="display: inline-flex; align-items: center; gap: 6px; font-size: 0.85rem; color: #64748b; margin-bottom: 0.5rem;">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"><polyline points="15 18 9 12 15 6"></polyline></svg>
                Back to Dashboard
            </a>
            <div style="display: flex; align-items: center; gap: 12px; flex-wrap: wrap;">
                <h1 style="font-size: 1.85rem; font-weight: 800; color: #0f172a;">Complaint Case: <%= c.getComplaintCode() %></h1>
                <span class="badge <%= c.getStatusBadgeClass() %>" style="font-size: 0.85rem; padding: 6px 12px;"><%= c.getStatus() %></span>
                <span class="badge <%= c.getPriorityBadgeClass() %>"><%= c.getPriority() %> PRIORITY</span>
            </div>
        </div>

        <div style="display: flex; gap: 8px;">
            <button onclick="window.print()" class="btn btn-secondary btn-sm">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"><polyline points="6 9 6 2 18 2 18 9"></polyline><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"></path><rect x="6" y="14" width="12" height="8"></rect></svg>
                Print Case File
            </button>
            <a href="<%= request.getContextPath() %>/track?code=<%= c.getComplaintCode() %>" target="_blank" class="btn btn-secondary btn-sm">
                Public View ↗
            </a>
        </div>
    </div>

    <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 1.5rem; align-items: flex-start;">

        <!-- Left Column: Details & Timeline -->
        <div>
            <!-- Main Content Card -->
            <div class="card" style="margin-bottom: 1.5rem;">
                <div class="card-header">
                    <div class="card-title">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline></svg>
                        Incident Summary
                    </div>
                    <span style="font-size: 0.82rem; color: #64748b;">Registered: <%= c.getFormattedCreatedAt() %></span>
                </div>

                <div style="margin-bottom: 1.25rem;">
                    <div style="font-size: 0.75rem; color: #64748b; font-weight: 700; text-transform: uppercase;">Subject Title</div>
                    <h3 style="font-size: 1.2rem; font-weight: 700; color: #0f172a; margin-top: 2px;"><%= c.getTitle() %></h3>
                </div>

                <div style="margin-bottom: 1.25rem;">
                    <div style="font-size: 0.75rem; color: #64748b; font-weight: 700; text-transform: uppercase;">Category</div>
                    <div style="font-weight: 600; color: #1d4ed8; margin-top: 2px;"><%= c.getCategory() %></div>
                </div>

                <div style="margin-bottom: 1.25rem;">
                    <div style="font-size: 0.75rem; color: #64748b; font-weight: 700; text-transform: uppercase;">Description</div>
                    <p style="color: #334155; line-height: 1.7; margin-top: 4px; white-space: pre-wrap;"><%= c.getDescription() %></p>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; background: #f8fafc; padding: 1rem; border-radius: 8px; border: 1px solid var(--border-color);">
                    <div>
                        <div style="font-size: 0.75rem; color: #64748b; font-weight: 700; text-transform: uppercase;">Ward / Zone</div>
                        <div style="font-weight: 600; color: #0f172a;"><%= c.getWardZone() %></div>
                    </div>
                    <div>
                        <div style="font-size: 0.75rem; color: #64748b; font-weight: 700; text-transform: uppercase;">Exact Landmark / Street</div>
                        <div style="font-weight: 600; color: #0f172a;"><%= c.getLocation() %></div>
                    </div>
                </div>

                <% if (c.getResolutionNotes() != null && !c.getResolutionNotes().trim().isEmpty()) { %>
                    <div style="margin-top: 1.25rem; background: var(--success-light); border: 1px solid var(--success-border); border-radius: 8px; padding: 1.25rem;">
                        <h4 style="color: #065f46; margin-bottom: 6px; display: flex; align-items: center; gap: 8px;">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                            Official Resolution Summary
                        </h4>
                        <p style="color: #047857; font-size: 0.88rem; line-height: 1.6;"><%= c.getResolutionNotes() %></p>
                        <div style="font-size: 0.78rem; color: #059669; margin-top: 6px;">
                            Resolved At: <strong><%= c.getFormattedResolvedAt() %></strong>
                        </div>
                    </div>
                <% } %>

                <% if (c.getCitizenRating() > 0) { %>
                    <div style="margin-top: 1.25rem; background: var(--warning-light); border: 1px solid var(--warning-border); border-radius: 8px; padding: 1.25rem;">
                        <div style="display: flex; align-items: center; justify-content: space-between;">
                            <h4 style="color: #92400e; margin-bottom: 4px; font-size: 0.95rem;">Citizen Satisfaction Rating</h4>
                            <div class="stars-display">
                                <% for (int i = 0; i < c.getCitizenRating(); i++) { %>
                                    <svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                                <% } %>
                                <% for (int i = c.getCitizenRating(); i < 5; i++) { %>
                                    <svg class="empty" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                                <% } %>
                            </div>
                        </div>
                        <p style="color: #78350f; font-size: 0.88rem; margin-top: 6px;">
                            "<%= c.getCitizenFeedback() != null && !c.getCitizenFeedback().trim().isEmpty() ? c.getCitizenFeedback() : "Confirmed resolved." %>"
                        </p>
                    </div>
                <% } %>
            </div>

            <!-- Milestone Audit Timeline -->
            <div class="card">
                <div class="card-header">
                    <div class="card-title">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                        Chronological Action Logs
                    </div>
                </div>

                <div class="timeline">
                    <% if (logs != null && !logs.isEmpty()) {
                        for (ComplaintLog log : logs) { 
                            boolean isRes = log.getAction() != null && log.getAction().toLowerCase().contains("resolved");
                    %>
                        <div class="timeline-item <%= isRes ? "resolved" : "" %>">
                            <div class="timeline-dot"></div>
                            <div class="timeline-content">
                                <div class="timeline-header">
                                    <div class="timeline-action"><%= log.getAction() %></div>
                                    <div class="timeline-date"><%= log.getFormattedDate() %></div>
                                </div>
                                <div class="timeline-body"><%= log.getRemarks() %></div>
                                <div class="timeline-by">Action by: <strong><%= log.getPerformedBy() %></strong></div>
                            </div>
                        </div>
                    <%  }
                       } else { %>
                        <p style="color: #64748b;">No action logs available.</p>
                    <% } %>
                </div>
            </div>
        </div>

        <!-- Right Column: Citizen Card & Status Action Box -->
        <div>
            <!-- Citizen Card -->
            <div class="card" style="margin-bottom: 1.5rem;">
                <div class="card-header">
                    <div class="card-title">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                        Citizen Details
                    </div>
                </div>

                <div style="margin-bottom: 1rem;">
                    <div style="font-size: 0.75rem; color: #64748b; font-weight: 700; text-transform: uppercase;">Name</div>
                    <div style="font-weight: 700; color: #0f172a; font-size: 1rem;"><%= c.getCitizenName() %></div>
                </div>

                <div style="margin-bottom: 1rem;">
                    <div style="font-size: 0.75rem; color: #64748b; font-weight: 700; text-transform: uppercase;">Mobile Phone</div>
                    <div>
                        <a href="tel:<%= c.getCitizenPhone() %>" style="font-weight: 600; color: #1d4ed8; display: inline-flex; align-items: center; gap: 6px;">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path></svg>
                            <%= c.getCitizenPhone() %>
                        </a>
                    </div>
                </div>

                <% if (c.getCitizenEmail() != null && !c.getCitizenEmail().trim().isEmpty()) { %>
                    <div style="margin-bottom: 1rem;">
                        <div style="font-size: 0.75rem; color: #64748b; font-weight: 700; text-transform: uppercase;">Email</div>
                        <div>
                            <a href="mailto:<%= c.getCitizenEmail() %>" style="color: #475569; font-size: 0.88rem; display: inline-flex; align-items: center; gap: 6px;">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path><polyline points="22,6 12,13 2,6"></polyline></svg>
                                <%= c.getCitizenEmail() %>
                            </a>
                        </div>
                    </div>
                <% } %>
            </div>

            <!-- Department Assignment Card -->
            <div class="card" style="margin-bottom: 1.5rem;">
                <div class="card-header">
                    <div class="card-title">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>
                        Departmental Cell
                    </div>
                </div>

                <div style="margin-bottom: 0.75rem;">
                    <div style="font-size: 0.75rem; color: #64748b; font-weight: 700; text-transform: uppercase;">Department</div>
                    <div style="font-weight: 700; color: #1e3a8a;">
                        <%= c.getDepartmentName() != null ? c.getDepartmentName() : "Not Assigned" %>
                    </div>
                </div>

                <div style="margin-bottom: 0.75rem;">
                    <div style="font-size: 0.75rem; color: #64748b; font-weight: 700; text-transform: uppercase;">Officer in Charge</div>
                    <div style="font-weight: 600; color: #0f172a;">
                        <%= c.getAssignedOfficerName() != null ? c.getAssignedOfficerName() : "Departmental Pool" %>
                    </div>
                </div>
            </div>

            <!-- Quick Action Box for Officer/Admin -->
            <div class="card" style="border-top: 4px solid #1d4ed8;">
                <div class="card-header">
                    <div class="card-title">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"><polyline points="9 11 12 14 22 4"></polyline><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path></svg>
                        Update Progress
                    </div>
                </div>

                <form action="<%= request.getContextPath() %>/officer/action" method="POST">
                    <input type="hidden" name="action" value="updateStatus">
                    <input type="hidden" name="complaintId" value="<%= c.getId() %>">

                    <div class="form-group">
                        <label class="form-label" for="detailNewStatus">Change Status</label>
                        <select name="newStatus" id="detailNewStatus" class="form-control" onchange="toggleDetailResolution(this.value)">
                            <option value="UNDER_REVIEW" <%= "UNDER_REVIEW".equalsIgnoreCase(c.getStatus()) ? "selected" : "" %>>UNDER_REVIEW (Inspection)</option>
                            <option value="IN_PROGRESS" <%= "IN_PROGRESS".equalsIgnoreCase(c.getStatus()) ? "selected" : "" %>>IN_PROGRESS (Crew Dispatched)</option>
                            <option value="RESOLVED" <%= "RESOLVED".equalsIgnoreCase(c.getStatus()) ? "selected" : "" %>>RESOLVED (Work Done)</option>
                            <option value="REJECTED" <%= "REJECTED".equalsIgnoreCase(c.getStatus()) ? "selected" : "" %>>REJECTED (Invalid)</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="detailRemarks">Officer Remarks <span class="required">*</span></label>
                        <textarea name="remarks" id="detailRemarks" class="form-control" rows="3" placeholder="Enter remarks on inspection or crew deployment..." required><%= c.getRemarks() != null ? c.getRemarks() : "" %></textarea>
                    </div>

                    <div class="form-group" id="detailResolutionBox" style="<%= "RESOLVED".equalsIgnoreCase(c.getStatus()) ? "" : "display: none;" %>">
                        <label class="form-label" for="detailResolutionNotes">Resolution Summary</label>
                        <textarea name="resolutionNotes" id="detailResolutionNotes" class="form-control" rows="3" placeholder="Describe the materials and completed repair work..."><%= c.getResolutionNotes() != null ? c.getResolutionNotes() : "" %></textarea>
                    </div>

                    <button type="submit" class="btn btn-primary btn-block">
                        Save Status &amp; Remarks
                    </button>
                </form>
            </div>
        </div>

    </div>
</div>

<script>
function toggleDetailResolution(status) {
    var box = document.getElementById('detailResolutionBox');
    if (box) {
        box.style.display = (status === 'RESOLVED') ? 'block' : 'none';
    }
}
</script>

<jsp:include page="/includes/footer.jsp" />

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.citycare.model.Complaint" %>
<%@ page import="com.citycare.model.ComplaintLog" %>
<%@ page import="com.citycare.model.User" %>
<%@ page import="java.util.List" %>
<%
    User sessionUser = (User) session.getAttribute("currentUser");
    if (sessionUser == null) {
        response.sendRedirect(request.getContextPath() + "/login?error=" + java.net.URLEncoder.encode("Please sign in to access grievance tracking.", "UTF-8"));
        return;
    }
    Complaint complaint = (Complaint) request.getAttribute("complaint");
    List<ComplaintLog> logs = (List<ComplaintLog>) request.getAttribute("logs");
    Boolean notFound = (Boolean) request.getAttribute("notFound");
    String searchedCode = (String) request.getAttribute("searchedCode");
    String feedbackSaved = request.getParameter("feedbackSaved");
%>
<jsp:include page="/includes/header.jsp" />

<div class="container" style="padding-top: 2.5rem; padding-bottom: 4rem;">
    <div style="max-width: 900px; margin: 0 auto;">

        <!-- Search Header -->
        <div style="text-align: center; margin-bottom: 2.5rem;">
            <h1 style="font-size: 2.1rem; font-weight: 800; color: #0f172a; margin-bottom: 0.5rem;">Track Complaint Progress</h1>
            <p style="color: #64748b; max-width: 600px; margin: 0 auto 1.5rem; font-size: 0.95rem;">
                Enter your unique complaint tracking number to monitor review stages, assigned departments, and real-time field progress.
            </p>

            <form action="<%= request.getContextPath() %>/track" method="GET" style="display: flex; gap: 8px; max-width: 520px; margin: 0 auto;">
                <input type="text" name="code" class="form-control" placeholder="Enter Tracking ID (e.g. CC-2026-1001)" value="<%= complaint != null ? complaint.getComplaintCode() : (searchedCode != null ? searchedCode : "") %>" required style="font-size: 1rem; padding: 12px 16px;">
                <button type="submit" class="btn btn-primary" style="padding: 12px 24px;">
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                    Track
                </button>
            </form>
        </div>

        <% if ("true".equalsIgnoreCase(feedbackSaved)) { %>
            <div class="alert alert-success">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                Thank you. Your feedback and satisfaction rating have been recorded in the Municipal Quality Audit Council records.
            </div>
        <% } %>

        <% if (notFound != null && notFound) { %>
            <div class="card" style="text-align: center; padding: 3rem 1.5rem;">
                <div style="width: 56px; height: 56px; border-radius: 50%; background: #fee2e2; color: #dc2626; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 1rem;">
                    <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line><line x1="8" y1="11" x2="14" y2="11"></line></svg>
                </div>
                <h3 style="color: #dc2626; margin-bottom: 0.5rem; font-size: 1.25rem;">Complaint Record Not Found</h3>
                <p style="color: #64748b; max-width: 480px; margin: 0 auto 1.5rem; font-size: 0.9rem;">
                    No complaint matched ID: <strong><%= searchedCode %></strong>. Please verify the code on your receipt or select a sample ID below.
                </p>
                <div style="font-size: 0.85rem; color: #64748b;">
                    Try demo IDs: 
                    <a href="<%= request.getContextPath() %>/track?code=CC-2026-1001">CC-2026-1001</a> &bull; 
                    <a href="<%= request.getContextPath() %>/track?code=CC-2026-1002">CC-2026-1002</a> &bull; 
                    <a href="<%= request.getContextPath() %>/track?code=CC-2026-1003">CC-2026-1003</a>
                </div>
            </div>
        <% } else if (complaint != null) { %>

            <!-- Detailed Complaint Status Card -->
            <div class="card" style="margin-bottom: 1.75rem;">
                <div class="card-header" style="flex-wrap: wrap; gap: 10px;">
                    <div>
                        <span style="font-size: 0.78rem; color: #64748b; text-transform: uppercase; font-weight: 700; letter-spacing: 0.04em;">Official Tracking ID</span>
                        <div style="font-size: 1.6rem; font-weight: 800; color: #1d4ed8; letter-spacing: -0.01em;">
                            <%= complaint.getComplaintCode() %>
                        </div>
                    </div>
                    <div style="display: flex; gap: 8px; align-items: center;">
                        <span class="badge <%= complaint.getPriorityBadgeClass() %>"><%= complaint.getPriority() %> PRIORITY</span>
                        <span class="badge <%= complaint.getStatusBadgeClass() %>" style="font-size: 0.85rem; padding: 6px 14px;"><%= complaint.getStatus() %></span>
                    </div>
                </div>

                <!-- Progress Stepper -->
                <%
                    String st = complaint.getStatus();
                    int stepNum = 1;
                    if ("UNDER_REVIEW".equalsIgnoreCase(st)) stepNum = 2;
                    else if ("IN_PROGRESS".equalsIgnoreCase(st)) stepNum = 3;
                    else if ("RESOLVED".equalsIgnoreCase(st)) stepNum = 4;
                    else if ("REJECTED".equalsIgnoreCase(st)) stepNum = -1;
                %>
                <div class="stepper">
                    <div class="step-progress-bar" style="width: <%= stepNum == 4 ? "85%" : (stepNum == 3 ? "55%" : (stepNum == 2 ? "30%" : "5%")) %>;"></div>

                    <div class="step <%= stepNum >= 1 ? "completed" : "" %>">
                        <div class="step-circle">
                            <% if (stepNum >= 2) { %>
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"><polyline points="20 6 9 17 4 12"></polyline></svg>
                            <% } else { %>1<% } %>
                        </div>
                        <div class="step-title">Submitted</div>
                        <div class="step-desc">Citizen lodged</div>
                    </div>

                    <div class="step <%= stepNum >= 2 ? (stepNum == 2 ? "active" : "completed") : "" %>">
                        <div class="step-circle">
                            <% if (stepNum >= 3) { %>
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"><polyline points="20 6 9 17 4 12"></polyline></svg>
                            <% } else { %>2<% } %>
                        </div>
                        <div class="step-title">Under Review</div>
                        <div class="step-desc">Triage &amp; verification</div>
                    </div>

                    <div class="step <%= stepNum >= 3 ? (stepNum == 3 ? "active" : "completed") : "" %>">
                        <div class="step-circle">
                            <% if (stepNum >= 4) { %>
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"><polyline points="20 6 9 17 4 12"></polyline></svg>
                            <% } else { %>3<% } %>
                        </div>
                        <div class="step-title">In Progress</div>
                        <div class="step-desc">Field crew dispatched</div>
                    </div>

                    <div class="step <%= stepNum == 4 ? "completed" : (stepNum == -1 ? "rejected" : "") %>">
                        <div class="step-circle">
                            <% if (stepNum == 4) { %>
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"><polyline points="20 6 9 17 4 12"></polyline></svg>
                            <% } else if (stepNum == -1) { %>
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                            <% } else { %>4<% } %>
                        </div>
                        <div class="step-title"><%= stepNum == -1 ? "Rejected" : "Resolved" %></div>
                        <div class="step-desc"><%= stepNum == -1 ? "Invalid request" : "Action completed" %></div>
                    </div>
                </div>

                <!-- Complaint Core Info Grid -->
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1.25rem; background: #f8fafc; border: 1px solid var(--border-color); border-radius: 8px; padding: 1.25rem; margin-bottom: 1.5rem;">
                    <div>
                        <div style="font-size: 0.75rem; color: #64748b; font-weight: 700; text-transform: uppercase;">Category</div>
                        <div style="font-weight: 700; color: #0f172a; margin-top: 2px;"><%= complaint.getCategory() %></div>
                    </div>
                    <div>
                        <div style="font-size: 0.75rem; color: #64748b; font-weight: 700; text-transform: uppercase;">Ward / Zone</div>
                        <div style="font-weight: 700; color: #0f172a; margin-top: 2px;"><%= complaint.getWardZone() %></div>
                    </div>
                    <div>
                        <div style="font-size: 0.75rem; color: #64748b; font-weight: 700; text-transform: uppercase;">Assigned Department</div>
                        <div style="font-weight: 700; color: #0f172a; margin-top: 2px;">
                            <%= complaint.getDepartmentName() != null ? complaint.getDepartmentName() : "Awaiting Routing" %>
                        </div>
                    </div>
                    <div>
                        <div style="font-size: 0.75rem; color: #64748b; font-weight: 700; text-transform: uppercase;">Lodged Date</div>
                        <div style="font-weight: 700; color: #0f172a; margin-top: 2px;"><%= complaint.getFormattedCreatedAt() %></div>
                    </div>
                </div>

                <!-- Description & Location -->
                <div style="margin-bottom: 1.25rem;">
                    <h4 style="font-size: 1.05rem; color: #0f172a; margin-bottom: 4px;">Subject: <%= complaint.getTitle() %></h4>
                    <p style="color: #475569; font-size: 0.925rem; line-height: 1.6;"><%= complaint.getDescription() %></p>
                </div>

                <div style="margin-bottom: 1.25rem; font-size: 0.88rem; display: flex; align-items: center; gap: 8px;">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
                    <span><strong>Location Landmark:</strong> <span style="color: #475569;"><%= complaint.getLocation() %></span></span>
                </div>

                <% if (complaint.getResolutionNotes() != null && !complaint.getResolutionNotes().trim().isEmpty()) { %>
                    <div style="background: var(--success-light); border: 1px solid var(--success-border); border-radius: 8px; padding: 1.25rem; margin-top: 1rem;">
                        <h4 style="color: #065f46; font-size: 0.95rem; margin-bottom: 4px; display: flex; align-items: center; gap: 8px;">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                            Official Resolution Summary
                        </h4>
                        <p style="color: #047857; font-size: 0.88rem; line-height: 1.6;"><%= complaint.getResolutionNotes() %></p>
                        <div style="font-size: 0.78rem; color: #059669; margin-top: 6px;">
                            Resolution Certified: <%= complaint.getFormattedResolvedAt() %>
                        </div>
                    </div>
                <% } %>
            </div>

            <!-- Audit Trail / Timeline of events -->
            <div class="card" style="margin-bottom: 1.75rem;">
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
                                <div class="timeline-body"><%= log.getRemarks() != null ? log.getRemarks() : "Status updated" %></div>
                                <div class="timeline-by">Action recorded by: <strong><%= log.getPerformedBy() %></strong></div>
                            </div>
                        </div>
                    <%  }
                       } else { %>
                        <p style="color: #64748b; font-size: 0.88rem;">No action logs recorded yet.</p>
                    <% } %>
                </div>
            </div>

            <!-- Citizen Feedback / Rating section -->
            <% if ("RESOLVED".equalsIgnoreCase(complaint.getStatus())) { %>
                <div class="card">
                    <div class="card-header">
                        <div class="card-title">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                            Citizen Satisfaction &amp; Quality Audit
                        </div>
                    </div>

                    <% if (complaint.getCitizenRating() > 0) { %>
                        <div style="background: var(--warning-light); border: 1px solid var(--warning-border); border-radius: 8px; padding: 1.25rem;">
                            <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 6px;">
                                <div class="stars-display">
                                    <% for (int i = 0; i < complaint.getCitizenRating(); i++) { %>
                                        <svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                                    <% } %>
                                    <% for (int i = complaint.getCitizenRating(); i < 5; i++) { %>
                                        <svg class="empty" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                                    <% } %>
                                </div>
                                <span style="font-size: 0.9rem; font-weight: 700; color: #92400e;"><%= complaint.getCitizenRating() %> of 5 Stars</span>
                            </div>
                            <p style="font-size: 0.9rem; color: #78350f;">
                                "<%= complaint.getCitizenFeedback() != null && !complaint.getCitizenFeedback().trim().isEmpty() ? complaint.getCitizenFeedback() : "Citizen confirmed resolution." %>"
                            </p>
                        </div>
                    <% } else { %>
                        <form action="<%= request.getContextPath() %>/submit-feedback" method="POST">
                            <input type="hidden" name="complaintCode" value="<%= complaint.getComplaintCode() %>">

                            <p style="font-size: 0.88rem; color: #475569; margin-bottom: 1rem;">
                                Was this civic issue resolved to your satisfaction? Please rate the repair quality:
                            </p>

                            <div class="form-group">
                                <label class="form-label">Your Satisfaction Rating:</label>
                                <div class="star-rating-box">
                                    <div class="star-rating-input">
                                        <input type="radio" id="star5" name="rating" value="5" checked>
                                        <label for="star5" title="5 Stars"><svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg></label>

                                        <input type="radio" id="star4" name="rating" value="4">
                                        <label for="star4" title="4 Stars"><svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg></label>

                                        <input type="radio" id="star3" name="rating" value="3">
                                        <label for="star3" title="3 Stars"><svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg></label>

                                        <input type="radio" id="star2" name="rating" value="2">
                                        <label for="star2" title="2 Stars"><svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg></label>

                                        <input type="radio" id="star1" name="rating" value="1">
                                        <label for="star1" title="1 Star"><svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg></label>
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="feedback">Citizen Feedback Comments:</label>
                                <textarea name="feedback" id="feedback" class="form-control" rows="3" placeholder="Provide feedback on the speed, workmanship, and cleanliness of the repair..."></textarea>
                            </div>

                            <button type="submit" class="btn btn-primary">
                                Submit Rating &amp; Review
                            </button>
                        </form>
                    <% } %>
                </div>
            <% } %>

        <% } else { %>

            <!-- Empty State -->
            <div class="card" style="text-align: center; padding: 3rem 1.5rem;">
                <div style="width: 56px; height: 56px; border-radius: 50%; background: #eff6ff; color: #1d4ed8; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 1rem;">
                    <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                </div>
                <h3 style="color: #0f172a; margin-bottom: 0.5rem; font-size: 1.25rem;">Track Any City Grievance</h3>
                <p style="color: #64748b; max-width: 480px; margin: 0 auto 1.5rem; font-size: 0.9rem;">
                    Enter your unique complaint tracking number above to see the inspection status and repair timeline.
                </p>
                <div style="display: flex; gap: 8px; justify-content: center; flex-wrap: wrap;">
                    <a href="<%= request.getContextPath() %>/track?code=CC-2026-1001" class="btn btn-secondary btn-sm">Sample 1: Resolved Pothole</a>
                    <a href="<%= request.getContextPath() %>/track?code=CC-2026-1002" class="btn btn-secondary btn-sm">Sample 2: Garbage In Progress</a>
                    <a href="<%= request.getContextPath() %>/track?code=CC-2026-1003" class="btn btn-secondary btn-sm">Sample 3: Streetlight Under Review</a>
                </div>
            </div>

        <% } %>

    </div>
</div>

<jsp:include page="/includes/footer.jsp" />

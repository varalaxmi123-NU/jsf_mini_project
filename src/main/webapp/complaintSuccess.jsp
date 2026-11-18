<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.citycare.dao.ComplaintDAO" %>
<%@ page import="com.citycare.model.Complaint" %>
<%
    String code = request.getParameter("code");
    Complaint complaint = null;
    if (code != null && !code.trim().isEmpty()) {
        ComplaintDAO dao = new ComplaintDAO();
        complaint = dao.getComplaintByCode(code.trim());
    }
%>
<jsp:include page="/includes/header.jsp" />

<div class="container" style="padding: 3rem 1.5rem 4rem;">
    <div style="max-width: 680px; margin: 0 auto; text-align: center;">

        <div style="width: 72px; height: 72px; border-radius: 50%; background: #ecfdf5; color: #059669; display: inline-flex; align-items: center; justify-content: center; margin: 0 auto 1.5rem; box-shadow: 0 4px 12px rgba(5, 150, 105, 0.15);">
            <svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>
        </div>

        <h1 style="font-size: 2.1rem; font-weight: 800; color: #0f172a; margin-bottom: 0.4rem;">
            Complaint Lodged Successfully
        </h1>
        <p style="color: #64748b; font-size: 1rem; margin-bottom: 2rem;">
            Your civic grievance has been officially registered and queued for municipal inspection.
        </p>

        <div class="card" style="text-align: left; padding: 2rem; border-top: 4px solid #1d4ed8; margin-bottom: 2rem;">
            <div style="background: #f8fafc; border: 1px dashed #cbd5e1; border-radius: 8px; padding: 1.25rem; text-align: center; margin-bottom: 1.5rem;">
                <span style="font-size: 0.78rem; color: #64748b; text-transform: uppercase; letter-spacing: 0.05em; font-weight: 700;">Unique Tracking ID</span>
                <div style="font-size: 2.2rem; font-weight: 900; color: #1d4ed8; letter-spacing: -0.02em; margin-top: 2px;">
                    <%= code != null ? code : "CC-2026-N/A" %>
                </div>
                <div style="font-size: 0.8rem; color: #94a3b8; margin-top: 2px;">
                    Retain this ID for online status inquiry and phone verification.
                </div>
            </div>

            <% if (complaint != null) { %>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; font-size: 0.88rem; border-bottom: 1px solid #e2e8f0; padding-bottom: 1rem; margin-bottom: 1.25rem;">
                    <div>
                        <span style="color: #64748b; font-size: 0.75rem; display: block; font-weight: 700; text-transform: uppercase;">Category:</span>
                        <strong><%= complaint.getCategory() %></strong>
                    </div>
                    <div>
                        <span style="color: #64748b; font-size: 0.75rem; display: block; font-weight: 700; text-transform: uppercase;">Urgency:</span>
                        <span class="badge <%= complaint.getPriorityBadgeClass() %>"><%= complaint.getPriority() %></span>
                    </div>
                    <div>
                        <span style="color: #64748b; font-size: 0.75rem; display: block; font-weight: 700; text-transform: uppercase;">Ward / Zone:</span>
                        <strong><%= complaint.getWardZone() %></strong>
                    </div>
                    <div>
                        <span style="color: #64748b; font-size: 0.75rem; display: block; font-weight: 700; text-transform: uppercase;">Current Status:</span>
                        <span class="badge <%= complaint.getStatusBadgeClass() %>"><%= complaint.getStatus() %></span>
                    </div>
                    <div style="grid-column: 1 / -1;">
                        <span style="color: #64748b; font-size: 0.75rem; display: block; font-weight: 700; text-transform: uppercase;">Subject:</span>
                        <strong><%= complaint.getTitle() %></strong>
                    </div>
                    <div style="grid-column: 1 / -1;">
                        <span style="color: #64748b; font-size: 0.75rem; display: block; font-weight: 700; text-transform: uppercase;">Location Landmark:</span>
                        <span><%= complaint.getLocation() %></span>
                    </div>
                </div>
            <% } %>

            <div style="display: flex; gap: 12px; justify-content: center; flex-wrap: wrap;">
                <a href="<%= request.getContextPath() %>/track?code=<%= code %>" class="btn btn-primary">
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                    Track Progress Now
                </a>
                <button type="button" onclick="window.print()" class="btn btn-secondary">
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor"><polyline points="6 9 6 2 18 2 18 9"></polyline><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"></path><rect x="6" y="14" width="12" height="8"></rect></svg>
                    Print Receipt
                </button>
            </div>
        </div>

        <a href="<%= request.getContextPath() %>/lodgeComplaint.jsp" style="font-size: 0.88rem; font-weight: 600; color: #1d4ed8; display: inline-flex; align-items: center; gap: 6px;">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
            Lodge another civic complaint
        </a>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />

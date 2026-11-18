<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<footer>
    <div class="container">
        <div class="footer-inner">
            <div class="footer-col">
                <h4>
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M3 21h18"></path><path d="M5 21V7l8-4v18"></path><path d="M19 21V11l-6-3"></path></svg>
                    CityCare Portal
                </h4>
                <p style="font-size: 0.85rem; line-height: 1.6; margin-bottom: 1rem;">
                    Centralized Smart City civic complaint registration, departmental routing, and SLA compliance monitoring under the Municipal Governance Charter.
                </p>
                <div style="font-size: 0.78rem; color: #94a3b8;">
                    Java Servlets &bull; JSP &bull; JDBC &bull; Apache Tomcat 9 &bull; MySQL
                </div>
            </div>
            <div class="footer-col">
                <h4>
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                    Citizen Redressal
                </h4>
                <ul>
                    <li><a href="<%= request.getContextPath() %>/login">Resident Sign In</a></li>
                    <li><a href="<%= request.getContextPath() %>/register">New Resident Registration</a></li>
                    <li><a href="<%= request.getContextPath() %>/#about">Municipal Redressal Charter</a></li>
                    <li><a href="<%= request.getContextPath() %>/#sectors">Infrastructure Sectors Covered</a></li>
                    <li><a href="<%= request.getContextPath() %>/#workflow">How CityCare Operates</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4>
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                    Authorized Workspaces
                </h4>
                <ul>
                    <li><a href="<%= request.getContextPath() %>/login">Resident Citizen Portal</a></li>
                    <li><a href="<%= request.getContextPath() %>/login">Municipal Engineering Workstation</a></li>
                    <li><a href="<%= request.getContextPath() %>/login">City Administrator Command Console</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4>
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path></svg>
                    Municipal Support
                </h4>
                <ul>
                    <li style="display: flex; align-items: center; gap: 8px; color: #cbd5e1; font-size: 0.85rem;">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path></svg>
                        <span>Toll Free: 1800-CITY-CARE</span>
                    </li>
                    <li style="display: flex; align-items: center; gap: 8px; color: #cbd5e1; font-size: 0.85rem;">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path><polyline points="22,6 12,13 2,6"></polyline></svg>
                        <span>support@citycare.gov.in</span>
                    </li>
                    <li style="display: flex; align-items: center; gap: 8px; color: #cbd5e1; font-size: 0.85rem;">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
                        <span>Municipal Corporation Central HQ</span>
                    </li>
                </ul>
            </div>
        </div>

        <div class="footer-bottom">
            <p>&copy; 2026 CityCare Smart City Governance. All rights reserved. Developed with Java Servlets, JSP, JDBC and Apache Tomcat 9.</p>
        </div>
    </div>
</footer>

<script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>

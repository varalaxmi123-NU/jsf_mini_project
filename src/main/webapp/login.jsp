<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String error = (String) request.getAttribute("errorMessage");
    String loggedOut = request.getParameter("loggedOut");
    String registered = request.getParameter("registered");
    String username = (String) request.getAttribute("username");
%>
<jsp:include page="/includes/header.jsp" />

<div class="container" style="padding: 4.5rem 1.5rem 6rem;">
    <div style="max-width: 440px; margin: 0 auto;">

        <div style="text-align: center; margin-bottom: 2rem;">
            <div style="width: 52px; height: 52px; background: #1d4ed8; border-radius: 12px; display: inline-flex; align-items: center; justify-content: center; color: #ffffff; margin-bottom: 1rem; box-shadow: 0 4px 12px rgba(29, 78, 216, 0.25);">
                <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
            </div>
            <h1 style="font-size: 1.85rem; font-weight: 800; color: #0f172a; letter-spacing: -0.025em;">Sign In to CityCare</h1>
            <p style="color: #64748b; font-size: 0.92rem;">Access for Resident Citizens, Field Officers &amp; Admins</p>
        </div>

        <% if (error != null) { %>
            <div class="alert alert-danger" style="margin-bottom: 1.25rem;">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                <%= error %>
            </div>
        <% } %>

        <% if ("true".equalsIgnoreCase(registered)) { %>
            <div class="alert alert-success" style="margin-bottom: 1.25rem;">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                Account created successfully! Please sign in with your credentials.
            </div>
        <% } %>

        <% if ("true".equalsIgnoreCase(loggedOut)) { %>
            <div class="alert alert-info" style="margin-bottom: 1.25rem;">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>
                You have been safely signed out.
            </div>
        <% } %>

        <div class="card" style="padding: 2.25rem; border-radius: 16px; border: 1px solid #e2e8f0; background: #ffffff; box-shadow: 0 10px 25px -5px rgba(15, 23, 42, 0.08), 0 8px 10px -6px rgba(15, 23, 42, 0.03);">
            <form action="<%= request.getContextPath() %>/login" method="POST" id="loginForm">
                <div class="form-group" style="margin-bottom: 1.25rem;">
                    <label class="form-label" for="username" style="font-weight: 600; color: #0f172a; font-size: 0.88rem;">Username or Official ID</label>
                    <div style="position: relative;">
                        <div style="position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: #94a3b8; pointer-events: none;">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                        </div>
                        <input type="text" name="username" id="username" class="form-control" placeholder="Enter username" value="<%= username != null ? username : "" %>" style="height: 44px; font-size: 0.95rem; padding-left: 42px; border-color: #cbd5e1; background: #ffffff;" required autofocus>
                    </div>
                </div>

                <div class="form-group" style="margin-bottom: 1.5rem;">
                    <label class="form-label" for="password" style="font-weight: 600; color: #0f172a; font-size: 0.88rem;">Password</label>
                    <div style="position: relative;">
                        <div style="position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: #94a3b8; pointer-events: none;">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                        </div>
                        <input type="password" name="password" id="password" class="form-control" placeholder="Enter password" style="height: 44px; font-size: 0.95rem; padding-left: 42px; border-color: #cbd5e1; background: #ffffff;" required>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary btn-block" style="height: 46px; font-size: 0.95rem; font-weight: 700; border-radius: 8px;">
                    Sign In to Portal
                </button>
            </form>

            <div style="text-align: center; margin-top: 1.5rem; padding-top: 1.25rem; border-top: 1px solid #f1f5f9;">
                <span style="font-size: 0.86rem; color: #64748b;">New resident citizen?</span>
                <a href="<%= request.getContextPath() %>/register" style="font-weight: 700; color: #1d4ed8; margin-left: 6px; font-size: 0.86rem;">Register Here &rarr;</a>
            </div>
        </div>

        <div style="text-align: center; margin-top: 1.5rem;">
            <a href="<%= request.getContextPath() %>/" style="font-size: 0.875rem; color: #64748b; display: inline-flex; align-items: center; gap: 6px; font-weight: 600;">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="15 18 9 12 15 6"></polyline></svg>
                Back to Public Overview
            </a>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />

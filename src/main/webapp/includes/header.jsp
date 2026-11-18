<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.citycare.model.User" %>
<%
    User sessionUser = (User) session.getAttribute("currentUser");
    String currentUri = request.getRequestURI();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CityCare - Smart City Civic Complaint Management System</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

<!-- Clean Modern Navbar -->
<header class="navbar">
    <div class="container nav-inner">
        <!-- Brand Crest & Title -->
        <a href="<%= request.getContextPath() %>/" class="navbar-brand">
            <div class="brand-crest">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M3 21h18"></path>
                    <path d="M5 21V7l8-4v18"></path>
                    <path d="M19 21V11l-6-3"></path>
                    <path d="M9 9v.01"></path>
                    <path d="M9 13v.01"></path>
                    <path d="M9 17v.01"></path>
                </svg>
            </div>
            <div class="brand-text-lockup">
                <span class="brand-title">City<span class="brand-accent">Care</span></span>
                <span class="brand-sep"></span>
                <span class="brand-sub">Smart City Portal</span>
            </div>
        </a>

        <!-- Central Navigation Links -->
        <ul class="nav-links">
            <% if (sessionUser == null) { %>
                <li>
                    <a href="<%= request.getContextPath() %>/" class="nav-item <%= currentUri.endsWith("/") || currentUri.endsWith("index.jsp") ? "active" : "" %>">
                        <span class="nav-icon"><svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path><polyline points="9 22 9 12 15 12 15 22"></polyline></svg></span>
                        <span>Home</span>
                    </a>
                </li>
                <li>
                    <a href="<%= request.getContextPath() %>/#sectors" class="nav-item">
                        <span class="nav-icon"><svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"><line x1="4" y1="21" x2="4" y2="3"></line><line x1="20" y1="21" x2="20" y2="3"></line><line x1="12" y1="19" x2="12" y2="15"></line></svg></span>
                        <span>Municipal Services</span>
                    </a>
                </li>
                <li>
                    <a href="<%= request.getContextPath() %>/#workflow" class="nav-item">
                        <span class="nav-icon"><svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline></svg></span>
                        <span>How It Works</span>
                    </a>
                </li>
                <li>
                    <a href="<%= request.getContextPath() %>/#about" class="nav-item">
                        <span class="nav-icon"><svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg></span>
                        <span>About</span>
                    </a>
                </li>
                <li>
                    <a href="<%= request.getContextPath() %>/#helplines" class="nav-item">
                        <span class="nav-icon"><svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path></svg></span>
                        <span>Helplines</span>
                    </a>
                </li>
            <% } else { %>
                <% if ("ADMIN".equalsIgnoreCase(sessionUser.getRole())) { %>
                    <li>
                        <a href="<%= request.getContextPath() %>/admin/dashboard" class="nav-item <%= currentUri.contains("admin") ? "active" : "" %>">
                            <span class="nav-icon"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg></span>
                            <span>Admin Console</span>
                        </a>
                    </li>
                <% } else if ("OFFICER".equalsIgnoreCase(sessionUser.getRole())) { %>
                    <li>
                        <a href="<%= request.getContextPath() %>/officer/dashboard" class="nav-item <%= currentUri.contains("officer") ? "active" : "" %>">
                            <span class="nav-icon"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg></span>
                            <span>Officer Workspace</span>
                        </a>
                    </li>
                <% } else { %>
                    <li>
                        <a href="<%= request.getContextPath() %>/citizen/dashboard" class="nav-item <%= currentUri.contains("citizen") ? "active" : "" %>">
                            <span class="nav-icon"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg></span>
                            <span>My Dashboard</span>
                        </a>
                    </li>
                    <li>
                        <a href="<%= request.getContextPath() %>/lodgeComplaint.jsp" class="nav-item <%= currentUri.contains("lodgeComplaint") ? "active" : "" %>">
                            <span class="nav-icon"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg></span>
                            <span>File Complaint</span>
                        </a>
                    </li>
                    <li>
                        <a href="<%= request.getContextPath() %>/track" class="nav-item <%= currentUri.contains("track") ? "active" : "" %>">
                            <span class="nav-icon"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg></span>
                            <span>Track Status</span>
                        </a>
                    </li>
                <% } %>
            <% } %>
        </ul>

        <!-- Action / Auth Hub -->
        <div class="nav-auth">
            <% if (sessionUser != null) { %>
                <div class="user-pill-civic">
                    <div class="user-avatar-dot">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                    </div>
                    <span class="user-pill-name"><%= sessionUser.getFullName() %></span>
                    <span class="user-role-badge <%= "ADMIN".equalsIgnoreCase(sessionUser.getRole()) ? "role-admin" : ("OFFICER".equalsIgnoreCase(sessionUser.getRole()) ? "role-officer" : "role-citizen") %>">
                        <%= sessionUser.getRole() %>
                    </span>
                </div>
                <a href="<%= request.getContextPath() %>/logout" class="btn btn-signout">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" y1="12" x2="9" y2="12"></line></svg>
                    <span>Sign Out</span>
                </a>
            <% } else { %>
                <a href="<%= request.getContextPath() %>/login" class="btn btn-nav-signin">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                    <span>Sign In</span>
                </a>
                <a href="<%= request.getContextPath() %>/register" class="btn btn-nav-register">
                    <span>Register</span>
                </a>
            <% } %>
        </div>
    </div>
</header>

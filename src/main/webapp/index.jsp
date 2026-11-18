<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.citycare.model.User" %>
<%
    User sessionUser = (User) session.getAttribute("currentUser");
%>
<jsp:include page="/includes/header.jsp" />

<!-- Hero Section with Crisp Modern Architecture -->
<section class="hero-clean">
    <div class="container">
        <div style="display: grid; grid-template-columns: 1.2fr 1fr; gap: 3.5rem; align-items: center;">
            
            <!-- Left Column: Purpose & Value Proposition -->
            <div>
                <h1 style="font-size: 2.85rem; font-weight: 800; line-height: 1.15; margin-bottom: 1.25rem; letter-spacing: -0.03em; color: #0f172a;">
                    Fixing our city, <br><span style="color: #1d4ed8;">one report at a time.</span>
                </h1>

                <p style="font-size: 1.1rem; color: #475569; line-height: 1.65; margin-bottom: 2rem; max-width: 560px;">
                    An official municipal platform connecting residents directly to zonal municipal engineers for potholes, waste clearance, streetlights, and water leaks under guaranteed SLA timelines.
                </p>

                <!-- Action CTAs -->
                <div style="display: flex; gap: 0.85rem; flex-wrap: wrap; margin-bottom: 2.5rem;">
                    <% if (sessionUser == null) { %>
                        <a href="<%= request.getContextPath() %>/login" class="btn btn-primary" style="padding: 12px 24px; font-size: 0.95rem; font-weight: 700; border-radius: 10px;">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                            Sign In to Lodge Complaint &rarr;
                        </a>
                        <a href="#sectors" class="btn btn-secondary" style="padding: 12px 20px; font-size: 0.95rem; font-weight: 600; border-radius: 10px;">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="4" y1="21" x2="4" y2="3"></line><line x1="20" y1="21" x2="20" y2="3"></line><line x1="12" y1="19" x2="12" y2="15"></line></svg>
                            Explore Services
                        </a>
                    <% } else { %>
                        <a href="<%= request.getContextPath() %>/<%= sessionUser.getRole().toLowerCase() %>/dashboard" class="btn btn-primary" style="padding: 12px 24px; font-size: 0.95rem; font-weight: 700; border-radius: 10px;">
                            Open <%= sessionUser.getRole() %> Workspace &rarr;
                        </a>
                    <% } %>
                </div>

                <!-- Common Civic Services Chips -->
                <div>
                    <div style="font-size: 0.75rem; font-weight: 700; color: #64748b; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 0.75rem;">
                        Core Municipal Divisions Covered
                    </div>
                    <div style="display: flex; flex-wrap: wrap; gap: 8px;">
                        <a href="#sectors" class="category-chip">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#dc2626" stroke-width="2"><line x1="4" y1="21" x2="4" y2="3"></line><line x1="20" y1="21" x2="20" y2="3"></line><line x1="12" y1="19" x2="12" y2="15"></line></svg>
                            <span>Roads &amp; Potholes</span>
                        </a>
                        <a href="#sectors" class="category-chip">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#d97706" stroke-width="2"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"></path></svg>
                            <span>Waste &amp; Sanitation</span>
                        </a>
                        <a href="#sectors" class="category-chip">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#ca8a04" stroke-width="2"><line x1="9" y1="18" x2="15" y2="18"></line><path d="M15.09 14c.18-.98.65-1.74 1.41-2.5A4.65 4.65 0 0 0 18 8 6 6 0 0 0 6 8c0 1 .23 2.23 1.5 3.5A4.61 4.61 0 0 1 8.91 14"></path></svg>
                            <span>Streetlights</span>
                        </a>
                        <a href="#sectors" class="category-chip">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2"><path d="M12 2.69l5.66 5.66a8 8 0 1 1-11.31 0z"></path></svg>
                            <span>Water Leaks</span>
                        </a>
                        <a href="#sectors" class="category-chip">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#16a34a" stroke-width="2"><path d="M12 2L8 6h3v6h2V6h3L12 2z"></path></svg>
                            <span>Parks &amp; Trees</span>
                        </a>
                    </div>
                </div>

            </div>

            <!-- Right Column: Clean Portal Sign In Card / Active Session -->
            <div>
                <% if (sessionUser == null) { %>
                    <div class="login-clean-card">
                        <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 1.5rem; padding-bottom: 1.15rem; border-bottom: 1px solid #f1f5f9;">
                            <div>
                                <h3 style="font-size: 1.3rem; font-weight: 800; color: #0f172a; margin-bottom: 2px;">
                                    Sign In to Portal
                                </h3>
                                <p style="font-size: 0.84rem; color: #64748b; margin: 0;">Access for Citizens, Officers &amp; Admins</p>
                            </div>
                            <div style="width: 40px; height: 40px; border-radius: 10px; background: #eff6ff; color: #1d4ed8; display: flex; align-items: center; justify-content: center;">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                            </div>
                        </div>

                        <form action="<%= request.getContextPath() %>/login" method="POST">
                            <div class="form-group" style="margin-bottom: 1.15rem;">
                                <label class="form-label" for="username" style="font-size: 0.85rem; font-weight: 600; color: #0f172a;">
                                    Username or Official ID
                                </label>
                                <div style="position: relative;">
                                    <div style="position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: #94a3b8; pointer-events: none;">
                                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                                    </div>
                                    <input type="text" name="username" id="username" class="form-control" placeholder="Enter username" style="height: 44px; font-size: 0.95rem; padding-left: 42px; border-color: #cbd5e1; background: #ffffff;" required>
                                </div>
                            </div>

                            <div class="form-group" style="margin-bottom: 1.5rem;">
                                <label class="form-label" for="password" style="font-size: 0.85rem; font-weight: 600; color: #0f172a;">
                                    Password
                                </label>
                                <div style="position: relative;">
                                    <div style="position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: #94a3b8; pointer-events: none;">
                                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                                    </div>
                                    <input type="password" name="password" id="password" class="form-control" placeholder="Enter password" style="height: 44px; font-size: 0.95rem; padding-left: 42px; border-color: #cbd5e1; background: #ffffff;" required>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-primary btn-block" style="height: 46px; font-size: 0.95rem; font-weight: 700; border-radius: 8px;">
                                Sign In &amp; Open Workspace
                            </button>
                        </form>

                        <div style="margin-top: 1.5rem; padding-top: 1.15rem; border-top: 1px solid #f1f5f9; text-align: center;">
                            <span style="font-size: 0.85rem; color: #64748b;">New resident citizen?</span>
                            <a href="<%= request.getContextPath() %>/register" style="font-weight: 700; color: #1d4ed8; margin-left: 6px; font-size: 0.85rem;">
                                Register Account &rarr;
                            </a>
                        </div>
                    </div>
                <% } else { %>
                    <!-- Authenticated Session Console Card -->
                    <div class="login-clean-card" style="text-align: center;">
                        <div style="width: 56px; height: 56px; border-radius: 50%; background: #ecfdf5; color: #059669; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 1rem; border: 1px solid #a7f3d0;">
                            <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                        </div>
                        <h3 style="font-size: 1.35rem; font-weight: 800; color: #0f172a; margin-bottom: 4px;">
                            Active Session Authenticated
                        </h3>
                        <p style="font-size: 0.92rem; color: #64748b; margin-bottom: 1.5rem;">
                            Signed in as <strong><%= sessionUser.getFullName() %></strong> (<%= sessionUser.getRole() %>)
                        </p>

                        <% if ("ADMIN".equalsIgnoreCase(sessionUser.getRole())) { %>
                            <a href="<%= request.getContextPath() %>/admin/dashboard" class="btn btn-primary btn-block" style="height: 46px; font-size: 0.95rem; font-weight: 700; margin-bottom: 10px; border-radius: 8px;">
                                Enter Administrator Console &rarr;
                            </a>
                        <% } else if ("OFFICER".equalsIgnoreCase(sessionUser.getRole())) { %>
                            <a href="<%= request.getContextPath() %>/officer/dashboard" class="btn btn-primary btn-block" style="height: 46px; font-size: 0.95rem; font-weight: 700; margin-bottom: 10px; border-radius: 8px;">
                                Enter Municipal Officer Workspace &rarr;
                            </a>
                        <% } else { %>
                            <a href="<%= request.getContextPath() %>/citizen/dashboard" class="btn btn-primary btn-block" style="height: 46px; font-size: 0.95rem; font-weight: 700; margin-bottom: 10px; border-radius: 8px;">
                                Enter Citizen Dashboard &rarr;
                            </a>
                        <% } %>

                        <a href="<%= request.getContextPath() %>/logout" class="btn btn-secondary btn-block" style="border-radius: 8px;">
                            Sign Out
                        </a>
                    </div>
                <% } %>
            </div>

        </div>
    </div>
</section>

<!-- Municipal Key Performance Metrics Bar -->
<section style="padding: 2.5rem 0; background: #f8fafc; border-bottom: 1px solid #e2e8f0;">
    <div class="container">
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 1.25rem;">
            
            <div class="card" style="padding: 1.4rem; border-top: 3px solid #1d4ed8; text-align: center; border-radius: 12px; background: #ffffff;">
                <div style="font-size: 1.85rem; font-weight: 800; color: #0f172a;">6 Divisions</div>
                <div style="font-size: 0.82rem; color: #64748b; font-weight: 600; margin-top: 3px;">Infrastructure Coverage</div>
            </div>

            <div class="card" style="padding: 1.4rem; border-top: 3px solid #059669; text-align: center; border-radius: 12px; background: #ffffff;">
                <div style="font-size: 1.85rem; font-weight: 800; color: #0f172a;">24&ndash;48 Hours</div>
                <div style="font-size: 0.82rem; color: #64748b; font-weight: 600; margin-top: 3px;">Guaranteed Resolution SLA</div>
            </div>

            <div class="card" style="padding: 1.4rem; border-top: 3px solid #ca8a04; text-align: center; border-radius: 12px; background: #ffffff;">
                <div style="font-size: 1.85rem; font-weight: 800; color: #0f172a;">100% Geotagged</div>
                <div style="font-size: 0.82rem; color: #64748b; font-weight: 600; margin-top: 3px;">GPS Verified Field Audits</div>
            </div>

            <div class="card" style="padding: 1.4rem; border-top: 3px solid #0284c7; text-align: center; border-radius: 12px; background: #ffffff;">
                <div style="font-size: 1.85rem; font-weight: 800; color: #0f172a;">24x7 Active</div>
                <div style="font-size: 0.82rem; color: #64748b; font-weight: 600; margin-top: 3px;">Emergency Control Room</div>
            </div>

        </div>
    </div>
</section>

<!-- Municipal Sectors Covered Section -->
<section id="sectors" style="padding: 4.5rem 0; background: #ffffff; border-bottom: 1px solid #e2e8f0;">
    <div class="container">
        <div style="text-align: center; max-width: 650px; margin: 0 auto 3.25rem;">
            <div style="font-size: 0.78rem; font-weight: 700; color: #1d4ed8; text-transform: uppercase; letter-spacing: 0.06em; margin-bottom: 6px;">
                Municipal Infrastructure Coverage
            </div>
            <h2 style="font-size: 2.1rem; font-weight: 800; color: #0f172a; margin-bottom: 0.5rem; letter-spacing: -0.025em;">
                Services &amp; Engineering Divisions
            </h2>
            <p style="color: #64748b; font-size: 0.95rem;">
                Round-the-clock incident management and repair dispatch across metropolitan sectors.
            </p>
        </div>

        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 1.5rem;">
            
            <div class="card" style="padding: 1.6rem; border-radius: 14px; background: #ffffff;">
                <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 1rem;">
                    <div style="width: 44px; height: 44px; border-radius: 10px; background: #fef2f2; color: #dc2626; display: flex; align-items: center; justify-content: center;">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="4" y1="21" x2="4" y2="3"></line><line x1="20" y1="21" x2="20" y2="3"></line><line x1="12" y1="19" x2="12" y2="15"></line></svg>
                    </div>
                    <span style="font-size: 0.75rem; color: #dc2626; font-weight: 700; background: #fef2f2; padding: 3px 10px; border-radius: 9999px;">SLA: 48h</span>
                </div>
                <h4 style="font-size: 1.05rem; font-weight: 700; color: #0f172a; margin-bottom: 0.4rem;">Roads &amp; Civil Infrastructure</h4>
                <p style="font-size: 0.88rem; color: #64748b; line-height: 1.6;">
                    Pothole compaction, asphalt resurfacing with VG-30 Bitumen grade, and sidewalk curb repairs.
                </p>
            </div>

            <div class="card" style="padding: 1.6rem; border-radius: 14px; background: #ffffff;">
                <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 1rem;">
                    <div style="width: 44px; height: 44px; border-radius: 10px; background: #fffbeb; color: #d97706; display: flex; align-items: center; justify-content: center;">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"></path></svg>
                    </div>
                    <span style="font-size: 0.75rem; color: #d97706; font-weight: 700; background: #fffbeb; padding: 3px 10px; border-radius: 9999px;">SLA: 24h</span>
                </div>
                <h4 style="font-size: 1.05rem; font-weight: 700; color: #0f172a; margin-bottom: 0.4rem;">Solid Waste &amp; Sanitation</h4>
                <p style="font-size: 0.88rem; color: #64748b; line-height: 1.6;">
                    Clearing overflowing community waste bins, compactor truck dispatch, and street cleanliness.
                </p>
            </div>

            <div class="card" style="padding: 1.6rem; border-radius: 14px; background: #ffffff;">
                <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 1rem;">
                    <div style="width: 44px; height: 44px; border-radius: 10px; background: #fefce8; color: #ca8a04; display: flex; align-items: center; justify-content: center;">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="9" y1="18" x2="15" y2="18"></line><path d="M15.09 14c.18-.98.65-1.74 1.41-2.5A4.65 4.65 0 0 0 18 8 6 6 0 0 0 6 8c0 1 .23 2.23 1.5 3.5A4.61 4.61 0 0 1 8.91 14"></path></svg>
                    </div>
                    <span style="font-size: 0.75rem; color: #ca8a04; font-weight: 700; background: #fefce8; padding: 3px 10px; border-radius: 9999px;">SLA: 48h</span>
                </div>
                <h4 style="font-size: 1.05rem; font-weight: 700; color: #0f172a; margin-bottom: 0.4rem;">Electrical &amp; Street Lighting</h4>
                <p style="font-size: 0.88rem; color: #64748b; line-height: 1.6;">
                    Restoration of unlit road corridors, LED fixtures replacement, and pole surge protector repairs.
                </p>
            </div>

            <div class="card" style="padding: 1.6rem; border-radius: 14px; background: #ffffff;">
                <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 1rem;">
                    <div style="width: 44px; height: 44px; border-radius: 10px; background: #f0f9ff; color: #0284c7; display: flex; align-items: center; justify-content: center;">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2.69l5.66 5.66a8 8 0 1 1-11.31 0z"></path></svg>
                    </div>
                    <span style="font-size: 0.75rem; color: #0284c7; font-weight: 700; background: #f0f9ff; padding: 3px 10px; border-radius: 9999px;">SLA: 24h</span>
                </div>
                <h4 style="font-size: 1.05rem; font-weight: 700; color: #0f172a; margin-bottom: 0.4rem;">Water Supply &amp; Pipelines</h4>
                <p style="font-size: 0.88rem; color: #64748b; line-height: 1.6;">
                    Repair of ruptured potable water mains, leakage containment, and pressure valve maintenance.
                </p>
            </div>

            <div class="card" style="padding: 1.6rem; border-radius: 14px; background: #ffffff;">
                <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 1rem;">
                    <div style="width: 44px; height: 44px; border-radius: 10px; background: #f0fdf4; color: #16a34a; display: flex; align-items: center; justify-content: center;">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2L8 6h3v6h2V6h3L12 2z"></path></svg>
                    </div>
                    <span style="font-size: 0.75rem; color: #16a34a; font-weight: 700; background: #f0fdf4; padding: 3px 10px; border-radius: 9999px;">SLA: 24h</span>
                </div>
                <h4 style="font-size: 1.05rem; font-weight: 700; color: #0f172a; margin-bottom: 0.4rem;">Urban Forestry &amp; Parks</h4>
                <p style="font-size: 0.88rem; color: #64748b; line-height: 1.6;">
                    Clearing fallen branches obstructing roadways using hydraulic cranes and park upkeep.
                </p>
            </div>

            <div class="card" style="padding: 1.6rem; border-radius: 14px; background: #ffffff;">
                <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 1rem;">
                    <div style="width: 44px; height: 44px; border-radius: 10px; background: #eef2ff; color: #4f46e5; display: flex; align-items: center; justify-content: center;">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="23 18 13.5 8.5 8.5 13.5 1 6"></polyline><polyline points="17 18 23 18 23 12"></polyline></svg>
                    </div>
                    <span style="font-size: 0.75rem; color: #4f46e5; font-weight: 700; background: #eef2ff; padding: 3px 10px; border-radius: 9999px;">SLA: 24h</span>
                </div>
                <h4 style="font-size: 1.05rem; font-weight: 700; color: #0f172a; margin-bottom: 0.4rem;">Stormwater &amp; Drainage</h4>
                <p style="font-size: 0.88rem; color: #64748b; line-height: 1.6;">
                    Pre-monsoon culvert desilting, drain wall restructuring, and choke clearance to mitigate flooding.
                </p>
            </div>

        </div>
    </div>
</section>

<!-- How CityCare Works (3-Step Pipeline) -->
<section id="workflow" style="padding: 4.5rem 0; background: #f8fafc; border-bottom: 1px solid #e2e8f0;">
    <div class="container">
        <div style="text-align: center; max-width: 650px; margin: 0 auto 3.25rem;">
            <div style="font-size: 0.78rem; font-weight: 700; color: #1d4ed8; text-transform: uppercase; letter-spacing: 0.06em; margin-bottom: 6px;">
                End-to-End Workflow
            </div>
            <h2 style="font-size: 2.1rem; font-weight: 800; color: #0f172a; margin-bottom: 0.5rem; letter-spacing: -0.025em;">
                How Redressal Works
            </h2>
            <p style="color: #64748b; font-size: 0.95rem;">
                A transparent, digital pipeline connecting citizens to responsible municipal engineers.
            </p>
        </div>

        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 1.75rem;">
            
            <div class="card" style="padding: 2.25rem 2rem; border-radius: 14px; background: #ffffff;">
                <div style="width: 44px; height: 44px; border-radius: 10px; background: #eff6ff; color: #1d4ed8; font-size: 1.15rem; font-weight: 800; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 1.25rem;">
                    01
                </div>
                <h4 style="font-size: 1.15rem; font-weight: 700; color: #0f172a; margin-bottom: 0.5rem;">Citizen Lodges Issue</h4>
                <p style="font-size: 0.88rem; color: #64748b; line-height: 1.6;">
                    Citizen signs in, selects civic sector, pins location coordinates, and receives an official tracking code.
                </p>
            </div>

            <div class="card" style="padding: 2.25rem 2rem; border-radius: 14px; background: #ffffff;">
                <div style="width: 44px; height: 44px; border-radius: 10px; background: #eff6ff; color: #1d4ed8; font-size: 1.15rem; font-weight: 800; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 1.25rem;">
                    02
                </div>
                <h4 style="font-size: 1.15rem; font-weight: 700; color: #0f172a; margin-bottom: 0.5rem;">Zonal Crew Dispatch</h4>
                <p style="font-size: 0.88rem; color: #64748b; line-height: 1.6;">
                    The responsible department officer reviews the ticket, deploys field contractors, and transitions status.
                </p>
            </div>

            <div class="card" style="padding: 2.25rem 2rem; border-radius: 14px; background: #ffffff;">
                <div style="width: 44px; height: 44px; border-radius: 10px; background: #ecfdf5; color: #059669; font-size: 1.15rem; font-weight: 800; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 1.25rem;">
                    03
                </div>
                <h4 style="font-size: 1.15rem; font-weight: 700; color: #0f172a; margin-bottom: 0.5rem;">Verified Resolution</h4>
                <p style="font-size: 0.88rem; color: #64748b; line-height: 1.6;">
                    Repairs are certified with material logs, and the citizen provides their official satisfaction rating.
                </p>
            </div>

        </div>
    </div>
</section>

<!-- About Governance Section -->
<section id="about" style="padding: 4.5rem 0; background: #ffffff; border-bottom: 1px solid #e2e8f0;">
    <div class="container">
        <div style="text-align: center; max-width: 650px; margin: 0 auto 3rem;">
            <div style="font-size: 0.78rem; font-weight: 700; color: #1d4ed8; text-transform: uppercase; letter-spacing: 0.06em; margin-bottom: 6px;">
                Municipal Charter &bull; Smart City Mission
            </div>
            <h2 style="font-size: 2.1rem; font-weight: 800; color: #0f172a; margin-bottom: 0.5rem; letter-spacing: -0.025em;">
                About CityCare Governance
            </h2>
            <p style="color: #64748b; font-size: 0.95rem;">
                Replacing manual complaint registers with transparent, time-bound municipal accountability.
            </p>
        </div>

        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 1.5rem;">
            <div class="card" style="padding: 1.6rem; border-radius: 12px; background: #f8fafc;">
                <h4 style="font-size: 1.05rem; font-weight: 700; color: #0f172a; margin-bottom: 0.5rem;">1. Instant Ingestion</h4>
                <p style="font-size: 0.88rem; color: #64748b; line-height: 1.6;">Digital reporting with GPS coordinates, landmarks, and photos for pinpoint accuracy.</p>
            </div>
            <div class="card" style="padding: 1.6rem; border-radius: 12px; background: #f8fafc;">
                <h4 style="font-size: 1.05rem; font-weight: 700; color: #0f172a; margin-bottom: 0.5rem;">2. Automated Triage</h4>
                <p style="font-size: 0.88rem; color: #64748b; line-height: 1.6;">Direct jurisdictional routing to the responsible zonal engineering division.</p>
            </div>
            <div class="card" style="padding: 1.6rem; border-radius: 12px; background: #f8fafc;">
                <h4 style="font-size: 1.05rem; font-weight: 700; color: #0f172a; margin-bottom: 0.5rem;">3. Engineering Logs</h4>
                <p style="font-size: 0.88rem; color: #64748b; line-height: 1.6;">Transparent tracking of deployed contractors, materials, and repair hours.</p>
            </div>
            <div class="card" style="padding: 1.6rem; border-radius: 12px; background: #f8fafc;">
                <h4 style="font-size: 1.05rem; font-weight: 700; color: #0f172a; margin-bottom: 0.5rem;">4. Citizen Rating</h4>
                <p style="font-size: 0.88rem; color: #64748b; line-height: 1.6;">Direct resident verification and satisfaction audits on every closed ticket.</p>
            </div>
        </div>
    </div>
</section>

<!-- Civic Helplines & Emergency Section -->
<section id="helplines" style="padding: 3.5rem 0 4rem; background: #f8fafc;">
    <div class="container">
        <div style="background: #ffffff; border: 1px solid #e2e8f0; border-left: 4px solid #ef4444; border-radius: 14px; padding: 2.25rem; display: grid; grid-template-columns: 1.2fr 1fr; gap: 2rem; align-items: center; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.04);">
            <div>
                <div style="display: inline-flex; align-items: center; gap: 6px; font-size: 0.75rem; font-weight: 700; color: #dc2626; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 6px;">
                    <span style="width: 7px; height: 7px; border-radius: 50%; background: #dc2626;"></span>
                    24x7 Emergency Dispatch
                </div>
                <h3 style="font-size: 1.5rem; font-weight: 800; color: #0f172a; margin-bottom: 0.4rem; letter-spacing: -0.02em;">
                    Immediate Civic Assistance
                </h3>
                <p style="color: #64748b; font-size: 0.92rem; line-height: 1.6; margin: 0;">
                    For active road cave-ins, burst high-pressure water mains, or fallen live electrical wires, contact our rapid municipal control room immediately.
                </p>
            </div>

            <div style="display: flex; flex-direction: column; gap: 0.75rem;">
                <a href="tel:18002489227" style="display: flex; align-items: center; gap: 14px; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 10px; padding: 12px 18px; text-decoration: none; transition: all 0.15s ease;">
                    <div style="width: 40px; height: 40px; border-radius: 8px; background: #eff6ff; color: #1d4ed8; display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path></svg>
                    </div>
                    <div>
                        <div style="font-size: 0.72rem; color: #64748b; text-transform: uppercase; font-weight: 700; letter-spacing: 0.04em;">Toll-Free Control Room</div>
                        <div style="font-size: 1.15rem; font-weight: 800; color: #0f172a;">1800-CITY-CARE (1800-248-9227)</div>
                    </div>
                </a>

                <a href="mailto:support@citycare.gov.in" style="display: flex; align-items: center; gap: 14px; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 10px; padding: 12px 18px; text-decoration: none; transition: all 0.15s ease;">
                    <div style="width: 40px; height: 40px; border-radius: 8px; background: #ecfdf5; color: #059669; display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path><polyline points="22,6 12,13 2,6"></polyline></svg>
                    </div>
                    <div>
                        <div style="font-size: 0.72rem; color: #64748b; text-transform: uppercase; font-weight: 700; letter-spacing: 0.04em;">Email Grievance Cell</div>
                        <div style="font-size: 1.05rem; font-weight: 700; color: #0f172a;">support@citycare.gov.in</div>
                    </div>
                </a>
            </div>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />

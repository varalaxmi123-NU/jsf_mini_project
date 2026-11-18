<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.citycare.dao.DepartmentDAO" %>
<%@ page import="com.citycare.model.Department" %>
<%@ page import="com.citycare.model.User" %>
<%@ page import="java.util.List" %>
<%
    User sessionUser = (User) session.getAttribute("currentUser");
    if (sessionUser == null) {
        response.sendRedirect(request.getContextPath() + "/login?error=" + java.net.URLEncoder.encode("Please sign in to lodge a civic grievance.", "UTF-8"));
        return;
    }
    DepartmentDAO departmentDAO = new DepartmentDAO();
    List<Department> departments = departmentDAO.getAllDepartments();
    String preCategory = request.getParameter("cat");
    if (preCategory == null) preCategory = "";
%>
<jsp:include page="/includes/header.jsp" />

<div class="container" style="padding-top: 2.5rem; padding-bottom: 3.5rem;">
    <div style="max-width: 860px; margin: 0 auto;">

        <div style="margin-bottom: 1.5rem;">
            <a href="<%= sessionUser != null ? request.getContextPath() + "/citizen/dashboard" : request.getContextPath() + "/" %>" style="display: inline-flex; align-items: center; gap: 6px; font-size: 0.85rem; color: #64748b; margin-bottom: 0.75rem;">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"><polyline points="15 18 9 12 15 6"></polyline></svg>
                Back to Dashboard
            </a>
            <h1 style="font-size: 2rem; font-weight: 800; color: #0f172a;">Lodge Official Civic Grievance</h1>
            <p style="color: #64748b; margin-top: 4px; font-size: 0.95rem;">
                Official registration for potholes, garbage overflow, streetlights, or water pipeline leakage directly into the Municipal Dispatch Ledger.
            </p>
        </div>

        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-danger">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>

        <div class="card" id="complaintFormCard">
            <form action="<%= request.getContextPath() %>/submit-complaint" method="POST" onsubmit="return validateComplaintForm();">
                
                <h3 style="font-size: 1.05rem; color: #1d4ed8; border-bottom: 1px solid #e2e8f0; padding-bottom: 8px; margin-bottom: 1.25rem; display: flex; align-items: center; gap: 8px;">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>
                    1. Grievance Classification &amp; Priority
                </h3>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="category">Issue Sector <span class="required">*</span></label>
                        <select name="category" id="category" class="form-control" required>
                            <option value="">-- Choose Municipal Sector --</option>
                            <option value="Potholes & Roads" <%= preCategory.contains("Pothole") || preCategory.contains("Road") ? "selected" : "" %>>Roads Infrastructure &amp; Potholes</option>
                            <option value="Overflowing Garbage" <%= preCategory.contains("Garbage") ? "selected" : "" %>>Solid Waste &amp; Overflowing Bins</option>
                            <option value="Damaged Streetlights" <%= preCategory.contains("Streetlight") ? "selected" : "" %>>Public Illumination &amp; Streetlights</option>
                            <option value="Water Leakage" <%= preCategory.contains("Water") ? "selected" : "" %>>Potable Water Pipeline Ruptures</option>
                            <option value="Drainage & Sewage" <%= preCategory.contains("Drainage") ? "selected" : "" %>>Stormwater Drains &amp; Sewage Blocks</option>
                            <option value="Fallen Tree / Parks" <%= preCategory.contains("Parks") || preCategory.contains("Tree") ? "selected" : "" %>>Urban Forestry &amp; Fallen Trees</option>
                            <option value="Other">Other Civil Infrastructure Issue</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="priority">Urgency Classification</label>
                        <select name="priority" id="priority" class="form-control">
                            <option value="LOW">Low - Routine repair (96h SLA)</option>
                            <option value="MEDIUM" selected>Medium - Normal civil repair (72h SLA)</option>
                            <option value="HIGH">High - Road hazard or heavy disruption (48h SLA)</option>
                            <option value="URGENT">Urgent - Life safety danger or main burst (24h SLA)</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="title">Grievance Subject / Title <span class="required">*</span></label>
                    <input type="text" name="title" id="title" class="form-control" placeholder="E.g., Severe road cave-in and asphalt failure near junction" required maxlength="180">
                </div>

                <div class="form-group">
                    <label class="form-label" for="description">Detailed Engineering Description <span class="required">*</span></label>
                    <textarea name="description" id="description" class="form-control" rows="4" placeholder="Describe the physical condition, approximate dimensions (length, depth), hazards to vehicles/pedestrians, and time observed..." required></textarea>
                </div>

                <h3 style="font-size: 1.05rem; color: #1d4ed8; border-bottom: 1px solid #e2e8f0; padding-bottom: 8px; margin: 1.75rem 0 1.25rem; display: flex; align-items: center; justify-content: space-between;">
                    <span style="display: flex; align-items: center; gap: 8px;">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
                        2. Location &amp; Geo-Coordinates
                    </span>
                    <button type="button" onclick="detectGPS()" class="btn btn-secondary btn-sm" style="font-size: 0.78rem;">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor"><circle cx="12" cy="12" r="10"></circle><polygon points="16.24 7.76 14.12 14.12 7.76 16.24 9.88 9.88 16.24 7.76"></polygon></svg>
                        Capture My GPS Location
                    </button>
                </h3>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="wardZone">Municipal Zone / Ward <span class="required">*</span></label>
                        <select name="wardZone" id="wardZone" class="form-control" required>
                            <option value="Zone 1 - Central Business District">Zone 1 - Central Business District (MG Road, Shanthinagar)</option>
                            <option value="Zone 2 - Koramangala & HSR Layout">Zone 2 - Koramangala &amp; HSR Layout</option>
                            <option value="Zone 3 - Indiranagar & Domlur">Zone 3 - Indiranagar &amp; Domlur</option>
                            <option value="Zone 4 - Whitefield & Mahadevapura">Zone 4 - Whitefield &amp; Mahadevapura Tech Zone</option>
                            <option value="Zone 5 - Jayanagar & JP Nagar">Zone 5 - Jayanagar &amp; JP Nagar</option>
                            <option value="Zone 6 - Malleshwaram & Rajajinagar">Zone 6 - Malleshwaram &amp; Rajajinagar</option>
                            <option value="Zone 7 - Hebbal & Yelahanka North">Zone 7 - Hebbal &amp; Yelahanka North</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="departmentId">Direct Department Routing</label>
                        <select name="departmentId" id="departmentId" class="form-control">
                            <option value="">-- Auto-Route by System --</option>
                            <% if (departments != null) {
                                for (Department d : departments) { %>
                                    <option value="<%= d.getId() %>"><%= d.getName() %></option>
                            <%  }
                               } %>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="location">Exact Landmark / Street Address <span class="required">*</span></label>
                    <input type="text" name="location" id="location" class="form-control" placeholder="E.g., Opposite Metro Pillar 142, Outer Ring Road, near Central Junction" required>
                    <div class="form-text">Specify visible shop signs, house numbers, or junction names for fast field dispatch.</div>
                </div>

                <div class="form-row" style="margin-top: 10px;">
                    <div class="form-group">
                        <label class="form-label" for="latitude" style="font-size: 0.8rem; color: #64748b;">Latitude</label>
                        <input type="text" name="latitude" id="latitude" class="form-control" placeholder="12.9716" value="12.9716">
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="longitude" style="font-size: 0.8rem; color: #64748b;">Longitude</label>
                        <input type="text" name="longitude" id="longitude" class="form-control" placeholder="77.5946" value="77.5946">
                    </div>
                </div>

                <h3 style="font-size: 1.05rem; color: #1d4ed8; border-bottom: 1px solid #e2e8f0; padding-bottom: 8px; margin: 1.75rem 0 1.25rem; display: flex; align-items: center; gap: 8px;">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                    3. Citizen Contact Information
                </h3>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="citizenName">Full Name <span class="required">*</span></label>
                        <input type="text" name="citizenName" id="citizenName" class="form-control" placeholder="Your full name" value="<%= sessionUser != null ? sessionUser.getFullName() : "" %>" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="citizenPhone">Phone Number <span class="required">*</span></label>
                        <input type="tel" name="citizenPhone" id="citizenPhone" class="form-control" placeholder="10-digit mobile number" value="<%= sessionUser != null && sessionUser.getPhone() != null ? sessionUser.getPhone() : "" %>" required pattern="[0-9]{10}">
                        <div class="form-text">Field engineer SMS dispatch &amp; verification call will be made here.</div>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="citizenEmail">Email Address</label>
                    <input type="email" name="citizenEmail" id="citizenEmail" class="form-control" placeholder="name@domain.com" value="<%= sessionUser != null && sessionUser.getEmail() != null ? sessionUser.getEmail() : "" %>">
                </div>

                <div class="form-group">
                    <label class="form-label" for="remarks">Additional Field Instructions / Timing</label>
                    <textarea name="remarks" id="remarks" class="form-control" rows="2" placeholder="E.g., Site is best inspected early morning before heavy office traffic..."></textarea>
                </div>

                <div style="margin-top: 2rem; display: flex; gap: 12px; justify-content: flex-end;">
                    <a href="<%= sessionUser != null ? request.getContextPath() + "/citizen/dashboard" : request.getContextPath() + "/" %>" class="btn btn-secondary">Cancel</a>
                    <button type="submit" class="btn btn-primary btn-lg">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"><line x1="22" y1="2" x2="11" y2="13"></line><polygon points="22 2 15 22 11 13 2 9 22 2"></polygon></svg>
                        Submit Grievance to Municipal Ledger
                    </button>
                </div>
            </form>
        </div>

        <div style="margin-top: 2rem; background: #eff6ff; border: 1px solid #bfdbfe; border-radius: 12px; padding: 1.25rem 1.5rem; display: flex; gap: 16px; align-items: flex-start;">
            <div style="color: #1d4ed8; flex-shrink: 0; margin-top: 2px;">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>
            </div>
            <div>
                <strong style="color: #1e3a8a; font-size: 0.95rem;">Citizen Charter &amp; SLA Commitment:</strong>
                <p style="font-size: 0.85rem; color: #1e40af; margin-top: 4px; line-height: 1.5;">
                    Every registered complaint receives an immutable unique tracking number. Triage starts within 12 hours. Standard resolution SLA for urgent road, streetlight, and water issues is within 24 to 48 hours.
                </p>
            </div>
        </div>
    </div>
</div>

<script>
function detectGPS() {
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function (position) {
            document.getElementById('latitude').value = position.coords.latitude.toFixed(6);
            document.getElementById('longitude').value = position.coords.longitude.toFixed(6);
            alert('GPS Coordinates captured: ' + position.coords.latitude.toFixed(6) + ', ' + position.coords.longitude.toFixed(6));
        }, function (error) {
            alert('Unable to retrieve GPS coordinates: ' + error.message);
        });
    } else {
        alert('Geolocation is not supported by this browser.');
    }
}
</script>

<jsp:include page="/includes/footer.jsp" />

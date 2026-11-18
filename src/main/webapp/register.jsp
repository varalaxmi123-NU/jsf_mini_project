<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String error = (String) request.getAttribute("errorMessage");
%>
<jsp:include page="/includes/header.jsp" />

<div class="container" style="padding: 4rem 1.5rem 6rem;">
    <div style="max-width: 500px; margin: 0 auto;">

        <div style="text-align: center; margin-bottom: 2rem;">
            <div style="width: 52px; height: 52px; background: #1d4ed8; border-radius: 12px; display: inline-flex; align-items: center; justify-content: center; color: #ffffff; margin-bottom: 1rem; box-shadow: 0 4px 12px rgba(29, 78, 216, 0.25);">
                <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="8.5" cy="7" r="4"></circle><line x1="20" y1="8" x2="20" y2="14"></line><line x1="23" y1="11" x2="17" y2="11"></line></svg>
            </div>
            <h1 style="font-size: 1.85rem; font-weight: 800; color: #0f172a; letter-spacing: -0.025em;">Citizen Registration</h1>
            <p style="color: #64748b; font-size: 0.92rem;">Create your Resident Account to lodge and track complaints</p>
        </div>

        <% if (error != null) { %>
            <div class="alert alert-danger" style="margin-bottom: 1.25rem;">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                <%= error %>
            </div>
        <% } %>

        <div class="card" style="padding: 2.25rem; border-radius: 16px; border: 1px solid #e2e8f0; background: #ffffff; box-shadow: 0 10px 25px -5px rgba(15, 23, 42, 0.08), 0 8px 10px -6px rgba(15, 23, 42, 0.03);">
            <form action="<%= request.getContextPath() %>/register" method="POST">
                <div class="form-group" style="margin-bottom: 1.2rem;">
                    <label class="form-label" for="regFullName" style="font-weight: 600; color: #0f172a; font-size: 0.88rem;">Full Legal Name <span class="required" style="color: #dc2626;">*</span></label>
                    <input type="text" name="fullName" id="regFullName" class="form-control" placeholder="E.g., Arvind Swamy" style="height: 44px; font-size: 0.92rem; border-color: #cbd5e1; background: #ffffff;" required>
                </div>

                <div class="form-row" style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 1.2rem;">
                    <div class="form-group">
                        <label class="form-label" for="regUsername" style="font-weight: 600; color: #0f172a; font-size: 0.88rem;">Username <span class="required" style="color: #dc2626;">*</span></label>
                        <input type="text" name="username" id="regUsername" class="form-control" placeholder="username" style="height: 44px; font-size: 0.92rem; border-color: #cbd5e1; background: #ffffff;" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="regPassword" style="font-weight: 600; color: #0f172a; font-size: 0.88rem;">Password <span class="required" style="color: #dc2626;">*</span></label>
                        <input type="password" name="password" id="regPassword" class="form-control" placeholder="password" style="height: 44px; font-size: 0.92rem; border-color: #cbd5e1; background: #ffffff;" required>
                    </div>
                </div>

                <div class="form-row" style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 1.2rem;">
                    <div class="form-group">
                        <label class="form-label" for="regPhone" style="font-weight: 600; color: #0f172a; font-size: 0.88rem;">Phone (10 Digits) <span class="required" style="color: #dc2626;">*</span></label>
                        <input type="tel" name="phone" id="regPhone" class="form-control" placeholder="98XXXXXXXX" pattern="[0-9]{10}" style="height: 44px; font-size: 0.92rem; border-color: #cbd5e1; background: #ffffff;" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="regEmail" style="font-weight: 600; color: #0f172a; font-size: 0.88rem;">Email Address</label>
                        <input type="email" name="email" id="regEmail" class="form-control" placeholder="name@domain.com" style="height: 44px; font-size: 0.92rem; border-color: #cbd5e1; background: #ffffff;">
                    </div>
                </div>

                <div class="form-group" style="margin-bottom: 1.5rem;">
                    <label class="form-label" for="regAddress" style="font-weight: 600; color: #0f172a; font-size: 0.88rem;">Residential Address</label>
                    <input type="text" name="address" id="regAddress" class="form-control" placeholder="House/Flat number, Street name, Ward/Zone" style="height: 44px; font-size: 0.92rem; border-color: #cbd5e1; background: #ffffff;">
                </div>

                <button type="submit" class="btn btn-primary btn-block" style="height: 46px; font-size: 0.95rem; font-weight: 700; border-radius: 8px;">
                    Register &amp; Open Workspace
                </button>
            </form>

            <div style="text-align: center; margin-top: 1.5rem; padding-top: 1.25rem; border-top: 1px solid #f1f5f9;">
                <span style="font-size: 0.86rem; color: #64748b;">Already have an account?</span>
                <a href="<%= request.getContextPath() %>/login" style="font-weight: 700; color: #1d4ed8; margin-left: 6px; font-size: 0.86rem;">Sign In Here &rarr;</a>
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

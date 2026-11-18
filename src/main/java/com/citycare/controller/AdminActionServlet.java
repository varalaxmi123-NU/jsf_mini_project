package com.citycare.controller;

import com.citycare.dao.ComplaintDAO;
import com.citycare.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/action")
public class AdminActionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ComplaintDAO complaintDAO;

    @Override
    public void init() throws ServletException {
        complaintDAO = new ComplaintDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("currentUser");
        if (!"ADMIN".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/officer/dashboard");
            return;
        }

        String action = request.getParameter("action");
        String complaintIdStr = request.getParameter("complaintId");

        if (complaintIdStr == null || complaintIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?error=MissingId");
            return;
        }

        int complaintId;
        try {
            complaintId = Integer.parseInt(complaintIdStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?error=InvalidId");
            return;
        }

        if ("assign".equalsIgnoreCase(action)) {
            String deptIdStr = request.getParameter("departmentId");
            String officerIdStr = request.getParameter("officerId");
            String remarks = request.getParameter("remarks");

            try {
                int deptId = Integer.parseInt(deptIdStr.trim());
                Integer officerId = null;
                if (officerIdStr != null && !officerIdStr.trim().isEmpty() && !"0".equals(officerIdStr)) {
                    officerId = Integer.parseInt(officerIdStr.trim());
                }
                complaintDAO.assignDepartmentAndOfficer(complaintId, deptId, officerId, remarks, user.getFullName());
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?success=Assigned");
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?error=AssignFailed");
            }
        } else if ("updateStatus".equalsIgnoreCase(action)) {
            String status = request.getParameter("status");
            String remarks = request.getParameter("remarks");
            String resolutionNotes = request.getParameter("resolutionNotes");

            complaintDAO.updateComplaintStatus(complaintId, status, remarks, resolutionNotes, user.getFullName());
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?success=StatusUpdated");
        } else if ("delete".equalsIgnoreCase(action)) {
            complaintDAO.deleteComplaint(complaintId);
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?success=Deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        }
    }
}

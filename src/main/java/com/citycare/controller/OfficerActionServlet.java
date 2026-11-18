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

@WebServlet("/officer/action")
public class OfficerActionServlet extends HttpServlet {
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
        String action = request.getParameter("action");
        String complaintIdStr = request.getParameter("complaintId");

        if (complaintIdStr == null || complaintIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/officer/dashboard?error=MissingComplaintId");
            return;
        }

        int complaintId;
        try {
            complaintId = Integer.parseInt(complaintIdStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/officer/dashboard?error=InvalidComplaintId");
            return;
        }

        if ("updateStatus".equalsIgnoreCase(action)) {
            String newStatus = request.getParameter("newStatus");
            String remarks = request.getParameter("remarks");
            String resolutionNotes = request.getParameter("resolutionNotes");
            String contractor = request.getParameter("contractor");
            String materials = request.getParameter("materials");

            complaintDAO.updateComplaintStatus(complaintId, newStatus, remarks, resolutionNotes, contractor, materials, user.getFullName());
            response.sendRedirect(request.getContextPath() + "/officer/dashboard?success=StatusUpdated");
        } else if ("reassign".equalsIgnoreCase(action)) {
            String deptIdStr = request.getParameter("reassignDeptId");
            String remarks = request.getParameter("reassignRemarks");
            try {
                int newDeptId = Integer.parseInt(deptIdStr.trim());
                complaintDAO.assignDepartmentAndOfficer(complaintId, newDeptId, null, remarks, user.getFullName());
                response.sendRedirect(request.getContextPath() + "/officer/dashboard?success=DepartmentReassigned");
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/officer/dashboard?error=ReassignFailed");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/officer/dashboard");
        }
    }
}

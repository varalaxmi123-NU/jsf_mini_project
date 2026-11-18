package com.citycare.controller;

import com.citycare.dao.ComplaintDAO;
import com.citycare.dao.DepartmentDAO;
import com.citycare.model.Complaint;
import com.citycare.model.Department;
import com.citycare.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/officer/dashboard")
public class OfficerDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ComplaintDAO complaintDAO;
    private DepartmentDAO departmentDAO;

    @Override
    public void init() throws ServletException {
        complaintDAO = new ComplaintDAO();
        departmentDAO = new DepartmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("currentUser");

        String keyword = request.getParameter("keyword");
        String category = request.getParameter("category");
        String status = request.getParameter("status");
        String ward = request.getParameter("ward");

        Integer deptId = user.getDepartmentId();
        // If admin is viewing officer dashboard or officer has no dept, show all or selected dept
        String filterDept = request.getParameter("deptId");
        if (filterDept != null && !filterDept.trim().isEmpty()) {
            try {
                deptId = Integer.parseInt(filterDept.trim());
            } catch (NumberFormatException ignored) {}
        }

        List<Complaint> complaints = complaintDAO.searchComplaints(keyword, category, status, ward, deptId);
        List<Department> departments = departmentDAO.getAllDepartments();

        int pendingCount = 0;
        int inProgressCount = 0;
        int resolvedCount = 0;
        int reviewCount = 0;

        for (Complaint c : complaints) {
            if ("PENDING".equalsIgnoreCase(c.getStatus())) pendingCount++;
            else if ("UNDER_REVIEW".equalsIgnoreCase(c.getStatus())) reviewCount++;
            else if ("IN_PROGRESS".equalsIgnoreCase(c.getStatus())) inProgressCount++;
            else if ("RESOLVED".equalsIgnoreCase(c.getStatus())) resolvedCount++;
        }

        request.setAttribute("complaints", complaints);
        request.setAttribute("departments", departments);
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("reviewCount", reviewCount);
        request.setAttribute("inProgressCount", inProgressCount);
        request.setAttribute("resolvedCount", resolvedCount);
        request.setAttribute("totalCount", complaints.size());

        request.setAttribute("selectedKeyword", keyword);
        request.setAttribute("selectedCategory", category);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("selectedWard", ward);

        request.getRequestDispatcher("/officerDashboard.jsp").forward(request, response);
    }
}

package com.citycare.controller;

import com.citycare.dao.ComplaintDAO;
import com.citycare.dao.DepartmentDAO;
import com.citycare.dao.UserDAO;
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
import java.util.Map;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ComplaintDAO complaintDAO;
    private DepartmentDAO departmentDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        complaintDAO = new ComplaintDAO();
        departmentDAO = new DepartmentDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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

        String keyword = request.getParameter("keyword");
        String category = request.getParameter("category");
        String status = request.getParameter("status");
        String ward = request.getParameter("ward");
        String deptIdStr = request.getParameter("deptId");

        Integer deptId = null;
        if (deptIdStr != null && !deptIdStr.trim().isEmpty() && !"ALL".equalsIgnoreCase(deptIdStr)) {
            try {
                deptId = Integer.parseInt(deptIdStr.trim());
            } catch (NumberFormatException ignored) {}
        }

        List<Complaint> complaints = complaintDAO.searchComplaints(keyword, category, status, ward, deptId);
        List<Department> departments = departmentDAO.getAllDepartments();
        List<User> officers = userDAO.getAllUsers();
        Map<String, Integer> stats = complaintDAO.getComplaintStatistics();
        Map<String, Integer> categoryDist = complaintDAO.getCategoryDistribution();
        Map<String, Integer> wardDist = complaintDAO.getWardDistribution();

        int total = stats.getOrDefault("TOTAL", 0);
        int resolved = stats.getOrDefault("RESOLVED", 0);
        int resolutionRate = total > 0 ? (resolved * 100) / total : 0;

        request.setAttribute("complaints", complaints);
        request.setAttribute("departments", departments);
        request.setAttribute("officers", officers);
        request.setAttribute("stats", stats);
        request.setAttribute("resolutionRate", resolutionRate);
        request.setAttribute("categoryDist", categoryDist);
        request.setAttribute("wardDist", wardDist);

        request.setAttribute("selectedKeyword", keyword);
        request.setAttribute("selectedCategory", category);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("selectedWard", ward);
        request.setAttribute("selectedDeptId", deptIdStr);

        request.getRequestDispatcher("/adminDashboard.jsp").forward(request, response);
    }
}

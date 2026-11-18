package com.citycare.controller;

import com.citycare.dao.ComplaintDAO;
import com.citycare.dao.DepartmentDAO;
import com.citycare.dao.UserDAO;
import com.citycare.model.Complaint;
import com.citycare.model.ComplaintLog;
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

@WebServlet("/complaint-details")
public class ComplaintDetailsServlet extends HttpServlet {
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

        String idStr = request.getParameter("id");
        String code = request.getParameter("code");

        Complaint complaint = null;
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                complaint = complaintDAO.getComplaintById(Integer.parseInt(idStr.trim()));
            } catch (NumberFormatException ignored) {}
        } else if (code != null && !code.trim().isEmpty()) {
            complaint = complaintDAO.getComplaintByCode(code.trim());
        }

        if (complaint == null) {
            response.sendRedirect(request.getContextPath() + "/officer/dashboard?error=NotFound");
            return;
        }

        List<ComplaintLog> logs = complaintDAO.getComplaintLogs(complaint.getId());
        List<Department> departments = departmentDAO.getAllDepartments();
        List<User> officers = userDAO.getAllUsers();

        request.setAttribute("complaint", complaint);
        request.setAttribute("logs", logs);
        request.setAttribute("departments", departments);
        request.setAttribute("officers", officers);

        request.getRequestDispatcher("/complaintDetails.jsp").forward(request, response);
    }
}

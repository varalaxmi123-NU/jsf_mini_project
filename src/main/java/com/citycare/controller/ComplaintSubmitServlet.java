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

@WebServlet("/submit-complaint")
public class ComplaintSubmitServlet extends HttpServlet {
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
            response.sendRedirect(request.getContextPath() + "/login?error=" + java.net.URLEncoder.encode("Please sign in to lodge a complaint.", "UTF-8"));
            return;
        }

        List<Department> departments = departmentDAO.getAllDepartments();
        request.setAttribute("departments", departments);
        request.getRequestDispatcher("/lodgeComplaint.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=" + java.net.URLEncoder.encode("Session expired. Please sign in again.", "UTF-8"));
            return;
        }

        String category = request.getParameter("category");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String location = request.getParameter("location");
        String wardZone = request.getParameter("wardZone");
        String latitude = request.getParameter("latitude");
        String longitude = request.getParameter("longitude");
        String citizenName = request.getParameter("citizenName");
        String citizenPhone = request.getParameter("citizenPhone");
        String citizenEmail = request.getParameter("citizenEmail");
        String priority = request.getParameter("priority");
        String deptIdStr = request.getParameter("departmentId");
        String remarks = request.getParameter("remarks");

        // If user is logged in, auto-fill contact if empty
        if (session != null && session.getAttribute("currentUser") != null) {
            User currentUser = (User) session.getAttribute("currentUser");
            if (citizenName == null || citizenName.trim().isEmpty()) {
                citizenName = currentUser.getFullName();
            }
            if (citizenPhone == null || citizenPhone.trim().isEmpty()) {
                citizenPhone = currentUser.getPhone();
            }
            if (citizenEmail == null || citizenEmail.trim().isEmpty()) {
                citizenEmail = currentUser.getEmail();
            }
        }

        // Basic validation
        if (title == null || title.trim().isEmpty() ||
            description == null || description.trim().isEmpty() ||
            location == null || location.trim().isEmpty() ||
            citizenName == null || citizenName.trim().isEmpty() ||
            citizenPhone == null || citizenPhone.trim().isEmpty()) {

            request.setAttribute("errorMessage", "Please fill in all mandatory fields (*)");
            request.setAttribute("departments", departmentDAO.getAllDepartments());
            request.getRequestDispatcher("/lodgeComplaint.jsp").forward(request, response);
            return;
        }

        Complaint complaint = new Complaint();
        complaint.setCategory(category != null ? category.trim() : "Other");
        complaint.setComplaintCode(complaintDAO.generateComplaintCode(complaint.getCategory()));
        complaint.setTitle(title.trim());
        complaint.setDescription(description.trim());
        complaint.setLocation(location.trim());
        complaint.setWardZone(wardZone != null ? wardZone.trim() : "Zone 1 - Central Business District");
        complaint.setLatitude(latitude != null && !latitude.trim().isEmpty() ? latitude.trim() : "12.9716");
        complaint.setLongitude(longitude != null && !longitude.trim().isEmpty() ? longitude.trim() : "77.5946");
        complaint.setCitizenName(citizenName.trim());
        complaint.setCitizenPhone(citizenPhone.trim());
        complaint.setCitizenEmail(citizenEmail != null ? citizenEmail.trim() : "");
        complaint.setPriority(priority != null && !priority.trim().isEmpty() ? priority.trim() : "MEDIUM");
        complaint.setStatus("PENDING");
        complaint.setRemarks(remarks != null ? remarks.trim() : "Grievance lodged by citizen");

        if (deptIdStr != null && !deptIdStr.trim().isEmpty()) {
            try {
                complaint.setDepartmentId(Integer.parseInt(deptIdStr.trim()));
            } catch (NumberFormatException ignored) {}
        } else {
            String cat = complaint.getCategory();
            if (cat != null) {
                if (cat.contains("Pothole") || cat.contains("Road")) complaint.setDepartmentId(1);
                else if (cat.contains("Garbage")) complaint.setDepartmentId(2);
                else if (cat.contains("Streetlight")) complaint.setDepartmentId(3);
                else if (cat.contains("Water")) complaint.setDepartmentId(4);
                else if (cat.contains("Tree") || cat.contains("Park")) complaint.setDepartmentId(5);
                else if (cat.contains("Drainage")) complaint.setDepartmentId(6);
                else complaint.setDepartmentId(1);
            } else {
                complaint.setDepartmentId(1);
            }
        }

        boolean success = complaintDAO.submitComplaint(complaint);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/complaintSuccess.jsp?code=" + complaint.getComplaintCode());
        } else {
            request.setAttribute("errorMessage", "An error occurred while lodging your grievance. Please verify database connection.");
            request.setAttribute("departments", departmentDAO.getAllDepartments());
            request.getRequestDispatcher("/lodgeComplaint.jsp").forward(request, response);
        }
    }
}

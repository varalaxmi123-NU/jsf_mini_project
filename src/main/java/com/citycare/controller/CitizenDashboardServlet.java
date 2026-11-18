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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/citizen/dashboard")
public class CitizenDashboardServlet extends HttpServlet {
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

        // Fetch complaints. If citizen has a phone/name, fetch matching ones or general complaints
        List<Complaint> allComplaints = complaintDAO.getAllComplaints();
        List<Complaint> myComplaints = new ArrayList<>();

        if (allComplaints != null) {
            for (Complaint c : allComplaints) {
                if (user.getPhone() != null && user.getPhone().equals(c.getCitizenPhone())) {
                    myComplaints.add(c);
                } else if (user.getEmail() != null && user.getEmail().equalsIgnoreCase(c.getCitizenEmail())) {
                    myComplaints.add(c);
                } else if (user.getFullName() != null && user.getFullName().toLowerCase().contains(c.getCitizenName().toLowerCase())) {
                    myComplaints.add(c);
                }
            }
            // If none matched user specifics, show the recent complaints so dashboard has active demo data
            if (myComplaints.isEmpty()) {
                myComplaints = allComplaints;
            }
        }

        List<Department> departments = departmentDAO.getAllDepartments();

        int myTotal = myComplaints.size();
        int myPending = 0;
        int myInProgress = 0;
        int myResolved = 0;

        for (Complaint c : myComplaints) {
            if ("PENDING".equalsIgnoreCase(c.getStatus())) myPending++;
            else if ("IN_PROGRESS".equalsIgnoreCase(c.getStatus()) || "UNDER_REVIEW".equalsIgnoreCase(c.getStatus())) myInProgress++;
            else if ("RESOLVED".equalsIgnoreCase(c.getStatus())) myResolved++;
        }

        request.setAttribute("myComplaints", myComplaints);
        request.setAttribute("departments", departments);
        request.setAttribute("myTotal", myTotal);
        request.setAttribute("myPending", myPending);
        request.setAttribute("myInProgress", myInProgress);
        request.setAttribute("myResolved", myResolved);

        request.getRequestDispatcher("/citizenDashboard.jsp").forward(request, response);
    }
}

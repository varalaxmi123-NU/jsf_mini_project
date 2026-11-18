package com.citycare.controller;

import com.citycare.dao.ComplaintDAO;
import com.citycare.model.Complaint;
import com.citycare.model.ComplaintLog;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;

@WebServlet("/track")
public class ComplaintTrackServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ComplaintDAO complaintDAO;

    @Override
    public void init() throws ServletException {
        complaintDAO = new ComplaintDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=" + URLEncoder.encode("Please sign in to access grievance tracking.", "UTF-8"));
            return;
        }

        String code = request.getParameter("code");
        if (code == null || code.trim().isEmpty()) {
            code = request.getParameter("complaintId");
        }

        if (code != null && !code.trim().isEmpty()) {
            code = code.trim().toUpperCase();
            Complaint complaint = complaintDAO.getComplaintByCode(code);
            if (complaint != null) {
                List<ComplaintLog> logs = complaintDAO.getComplaintLogs(complaint.getId());
                request.setAttribute("complaint", complaint);
                request.setAttribute("logs", logs);
            } else {
                request.setAttribute("notFound", true);
                request.setAttribute("searchedCode", code);
            }
        }

        request.getRequestDispatcher("/trackComplaint.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String code = request.getParameter("code");
        if (code != null && !code.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/track?code=" + code.trim());
        } else {
            response.sendRedirect(request.getContextPath() + "/track");
        }
    }
}

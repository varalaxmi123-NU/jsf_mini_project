package com.citycare.controller;

import com.citycare.dao.ComplaintDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/submit-feedback")
public class ComplaintFeedbackServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ComplaintDAO complaintDAO;

    @Override
    public void init() throws ServletException {
        complaintDAO = new ComplaintDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String code = request.getParameter("complaintCode");
        String ratingStr = request.getParameter("rating");
        String feedback = request.getParameter("feedback");

        int rating = 5;
        if (ratingStr != null && !ratingStr.trim().isEmpty()) {
            try {
                rating = Integer.parseInt(ratingStr.trim());
            } catch (NumberFormatException ignored) {}
        }

        if (code != null && !code.trim().isEmpty()) {
            complaintDAO.updateCitizenFeedback(code.trim(), rating, feedback != null ? feedback.trim() : "");
            response.sendRedirect(request.getContextPath() + "/track?code=" + code.trim() + "&feedbackSaved=true");
        } else {
            response.sendRedirect(request.getContextPath() + "/track");
        }
    }
}

package com.citycare.controller;

import com.citycare.dao.UserDAO;
import com.citycare.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String fullName = request.getParameter("fullName");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        if (fullName == null || fullName.trim().isEmpty() ||
            username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty()) {

            request.setAttribute("errorMessage", "Please complete all mandatory fields (*).");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        User u = new User();
        u.setFullName(fullName.trim());
        u.setUsername(username.trim());
        u.setPassword(password.trim());
        u.setEmail(email != null ? email.trim() : "");
        u.setPhone(phone.trim());
        u.setAddress(address != null ? address.trim() : "");

        boolean created = userDAO.registerCitizen(u);
        if (created) {
            // Auto login
            User authenticated = userDAO.authenticate(u.getUsername(), u.getPassword());
            if (authenticated != null) {
                HttpSession session = request.getSession(true);
                session.setAttribute("currentUser", authenticated);
                response.sendRedirect(request.getContextPath() + "/citizen/dashboard");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/login?registered=true");
        } else {
            request.setAttribute("errorMessage", "Registration failed. Username may already be in use.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}

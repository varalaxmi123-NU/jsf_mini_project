package com.citycare.controller;

import com.citycare.dao.ComplaintDAO;
import com.citycare.model.Complaint;
import com.citycare.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/admin/export-csv")
public class ExportCsvServlet extends HttpServlet {
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
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("currentUser");
        if (!"ADMIN".equalsIgnoreCase(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        List<Complaint> list = complaintDAO.getAllComplaints();
        String dateStr = new SimpleDateFormat("yyyyMMdd_HHmm").format(new Date());

        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"CityCare_Grievances_" + dateStr + ".csv\"");

        PrintWriter out = response.getWriter();
        out.println("Complaint ID,Category,Title,Description,Location,Ward/Zone,Priority,Status,Department,Assigned Officer,Contractor,Materials Used,Citizen Name,Citizen Phone,Citizen Email,SLA Hours,Citizen Rating,Lodged Date,Resolved Date");

        if (list != null) {
            for (Complaint c : list) {
                out.print(escapeCsv(c.getComplaintCode()) + ",");
                out.print(escapeCsv(c.getCategory()) + ",");
                out.print(escapeCsv(c.getTitle()) + ",");
                out.print(escapeCsv(c.getDescription()) + ",");
                out.print(escapeCsv(c.getLocation()) + ",");
                out.print(escapeCsv(c.getWardZone()) + ",");
                out.print(escapeCsv(c.getPriority()) + ",");
                out.print(escapeCsv(c.getStatus()) + ",");
                out.print(escapeCsv(c.getDepartmentName()) + ",");
                out.print(escapeCsv(c.getAssignedOfficerName()) + ",");
                out.print(escapeCsv(c.getContractorAssigned()) + ",");
                out.print(escapeCsv(c.getMaterialsUsed()) + ",");
                out.print(escapeCsv(c.getCitizenName()) + ",");
                out.print(escapeCsv(c.getCitizenPhone()) + ",");
                out.print(escapeCsv(c.getCitizenEmail()) + ",");
                out.print(c.getSlaHours() + ",");
                out.print(c.getCitizenRating() + ",");
                out.print(escapeCsv(c.getFormattedCreatedAt()) + ",");
                out.println(escapeCsv(c.getFormattedResolvedAt()));
            }
        }
        out.flush();
    }

    private String escapeCsv(String str) {
        if (str == null) return "\"\"";
        return "\"" + str.replace("\"", "\"\"").replace("\n", " ").replace("\r", " ") + "\"";
    }
}

package com.citycare.dao;

import com.citycare.model.Complaint;
import com.citycare.model.ComplaintLog;
import com.citycare.util.DBConnection;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Date;

public class ComplaintDAO {

    public synchronized String generateComplaintCode(String category) {
        String prefix = "CV";
        if (category != null) {
            String lower = category.toLowerCase();
            if (lower.contains("road") || lower.contains("pothole")) prefix = "RD";
            else if (lower.contains("garbage") || lower.contains("waste")) prefix = "SW";
            else if (lower.contains("light") || lower.contains("electric")) prefix = "EL";
            else if (lower.contains("water")) prefix = "WT";
            else if (lower.contains("drain")) prefix = "SWD";
            else if (lower.contains("tree") || lower.contains("park")) prefix = "PK";
        }
        int random = 1000 + new Random().nextInt(9000);
        String year = new SimpleDateFormat("yyyy").format(new Date());
        return "BMCC-" + year + "-" + prefix + "-" + random;
    }

    public boolean submitComplaint(Complaint c) {
        String sql = "INSERT INTO complaints (complaint_code, category, title, description, location, ward_zone, "
                   + "latitude, longitude, citizen_name, citizen_phone, citizen_email, priority, status, department_id, remarks, sla_hours) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'PENDING', ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, c.getComplaintCode());
            ps.setString(2, c.getCategory());
            ps.setString(3, c.getTitle());
            ps.setString(4, c.getDescription());
            ps.setString(5, c.getLocation());
            ps.setString(6, c.getWardZone());
            ps.setString(7, c.getLatitude());
            ps.setString(8, c.getLongitude());
            ps.setString(9, c.getCitizenName());
            ps.setString(10, c.getCitizenPhone());
            ps.setString(11, c.getCitizenEmail());
            ps.setString(12, c.getPriority());

            if (c.getDepartmentId() != null && c.getDepartmentId() > 0) {
                ps.setInt(13, c.getDepartmentId());
            } else {
                ps.setNull(13, Types.INTEGER);
            }
            ps.setString(14, c.getRemarks());

            // SLA calculation: Urgent = 24h, High = 48h, Medium = 72h
            int sla = 48;
            if ("URGENT".equalsIgnoreCase(c.getPriority())) sla = 24;
            else if ("LOW".equalsIgnoreCase(c.getPriority())) sla = 96;
            else if ("MEDIUM".equalsIgnoreCase(c.getPriority())) sla = 72;
            ps.setInt(15, sla);

            int affected = ps.executeUpdate();
            if (affected > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    c.setId(rs.getInt(1));
                }

                String logSql = "INSERT INTO complaint_logs (complaint_id, action, status_from, status_to, remarks, performed_by) "
                              + "VALUES (?, 'Grievance Registered', NULL, 'PENDING', 'Official grievance recorded in Municipal Dispatch Ledger', ?)";
                try (PreparedStatement logPs = conn.prepareStatement(logSql)) {
                    logPs.setInt(1, c.getId());
                    logPs.setString(2, c.getCitizenName() != null ? c.getCitizenName() : "Citizen");
                    logPs.executeUpdate();
                }

                conn.commit();
                return true;
            }
            conn.rollback();
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); } catch (SQLException ignored) {}
            }
            DBConnection.close(rs, ps, conn);
        }
        return false;
    }

    public Complaint getComplaintById(int id) {
        String sql = "SELECT c.*, d.name AS department_name, u.full_name AS assigned_officer_name "
                   + "FROM complaints c "
                   + "LEFT JOIN departments d ON c.department_id = d.id "
                   + "LEFT JOIN users u ON c.assigned_officer_id = u.id "
                   + "WHERE c.id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapComplaint(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return null;
    }

    public Complaint getComplaintByCode(String code) {
        String sql = "SELECT c.*, d.name AS department_name, u.full_name AS assigned_officer_name "
                   + "FROM complaints c "
                   + "LEFT JOIN departments d ON c.department_id = d.id "
                   + "LEFT JOIN users u ON c.assigned_officer_id = u.id "
                   + "WHERE UPPER(TRIM(c.complaint_code)) = UPPER(TRIM(?))";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, code);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapComplaint(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return null;
    }

    public List<Complaint> getAllComplaints() {
        return searchComplaints(null, null, null, null, null);
    }

    public List<Complaint> searchComplaints(String keyword, String category, String status, String ward, Integer deptId) {
        List<Complaint> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT c.*, d.name AS department_name, u.full_name AS assigned_officer_name " +
            "FROM complaints c " +
            "LEFT JOIN departments d ON c.department_id = d.id " +
            "LEFT JOIN users u ON c.assigned_officer_id = u.id " +
            "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (c.complaint_code LIKE ? OR c.title LIKE ? OR c.description LIKE ? OR c.location LIKE ? OR c.citizen_name LIKE ? OR c.citizen_phone LIKE ?) ");
            String kw = "%" + keyword.trim() + "%";
            for (int i = 0; i < 6; i++) {
                params.add(kw);
            }
        }
        if (category != null && !category.trim().isEmpty() && !category.equalsIgnoreCase("ALL")) {
            sql.append("AND c.category = ? ");
            params.add(category.trim());
        }
        if (status != null && !status.trim().isEmpty() && !status.equalsIgnoreCase("ALL")) {
            sql.append("AND c.status = ? ");
            params.add(status.trim());
        }
        if (ward != null && !ward.trim().isEmpty() && !ward.equalsIgnoreCase("ALL")) {
            sql.append("AND c.ward_zone = ? ");
            params.add(ward.trim());
        }
        if (deptId != null && deptId > 0) {
            sql.append("AND c.department_id = ? ");
            params.add(deptId);
        }

        sql.append("ORDER BY c.created_at DESC");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapComplaint(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }

    public boolean updateComplaintStatus(int complaintId, String newStatus, String remarks, String resolutionNotes, String updatedBy) {
        return updateComplaintStatus(complaintId, newStatus, remarks, resolutionNotes, null, null, updatedBy);
    }

    public boolean updateComplaintStatus(int complaintId, String newStatus, String remarks, String resolutionNotes, String contractor, String materials, String updatedBy) {
        Complaint current = getComplaintById(complaintId);
        if (current == null) return false;

        StringBuilder sql = new StringBuilder("UPDATE complaints SET status = ?, remarks = ? ");
        if (contractor != null && !contractor.trim().isEmpty()) {
            sql.append(", contractor_assigned = ? ");
        }
        if (materials != null && !materials.trim().isEmpty()) {
            sql.append(", materials_used = ? ");
        }
        if ("RESOLVED".equalsIgnoreCase(newStatus)) {
            sql.append(", resolved_at = NOW(), resolution_notes = ? ");
        } else if (resolutionNotes != null && !resolutionNotes.trim().isEmpty()) {
            sql.append(", resolution_notes = ? ");
        }
        sql.append("WHERE id = ?");

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            ps = conn.prepareStatement(sql.toString());
            int idx = 1;
            ps.setString(idx++, newStatus);
            ps.setString(idx++, remarks != null ? remarks : current.getRemarks());

            if (contractor != null && !contractor.trim().isEmpty()) {
                ps.setString(idx++, contractor.trim());
            }
            if (materials != null && !materials.trim().isEmpty()) {
                ps.setString(idx++, materials.trim());
            }
            if ("RESOLVED".equalsIgnoreCase(newStatus) || (resolutionNotes != null && !resolutionNotes.trim().isEmpty())) {
                ps.setString(idx++, resolutionNotes);
            }
            ps.setInt(idx, complaintId);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                String logSql = "INSERT INTO complaint_logs (complaint_id, action, status_from, status_to, remarks, performed_by) "
                              + "VALUES (?, ?, ?, ?, ?, ?)";
                try (PreparedStatement logPs = conn.prepareStatement(logSql)) {
                    logPs.setInt(1, complaintId);
                    logPs.setString(2, "Status changed to " + newStatus);
                    logPs.setString(3, current.getStatus());
                    logPs.setString(4, newStatus);
                    logPs.setString(5, remarks != null && !remarks.trim().isEmpty() ? remarks : "Progress certified by municipal officer");
                    logPs.setString(6, updatedBy != null ? updatedBy : "Municipal Officer");
                    logPs.executeUpdate();
                }

                conn.commit();
                return true;
            }
            conn.rollback();
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); } catch (SQLException ignored) {}
            }
            DBConnection.close(null, ps, conn);
        }
        return false;
    }

    public boolean assignDepartmentAndOfficer(int complaintId, int deptId, Integer officerId, String remarks, String updatedBy) {
        Complaint current = getComplaintById(complaintId);
        if (current == null) return false;

        String sql = "UPDATE complaints SET department_id = ?, assigned_officer_id = ?, status = CASE WHEN status = 'PENDING' THEN 'UNDER_REVIEW' ELSE status END, remarks = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            ps = conn.prepareStatement(sql);
            ps.setInt(1, deptId);
            if (officerId != null && officerId > 0) {
                ps.setInt(2, officerId);
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            ps.setString(3, remarks != null ? remarks : current.getRemarks());
            ps.setInt(4, complaintId);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                String logSql = "INSERT INTO complaint_logs (complaint_id, action, status_from, status_to, remarks, performed_by) "
                              + "VALUES (?, 'Triage Routing & Officer Assigned', ?, ?, ?, ?)";
                try (PreparedStatement logPs = conn.prepareStatement(logSql)) {
                    logPs.setInt(1, complaintId);
                    logPs.setString(2, current.getStatus());
                    String nextStatus = "PENDING".equalsIgnoreCase(current.getStatus()) ? "UNDER_REVIEW" : current.getStatus();
                    logPs.setString(3, nextStatus);
                    logPs.setString(4, remarks != null ? remarks : "Dispatched to department ID " + deptId);
                    logPs.setString(5, updatedBy != null ? updatedBy : "Commissioner Office");
                    logPs.executeUpdate();
                }

                conn.commit();
                return true;
            }
            conn.rollback();
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); } catch (SQLException ignored) {}
            }
            DBConnection.close(null, ps, conn);
        }
        return false;
    }

    public boolean updateCitizenFeedback(String complaintCode, int rating, String feedback) {
        String sql = "UPDATE complaints SET citizen_rating = ?, citizen_feedback = ? WHERE UPPER(TRIM(complaint_code)) = UPPER(TRIM(?))";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, rating);
            ps.setString(2, feedback);
            ps.setString(3, complaintCode);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(null, ps, conn);
        }
        return false;
    }

    public Map<String, Integer> getComplaintStatistics() {
        Map<String, Integer> stats = new LinkedHashMap<>();
        stats.put("TOTAL", 0);
        stats.put("PENDING", 0);
        stats.put("UNDER_REVIEW", 0);
        stats.put("IN_PROGRESS", 0);
        stats.put("RESOLVED", 0);
        stats.put("REJECTED", 0);

        String sql = "SELECT status, COUNT(*) AS cnt FROM complaints GROUP BY status";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            int total = 0;
            while (rs.next()) {
                String st = rs.getString("status");
                int count = rs.getInt("cnt");
                if (st != null) {
                    stats.put(st.toUpperCase(), count);
                    total += count;
                }
            }
            stats.put("TOTAL", total);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return stats;
    }

    public Map<String, Integer> getCategoryDistribution() {
        Map<String, Integer> catMap = new LinkedHashMap<>();
        String sql = "SELECT category, COUNT(*) AS cnt FROM complaints GROUP BY category ORDER BY cnt DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                catMap.put(rs.getString("category"), rs.getInt("cnt"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return catMap;
    }

    public Map<String, Integer> getWardDistribution() {
        Map<String, Integer> wardMap = new LinkedHashMap<>();
        String sql = "SELECT ward_zone, COUNT(*) AS cnt FROM complaints GROUP BY ward_zone ORDER BY cnt DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                wardMap.put(rs.getString("ward_zone"), rs.getInt("cnt"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return wardMap;
    }

    public List<ComplaintLog> getComplaintLogs(int complaintId) {
        List<ComplaintLog> list = new ArrayList<>();
        String sql = "SELECT * FROM complaint_logs WHERE complaint_id = ? ORDER BY created_at ASC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, complaintId);
            rs = ps.executeQuery();
            while (rs.next()) {
                ComplaintLog log = new ComplaintLog();
                log.setId(rs.getInt("id"));
                log.setComplaintId(rs.getInt("complaint_id"));
                log.setAction(rs.getString("action"));
                log.setStatusFrom(rs.getString("status_from"));
                log.setStatusTo(rs.getString("status_to"));
                log.setRemarks(rs.getString("remarks"));
                log.setPerformedBy(rs.getString("performed_by"));
                log.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(log);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }

    public boolean deleteComplaint(int id) {
        String sql = "DELETE FROM complaints WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(null, ps, conn);
        }
        return false;
    }

    private Complaint mapComplaint(ResultSet rs) throws SQLException {
        Complaint c = new Complaint();
        c.setId(rs.getInt("id"));
        c.setComplaintCode(rs.getString("complaint_code"));
        c.setCategory(rs.getString("category"));
        c.setTitle(rs.getString("title"));
        c.setDescription(rs.getString("description"));
        c.setLocation(rs.getString("location"));
        c.setWardZone(rs.getString("ward_zone"));
        c.setLatitude(rs.getString("latitude"));
        c.setLongitude(rs.getString("longitude"));
        c.setCitizenName(rs.getString("citizen_name"));
        c.setCitizenPhone(rs.getString("citizen_phone"));
        c.setCitizenEmail(rs.getString("citizen_email"));
        c.setPriority(rs.getString("priority"));
        c.setStatus(rs.getString("status"));

        int dId = rs.getInt("department_id");
        if (!rs.wasNull()) {
            c.setDepartmentId(dId);
        }
        try {
            c.setDepartmentName(rs.getString("department_name"));
        } catch (SQLException ignored) {}

        int oId = rs.getInt("assigned_officer_id");
        if (!rs.wasNull()) {
            c.setAssignedOfficerId(oId);
        }
        try {
            c.setAssignedOfficerName(rs.getString("assigned_officer_name"));
        } catch (SQLException ignored) {}

        c.setContractorAssigned(rs.getString("contractor_assigned"));
        c.setMaterialsUsed(rs.getString("materials_used"));
        c.setRemarks(rs.getString("remarks"));
        c.setResolutionNotes(rs.getString("resolution_notes"));
        c.setCitizenRating(rs.getInt("citizen_rating"));
        c.setCitizenFeedback(rs.getString("citizen_feedback"));
        c.setSlaHours(rs.getInt("sla_hours"));
        c.setCreatedAt(rs.getTimestamp("created_at"));
        c.setUpdatedAt(rs.getTimestamp("updated_at"));
        c.setResolvedAt(rs.getTimestamp("resolved_at"));
        return c;
    }
}

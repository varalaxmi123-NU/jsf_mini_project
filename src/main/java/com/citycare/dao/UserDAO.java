package com.citycare.dao;

import com.citycare.model.User;
import com.citycare.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    public User authenticate(String username, String password) {
        String sql = "SELECT u.id, u.username, u.password, u.full_name, u.role, u.department_id, "
                   + "d.name AS department_name, u.designation, u.email, u.phone, u.address, u.created_at "
                   + "FROM users u "
                   + "LEFT JOIN departments d ON u.department_id = d.id "
                   + "WHERE u.username = ? AND u.password = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, username != null ? username.trim() : "");
            ps.setString(2, password != null ? password.trim() : "");
            rs = ps.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setFullName(rs.getString("full_name"));
                u.setRole(rs.getString("role"));
                int deptId = rs.getInt("department_id");
                if (!rs.wasNull()) {
                    u.setDepartmentId(deptId);
                }
                u.setDepartmentName(rs.getString("department_name"));
                u.setDesignation(rs.getString("designation"));
                u.setEmail(rs.getString("email"));
                u.setPhone(rs.getString("phone"));
                u.setAddress(rs.getString("address"));
                u.setCreatedAt(rs.getTimestamp("created_at"));
                return u;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return null;
    }

    public boolean registerCitizen(User u) {
        String sql = "INSERT INTO users (username, password, full_name, role, designation, email, phone, address) "
                   + "VALUES (?, ?, ?, 'CITIZEN', 'Resident Citizen', ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, u.getUsername().trim());
            ps.setString(2, u.getPassword().trim());
            ps.setString(3, u.getFullName().trim());
            ps.setString(4, u.getEmail() != null ? u.getEmail().trim() : "");
            ps.setString(5, u.getPhone() != null ? u.getPhone().trim() : "");
            ps.setString(6, u.getAddress() != null ? u.getAddress().trim() : "");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(null, ps, conn);
        }
        return false;
    }

    public List<User> getOfficersByDepartment(int deptId) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.id, u.username, u.full_name, u.role, u.department_id, "
                   + "d.name AS department_name, u.designation, u.email, u.phone "
                   + "FROM users u "
                   + "LEFT JOIN departments d ON u.department_id = d.id "
                   + "WHERE u.department_id = ? AND u.role = 'OFFICER' "
                   + "ORDER BY u.full_name ASC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, deptId);
            rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setFullName(rs.getString("full_name"));
                u.setRole(rs.getString("role"));
                u.setDepartmentId(rs.getInt("department_id"));
                u.setDepartmentName(rs.getString("department_name"));
                u.setDesignation(rs.getString("designation"));
                u.setEmail(rs.getString("email"));
                u.setPhone(rs.getString("phone"));
                list.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }

    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.id, u.username, u.full_name, u.role, u.department_id, "
                   + "d.name AS department_name, u.designation, u.email, u.phone, u.address, u.created_at "
                   + "FROM users u "
                   + "LEFT JOIN departments d ON u.department_id = d.id "
                   + "ORDER BY u.role ASC, u.full_name ASC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setFullName(rs.getString("full_name"));
                u.setRole(rs.getString("role"));
                int deptId = rs.getInt("department_id");
                if (!rs.wasNull()) {
                    u.setDepartmentId(deptId);
                }
                u.setDepartmentName(rs.getString("department_name"));
                u.setDesignation(rs.getString("designation"));
                u.setEmail(rs.getString("email"));
                u.setPhone(rs.getString("phone"));
                u.setAddress(rs.getString("address"));
                u.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }
}

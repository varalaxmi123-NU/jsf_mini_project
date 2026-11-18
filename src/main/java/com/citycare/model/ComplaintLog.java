package com.citycare.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

public class ComplaintLog implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int complaintId;
    private String action;
    private String statusFrom;
    private String statusTo;
    private String remarks;
    private String performedBy;
    private Timestamp createdAt;

    public ComplaintLog() {
    }

    public ComplaintLog(int complaintId, String action, String statusFrom, String statusTo, String remarks, String performedBy) {
        this.complaintId = complaintId;
        this.action = action;
        this.statusFrom = statusFrom;
        this.statusTo = statusTo;
        this.remarks = remarks;
        this.performedBy = performedBy;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getComplaintId() {
        return complaintId;
    }

    public void setComplaintId(int complaintId) {
        this.complaintId = complaintId;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getStatusFrom() {
        return statusFrom;
    }

    public void setStatusFrom(String statusFrom) {
        this.statusFrom = statusFrom;
    }

    public String getStatusTo() {
        return statusTo;
    }

    public void setStatusTo(String statusTo) {
        this.statusTo = statusTo;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    public String getPerformedBy() {
        return performedBy;
    }

    public void setPerformedBy(String performedBy) {
        this.performedBy = performedBy;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getFormattedDate() {
        if (createdAt == null) return "";
        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
        return sdf.format(createdAt);
    }
}

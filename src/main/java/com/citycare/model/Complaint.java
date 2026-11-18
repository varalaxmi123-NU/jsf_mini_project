package com.citycare.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

public class Complaint implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String complaintCode;
    private String category;
    private String title;
    private String description;
    private String location;
    private String wardZone;
    private String latitude;
    private String longitude;
    private String citizenName;
    private String citizenPhone;
    private String citizenEmail;
    private String priority; // LOW, MEDIUM, HIGH, URGENT
    private String status;   // PENDING, UNDER_REVIEW, IN_PROGRESS, RESOLVED, REJECTED
    private Integer departmentId;
    private String departmentName;
    private Integer assignedOfficerId;
    private String assignedOfficerName;
    private String contractorAssigned;
    private String materialsUsed;
    private String remarks;
    private String resolutionNotes;
    private int citizenRating; // 1 to 5
    private String citizenFeedback;
    private int slaHours; // e.g. 24, 48, 72
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Timestamp resolvedAt;

    public Complaint() {
        this.slaHours = 48;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getComplaintCode() {
        return complaintCode;
    }

    public void setComplaintCode(String complaintCode) {
        this.complaintCode = complaintCode;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getWardZone() {
        return wardZone;
    }

    public void setWardZone(String wardZone) {
        this.wardZone = wardZone;
    }

    public String getLatitude() {
        return latitude;
    }

    public void setLatitude(String latitude) {
        this.latitude = latitude;
    }

    public String getLongitude() {
        return longitude;
    }

    public void setLongitude(String longitude) {
        this.longitude = longitude;
    }

    public String getCitizenName() {
        return citizenName;
    }

    public void setCitizenName(String citizenName) {
        this.citizenName = citizenName;
    }

    public String getCitizenPhone() {
        return citizenPhone;
    }

    public void setCitizenPhone(String citizenPhone) {
        this.citizenPhone = citizenPhone;
    }

    public String getCitizenEmail() {
        return citizenEmail;
    }

    public void setCitizenEmail(String citizenEmail) {
        this.citizenEmail = citizenEmail;
    }

    public String getPriority() {
        return priority != null ? priority : "MEDIUM";
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }

    public String getStatus() {
        return status != null ? status : "PENDING";
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(Integer departmentId) {
        this.departmentId = departmentId;
    }

    public String getDepartmentName() {
        return departmentName;
    }

    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
    }

    public Integer getAssignedOfficerId() {
        return assignedOfficerId;
    }

    public void setAssignedOfficerId(Integer assignedOfficerId) {
        this.assignedOfficerId = assignedOfficerId;
    }

    public String getAssignedOfficerName() {
        return assignedOfficerName;
    }

    public void setAssignedOfficerName(String assignedOfficerName) {
        this.assignedOfficerName = assignedOfficerName;
    }

    public String getContractorAssigned() {
        return contractorAssigned;
    }

    public void setContractorAssigned(String contractorAssigned) {
        this.contractorAssigned = contractorAssigned;
    }

    public String getMaterialsUsed() {
        return materialsUsed;
    }

    public void setMaterialsUsed(String materialsUsed) {
        this.materialsUsed = materialsUsed;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    public String getResolutionNotes() {
        return resolutionNotes;
    }

    public void setResolutionNotes(String resolutionNotes) {
        this.resolutionNotes = resolutionNotes;
    }

    public int getCitizenRating() {
        return citizenRating;
    }

    public void setCitizenRating(int citizenRating) {
        this.citizenRating = citizenRating;
    }

    public String getCitizenFeedback() {
        return citizenFeedback;
    }

    public void setCitizenFeedback(String citizenFeedback) {
        this.citizenFeedback = citizenFeedback;
    }

    public int getSlaHours() {
        return slaHours > 0 ? slaHours : 48;
    }

    public void setSlaHours(int slaHours) {
        this.slaHours = slaHours;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public Timestamp getResolvedAt() {
        return resolvedAt;
    }

    public void setResolvedAt(Timestamp resolvedAt) {
        this.resolvedAt = resolvedAt;
    }

    // Presentation helpers
    public String getStatusBadgeClass() {
        if (status == null) return "badge-pending";
        switch (status.toUpperCase()) {
            case "PENDING":
                return "badge-pending";
            case "UNDER_REVIEW":
                return "badge-review";
            case "IN_PROGRESS":
                return "badge-progress";
            case "RESOLVED":
                return "badge-resolved";
            case "REJECTED":
                return "badge-rejected";
            default:
                return "badge-default";
        }
    }

    public String getPriorityBadgeClass() {
        if (priority == null) return "priority-medium";
        switch (priority.toUpperCase()) {
            case "URGENT":
                return "priority-urgent";
            case "HIGH":
                return "priority-high";
            case "MEDIUM":
                return "priority-medium";
            case "LOW":
                return "priority-low";
            default:
                return "priority-medium";
        }
    }

    public String getSlaRemainingLabel() {
        if ("RESOLVED".equalsIgnoreCase(status)) {
            return "Resolved within SLA";
        }
        if (createdAt == null) return "Active SLA";
        long elapsedMs = System.currentTimeMillis() - createdAt.getTime();
        long elapsedHours = elapsedMs / (1000 * 60 * 60);
        long remaining = getSlaHours() - elapsedHours;
        if (remaining <= 0) {
            return "SLA Breached (" + Math.abs(remaining) + "h overdue)";
        }
        return remaining + "h remaining";
    }

    public String getSlaRemainingClass() {
        if ("RESOLVED".equalsIgnoreCase(status)) return "badge-resolved";
        if (createdAt == null) return "badge-default";
        long elapsedMs = System.currentTimeMillis() - createdAt.getTime();
        long elapsedHours = elapsedMs / (1000 * 60 * 60);
        if (elapsedHours > getSlaHours()) return "badge-rejected";
        if (getSlaHours() - elapsedHours < 12) return "badge-pending";
        return "badge-progress";
    }

    public String getFormattedCreatedAt() {
        if (createdAt == null) return "N/A";
        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
        return sdf.format(createdAt);
    }

    public String getFormattedResolvedAt() {
        if (resolvedAt == null) return "In Progress";
        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
        return sdf.format(resolvedAt);
    }

    public String getStatusLabel() {
        if (status == null) return "Pending";
        switch (status.toUpperCase()) {
            case "PENDING": return "Pending";
            case "UNDER_REVIEW": return "Under Review";
            case "IN_PROGRESS": return "In Progress";
            case "RESOLVED": return "Resolved";
            case "REJECTED": return "Rejected";
            default: return status.replace("_", " ");
        }
    }

    public String getFormattedDate() {
        return getFormattedCreatedAt();
    }
}

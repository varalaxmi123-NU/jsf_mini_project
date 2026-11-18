/**
 * CityCare - Smart City Complaint Management System
 * Client-Side Interactivity
 */

document.addEventListener('DOMContentLoaded', function () {
    // Initialize Modal triggers
    initModals();

    // Initialize Auto-filtering on data tables if available
    initTableSearch();

    // Auto-dismiss alerts after 5 seconds
    initAlerts();
});

function initModals() {
    window.openModal = function (modalId) {
        var modal = document.getElementById(modalId);
        if (modal) {
            modal.classList.add('active');
            document.body.style.overflow = 'hidden';
        }
    };

    window.closeModal = function (modalId) {
        var modal = document.getElementById(modalId);
        if (modal) {
            modal.classList.remove('active');
            document.body.style.overflow = 'auto';
        }
    };

    // Close on overlay click
    document.querySelectorAll('.modal-overlay').forEach(function (overlay) {
        overlay.addEventListener('click', function (e) {
            if (e.target === overlay) {
                overlay.classList.remove('active');
                document.body.style.overflow = 'auto';
            }
        });
    });

    // Close on Escape key
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') {
            document.querySelectorAll('.modal-overlay.active').forEach(function (modal) {
                modal.classList.remove('active');
            });
            document.body.style.overflow = 'auto';
        }
    });
}

function openOfficerStatusModal(complaintId, currentStatus, currentRemarks) {
    var idInput = document.getElementById('modalComplaintId');
    var statusSelect = document.getElementById('modalNewStatus');
    var remarksText = document.getElementById('modalRemarks');
    var resNotesGroup = document.getElementById('modalResolutionGroup');

    if (idInput) idInput.value = complaintId;
    if (statusSelect) {
        statusSelect.value = currentStatus;
        toggleResolutionNotes(statusSelect.value);
    }
    if (remarksText) remarksText.value = currentRemarks || '';

    window.openModal('officerStatusModal');
}

function toggleResolutionNotes(status) {
    var resGroup = document.getElementById('modalResolutionGroup');
    if (resGroup) {
        if (status === 'RESOLVED') {
            resGroup.style.display = 'block';
        } else {
            resGroup.style.display = 'none';
        }
    }
}

function openAdminAssignModal(complaintId, currentDeptId, currentOfficerId) {
    var idInput = document.getElementById('assignComplaintId');
    var deptSelect = document.getElementById('assignDeptSelect');
    var officerSelect = document.getElementById('assignOfficerSelect');

    if (idInput) idInput.value = complaintId;
    if (deptSelect && currentDeptId) deptSelect.value = currentDeptId;
    if (officerSelect && currentOfficerId) officerSelect.value = currentOfficerId;

    window.openModal('adminAssignModal');
}

function initTableSearch() {
    var searchInput = document.getElementById('tableSearchInput');
    if (searchInput) {
        searchInput.addEventListener('input', function () {
            var filter = searchInput.value.toLowerCase();
            var rows = document.querySelectorAll('.filterable-table tbody tr');
            rows.forEach(function (row) {
                var text = row.textContent.toLowerCase();
                if (text.indexOf(filter) > -1) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        });
    }
}

function initAlerts() {
    var alerts = document.querySelectorAll('.alert');
    if (alerts.length > 0) {
        setTimeout(function () {
            alerts.forEach(function (alert) {
                alert.style.transition = 'opacity 0.5s ease';
                alert.style.opacity = '0';
                setTimeout(function () {
                    alert.remove();
                }, 500);
            });
        }, 5000);
    }
}

function validateComplaintForm() {
    var phone = document.getElementById('citizenPhone');
    if (phone) {
        var cleanPhone = phone.value.replace(/[^0-9]/g, '');
        if (cleanPhone.length < 10) {
            alert('Please enter a valid 10-digit phone number for SMS tracking updates.');
            phone.focus();
            return false;
        }
    }
    return true;
}

function selectCategory(categoryName, deptId) {
    var catSelect = document.getElementById('category');
    var deptSelect = document.getElementById('departmentId');
    if (catSelect) {
        catSelect.value = categoryName;
    }
    if (deptSelect && deptId) {
        deptSelect.value = deptId;
    }
    var formSection = document.getElementById('complaintFormCard');
    if (formSection) {
        formSection.scrollIntoView({ behavior: 'smooth' });
    }
}

function printReceipt() {
    window.print();
}

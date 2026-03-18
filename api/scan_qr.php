<?php
require_once 'config.php';

// Get POST data
$data = json_decode(file_get_contents('php://input'), true);

if (!isset($data['participantID']) || !isset($data['coach_username'])) {
    sendResponse(false, 'Participant ID and coach username are required');
}

$participantID = $data['participantID'];
$coach_username = $data['coach_username'];
$checkpoint = isset($data['checkpoint']) ? $data['checkpoint'] : 'gate';

// Always fetch coach's sport_category and role directly from DB — never trust client
$conn = getDBConnection();

$admin_stmt = $conn->prepare("SELECT sport_category, role FROM admin WHERE username = ?");
$admin_stmt->bind_param("s", $coach_username);
$admin_stmt->execute();
$admin_result = $admin_stmt->get_result();

if ($admin_result->num_rows === 0) {
    sendResponse(false, 'Coach account not found');
}

$admin_data = $admin_result->fetch_assoc();
$coach_sport_category = $admin_data['sport_category'];
$coach_role = $admin_data['role'];
$admin_stmt->close();

// Get student info
$stmt = $conn->prepare("SELECT id, participantID, fullname, division, event, participant_type FROM students WHERE participantID = ?");
$stmt->bind_param("s", $participantID);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    sendResponse(false, 'Participant not found');
}

$student = $result->fetch_assoc();

// Check sport category match — skip only for superadmin
if ($coach_role !== 'superadmin' && $coach_role !== 'admin') {
    if (empty($coach_sport_category) || strtoupper(trim($student['event'])) !== strtoupper(trim($coach_sport_category))) {
        sendResponse(false, "You are not the coach of this athlete. Your sport: " . ($coach_sport_category ?? 'N/A') . ", Athlete's sport: {$student['event']}", [
            'student' => $student
        ]);
    }
}
$student_id = $student['id'];
$today = date('Y-m-d');
$now = date('Y-m-d H:i:s');

// Check today's attendance record
$check_stmt = $conn->prepare("SELECT id, time_in, time_out, status FROM attendance WHERE student_id = ? AND date = ? ORDER BY time_in DESC LIMIT 1");
$check_stmt->bind_param("is", $student_id, $today);
$check_stmt->execute();
$check_result = $check_stmt->get_result();

if ($check_result->num_rows === 0) {
    // No attendance record for today
    sendResponse(false, 'No attendance record found for today. Please time in first at billeting.');
}

$attendance = $check_result->fetch_assoc();
$attendance_id = $attendance['id'];

// Check if athlete has timed in but NOT timed out yet
if ($attendance['time_out'] === null) {
    sendResponse(false, 'Athlete is still inside Billeting, please time out first', [
        'student' => $student,
        'time_in' => $attendance['time_in'],
        'status' => $attendance['status']
    ]);
}

// Check if athlete is already onsite
if ($attendance['status'] === 'onsite') {
    sendResponse(false, 'Athlete already on site', [
        'student' => $student,
        'time_in' => $attendance['time_in'],
        'time_out' => $attendance['time_out'],
        'status' => 'onsite'
    ]);
}

// Athlete has timed in AND timed out (offsite), now change to onsite
$update_stmt = $conn->prepare("UPDATE attendance SET status = 'onsite', last_checkpoint = ? WHERE id = ?");
$update_stmt->bind_param("si", $checkpoint, $attendance_id);
$update_stmt->execute();

// Log the action
$log_stmt = $conn->prepare("INSERT INTO attendance_audit_log (attendance_id, student_id, action, scanned_by, checkpoint, scan_time, notes) VALUES (?, ?, 'time_in', ?, ?, ?, 'Status changed from offsite to onsite')");
$scanned_by = 'coach_' . $coach_username;
$log_stmt->bind_param("iisss", $attendance_id, $student_id, $scanned_by, $checkpoint, $now);
$log_stmt->execute();

sendResponse(true, 'Athlete is now on-site', [
    'action' => 'status_change',
    'student' => $student,
    'time_in' => $attendance['time_in'],
    'time_out' => $attendance['time_out'],
    'scan_time' => $now,
    'checkpoint' => $checkpoint,
    'old_status' => 'offsite',
    'new_status' => 'onsite'
]);

$stmt->close();
$conn->close();
?>

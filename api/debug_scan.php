<?php
require_once 'config.php';

$data = json_decode(file_get_contents('php://input'), true);

$coach_username = $data['coach_username'] ?? 'basketball_coach';
$participantID  = $data['participantID']  ?? '';

$conn = getDBConnection();

// Step 1: Get coach info
$admin_stmt = $conn->prepare("SELECT username, role, sport_category FROM admin WHERE username = ?");
$admin_stmt->bind_param("s", $coach_username);
$admin_stmt->execute();
$admin_data = $admin_stmt->get_result()->fetch_assoc();

// Step 2: Get student info
$student = null;
if ($participantID) {
    $s_stmt = $conn->prepare("SELECT id, fullname, event FROM students WHERE participantID = ?");
    $s_stmt->bind_param("s", $participantID);
    $s_stmt->execute();
    $student = $s_stmt->get_result()->fetch_assoc();
}

// Step 3: Simulate the check
$would_pass = null;
$reason     = null;
if ($admin_data && $student) {
    $role     = $admin_data['role'];
    $sport    = $admin_data['sport_category'];
    $event    = $student['event'];

    if ($role === 'superadmin' || $role === 'admin') {
        $would_pass = true;
        $reason = "Role is '$role' — bypass check";
    } elseif (empty($sport)) {
        $would_pass = false;
        $reason = "Coach has no sport_category set in DB";
    } elseif (strtoupper(trim($event)) === strtoupper(trim($sport))) {
        $would_pass = true;
        $reason = "Match: coach sport '$sport' == athlete event '$event'";
    } else {
        $would_pass = false;
        $reason = "Mismatch: coach sport '$sport' != athlete event '$event'";
    }
}

echo json_encode([
    'coach'      => $admin_data,
    'student'    => $student,
    'would_pass' => $would_pass,
    'reason'     => $reason,
], JSON_PRETTY_PRINT);
?>

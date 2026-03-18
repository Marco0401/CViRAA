<?php
require_once 'config.php';

// Get POST data
$data = json_decode(file_get_contents('php://input'), true);

if (!isset($data['coach_username'])) {
    sendResponse(false, 'Coach username is required');
}

$coach_username = $data['coach_username'];
$today = date('Y-m-d');

$conn = getDBConnection();

// Get athletes scanned by this coach today (status changed to onsite)
$stmt = $conn->prepare("
    SELECT 
        s.id,
        s.participantID,
        s.fullname,
        s.division,
        s.event,
        s.participant_type,
        a.time_in,
        a.time_out,
        a.status,
        aal.scan_time,
        aal.checkpoint
    FROM attendance_audit_log aal
    INNER JOIN students s ON aal.student_id = s.id
    INNER JOIN attendance a ON aal.attendance_id = a.id
    WHERE aal.scanned_by = ?
    AND DATE(aal.scan_time) = ?
    AND aal.notes LIKE '%offsite to onsite%'
    ORDER BY aal.scan_time DESC
");

$scanned_by = 'coach_' . $coach_username;
$stmt->bind_param("ss", $scanned_by, $today);
$stmt->execute();
$result = $stmt->get_result();

$athletes = [];
while ($row = $result->fetch_assoc()) {
    $athletes[] = $row;
}

sendResponse(true, 'Scanned athletes retrieved', [
    'count' => count($athletes),
    'athletes' => $athletes
]);

$stmt->close();
$conn->close();
?>

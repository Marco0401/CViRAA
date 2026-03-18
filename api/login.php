<?php
require_once 'config.php';

// Get POST data
$data = json_decode(file_get_contents('php://input'), true);

if (!isset($data['username']) || !isset($data['password'])) {
    sendResponse(false, 'Username and password are required');
}

$username = $data['username'];
$password = $data['password'];

$conn = getDBConnection();

// Prepare statement to prevent SQL injection
$stmt = $conn->prepare("SELECT id, username, password, profile_picture, full_name, role FROM admin WHERE username = ?");
$stmt->bind_param("s", $username);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    sendResponse(false, 'Invalid username or password');
}

$user = $result->fetch_assoc();

// Verify password
if (!password_verify($password, $user['password'])) {
    sendResponse(false, 'Invalid username or password');
}

// Remove password from response
unset($user['password']);

// Log the login action
$log_stmt = $conn->prepare("INSERT INTO admin_action_log (admin_id, admin_username, action_type, description) VALUES (?, ?, 'login', 'User logged in')");
$log_stmt->bind_param("is", $user['id'], $user['username']);
$log_stmt->execute();

sendResponse(true, 'Login successful', $user);

$stmt->close();
$conn->close();
?>

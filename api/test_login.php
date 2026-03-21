<?php
require_once 'config.php';

$conn = getDBConnection();

$username = isset($_GET['u']) ? $_GET['u'] : 'sepaktakraw_coach';
$password = isset($_GET['p']) ? $_GET['p'] : 'deped123';

$stmt = $conn->prepare("SELECT username, password, plain_password FROM admin WHERE username = ?");
$stmt->bind_param("s", $username);
$stmt->execute();
$result = $stmt->get_result();
$user = $result->fetch_assoc();

if (!$user) {
    echo json_encode(['error' => 'User not found']);
    exit;
}

echo json_encode([
    'username'       => $user['username'],
    'plain_password' => $user['plain_password'],
    'testing_with'   => $password,
    'verify_result'  => password_verify($password, $user['password']),
    'hash_preview'   => substr($user['password'], 0, 20) . '...',
]);
?>

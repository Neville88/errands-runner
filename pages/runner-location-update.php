<?php

declare(strict_types=1);

require_once __DIR__ . '/../includes/auth.php';

header('Content-Type: application/json');

if (!is_logged_in()) {
    http_response_code(401);
    echo json_encode(['ok' => false, 'error' => 'Not authenticated.']);
    exit;
}

$user = current_user();
if ($user['role'] !== 'runner') {
    http_response_code(403);
    echo json_encode(['ok' => false, 'error' => 'Only runners can share live location.']);
    exit;
}

if (!request_method_is('POST')) {
    http_response_code(405);
    echo json_encode(['ok' => false, 'error' => 'Invalid method.']);
    exit;
}

$requestId = (int) ($_POST['request_id'] ?? 0);
$lat = (float) ($_POST['lat'] ?? 0);
$lng = (float) ($_POST['lng'] ?? 0);

if ($requestId <= 0) {
    http_response_code(422);
    echo json_encode(['ok' => false, 'error' => 'Missing request id.']);
    exit;
}

if ($lat === 0.0 && $lng === 0.0) {
    http_response_code(422);
    echo json_encode(['ok' => false, 'error' => 'Invalid coordinates.']);
    exit;
}

if ($lat < -90 || $lat > 90 || $lng < -180 || $lng > 180) {
    http_response_code(422);
    echo json_encode(['ok' => false, 'error' => 'Coordinates out of range.']);
    exit;
}

$assignment = fetch_assignment_by_request_id($requestId);
if ($assignment === null || (int) $assignment['runner_id'] !== (int) $user['id']) {
    http_response_code(403);
    echo json_encode(['ok' => false, 'error' => 'You are not assigned to this request.']);
    exit;
}

if (!in_array($assignment['status'], ['assigned', 'in_progress'], true)) {
    http_response_code(422);
    echo json_encode(['ok' => false, 'error' => 'Location updates are only allowed while the job is active.']);
    exit;
}

$updated = execute_query(
    'UPDATE assignments SET current_lat = :lat, current_lng = :lng, last_location_at = NOW() WHERE id = :id',
    [
        'lat' => $lat,
        'lng' => $lng,
        'id' => $assignment['id'],
    ]
);

if (!$updated) {
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => 'Failed to store location.']);
    exit;
}

echo json_encode([
    'ok' => true,
    'lat' => $lat,
    'lng' => $lng,
    'last_location_at' => date('Y-m-d H:i:s'),
]);


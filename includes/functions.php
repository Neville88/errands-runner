<?php

declare(strict_types=1);

require_once __DIR__ . '/config.php';
require_once __DIR__ . '/../database/config/database.php';

function app_url(string $path = ''): string
{
    $base = rtrim(APP_URL, '/');
    $path = ltrim($path, '/');
    return $path === '' ? $base : $base . '/' . $path;
}

function asset_url(string $path = ''): string
{
    return app_url('assets/' . ltrim($path, '/'));
}

function page_url(string $path = ''): string
{
    return app_url('pages/' . ltrim($path, '/'));
}

function h(null|int|float|string $value): string
{
    return htmlspecialchars((string) $value, ENT_QUOTES, 'UTF-8');
}

function redirect(string $path): never
{
    $target = preg_match('/^https?:\/\//i', $path) ? $path : app_url($path);
    header('Location: ' . $target);
    exit;
}

function request_method_is(string $method): bool
{
    return strtoupper($_SERVER['REQUEST_METHOD'] ?? 'GET') === strtoupper($method);
}

function current_user(): ?array
{
    return $_SESSION['auth_user'] ?? null;
}

function current_user_id(): ?int
{
    return isset($_SESSION['auth_user']['id']) ? (int) $_SESSION['auth_user']['id'] : null;
}

function is_logged_in(): bool
{
    return current_user() !== null;
}

function has_role(string|array $roles): bool
{
    $user = current_user();
    return $user !== null && in_array($user['role'], (array) $roles, true);
}

function role_label(string $role): string
{
    return USER_ROLES[$role] ?? ucwords(str_replace('_', ' ', $role));
}

function request_type_label(string $type): string
{
    return REQUEST_TYPES[$type] ?? ucwords(str_replace('_', ' ', $type));
}

function status_label(string $status): string
{
    return REQUEST_STATUSES[$status] ?? QUOTATION_STATUSES[$status] ?? ASSIGNMENT_STATUSES[$status] ?? TRANSACTION_STATUSES[$status] ?? ucwords(str_replace('_', ' ', $status));
}

function payment_method_label(string $method): string
{
    return PAYMENT_METHODS[$method] ?? ucwords(str_replace('_', ' ', $method));
}

function role_dashboard_path(string $role): string
{
    return match ($role) {
        'seller' => 'pages/seller-dashboard.php',
        'buyer' => 'pages/buyer-dashboard.php',
        'runner' => 'pages/runner-dashboard.php',
        'admin' => 'pages/admin-dashboard.php',
        default => 'pages/dashboard.php',
    };
}

function money(float|int|string|null $amount): string
{
    return APP_CURRENCY . ' ' . number_format((float) $amount, 2);
}

function send_email_prompt(string $to, string $subject, string $body): void
{
    if ($to === '') {
        return;
    }

    $encodedSubject = '=?UTF-8?B?' . base64_encode($subject) . '?=';
    $headers = [];
    $headers[] = 'From: ' . (APP_MAIL_FROM_NAME !== '' ? APP_MAIL_FROM_NAME : APP_NAME) . ' <' . APP_SUPPORT_EMAIL . '>';
    $headers[] = 'Reply-To: ' . APP_SUPPORT_EMAIL;
    $headers[] = 'Content-Type: text/plain; charset=UTF-8';

    @mail($to, $encodedSubject, $body, implode("\r\n", $headers));
}

function send_sms_prompt(string $phone, string $message): void
{
    // Placeholder for SMS gateway integration (e.g. Twilio, Africa's Talking).
    // Intentionally left as a no-op so the system remains functional without external credentials.
}

function fetch_one(string $sql, array $params = []): ?array
{
    $statement = db()->prepare($sql);
    $statement->execute($params);
    $result = $statement->fetch();
    return $result === false ? null : $result;
}

function fetch_all(string $sql, array $params = []): array
{
    $statement = db()->prepare($sql);
    $statement->execute($params);
    return $statement->fetchAll();
}

function execute_query(string $sql, array $params = []): bool
{
    $statement = db()->prepare($sql);
    return $statement->execute($params);
}

function count_by_query(string $sql, array $params = []): int
{
    $row = fetch_one($sql, $params);
    return (int) ($row['aggregate'] ?? 0);
}

function build_upload_directory(string $directory): void
{
    if (!is_dir($directory)) {
        mkdir($directory, 0777, true);
    }
}

function normalize_upload_path(string $directory, string $filename): string
{
    build_upload_directory($directory);
    return rtrim($directory, '/\\') . DIRECTORY_SEPARATOR . $filename;
}

function upload_image(array $file, string $directory, array &$errors, string $label = 'file'): ?string
{
    if (($file['error'] ?? UPLOAD_ERR_NO_FILE) === UPLOAD_ERR_NO_FILE) {
        return null;
    }
    if (($file['error'] ?? UPLOAD_ERR_NO_FILE) !== UPLOAD_ERR_OK) {
        $errors[] = 'Unable to upload the ' . $label . '.';
        return null;
    }
    if (($file['size'] ?? 0) > UPLOAD_MAX_SIZE) {
        $errors[] = ucfirst($label) . ' must be smaller than 5MB.';
        return null;
    }

    $tmpName = (string) ($file['tmp_name'] ?? '');
    $mimeType = (new finfo(FILEINFO_MIME_TYPE))->file($tmpName);
    $extensions = [
        'image/jpeg' => 'jpg',
        'image/png' => 'png',
        'image/webp' => 'webp',
        'image/gif' => 'gif',
    ];

    if (!isset($extensions[$mimeType])) {
        $errors[] = ucfirst($label) . ' must be a JPG, PNG, WEBP, or GIF image.';
        return null;
    }

    $filename = uniqid('upload_', true) . '.' . $extensions[$mimeType];
    $targetPath = normalize_upload_path($directory, $filename);
    if (!move_uploaded_file($tmpName, $targetPath)) {
        $errors[] = 'Unable to save the ' . $label . ' to storage.';
        return null;
    }

    return basename($directory) . '/' . $filename;
}

function upload_url(?string $relativePath): ?string
{
    if ($relativePath === null || $relativePath === '') {
        return null;
    }

    return asset_url('uploads/' . ltrim(str_replace('\\', '/', $relativePath), '/'));
}

function user_select_sql(): string
{
    return 'SELECT u.id, u.full_name, u.email, u.phone, u.password_hash, u.is_active, u.last_login_at, u.created_at,
                r.role_key AS role,
                p.address_line, p.city, p.state_region, p.postal_code, p.bio, p.profile_image
            FROM users u
            INNER JOIN roles r ON r.id = u.role_id
            LEFT JOIN profiles p ON p.user_id = u.id';
}

function fetch_user_by_email(string $email): ?array
{
    return fetch_one(user_select_sql() . ' WHERE u.email = :email LIMIT 1', ['email' => $email]);
}

function fetch_user_by_id(int $id): ?array
{
    return fetch_one(user_select_sql() . ' WHERE u.id = :id LIMIT 1', ['id' => $id]);
}

function hydrate_user_session(int $userId): void
{
    $user = fetch_user_by_id($userId);
    if ($user !== null) {
        unset($user['password_hash']);
        $_SESSION['auth_user'] = $user;
    }
}

function list_users(?string $role = null): array
{
    $sql = user_select_sql();
    $params = [];
    if ($role !== null && $role !== '') {
        $sql .= ' WHERE r.role_key = :role_key';
        $params['role_key'] = $role;
    }
    $sql .= ' ORDER BY u.created_at DESC';
    return fetch_all($sql, $params);
}

function platform_snapshot(): array
{
    return [
        'users' => count_by_query('SELECT COUNT(*) AS aggregate FROM users WHERE is_active = 1'),
        'requests' => count_by_query('SELECT COUNT(*) AS aggregate FROM requests'),
        'completed_deliveries' => count_by_query('SELECT COUNT(*) AS aggregate FROM requests WHERE status IN ("completed", "confirmed")'),
        'active_runners' => count_by_query('SELECT COUNT(*) AS aggregate FROM users u INNER JOIN roles r ON r.id = u.role_id WHERE r.role_key = "runner" AND u.is_active = 1'),
    ];
}

function featured_runners(int $limit = 3): array
{
    return fetch_all(
        'SELECT u.id,
                u.full_name,
                u.email,
                u.phone,
                p.city,
                p.state_region,
                p.bio,
                p.profile_image,
                COALESCE(ROUND(AVG(rr.rating), 1), 0) AS average_rating,
                COUNT(DISTINCT rr.id) AS review_count,
                COUNT(DISTINCT a_done.request_id) AS completed_jobs,
                COUNT(DISTINCT a_active.request_id) AS active_jobs
         FROM users u
         INNER JOIN roles r ON r.id = u.role_id AND r.role_key = "runner"
         LEFT JOIN profiles p ON p.user_id = u.id
         LEFT JOIN runner_reviews rr ON rr.runner_id = u.id
         LEFT JOIN assignments a_done ON a_done.runner_id = u.id AND a_done.status IN ("completed", "confirmed")
         LEFT JOIN assignments a_active ON a_active.runner_id = u.id AND a_active.status IN ("assigned", "in_progress")
         WHERE u.is_active = 1
         GROUP BY u.id, u.full_name, u.email, u.phone, p.city, p.state_region, p.bio, p.profile_image
         ORDER BY average_rating DESC, review_count DESC, completed_jobs DESC, active_jobs ASC, u.full_name ASC
         LIMIT ' . (int) $limit
    );
}

function nearest_runners_for_request(array $request, int $limit = 5): array
{
    $requesterId = (int) $request['requester_id'];

    return fetch_all(
        'SELECT runner.id,
                runner.full_name,
                runner.email,
                runner.phone,
                p_runner.city,
                p_runner.state_region,
                p_runner.bio,
                p_runner.profile_image,
                COALESCE(ROUND(AVG(rr.rating), 1), 0) AS average_rating,
                COUNT(DISTINCT rr.id) AS review_count,
                COUNT(DISTINCT a_done.request_id) AS completed_jobs,
                COUNT(DISTINCT a_active.request_id) AS active_jobs,
                CASE
                    WHEN p_runner.city IS NOT NULL
                         AND p_req.city IS NOT NULL
                         AND p_runner.city = p_req.city
                         AND p_runner.state_region = p_req.state_region THEN 0
                    WHEN p_runner.state_region IS NOT NULL
                         AND p_req.state_region IS NOT NULL
                         AND p_runner.state_region = p_req.state_region THEN 1
                    ELSE 2
                END AS location_rank
         FROM users runner
         INNER JOIN roles r ON r.id = runner.role_id AND r.role_key = "runner"
         LEFT JOIN profiles p_runner ON p_runner.user_id = runner.id
         INNER JOIN users requester ON requester.id = :requester_id
         LEFT JOIN profiles p_req ON p_req.user_id = requester.id
         LEFT JOIN runner_reviews rr ON rr.runner_id = runner.id
         LEFT JOIN assignments a_done ON a_done.runner_id = runner.id AND a_done.status IN ("completed", "confirmed")
         LEFT JOIN assignments a_active ON a_active.runner_id = runner.id AND a_active.status IN ("assigned", "in_progress")
         WHERE runner.is_active = 1
         GROUP BY runner.id, runner.full_name, runner.email, runner.phone, p_runner.city, p_runner.state_region, p_runner.bio, p_runner.profile_image, location_rank
         ORDER BY location_rank ASC, average_rating DESC, review_count DESC, completed_jobs DESC, active_jobs ASC, runner.full_name ASC
         LIMIT ' . (int) $limit,
        ['requester_id' => $requesterId]
    );
}

function homepage_testimonials(int $limit = 6): array
{
    return fetch_all(
        'SELECT rr.*, reviewer.full_name AS reviewer_name, runner.full_name AS runner_name, req.title AS request_title
         FROM runner_reviews rr
         INNER JOIN users reviewer ON reviewer.id = rr.reviewer_id
         INNER JOIN users runner ON runner.id = rr.runner_id
         INNER JOIN requests req ON req.id = rr.request_id
         ORDER BY rr.created_at DESC
         LIMIT ' . (int) $limit
    );
}

function update_user_profile(int $userId, array $data, ?string $profileImage = null): bool
{
    $pdo = db();
    $pdo->beginTransaction();

    try {
        $pdo->prepare('UPDATE users SET full_name = :full_name, phone = :phone WHERE id = :id')->execute([
            'id' => $userId,
            'full_name' => $data['full_name'],
            'phone' => $data['phone'],
        ]);

        $existing = fetch_one('SELECT profile_image FROM profiles WHERE user_id = :user_id LIMIT 1', ['user_id' => $userId]);
        $pdo->prepare('UPDATE profiles SET address_line = :address_line, city = :city, state_region = :state_region, postal_code = :postal_code, bio = :bio, profile_image = :profile_image WHERE user_id = :user_id')->execute([
            'user_id' => $userId,
            'address_line' => $data['address_line'],
            'city' => $data['city'],
            'state_region' => $data['state_region'],
            'postal_code' => $data['postal_code'],
            'bio' => $data['bio'],
            'profile_image' => $profileImage ?? ($existing['profile_image'] ?? null),
        ]);

        $pdo->commit();
        hydrate_user_session($userId);
        return true;
    } catch (Throwable $throwable) {
        $pdo->rollBack();
        throw $throwable;
    }
}

function store_contact_message(array $data): bool
{
    return execute_query('INSERT INTO contact_messages (name, email, phone, subject, message, status) VALUES (:name, :email, :phone, :subject, :message, :status)', [
        'name' => $data['name'],
        'email' => $data['email'],
        'phone' => $data['phone'],
        'subject' => $data['subject'],
        'message' => $data['message'],
        'status' => 'new',
    ]);
}

function unread_notification_count(int $userId): int
{
    return count_by_query('SELECT COUNT(*) AS aggregate FROM notifications WHERE user_id = :user_id AND is_read = 0', ['user_id' => $userId]);
}

function create_notification(int $userId, string $title, string $message, string $link = ''): void
{
    execute_query('INSERT INTO notifications (user_id, title, message, link_url) VALUES (:user_id, :title, :message, :link_url)', [
        'user_id' => $userId,
        'title' => $title,
        'message' => $message,
        'link_url' => $link,
    ]);

    $user = fetch_user_by_id($userId);
    if ($user === null) {
        return;
    }

    $url = '';
    if ($link !== '') {
        $url = preg_match('/^https?:\\/\\//i', $link) ? $link : app_url(ltrim($link, '/'));
    }

    $emailBody = $message;
    if ($url !== '') {
        $emailBody .= "\n\nOpen: " . $url;
    }

    send_email_prompt((string) $user['email'], $title, $emailBody);

    $smsMessage = $title . ': ' . $message;
    if ($url !== '') {
        $smsMessage .= ' ' . $url;
    }
    send_sms_prompt((string) $user['phone'], $smsMessage);
}

function list_notifications_for_user(array $user): array
{
    if ($user['role'] === 'admin') {
        return fetch_all('SELECT n.*, u.full_name FROM notifications n INNER JOIN users u ON u.id = n.user_id ORDER BY n.created_at DESC LIMIT 200');
    }

    return fetch_all('SELECT n.*, u.full_name FROM notifications n INNER JOIN users u ON u.id = n.user_id WHERE n.user_id = :user_id ORDER BY n.created_at DESC', ['user_id' => $user['id']]);
}

function mark_notifications_read(int $userId): void
{
    execute_query('UPDATE notifications SET is_read = 1 WHERE user_id = :user_id', ['user_id' => $userId]);
}

function request_select_sql(): string
{
    return 'SELECT req.*, requester.full_name AS requester_name, requester.email AS requester_email,
                roles.role_key AS requester_role,
                item.item_name AS primary_item_name, item.quantity AS primary_item_quantity, item.image_path AS primary_item_image,
                assignment.runner_id AS assigned_runner_id, assignment.status AS assignment_status,
                assignment.proof_image_path, assignment.proof_note,
                runner.full_name AS runner_name,
                quote.id AS approved_quotation_id, quote.amount AS approved_quote_amount
            FROM requests req
            INNER JOIN users requester ON requester.id = req.requester_id
            INNER JOIN roles ON roles.id = requester.role_id
            LEFT JOIN request_items item ON item.id = (SELECT id FROM request_items WHERE request_id = req.id ORDER BY id ASC LIMIT 1)
            LEFT JOIN assignments assignment ON assignment.request_id = req.id
            LEFT JOIN users runner ON runner.id = assignment.runner_id
            LEFT JOIN quotations quote ON quote.id = assignment.quotation_id';
}

function fetch_requests_for_user(array $user, array $filters = []): array
{
    $sql = request_select_sql();
    $where = [];
    $params = [];

    if (in_array($user['role'], ['seller', 'buyer'], true)) {
        $where[] = 'req.requester_id = :user_id';
        $params['user_id'] = $user['id'];
    } elseif ($user['role'] === 'runner') {
        $where[] = '(assignment.runner_id = :user_id OR (assignment.runner_id IS NULL AND req.visibility_status = "public" AND req.status IN ("open", "quoted")))';
        $params['user_id'] = $user['id'];
    }

    if (!empty($filters['status'])) {
        $where[] = 'req.status = :status';
        $params['status'] = $filters['status'];
    }
    if (!empty($filters['request_type'])) {
        $where[] = 'req.request_type = :request_type';
        $params['request_type'] = $filters['request_type'];
    }

    if ($where !== []) {
        $sql .= ' WHERE ' . implode(' AND ', $where);
    }
    $sql .= ' ORDER BY req.created_at DESC';

    return fetch_all($sql, $params);
}

function fetch_request_by_id(int $requestId): ?array
{
    return fetch_one(request_select_sql() . ' WHERE req.id = :id LIMIT 1', ['id' => $requestId]);
}

function fetch_request_items(int $requestId): array
{
    return fetch_all('SELECT * FROM request_items WHERE request_id = :request_id ORDER BY id ASC', ['request_id' => $requestId]);
}

function fetch_request_item_samples(int $requestId): array
{
    return fetch_all(
        'SELECT s.*, runner.full_name AS runner_name
         FROM request_item_samples s
         INNER JOIN users runner ON runner.id = s.runner_id
         WHERE s.request_id = :request_id
         ORDER BY s.created_at DESC',
        ['request_id' => $requestId]
    );
}

function create_request_item_sample(int $requestId, int $runnerId, string $imagePath, ?string $caption, ?float $priceEstimate): bool
{
    return execute_query(
        'INSERT INTO request_item_samples (request_id, runner_id, image_path, caption, price_estimate)
         VALUES (:request_id, :runner_id, :image_path, :caption, :price_estimate)',
        [
            'request_id' => $requestId,
            'runner_id' => $runnerId,
            'image_path' => $imagePath,
            'caption' => $caption,
            'price_estimate' => $priceEstimate,
        ]
    );
}

function select_request_item_sample(int $sampleId, int $requesterId): bool
{
    $sample = fetch_one(
        'SELECT s.*, req.requester_id
         FROM request_item_samples s
         INNER JOIN requests req ON req.id = s.request_id
         WHERE s.id = :id
         LIMIT 1',
        ['id' => $sampleId]
    );

    if ($sample === null || (int) $sample['requester_id'] !== $requesterId) {
        return false;
    }

    execute_query(
        'UPDATE request_item_samples SET is_selected = 0 WHERE request_id = :request_id',
        ['request_id' => $sample['request_id']]
    );

    return execute_query(
        'UPDATE request_item_samples SET is_selected = 1 WHERE id = :id',
        ['id' => $sampleId]
    );
}

function fetch_request_quotes(int $requestId): array
{
    return fetch_all('SELECT q.*, u.full_name AS runner_name FROM quotations q INNER JOIN users u ON u.id = q.runner_id WHERE q.request_id = :request_id ORDER BY q.created_at DESC', ['request_id' => $requestId]);
}

function fetch_assignment_by_request_id(int $requestId): ?array
{
    return fetch_one('SELECT a.*, u.full_name AS runner_name, u.email AS runner_email, u.phone AS runner_phone FROM assignments a INNER JOIN users u ON u.id = a.runner_id WHERE a.request_id = :request_id LIMIT 1', ['request_id' => $requestId]);
}

function fetch_request_logs(int $requestId): array
{
    return fetch_all('SELECT l.*, u.full_name AS actor_name FROM request_status_logs l LEFT JOIN users u ON u.id = l.actor_id WHERE l.request_id = :request_id ORDER BY l.created_at DESC', ['request_id' => $requestId]);
}

function fetch_runner_review_by_request_id(int $requestId): ?array
{
    return fetch_one(
        'SELECT rr.*, reviewer.full_name AS reviewer_name, runner.full_name AS runner_name
         FROM runner_reviews rr
         INNER JOIN users reviewer ON reviewer.id = rr.reviewer_id
         INNER JOIN users runner ON runner.id = rr.runner_id
         WHERE rr.request_id = :request_id LIMIT 1',
        ['request_id' => $requestId]
    );
}

function list_quotes_for_user(array $user): array
{
    if ($user['role'] === 'admin') {
        return fetch_all('SELECT q.*, req.title AS request_title, u.full_name AS runner_name, req.requester_id FROM quotations q INNER JOIN requests req ON req.id = q.request_id INNER JOIN users u ON u.id = q.runner_id ORDER BY q.created_at DESC');
    }
    if ($user['role'] === 'runner') {
        return fetch_all('SELECT q.*, req.title AS request_title, u.full_name AS runner_name, req.requester_id FROM quotations q INNER JOIN requests req ON req.id = q.request_id INNER JOIN users u ON u.id = q.runner_id WHERE q.runner_id = :user_id ORDER BY q.created_at DESC', ['user_id' => $user['id']]);
    }
    return fetch_all('SELECT q.*, req.title AS request_title, u.full_name AS runner_name, req.requester_id FROM quotations q INNER JOIN requests req ON req.id = q.request_id INNER JOIN users u ON u.id = q.runner_id WHERE req.requester_id = :user_id ORDER BY q.created_at DESC', ['user_id' => $user['id']]);
}

function list_transactions_for_user(array $user): array
{
    if ($user['role'] === 'admin') {
        return fetch_all('SELECT t.*, payer.full_name AS payer_name, payee.full_name AS payee_name, req.title AS request_title FROM transactions t INNER JOIN users payer ON payer.id = t.payer_id LEFT JOIN users payee ON payee.id = t.payee_id INNER JOIN requests req ON req.id = t.request_id ORDER BY t.created_at DESC');
    }
    return fetch_all('SELECT t.*, payer.full_name AS payer_name, payee.full_name AS payee_name, req.title AS request_title FROM transactions t INNER JOIN users payer ON payer.id = t.payer_id LEFT JOIN users payee ON payee.id = t.payee_id INNER JOIN requests req ON req.id = t.request_id WHERE t.payer_id = :user_id OR t.payee_id = :user_id ORDER BY t.created_at DESC', ['user_id' => $user['id']]);
}

function fetch_transactions_for_request(int $requestId): array
{
    return fetch_all(
        'SELECT t.*, payer.full_name AS payer_name, payee.full_name AS payee_name
         FROM transactions t
         INNER JOIN users payer ON payer.id = t.payer_id
         LEFT JOIN users payee ON payee.id = t.payee_id
         WHERE t.request_id = :request_id
         ORDER BY t.created_at DESC',
        ['request_id' => $requestId]
    );
}

function user_can_view_request(array $user, array $request): bool
{
    if ($user['role'] === 'admin') { return true; }
    if ((int) $request['requester_id'] === (int) $user['id']) { return true; }
    if ((int) ($request['assigned_runner_id'] ?? 0) === (int) $user['id']) { return true; }
    return $user['role'] === 'runner' && empty($request['assigned_runner_id']) && $request['visibility_status'] === 'public' && in_array($request['status'], ['open', 'quoted'], true);
}

function create_request_log(int $requestId, ?int $actorId, string $status, string $note = ''): void
{
    execute_query('INSERT INTO request_status_logs (request_id, actor_id, status, note) VALUES (:request_id, :actor_id, :status, :note)', ['request_id' => $requestId, 'actor_id' => $actorId, 'status' => $status, 'note' => $note]);
}

function create_transaction_record(int $requestId, int $payerId, ?int $payeeId, float $amount, string $paymentMethod, string $status = 'pending', string $notes = ''): void
{
    execute_query('INSERT INTO transactions (request_id, payer_id, payee_id, amount, payment_method, payment_status, transaction_reference, notes) VALUES (:request_id, :payer_id, :payee_id, :amount, :payment_method, :payment_status, :transaction_reference, :notes)', [
        'request_id' => $requestId,
        'payer_id' => $payerId,
        'payee_id' => $payeeId,
        'amount' => $amount,
        'payment_method' => $paymentMethod,
        'payment_status' => $status,
        'transaction_reference' => 'TRX-' . strtoupper(bin2hex(random_bytes(4))),
        'notes' => $notes,
    ]);
}

function create_errand_request(array $user, array $data, ?string $itemImage = null): int
{
    $pdo = db();
    $pdo->beginTransaction();
    try {
        $pdo->prepare('INSERT INTO requests (requester_id, requester_role_key, request_type, title, description, pickup_location, destination, budget_amount, quoted_amount, payment_method, recipient_name, recipient_phone, delivery_window, special_instructions, status, visibility_status) VALUES (:requester_id, :requester_role_key, :request_type, :title, :description, :pickup_location, :destination, :budget_amount, NULL, :payment_method, :recipient_name, :recipient_phone, :delivery_window, :special_instructions, :status, :visibility_status)')->execute([
            'requester_id' => $user['id'],
            'requester_role_key' => $user['role'],
            'request_type' => $data['request_type'],
            'title' => $data['title'],
            'description' => $data['description'],
            'pickup_location' => $data['pickup_location'],
            'destination' => $data['destination'],
            'budget_amount' => $data['budget_amount'],
            'payment_method' => $data['payment_method'],
            'recipient_name' => $data['recipient_name'],
            'recipient_phone' => $data['recipient_phone'],
            'delivery_window' => $data['delivery_window'],
            'special_instructions' => $data['special_instructions'],
            'status' => 'open',
            'visibility_status' => 'public',
        ]);
        $requestId = (int) $pdo->lastInsertId();
        $pdo->prepare('INSERT INTO request_items (request_id, item_name, item_description, quantity, estimated_unit_price, image_path) VALUES (:request_id, :item_name, :item_description, :quantity, :estimated_unit_price, :image_path)')->execute([
            'request_id' => $requestId,
            'item_name' => $data['item_name'],
            'item_description' => $data['item_description'],
            'quantity' => $data['item_quantity'],
            'estimated_unit_price' => $data['estimated_unit_price'],
            'image_path' => $itemImage,
        ]);
        $pdo->commit();
    } catch (Throwable $throwable) {
        $pdo->rollBack();
        throw $throwable;
    }

    create_request_log($requestId, (int) $user['id'], 'open', 'Request created by ' . role_label($user['role']) . '.');
    foreach (list_users('admin') as $admin) {
        create_notification((int) $admin['id'], 'New request created', $data['title'] . ' has been submitted and is now visible in admin oversight.', page_url('request-details.php?id=' . $requestId));
    }
    return $requestId;
}

function create_quote(int $requestId, int $runnerId, float $amount, string $note = ''): bool
{
    $request = fetch_request_by_id($requestId);
    if ($request === null || !empty($request['assigned_runner_id'])) { return false; }
    $existing = fetch_one('SELECT id FROM quotations WHERE request_id = :request_id AND runner_id = :runner_id AND status = "pending" LIMIT 1', ['request_id' => $requestId, 'runner_id' => $runnerId]);
    if ($existing !== null) { return false; }

    execute_query('INSERT INTO quotations (request_id, runner_id, amount, note, status) VALUES (:request_id, :runner_id, :amount, :note, :status)', ['request_id' => $requestId, 'runner_id' => $runnerId, 'amount' => $amount, 'note' => $note, 'status' => 'pending']);
    if ($request['status'] === 'open') {
        execute_query('UPDATE requests SET status = :status WHERE id = :id', ['status' => 'quoted', 'id' => $requestId]);
        create_request_log($requestId, $runnerId, 'quoted', 'Quotation submitted at ' . money($amount) . '.');
    }
    create_notification((int) $request['requester_id'], 'Quotation received', 'A runner submitted a quotation for ' . $request['title'] . '.', page_url('request-details.php?id=' . $requestId));
    return true;
}

function approve_quote(int $quoteId, int $requesterId): bool
{
    $quote = fetch_one('SELECT q.*, req.id AS request_id, req.requester_id, req.title, req.payment_method FROM quotations q INNER JOIN requests req ON req.id = q.request_id WHERE q.id = :id LIMIT 1', ['id' => $quoteId]);
    if ($quote === null || (int) $quote['requester_id'] !== $requesterId) { return false; }
    if (fetch_assignment_by_request_id((int) $quote['request_id']) !== null) { return false; }

    $pdo = db();
    $pdo->beginTransaction();
    try {
        $pdo->prepare('UPDATE quotations SET status = :status WHERE id = :id')->execute(['status' => 'approved', 'id' => $quoteId]);
        $pdo->prepare('UPDATE quotations SET status = :status WHERE request_id = :request_id AND id <> :id')->execute(['status' => 'rejected', 'request_id' => $quote['request_id'], 'id' => $quoteId]);
        $pdo->prepare('INSERT INTO assignments (request_id, runner_id, quotation_id, status, accepted_at) VALUES (:request_id, :runner_id, :quotation_id, :status, NOW())')->execute([
            'request_id' => $quote['request_id'],
            'runner_id' => $quote['runner_id'],
            'quotation_id' => $quoteId,
            'status' => 'assigned',
        ]);
        $pdo->prepare('UPDATE requests SET quoted_amount = :quoted_amount, status = :status WHERE id = :id')->execute([
            'quoted_amount' => $quote['amount'],
            'status' => 'assigned',
            'id' => $quote['request_id'],
        ]);
        $pdo->commit();
    } catch (Throwable $throwable) {
        $pdo->rollBack();
        throw $throwable;
    }

    create_request_log((int) $quote['request_id'], $requesterId, 'assigned', 'Quotation approved and runner assigned.');
    create_transaction_record((int) $quote['request_id'], $requesterId, (int) $quote['runner_id'], (float) $quote['amount'], (string) $quote['payment_method'], 'processing', 'Created from approved quotation.');
    create_notification((int) $quote['runner_id'], 'Quotation approved', 'Your quotation for ' . $quote['title'] . ' was approved.', page_url('request-details.php?id=' . $quote['request_id']));
    return true;
}

function accept_delivery_request(int $requestId, int $runnerId): bool
{
    $request = fetch_request_by_id($requestId);
    if ($request === null || $request['request_type'] !== 'delivery_request' || !empty($request['assigned_runner_id']) || $request['status'] !== 'open') { return false; }

    execute_query('INSERT INTO assignments (request_id, runner_id, quotation_id, status, accepted_at) VALUES (:request_id, :runner_id, NULL, :status, NOW())', ['request_id' => $requestId, 'runner_id' => $runnerId, 'status' => 'assigned']);
    execute_query('UPDATE requests SET status = :status, quoted_amount = :quoted_amount WHERE id = :id', ['status' => 'assigned', 'quoted_amount' => $request['budget_amount'], 'id' => $requestId]);

    create_request_log($requestId, $runnerId, 'assigned', 'Runner accepted the delivery request directly.');
    create_transaction_record($requestId, (int) $request['requester_id'], $runnerId, (float) $request['budget_amount'], (string) $request['payment_method'], 'processing', 'Created from direct delivery acceptance.');
    create_notification((int) $request['requester_id'], 'Request accepted', 'A runner accepted your request: ' . $request['title'] . '.', page_url('request-details.php?id=' . $requestId));
    return true;
}

function update_request_status_action(int $requestId, int $actorId, string $newStatus, string $note = '', ?string $proofImage = null, string $proofNote = ''): bool
{
    $request = fetch_request_by_id($requestId);
    if ($request === null) { return false; }

    execute_query('UPDATE requests SET status = :status WHERE id = :id', ['status' => $newStatus, 'id' => $requestId]);

    $assignment = fetch_assignment_by_request_id($requestId);
    if ($assignment !== null) {
        $fields = ['status = :status', 'updated_at = NOW()'];
        $params = ['status' => $newStatus, 'id' => $assignment['id']];
        if ($newStatus === 'in_progress') { $fields[] = 'started_at = COALESCE(started_at, NOW())'; }
        if ($newStatus === 'completed') { $fields[] = 'completed_at = NOW()'; }
        if ($newStatus === 'confirmed') { $fields[] = 'confirmed_at = NOW()'; }
        if ($proofImage !== null) { $fields[] = 'proof_image_path = :proof_image_path'; $params['proof_image_path'] = $proofImage; }
        if ($proofNote !== '') { $fields[] = 'proof_note = :proof_note'; $params['proof_note'] = $proofNote; }
        execute_query('UPDATE assignments SET ' . implode(', ', $fields) . ' WHERE id = :id', $params);
    }

    if ($newStatus === 'confirmed') {
        execute_query('UPDATE transactions SET payment_status = :status WHERE request_id = :request_id AND payment_status IN ("pending", "processing")', ['status' => 'paid', 'request_id' => $requestId]);
    }

    create_request_log($requestId, $actorId, $newStatus, $note);
    $audience = [(int) $request['requester_id']];
    if (!empty($request['assigned_runner_id'])) { $audience[] = (int) $request['assigned_runner_id']; }
    foreach (array_unique($audience) as $userId) {
        if ($userId !== $actorId) {
            create_notification($userId, 'Request status updated', $request['title'] . ' is now ' . status_label($newStatus) . '.', page_url('request-details.php?id=' . $requestId));
        }
    }
    return true;
}

function confirm_request_completion(int $requestId, int $actorId): bool
{
    $request = fetch_request_by_id($requestId);
    if ($request === null || $request['status'] !== 'completed') { return false; }
    return update_request_status_action($requestId, $actorId, 'confirmed', 'Requester confirmed successful delivery.');
}

function create_runner_review(int $requestId, int $reviewerId, int $rating, string $reviewText): bool
{
    $request = fetch_request_by_id($requestId);
    $assignment = fetch_assignment_by_request_id($requestId);

    if ($request === null || $assignment === null) {
        return false;
    }

    if ((int) $request['requester_id'] !== $reviewerId || $request['status'] !== 'confirmed') {
        return false;
    }

    if ($rating < 1 || $rating > 5) {
        return false;
    }

    if (fetch_runner_review_by_request_id($requestId) !== null) {
        return false;
    }

    $created = execute_query(
        'INSERT INTO runner_reviews (request_id, reviewer_id, runner_id, rating, review_text)
         VALUES (:request_id, :reviewer_id, :runner_id, :rating, :review_text)',
        [
            'request_id' => $requestId,
            'reviewer_id' => $reviewerId,
            'runner_id' => $assignment['runner_id'],
            'rating' => $rating,
            'review_text' => $reviewText,
        ]
    );

    if ($created) {
        create_notification((int) $assignment['runner_id'], 'New service review', 'A customer rated your completed service on "' . $request['title'] . '".', page_url('request-details.php?id=' . $requestId));
    }

    return $created;
}

function toggle_request_visibility(int $requestId, int $adminId): bool
{
    $request = fetch_request_by_id($requestId);
    if ($request === null) { return false; }
    $next = $request['visibility_status'] === 'public' ? 'hidden' : 'public';
    execute_query('UPDATE requests SET visibility_status = :visibility_status WHERE id = :id', ['visibility_status' => $next, 'id' => $requestId]);
    create_request_log($requestId, $adminId, $request['status'], $next === 'public' ? 'Admin made the request visible to runners.' : 'Admin hid the request from public runner listing.');
    return true;
}

function toggle_user_status(int $userId): bool
{
    $user = fetch_one('SELECT id, is_active FROM users WHERE id = :id LIMIT 1', ['id' => $userId]);
    if ($user === null) { return false; }
    $next = (int) $user['is_active'] === 1 ? 0 : 1;
    return execute_query('UPDATE users SET is_active = :is_active WHERE id = :id', ['is_active' => $next, 'id' => $userId]);
}

function dashboard_metrics(array $user): array
{
    if ($user['role'] === 'admin') {
        return [
            'users' => count_by_query('SELECT COUNT(*) AS aggregate FROM users'),
            'requests' => count_by_query('SELECT COUNT(*) AS aggregate FROM requests'),
            'active_requests' => count_by_query('SELECT COUNT(*) AS aggregate FROM requests WHERE status IN ("open", "quoted", "assigned", "in_progress")'),
            'transactions' => count_by_query('SELECT COUNT(*) AS aggregate FROM transactions WHERE payment_status IN ("pending", "processing")'),
        ];
    }
    if ($user['role'] === 'runner') {
        return [
            'available' => count_by_query('SELECT COUNT(*) AS aggregate FROM requests WHERE visibility_status = "public" AND status IN ("open", "quoted") AND id NOT IN (SELECT request_id FROM assignments)'),
            'assigned' => count_by_query('SELECT COUNT(*) AS aggregate FROM assignments WHERE runner_id = :runner_id AND status = "assigned"', ['runner_id' => $user['id']]),
            'in_progress' => count_by_query('SELECT COUNT(*) AS aggregate FROM assignments WHERE runner_id = :runner_id AND status = "in_progress"', ['runner_id' => $user['id']]),
            'completed' => count_by_query('SELECT COUNT(*) AS aggregate FROM assignments WHERE runner_id = :runner_id AND status IN ("completed", "confirmed")', ['runner_id' => $user['id']]),
        ];
    }
    return [
        'total' => count_by_query('SELECT COUNT(*) AS aggregate FROM requests WHERE requester_id = :requester_id', ['requester_id' => $user['id']]),
        'quoted' => count_by_query('SELECT COUNT(*) AS aggregate FROM requests WHERE requester_id = :requester_id AND status = "quoted"', ['requester_id' => $user['id']]),
        'active' => count_by_query('SELECT COUNT(*) AS aggregate FROM requests WHERE requester_id = :requester_id AND status IN ("assigned", "in_progress")', ['requester_id' => $user['id']]),
        'completed' => count_by_query('SELECT COUNT(*) AS aggregate FROM requests WHERE requester_id = :requester_id AND status IN ("completed", "confirmed")', ['requester_id' => $user['id']]),
    ];
}

function recent_requests(array $user, int $limit = 5): array
{
    return array_slice(fetch_requests_for_user($user), 0, $limit);
}
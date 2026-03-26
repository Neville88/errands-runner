<?php

declare(strict_types=1);

require_once __DIR__ . '/functions.php';
require_once __DIR__ . '/flash.php';
require_once __DIR__ . '/validators.php';

function require_auth(): void
{
    if (!is_logged_in()) {
        set_flash('warning', 'Please sign in to continue.');
        redirect('pages/login.php');
    }
}

function require_guest(): void
{
    if (is_logged_in()) {
        redirect(role_dashboard_path((string) current_user()['role']));
    }
}

function login_user(string $email, string $password): bool
{
    $user = fetch_user_by_email($email);
    if ($user === null || (int) $user['is_active'] !== 1) { return false; }
    if (!password_verify($password, (string) $user['password_hash'])) { return false; }
    execute_query('UPDATE users SET last_login_at = NOW() WHERE id = :id', ['id' => $user['id']]);
    hydrate_user_session((int) $user['id']);
    return true;
}

function register_user(array $data): bool
{
    if (fetch_user_by_email($data['email']) !== null) { return false; }
    $role = fetch_one('SELECT id FROM roles WHERE role_key = :role_key LIMIT 1', ['role_key' => $data['role']]);
    if ($role === null) { return false; }

    $pdo = db();
    $pdo->beginTransaction();
    try {
        $pdo->prepare('INSERT INTO users (role_id, full_name, email, phone, password_hash, is_active) VALUES (:role_id, :full_name, :email, :phone, :password_hash, 1)')->execute([
            'role_id' => $role['id'],
            'full_name' => $data['full_name'],
            'email' => $data['email'],
            'phone' => $data['phone'],
            'password_hash' => password_hash($data['password'], PASSWORD_DEFAULT),
        ]);
        $userId = (int) $pdo->lastInsertId();
        $pdo->prepare('INSERT INTO profiles (user_id) VALUES (:user_id)')->execute(['user_id' => $userId]);
        $pdo->commit();
        hydrate_user_session($userId);
        create_notification($userId, 'Welcome to Errands Runner', 'Your account is ready. Create requests or manage assignments from your dashboard.', page_url('dashboard.php'));
        return true;
    } catch (Throwable $throwable) {
        $pdo->rollBack();
        throw $throwable;
    }
}

function logout_user(): void
{
    $_SESSION = [];
    if (ini_get('session.use_cookies')) {
        $params = session_get_cookie_params();
        setcookie(session_name(), '', time() - 42000, $params['path'], $params['domain'], (bool) $params['secure'], (bool) $params['httponly']);
    }
    session_destroy();
}
<?php

declare(strict_types=1);

require_once __DIR__ . '/../includes/auth.php';
require_once __DIR__ . '/../components/buttons.php';
require_once __DIR__ . '/../components/forms.php';
require_once __DIR__ . '/../components/alerts.php';

require_guest();

$errors = [];
$input = ['email' => ''];
if (request_method_is('POST')) {
    $validation = validate_login_input($_POST);
    $errors = $validation['errors'];
    $input = $validation['data'];
    if ($errors === [] && login_user($input['email'], $input['password'])) {
        set_flash('success', 'Welcome back.');
        redirect(role_dashboard_path((string) current_user()['role']));
    }
    if ($errors === []) { $errors[] = 'Invalid login credentials.'; }
}

$pageTitle = 'Login';
$pageDescription = 'Access your Errands Runner account.';
require_once __DIR__ . '/../layouts/header.php';
?>
<section class="glass-panel mx-auto max-w-xl rounded-[2rem] p-8 shadow-sm">
    <h1 class="text-3xl font-bold text-[#1F2933]">Sign In</h1>
    <p class="mt-3 text-sm text-[#1F2933]">Access your dashboard, requests, quotations, notifications, and transactions.</p>
    <?php foreach ($errors as $error): ?><?= render_alert($error, 'error') ?><?php endforeach; ?>
    <form method="post" class="mt-6 space-y-5">
        <?= form_input('email', 'Email Address', $input['email'] ?? '', 'email', true, 'you@example.com') ?>
        <?= form_input('password', 'Password', '', 'password', true, 'Enter your password') ?>
        <button type="submit" class="<?= h(button_classes('primary')) ?> w-full">Sign In</button>
    </form>
    <div class="mt-6 flex items-center justify-between text-sm">
        <a href="<?= h(page_url('forgot-password.php')) ?>" class="font-medium text-[#14532D]">Forgot password?</a>
        <a href="<?= h(page_url('register.php')) ?>" class="font-medium text-[#14532D]">Create account</a>
    </div>
</section>
<?php require_once __DIR__ . '/../layouts/footer.php'; ?>
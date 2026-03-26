<?php

declare(strict_types=1);

require_once __DIR__ . '/../includes/auth.php';
require_once __DIR__ . '/../components/buttons.php';
require_once __DIR__ . '/../components/forms.php';
require_once __DIR__ . '/../components/alerts.php';

require_guest();

$errors = [];
$input = ['full_name' => '', 'email' => '', 'phone' => '', 'role' => 'buyer'];
if (request_method_is('POST')) {
    $validation = validate_registration_input($_POST);
    $errors = $validation['errors'];
    $input = $validation['data'];
    if ($errors === [] && register_user($input)) {
        set_flash('success', 'Account created successfully.');
        redirect(role_dashboard_path((string) current_user()['role']));
    }
    if ($errors === [] && fetch_user_by_email($input['email']) !== null) { $errors[] = 'An account with that email already exists.'; }
}

$pageTitle = 'Register';
$pageDescription = 'Create a seller, buyer, or runner account.';
require_once __DIR__ . '/../layouts/header.php';
?>
<section class="glass-panel mx-auto max-w-2xl rounded-[2rem] p-8 shadow-sm">
    <h1 class="text-3xl font-bold text-[#1F2933]">Create Account</h1>
    <p class="mt-3 text-sm text-[#1F2933]">Choose your role and start using the errands and delivery platform.</p>
    <?php foreach ($errors as $error): ?><?= render_alert($error, 'error') ?><?php endforeach; ?>
    <form method="post" class="mt-6 grid gap-5 md:grid-cols-2">
        <div class="md:col-span-2"><?= form_input('full_name', 'Full Name', $input['full_name'] ?? '', 'text', true, 'Enter your full name') ?></div>
        <?= form_input('email', 'Email Address', $input['email'] ?? '', 'email', true, 'you@example.com') ?>
        <?= form_input('phone', 'Phone Number', $input['phone'] ?? '', 'text', true, '0800 000 0000') ?>
        <div class="md:col-span-2"><?= form_select('role', 'Account Type', PUBLIC_REGISTRATION_ROLES, $input['role'] ?? 'buyer', true) ?></div>
        <?= form_input('password', 'Password', '', 'password', true, 'Minimum 8 characters') ?>
        <?= form_input('password_confirmation', 'Confirm Password', '', 'password', true, 'Repeat password') ?>
        <div class="md:col-span-2"><button type="submit" class="<?= h(button_classes('primary')) ?> w-full">Create Account</button></div>
    </form>
</section>
<?php require_once __DIR__ . '/../layouts/footer.php'; ?>
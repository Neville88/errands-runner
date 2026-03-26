<?php

declare(strict_types=1);

require_once __DIR__ . '/../includes/auth.php';
require_once __DIR__ . '/../layouts/dashboard_header.php';
require_once __DIR__ . '/../layouts/dashboard_sidebar.php';
require_once __DIR__ . '/../components/buttons.php';
require_once __DIR__ . '/../components/forms.php';
require_once __DIR__ . '/../components/alerts.php';

require_auth();

$user = current_user();
$errors = [];
$input = [
    'full_name' => $user['full_name'],
    'phone' => $user['phone'],
    'address_line' => $user['address_line'] ?? '',
    'city' => $user['city'] ?? '',
    'state_region' => $user['state_region'] ?? '',
    'postal_code' => $user['postal_code'] ?? '',
    'bio' => $user['bio'] ?? '',
];

if (request_method_is('POST')) {
    $validation = validate_profile_input($_POST);
    $errors = $validation['errors'];
    $input = $validation['data'];
    $profileImage = null;

    if ($errors === []) {
        $profileImage = upload_image($_FILES['profile_image'] ?? [], PROFILE_UPLOAD_DIR, $errors, 'profile image');
    }

    if ($errors === [] && update_user_profile((int) $user['id'], $input, $profileImage)) {
        set_flash('success', 'Profile updated successfully.');
        redirect('pages/profile.php');
    }
}

$user = fetch_user_by_id((int) $user['id']) ?? $user;
$pageTitle = 'Profile';
$pageDescription = 'Manage your account profile and contact details.';
require_once __DIR__ . '/../layouts/header.php';
?>
<div class="grid gap-6 lg:grid-cols-[280px_1fr]">
    <?php render_dashboard_sidebar('profile.php'); ?>
    <section>
        <?php render_dashboard_header('Profile', 'Update your personal details, address information, and profile image.'); ?>
        <div class="glass-panel rounded-[2rem] p-8 shadow-sm">
            <?php foreach ($errors as $error): ?><?= render_alert($error, 'error') ?><?php endforeach; ?>
            <div class="mb-6 flex items-center gap-4 rounded-[2rem] bg-[#F7F7F2] p-5">
                <?php if (!empty($user['profile_image'])): ?>
                    <img src="<?= h(upload_url($user['profile_image']) ?? '') ?>" alt="Profile image" class="h-20 w-20 rounded-3xl object-cover">
                <?php else: ?>
                    <div class="flex h-20 w-20 items-center justify-center rounded-3xl bg-[#14532D] text-2xl font-bold text-[#F7F7F2]"><?= h(strtoupper(substr($user['full_name'], 0, 1))) ?></div>
                <?php endif; ?>
                <div>
                    <h2 class="text-xl font-semibold text-[#1F2933]"><?= h($user['full_name']) ?></h2>
                    <p class="text-sm text-[#1F2933]"><?= h(role_label($user['role'])) ?></p>
                </div>
            </div>
            <form method="post" enctype="multipart/form-data" class="grid gap-5 md:grid-cols-2">
                <div class="md:col-span-2"><?= form_input('full_name', 'Full Name', $input['full_name'], 'text', true, 'Your full name') ?></div>
                <?= form_input('email', 'Email Address', $user['email'], 'email', false, '') ?>
                <?= form_input('phone', 'Phone Number', $input['phone'], 'text', true, '0800 000 0000') ?>
                <div class="md:col-span-2"><?= form_file('profile_image', 'Profile Image') ?></div>
                <div class="md:col-span-2"><?= form_input('address_line', 'Address', $input['address_line'], 'text', false, 'Street and area') ?></div>
                <?= form_input('city', 'City', $input['city'], 'text', false, 'City') ?>
                <?= form_input('state_region', 'State / Region', $input['state_region'], 'text', false, 'State or region') ?>
                <?= form_input('postal_code', 'Postal Code', $input['postal_code'], 'text', false, 'Postal code') ?>
                <div class="md:col-span-2"><?= form_textarea('bio', 'Bio / Notes', $input['bio'], false, 'Optional role or service notes') ?></div>
                <div class="md:col-span-2"><button type="submit" class="<?= h(button_classes('primary')) ?>">Save Changes</button></div>
            </form>
        </div>
    </section>
</div>
<?php require_once __DIR__ . '/../layouts/footer.php'; ?>
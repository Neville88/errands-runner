<?php

declare(strict_types=1);

require_once __DIR__ . '/../includes/functions.php';
require_once __DIR__ . '/../includes/flash.php';
require_once __DIR__ . '/../components/buttons.php';
require_once __DIR__ . '/../components/forms.php';

if (request_method_is('POST')) {
    set_flash('info', 'Password resets are currently handled by the admin team. Contact support and include your email address.');
    redirect('pages/forgot-password.php');
}

$pageTitle = 'Forgot Password';
$pageDescription = 'Request password reset assistance.';
require_once __DIR__ . '/../layouts/header.php';
?>
<section class="glass-panel mx-auto max-w-xl rounded-[2rem] p-8 shadow-sm">
    <h1 class="text-3xl font-bold text-[#1F2933]">Forgot Password</h1>
    <p class="mt-3 text-sm text-[#1F2933]">Submit your email address and contact the admin team for manual reset assistance.</p>
    <form method="post" class="mt-6 space-y-5">
        <?= form_input('email', 'Email Address', '', 'email', true, 'you@example.com') ?>
        <button type="submit" class="<?= h(button_classes('primary')) ?> w-full">Submit Reset Request</button>
    </form>
</section>
<?php require_once __DIR__ . '/../layouts/footer.php'; ?>
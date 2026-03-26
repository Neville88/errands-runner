<?php

declare(strict_types=1);

require_once __DIR__ . '/../includes/functions.php';
require_once __DIR__ . '/../includes/flash.php';
require_once __DIR__ . '/../includes/validators.php';
require_once __DIR__ . '/../components/buttons.php';
require_once __DIR__ . '/../components/forms.php';
require_once __DIR__ . '/../components/alerts.php';

$errors = [];
$input = ['name' => '', 'email' => '', 'phone' => '', 'subject' => '', 'message' => ''];
if (request_method_is('POST')) {
    $validation = validate_contact_input($_POST);
    $errors = $validation['errors'];
    $input = $validation['data'];
    if ($errors === [] && store_contact_message($input)) {
        set_flash('success', 'Your message has been sent to the operations team.');
        redirect('pages/contact.php');
    }
}

$pageTitle = 'Contact';
$pageDescription = 'Reach the Errands Runner support and operations team.';
require_once __DIR__ . '/../layouts/header.php';
?>
<section class="grid gap-6 lg:grid-cols-[0.9fr_1.1fr]">
    <article class="glass-panel rounded-[2rem] p-8 shadow-sm">
        <h1 class="text-3xl font-bold text-[#1F2933]">Contact & Support</h1>
        <p class="mt-4 text-sm leading-7 text-[#1F2933]">Need help with access, request disputes, visibility settings, or transaction questions? Reach the operations team using the details or form.</p>
        <div class="mt-8 space-y-4 text-sm text-[#1F2933]">
            <p>
                <strong>Email:</strong>
                <a href="mailto:<?= h(APP_SUPPORT_EMAIL) ?>" class="font-medium text-[#14532D]">
                    <?= h(APP_SUPPORT_EMAIL) ?>
                </a>
            </p>
            <p>
                <strong>Phone:</strong>
                <a href="https://wa.me/256706888958" class="font-medium text-[#14532D]">
                    Chat on WhatsApp (+256 706 888958)
                </a>
                <span class="mx-1 text-[#E5E7EB]/60">|</span>
                <a href="tel:+256706888958" class="font-medium text-[#14532D]">
                    Call +256 706 888958
                </a>
            </p>
            <p><strong>Hours:</strong> Monday to Saturday, 8:00 AM to 6:00 PM</p>
        </div>
    </article>
    <article class="glass-panel rounded-[2rem] p-8 shadow-sm">
        <?php foreach ($errors as $error): ?><?= render_alert($error, 'error') ?><?php endforeach; ?>
        <form method="post" class="grid gap-5 md:grid-cols-2">
            <?= form_input('name', 'Full Name', $input['name'], 'text', true, 'Your name') ?>
            <?= form_input('email', 'Email Address', $input['email'], 'email', true, 'you@example.com') ?>
            <?= form_input('phone', 'Phone Number', $input['phone'], 'text', false, 'Optional phone number') ?>
            <?= form_input('subject', 'Subject', $input['subject'], 'text', true, 'What do you need help with?') ?>
            <div class="md:col-span-2"><?= form_textarea('message', 'Message', $input['message'], true, 'Describe your issue or question.') ?></div>
            <div class="md:col-span-2"><button type="submit" class="<?= h(button_classes('primary')) ?>">Send Message</button></div>
        </form>
    </article>
</section>
<?php require_once __DIR__ . '/../layouts/footer.php'; ?>
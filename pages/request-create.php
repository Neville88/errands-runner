<?php

declare(strict_types=1);

require_once __DIR__ . '/../includes/role_guard.php';
require_once __DIR__ . '/../layouts/dashboard_header.php';
require_once __DIR__ . '/../layouts/dashboard_sidebar.php';
require_once __DIR__ . '/../components/buttons.php';
require_once __DIR__ . '/../components/forms.php';
require_once __DIR__ . '/../components/alerts.php';

require_role(['seller', 'buyer']);

$user = current_user();
$linkedRunner = null;
if (isset($_GET['runner_id'])) {
    $candidateId = (int) $_GET['runner_id'];
    if ($candidateId > 0) {
        $candidate = fetch_user_by_id($candidateId);
        if ($candidate !== null && $candidate['role'] === 'runner' && (int) $candidate['is_active'] === 1) {
            $linkedRunner = $candidate;
        }
    }
}
$errors = [];
$input = [
    'request_type' => array_key_first(role_request_type_options($user['role'])),
    'title' => '',
    'description' => '',
    'item_name' => '',
    'item_quantity' => '1',
    'estimated_unit_price' => '',
    'pickup_location' => '',
    'destination' => '',
    'recipient_name' => '',
    'recipient_phone' => '',
    'delivery_window' => '',
    'special_instructions' => '',
    'budget_amount' => '',
    'payment_method' => 'cash_on_delivery',
];

if (request_method_is('POST')) {
    $validation = validate_request_input($_POST, $user);
    $errors = $validation['errors'];
    $input = array_merge($input, $validation['data']);
    $itemImage = null;

    if ($errors === []) {
        $itemImage = upload_image($_FILES['item_image'] ?? [], ITEM_UPLOAD_DIR, $errors, 'item image');
    }

    if ($errors === []) {
        $requestId = create_errand_request($user, $validation['data'], $itemImage);
        set_flash('success', 'Request created successfully.');
        redirect('pages/request-details.php?id=' . $requestId);
    }
}

$pageTitle = 'Create Request';
$pageDescription = 'Submit a new errand or delivery request.';
require_once __DIR__ . '/../layouts/header.php';
?>
<div class="grid gap-6 lg:grid-cols-[280px_1fr]">
    <?php render_dashboard_sidebar('request-create.php'); ?>
    <section>
        <?php
        $headerDescription = $linkedRunner === null
            ? 'Fill out the request details clearly so runners and admins can process it with minimal friction.'
            : 'You can either call the linked runner to describe your errand, or fill in the details below for clearer tracking.';
        render_dashboard_header('Create Request', $headerDescription);
        ?>
        <?php if ($linkedRunner !== null): ?>
            <div class="mb-4 glass-panel rounded-[2rem] p-5 shadow-sm">
                <div class="flex flex-col gap-3 md:flex-row md:items-center md:justify-between">
                    <div>
                        <p class="text-xs font-semibold uppercase tracking-[0.24em] text-[#22C55E]">Linked Runner</p>
                        <p class="mt-2 text-lg font-semibold text-[#1F2933]"><?= h($linkedRunner['full_name']) ?></p>
                        <p class="text-sm text-[#1F2933]"><?= h(trim(($linkedRunner['city'] ?? '') . ', ' . ($linkedRunner['state_region'] ?? ''), ', ')) ?></p>
                    </div>
                    <div class="flex flex-col gap-2 md:flex-row md:items-center">
                        <a href="tel:<?= h($linkedRunner['phone']) ?>" class="<?= h(button_classes('primary')) ?> w-full md:w-auto">
                            Call this runner
                        </a>
                        <p class="text-xs text-[#1F2933]/70 md:ml-3">On mobile, this will open your phone dialer.</p>
                    </div>
                </div>
            </div>
        <?php endif; ?>
        <div class="glass-panel rounded-[2rem] p-8 shadow-sm">
            <?php foreach ($errors as $error): ?><?= render_alert($error, 'error') ?><?php endforeach; ?>
            <form method="post" enctype="multipart/form-data" class="grid gap-5 md:grid-cols-2">
                <div class="md:col-span-2"><?= form_select('request_type', 'Request Type', role_request_type_options($user['role']), (string) $input['request_type'], true) ?></div>
                <div class="md:col-span-2"><?= form_input('title', 'Request Title', (string) $input['title'], 'text', true, 'e.g. Source groceries and deliver') ?></div>
                <div class="md:col-span-2"><?= form_textarea('description', 'Description', (string) $input['description'], true, 'Describe the task, goods, item specs, or errand details clearly.') ?></div>
                <?= form_input('item_name', 'Item / Package Name', (string) $input['item_name'], 'text', true, 'e.g. Grocery bundle') ?>
                <?= form_input('item_quantity', 'Quantity', (string) $input['item_quantity'], 'number', true, '1') ?>
                <div class="space-y-2">
                    <?= form_input('estimated_unit_price', 'Estimated Unit Price (UGX)', (string) $input['estimated_unit_price'], 'number', false, '0.00') ?>
                    <p class="text-xs text-[#1F2933]/80">Your best guess of price per unit (e.g. per kg, per item) in UGX. Helps runners give accurate quotes. Leave 0 if unsure.</p>
                </div>
                <div class="md:col-span-2"><?= form_file('item_image', 'Item Image') ?></div>
                <?= form_input('pickup_location', 'Pickup Location', (string) $input['pickup_location'], 'text', true, 'Pickup point') ?>
                <?= form_input('destination', 'Destination', (string) $input['destination'], 'text', true, 'Dropoff point') ?>
                <?= form_input('recipient_name', 'Recipient Name', (string) $input['recipient_name'], 'text', true, 'Who should receive it?') ?>
                <?= form_input('recipient_phone', 'Recipient Phone', (string) $input['recipient_phone'], 'text', true, 'Recipient phone number') ?>
                <?= form_input('delivery_window', 'Preferred Delivery Window', (string) $input['delivery_window'], 'text', false, 'e.g. Today 3pm - 6pm') ?>
                <div class="space-y-2">
                    <?= form_select('payment_method', 'Payment Method', PAYMENT_METHODS, (string) $input['payment_method'], true) ?>
                    <p id="payment-method-help" class="text-xs text-[#1F2933]/80">
                        Cash on Delivery — you pay the runner in cash after a successful handoff. Admins can still record the transaction.
                    </p>
                </div>
                <div class="md:col-span-2"><?= form_input('budget_amount', 'Budget / Price Estimate', (string) $input['budget_amount'], 'number', false, '0.00') ?></div>
                <div class="md:col-span-2"><?= form_textarea('special_instructions', 'Special Instructions', (string) $input['special_instructions'], false, 'Gate code, fragile handling, sourcing preferences, or other notes') ?></div>
                <div class="md:col-span-2"><button type="submit" class="<?= h(button_classes('primary')) ?>">Submit Request</button></div>
            </form>
        </div>
        <script>
            (function () {
                const select = document.querySelector('select[name="payment_method"]');
                const help = document.getElementById('payment-method-help');
                if (!select || !help) return;

                const messages = {
                    cash_on_delivery: 'Cash on Delivery — you pay the runner in cash after a successful handoff. Admins can still record the transaction.',
                    bank_transfer: 'Bank Transfer — you will settle using mobile or bank transfer; the platform records the payment against this request.',
                    wallet: 'Wallet / Internal Settlement — payment will be settled through your agreed wallet or internal balance, then tracked in the system.',
                    manual_record: 'Manual Record — for office or special settlements handled outside the platform, with finance recording the payment status manually.'
                };

                function updateMessage() {
                    const value = select.value;
                    help.textContent = messages[value] || '';
                }

                select.addEventListener('change', updateMessage);
                updateMessage();
            })();
        </script>
    </section>
</div>
<?php require_once __DIR__ . '/../layouts/footer.php'; ?>
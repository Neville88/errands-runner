<?php

declare(strict_types=1);

require_once __DIR__ . '/../includes/auth.php';
require_once __DIR__ . '/../layouts/dashboard_header.php';
require_once __DIR__ . '/../layouts/dashboard_sidebar.php';
require_once __DIR__ . '/../components/buttons.php';
require_once __DIR__ . '/../components/forms.php';
require_once __DIR__ . '/../components/badges.php';
require_once __DIR__ . '/../components/tables.php';
require_once __DIR__ . '/../components/alerts.php';

require_auth();

$user = current_user();
$requestId = (int) ($_GET['id'] ?? 0);
$request = $requestId > 0 ? fetch_request_by_id($requestId) : null;
if ($request === null || !user_can_view_request($user, $request)) {
    set_flash('error', 'The requested errand could not be found or is not accessible to your account.');
    redirect('pages/requests.php');
}

$errors = [];
if (request_method_is('POST')) {
    $action = (string) ($_POST['action'] ?? '');
    $success = false;

    if ($action === 'submit_quote' && $user['role'] === 'runner') {
        $validation = validate_quote_input($_POST);
        $errors = $validation['errors'];
        if ($errors === []) {
            $success = create_quote($requestId, (int) $user['id'], (float) $validation['data']['amount'], (string) $validation['data']['note']);
            if ($success) { set_flash('success', 'Quotation submitted successfully.'); redirect('pages/request-details.php?id=' . $requestId); }
            $errors[] = 'Unable to submit a quotation for this request.';
        }
    }

    if ($action === 'approve_quote' && (int) $request['requester_id'] === (int) $user['id']) {
        $success = approve_quote((int) ($_POST['quote_id'] ?? 0), (int) $user['id']);
        if ($success) { set_flash('success', 'Quotation approved and runner assigned.'); redirect('pages/request-details.php?id=' . $requestId); }
        $errors[] = 'Unable to approve the selected quotation.';
    }

    if ($action === 'accept_delivery' && $user['role'] === 'runner') {
        $success = accept_delivery_request($requestId, (int) $user['id']);
        if ($success) { set_flash('success', 'Delivery request accepted.'); redirect('pages/request-details.php?id=' . $requestId); }
        $errors[] = 'Unable to accept this delivery request.';
    }

    if ($action === 'start_progress' && (($user['role'] === 'runner' && (int) ($request['assigned_runner_id'] ?? 0) === (int) $user['id']) || $user['role'] === 'admin')) {
        $success = update_request_status_action($requestId, (int) $user['id'], 'in_progress', 'Runner started work on the request.');
        if ($success) { set_flash('success', 'Request moved to in progress.'); redirect('pages/request-details.php?id=' . $requestId); }
    }

    if ($action === 'mark_completed' && (($user['role'] === 'runner' && (int) ($request['assigned_runner_id'] ?? 0) === (int) $user['id']) || $user['role'] === 'admin')) {
        $proofImage = upload_image($_FILES['proof_image'] ?? [], RECEIPT_UPLOAD_DIR, $errors, 'proof of delivery');
        if ($errors === []) {
            $success = update_request_status_action($requestId, (int) $user['id'], 'completed', 'Runner marked the request as completed.', $proofImage, trim((string) ($_POST['proof_note'] ?? '')));
            if ($success) { set_flash('success', 'Request marked as completed.'); redirect('pages/request-details.php?id=' . $requestId); }
        }
    }

    if ($action === 'confirm_delivery' && (((int) $request['requester_id'] === (int) $user['id']) || $user['role'] === 'admin')) {
        $success = confirm_request_completion($requestId, (int) $user['id']);
        if ($success) { set_flash('success', 'Delivery confirmed successfully.'); redirect('pages/request-details.php?id=' . $requestId); }
    }

    if ($action === 'submit_review' && (int) $request['requester_id'] === (int) $user['id']) {
        $rating = (int) ($_POST['rating'] ?? 0);
        $reviewText = trim((string) ($_POST['review_text'] ?? ''));

        if ($rating < 1 || $rating > 5) {
            $errors[] = 'Select a valid star rating.';
        }
        if (mb_strlen($reviewText) < 10) {
            $errors[] = 'Review text must contain at least 10 characters.';
        }

        if ($errors === [] && create_runner_review($requestId, (int) $user['id'], $rating, $reviewText)) {
            set_flash('success', 'Thank you for rating your runner.');
            redirect('pages/request-details.php?id=' . $requestId);
        }

        if ($errors === []) {
            $errors[] = 'Unable to save your review for this request.';
        }
    }

    if ($action === 'cancel_request' && (((int) $request['requester_id'] === (int) $user['id']) || $user['role'] === 'admin')) {
        $success = update_request_status_action($requestId, (int) $user['id'], 'cancelled', 'Request cancelled by owner or admin.');
        if ($success) { set_flash('success', 'Request cancelled.'); redirect('pages/request-details.php?id=' . $requestId); }
    }

    if ($action === 'invite_runner' && (((int) $request['requester_id'] === (int) $user['id']) || $user['role'] === 'admin') && empty($request['assigned_runner_id'])) {
        $runnerId = (int) ($_POST['runner_id'] ?? 0);
        if ($runnerId <= 0) {
            $errors[] = 'Select a valid runner to notify.';
        } else {
            $runner = fetch_user_by_id($runnerId);
            if ($runner === null || $runner['role'] !== 'runner' || (int) $runner['is_active'] !== 1) {
                $errors[] = 'The selected runner is not available.';
            } else {
                create_notification(
                    $runnerId,
                    'Nearby errand opportunity',
                    'A customer created an errand that may be close to your working area: "' . $request['title'] . '".',
                    page_url('request-details.php?id=' . $requestId)
                );
                set_flash('success', 'Runner has been notified about this errand.');
                redirect('pages/request-details.php?id=' . $requestId);
            }
        }
    }

    if ($action === 'add_sample' && $user['role'] === 'runner' && (int) ($request['assigned_runner_id'] ?? 0) === (int) $user['id'] && in_array($request['status'], ['assigned', 'in_progress'], true)) {
        $caption = trim((string) ($_POST['sample_caption'] ?? ''));
        $priceEstimate = $_POST['sample_price'] !== '' ? (float) $_POST['sample_price'] : null;
        $sampleImage = upload_image($_FILES['sample_image'] ?? [], SAMPLE_UPLOAD_DIR, $errors, 'sample image');
        if ($errors === []) {
            if ($sampleImage === null) {
                $errors[] = 'Please attach a sample image.';
            } else {
                $created = create_request_item_sample($requestId, (int) $user['id'], $sampleImage, $caption !== '' ? $caption : null, $priceEstimate);
                if ($created) {
                    create_notification(
                        (int) $request['requester_id'],
                        'New item sample shared',
                        'Your runner shared a new photo sample for "' . $request['title'] . '".',
                        page_url('request-details.php?id=' . $requestId)
                    );
                    set_flash('success', 'Sample photo added for this request.');
                    redirect('pages/request-details.php?id=' . $requestId);
                }
                $errors[] = 'Unable to save the sample image.';
            }
        }
    }

    if ($action === 'select_sample' && (int) $request['requester_id'] === (int) $user['id'] && in_array($request['status'], ['quoted', 'assigned', 'in_progress'], true)) {
        $sampleId = (int) ($_POST['sample_id'] ?? 0);
        if ($sampleId <= 0) {
            $errors[] = 'Select a valid sample.';
        } else {
            if (select_request_item_sample($sampleId, (int) $user['id'])) {
                set_flash('success', 'Preferred item sample recorded.');
                redirect('pages/request-details.php?id=' . $requestId);
            }
            $errors[] = 'Unable to select this sample for the request.';
        }
    }

    if ($errors === [] && !$success) {
        $errors[] = 'The requested action could not be completed.';
    }
}

$request = fetch_request_by_id($requestId);
$items = fetch_request_items($requestId);
$itemSamples = fetch_request_item_samples($requestId);
$quotes = fetch_request_quotes($requestId);
$assignment = fetch_assignment_by_request_id($requestId);
$logs = fetch_request_logs($requestId);
$review = fetch_runner_review_by_request_id($requestId);
$transactions = fetch_transactions_for_request($requestId);
$primaryTransaction = $transactions[0] ?? null;
$suggestedRunners = $assignment === null ? nearest_runners_for_request($request, 3) : [];

$pageTitle = 'Request Details';
$pageDescription = 'View request workflow details, quotations, assignment, and proof.';
require_once __DIR__ . '/../layouts/header.php';
?>
<div class="grid gap-6 lg:grid-cols-[280px_1fr]">
    <?php render_dashboard_sidebar('requests.php'); ?>
    <section>
        <?php render_dashboard_header('Request Details', 'Track the lifecycle of a request, review quotations, and perform workflow actions.', '<a href="' . h(page_url('requests.php')) . '" class="' . h(button_classes('secondary')) . '">Back to Requests</a>'); ?>
        <?php foreach ($errors as $error): ?><?= render_alert($error, 'error') ?><?php endforeach; ?>
        <div class="grid gap-6 xl:grid-cols-[1.35fr_0.65fr]">
            <div class="space-y-6">
                <article class="glass-panel rounded-[2rem] p-8 shadow-sm">
                    <div class="flex flex-col gap-4 lg:flex-row lg:items-start lg:justify-between">
                        <div>
                            <p class="text-sm font-semibold uppercase tracking-[0.2em] text-[#22C55E]"><?= h(request_type_label($request['request_type'])) ?></p>
                            <h1 class="mt-2 text-3xl font-bold text-[#1F2933]"><?= h($request['title']) ?></h1>
                            <p class="mt-4 text-sm leading-7 text-[#1F2933]"><?= nl2br(h($request['description'])) ?></p>
                        </div>
                        <div class="flex flex-wrap gap-2">
                            <?= render_badge(status_label($request['status']), $request['status']) ?>
                            <?= render_badge($request['visibility_status'] === 'public' ? 'Visible To Runners' : 'Hidden From Marketplace', $request['visibility_status'] === 'public' ? 'approved' : 'cancelled') ?>
                        </div>
                    </div>
                    <div class="mt-8 grid gap-5 md:grid-cols-2">
                        <div class="rounded-3xl bg-[#F7F7F2] p-5"><p class="text-xs uppercase tracking-[0.2em] text-[#22C55E]">Requester</p><p class="mt-2 font-semibold text-[#1F2933]"><?= h($request['requester_name']) ?></p></div>
                        <div class="rounded-3xl bg-[#F7F7F2] p-5"><p class="text-xs uppercase tracking-[0.2em] text-[#22C55E]">Assigned Runner</p><p class="mt-2 font-semibold text-[#1F2933]"><?= h($request['runner_name'] ?? 'Not yet assigned') ?></p></div>
                        <div class="rounded-3xl bg-[#F7F7F2] p-5"><p class="text-xs uppercase tracking-[0.2em] text-[#22C55E]">Pickup</p><p class="mt-2 text-sm leading-7 text-[#1F2933]"><?= h($request['pickup_location']) ?></p></div>
                        <div class="rounded-3xl bg-[#F7F7F2] p-5"><p class="text-xs uppercase tracking-[0.2em] text-[#22C55E]">Destination</p><p class="mt-2 text-sm leading-7 text-[#1F2933]"><?= h($request['destination']) ?></p></div>
                        <div class="rounded-3xl bg-[#F7F7F2] p-5"><p class="text-xs uppercase tracking-[0.2em] text-[#22C55E]">Recipient</p><p class="mt-2 font-semibold text-[#1F2933]"><?= h($request['recipient_name']) ?></p><p class="text-sm text-[#1F2933]"><?= h($request['recipient_phone']) ?></p></div>
                        <div class="rounded-3xl bg-[#F7F7F2] p-5"><p class="text-xs uppercase tracking-[0.2em] text-[#22C55E]">Budget / Agreed Amount</p><p class="mt-2 font-semibold text-[#1F2933]"><?= h(money($request['quoted_amount'] ?? $request['budget_amount'])) ?></p><p class="text-sm text-[#1F2933]"><?= h(payment_method_label($request['payment_method'])) ?></p></div>
                    </div>
                    <?php if (!empty($request['delivery_window']) || !empty($request['special_instructions'])): ?>
                        <div class="mt-6 grid gap-4 md:grid-cols-2">
                            <div class="rounded-3xl bg-[#F7F7F2] p-5"><p class="text-xs uppercase tracking-[0.2em] text-[#22C55E]">Delivery Window</p><p class="mt-2 text-sm leading-7 text-[#1F2933]"><?= h($request['delivery_window'] ?: 'Not specified') ?></p></div>
                            <div class="rounded-3xl bg-[#F7F7F2] p-5"><p class="text-xs uppercase tracking-[0.2em] text-[#22C55E]">Instructions</p><p class="mt-2 text-sm leading-7 text-[#1F2933]"><?= h($request['special_instructions'] ?: 'No additional instructions') ?></p></div>
                        </div>
                    <?php endif; ?>
                </article>
                <article class="glass-panel rounded-[2rem] p-8 shadow-sm">
                    <h2 class="text-xl font-semibold text-[#1F2933]">Request Items</h2>
                    <div class="mt-6 space-y-4">
                        <?php foreach ($items as $item): ?>
                            <div class="rounded-3xl border border-[#E5E7EB] p-5">
                                <div class="flex flex-col gap-4 md:flex-row md:items-start md:justify-between">
                                    <div>
                                        <h3 class="text-lg font-semibold text-[#1F2933]"><?= h($item['item_name']) ?></h3>
                                        <p class="mt-1 text-sm text-[#1F2933]">Quantity: <?= h((string) $item['quantity']) ?><?php if ((float) $item['estimated_unit_price'] > 0): ?> | Estimated Unit Price: <?= h(money($item['estimated_unit_price'])) ?><?php endif; ?></p>
                                        <?php if (!empty($item['item_description'])): ?><p class="mt-3 text-sm leading-7 text-[#1F2933]"><?= h($item['item_description']) ?></p><?php endif; ?>
                                    </div>
                                    <?php if (!empty($item['image_path'])): ?><img src="<?= h(upload_url($item['image_path']) ?? '') ?>" alt="Request item image" class="h-28 w-28 rounded-3xl object-cover"><?php endif; ?>
                                </div>
                            </div>
                        <?php endforeach; ?>
                    </div>
                </article>
                <?php if ($itemSamples !== []): ?>
                    <article class="glass-panel rounded-[2rem] p-8 shadow-sm">
                        <h2 class="text-xl font-semibold text-[#1F2933]">Item Samples From Runner</h2>
                        <p class="mt-2 text-sm leading-7 text-[#1F2933]">
                            These photos were shared by the runner while sourcing the item. Choose which one best matches what you want.
                        </p>
                        <div class="mt-6 grid gap-4 md:grid-cols-2">
                            <?php foreach ($itemSamples as $sample): ?>
                                <div class="rounded-3xl border border-[#E5E7EB] p-4">
                                    <div class="flex flex-col gap-3">
                                        <img src="<?= h(upload_url($sample['image_path']) ?? '') ?>" alt="Sample option" class="h-40 w-full rounded-3xl object-cover">
                                        <div class="flex items-center justify-between gap-2">
                                            <div>
                                                <p class="text-sm font-semibold text-[#1F2933]">
                                                    <?= h($sample['caption'] ?? 'Sample option') ?>
                                                </p>
                                                <p class="mt-1 text-xs text-[#1F2933]">
                                                    By <?= h($sample['runner_name']) ?>
                                                    <?php if ($sample['price_estimate'] !== null): ?>
                                                        · Est. <?= h(money($sample['price_estimate'])) ?>
                                                    <?php endif; ?>
                                                </p>
                                            </div>
                                            <?php if ((int) $sample['is_selected'] === 1): ?>
                                                <?= render_badge('Preferred', 'approved') ?>
                                            <?php endif; ?>
                                        </div>
                                        <?php if ((int) $request['requester_id'] === (int) $user['id'] && in_array($request['status'], ['quoted', 'assigned', 'in_progress'], true)): ?>
                                            <form method="post" class="mt-2">
                                                <input type="hidden" name="action" value="select_sample">
                                                <input type="hidden" name="sample_id" value="<?= h((string) $sample['id']) ?>">
                                                <button type="submit" class="<?= h(button_classes('secondary')) ?> w-full">
                                                    <?= (int) $sample['is_selected'] === 1 ? 'Selected as preferred' : 'Mark as preferred' ?>
                                                </button>
                                            </form>
                                        <?php endif; ?>
                                    </div>
                                </div>
                            <?php endforeach; ?>
                        </div>
                    </article>
                <?php endif; ?>
                <article class="glass-panel rounded-[2rem] p-8 shadow-sm">
                    <h2 class="text-xl font-semibold text-[#1F2933]">Quotations</h2>
                    <?php if ($quotes === []): ?>
                        <div class="mt-6"><?= render_empty_state('No quotations yet', 'Runner quotations for this request will appear here.') ?></div>
                    <?php else: ?>
                        <div class="mt-6 space-y-4">
                            <?php foreach ($quotes as $quote): ?>
                                <div class="rounded-3xl border border-[#E5E7EB] p-5">
                                    <div class="flex flex-col gap-3 md:flex-row md:items-start md:justify-between">
                                        <div>
                                            <h3 class="text-lg font-semibold text-[#1F2933]"><?= h($quote['runner_name']) ?></h3>
                                            <p class="mt-1 text-sm text-[#1F2933]"><?= h(money($quote['amount'])) ?></p>
                                            <?php if (!empty($quote['note'])): ?><p class="mt-3 text-sm leading-7 text-[#1F2933]"><?= h($quote['note']) ?></p><?php endif; ?>
                                        </div>
                                        <div class="flex flex-wrap items-center gap-2">
                                            <?= render_badge(status_label($quote['status']), $quote['status']) ?>
                                            <?php if ((int) $request['requester_id'] === (int) $user['id'] && $quote['status'] === 'pending' && empty($request['assigned_runner_id'])): ?>
                                                <form method="post"><input type="hidden" name="action" value="approve_quote"><input type="hidden" name="quote_id" value="<?= h((string) $quote['id']) ?>"><button type="submit" class="<?= h(button_classes('success')) ?>">Approve Quote</button></form>
                                            <?php endif; ?>
                                        </div>
                                    </div>
                                </div>
                            <?php endforeach; ?>
                        </div>
                    <?php endif; ?>
                </article>
                <article class="glass-panel rounded-[2rem] p-8 shadow-sm">
                    <h2 class="text-xl font-semibold text-[#1F2933]">Status Timeline</h2>
                    <div class="mt-6 space-y-4">
                        <?php foreach ($logs as $log): ?>
                            <div class="rounded-3xl bg-[#F7F7F2] p-5">
                                <div class="flex flex-col gap-2 md:flex-row md:items-center md:justify-between">
                                    <div class="flex items-center gap-3">
                                        <?= render_badge(status_label($log['status']), $log['status']) ?>
                                        <p class="text-sm font-semibold text-[#1F2933]"><?= h($log['actor_name'] ?? 'System') ?></p>
                                    </div>
                                    <p class="text-xs uppercase tracking-[0.2em] text-[#22C55E]"><?= h($log['created_at']) ?></p>
                                </div>
                                <?php if (!empty($log['note'])): ?><p class="mt-3 text-sm leading-7 text-[#1F2933]"><?= h($log['note']) ?></p><?php endif; ?>
                            </div>
                        <?php endforeach; ?>
                    </div>
                </article>
                <?php if ($review !== null): ?>
                    <article class="glass-panel rounded-[2rem] p-8 shadow-sm">
                        <h2 class="text-xl font-semibold text-[#1F2933]">Customer Review</h2>
                        <div class="mt-5 flex items-center gap-3">
                            <?= render_stars((int) $review['rating']) ?>
                            <p class="text-sm font-semibold text-[#1F2933]"><?= h((string) $review['rating']) ?>/5</p>
                        </div>
                        <p class="mt-4 text-sm leading-7 text-[#1F2933]"><?= h($review['review_text']) ?></p>
                        <p class="mt-4 text-sm text-[#1F2933]">Review by <?= h($review['reviewer_name']) ?> for <?= h($review['runner_name']) ?></p>
                    </article>
                <?php endif; ?>
            </div>
            <aside class="space-y-6">
                <?php
                $hasLiveLocation = $assignment !== null
                    && array_key_exists('current_lat', $assignment)
                    && array_key_exists('current_lng', $assignment)
                    && $assignment['current_lat'] !== null
                    && $assignment['current_lng'] !== null;
                $isRequestOwner = (int) $request['requester_id'] === (int) $user['id'];
                $isAssignedRunner = $assignment !== null && (int) $assignment['runner_id'] === (int) $user['id'];
                ?>
                <?php if ($hasLiveLocation && ($isRequestOwner || $user['role'] === 'admin' || $isAssignedRunner)): ?>
                    <article class="glass-panel rounded-[2rem] p-6 shadow-sm">
                        <h2 class="text-lg font-semibold text-[#1F2933]">Runner Location</h2>
                        <p class="mt-2 text-sm leading-7 text-[#1F2933]">
                            Last shared position from the assigned runner.
                        </p>
                        <p class="mt-2 text-xs uppercase tracking-[0.18em] text-[#22C55E]">
                            <?= h($assignment['last_location_at'] ?? 'Just now') ?>
                        </p>
                        <div class="mt-4 space-y-2 text-sm text-[#1F2933]">
                            <p>Latitude: <?= h((string) ($assignment['current_lat'] ?? '')) ?> | Longitude: <?= h((string) ($assignment['current_lng'] ?? '')) ?></p>
                            <a
                                href="https://www.google.com/maps?q=<?= h((string) $assignment['current_lat']) ?>,<?= h((string) $assignment['current_lng']) ?>"
                                target="_blank"
                                rel="noopener noreferrer"
                                class="<?= h(button_classes('secondary')) ?> block text-center"
                            >
                                Open in Maps
                            </a>
                        </div>
                    </article>
                <?php endif; ?>
                <?php if ($primaryTransaction !== null && (((int) $request['requester_id'] === (int) $user['id']) || $user['role'] === 'admin')): ?>
                    <article class="glass-panel rounded-[2rem] p-6 shadow-sm">
                        <h2 class="text-lg font-semibold text-[#1F2933]">Payment Details</h2>
                        <p class="mt-2 text-sm leading-7 text-[#1F2933]">
                            This section tracks how payment for this errand will be settled. Secure Mobile Money and card processing
                            will plug in here later; for now, use the reference below when settling offline.
                        </p>
                        <div class="mt-4 grid gap-3 text-sm text-[#1F2933]">
                            <div class="rounded-2xl bg-[#F7F7F2] p-3">
                                <p class="text-xs uppercase tracking-[0.18em] text-[#22C55E]">Amount</p>
                                <p class="mt-1 font-semibold"><?= h(money($primaryTransaction['amount'])) ?></p>
                            </div>
                            <div class="rounded-2xl bg-[#F7F7F2] p-3">
                                <p class="text-xs uppercase tracking-[0.18em] text-[#22C55E]">Method</p>
                                <p class="mt-1 font-semibold"><?= h(payment_method_label($primaryTransaction['payment_method'])) ?></p>
                            </div>
                            <div class="rounded-2xl bg-[#F7F7F2] p-3">
                                <p class="text-xs uppercase tracking-[0.18em] text-[#22C55E]">Reference</p>
                                <p class="mt-1 font-mono text-sm"><?= h($primaryTransaction['transaction_reference']) ?></p>
                            </div>
                            <div class="rounded-2xl bg-[#F7F7F2] p-3">
                                <p class="text-xs uppercase tracking-[0.18em] text-[#22C55E]">Status</p>
                                <p class="mt-1 font-semibold"><?= h(status_label($primaryTransaction['payment_status'])) ?></p>
                            </div>
                        </div>
                        <?php if (in_array($primaryTransaction['payment_method'], ['bank_transfer', 'wallet'], true) && in_array($primaryTransaction['payment_status'], ['pending', 'processing'], true) && (int) $primaryTransaction['payer_id'] === (int) $user['id']): ?>
                            <p class="mt-4 text-xs leading-6 text-[#1F2933]">
                                When online payments are enabled, this page will let you pay using Mobile Money or card directly.
                                For now, complete payment using your usual channel and the platform will record settlement once confirmed.
                            </p>
                        <?php endif; ?>
                    </article>
                <?php endif; ?>
                <?php if ($assignment === null && $suggestedRunners !== [] && (((int) $request['requester_id'] === (int) $user['id']) || $user['role'] === 'admin')): ?>
                    <article class="glass-panel rounded-[2rem] p-6 shadow-sm">
                        <h2 class="text-lg font-semibold text-[#1F2933]">Suggested Nearby Runners</h2>
                        <p class="mt-2 text-sm leading-7 text-[#1F2933]">
                            Based on your profile location, these runners are likely to be closest to this errand.
                            You can notify one or more of them so they can review and respond.
                        </p>
                        <div class="mt-4 space-y-4">
                            <?php foreach ($suggestedRunners as $runner): ?>
                                <?php
                                $runnerActiveJobs = (int) ($runner['active_jobs'] ?? 0);
                                $runnerAvailable = $runnerActiveJobs === 0;
                                ?>
                                <div class="rounded-3xl border border-[#E5E7EB] p-4">
                                    <div class="flex flex-col gap-3 md:flex-row md:items-center md:justify-between">
                                        <div>
                                            <p class="text-sm font-semibold text-[#1F2933]"><?= h($runner['full_name']) ?></p>
                                            <p class="mt-1 text-xs text-[#1F2933]">
                                                <?= h(trim(($runner['city'] ?? '') . ', ' . ($runner['state_region'] ?? ''), ', ')) ?>
                                            </p>
                                            <div class="mt-2 flex items-center gap-2 text-xs text-[#1F2933]">
                                                <?= render_stars((float) $runner['average_rating']) ?>
                                                <span><?= h(number_format((float) $runner['average_rating'], 1)) ?>/5</span>
                                                <span>· <?= h((string) $runner['review_count']) ?> reviews</span>
                                            </div>
                                            <p class="mt-1 text-xs text-[#1F2933]">
                                                <?= h($runnerAvailable ? 'Currently free for new errands.' : 'Busy on other errands right now.') ?>
                                            </p>
                                        </div>
                                        <form method="post" class="mt-2 md:mt-0">
                                            <input type="hidden" name="action" value="invite_runner">
                                            <input type="hidden" name="runner_id" value="<?= h((string) $runner['id']) ?>">
                                            <button type="submit" class="<?= h(button_classes('secondary')) ?>">
                                                Notify this runner
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            <?php endforeach; ?>
                        </div>
                    </article>
                <?php endif; ?>
                <?php if ($assignment !== null && (!empty($assignment['proof_image_path']) || !empty($assignment['proof_note']))): ?>
                    <article class="glass-panel rounded-[2rem] p-6 shadow-sm">
                        <h2 class="text-lg font-semibold text-[#1F2933]">Proof / Completion Note</h2>
                        <?php if (!empty($assignment['proof_image_path'])): ?><img src="<?= h(upload_url($assignment['proof_image_path']) ?? '') ?>" alt="Proof of delivery" class="mt-4 w-full rounded-3xl object-cover"><?php endif; ?>
                        <?php if (!empty($assignment['proof_note'])): ?><p class="mt-4 text-sm leading-7 text-[#1F2933]"><?= h($assignment['proof_note']) ?></p><?php endif; ?>
                    </article>
                <?php endif; ?>
                <?php if ($user['role'] === 'runner' && empty($request['assigned_runner_id']) && in_array($request['status'], ['open', 'quoted'], true)): ?>
                    <article class="glass-panel rounded-[2rem] p-6 shadow-sm">
                        <h2 class="text-lg font-semibold text-[#1F2933]">Runner Actions</h2>
                        <?php if ($request['request_type'] === 'delivery_request' && $request['status'] === 'open'): ?>
                            <form method="post" class="mt-4"><input type="hidden" name="action" value="accept_delivery"><button type="submit" class="<?= h(button_classes('success')) ?> w-full">Accept Delivery Job</button></form>
                        <?php endif; ?>
                        <form method="post" class="mt-4 space-y-4">
                            <input type="hidden" name="action" value="submit_quote">
                            <?= form_input('amount', 'Quote Amount', '', 'number', true, '0.00') ?>
                            <?= form_textarea('note', 'Quote Note', '', false, 'Optional sourcing or delivery note') ?>
                            <button type="submit" class="<?= h(button_classes('primary')) ?> w-full">Submit Quote</button>
                        </form>
                    </article>
                <?php endif; ?>
                <?php if ((($user['role'] === 'runner' && (int) ($request['assigned_runner_id'] ?? 0) === (int) $user['id']) || $user['role'] === 'admin') && in_array($request['status'], ['assigned', 'in_progress'], true)): ?>
                    <article class="glass-panel rounded-[2rem] p-6 shadow-sm">
                        <h2 class="text-lg font-semibold text-[#1F2933]">Execution Controls</h2>
                        <div class="mt-4 space-y-3">
                            <?php if ($user['role'] === 'runner' && $isAssignedRunner): ?>
                                <div class="rounded-2xl bg-[#F7F7F2] p-4">
                                    <p class="text-sm font-semibold text-[#1F2933]">Share Live Location</p>
                                    <p class="mt-2 text-xs leading-6 text-[#1F2933]">
                                        When enabled, this page will share your approximate GPS location for this job so the customer can track progress.
                                    </p>
                                    <button
                                        type="button"
                                        id="toggle-live-location"
                                        class="<?= h(button_classes('secondary')) ?> mt-3 w-full"
                                        data-request-id="<?= h((string) $requestId) ?>"
                                    >
                                        Enable live location
                                    </button>
                                    <p id="live-location-status" class="mt-2 text-xs text-[#1F2933]"></p>
                                </div>
                                <div class="mt-4 rounded-2xl bg-[#F7F7F2] p-4">
                                    <p class="text-sm font-semibold text-[#1F2933]">Share Item Sample Photos</p>
                                    <p class="mt-2 text-xs leading-6 text-[#1F2933]">
                                        When sourcing items, you can share multiple sample photos with approximate prices so the customer can pick their preferred option before you finalize the purchase.
                                    </p>
                                    <form method="post" enctype="multipart/form-data" class="mt-3 space-y-3">
                                        <input type="hidden" name="action" value="add_sample">
                                        <?= form_file('sample_image', 'Sample Image') ?>
                                        <?= form_input('sample_price', 'Estimated Price For This Option (Optional)', '', 'number', false, '0.00') ?>
                                        <?= form_input('sample_caption', 'Short Note (Optional)', '', 'text', false, 'e.g. Option from Owino stall, medium size') ?>
                                        <button type="submit" class="<?= h(button_classes('secondary')) ?> w-full">Upload Sample</button>
                                    </form>
                                </div>
                            <?php endif; ?>
                            <?php if ($request['status'] === 'assigned'): ?><form method="post"><input type="hidden" name="action" value="start_progress"><button type="submit" class="<?= h(button_classes('primary')) ?> w-full">Start Request</button></form><?php endif; ?>
                            <form method="post" enctype="multipart/form-data" class="space-y-4">
                                <input type="hidden" name="action" value="mark_completed">
                                <?= form_file('proof_image', 'Proof of Delivery / Completion Image') ?>
                                <?= form_textarea('proof_note', 'Completion Note', '', false, 'Optional proof note or delivery confirmation details') ?>
                                <button type="submit" class="<?= h(button_classes('success')) ?> w-full">Mark As Completed</button>
                            </form>
                        </div>
                    </article>
                <?php endif; ?>
                <?php if ((((int) $request['requester_id'] === (int) $user['id']) || $user['role'] === 'admin') && $request['status'] === 'completed'): ?>
                    <article class="glass-panel rounded-[2rem] p-6 shadow-sm">
                        <h2 class="text-lg font-semibold text-[#1F2933]">Confirmation</h2>
                        <p class="mt-3 text-sm leading-7 text-[#1F2933]">The runner has marked this request as completed. Confirm it once the delivery has been verified.</p>
                        <form method="post" class="mt-4"><input type="hidden" name="action" value="confirm_delivery"><button type="submit" class="<?= h(button_classes('success')) ?> w-full">Confirm Delivery</button></form>
                    </article>
                <?php endif; ?>
                <?php if ((int) $request['requester_id'] === (int) $user['id'] && $request['status'] === 'confirmed' && $assignment !== null && $review === null): ?>
                    <article class="glass-panel rounded-[2rem] p-6 shadow-sm">
                        <h2 class="text-lg font-semibold text-[#1F2933]">Rate This Runner</h2>
                        <p class="mt-3 text-sm leading-7 text-[#1F2933]">Share how the service went so other customers can make better decisions.</p>
                        <form method="post" class="mt-4 space-y-4">
                            <input type="hidden" name="action" value="submit_review">
                            <?= form_select('rating', 'Star Rating', ['5' => '5 Stars', '4' => '4 Stars', '3' => '3 Stars', '2' => '2 Stars', '1' => '1 Star'], '5', true) ?>
                            <?= form_textarea('review_text', 'Review', '', true, 'Describe the speed, communication, and overall service quality.') ?>
                            <button type="submit" class="<?= h(button_classes('primary')) ?> w-full">Submit Review</button>
                        </form>
                    </article>
                <?php endif; ?>
                <?php if ((((int) $request['requester_id'] === (int) $user['id']) || $user['role'] === 'admin') && !in_array($request['status'], ['confirmed', 'cancelled'], true)): ?>
                    <article class="glass-panel rounded-[2rem] p-6 shadow-sm">
                        <h2 class="text-lg font-semibold text-[#1F2933]">Cancel Request</h2>
                        <p class="mt-3 text-sm leading-7 text-[#1F2933]">Use this only if the errand should no longer proceed.</p>
                        <form method="post" class="mt-4"><input type="hidden" name="action" value="cancel_request"><button type="submit" data-confirm="Cancel this request?" class="<?= h(button_classes('danger')) ?> w-full">Cancel Request</button></form>
                    </article>
                <?php endif; ?>
            </aside>
        </div>
    </section>
</div>
<?php if ($user['role'] === 'runner' && $assignment !== null && (int) $assignment['runner_id'] === (int) $user['id'] && in_array($assignment['status'], ['assigned', 'in_progress'], true)): ?>
<script>
    (function () {
        const button = document.getElementById('toggle-live-location');
        const statusEl = document.getElementById('live-location-status');
        if (!button || !statusEl || !navigator.geolocation) {
            if (statusEl) {
                statusEl.textContent = 'Live location is not available on this device.';
            }
            return;
        }

        let watchId = null;
        let enabled = false;
        const requestId = button.getAttribute('data-request-id');

        function setStatus(message, isError) {
            statusEl.textContent = message;
            statusEl.style.color = isError ? '#b91c1c' : '#1F2933';
        }

        async function sendLocation(lat, lng) {
            try {
                const response = await fetch('<?= h(page_url('runner-location-update.php')) ?>', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: new URLSearchParams({
                        request_id: requestId,
                        lat: String(lat),
                        lng: String(lng)
                    })
                });
                const data = await response.json();
                if (!data.ok) {
                    setStatus(data.error || 'Unable to update location.', true);
                } else {
                    setStatus('Location shared at ' + data.last_location_at + '.', false);
                }
            } catch (error) {
                setStatus('Network error while sharing location.', true);
            }
        }

        function startSharing() {
            if (!navigator.geolocation) {
                setStatus('Geolocation is not supported in this browser.', true);
                return;
            }
            enabled = true;
            button.textContent = 'Disable live location';
            setStatus('Requesting location permission…', false);
            watchId = navigator.geolocation.watchPosition(
                (position) => {
                    const { latitude, longitude } = position.coords;
                    sendLocation(latitude, longitude);
                },
                (error) => {
                    enabled = false;
                    button.textContent = 'Enable live location';
                    switch (error.code) {
                        case error.PERMISSION_DENIED:
                            setStatus('Location permission denied. Enable it in your browser settings.', true);
                            break;
                        case error.POSITION_UNAVAILABLE:
                            setStatus('Location information is unavailable.', true);
                            break;
                        case error.TIMEOUT:
                            setStatus('Location request timed out.', true);
                            break;
                        default:
                            setStatus('Unable to get your location.', true);
                    }
                },
                {
                    enableHighAccuracy: false,
                    maximumAge: 10000,
                    timeout: 20000
                }
            );
        }

        function stopSharing() {
            enabled = false;
            if (watchId !== null) {
                navigator.geolocation.clearWatch(watchId);
                watchId = null;
            }
            button.textContent = 'Enable live location';
            setStatus('Live location sharing stopped.', false);
        }

        button.addEventListener('click', function () {
            if (enabled) {
                stopSharing();
            } else {
                startSharing();
            }
        });
    })();
</script>
<?php endif; ?>
<?php require_once __DIR__ . '/../layouts/footer.php'; ?>
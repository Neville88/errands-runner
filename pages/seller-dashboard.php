<?php

declare(strict_types=1);

require_once __DIR__ . '/../includes/role_guard.php';
require_once __DIR__ . '/../layouts/dashboard_header.php';
require_once __DIR__ . '/../layouts/dashboard_sidebar.php';
require_once __DIR__ . '/../components/cards.php';
require_once __DIR__ . '/../components/buttons.php';
require_once __DIR__ . '/../components/badges.php';
require_once __DIR__ . '/../components/tables.php';

require_role('seller');

$user = current_user();
$metrics = dashboard_metrics($user);
$recent = recent_requests($user);
$pageTitle = 'Seller Dashboard';
$pageDescription = 'Manage deliveries from store or inventory to customer destinations.';
require_once __DIR__ . '/../layouts/header.php';
?>
<div class="grid gap-6 lg:grid-cols-[280px_1fr]">
    <?php render_dashboard_sidebar('dashboard.php'); ?>
    <section>
        <?php render_dashboard_header('Seller Dashboard', 'Create delivery requests, monitor assignments, and confirm successful handoffs.', '<a href="' . h(page_url('request-create.php')) . '" class="' . h(button_classes('primary')) . '">New Delivery Request</a>'); ?>
        <div class="grid gap-4 md:grid-cols-2 xl:grid-cols-4">
            <?= render_stat_card('Total Requests', (string) $metrics['total'], 'All seller requests you created.', 'action') ?>
            <?= render_stat_card('Quoted', (string) $metrics['quoted'], 'Requests waiting for your review.', 'warm') ?>
            <?= render_stat_card('Active', (string) $metrics['active'], 'Assigned or currently in progress.', 'muted') ?>
            <?= render_stat_card('Completed', (string) $metrics['completed'], 'Finished or confirmed requests.', 'surface') ?>
        </div>
        <div class="glass-panel mt-6 rounded-[2rem] p-8 shadow-sm">
            <h2 class="text-xl font-semibold text-[#1F2933]">Recent Requests</h2>
            <p class="mt-1 text-sm text-[#1F2933]">Open any request to track its status, assigned runner, and handoff history.</p>
            <?php if ($recent === []): ?><div class="mt-6"><?= render_empty_state('No requests created yet', 'Start by submitting a delivery request for your customers.') ?></div><?php else: ?><div class="mt-6 space-y-4"><?php foreach ($recent as $request): ?><a href="<?= h(page_url('request-details.php?id=' . $request['id'])) ?>" class="block rounded-3xl border border-[#E5E7EB] p-5 transition hover:border-[#22C55E]"><div class="flex flex-col gap-3 md:flex-row md:items-center md:justify-between"><div><h3 class="text-lg font-semibold text-[#1F2933]"><?= h($request['title']) ?></h3><p class="mt-1 text-sm text-[#1F2933]"><?= h($request['destination']) ?></p></div><?= render_badge(status_label($request['status']), $request['status']) ?></div></a><?php endforeach; ?></div><?php endif; ?>
        </div>
    </section>
</div>
<?php require_once __DIR__ . '/../layouts/footer.php'; ?>
<?php

declare(strict_types=1);

require_once __DIR__ . '/../includes/role_guard.php';
require_once __DIR__ . '/../layouts/dashboard_header.php';
require_once __DIR__ . '/../layouts/dashboard_sidebar.php';
require_once __DIR__ . '/../components/cards.php';
require_once __DIR__ . '/../components/buttons.php';
require_once __DIR__ . '/../components/badges.php';
require_once __DIR__ . '/../components/tables.php';

require_role('admin');

$user = current_user();
$metrics = dashboard_metrics($user);
$recent = recent_requests($user, 6);
$pageTitle = 'Admin Dashboard';
$pageDescription = 'Platform operations, visibility control, and user supervision.';
require_once __DIR__ . '/../layouts/header.php';
?>
<div class="grid gap-6 lg:grid-cols-[280px_1fr]">
    <?php render_dashboard_sidebar('dashboard.php'); ?>
    <section>
        <?php render_dashboard_header('Admin Dashboard', 'Monitor users, requests, transaction status, and overall platform activity.', '<a href="' . h(page_url('manage-requests.php')) . '" class="' . h(button_classes('primary')) . '">Manage Requests</a>'); ?>
        <div class="grid gap-4 md:grid-cols-2 xl:grid-cols-4">
            <?= render_stat_card('Users', (string) $metrics['users'], 'All registered platform users.', 'action') ?>
            <?= render_stat_card('Requests', (string) $metrics['requests'], 'Total requests in the system.', 'warm') ?>
            <?= render_stat_card('Active Requests', (string) $metrics['active_requests'], 'Open, quoted, assigned, or ongoing.', 'muted') ?>
            <?= render_stat_card('Pending Transactions', (string) $metrics['transactions'], 'Transactions awaiting final settlement.', 'surface') ?>
        </div>
        <div class="glass-panel mt-6 rounded-[2rem] p-8 shadow-sm">
            <h2 class="text-xl font-semibold text-[#1F2933]">Recent Platform Requests</h2>
            <?php if ($recent === []): ?><div class="mt-6"><?= render_empty_state('No requests found', 'Once users submit requests, they will appear here for oversight.') ?></div><?php else: ?><div class="mt-6 space-y-4"><?php foreach ($recent as $request): ?><a href="<?= h(page_url('request-details.php?id=' . $request['id'])) ?>" class="block rounded-3xl border border-[#E5E7EB] p-5 transition hover:border-[#22C55E]"><div class="flex flex-col gap-3 md:flex-row md:items-center md:justify-between"><div><h3 class="text-lg font-semibold text-[#1F2933]"><?= h($request['title']) ?></h3><p class="mt-1 text-sm text-[#1F2933]"><?= h($request['requester_name']) ?> | <?= h($request['runner_name'] ?? 'No runner assigned') ?></p></div><?= render_badge(status_label($request['status']), $request['status']) ?></div></a><?php endforeach; ?></div><?php endif; ?>
        </div>
    </section>
</div>
<?php require_once __DIR__ . '/../layouts/footer.php'; ?>
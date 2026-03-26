<?php

declare(strict_types=1);

require_once __DIR__ . '/../includes/role_guard.php';
require_once __DIR__ . '/../layouts/dashboard_header.php';
require_once __DIR__ . '/../layouts/dashboard_sidebar.php';
require_once __DIR__ . '/../components/cards.php';
require_once __DIR__ . '/../components/badges.php';
require_once __DIR__ . '/../components/tables.php';

require_role('runner');

$user = current_user();
$metrics = dashboard_metrics($user);
$recent = recent_requests($user, 6);
$pageTitle = 'Runner Dashboard';
$pageDescription = 'Review available jobs, assigned errands, proof uploads, and completion progress.';
require_once __DIR__ . '/../layouts/header.php';
?>
<div class="grid gap-6 lg:grid-cols-[280px_1fr]">
    <?php render_dashboard_sidebar('dashboard.php'); ?>
    <section>
        <?php render_dashboard_header('Runner Dashboard', 'Accept delivery jobs, quote open errands, and keep statuses updated with proof when needed.'); ?>
        <div class="grid gap-4 md:grid-cols-2 xl:grid-cols-4">
            <?= render_stat_card('Available Jobs', (string) $metrics['available'], 'Visible requests awaiting a runner.', 'action') ?>
            <?= render_stat_card('Assigned', (string) $metrics['assigned'], 'Jobs already assigned to you.', 'warm') ?>
            <?= render_stat_card('In Progress', (string) $metrics['in_progress'], 'Jobs currently being fulfilled.', 'muted') ?>
            <?= render_stat_card('Completed', (string) $metrics['completed'], 'Finished or confirmed assignments.', 'surface') ?>
        </div>
        <div class="glass-panel mt-6 rounded-[2rem] p-8 shadow-sm">
            <h2 class="text-xl font-semibold text-[#1F2933]">Latest Opportunities & Assignments</h2>
            <?php if ($recent === []): ?><div class="mt-6"><?= render_empty_state('No runner items yet', 'Open requests and assigned errands will appear here.') ?></div><?php else: ?><div class="mt-6 space-y-4"><?php foreach ($recent as $request): ?><a href="<?= h(page_url('request-details.php?id=' . $request['id'])) ?>" class="block rounded-3xl border border-[#E5E7EB] p-5 transition hover:border-[#22C55E]"><div class="flex flex-col gap-3 md:flex-row md:items-center md:justify-between"><div><h3 class="text-lg font-semibold text-[#1F2933]"><?= h($request['title']) ?></h3><p class="mt-1 text-sm text-[#1F2933]"><?= h($request['requester_name']) ?> | <?= h(request_type_label($request['request_type'])) ?></p></div><?= render_badge(status_label($request['status']), $request['status']) ?></div></a><?php endforeach; ?></div><?php endif; ?>
        </div>
    </section>
</div>
<?php require_once __DIR__ . '/../layouts/footer.php'; ?>
<?php

declare(strict_types=1);

require_once __DIR__ . '/../includes/auth.php';
require_once __DIR__ . '/../layouts/dashboard_header.php';
require_once __DIR__ . '/../layouts/dashboard_sidebar.php';
require_once __DIR__ . '/../components/buttons.php';
require_once __DIR__ . '/../components/forms.php';
require_once __DIR__ . '/../components/badges.php';
require_once __DIR__ . '/../components/tables.php';

require_auth();

$user = current_user();
$filters = [
    'status' => trim((string) ($_GET['status'] ?? '')),
    'request_type' => trim((string) ($_GET['request_type'] ?? '')),
];
$requests = fetch_requests_for_user($user, $filters);
$actions = in_array($user['role'], ['seller', 'buyer'], true) ? '<a href="' . h(page_url('request-create.php')) . '" class="' . h(button_classes('primary')) . '">Create Request</a>' : '';

$pageTitle = 'Requests';
$pageDescription = 'Track the status of all errands you have created or are involved in.';
require_once __DIR__ . '/../layouts/header.php';
?>
<div class="grid gap-6 lg:grid-cols-[280px_1fr]">
    <?php render_dashboard_sidebar('requests.php'); ?>
    <section>
        <?php render_dashboard_header('Requests', 'Track your errands from open to completed, and drill into each request for full details.', $actions); ?>
        <div class="glass-panel mb-6 rounded-[2rem] p-6 shadow-sm">
            <form method="get" class="grid gap-4 md:grid-cols-3">
                <?= form_select('status', 'Status', ['' => 'All Statuses'] + REQUEST_STATUSES, $filters['status']) ?>
                <?= form_select('request_type', 'Request Type', ['' => 'All Request Types'] + REQUEST_TYPES, $filters['request_type']) ?>
                <div class="flex items-end"><button type="submit" class="<?= h(button_classes('secondary')) ?>">Apply Filters</button></div>
            </form>
        </div>
        <div class="glass-panel overflow-hidden rounded-[2rem] shadow-sm">
            <?php if ($requests === []): ?>
                <div class="p-8"><?= render_empty_state('No requests found', 'There are no requests to display for the selected filters.') ?></div>
            <?php else: ?>
                <div class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-[#E5E7EB] text-sm">
                        <thead class="bg-[#F7F7F2] text-left text-[#1F2933]"><tr><th class="px-6 py-4 font-semibold">Request</th><th class="px-6 py-4 font-semibold">Type</th><th class="px-6 py-4 font-semibold">Status</th><th class="px-6 py-4 font-semibold">Runner</th><th class="px-6 py-4 font-semibold">Amount</th><th class="px-6 py-4 font-semibold"></th></tr></thead>
                        <tbody class="divide-y divide-[#E5E7EB]">
                            <?php foreach ($requests as $request): ?>
                                <tr>
                                    <td class="px-6 py-4"><div class="font-semibold text-[#1F2933]"><?= h($request['title']) ?></div><div class="mt-1 text-xs text-[#1F2933]"><?= h($request['requester_name']) ?></div></td>
                                    <td class="px-6 py-4 text-[#1F2933]"><?= h(request_type_label($request['request_type'])) ?></td>
                                    <td class="px-6 py-4"><?= render_badge(status_label($request['status']), $request['status']) ?></td>
                                    <td class="px-6 py-4 text-[#1F2933]"><?= h($request['runner_name'] ?? 'Unassigned') ?></td>
                                    <td class="px-6 py-4 text-[#1F2933]"><?= h(money($request['quoted_amount'] ?? $request['budget_amount'])) ?></td>
                                    <td class="px-6 py-4 text-right"><a href="<?= h(page_url('request-details.php?id=' . $request['id'])) ?>" class="font-semibold text-[#14532D]">Track</a></td>
                                </tr>
                            <?php endforeach; ?>
                        </tbody>
                    </table>
                </div>
            <?php endif; ?>
        </div>
    </section>
</div>
<?php require_once __DIR__ . '/../layouts/footer.php'; ?>
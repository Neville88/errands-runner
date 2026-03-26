<?php

declare(strict_types=1);

require_once __DIR__ . '/../includes/role_guard.php';
require_once __DIR__ . '/../layouts/dashboard_header.php';
require_once __DIR__ . '/../layouts/dashboard_sidebar.php';
require_once __DIR__ . '/../components/badges.php';
require_once __DIR__ . '/../components/tables.php';

require_role('admin');

$user = current_user();
if (request_method_is('POST')) {
    $requestId = (int) ($_POST['request_id'] ?? 0);
    $action = (string) ($_POST['action'] ?? '');
    if ($requestId > 0 && $action === 'toggle_visibility' && toggle_request_visibility($requestId, (int) $user['id'])) {
        set_flash('success', 'Request visibility updated.');
        redirect('pages/manage-requests.php');
    }
    if ($requestId > 0 && $action === 'set_status') {
        $status = (string) ($_POST['status'] ?? 'open');
        if (array_key_exists($status, REQUEST_STATUSES) && update_request_status_action($requestId, (int) $user['id'], $status, 'Admin status override.')) {
            set_flash('success', 'Request status updated.');
            redirect('pages/manage-requests.php');
        }
    }
    set_flash('error', 'Unable to update the request.');
    redirect('pages/manage-requests.php');
}

$requests = fetch_requests_for_user($user);
$pageTitle = 'Manage Requests';
$pageDescription = 'Admin controls for request visibility and status overrides.';
require_once __DIR__ . '/../layouts/header.php';
?>
<div class="grid gap-6 lg:grid-cols-[280px_1fr]">
    <?php render_dashboard_sidebar('manage-requests.php'); ?>
    <section>
        <?php render_dashboard_header('Manage Requests', 'Oversee lifecycle state, runner visibility, and operational intervention.'); ?>
        <div class="space-y-4">
            <?php if ($requests === []): ?>
                <?= render_empty_state('No requests available', 'Requests will appear here when users begin using the system.') ?>
            <?php else: ?>
                <?php foreach ($requests as $request): ?>
                    <article class="glass-panel rounded-[2rem] p-6 shadow-sm">
                        <div class="flex flex-col gap-4 xl:flex-row xl:items-center xl:justify-between">
                            <div>
                                <h2 class="text-xl font-semibold text-[#1F2933]"><?= h($request['title']) ?></h2>
                                <p class="mt-2 text-sm text-[#1F2933]"><?= h($request['requester_name']) ?> | <?= h(request_type_label($request['request_type'])) ?> | <?= h($request['runner_name'] ?? 'No runner assigned') ?></p>
                                <div class="mt-3 flex flex-wrap gap-2">
                                    <?= render_badge(status_label($request['status']), $request['status']) ?>
                                    <?= render_badge($request['visibility_status'] === 'public' ? 'Visible' : 'Hidden', $request['visibility_status'] === 'public' ? 'approved' : 'cancelled') ?>
                                </div>
                            </div>
                            <div class="flex flex-col gap-3 md:flex-row">
                                <form method="post" class="flex items-center gap-3">
                                    <input type="hidden" name="action" value="set_status">
                                    <input type="hidden" name="request_id" value="<?= h((string) $request['id']) ?>">
                                    <select name="status" class="rounded-2xl border border-[#E5E7EB] bg-[#F7F7F2]/95 px-4 py-2 text-sm text-[#1F2933]">
                                        <?php foreach (REQUEST_STATUSES as $statusKey => $statusLabel): ?><option value="<?= h($statusKey) ?>" <?= $request['status'] === $statusKey ? 'selected' : '' ?>><?= h($statusLabel) ?></option><?php endforeach; ?>
                                    </select>
                                    <button type="submit" class="rounded-2xl bg-[#14532D] px-4 py-2 text-sm font-semibold text-[#F7F7F2]">Update</button>
                                </form>
                                <form method="post"><input type="hidden" name="action" value="toggle_visibility"><input type="hidden" name="request_id" value="<?= h((string) $request['id']) ?>"><button type="submit" class="rounded-2xl border border-[#E5E7EB] bg-[#F7F7F2]/90 px-4 py-2 text-sm font-semibold text-[#14532D]"><?= $request['visibility_status'] === 'public' ? 'Hide' : 'Show' ?></button></form>
                                <a href="<?= h(page_url('request-details.php?id=' . $request['id'])) ?>" class="rounded-2xl border border-[#E5E7EB] bg-[#F7F7F2]/90 px-4 py-2 text-sm font-semibold text-[#14532D]">Open</a>
                            </div>
                        </div>
                    </article>
                <?php endforeach; ?>
            <?php endif; ?>
        </div>
    </section>
</div>
<?php require_once __DIR__ . '/../layouts/footer.php'; ?>
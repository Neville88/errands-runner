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
    $targetId = (int) ($_POST['user_id'] ?? 0);
    if ($targetId > 0 && $targetId !== (int) $user['id'] && toggle_user_status($targetId)) {
        set_flash('success', 'User status updated.');
        redirect('pages/manage-users.php');
    }
    set_flash('error', 'Unable to update user status.');
    redirect('pages/manage-users.php');
}

$users = list_users();
$pageTitle = 'Manage Users';
$pageDescription = 'View all platform users and control account status.';
require_once __DIR__ . '/../layouts/header.php';
?>
<div class="grid gap-6 lg:grid-cols-[280px_1fr]">
    <?php render_dashboard_sidebar('manage-users.php'); ?>
    <section>
        <?php render_dashboard_header('Manage Users', 'Supervise registered accounts and disable or enable access when necessary.'); ?>
        <div class="glass-panel overflow-hidden rounded-[2rem] shadow-sm">
            <?php if ($users === []): ?><div class="p-8"><?= render_empty_state('No users found', 'User registrations will appear here once accounts are created.') ?></div><?php else: ?><div class="overflow-x-auto"><table class="min-w-full divide-y divide-[#E5E7EB] text-sm"><thead class="bg-[#F7F7F2] text-left text-[#1F2933]"><tr><th class="px-6 py-4 font-semibold">Name</th><th class="px-6 py-4 font-semibold">Role</th><th class="px-6 py-4 font-semibold">Email</th><th class="px-6 py-4 font-semibold">Status</th><th class="px-6 py-4 font-semibold"></th></tr></thead><tbody class="divide-y divide-[#E5E7EB]"><?php foreach ($users as $record): ?><tr><td class="px-6 py-4"><div class="font-semibold text-[#1F2933]"><?= h($record['full_name']) ?></div><div class="mt-1 text-xs text-[#1F2933]"><?= h($record['phone']) ?></div></td><td class="px-6 py-4"><?= render_badge(role_label($record['role']), $record['role']) ?></td><td class="px-6 py-4 text-[#1F2933]"><?= h($record['email']) ?></td><td class="px-6 py-4"><?= render_badge((int) $record['is_active'] === 1 ? 'Active' : 'Disabled', (int) $record['is_active'] === 1 ? 'approved' : 'cancelled') ?></td><td class="px-6 py-4 text-right"><?php if ((int) $record['id'] !== (int) $user['id']): ?><form method="post"><input type="hidden" name="user_id" value="<?= h((string) $record['id']) ?>"><button type="submit" class="font-semibold text-[#14532D]"><?= (int) $record['is_active'] === 1 ? 'Disable' : 'Enable' ?></button></form><?php else: ?><span class="text-xs text-[#22C55E]">Current Admin</span><?php endif; ?></td></tr><?php endforeach; ?></tbody></table></div><?php endif; ?>
        </div>
    </section>
</div>
<?php require_once __DIR__ . '/../layouts/footer.php'; ?>
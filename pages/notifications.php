<?php

declare(strict_types=1);

require_once __DIR__ . '/../includes/auth.php';
require_once __DIR__ . '/../layouts/dashboard_header.php';
require_once __DIR__ . '/../layouts/dashboard_sidebar.php';
require_once __DIR__ . '/../components/tables.php';

require_auth();

$user = current_user();
mark_notifications_read((int) $user['id']);
$notifications = list_notifications_for_user($user);
$pageTitle = 'Notifications';
$pageDescription = 'System alerts, request updates, and workflow notifications.';
require_once __DIR__ . '/../layouts/header.php';
?>
<div class="grid gap-6 lg:grid-cols-[280px_1fr]">
    <?php render_dashboard_sidebar('notifications.php'); ?>
    <section>
        <?php render_dashboard_header('Notifications', 'Stay informed on quotation updates, assignments, deliveries, and admin activity.'); ?>
        <div class="space-y-4">
            <?php if ($notifications === []): ?>
                <?= render_empty_state('No notifications yet', 'Platform alerts and workflow updates will appear here.') ?>
            <?php else: ?>
                <?php foreach ($notifications as $notification): ?>
                    <article class="glass-panel rounded-[2rem] p-6 shadow-sm">
                        <div class="flex flex-col gap-4 md:flex-row md:items-start md:justify-between">
                            <div>
                                <h2 class="text-lg font-semibold text-[#1F2933]"><?= h($notification['title']) ?></h2>
                                <p class="mt-2 text-sm leading-7 text-[#1F2933]"><?= h($notification['message']) ?></p>
                                <p class="mt-3 text-xs uppercase tracking-[0.2em] text-[#22C55E]"><?= h($notification['full_name']) ?> | <?= h($notification['created_at']) ?></p>
                            </div>
                            <?php if (!empty($notification['link_url'])): ?>
                                <?php
                                $rawLink = (string) $notification['link_url'];
                                $resolvedLink = preg_match('/^https?:\/\//i', $rawLink)
                                    ? $rawLink
                                    : app_url(ltrim($rawLink, '/'));
                                ?>
                                <a href="<?= h($resolvedLink) ?>" class="font-semibold text-[#14532D]">Open</a>
                            <?php endif; ?>
                        </div>
                    </article>
                <?php endforeach; ?>
            <?php endif; ?>
        </div>
    </section>
</div>
<?php require_once __DIR__ . '/../layouts/footer.php'; ?>
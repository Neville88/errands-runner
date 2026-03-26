<?php

declare(strict_types=1);

require_once __DIR__ . '/../components/badges.php';

function render_dashboard_sidebar(string $currentPage): void
{
    $user = current_user();
    if ($user === null) { return; }

    $links = [
        ['file' => 'dashboard.php', 'label' => 'Dashboard'],
        ['file' => 'profile.php', 'label' => 'Profile'],
        ['file' => 'requests.php', 'label' => 'Requests'],
        ['file' => 'quotations.php', 'label' => 'Quotations'],
        ['file' => 'notifications.php', 'label' => 'Notifications'],
        ['file' => 'transactions.php', 'label' => 'Transactions'],
    ];

    if (in_array($user['role'], ['seller', 'buyer'], true)) {
        $links[] = ['file' => 'request-create.php', 'label' => 'Create Request'];
    }
    if ($user['role'] === 'admin') {
        $links[] = ['file' => 'manage-users.php', 'label' => 'Manage Users'];
        $links[] = ['file' => 'manage-requests.php', 'label' => 'Manage Requests'];
    }
    ?>
    <aside class="dashboard-shell rounded-[2rem] bg-[#1F2933]/92 p-6 text-[#F7F7F2] shadow-xl backdrop-blur">
        <div class="border-b border-[#E5E7EB]/20 pb-6">
            <p class="text-sm font-semibold uppercase tracking-[0.24em] text-[#22C55E]">Signed In As</p>
            <h2 class="mt-3 text-xl font-semibold"><?= h($user['full_name']) ?></h2>
            <p class="mt-2 text-sm text-[#F7F7F2]/80"><?= h($user['email']) ?></p>
            <div class="mt-3"><?= render_badge(role_label($user['role']), $user['role']) ?></div>
        </div>
        <nav class="mt-6 space-y-2">
            <?php foreach ($links as $link): ?>
                <a href="<?= h(page_url($link['file'])) ?>" class="block rounded-2xl px-4 py-3 text-sm font-medium transition <?= $currentPage === $link['file'] ? 'bg-[#F7F7F2] text-[#14532D]' : 'text-[#F7F7F2]/80 hover:bg-[#14532D]/70 hover:text-[#F7F7F2]' ?>">
                    <?= h($link['label']) ?>
                </a>
            <?php endforeach; ?>
        </nav>
    </aside>
    <?php
}
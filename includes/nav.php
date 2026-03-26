<?php

declare(strict_types=1);

require_once __DIR__ . '/functions.php';
require_once __DIR__ . '/../components/buttons.php';

function render_nav(): void
{
    $user = current_user();
    $notificationCount = $user !== null ? unread_notification_count((int) $user['id']) : 0;
    ?>
    <header class="sticky top-0 z-40 border-b border-[#E5E7EB]/60 bg-[#1F2933]/88 backdrop-blur">
        <div class="mx-auto flex max-w-7xl items-center justify-between gap-4 px-4 py-4 sm:px-6 lg:px-8">
            <a href="<?= h(app_url()) ?>" class="flex items-center gap-3 text-lg font-bold text-[#F7F7F2]">
                <span class="inline-flex h-11 w-11 items-center justify-center rounded-2xl bg-[#14532D] text-sm font-semibold text-[#F7F7F2]">ER</span>
                <span><?= h(APP_NAME) ?></span>
            </a>
            <nav class="hidden items-center gap-6 text-sm font-medium text-[#F7F7F2]/80 md:flex">
                <a href="<?= h(app_url()) ?>" class="hover:text-[#22C55E]">Home</a>
                <a href="<?= h(page_url('about.php')) ?>" class="hover:text-[#22C55E]">About</a>
                <a href="<?= h(page_url('services.php')) ?>" class="hover:text-[#22C55E]">Services</a>
                <a href="<?= h(page_url('contact.php')) ?>" class="hover:text-[#22C55E]">Contact</a>
            </nav>
            <div class="flex items-center gap-3">
                <?php if ($user === null): ?>
                    <a href="<?= h(page_url('login.php')) ?>" class="<?= h(button_classes('secondary')) ?>">Sign In</a>
                    <a href="<?= h(page_url('register.php')) ?>" class="<?= h(button_classes('primary')) ?>">Create Account</a>
                <?php else: ?>
                    <a href="<?= h(page_url('notifications.php')) ?>" class="relative rounded-2xl border border-[#E5E7EB]/60 bg-[#F7F7F2]/90 px-4 py-2 text-sm font-semibold text-[#14532D]">
                        Notifications
                        <?php if ($notificationCount > 0): ?>
                            <span class="absolute -right-2 -top-2 inline-flex h-6 min-w-6 items-center justify-center rounded-full bg-[#14532D] px-2 text-xs font-bold text-[#F7F7F2]"><?= h((string) $notificationCount) ?></span>
                        <?php endif; ?>
                    </a>
                    <a href="<?= h(app_url(role_dashboard_path((string) $user['role']))) ?>" class="hidden sm:inline-flex <?= h(button_classes('secondary')) ?>">Dashboard</a>
                    <a href="<?= h(page_url('logout.php')) ?>" class="<?= h(button_classes('primary')) ?>">Logout</a>
                <?php endif; ?>
            </div>
        </div>
    </header>
    <?php
}
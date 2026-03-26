<?php

declare(strict_types=1);

require_once __DIR__ . '/../components/buttons.php';
$pageTitle = 'Services';
$pageDescription = 'Core errands runner services and role-specific capabilities.';
require_once __DIR__ . '/../layouts/header.php';
?>
<section class="grid gap-6 lg:grid-cols-2">
    <article class="glass-panel rounded-[2rem] p-8 shadow-sm"><h1 class="text-3xl font-bold text-[#1F2933]">Core Services</h1><ul class="mt-6 space-y-4 text-sm leading-7 text-[#1F2933]"><li>Seller delivery request creation and customer fulfillment tracking</li><li>Buyer item purchase errands, pickup/dropoff tasks, and custom errands</li><li>Runner quotation, acceptance, status updates, and proof handling</li><li>Notifications, transaction records, and lifecycle confirmations</li><li>Admin controls for users, requests, visibility, and operational oversight</li></ul></article>
    <article class="rounded-[2rem] brand-gradient p-8 text-white shadow-sm"><h2 class="text-2xl font-semibold">Designed For Maintainability</h2><p class="mt-4 text-sm leading-7 text-white/90">The system is intentionally organized around reusable includes, components, layouts, and route responsibilities so future enhancements remain clear and scalable.</p><div class="mt-8"><a href="<?= h(page_url('register.php')) ?>" class="<?= h(button_classes('secondary')) ?> border-white/40 bg-white/90">Start Using The Platform</a></div></article>
</section>
<?php require_once __DIR__ . '/../layouts/footer.php'; ?>
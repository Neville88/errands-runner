<?php

declare(strict_types=1);

$pageTitle = 'About';
$pageDescription = 'Learn how Errands Runner supports multi-role errands and delivery coordination.';
require_once __DIR__ . '/../layouts/header.php';
?>
<section class="glass-panel rounded-[2rem] p-8 shadow-sm">
    <p class="text-sm font-semibold uppercase tracking-[0.3em] text-[#22C55E]">About The Platform</p>
    <h1 class="mt-4 text-4xl font-bold text-[#1F2933]">Built for dependable errand and delivery coordination.</h1>
    <div class="mt-6 grid gap-8 lg:grid-cols-3">
        <article><h2 class="text-xl font-semibold text-[#1F2933]">Sellers</h2><p class="mt-3 text-sm leading-7 text-[#1F2933]">Create structured delivery requests, specify packages, and confirm completed movement.</p></article>
        <article><h2 class="text-xl font-semibold text-[#1F2933]">Buyers</h2><p class="mt-3 text-sm leading-7 text-[#1F2933]">Request item purchase, pickup/dropoff, and custom errands with quotations where appropriate.</p></article>
        <article><h2 class="text-xl font-semibold text-[#1F2933]">Runners & Admins</h2><p class="mt-3 text-sm leading-7 text-[#1F2933]">Runners fulfill jobs while admins supervise users, requests, transactions, and system order.</p></article>
    </div>
</section>
<?php require_once __DIR__ . '/../layouts/footer.php'; ?>
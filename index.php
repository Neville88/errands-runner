<?php

declare(strict_types=1);

require_once __DIR__ . '/includes/functions.php';
require_once __DIR__ . '/components/buttons.php';
require_once __DIR__ . '/components/badges.php';

$snapshot = platform_snapshot();
$featuredRunners = featured_runners(3);
$testimonials = homepage_testimonials(6);
$currentUser = current_user();
$canRequestErrand = $currentUser !== null && in_array($currentUser['role'], ['buyer', 'seller'], true);
$primaryAvailableRunnerId = null;
foreach ($featuredRunners as $candidateRunner) {
    if ((int) ($candidateRunner['active_jobs'] ?? 0) === 0) {
        $primaryAvailableRunnerId = (int) $candidateRunner['id'];
        break;
    }
}
$allFeaturedBusy = $primaryAvailableRunnerId === null;
$pageTitle = 'Errands, Delivery, and Runner Coordination';
$pageDescription = 'A structured errands runner platform for sellers, buyers, runners, and admins.';
require_once __DIR__ . '/layouts/header.php';
?>
<section class="glass-panel overflow-hidden rounded-[2rem] px-8 py-16 shadow-sm">
    <div class="grid gap-10 lg:grid-cols-[1.08fr_0.92fr] lg:items-center">
        <div>
            <p class="text-sm font-semibold uppercase tracking-[0.3em] text-[#22C55E]">Errands · Deliveries · Pickups</p>
            <h1 class="mt-5 max-w-3xl text-4xl font-bold tracking-tight text-[#1F2933] sm:text-5xl">Request errands and match with trusted local runners.</h1>
            <p class="mt-6 max-w-2xl text-lg leading-8 text-[#1F2933]">Post what you need moved or sourced, choose a rated runner, track progress, and confirm delivery — all in one clean workflow.</p>
            <div class="mt-8 flex flex-wrap gap-4">
                <?php if ($canRequestErrand): ?>
                    <a href="<?= h(page_url('request-create.php')) ?>" class="<?= h(button_classes('primary')) ?>">Request an errand</a>
                <?php else: ?>
                    <a href="<?= h(page_url('login.php')) ?>" class="<?= h(button_classes('primary')) ?>">Log in to request</a>
                <?php endif; ?>
                <a href="#runners" class="<?= h(button_classes('secondary')) ?>">Browse runners</a>
            </div>
            <div class="mt-8 grid gap-4 sm:grid-cols-3">
                <div class="rounded-3xl bg-[#F7F7F2] p-4 shadow-sm">
                    <p class="text-xs uppercase tracking-[0.2em] text-[#22C55E]">Active Users</p>
                    <p class="mt-2 text-2xl font-bold text-[#1F2933]"><?= h((string) $snapshot['users']) ?>+</p>
                </div>
                <div class="rounded-3xl bg-[#F7F7F2] p-4 shadow-sm">
                    <p class="text-xs uppercase tracking-[0.2em] text-[#22C55E]">Completed Deliveries</p>
                    <p class="mt-2 text-2xl font-bold text-[#1F2933]"><?= h((string) $snapshot['completed_deliveries']) ?>+</p>
                </div>
                <div class="rounded-3xl bg-[#F7F7F2] p-4 shadow-sm">
                    <p class="text-xs uppercase tracking-[0.2em] text-[#22C55E]">Ready Runners</p>
                    <p class="mt-2 text-2xl font-bold text-[#1F2933]"><?= h((string) $snapshot['active_runners']) ?></p>
                </div>
            </div>
        </div>
        <div class="glass-panel grid gap-4 rounded-[2rem] p-6">
            <div class="rounded-3xl bg-[#F7F7F2] p-5 text-[#1F2933] shadow-sm">
                <p class="text-sm font-semibold text-[#22C55E]">Fast-moving request types</p>
                <div class="mt-4 flex flex-wrap gap-2">
                    <?= render_badge('Market errands', 'buyer') ?>
                    <?= render_badge('Same-day delivery', 'approved') ?>
                    <?= render_badge('Document pickups', 'assigned') ?>
                    <?= render_badge('Custom errands', 'runner') ?>
                </div>
                <p class="mt-4 text-sm leading-7 text-[#1F2933]">From Kampala market runs to urgent office deliveries, the platform keeps jobs structured and visible from creation to proof of delivery.</p>
            </div>
            <div class="rounded-3xl bg-[#F7F7F2] p-5 text-[#1F2933] shadow-sm">
                <p class="text-sm font-semibold text-[#22C55E]">Why people stay</p>
                <ul class="mt-4 space-y-3 text-sm leading-7 text-[#1F2933]">
                    <li>Clear quotations and job assignment flow</li>
                    <li>Visible top-rated riders with direct contact links</li>
                    <li>Proof uploads, status tracking, and post-service reviews</li>
                </ul>
            </div>
            <div class="rounded-3xl brand-gradient p-5 text-white shadow-sm">
                <p class="text-sm font-semibold uppercase tracking-[0.18em] text-white/80">Customer confidence</p>
                <h2 class="mt-3 text-2xl font-bold">Rated runners. Real reviews. Better decisions.</h2>
                <p class="mt-3 text-sm leading-7 text-white/90">Customers can now rate runners after confirmed deliveries, helping the best agents rise to the top.</p>
            </div>
        </div>
    </div>
</section>
<section class="mt-12 grid gap-6 lg:grid-cols-[0.85fr_1.15fr]">
    <article class="glass-panel rounded-[2rem] p-8 shadow-sm" id="runners">
        <p class="text-sm font-semibold uppercase tracking-[0.24em] text-[#22C55E]">How It Works</p>
        <div class="mt-6 space-y-5">
            <div class="rounded-3xl bg-[#F7F7F2] p-5">
                <h2 class="text-lg font-semibold text-[#1F2933]">1. Post your request</h2>
                <p class="mt-2 text-sm leading-7 text-[#1F2933]">Create a delivery, item purchase, pickup/dropoff, or custom errand with budget, item details, and destination.</p>
            </div>
            <div class="rounded-3xl bg-[#F7F7F2] p-5">
                <h2 class="text-lg font-semibold text-[#1F2933]">2. Get matched with a runner</h2>
                <p class="mt-2 text-sm leading-7 text-[#1F2933]">Runners can accept direct delivery jobs or send quotations for sourcing errands and more complex requests.</p>
            </div>
            <div class="rounded-3xl bg-[#F7F7F2] p-5">
                <h2 class="text-lg font-semibold text-[#1F2933]">3. Track, confirm, and rate</h2>
                <p class="mt-2 text-sm leading-7 text-[#1F2933]">Follow status changes, review proof of completion, confirm successful service, and leave a star rating.</p>
            </div>
        </div>
    </article>
    <article class="glass-panel rounded-[2rem] p-8 shadow-sm">
        <div class="flex flex-col gap-3 md:flex-row md:items-end md:justify-between">
            <div>
                <p class="text-sm font-semibold uppercase tracking-[0.24em] text-[#22C55E]">Top Ranked Runners</p>
                <h2 class="mt-2 text-3xl font-bold text-[#1F2933]">Featured delivery agents customers already trust</h2>
            </div>
            <a href="<?= h(page_url('register.php')) ?>" class="<?= h(button_classes('secondary')) ?>">Join As Runner</a>
        </div>
        <div class="mt-8 grid gap-5 xl:grid-cols-3">
            <?php foreach ($featuredRunners as $runner): ?>
                <?php
                $activeJobs = (int) ($runner['active_jobs'] ?? 0);
                $isAvailable = $activeJobs === 0;
                ?>
                <article id="runner-<?= h((string) $runner['id']) ?>" class="overflow-hidden rounded-[2rem] border border-[#E5E7EB] bg-[#F7F7F2] shadow-sm">
                    <?php if (!empty($runner['profile_image'])): ?>
                        <img src="<?= h(upload_url($runner['profile_image']) ?? '') ?>" alt="<?= h($runner['full_name']) ?>" class="h-64 w-full object-cover object-top">
                    <?php else: ?>
                        <div class="flex h-64 items-center justify-center bg-[#14532D] text-4xl font-bold text-[#F7F7F2]"><?= h(strtoupper(substr($runner['full_name'], 0, 1))) ?></div>
                    <?php endif; ?>
                    <div class="p-5">
                        <div class="flex items-start justify-between gap-4">
                            <div>
                                <h3 class="text-xl font-semibold text-[#1F2933]"><?= h($runner['full_name']) ?></h3>
                                <p class="mt-1 text-sm text-[#1F2933]"><?= h(trim(($runner['city'] ?? '') . ', ' . ($runner['state_region'] ?? ''), ', ')) ?></p>
                            </div>
                            <?= render_badge($isAvailable ? 'Available now' : 'Busy on errands', $isAvailable ? 'approved' : 'pending') ?>
                        </div>
                        <div class="mt-4 flex items-center gap-3">
                            <?= render_stars((float) $runner['average_rating']) ?>
                            <p class="text-sm font-semibold text-[#1F2933]"><?= h(number_format((float) $runner['average_rating'], 1)) ?>/5</p>
                            <p class="text-sm text-[#1F2933]"><?= h((string) $runner['review_count']) ?> reviews</p>
                        </div>
                        <p class="mt-4 text-sm leading-7 text-[#1F2933]"><?= h($runner['bio'] ?? 'Reliable local runner.') ?></p>
                        <div class="mt-4 grid grid-cols-2 gap-3 text-sm">
                            <div class="rounded-2xl bg-white p-3">
                                <p class="text-xs uppercase tracking-[0.15em] text-[#22C55E]">Completed Jobs</p>
                                <p class="mt-1 font-semibold text-[#1F2933]"><?= h((string) $runner['completed_jobs']) ?></p>
                            </div>
                            <div class="rounded-2xl bg-white p-3">
                                <p class="text-xs uppercase tracking-[0.15em] text-[#22C55E]">Reach Runner</p>
                                <p class="mt-1 font-semibold text-[#1F2933]"><?= h($runner['phone']) ?></p>
                            </div>
                        </div>
                        <div class="mt-5 flex gap-3">
                            <?php if ($canRequestErrand): ?>
                                <?php if ($isAvailable): ?>
                                    <a href="<?= h(page_url('request-create.php?runner_id=' . $runner['id'])) ?>" class="<?= h(button_classes('primary')) ?> flex-1">
                                        Start errand with <?= h($runner['full_name']) ?>
                                    </a>
                                <?php else: ?>
                                    <button type="button" class="<?= h(button_classes('secondary')) ?> flex-1 cursor-not-allowed opacity-60" disabled>
                                        Runner currently busy
                                    </button>
                                    <?php if (!$allFeaturedBusy && $primaryAvailableRunnerId !== null && $primaryAvailableRunnerId !== (int) $runner['id']): ?>
                                        <a href="#runner-<?= h((string) $primaryAvailableRunnerId) ?>" class="<?= h(button_classes('primary')) ?> flex-1">
                                            See available runner
                                        </a>
                                    <?php elseif ($allFeaturedBusy): ?>
                                        <a href="<?= h(page_url('request-create.php')) ?>" class="<?= h(button_classes('primary')) ?> flex-1">
                                            Scan all available runners
                                        </a>
                                    <?php endif; ?>
                                <?php endif; ?>
                            <?php else: ?>
                                <a href="<?= h(page_url('login.php')) ?>" class="<?= h(button_classes('primary')) ?> flex-1">
                                    Log in to request
                                </a>
                            <?php endif; ?>
                        </div>
                    </div>
                </article>
            <?php endforeach; ?>
        </div>
    </article>
</section>
<section class="glass-panel mt-12 rounded-[2rem] p-8 shadow-sm">
    <div class="flex flex-col gap-3 md:flex-row md:items-end md:justify-between">
        <div>
            <p class="text-sm font-semibold uppercase tracking-[0.24em] text-[#22C55E]">Customer Reviews</p>
            <h2 class="mt-2 text-3xl font-bold text-[#1F2933]">What customers say after real completed errands</h2>
        </div>
        <a href="<?= h(page_url('register.php')) ?>" class="<?= h(button_classes('secondary')) ?>">Become a customer</a>
    </div>
    <div class="mt-8 grid gap-5 md:grid-cols-2 xl:grid-cols-3">
        <?php foreach ($testimonials as $testimonial): ?>
            <article class="rounded-[2rem] border border-[#E5E7EB] bg-[#F7F7F2] p-6 shadow-sm">
                <div class="flex items-center justify-between gap-3">
                    <?= render_stars((int) $testimonial['rating']) ?>
                    <span class="text-sm font-semibold text-[#1F2933]"><?= h((string) $testimonial['rating']) ?>/5</span>
                </div>
                <p class="mt-4 text-sm leading-7 text-[#1F2933]">"<?= h($testimonial['review_text']) ?>"</p>
                <div class="mt-5 border-t border-[#E5E7EB] pt-4">
                    <p class="font-semibold text-[#1F2933]"><?= h($testimonial['reviewer_name']) ?></p>
                    <p class="mt-1 text-sm text-[#1F2933]">Reviewed <?= h($testimonial['runner_name']) ?> for <?= h($testimonial['request_title']) ?></p>
                </div>
            </article>
        <?php endforeach; ?>
    </div>
</section>
<?php require_once __DIR__ . '/layouts/footer.php'; ?>
<?php

declare(strict_types=1);

require_once __DIR__ . '/../includes/auth.php';
require_once __DIR__ . '/../layouts/dashboard_header.php';
require_once __DIR__ . '/../layouts/dashboard_sidebar.php';
require_once __DIR__ . '/../components/badges.php';
require_once __DIR__ . '/../components/tables.php';

require_auth();

$user = current_user();
$quotes = list_quotes_for_user($user);
$pageTitle = 'Quotations';
$pageDescription = 'Review submitted quotations and approval status.';
require_once __DIR__ . '/../layouts/header.php';
?>
<div class="grid gap-6 lg:grid-cols-[280px_1fr]">
    <?php render_dashboard_sidebar('quotations.php'); ?>
    <section>
        <?php render_dashboard_header('Quotations', 'Track request quotes, approvals, and runner proposals.'); ?>
        <div class="glass-panel overflow-hidden rounded-[2rem] shadow-sm">
            <?php if ($quotes === []): ?>
                <div class="p-8"><?= render_empty_state('No quotations found', 'Quotes will appear here once runners submit proposals.') ?></div>
            <?php else: ?>
                <div class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-[#E5E7EB] text-sm">
                        <thead class="bg-[#F7F7F2] text-left text-[#1F2933]"><tr><th class="px-6 py-4 font-semibold">Request</th><th class="px-6 py-4 font-semibold">Runner</th><th class="px-6 py-4 font-semibold">Amount</th><th class="px-6 py-4 font-semibold">Status</th><th class="px-6 py-4 font-semibold"></th></tr></thead>
                        <tbody class="divide-y divide-[#E5E7EB]">
                            <?php foreach ($quotes as $quote): ?>
                                <tr>
                                    <td class="px-6 py-4 font-semibold text-[#1F2933]"><?= h($quote['request_title']) ?></td>
                                    <td class="px-6 py-4 text-[#1F2933]"><?= h($quote['runner_name']) ?></td>
                                    <td class="px-6 py-4 text-[#1F2933]"><?= h(money($quote['amount'])) ?></td>
                                    <td class="px-6 py-4"><?= render_badge(status_label($quote['status']), $quote['status']) ?></td>
                                    <td class="px-6 py-4 text-right"><a href="<?= h(page_url('request-details.php?id=' . $quote['request_id'])) ?>" class="font-semibold text-[#14532D]">Open Request</a></td>
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
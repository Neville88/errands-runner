<?php

declare(strict_types=1);

require_once __DIR__ . '/../includes/auth.php';
require_once __DIR__ . '/../layouts/dashboard_header.php';
require_once __DIR__ . '/../layouts/dashboard_sidebar.php';
require_once __DIR__ . '/../components/badges.php';
require_once __DIR__ . '/../components/tables.php';

require_auth();

$user = current_user();
$transactions = list_transactions_for_user($user);
$pageTitle = 'Transactions';
$pageDescription = 'Review payment references, methods, and settlement status.';
require_once __DIR__ . '/../layouts/header.php';
?>
<div class="grid gap-6 lg:grid-cols-[280px_1fr]">
    <?php render_dashboard_sidebar('transactions.php'); ?>
    <section>
        <?php render_dashboard_header('Transactions', 'Financial records linked to approved quotations and delivery assignments.'); ?>
        <div class="glass-panel overflow-hidden rounded-[2rem] shadow-sm">
            <?php if ($transactions === []): ?>
                <div class="p-8"><?= render_empty_state('No transactions yet', 'Transaction records will appear when requests are assigned or approved.') ?></div>
            <?php else: ?>
                <div class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-[#E5E7EB] text-sm">
                        <thead class="bg-[#F7F7F2] text-left text-[#1F2933]"><tr><th class="px-6 py-4 font-semibold">Reference</th><th class="px-6 py-4 font-semibold">Request</th><th class="px-6 py-4 font-semibold">Method</th><th class="px-6 py-4 font-semibold">Payer</th><th class="px-6 py-4 font-semibold">Payee</th><th class="px-6 py-4 font-semibold">Amount</th><th class="px-6 py-4 font-semibold">Status</th></tr></thead>
                        <tbody class="divide-y divide-[#E5E7EB]">
                            <?php foreach ($transactions as $transaction): ?>
                                <tr>
                                    <td class="px-6 py-4 font-semibold text-[#1F2933]"><?= h($transaction['transaction_reference']) ?></td>
                                    <td class="px-6 py-4 text-[#1F2933]"><?= h($transaction['request_title']) ?></td>
                                    <td class="px-6 py-4 text-[#1F2933]"><?= h(payment_method_label($transaction['payment_method'])) ?></td>
                                    <td class="px-6 py-4 text-[#1F2933]"><?= h($transaction['payer_name']) ?></td>
                                    <td class="px-6 py-4 text-[#1F2933]"><?= h($transaction['payee_name'] ?? 'Pending') ?></td>
                                    <td class="px-6 py-4 text-[#1F2933]"><?= h(money($transaction['amount'])) ?></td>
                                    <td class="px-6 py-4"><?= render_badge(status_label($transaction['payment_status']), $transaction['payment_status']) ?></td>
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
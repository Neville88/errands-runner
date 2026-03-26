<?php

declare(strict_types=1);

function render_alert(string $message, string $type = 'info'): string
{
    $classes = [
        'success' => 'border-[#22C55E]/35 bg-[#F7F7F2]/95 text-[#14532D]',
        'error' => 'border-[#E5E7EB] bg-[#F7F7F2]/95 text-[#1F2933]',
        'warning' => 'border-[#E5E7EB] bg-[#F7F7F2]/95 text-[#1F2933]',
        'info' => 'border-[#E5E7EB] bg-[#F7F7F2]/95 text-[#1F2933]',
    ];

    return sprintf(
        '<div data-alert class="mb-4 rounded-3xl border px-4 py-3 text-sm shadow-sm %s"><div class="flex items-start justify-between gap-3"><p class="leading-6">%s</p><button type="button" data-dismiss-alert class="text-xs font-semibold uppercase tracking-wide text-[#14532D]">Dismiss</button></div></div>',
        $classes[$type] ?? $classes['info'],
        htmlspecialchars($message, ENT_QUOTES, 'UTF-8')
    );
}
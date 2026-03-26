<?php

declare(strict_types=1);

function button_classes(string $variant = 'primary'): string
{
    $classes = [
        'primary' => 'inline-flex items-center justify-center rounded-2xl bg-[#14532D] px-4 py-2.5 text-sm font-semibold text-[#F7F7F2] shadow-sm transition hover:bg-[#166534]',
        'secondary' => 'inline-flex items-center justify-center rounded-2xl border border-[#E5E7EB] bg-[#F7F7F2]/90 px-4 py-2.5 text-sm font-semibold text-[#14532D] transition hover:border-[#22C55E] hover:bg-[#F7F7F2]',
        'success' => 'inline-flex items-center justify-center rounded-2xl bg-[#166534] px-4 py-2.5 text-sm font-semibold text-[#F7F7F2] shadow-sm transition hover:bg-[#14532D]',
        'danger' => 'inline-flex items-center justify-center rounded-2xl border border-[#E5E7EB] bg-[#1F2933] px-4 py-2.5 text-sm font-semibold text-[#F7F7F2] transition hover:bg-[#14532D]',
    ];

    return $classes[$variant] ?? $classes['primary'];
}
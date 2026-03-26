<?php

declare(strict_types=1);

function render_stat_card(string $label, string $value, string $hint, string $tone = 'action'): string
{
    $tones = [
        'action' => 'from-[#14532D] to-[#166534]',
        'warm' => 'from-[#166534] to-[#14532D]',
        'muted' => 'from-[#22C55E] to-[#166534]',
        'surface' => 'from-[#1F2933] to-[#14532D]',
    ];

    $gradient = $tones[$tone] ?? $tones['action'];

    return sprintf(
        '<article class="rounded-[2rem] bg-gradient-to-br %s p-6 text-white shadow-lg"><p class="text-sm uppercase tracking-[0.25em] text-white/80">%s</p><h3 class="mt-4 text-3xl font-bold">%s</h3><p class="mt-2 text-sm text-white/90">%s</p></article>',
        $gradient,
        htmlspecialchars($label, ENT_QUOTES, 'UTF-8'),
        htmlspecialchars($value, ENT_QUOTES, 'UTF-8'),
        htmlspecialchars($hint, ENT_QUOTES, 'UTF-8')
    );
}
<?php

declare(strict_types=1);

function badge_classes(string $value): string
{
    $map = [
        'open' => 'bg-[#F7F7F2] text-[#14532D] ring-[#22C55E]/30',
        'quoted' => 'bg-[#F7F7F2] text-[#166534] ring-[#22C55E]/30',
        'assigned' => 'bg-[#F7F7F2] text-[#14532D] ring-[#E5E7EB]',
        'in_progress' => 'bg-[#F7F7F2] text-[#166534] ring-[#22C55E]/30',
        'completed' => 'bg-[#F7F7F2] text-[#14532D] ring-[#22C55E]/30',
        'confirmed' => 'bg-[#F7F7F2] text-[#14532D] ring-[#22C55E]/30',
        'cancelled' => 'bg-[#F7F7F2] text-[#1F2933] ring-[#E5E7EB]',
        'pending' => 'bg-[#F7F7F2] text-[#1F2933] ring-[#E5E7EB]',
        'approved' => 'bg-[#F7F7F2] text-[#14532D] ring-[#22C55E]/30',
        'rejected' => 'bg-[#F7F7F2] text-[#1F2933] ring-[#E5E7EB]',
        'seller' => 'bg-[#F7F7F2] text-[#166534] ring-[#22C55E]/30',
        'buyer' => 'bg-[#F7F7F2] text-[#14532D] ring-[#22C55E]/30',
        'runner' => 'bg-[#F7F7F2] text-[#166534] ring-[#22C55E]/30',
        'admin' => 'bg-[#F7F7F2] text-[#1F2933] ring-[#E5E7EB]',
        'paid' => 'bg-[#F7F7F2] text-[#14532D] ring-[#22C55E]/30',
        'processing' => 'bg-[#F7F7F2] text-[#166534] ring-[#22C55E]/30',
    ];

    return $map[$value] ?? 'bg-[#F7F7F2] text-[#14532D] ring-[#E5E7EB]';
}

function render_badge(string $label, string $value): string
{
    return sprintf('<span class="inline-flex items-center rounded-full px-3 py-1 text-xs font-semibold ring-1 ring-inset %s">%s</span>', badge_classes($value), htmlspecialchars($label, ENT_QUOTES, 'UTF-8'));
}

function render_stars(int|float $rating, int $max = 5): string
{
    $filled = (int) round((float) $rating);
    $html = '<div class="flex items-center gap-1 text-[#22C55E]">';

    for ($i = 1; $i <= $max; $i++) {
        $html .= sprintf(
            '<span class="%s">%s</span>',
            $i <= $filled ? 'opacity-100' : 'opacity-25',
            '&#9733;'
        );
    }

    $html .= '</div>';
    return $html;
}
<?php

declare(strict_types=1);

function render_empty_state(string $title, string $message): string
{
    return sprintf(
        '<div class="rounded-[2rem] border border-dashed border-[#22C55E]/35 bg-[#F7F7F2]/92 px-6 py-12 text-center shadow-sm"><h3 class="text-lg font-semibold text-[#1F2933]">%s</h3><p class="mt-2 text-sm text-[#1F2933]">%s</p></div>',
        htmlspecialchars($title, ENT_QUOTES, 'UTF-8'),
        htmlspecialchars($message, ENT_QUOTES, 'UTF-8')
    );
}
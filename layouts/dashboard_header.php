<?php

declare(strict_types=1);

function render_dashboard_header(string $title, string $description, string $actions = ''): void
{
    ?>
    <div class="glass-panel mb-6 flex flex-col gap-4 rounded-[2rem] p-6 shadow-sm lg:flex-row lg:items-center lg:justify-between">
        <div>
            <p class="text-sm font-semibold uppercase tracking-[0.2em] text-[#22C55E]">Workspace</p>
            <h1 class="mt-2 text-3xl font-bold text-[#1F2933]"><?= h($title) ?></h1>
            <p class="mt-2 max-w-2xl text-sm text-[#1F2933]"><?= h($description) ?></p>
        </div>
        <?php if ($actions !== ''): ?>
            <div class="flex flex-wrap items-center gap-3"><?= $actions ?></div>
        <?php endif; ?>
    </div>
    <?php
}
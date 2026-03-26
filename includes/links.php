<?php

declare(strict_types=1);

require_once __DIR__ . '/functions.php';

function render_links(string $title, string $description = ''): void
{
    $description = $description !== '' ? $description : 'Structured errands, quotations, assignments, notifications, and transactions in one clean platform.';
    echo '<meta charset="UTF-8">';
    echo '<meta name="viewport" content="width=device-width, initial-scale=1.0">';
    echo '<title>' . h($title) . ' | ' . h(APP_NAME) . '</title>';
    echo '<meta name="description" content="' . h($description) . '">';
    echo '<script src="https://cdn.tailwindcss.com"></script>';
    echo '<link rel="stylesheet" href="' . h(asset_url('css/styles.css')) . '">';
    echo '<script defer src="' . h(asset_url('js/script.js')) . '"></script>';
}
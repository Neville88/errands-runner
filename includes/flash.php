<?php

declare(strict_types=1);

require_once __DIR__ . '/../components/alerts.php';

function set_flash(string $type, string $message): void
{
    $_SESSION['flash_messages'][] = [
        'type' => $type,
        'message' => $message,
    ];
}

function consume_flashes(): array
{
    $messages = $_SESSION['flash_messages'] ?? [];
    unset($_SESSION['flash_messages']);

    return $messages;
}

function render_flash_messages(): void
{
    foreach (consume_flashes() as $flash) {
        echo render_alert((string) ($flash['message'] ?? ''), (string) ($flash['type'] ?? 'info'));
    }
}

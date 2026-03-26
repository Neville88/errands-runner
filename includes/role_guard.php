<?php

declare(strict_types=1);

require_once __DIR__ . '/auth.php';

function require_role(string|array $roles): void
{
    require_auth();

    if (!has_role($roles)) {
        set_flash('error', 'You do not have permission to access that page.');
        redirect(role_dashboard_path((string) current_user()['role']));
    }
}

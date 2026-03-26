<?php

declare(strict_types=1);

require_once __DIR__ . '/../includes/functions.php';
require_once __DIR__ . '/../includes/flash.php';
require_once __DIR__ . '/../includes/nav.php';
require_once __DIR__ . '/../includes/links.php';

$pageTitle = $pageTitle ?? APP_NAME;
$pageDescription = $pageDescription ?? 'A clean errands and delivery coordination platform for buyers, sellers, runners, and admins.';
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <?php render_links($pageTitle, $pageDescription); ?>
</head>
<body class="bg-[#1F2933] text-[#1F2933]">
<div class="min-h-screen flex flex-col">
    <?php render_nav(); ?>
    <main class="flex-1">
        <div class="mx-auto max-w-7xl px-4 py-6 sm:px-6 lg:px-8">
            <?php render_flash_messages(); ?>
<?php

declare(strict_types=1);

require_once __DIR__ . '/config.php';

function validate_registration_input(array $input): array
{
    $data = [
        'full_name' => trim((string) ($input['full_name'] ?? '')),
        'email' => strtolower(trim((string) ($input['email'] ?? ''))),
        'phone' => trim((string) ($input['phone'] ?? '')),
        'role' => trim((string) ($input['role'] ?? 'buyer')),
        'password' => (string) ($input['password'] ?? ''),
        'password_confirmation' => (string) ($input['password_confirmation'] ?? ''),
    ];
    $errors = [];
    if (mb_strlen($data['full_name']) < 3) { $errors[] = 'Full name must contain at least 3 characters.'; }
    if (!filter_var($data['email'], FILTER_VALIDATE_EMAIL)) { $errors[] = 'Enter a valid email address.'; }
    if ($data['phone'] === '') { $errors[] = 'Phone number is required.'; }
    if (!array_key_exists($data['role'], PUBLIC_REGISTRATION_ROLES)) { $errors[] = 'Select a valid account type.'; }
    if (strlen($data['password']) < 8) { $errors[] = 'Password must contain at least 8 characters.'; }
    if ($data['password'] !== $data['password_confirmation']) { $errors[] = 'Password confirmation does not match.'; }
    return ['data' => $data, 'errors' => $errors];
}

function validate_login_input(array $input): array
{
    $data = [
        'email' => strtolower(trim((string) ($input['email'] ?? ''))),
        'password' => (string) ($input['password'] ?? ''),
    ];
    $errors = [];
    if (!filter_var($data['email'], FILTER_VALIDATE_EMAIL)) { $errors[] = 'Enter a valid email address.'; }
    if ($data['password'] === '') { $errors[] = 'Password is required.'; }
    return ['data' => $data, 'errors' => $errors];
}

function validate_profile_input(array $input): array
{
    $data = [
        'full_name' => trim((string) ($input['full_name'] ?? '')),
        'phone' => trim((string) ($input['phone'] ?? '')),
        'address_line' => trim((string) ($input['address_line'] ?? '')),
        'city' => trim((string) ($input['city'] ?? '')),
        'state_region' => trim((string) ($input['state_region'] ?? '')),
        'postal_code' => trim((string) ($input['postal_code'] ?? '')),
        'bio' => trim((string) ($input['bio'] ?? '')),
    ];
    $errors = [];
    if (mb_strlen($data['full_name']) < 3) { $errors[] = 'Full name must contain at least 3 characters.'; }
    if ($data['phone'] === '') { $errors[] = 'Phone number is required.'; }
    return ['data' => $data, 'errors' => $errors];
}

function validate_contact_input(array $input): array
{
    $data = [
        'name' => trim((string) ($input['name'] ?? '')),
        'email' => strtolower(trim((string) ($input['email'] ?? ''))),
        'phone' => trim((string) ($input['phone'] ?? '')),
        'subject' => trim((string) ($input['subject'] ?? '')),
        'message' => trim((string) ($input['message'] ?? '')),
    ];
    $errors = [];
    if (mb_strlen($data['name']) < 3) { $errors[] = 'Enter your full name.'; }
    if (!filter_var($data['email'], FILTER_VALIDATE_EMAIL)) { $errors[] = 'Enter a valid email address.'; }
    if (mb_strlen($data['subject']) < 3) { $errors[] = 'Subject must contain at least 3 characters.'; }
    if (mb_strlen($data['message']) < 10) { $errors[] = 'Message must contain at least 10 characters.'; }
    return ['data' => $data, 'errors' => $errors];
}

function validate_request_input(array $input, array $user): array
{
    $requestType = trim((string) ($input['request_type'] ?? ''));
    $description = trim((string) ($input['description'] ?? ''));
    $data = [
        'request_type' => $requestType,
        'title' => trim((string) ($input['title'] ?? '')),
        'description' => $description,
        'item_name' => trim((string) ($input['item_name'] ?? '')),
        'item_description' => trim((string) ($input['item_description'] ?? '')) ?: $description,
        'item_quantity' => max(1, (int) ($input['item_quantity'] ?? 1)),
        'estimated_unit_price' => (float) ($input['estimated_unit_price'] ?? 0),
        'pickup_location' => trim((string) ($input['pickup_location'] ?? '')),
        'destination' => trim((string) ($input['destination'] ?? '')),
        'recipient_name' => trim((string) ($input['recipient_name'] ?? '')),
        'recipient_phone' => trim((string) ($input['recipient_phone'] ?? '')),
        'delivery_window' => trim((string) ($input['delivery_window'] ?? '')),
        'special_instructions' => trim((string) ($input['special_instructions'] ?? '')),
        'budget_amount' => (float) ($input['budget_amount'] ?? 0),
        'payment_method' => trim((string) ($input['payment_method'] ?? 'cash_on_delivery')),
    ];
    $errors = [];
    if (!array_key_exists($requestType, role_request_type_options($user['role']))) { $errors[] = 'Select a valid request type for your account.'; }
    if (mb_strlen($data['title']) < 5) { $errors[] = 'Title must contain at least 5 characters.'; }
    if (mb_strlen($data['description']) < 10) { $errors[] = 'Description must contain at least 10 characters.'; }
    if ($data['item_name'] === '') { $errors[] = 'Item or package name is required.'; }
    if ($data['pickup_location'] === '') { $errors[] = 'Pickup location is required.'; }
    if ($data['destination'] === '') { $errors[] = 'Destination is required.'; }
    if ($data['recipient_name'] === '') { $errors[] = 'Recipient name is required.'; }
    if ($data['recipient_phone'] === '') { $errors[] = 'Recipient phone is required.'; }
    if (!array_key_exists($data['payment_method'], PAYMENT_METHODS)) { $errors[] = 'Select a valid payment method.'; }
    if ($data['budget_amount'] < 0 || $data['estimated_unit_price'] < 0) { $errors[] = 'Amounts cannot be negative.'; }
    return ['data' => $data, 'errors' => $errors];
}

function validate_quote_input(array $input): array
{
    $data = [
        'amount' => (float) ($input['amount'] ?? 0),
        'note' => trim((string) ($input['note'] ?? '')),
    ];
    $errors = [];
    if ($data['amount'] <= 0) { $errors[] = 'Quote amount must be greater than zero.'; }
    return ['data' => $data, 'errors' => $errors];
}
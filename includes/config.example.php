<?php

declare(strict_types=1);

require_once __DIR__ . '/session.php';

date_default_timezone_set('Africa/Kampala');

define('APP_NAME', 'Errands Runner');
define('APP_CURRENCY', 'UGX');
define('APP_SUPPORT_EMAIL', 'ssekiziyivudenison19@gmail.com');
define('APP_SUPPORT_PHONE', '+256 706 888958');
define('APP_MAIL_FROM_NAME', 'Errands Runner Support');

// Local vs hosted: one config works for both; detect by HTTP_HOST
$host = $_SERVER['HTTP_HOST'] ?? '';
$isLocal = (strpos($host, 'localhost') !== false || strpos($host, '127.0.0.1') !== false);
$isHosted = (strpos($host, 'thecorridortechnologies.com') !== false);

if ($isLocal && !$isHosted) {
    define('APP_URL', 'http://localhost/ErrandRunner');
    define('DB_HOST', 'localhost');
    define('DB_PORT', '3306');
    define('DB_NAME', 'errands_runner');
    define('DB_USER', 'root');
    define('DB_PASS', '');
} else {
    define('APP_URL', 'https://thecorridortechnologies.com/errands');
    define('DB_HOST', 'localhost');
    define('DB_PORT', '3306');
    define('DB_NAME', 'thecorri_errands');
    define('DB_USER', 'YOUR_CPANEL_DB_USER');
    define('DB_PASS', 'YOUR_CPANEL_DB_PASSWORD');
}

define('UPLOAD_MAX_SIZE', 5 * 1024 * 1024);
define('PROFILE_UPLOAD_DIR', __DIR__ . '/../assets/uploads/profiles');
define('REQUEST_UPLOAD_DIR', __DIR__ . '/../assets/uploads/requests');
define('RECEIPT_UPLOAD_DIR', __DIR__ . '/../assets/uploads/receipts');
define('ITEM_UPLOAD_DIR', __DIR__ . '/../assets/uploads/items');
define('SAMPLE_UPLOAD_DIR', __DIR__ . '/../assets/uploads/samples');

const BRAND_COLORS = [
    'surface' => '#F7F7F2',
    'warm' => '#E5E7EB',
    'muted' => '#22C55E',
    'action' => '#14532D',
];

const USER_ROLES = [
    'seller' => 'Seller',
    'buyer' => 'Buyer / Customer',
    'runner' => 'Runner / Delivery Agent',
    'admin' => 'Administrator',
];

const PUBLIC_REGISTRATION_ROLES = [
    'seller' => 'Seller',
    'buyer' => 'Buyer / Customer',
    'runner' => 'Runner / Delivery Agent',
];

const REQUEST_TYPES = [
    'delivery_request' => 'Delivery Request',
    'item_purchase_request' => 'Item Purchase Request',
    'pickup_dropoff_errand' => 'Pickup / Dropoff Errand',
    'custom_errand' => 'Custom Errand',
];

const REQUEST_STATUSES = [
    'open' => 'Open',
    'quoted' => 'Quoted',
    'assigned' => 'Assigned',
    'in_progress' => 'In Progress',
    'completed' => 'Completed',
    'confirmed' => 'Confirmed',
    'cancelled' => 'Cancelled',
];

const REQUEST_VISIBILITY = [
    'public' => 'Visible To Runners',
    'hidden' => 'Hidden From Marketplace',
];

const QUOTATION_STATUSES = [
    'pending' => 'Pending Review',
    'approved' => 'Approved',
    'rejected' => 'Rejected',
];

const ASSIGNMENT_STATUSES = [
    'assigned' => 'Assigned',
    'in_progress' => 'In Progress',
    'completed' => 'Completed',
    'confirmed' => 'Confirmed',
    'cancelled' => 'Cancelled',
];

const TRANSACTION_STATUSES = [
    'pending' => 'Pending',
    'processing' => 'Processing',
    'paid' => 'Paid',
    'cancelled' => 'Cancelled',
];

const PAYMENT_METHODS = [
    'cash_on_delivery' => 'Cash on Delivery',
    'bank_transfer' => 'Bank Transfer',
    'wallet' => 'Wallet / Internal Settlement',
    'manual_record' => 'Manual Record',
];

function role_request_type_options(string $role): array
{
    return match ($role) {
        'seller' => [
            'delivery_request' => REQUEST_TYPES['delivery_request'],
            'pickup_dropoff_errand' => REQUEST_TYPES['pickup_dropoff_errand'],
        ],
        'buyer' => [
            'item_purchase_request' => REQUEST_TYPES['item_purchase_request'],
            'pickup_dropoff_errand' => REQUEST_TYPES['pickup_dropoff_errand'],
            'custom_errand' => REQUEST_TYPES['custom_errand'],
            'delivery_request' => REQUEST_TYPES['delivery_request'],
        ],
        default => REQUEST_TYPES,
    };
}


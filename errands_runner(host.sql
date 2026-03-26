-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 17, 2026 at 10:21 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

-- --------------------------------------------------------

--
-- Table structure for table `assignments`
--

CREATE TABLE `assignments` (
  `id` int(10) UNSIGNED NOT NULL,
  `request_id` int(10) UNSIGNED NOT NULL,
  `runner_id` int(10) UNSIGNED NOT NULL,
  `quotation_id` int(10) UNSIGNED DEFAULT NULL,
  `status` enum('assigned','in_progress','completed','confirmed','cancelled') NOT NULL DEFAULT 'assigned',
  `accepted_at` timestamp NULL DEFAULT NULL,
  `started_at` timestamp NULL DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `confirmed_at` timestamp NULL DEFAULT NULL,
  `proof_image_path` varchar(255) DEFAULT NULL,
  `proof_note` text DEFAULT NULL,
  `current_lat` decimal(10,7) DEFAULT NULL,
  `current_lng` decimal(10,7) DEFAULT NULL,
  `last_location_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `assignments`
--

INSERT INTO `assignments` (`id`, `request_id`, `runner_id`, `quotation_id`, `status`, `accepted_at`, `started_at`, `completed_at`, `confirmed_at`, `proof_image_path`, `proof_note`, `current_lat`, `current_lng`, `last_location_at`, `created_at`, `updated_at`) VALUES
(1, 1, 4, NULL, 'assigned', '2026-03-17 16:46:29', NULL, '2026-03-17 17:03:45', NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-17 16:46:29', '2026-03-17 18:16:25'),
(2, 3, 7, NULL, 'confirmed', '2026-03-17 17:47:28', '2026-03-17 17:47:28', '2026-03-17 17:47:28', '2026-03-17 17:47:28', NULL, 'Package handed over to Grace Namuli in person and delivery confirmed by phone.', NULL, NULL, NULL, '2026-03-17 17:47:28', '2026-03-17 18:16:25'),
(3, 4, 8, NULL, 'confirmed', '2026-03-17 17:47:28', '2026-03-17 17:47:28', '2026-03-17 17:47:28', '2026-03-17 17:47:28', NULL, 'Customer received parcel in good condition and confirmed by call.', NULL, NULL, NULL, '2026-03-17 17:47:28', '2026-03-17 18:16:25'),
(4, 5, 9, NULL, 'confirmed', '2026-03-17 17:47:28', '2026-03-17 17:47:28', '2026-03-17 17:47:28', '2026-03-17 17:47:28', NULL, 'Envelope delivered sealed to the branch administrator.', NULL, NULL, NULL, '2026-03-17 17:47:28', '2026-03-17 18:16:25'),
(5, 6, 13, 4, 'in_progress', '2026-03-17 18:16:25', '2026-03-17 18:16:25', NULL, NULL, NULL, 'Bakery pickup confirmed and store run underway.', NULL, NULL, NULL, '2026-03-17 18:16:25', '2026-03-17 18:16:25'),
(6, 7, 7, NULL, 'in_progress', '2026-03-17 18:16:25', '2026-03-17 18:16:25', NULL, NULL, NULL, 'Supplies loaded and en route to the venue.', NULL, NULL, NULL, '2026-03-17 18:16:25', '2026-03-17 18:16:25');

-- --------------------------------------------------------

--
-- Table structure for table `contact_messages`
--

CREATE TABLE `contact_messages` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(150) NOT NULL,
  `email` varchar(150) NOT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `subject` varchar(180) NOT NULL,
  `message` text NOT NULL,
  `status` enum('new','reviewed','closed') NOT NULL DEFAULT 'new',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `title` varchar(180) NOT NULL,
  `message` text NOT NULL,
  `link_url` varchar(255) DEFAULT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `user_id`, `title`, `message`, `link_url`, `is_read`, `created_at`) VALUES
(1, 1, 'Platform initialized', 'Starter data has been inserted into the errands runner database.', 'pages/admin-dashboard.php', 1, '2026-03-17 16:46:29'),
(2, 5, 'Welcome to Errands Runner', 'Your account is ready. Create requests or manage assignments from your dashboard.', 'http://localhost/ErrandRunner/pages/dashboard.php', 1, '2026-03-17 16:52:10'),
(3, 6, 'Welcome to Errands Runner', 'Your account is ready. Create requests or manage assignments from your dashboard.', 'http://localhost/ErrandRunner/pages/dashboard.php', 0, '2026-03-17 17:01:30'),
(4, 2, 'Request status updated', 'Deliver beverage cartons to customer is now Completed.', 'http://localhost/ErrandRunner/pages/request-details.php?id=1', 0, '2026-03-17 17:03:45'),
(5, 4, 'Request status updated', 'Deliver beverage cartons to customer is now Completed.', 'http://localhost/ErrandRunner/pages/request-details.php?id=1', 0, '2026-03-17 17:03:45'),
(6, 3, 'New quotations received', 'Three runners submitted quotations for your grocery sourcing errand.', 'pages/request-details.php?id=2', 0, '2026-03-17 18:16:25'),
(7, 13, 'Quotation approved', 'Your quotation for the birthday cake and party supplies errand was approved.', 'pages/request-details.php?id=6', 0, '2026-03-17 18:16:25'),
(8, 3, 'Request status updated', 'Source groceries for the Nansubuga family is now Cancelled.', 'http://localhost/ErrandRunner/pages/request-details.php?id=2', 0, '2026-03-17 19:38:20'),
(9, 8, 'Nearby errand opportunity', 'A customer created an errand that may be close to your working area: \"Source groceries for the Nansubuga family\".', 'http://localhost/ErrandRunner/pages/request-details.php?id=2', 0, '2026-03-17 21:10:16');

-- --------------------------------------------------------

--
-- Table structure for table `profiles`
--

CREATE TABLE `profiles` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `profile_image` varchar(255) DEFAULT NULL,
  `address_line` varchar(255) DEFAULT NULL,
  `city` varchar(120) DEFAULT NULL,
  `state_region` varchar(120) DEFAULT NULL,
  `postal_code` varchar(40) DEFAULT NULL,
  `bio` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `profiles`
--

INSERT INTO `profiles` (`id`, `user_id`, `profile_image`, `address_line`, `city`, `state_region`, `postal_code`, `bio`, `created_at`, `updated_at`) VALUES
(1, 1, NULL, NULL, 'Kampala', 'Central Region', NULL, 'Operations lead overseeing user support, request quality, and delivery standards across the platform.', '2026-03-17 16:46:29', '2026-03-17 18:16:25'),
(2, 2, NULL, NULL, 'Mbarara', 'Western Region', NULL, 'Owner of a wholesale beverages and pantry supplies business serving retail shops and small events.', '2026-03-17 16:46:29', '2026-03-17 18:16:25'),
(3, 3, NULL, NULL, 'Kampala', 'Central Region', NULL, 'Busy working parent who uses the platform for home shopping, cake pickups, and planned family errands.', '2026-03-17 16:46:29', '2026-03-17 18:16:25'),
(4, 4, NULL, NULL, 'Entebbe', 'Central Region', NULL, 'Steady boda rider trusted for same-day parcel handoffs, short-notice town runs, and careful retail deliveries.', '2026-03-17 16:46:29', '2026-03-17 18:16:25'),
(5, 5, 'profiles/upload_69b9872e311b07.57542764.jpg', 'mukono', 'mukono', '', '', '', '2026-03-17 16:52:10', '2026-03-17 16:54:06'),
(6, 6, NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-17 17:01:30', '2026-03-17 17:01:30'),
(7, 7, 'profiles/samuel-kato.png', NULL, 'Kampala', 'Central Region', NULL, 'Fast boda runner trusted for market pickups and same-day town deliveries.', '2026-03-17 17:47:28', '2026-03-17 17:47:28'),
(8, 8, 'profiles/aisha-nanyonga.png', NULL, 'Wakiso', 'Central Region', NULL, 'Friendly dispatch rider known for careful package handling and excellent communication.', '2026-03-17 17:47:28', '2026-03-17 17:47:28'),
(9, 9, 'profiles/brian-ssemanda.png', NULL, 'Mukono', 'Central Region', NULL, 'Reliable errands specialist for office runs, grocery sourcing, and customer drop-offs.', '2026-03-17 17:47:28', '2026-03-17 17:47:28'),
(10, 10, NULL, NULL, 'Kampala', 'Central Region', NULL, 'Runs a boutique and beauty retail shop that depends on careful same-day customer deliveries.', '2026-03-17 18:16:25', '2026-03-17 18:16:25'),
(11, 11, NULL, NULL, 'Kampala', 'Central Region', NULL, 'Finance officer who books pharmacy and device accessory pickups during work hours.', '2026-03-17 18:16:25', '2026-03-17 18:16:25'),
(12, 12, NULL, NULL, 'Kampala', 'Central Region', NULL, 'Office administrator coordinating branch documents, signed files, and internal parcel movement.', '2026-03-17 18:16:25', '2026-03-17 18:16:25'),
(13, 13, NULL, NULL, 'Wakiso', 'Central Region', NULL, 'Known for event sourcing, bakery pickups, and clear communication with customers and vendors.', '2026-03-17 18:16:25', '2026-03-17 18:16:25');

-- --------------------------------------------------------

--
-- Table structure for table `quotations`
--

CREATE TABLE `quotations` (
  `id` int(10) UNSIGNED NOT NULL,
  `request_id` int(10) UNSIGNED NOT NULL,
  `runner_id` int(10) UNSIGNED NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `note` text DEFAULT NULL,
  `status` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `quotations`
--

INSERT INTO `quotations` (`id`, `request_id`, `runner_id`, `amount`, `note`, `status`, `created_at`, `updated_at`) VALUES
(1, 2, 4, 98000.00, 'I can source everything early in the morning and send pricing updates before purchase.', 'pending', '2026-03-17 18:16:25', '2026-03-17 18:16:25'),
(2, 2, 8, 96000.00, 'Available from 8am and can deliver before lunch with item photos if needed.', 'pending', '2026-03-17 18:16:25', '2026-03-17 18:16:25'),
(3, 2, 13, 94500.00, 'I know a reliable stall in Owino and can confirm fresh produce before buying.', 'pending', '2026-03-17 18:16:25', '2026-03-17 18:16:25'),
(4, 6, 13, 116000.00, 'I can handle the bakery pickup, candles, and juice in one coordinated trip this afternoon.', 'approved', '2026-03-17 18:16:25', '2026-03-17 18:16:25'),
(5, 6, 7, 121000.00, 'Available after midday with fast delivery, though bakery queue times may affect timing.', 'rejected', '2026-03-17 18:16:25', '2026-03-17 18:16:25');

-- --------------------------------------------------------

--
-- Table structure for table `requests`
--

CREATE TABLE `requests` (
  `id` int(10) UNSIGNED NOT NULL,
  `requester_id` int(10) UNSIGNED NOT NULL,
  `requester_role_key` varchar(30) NOT NULL,
  `request_type` enum('delivery_request','item_purchase_request','pickup_dropoff_errand','custom_errand') NOT NULL,
  `title` varchar(180) NOT NULL,
  `description` text NOT NULL,
  `pickup_location` varchar(255) NOT NULL,
  `destination` varchar(255) NOT NULL,
  `budget_amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `quoted_amount` decimal(12,2) DEFAULT NULL,
  `payment_method` enum('cash_on_delivery','bank_transfer','wallet','manual_record') NOT NULL DEFAULT 'cash_on_delivery',
  `recipient_name` varchar(150) NOT NULL,
  `recipient_phone` varchar(50) NOT NULL,
  `delivery_window` varchar(120) DEFAULT NULL,
  `special_instructions` text DEFAULT NULL,
  `status` enum('open','quoted','assigned','in_progress','completed','confirmed','cancelled') NOT NULL DEFAULT 'open',
  `visibility_status` enum('public','hidden') NOT NULL DEFAULT 'public',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `requests`
--

INSERT INTO `requests` (`id`, `requester_id`, `requester_role_key`, `request_type`, `title`, `description`, `pickup_location`, `destination`, `budget_amount`, `quoted_amount`, `payment_method`, `recipient_name`, `recipient_phone`, `delivery_window`, `special_instructions`, `status`, `visibility_status`, `created_at`, `updated_at`) VALUES
(1, 2, 'seller', 'delivery_request', 'Deliver beverage cartons to Lydia Mini Mart', 'Deliver two beverage cartons to Lydia Mini Mart before the evening rush and confirm handoff with the cashier on site.', 'Nakasero Market, Kampala', 'Ntinda, Kampala', 45000.00, 45000.00, 'cash_on_delivery', 'Lydia Namazzi', '+256705555555', 'Today 3pm - 6pm', 'Keep cartons upright and call the shop assistant on approach.', 'assigned', 'public', '2026-03-17 16:46:29', '2026-03-17 18:16:25'),
(2, 3, 'buyer', 'item_purchase_request', 'Source groceries for the Nansubuga family', 'Buy rice, cooking oil, tomatoes, onions, and seasoning from a trusted market stall and deliver them home before lunch.', 'Owino Market, Kampala', 'Naalya, Kampala', 92000.00, NULL, 'bank_transfer', 'Sarah Nansubuga', '+256702110223', 'Tomorrow morning', 'Send a quick update if tomato prices are much higher than expected.', 'cancelled', 'public', '2026-03-17 16:46:29', '2026-03-17 19:38:20'),
(3, 3, 'buyer', 'custom_errand', 'Pick up paid pharmacy order for Grace Namuli', 'Collect a fully paid pharmacy package and deliver it safely to the family residence with care instructions followed.', 'Acacia Mall Pharmacy, Kampala', 'Kololo, Kampala', 32000.00, 32000.00, 'bank_transfer', 'Grace Namuli', '+256707111222', 'Yesterday afternoon', 'Medicine should stay upright and dry during transport.', 'confirmed', 'public', '2026-03-17 17:47:28', '2026-03-17 18:16:25'),
(4, 2, 'seller', 'delivery_request', 'Same-day boutique parcel drop to Najjera', 'A customer parcel with dresses and skincare items needs a careful same-day delivery and a call before arrival.', 'Arena Mall, Kampala', 'Najjera, Wakiso', 28000.00, 28000.00, 'cash_on_delivery', 'Fiona Katusiime', '+256707333444', 'Yesterday 1pm - 4pm', 'Customer requested a call 10 minutes before arrival.', 'confirmed', 'public', '2026-03-17 17:47:28', '2026-03-17 18:16:25'),
(5, 3, 'buyer', 'pickup_dropoff_errand', 'Office document pickup for Bugolobi branch', 'Collect signed contract files from town and deliver them to the Bugolobi branch office without bending or opening the envelope.', 'NSSF Building, Kampala Road', 'Bugolobi, Kampala', 40000.00, 40000.00, 'manual_record', 'Harriet Nakafeero', '+256707555666', 'This morning', 'Keep envelope sealed and undamaged.', 'confirmed', 'public', '2026-03-17 17:47:28', '2026-03-17 18:16:25'),
(6, 3, 'buyer', 'item_purchase_request', 'Source birthday cake and party supplies', 'Buy a medium vanilla birthday cake, candles, paper plates, and juice for a family gathering this afternoon.', 'Capital Shoppers, Ntinda', 'Kisaasi, Kampala', 118000.00, 116000.00, 'bank_transfer', 'Sarah Nansubuga', '+256702110223', 'Today 1pm - 4pm', 'Cake should be written with \"Happy Birthday Auntie Mary\".', 'in_progress', 'public', '2026-03-17 18:16:25', '2026-03-17 18:16:25'),
(7, 2, 'seller', 'delivery_request', 'Deliver catering supplies to UMA conference venue', 'Move sealed catering supplies from the store to the conference venue and hand over to the event coordinator before setup begins.', 'Nakawa Industrial Area, Kampala', 'UMA Show Grounds, Lugogo', 67000.00, 67000.00, 'cash_on_delivery', 'Mildred Nassozi', '+256705888999', 'Today 9am - 12pm', 'Check item count with the coordinator before leaving.', 'in_progress', 'public', '2026-03-17 18:16:25', '2026-03-17 18:16:25'),
(8, 11, 'buyer', 'custom_errand', 'Pick up laptop charger from Village Mall', 'Pick up a reserved laptop charger from the electronics shop and bring it to the office before close of business.', 'Village Mall, Bugolobi', 'Kololo, Kampala', 35000.00, NULL, 'wallet', 'Joel Ssentamu', '+256702220334', 'Today before 5pm', 'Request the shop receipt and keep the box clean.', 'open', 'public', '2026-03-17 18:16:25', '2026-03-17 18:16:25'),
(9, 10, 'seller', 'delivery_request', 'Restock salon products from Kikuubo supplier', 'Collect a prepared salon restock from the supplier and return it to the shop before customer traffic increases.', 'Kikuubo, Kampala', 'Kansanga, Kampala', 54000.00, NULL, 'manual_record', 'Irene Nakato', '+256701220332', 'Tomorrow 10am - 1pm', 'Supplier will release stock after phone confirmation.', 'open', 'public', '2026-03-17 18:16:25', '2026-03-17 18:16:25');

-- --------------------------------------------------------

--
-- Table structure for table `request_items`
--

CREATE TABLE `request_items` (
  `id` int(10) UNSIGNED NOT NULL,
  `request_id` int(10) UNSIGNED NOT NULL,
  `item_name` varchar(180) NOT NULL,
  `item_description` text DEFAULT NULL,
  `quantity` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `estimated_unit_price` decimal(12,2) NOT NULL DEFAULT 0.00,
  `image_path` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `request_items`
--

INSERT INTO `request_items` (`id`, `request_id`, `item_name`, `item_description`, `quantity`, `estimated_unit_price`, `image_path`, `created_at`, `updated_at`) VALUES
(1, 1, 'Beverage Cartons', 'Two sealed cartons packed for retail shelf delivery.', 2, 22500.00, NULL, '2026-03-17 16:46:29', '2026-03-17 18:16:25'),
(2, 2, 'Weekly Groceries', 'Rice, cooking oil, tomatoes, onions, and seasoning from a reliable market stall.', 1, 92000.00, NULL, '2026-03-17 16:46:29', '2026-03-17 18:16:25'),
(3, 3, 'Pharmacy Package', 'Already paid package with medicine and vitamins.', 1, 32000.00, NULL, '2026-03-17 17:47:28', '2026-03-17 18:16:25'),
(4, 4, 'Boutique Parcel', 'Fashion parcel wrapped for customer delivery.', 1, 28000.00, NULL, '2026-03-17 17:47:28', '2026-03-17 17:47:28'),
(5, 5, 'Contract Documents', 'Signed documents for internal branch processing.', 1, 40000.00, NULL, '2026-03-17 17:47:28', '2026-03-17 18:16:25'),
(6, 6, 'Cake and Party Supplies', 'Vanilla cake, candles, plates, tissue, and bottled juice.', 1, 118000.00, NULL, '2026-03-17 18:16:25', '2026-03-17 18:16:25'),
(7, 7, 'Catering Supplies', 'Disposable trays, drinks, napkins, and serving items for an event setup.', 6, 11166.67, NULL, '2026-03-17 18:16:25', '2026-03-17 18:16:25'),
(8, 8, 'Laptop Charger', 'Reserved original charger from the electronics store.', 1, 35000.00, NULL, '2026-03-17 18:16:25', '2026-03-17 18:16:25'),
(9, 9, 'Salon Restock', 'Hair food, body lotion, and related salon products packed by the supplier.', 1, 54000.00, NULL, '2026-03-17 18:16:25', '2026-03-17 18:16:25');

-- --------------------------------------------------------

--
-- Table structure for table `request_item_samples`
--

CREATE TABLE `request_item_samples` (
  `id` int(10) UNSIGNED NOT NULL,
  `request_id` int(10) UNSIGNED NOT NULL,
  `runner_id` int(10) UNSIGNED NOT NULL,
  `image_path` varchar(255) NOT NULL,
  `caption` varchar(255) DEFAULT NULL,
  `price_estimate` decimal(12,2) DEFAULT NULL,
  `is_selected` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `request_status_logs`
--

CREATE TABLE `request_status_logs` (
  `id` int(10) UNSIGNED NOT NULL,
  `request_id` int(10) UNSIGNED NOT NULL,
  `actor_id` int(10) UNSIGNED DEFAULT NULL,
  `status` enum('open','quoted','assigned','in_progress','completed','confirmed','cancelled') NOT NULL,
  `note` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `request_status_logs`
--

INSERT INTO `request_status_logs` (`id`, `request_id`, `actor_id`, `status`, `note`, `created_at`) VALUES
(1, 1, 2, 'open', 'Moses created the beverage delivery request for a retail customer restock.', '2026-03-17 16:46:29'),
(2, 1, 4, 'assigned', 'Peter accepted the delivery and is preparing for dispatch.', '2026-03-17 16:46:29'),
(3, 2, 3, 'open', 'Sarah created a planned grocery sourcing errand for her household.', '2026-03-17 16:46:29'),
(4, 1, 1, 'completed', 'Runner marked the request as completed.', '2026-03-17 17:03:45'),
(5, 2, NULL, 'quoted', 'Multiple runner quotations have been submitted for review.', '2026-03-17 18:16:25'),
(6, 6, 3, 'open', 'Sarah created a cake and party supplies sourcing errand for a family gathering.', '2026-03-17 18:16:25'),
(7, 6, NULL, 'quoted', 'Competing runner quotations were submitted for the party sourcing errand.', '2026-03-17 18:16:26'),
(8, 6, 13, 'assigned', 'Ruth was selected based on the approved quotation.', '2026-03-17 18:16:26'),
(9, 6, 13, 'in_progress', 'Ruth has started the bakery pickup and related shopping.', '2026-03-17 18:16:26'),
(10, 7, 2, 'open', 'Moses created a venue delivery request for conference catering supplies.', '2026-03-17 18:16:26'),
(11, 7, 7, 'assigned', 'Samuel accepted the catering supplies delivery.', '2026-03-17 18:16:26'),
(12, 7, 7, 'in_progress', 'Samuel is transporting supplies to UMA Show Grounds.', '2026-03-17 18:16:26'),
(13, 8, 11, 'open', 'Joel created a tech accessory pickup request for the office.', '2026-03-17 18:16:26'),
(14, 9, 10, 'open', 'Irene created a restock request ahead of weekend salon traffic.', '2026-03-17 18:16:26'),
(15, 2, 1, 'cancelled', 'Request cancelled by owner or admin.', '2026-03-17 19:38:20');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` int(10) UNSIGNED NOT NULL,
  `role_key` varchar(30) NOT NULL,
  `role_name` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `role_key`, `role_name`, `created_at`) VALUES
(1, 'seller', 'Seller', '2026-03-17 16:46:29'),
(2, 'buyer', 'Buyer / Customer', '2026-03-17 16:46:29'),
(3, 'runner', 'Runner / Delivery Agent', '2026-03-17 16:46:29'),
(4, 'admin', 'Administrator', '2026-03-17 16:46:29');

-- --------------------------------------------------------

--
-- Table structure for table `runner_reviews`
--

CREATE TABLE `runner_reviews` (
  `id` int(10) UNSIGNED NOT NULL,
  `request_id` int(10) UNSIGNED NOT NULL,
  `reviewer_id` int(10) UNSIGNED NOT NULL,
  `runner_id` int(10) UNSIGNED NOT NULL,
  `rating` tinyint(3) UNSIGNED NOT NULL,
  `review_text` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ;

--
-- Dumping data for table `runner_reviews`
--

INSERT INTO `runner_reviews` (`id`, `request_id`, `reviewer_id`, `runner_id`, `rating`, `review_text`, `created_at`, `updated_at`) VALUES
(1, 3, 3, 7, 5, 'Samuel kept me updated, handled the pharmacy package carefully, and arrived earlier than expected.', '2026-03-17 17:47:28', '2026-03-17 17:47:28'),
(2, 4, 2, 8, 5, 'Aisha communicated beautifully with the customer and made the delivery feel premium and stress free.', '2026-03-17 17:47:28', '2026-03-17 17:47:28'),
(3, 5, 3, 9, 4, 'Brian was professional, respectful, and delivered the office documents without any issues.', '2026-03-17 17:47:28', '2026-03-17 17:47:28');

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE `transactions` (
  `id` int(10) UNSIGNED NOT NULL,
  `request_id` int(10) UNSIGNED NOT NULL,
  `payer_id` int(10) UNSIGNED NOT NULL,
  `payee_id` int(10) UNSIGNED DEFAULT NULL,
  `amount` decimal(12,2) NOT NULL,
  `payment_method` enum('cash_on_delivery','bank_transfer','wallet','manual_record') NOT NULL DEFAULT 'manual_record',
  `payment_status` enum('pending','processing','paid','cancelled') NOT NULL DEFAULT 'pending',
  `transaction_reference` varchar(80) NOT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transactions`
--

INSERT INTO `transactions` (`id`, `request_id`, `payer_id`, `payee_id`, `amount`, `payment_method`, `payment_status`, `transaction_reference`, `notes`, `created_at`, `updated_at`) VALUES
(1, 1, 2, 4, 45000.00, 'cash_on_delivery', 'processing', 'TRX-2026-1001', 'Cash settlement will be completed after the cartons are handed over to the mini mart.', '2026-03-17 16:46:29', '2026-03-17 18:16:25'),
(2, 3, 3, 7, 32000.00, 'bank_transfer', 'paid', 'TRX-2026-1002', 'Bank transfer cleared after the pharmacy order was delivered.', '2026-03-17 17:47:28', '2026-03-17 18:16:25'),
(3, 4, 2, 8, 28000.00, 'cash_on_delivery', 'paid', 'TRX-2026-1003', 'Customer paid on delivery and the seller settled the runner immediately after.', '2026-03-17 17:47:28', '2026-03-17 18:16:25'),
(4, 5, 3, 9, 40000.00, 'manual_record', 'paid', 'TRX-2026-1004', 'Manual office settlement recorded after documents reached the branch.', '2026-03-17 17:47:28', '2026-03-17 18:16:25'),
(5, 6, 3, 13, 116000.00, 'bank_transfer', 'processing', 'TRX-2026-1005', 'Initial transfer sent while the runner completes bakery pickup and party supply sourcing.', '2026-03-17 18:16:25', '2026-03-17 18:16:25'),
(6, 7, 2, 7, 67000.00, 'cash_on_delivery', 'processing', 'TRX-2026-1006', 'Runner payment will be closed out after the event coordinator confirms item count.', '2026-03-17 18:16:25', '2026-03-17 18:16:25');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `role_id` int(10) UNSIGNED NOT NULL,
  `full_name` varchar(150) NOT NULL,
  `email` varchar(150) NOT NULL,
  `phone` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `last_login_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `role_id`, `full_name`, `email`, `phone`, `password_hash`, `is_active`, `last_login_at`, `created_at`, `updated_at`) VALUES
(1, 4, 'Ssekiziyivu Denison', 'ssekiziyivudenison19@gmail.com', '+256706888958', '$2y$10$Gkx5wBHl1Udkob/AY70igeQgz.7cwFJ5GpZlHxyawHXOOrnWOCiN2', 1, '2026-03-17 21:01:40', '2026-03-17 16:46:29', '2026-03-17 21:01:40'),
(2, 1, 'Moses Kibirige', 'moses.kibirige@errandsrunner.test', '+256701110221', '$2y$10$Gkx5wBHl1Udkob/AY70igeQgz.7cwFJ5GpZlHxyawHXOOrnWOCiN2', 1, NULL, '2026-03-17 16:46:29', '2026-03-17 18:16:25'),
(3, 2, 'Sarah Nansubuga', 'sarah.nansubuga@errandsrunner.test', '+256702110223', '$2y$10$Gkx5wBHl1Udkob/AY70igeQgz.7cwFJ5GpZlHxyawHXOOrnWOCiN2', 1, NULL, '2026-03-17 16:46:29', '2026-03-17 18:16:25'),
(4, 3, 'Peter Walusimbi', 'peter.walusimbi@errandsrunner.test', '+256703110226', '$2y$10$Gkx5wBHl1Udkob/AY70igeQgz.7cwFJ5GpZlHxyawHXOOrnWOCiN2', 1, NULL, '2026-03-17 16:46:29', '2026-03-17 18:16:25'),
(5, 2, 'Gareth Neville', 'garethneville3@gmail.com', '0702777745', '$2y$10$xlwj56VCFZX2F5zsCk8qeu1xm9rU.ZwD/.9xjyAW8usrfOLFTLmK.', 1, '2026-03-17 19:52:30', '2026-03-17 16:52:10', '2026-03-17 19:52:30'),
(6, 3, 'john doe', 'johndoe3@gmail.com', '0702333345', '$2y$10$wJLx/brxjkFg04MPwaeok.fi2y2Wsno/DMrUdvwrB7qzvdd9/CFn6', 1, NULL, '2026-03-17 17:01:30', '2026-03-17 17:01:30'),
(7, 3, 'Samuel Kato', 'samuel.kato@errandsrunner.test', '+256704110221', '$2y$10$Gkx5wBHl1Udkob/AY70igeQgz.7cwFJ5GpZlHxyawHXOOrnWOCiN2', 1, NULL, '2026-03-17 17:47:28', '2026-03-17 18:16:25'),
(8, 3, 'Aisha Nanyonga', 'aisha.nanyonga@errandsrunner.test', '+256704220331', '$2y$10$Gkx5wBHl1Udkob/AY70igeQgz.7cwFJ5GpZlHxyawHXOOrnWOCiN2', 1, NULL, '2026-03-17 17:47:28', '2026-03-17 18:16:25'),
(9, 3, 'Brian Ssemanda', 'brian.ssemanda@errandsrunner.test', '+256704330441', '$2y$10$Gkx5wBHl1Udkob/AY70igeQgz.7cwFJ5GpZlHxyawHXOOrnWOCiN2', 1, NULL, '2026-03-17 17:47:28', '2026-03-17 18:16:25'),
(10, 1, 'Irene Nakato', 'irene.nakato@errandsrunner.test', '+256701220332', '$2y$10$Gkx5wBHl1Udkob/AY70igeQgz.7cwFJ5GpZlHxyawHXOOrnWOCiN2', 1, NULL, '2026-03-17 18:16:25', '2026-03-17 18:16:25'),
(11, 2, 'Joel Ssentamu', 'joel.ssentamu@errandsrunner.test', '+256702220334', '$2y$10$Gkx5wBHl1Udkob/AY70igeQgz.7cwFJ5GpZlHxyawHXOOrnWOCiN2', 1, NULL, '2026-03-17 18:16:25', '2026-03-17 18:16:25'),
(12, 2, 'Patricia Namara', 'patricia.namara@errandsrunner.test', '+256702330445', '$2y$10$Gkx5wBHl1Udkob/AY70igeQgz.7cwFJ5GpZlHxyawHXOOrnWOCiN2', 1, NULL, '2026-03-17 18:16:25', '2026-03-17 18:16:25'),
(13, 3, 'Ruth Nankya', 'ruth.nankya@errandsrunner.test', '+256703550662', '$2y$10$Gkx5wBHl1Udkob/AY70igeQgz.7cwFJ5GpZlHxyawHXOOrnWOCiN2', 1, NULL, '2026-03-17 18:16:25', '2026-03-17 18:16:25');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `assignments`
--
ALTER TABLE `assignments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `request_id` (`request_id`),
  ADD KEY `fk_assignments_quotation` (`quotation_id`),
  ADD KEY `idx_assignments_runner` (`runner_id`),
  ADD KEY `idx_assignments_status` (`status`),
  ADD KEY `idx_assignments_location` (`current_lat`,`current_lng`);

--
-- Indexes for table `contact_messages`
--
ALTER TABLE `contact_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_contact_messages_status` (`status`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_notifications_user` (`user_id`),
  ADD KEY `idx_notifications_read` (`is_read`);

--
-- Indexes for table `profiles`
--
ALTER TABLE `profiles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- Indexes for table `quotations`
--
ALTER TABLE `quotations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_quotations_request` (`request_id`),
  ADD KEY `idx_quotations_runner` (`runner_id`),
  ADD KEY `idx_quotations_status` (`status`);

--
-- Indexes for table `requests`
--
ALTER TABLE `requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_requests_requester` (`requester_id`),
  ADD KEY `idx_requests_status` (`status`),
  ADD KEY `idx_requests_type` (`request_type`),
  ADD KEY `idx_requests_visibility` (`visibility_status`);

--
-- Indexes for table `request_items`
--
ALTER TABLE `request_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_request_items_request` (`request_id`);

--
-- Indexes for table `request_item_samples`
--
ALTER TABLE `request_item_samples`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_request_item_samples_request` (`request_id`),
  ADD KEY `idx_request_item_samples_runner` (`runner_id`),
  ADD KEY `idx_request_item_samples_selected` (`is_selected`);

--
-- Indexes for table `request_status_logs`
--
ALTER TABLE `request_status_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_request_status_logs_actor` (`actor_id`),
  ADD KEY `idx_request_status_logs_request` (`request_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `role_key` (`role_key`);

--
-- Indexes for table `runner_reviews`
--
ALTER TABLE `runner_reviews`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `request_id` (`request_id`),
  ADD KEY `fk_runner_reviews_reviewer` (`reviewer_id`),
  ADD KEY `fk_runner_reviews_runner` (`runner_id`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `transaction_reference` (`transaction_reference`),
  ADD KEY `fk_transactions_request` (`request_id`),
  ADD KEY `idx_transactions_status` (`payment_status`),
  ADD KEY `idx_transactions_payer` (`payer_id`),
  ADD KEY `idx_transactions_payee` (`payee_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_users_role` (`role_id`),
  ADD KEY `idx_users_active` (`is_active`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `assignments`
--
ALTER TABLE `assignments`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `contact_messages`
--
ALTER TABLE `contact_messages`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `profiles`
--
ALTER TABLE `profiles`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `quotations`
--
ALTER TABLE `quotations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `requests`
--
ALTER TABLE `requests`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `request_items`
--
ALTER TABLE `request_items`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `request_item_samples`
--
ALTER TABLE `request_item_samples`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `request_status_logs`
--
ALTER TABLE `request_status_logs`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `runner_reviews`
--
ALTER TABLE `runner_reviews`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `assignments`
--
ALTER TABLE `assignments`
  ADD CONSTRAINT `fk_assignments_quotation` FOREIGN KEY (`quotation_id`) REFERENCES `quotations` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_assignments_request` FOREIGN KEY (`request_id`) REFERENCES `requests` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_assignments_runner` FOREIGN KEY (`runner_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `fk_notifications_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `profiles`
--
ALTER TABLE `profiles`
  ADD CONSTRAINT `fk_profiles_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `quotations`
--
ALTER TABLE `quotations`
  ADD CONSTRAINT `fk_quotations_request` FOREIGN KEY (`request_id`) REFERENCES `requests` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_quotations_runner` FOREIGN KEY (`runner_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `requests`
--
ALTER TABLE `requests`
  ADD CONSTRAINT `fk_requests_requester` FOREIGN KEY (`requester_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `request_items`
--
ALTER TABLE `request_items`
  ADD CONSTRAINT `fk_request_items_request` FOREIGN KEY (`request_id`) REFERENCES `requests` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `request_item_samples`
--
ALTER TABLE `request_item_samples`
  ADD CONSTRAINT `fk_request_item_samples_request` FOREIGN KEY (`request_id`) REFERENCES `requests` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_request_item_samples_runner` FOREIGN KEY (`runner_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `request_status_logs`
--
ALTER TABLE `request_status_logs`
  ADD CONSTRAINT `fk_request_status_logs_actor` FOREIGN KEY (`actor_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_request_status_logs_request` FOREIGN KEY (`request_id`) REFERENCES `requests` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `runner_reviews`
--
ALTER TABLE `runner_reviews`
  ADD CONSTRAINT `fk_runner_reviews_request` FOREIGN KEY (`request_id`) REFERENCES `requests` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_runner_reviews_reviewer` FOREIGN KEY (`reviewer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_runner_reviews_runner` FOREIGN KEY (`runner_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `fk_transactions_payee` FOREIGN KEY (`payee_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_transactions_payer` FOREIGN KEY (`payer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_transactions_request` FOREIGN KEY (`request_id`) REFERENCES `requests` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_users_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);
--
-- Database: `footystats`
--
CREATE DATABASE IF NOT EXISTS `footystats` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `footystats`;

-- --------------------------------------------------------

--
-- Table structure for table `admin_users`
--

CREATE TABLE `admin_users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `is_super_admin` tinyint(1) DEFAULT 0,
  `last_login` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin_users`
--

INSERT INTO `admin_users` (`id`, `username`, `password_hash`, `email`, `full_name`, `is_super_admin`, `last_login`, `created_at`, `updated_at`) VALUES
(1, 'admin', '$2y$10$o0nqBlC2wqIJHCNHhKMRjekzoeqQKJuDw6HXnpAeipZjRGdB8d1g2', 'garethneville3@gmail.com', 'Gareth Neville Kisuze', 1, '2025-06-17 10:43:15', '2025-06-13 07:32:00', '2025-06-17 07:43:15');

-- --------------------------------------------------------

--
-- Table structure for table `images`
--

CREATE TABLE `images` (
  `id` int(11) NOT NULL,
  `type` enum('goal','assist','table_standings') NOT NULL,
  `filename` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `season` varchar(9) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `images`
--

INSERT INTO `images` (`id`, `type`, `filename`, `description`, `season`, `created_at`, `updated_at`) VALUES
(1, 'table_standings', 'table_standings_6846bbb6483803.21797050.jpg', 'table standings', '2025/26', '2025-06-09 10:47:18', '2025-06-09 10:47:18');

-- --------------------------------------------------------

--
-- Table structure for table `matches`
--

CREATE TABLE `matches` (
  `id` int(11) NOT NULL,
  `home_team_id` int(11) NOT NULL,
  `away_team_id` int(11) NOT NULL,
  `match_date` datetime NOT NULL,
  `home_score` int(11) DEFAULT NULL,
  `away_score` int(11) DEFAULT NULL,
  `status` enum('scheduled','live','completed','cancelled') DEFAULT 'scheduled',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `match_start_time` datetime DEFAULT NULL,
  `current_minute` int(11) DEFAULT 0,
  `is_timer_running` tinyint(1) DEFAULT 0,
  `last_timer_update` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `matches`
--

INSERT INTO `matches` (`id`, `home_team_id`, `away_team_id`, `match_date`, `home_score`, `away_score`, `status`, `created_at`, `updated_at`, `match_start_time`, `current_minute`, `is_timer_running`, `last_timer_update`) VALUES
(5, 2, 1, '2025-05-24 11:30:00', 2, 2, 'completed', '2025-06-10 06:49:40', '2025-06-10 06:49:40', NULL, 0, 0, NULL),
(6, 3, 2, '2025-05-24 12:32:00', 3, 1, 'completed', '2025-06-10 07:35:12', '2025-06-10 07:35:12', NULL, 0, 0, NULL),
(7, 3, 1, '2025-05-24 12:41:00', 1, 2, 'completed', '2025-06-10 07:39:54', '2025-06-10 07:39:54', NULL, 0, 0, NULL),
(8, 3, 4, '2025-05-31 11:00:00', 1, 3, 'completed', '2025-06-10 08:00:59', '2025-06-10 08:00:59', NULL, 0, 0, NULL),
(9, 1, 2, '2025-05-31 12:05:00', 2, 0, 'completed', '2025-06-10 08:05:14', '2025-06-10 08:05:14', NULL, 0, 0, NULL),
(10, 4, 1, '2025-05-31 03:20:00', 1, 2, 'completed', '2025-06-10 08:12:26', '2025-06-11 06:52:29', NULL, 0, 0, NULL),
(11, 2, 3, '2025-05-31 12:50:00', 2, 0, 'completed', '2025-06-10 08:33:15', '2025-06-10 08:33:15', NULL, 0, 0, NULL),
(12, 4, 2, '2025-05-31 10:13:00', 2, 3, 'completed', '2025-06-10 08:41:14', '2025-06-10 08:42:26', NULL, 0, 0, NULL),
(13, 3, 1, '2025-05-31 13:46:00', 0, 5, 'completed', '2025-06-10 08:56:02', '2025-06-10 08:56:02', NULL, 0, 0, NULL),
(14, 2, 1, '2025-06-07 11:19:00', 4, 1, 'completed', '2025-06-10 09:10:55', '2025-06-10 09:10:55', NULL, 0, 0, NULL),
(15, 3, 4, '2025-06-07 11:50:00', 1, 0, 'completed', '2025-06-10 09:20:05', '2025-06-10 09:20:05', NULL, 0, 0, NULL),
(16, 1, 5, '2025-06-07 11:55:00', 4, 0, 'completed', '2025-06-10 09:22:35', '2025-06-10 09:22:35', NULL, 0, 0, NULL),
(17, 3, 2, '2025-06-07 12:15:00', 3, 0, 'completed', '2025-06-10 09:24:36', '2025-06-10 09:24:36', NULL, 0, 0, NULL),
(18, 5, 4, '2025-06-07 12:51:00', 0, 0, 'completed', '2025-06-10 09:27:09', '2025-06-10 09:27:09', NULL, 0, 0, NULL),
(19, 1, 3, '2025-06-07 09:55:00', 2, 1, 'completed', '2025-06-10 09:30:06', '2025-06-10 09:30:43', NULL, 0, 0, NULL),
(20, 2, 4, '2025-06-07 10:15:00', 3, 1, 'completed', '2025-06-10 09:35:47', '2025-06-10 10:28:28', NULL, 0, 0, NULL),
(21, 3, 5, '2025-06-07 13:46:00', 1, 0, 'completed', '2025-06-10 10:23:06', '2025-06-10 10:23:47', NULL, 0, 0, NULL),
(22, 4, 1, '2025-06-07 07:56:00', 2, 2, 'completed', '2025-06-10 10:28:08', '2025-06-11 05:12:11', NULL, 0, 0, NULL),
(23, 2, 5, '2025-06-07 14:30:00', 1, 0, 'completed', '2025-06-10 10:30:04', '2025-06-10 10:30:04', NULL, 0, 0, NULL),
(31, 3, 1, '2025-06-14 11:17:00', 0, 0, 'completed', '2025-06-13 08:41:46', '2025-06-14 08:54:49', NULL, 0, 0, NULL),
(32, 2, 5, '2025-06-14 11:34:00', 4, 1, 'completed', '2025-06-13 08:42:26', '2025-06-14 09:13:26', NULL, 0, 0, NULL),
(33, 4, 3, '2025-06-14 08:51:00', 1, 1, 'completed', '2025-06-13 08:43:50', '2025-06-14 19:47:24', NULL, 0, 0, NULL),
(34, 1, 2, '2025-06-14 12:08:00', 0, 2, 'completed', '2025-06-13 08:45:17', '2025-06-14 10:02:28', NULL, 0, 0, NULL),
(35, 5, 3, '2025-06-14 12:25:00', 2, 0, 'completed', '2025-06-13 08:46:04', '2025-06-14 10:16:15', NULL, 0, 0, NULL),
(36, 1, 4, '2025-06-14 12:42:00', 1, 0, 'completed', '2025-06-13 08:47:04', '2025-06-14 10:36:49', NULL, 0, 0, NULL),
(37, 2, 3, '2025-06-14 09:59:00', 0, 1, 'completed', '2025-06-13 08:49:22', '2025-06-14 19:46:52', NULL, 0, 0, NULL),
(38, 5, 1, '2025-06-14 13:16:00', 2, 1, 'completed', '2025-06-13 08:50:44', '2025-06-14 11:27:45', NULL, 0, 0, NULL),
(39, 2, 4, '2025-06-14 13:33:00', 0, 1, 'completed', '2025-06-13 08:51:49', '2025-06-14 11:48:55', NULL, 0, 0, NULL),
(40, 5, 4, '2025-06-14 11:00:00', 1, 2, 'completed', '2025-06-14 07:44:14', '2025-06-14 08:32:15', NULL, 0, 0, NULL),
(52, 1, 4, '2025-06-07 12:38:00', 0, 0, 'scheduled', '2025-06-16 09:38:25', '2025-06-16 09:38:25', NULL, 0, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `match_events`
--

CREATE TABLE `match_events` (
  `id` int(11) NOT NULL,
  `match_id` int(11) NOT NULL,
  `player_id` int(11) DEFAULT NULL,
  `event_type` enum('goal','assist','yellow_card','red_card','substitution') NOT NULL,
  `goal_type` enum('regular','own_goal','penalty') DEFAULT 'regular',
  `minute` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `assist_player_id` int(11) DEFAULT NULL,
  `is_penalty` tinyint(1) NOT NULL DEFAULT 0,
  `is_own_goal` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `match_events`
--

INSERT INTO `match_events` (`id`, `match_id`, `player_id`, `event_type`, `goal_type`, `minute`, `created_at`, `assist_player_id`, `is_penalty`, `is_own_goal`) VALUES
(12, 5, 4, 'goal', 'regular', 2, '2025-06-10 06:49:40', NULL, 0, 0),
(13, 5, 2, 'goal', 'regular', 4, '2025-06-10 06:49:40', NULL, 0, 0),
(14, 5, 4, 'goal', 'regular', 6, '2025-06-10 06:49:40', NULL, 0, 0),
(15, 5, 46, 'goal', 'regular', 11, '2025-06-10 06:49:40', NULL, 0, 0),
(16, 6, 9, 'goal', 'regular', 3, '2025-06-10 07:35:12', NULL, 0, 0),
(17, 6, 9, 'goal', 'regular', 6, '2025-06-10 07:35:12', NULL, 0, 0),
(18, 6, 9, 'goal', 'regular', 7, '2025-06-10 07:35:12', NULL, 0, 0),
(19, 6, 4, 'goal', 'regular', 12, '2025-06-10 07:35:12', NULL, 0, 0),
(20, 7, 5, 'goal', 'regular', 3, '2025-06-10 07:39:54', NULL, 0, 0),
(21, 7, 2, 'goal', 'regular', 4, '2025-06-10 07:39:54', NULL, 0, 0),
(22, 7, 47, 'goal', 'regular', 6, '2025-06-10 07:39:54', NULL, 0, 0),
(23, 8, 22, 'goal', 'regular', 3, '2025-06-10 08:00:59', 23, 0, 0),
(24, 8, 9, 'goal', 'regular', 2, '2025-06-10 08:00:59', NULL, 0, 0),
(25, 8, 29, 'goal', 'regular', 5, '2025-06-10 08:00:59', 30, 0, 0),
(26, 8, 29, 'goal', 'regular', 11, '2025-06-10 08:00:59', 22, 0, 0),
(27, 9, 2, 'goal', 'regular', 1, '2025-06-10 08:05:14', 48, 0, 0),
(28, 9, 46, 'goal', 'regular', 2, '2025-06-10 08:05:14', 45, 0, 0),
(33, 11, 4, 'goal', 'regular', 3, '2025-06-10 08:33:15', 43, 0, 0),
(34, 11, 52, 'goal', 'regular', 7, '2025-06-10 08:33:15', 4, 0, 0),
(40, 12, 23, 'goal', 'regular', 1, '2025-06-10 08:42:26', 28, 0, 0),
(41, 12, 40, 'goal', 'regular', 2, '2025-06-10 08:42:26', 39, 0, 0),
(42, 12, 4, 'goal', 'regular', 3, '2025-06-10 08:42:26', NULL, 0, 0),
(43, 12, 23, 'goal', 'regular', 67, '2025-06-10 08:42:26', NULL, 0, 0),
(44, 12, 39, 'goal', 'regular', 86, '2025-06-10 08:42:26', 4, 0, 0),
(45, 12, 1, 'red_card', 'regular', 19, '2025-06-10 08:42:26', NULL, 0, 0),
(46, 13, 44, 'goal', 'regular', 4, '2025-06-10 08:56:02', 50, 0, 0),
(47, 13, 50, 'goal', 'regular', 5, '2025-06-10 08:56:02', 46, 0, 0),
(48, 13, 45, 'goal', 'regular', 15, '2025-06-10 08:56:02', 2, 0, 0),
(49, 13, 46, 'goal', 'regular', 20, '2025-06-10 08:56:02', 2, 0, 0),
(50, 13, 2, 'goal', 'regular', 21, '2025-06-10 08:56:02', 50, 0, 0),
(51, 14, 39, 'goal', 'regular', 1, '2025-06-10 09:10:55', NULL, 0, 0),
(52, 14, 46, 'goal', 'regular', 2, '2025-06-10 09:10:55', 2, 0, 0),
(53, 14, 4, 'goal', 'regular', 3, '2025-06-10 09:10:55', NULL, 0, 0),
(54, 14, 42, 'goal', 'regular', 8, '2025-06-10 09:10:55', 39, 0, 0),
(55, 14, 4, 'goal', 'regular', 13, '2025-06-10 09:10:55', NULL, 0, 0),
(56, 15, 18, 'goal', 'regular', 9, '2025-06-10 09:20:05', 9, 0, 0),
(57, 16, 48, 'goal', 'regular', 3, '2025-06-10 09:22:35', 2, 0, 0),
(58, 16, 48, 'goal', 'regular', 5, '2025-06-10 09:22:35', 50, 0, 0),
(59, 16, 2, 'goal', 'regular', 4, '2025-06-10 09:22:35', 44, 0, 0),
(60, 16, 46, 'goal', 'regular', 8, '2025-06-10 09:22:35', 49, 0, 0),
(61, 17, 18, 'goal', 'regular', 2, '2025-06-10 09:24:36', NULL, 0, 0),
(62, 17, 18, 'goal', 'regular', 4, '2025-06-10 09:24:36', 9, 0, 0),
(63, 17, 18, 'goal', 'regular', 13, '2025-06-10 09:24:36', NULL, 0, 0),
(68, 19, 46, 'goal', 'regular', 2, '2025-06-10 09:30:43', 44, 0, 0),
(69, 19, 46, 'goal', 'regular', 4, '2025-06-10 09:30:43', 49, 0, 0),
(70, 19, 18, 'goal', 'regular', 14, '2025-06-10 09:30:43', 5, 0, 0),
(71, 19, 2, 'red_card', 'regular', 12, '2025-06-10 09:30:43', NULL, 0, 0),
(72, 19, 45, 'yellow_card', 'regular', 11, '2025-06-10 09:30:43', NULL, 0, 0),
(86, 21, 18, 'goal', 'regular', 14, '2025-06-10 10:23:47', 10, 0, 0),
(97, 20, 4, 'goal', 'regular', 4, '2025-06-10 10:28:28', 40, 0, 0),
(98, 20, 25, 'goal', 'regular', 5, '2025-06-10 10:28:28', 22, 0, 0),
(99, 20, 40, 'goal', 'regular', 9, '2025-06-10 10:28:28', 43, 0, 0),
(100, 20, 43, 'goal', 'regular', 16, '2025-06-10 10:28:28', 39, 0, 0),
(101, 20, 29, 'yellow_card', 'regular', 6, '2025-06-10 10:28:28', NULL, 0, 0),
(102, 20, 1, 'red_card', 'regular', 14, '2025-06-10 10:28:28', NULL, 0, 0),
(103, 23, 39, 'goal', 'regular', 4, '2025-06-10 10:30:04', 4, 0, 0),
(119, 22, 47, 'goal', 'regular', 1, '2025-06-11 05:12:11', NULL, 0, 0),
(120, 22, 29, 'goal', 'regular', 4, '2025-06-11 05:12:11', 27, 0, 0),
(121, 22, 23, 'goal', 'penalty', 6, '2025-06-11 05:12:11', NULL, 1, 0),
(122, 22, 50, 'goal', 'regular', 8, '2025-06-11 05:12:11', 49, 0, 0),
(123, 10, 1, 'goal', 'own_goal', 1, '2025-06-11 05:13:35', NULL, 0, 1),
(124, 10, 20, 'goal', 'regular', 2, '2025-06-11 05:13:35', NULL, 0, 0),
(125, 10, 20, 'goal', 'regular', 4, '2025-06-11 05:13:35', NULL, 0, 0),
(126, 10, 22, 'yellow_card', 'regular', 6, '2025-06-11 05:13:35', NULL, 0, 0),
(161, 40, 20, 'goal', 'regular', 3, '2025-06-14 08:17:49', 29, 0, 0),
(162, 40, 20, 'goal', 'regular', 5, '2025-06-14 08:20:31', 1, 0, 0),
(163, 40, 54, 'goal', 'regular', 11, '2025-06-14 08:26:31', NULL, 0, 0),
(164, 40, 57, 'yellow_card', 'regular', 16, '2025-06-14 08:30:49', NULL, 0, 0),
(165, 32, 4, 'goal', 'regular', 5, '2025-06-14 09:02:47', 36, 0, 0),
(166, 32, 4, 'goal', 'regular', 8, '2025-06-14 09:04:52', 39, 0, 0),
(167, 32, 4, 'goal', 'regular', 9, '2025-06-14 09:05:50', 36, 0, 0),
(170, 34, 4, 'goal', 'regular', 3, '2025-06-14 09:40:19', 39, 0, 0),
(171, 34, 4, 'goal', 'regular', 12, '2025-06-14 09:50:59', NULL, 0, 0),
(172, 35, 54, 'goal', 'regular', 5, '2025-06-14 10:05:44', 67, 0, 0),
(173, 35, 54, 'goal', 'regular', 6, '2025-06-14 10:06:09', NULL, 0, 0),
(174, 36, 44, 'goal', 'regular', 16, '2025-06-14 10:36:28', 2, 0, 0),
(176, 38, 55, 'goal', 'regular', 4, '2025-06-14 11:13:16', 54, 0, 0),
(177, 38, 50, 'goal', 'regular', 7, '2025-06-14 11:15:35', 47, 0, 0),
(178, 38, 63, 'goal', 'regular', 13, '2025-06-14 11:23:16', 53, 0, 0),
(179, 39, 21, 'goal', 'regular', 4, '2025-06-14 11:33:26', 23, 0, 0),
(182, 37, 18, 'goal', 'penalty', 13, '2025-06-14 19:46:52', NULL, 1, 0),
(183, 33, 29, 'goal', 'regular', 4, '2025-06-14 19:47:24', 22, 0, 0),
(184, 33, 19, 'goal', 'regular', 14, '2025-06-14 19:47:24', 9, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `match_statistics_tracking`
--

CREATE TABLE `match_statistics_tracking` (
  `match_id` int(11) NOT NULL,
  `season` varchar(9) NOT NULL,
  `counted_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `match_statistics_tracking`
--

INSERT INTO `match_statistics_tracking` (`match_id`, `season`, `counted_at`) VALUES
(5, '2025', '2025-06-16 11:44:32'),
(6, '2025', '2025-06-16 11:44:32'),
(7, '2025', '2025-06-16 11:44:32'),
(8, '2025', '2025-06-16 11:44:32'),
(9, '2025', '2025-06-16 11:44:32'),
(10, '2025', '2025-06-16 11:44:32'),
(11, '2025', '2025-06-16 11:44:32'),
(12, '2025', '2025-06-16 11:44:32'),
(13, '2025', '2025-06-16 11:44:32'),
(14, '2025', '2025-06-16 11:44:32'),
(15, '2025', '2025-06-16 11:44:32'),
(16, '2025', '2025-06-16 11:44:32'),
(17, '2025', '2025-06-16 11:44:32'),
(18, '2025', '2025-06-16 11:44:32'),
(19, '2025', '2025-06-16 11:44:32'),
(20, '2025', '2025-06-16 11:44:32'),
(21, '2025', '2025-06-16 11:44:32'),
(22, '2025', '2025-06-16 11:44:32'),
(23, '2025', '2025-06-16 11:44:32'),
(31, '2025', '2025-06-16 11:44:32'),
(32, '2025', '2025-06-16 11:44:32'),
(33, '2025', '2025-06-16 11:44:32'),
(34, '2025', '2025-06-16 11:44:32'),
(35, '2025', '2025-06-16 11:44:32'),
(36, '2025', '2025-06-16 11:44:32'),
(37, '2025', '2025-06-16 11:44:32'),
(38, '2025', '2025-06-16 11:44:32'),
(39, '2025', '2025-06-16 11:44:32'),
(40, '2025', '2025-06-16 11:44:32');

-- --------------------------------------------------------

--
-- Table structure for table `players`
--

CREATE TABLE `players` (
  `id` int(11) NOT NULL,
  `team_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `position` enum('Goalkeeper','Defender','Midfielder','Forward') NOT NULL,
  `photo_filename` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `players`
--

INSERT INTO `players` (`id`, `team_id`, `name`, `position`, `photo_filename`, `created_at`, `updated_at`) VALUES
(1, 4, 'Watuke Reagan', 'Defender', 'player_6847a4b3316ba0.62669294.png', '2025-06-09 09:34:14', '2025-06-10 11:20:09'),
(2, 1, 'certi', 'Forward', 'player_6847a445a18d56.36945788.png', '2025-06-09 11:12:14', '2025-06-10 03:19:33'),
(4, 2, 'timo', 'Forward', 'player_6847a6d619c3b5.14587914.png', '2025-06-09 11:13:00', '2025-06-10 03:30:30'),
(5, 3, 'Gareth', 'Defender', 'player_6847a4d874b1f6.55285895.png', '2025-06-09 11:13:15', '2025-06-10 06:44:46'),
(6, 3, 'Eriab', 'Defender', 'player_6847a6b77f2fc6.27391337.png', '2025-06-10 03:29:59', '2025-06-10 03:29:59'),
(7, 3, 'Kirenda', 'Midfielder', 'player_68494bb29bd558.64811734.jpg', '2025-06-10 03:31:01', '2025-06-11 09:26:10'),
(8, 3, 'Freddie', 'Midfielder', 'player_684a7602187ee0.45572431.jpg', '2025-06-10 03:31:32', '2025-06-12 06:38:58'),
(9, 3, 'Ryan', 'Forward', 'player_6847a77820f889.37937114.png', '2025-06-10 03:32:03', '2025-06-10 03:33:12'),
(10, 3, 'Shemar', 'Defender', 'player_6847a75f7d2a32.89871765.png', '2025-06-10 03:32:47', '2025-06-10 03:32:47'),
(11, 3, 'wacha', 'Defender', 'player_6847a7a9bcda93.59104121.png', '2025-06-10 03:34:01', '2025-06-10 03:34:01'),
(12, 3, 'Marvin', 'Defender', 'player_6847a7dfb08a78.31178501.png', '2025-06-10 03:34:55', '2025-06-10 03:34:55'),
(13, 3, 'Davido', 'Defender', 'player_6847a813d8b1b0.69788078.png', '2025-06-10 03:35:47', '2025-06-10 03:35:47'),
(14, 3, 'Fahad', 'Forward', 'player_6847a84e2b6f35.28663773.png', '2025-06-10 03:36:46', '2025-06-10 03:36:46'),
(15, 3, 'Bataringaya', 'Goalkeeper', 'player_6847d46f55e512.96949982.jpg', '2025-06-10 03:37:30', '2025-06-10 06:45:03'),
(16, 3, 'Semax', 'Defender', 'player_6847a8d67c5252.98247444.png', '2025-06-10 03:39:02', '2025-06-10 03:39:02'),
(17, 3, 'Kayondo', 'Midfielder', 'player_6847d4992cc6d2.96082636.jpg', '2025-06-10 03:39:33', '2025-06-10 06:45:45'),
(18, 3, 'Anyaar', 'Forward', NULL, '2025-06-10 03:40:55', '2025-06-10 03:40:55'),
(19, 3, 'Oba', 'Defender', 'player_68494857e13530.56907609.jpg', '2025-06-10 03:41:25', '2025-06-11 09:11:51'),
(20, 4, 'Hector', 'Forward', 'player_6847a9ef872102.46626558.png', '2025-06-10 03:43:43', '2025-06-10 03:43:43'),
(21, 4, 'Adengo', 'Midfielder', 'player_6847aa23741587.13823334.png', '2025-06-10 03:44:35', '2025-06-10 03:44:35'),
(22, 4, 'Crivin', 'Defender', 'player_6847aa50528af8.59209445.png', '2025-06-10 03:45:20', '2025-06-10 03:45:20'),
(23, 4, 'Mukasa Victor', 'Forward', 'player_6847aa75112b16.07538717.png', '2025-06-10 03:45:57', '2025-06-10 03:45:57'),
(24, 4, 'Maine', 'Midfielder', 'player_6847aa945927f1.72173907.png', '2025-06-10 03:46:28', '2025-06-10 03:46:28'),
(25, 4, 'Njuba', 'Forward', NULL, '2025-06-10 03:57:27', '2025-06-10 03:57:27'),
(26, 4, 'Ian Victor', 'Goalkeeper', 'player_6847ad5e57b7f3.40108421.png', '2025-06-10 03:58:22', '2025-06-10 03:58:22'),
(27, 4, 'Mubiru', 'Midfielder', NULL, '2025-06-10 03:59:43', '2025-06-10 03:59:43'),
(28, 4, 'Aijuka', 'Defender', 'player_6847addedaa802.99526329.png', '2025-06-10 04:00:30', '2025-06-10 04:00:30'),
(29, 4, 'Nick', 'Midfielder', 'player_6847adff2a9944.47830315.png', '2025-06-10 04:01:03', '2025-06-10 04:01:03'),
(30, 4, 'Cedo', 'Midfielder', 'player_6847ae93458271.13599273.png', '2025-06-10 04:03:31', '2025-06-10 04:03:31'),
(31, 2, 'Ogi', 'Defender', NULL, '2025-06-10 04:12:41', '2025-06-10 04:12:41'),
(32, 2, 'Kalumba', 'Midfielder', 'player_6847b0e0592e38.53009905.png', '2025-06-10 04:13:20', '2025-06-10 04:13:20'),
(33, 2, 'Kizz Mich', 'Defender', NULL, '2025-06-10 04:14:22', '2025-06-10 04:14:22'),
(34, 2, 'Melvin VIni', 'Forward', 'player_6847b147f1f5c8.41719375.png', '2025-06-10 04:15:03', '2025-06-10 04:15:03'),
(35, 2, 'Waya', 'Defender', 'player_6847b1650c4322.42974641.png', '2025-06-10 04:15:33', '2025-06-10 04:15:33'),
(36, 2, 'Kester', 'Forward', 'player_6847b192033ca8.19635207.png', '2025-06-10 04:16:18', '2025-06-10 04:16:18'),
(37, 2, 'Ramos', 'Defender', NULL, '2025-06-10 04:17:00', '2025-06-10 04:17:00'),
(38, 2, 'Akuma', 'Goalkeeper', NULL, '2025-06-10 04:17:24', '2025-06-10 04:17:24'),
(39, 2, 'Olimi', 'Forward', NULL, '2025-06-10 04:17:52', '2025-06-10 04:17:52'),
(40, 2, 'Zijjan', 'Midfielder', NULL, '2025-06-10 04:18:20', '2025-06-10 04:18:20'),
(41, 2, 'Perez', 'Midfielder', NULL, '2025-06-10 04:19:01', '2025-06-10 04:19:01'),
(42, 2, 'Kinya', 'Midfielder', 'player_6847b2530ff745.30447646.png', '2025-06-10 04:19:31', '2025-06-10 04:19:31'),
(43, 2, 'Conrad', 'Midfielder', NULL, '2025-06-10 04:20:00', '2025-06-10 04:20:00'),
(44, 1, 'Elijah', 'Defender', 'player_6847b3abbf8291.21996312.png', '2025-06-10 04:25:15', '2025-06-10 04:25:15'),
(45, 1, 'Cunha', 'Midfielder', 'player_6847b3d137e8f5.46776104.png', '2025-06-10 04:25:53', '2025-06-10 04:25:53'),
(46, 1, 'Acram', 'Forward', 'player_6847b40191aa67.30954060.png', '2025-06-10 04:26:41', '2025-06-10 04:26:41'),
(47, 1, 'Dalton', 'Midfielder', NULL, '2025-06-10 04:27:15', '2025-06-10 04:27:15'),
(48, 1, 'Jew', 'Midfielder', 'player_6847b44a736d99.47499629.png', '2025-06-10 04:27:54', '2025-06-10 04:27:54'),
(49, 1, 'Micheal', 'Midfielder', 'player_6847b4827f72e8.26253728.png', '2025-06-10 04:28:50', '2025-06-10 04:28:50'),
(50, 1, 'Jordan', 'Midfielder', 'player_6847b4b4d3f678.41342089.png', '2025-06-10 04:29:40', '2025-06-10 04:29:40'),
(51, 4, 'Bamwete', 'Midfielder', 'player_6847d368df6370.54881497.png', '2025-06-10 06:40:40', '2025-06-10 06:40:40'),
(52, 2, 'Imran', 'Midfielder', NULL, '2025-06-10 08:31:30', '2025-06-10 08:31:30'),
(53, 5, 'Graham', 'Goalkeeper', NULL, '2025-06-11 08:35:54', '2025-06-11 08:35:54'),
(54, 5, 'Rajab', 'Midfielder', NULL, '2025-06-11 08:36:18', '2025-06-11 08:36:18'),
(55, 5, 'Jarvis', 'Defender', NULL, '2025-06-11 08:36:48', '2025-06-11 08:36:48'),
(56, 5, 'Fabrin', 'Forward', NULL, '2025-06-11 08:37:06', '2025-06-11 08:37:06'),
(57, 5, 'Kakooza', 'Midfielder', NULL, '2025-06-11 08:37:41', '2025-06-11 08:37:41'),
(58, 5, 'Busque', 'Defender', NULL, '2025-06-11 08:38:02', '2025-06-11 08:38:02'),
(59, 5, 'Kiganda', 'Forward', NULL, '2025-06-11 08:38:25', '2025-06-11 08:38:25'),
(60, 5, 'Mera', 'Defender', NULL, '2025-06-11 08:39:38', '2025-06-11 08:39:38'),
(61, 5, 'Sypan', 'Forward', NULL, '2025-06-11 08:40:21', '2025-06-11 08:40:21'),
(62, 5, 'Obia', 'Defender', NULL, '2025-06-11 08:40:40', '2025-06-11 08:40:40'),
(63, 5, 'Alkham', 'Forward', NULL, '2025-06-11 08:41:01', '2025-06-11 08:41:01'),
(64, 5, 'Amane', 'Midfielder', NULL, '2025-06-11 08:41:22', '2025-06-11 08:41:22'),
(65, 5, 'Montez', 'Midfielder', NULL, '2025-06-11 08:41:48', '2025-06-11 08:41:48'),
(66, 5, 'Owen', 'Midfielder', NULL, '2025-06-11 08:42:10', '2025-06-11 08:42:10'),
(67, 5, 'Offman', 'Defender', NULL, '2025-06-11 08:42:27', '2025-06-11 08:42:27'),
(68, 5, 'Kabenge', 'Midfielder', NULL, '2025-06-11 08:42:51', '2025-06-11 08:42:51');

-- --------------------------------------------------------

--
-- Table structure for table `player_statistics`
--

CREATE TABLE `player_statistics` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `season` varchar(9) NOT NULL,
  `appearances` int(11) DEFAULT 0,
  `goals` int(11) DEFAULT 0,
  `assists` int(11) DEFAULT 0,
  `yellow_cards` int(11) DEFAULT 0,
  `red_cards` int(11) DEFAULT 0,
  `clean_sheets` int(11) DEFAULT 0,
  `saves` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `player_statistics`
--

INSERT INTO `player_statistics` (`id`, `player_id`, `season`, `appearances`, `goals`, `assists`, `yellow_cards`, `red_cards`, `clean_sheets`, `saves`, `created_at`, `updated_at`) VALUES
(1, 2, '2025', 3, 5, 5, 0, 1, 0, 0, '2025-06-09 11:13:55', '2025-06-14 10:36:29'),
(4, 4, '2025', 3, 14, 3, 0, 0, 0, 0, '2025-06-10 06:49:40', '2025-06-16 07:46:41'),
(7, 46, '2025', 3, 7, 1, 0, 0, 0, 0, '2025-06-10 06:49:40', '2025-06-16 07:42:17'),
(8, 49, '2025', 3, 1, 4, 0, 0, 0, 0, '2025-06-10 07:31:16', '2025-06-16 05:26:36'),
(9, 50, '2025', 3, 6, 2, 0, 0, 0, 0, '2025-06-10 07:31:49', '2025-06-16 10:44:02'),
(10, 9, '2025', 3, 4, 3, 0, 0, 0, 0, '2025-06-10 07:35:12', '2025-06-14 11:37:03'),
(14, 5, '2025', 3, 1, 1, 0, 0, 0, 0, '2025-06-10 07:39:54', '2025-06-10 11:03:47'),
(16, 47, '2025', 3, 2, 1, 0, 0, 0, 0, '2025-06-10 07:39:54', '2025-06-14 11:15:35'),
(17, 45, '2025', 3, 2, 1, 1, 0, 0, 0, '2025-06-10 07:49:05', '2025-06-10 11:59:35'),
(18, 48, '2025', 3, 2, 1, 0, 0, 0, 0, '2025-06-10 07:49:54', '2025-06-10 09:22:35'),
(19, 44, '2025', 3, 2, 3, 0, 0, 0, 0, '2025-06-10 07:50:04', '2025-06-16 10:04:09'),
(20, 36, '2025', 2, 2, 2, 0, 0, 0, 0, '2025-06-10 07:53:29', '2025-06-16 07:40:31'),
(21, 41, '2025', 3, 1, 0, 0, 0, 0, 0, '2025-06-10 07:55:15', '2025-06-10 07:55:15'),
(22, 23, '2025', 2, 3, 2, 0, 0, 0, 0, '2025-06-10 08:00:59', '2025-06-14 11:33:26'),
(23, 22, '2025', 2, 1, 3, 1, 0, 0, 0, '2025-06-10 08:00:59', '2025-06-14 09:19:02'),
(25, 30, '2025', 2, 0, 1, 0, 0, 0, 0, '2025-06-10 08:00:59', '2025-06-17 05:47:22'),
(26, 29, '2025', 2, 4, 2, 1, 0, 0, 0, '2025-06-10 08:00:59', '2025-06-14 09:19:02'),
(34, 20, '2025', 3, 4, 0, 0, 0, 0, 0, '2025-06-10 08:12:26', '2025-06-16 12:13:59'),
(35, 1, '2025', 3, 0, 1, 2, 2, 0, 0, '2025-06-10 08:12:26', '2025-06-16 05:53:11'),
(38, 43, '2025', 2, 1, 2, 0, 0, 0, 0, '2025-06-10 08:33:15', '2025-06-10 11:07:11'),
(41, 52, '2025', 3, 1, 0, 0, 0, 0, 0, '2025-06-10 08:33:15', '2025-06-10 11:05:26'),
(42, 28, '2025', 1, 0, 2, 0, 0, 0, 0, '2025-06-10 08:41:14', '2025-06-14 07:43:31'),
(44, 39, '2025', 2, 3, 5, 0, 0, 0, 0, '2025-06-10 08:41:14', '2025-06-14 09:40:19'),
(45, 40, '2025', 3, 2, 1, 0, 0, 0, 0, '2025-06-10 08:41:14', '2025-06-10 11:03:24'),
(74, 42, '2025', 3, 1, 0, 0, 0, 0, 0, '2025-06-10 09:10:55', '2025-06-10 11:06:20'),
(77, 18, '2025', 1, 7, 0, 0, 0, 0, 0, '2025-06-10 09:20:05', '2025-06-14 11:37:24'),
(108, 25, '2025', 1, 1, 0, 0, 0, 0, 0, '2025-06-10 09:35:47', '2025-06-16 12:15:41'),
(125, 10, '2025', 3, 0, 1, 0, 0, 0, 0, '2025-06-10 10:23:06', '2025-06-10 11:09:40'),
(139, 27, '2025', 2, 0, 1, 0, 0, 0, 0, '2025-06-10 10:28:08', '2025-06-10 11:11:03'),
(157, 21, '2025', 1, 1, 0, 0, 0, 0, 0, '2025-06-10 11:08:04', '2025-06-16 06:30:02'),
(158, 51, '2025', 2, 0, 0, 0, 0, 0, 0, '2025-06-10 11:08:22', '2025-06-17 05:47:22'),
(159, 26, '2025', 1, 0, 0, 0, 0, 0, 0, '2025-06-10 11:08:47', '2025-06-16 09:58:33'),
(160, 24, '2025', 2, 0, 0, 0, 0, 0, 0, '2025-06-10 11:08:59', '2025-06-16 12:13:59'),
(161, 11, '2025', 3, 0, 0, 0, 0, 0, 0, '2025-06-10 11:09:21', '2025-06-10 11:09:21'),
(162, 16, '2025', 3, 0, 0, 0, 0, 0, 0, '2025-06-10 11:09:52', '2025-06-16 07:09:01'),
(163, 19, '2025', 1, 1, 0, 0, 0, 0, 0, '2025-06-10 11:10:02', '2025-06-14 11:36:45'),
(164, 12, '2025', 3, 0, 0, 0, 0, 0, 0, '2025-06-10 11:10:13', '2025-06-10 11:17:00'),
(165, 7, '2025', 1, 0, 0, 0, 0, 0, 0, '2025-06-10 11:10:26', '2025-06-10 11:10:26'),
(166, 17, '2025', 2, 0, 0, 0, 0, 0, 0, '2025-06-10 11:10:39', '2025-06-10 11:10:39'),
(167, 14, '2025', 3, 0, 0, 0, 0, 0, 0, '2025-06-10 11:10:53', '2025-06-10 11:10:53'),
(168, 38, '2025', 3, 0, 0, 1, 0, 0, 0, '2025-06-10 11:12:25', '2025-06-11 07:09:32'),
(169, 32, '2025', 3, 0, 0, 1, 0, 0, 0, '2025-06-10 11:12:50', '2025-06-11 08:00:51'),
(170, 33, '2025', 3, 0, 0, 0, 1, 0, 0, '2025-06-10 11:13:09', '2025-06-10 11:13:09'),
(171, 34, '2025', 2, 0, 0, 0, 0, 0, 0, '2025-06-10 11:13:24', '2025-06-16 12:09:09'),
(172, 31, '2025', 3, 0, 0, 0, 0, 0, 0, '2025-06-10 11:13:42', '2025-06-16 10:32:59'),
(173, 37, '2025', 2, 0, 0, 0, 0, 0, 0, '2025-06-10 11:14:28', '2025-06-10 11:14:28'),
(174, 35, '2025', 3, 0, 0, 0, 0, 0, 0, '2025-06-10 11:14:48', '2025-06-16 10:32:53'),
(175, 15, '2025', 1, 0, 0, 0, 0, 0, 0, '2025-06-10 11:16:09', '2025-06-10 11:16:09'),
(176, 13, '2025', 2, 0, 0, 0, 0, 0, 0, '2025-06-10 11:16:21', '2025-06-10 11:16:21'),
(177, 6, '2025', 3, 0, 0, 0, 0, 0, 0, '2025-06-10 11:16:30', '2025-06-10 11:16:30'),
(178, 8, '2025', 1, 0, 0, 0, 0, 0, 0, '2025-06-10 11:16:42', '2025-06-10 11:16:42'),
(203, 54, '2025', 0, 3, 1, 0, 0, 0, 0, '2025-06-14 08:26:31', '2025-06-14 11:13:16'),
(204, 57, '2025', 0, 0, 0, 1, 0, 0, 0, '2025-06-14 08:30:49', '2025-06-14 08:30:49'),
(219, 67, '2025', 0, 0, 1, 0, 0, 0, 0, '2025-06-14 10:05:44', '2025-06-14 10:05:44'),
(225, 55, '2025', 0, 1, 0, 0, 0, 0, 0, '2025-06-14 11:13:16', '2025-06-14 11:13:16'),
(229, 63, '2025', 0, 1, 0, 0, 0, 0, 0, '2025-06-14 11:23:16', '2025-06-14 11:23:16'),
(230, 53, '2025', 0, 0, 1, 0, 0, 0, 0, '2025-06-14 11:23:16', '2025-06-14 11:23:16'),
(241, 56, '2025', 0, 0, 0, 0, 0, 0, 0, '2025-06-16 05:56:20', '2025-06-16 05:57:07'),
(251, 60, '2025', 0, 0, 0, 0, 0, 0, 0, '2025-06-16 10:35:47', '2025-06-16 10:43:45'),
(253, 61, '2025', 0, 0, 0, 0, 0, 0, 0, '2025-06-16 11:15:40', '2025-06-16 11:26:15');

-- --------------------------------------------------------

--
-- Table structure for table `standings`
--

CREATE TABLE `standings` (
  `id` int(11) NOT NULL,
  `team_id` int(11) NOT NULL,
  `season` varchar(9) NOT NULL,
  `played` int(11) DEFAULT 0,
  `won` int(11) DEFAULT 0,
  `drawn` int(11) DEFAULT 0,
  `lost` int(11) DEFAULT 0,
  `goals_for` int(11) DEFAULT 0,
  `goals_against` int(11) DEFAULT 0,
  `points` int(11) DEFAULT 0,
  `position` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `standings`
--

INSERT INTO `standings` (`id`, `team_id`, `season`, `played`, `won`, `drawn`, `lost`, `goals_for`, `goals_against`, `points`, `position`, `created_at`, `updated_at`) VALUES
(1, 1, '2025', 14, 7, 3, 4, 30, 21, 24, 2, '2025-06-09 11:21:54', '2025-06-17 05:47:22'),
(2, 5, '2025', 8, 2, 1, 5, 6, 13, 7, 5, '2025-06-09 11:21:54', '2025-06-16 12:13:59'),
(3, 3, '2025', 14, 5, 3, 6, 24, 27, 18, 3, '2025-06-09 11:28:58', '2025-06-17 05:47:22'),
(4, 2, '2025', 14, 8, 1, 5, 28, 22, 25, 1, '2025-06-10 06:01:23', '2025-06-16 12:17:20'),
(8, 4, '2025', 11, 4, 3, 4, 14, 14, 15, 4, '2025-06-10 06:34:35', '2025-06-17 05:47:22');

-- --------------------------------------------------------

--
-- Table structure for table `teams`
--

CREATE TABLE `teams` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `short_name` varchar(10) DEFAULT NULL,
  `logo_filename` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `teams`
--

INSERT INTO `teams` (`id`, `name`, `short_name`, `logo_filename`, `created_at`, `updated_at`) VALUES
(1, 'End Career FC', 'EFC', 'logo_6846b51a3b8ff8.86866853.png', '2025-06-09 09:01:20', '2025-06-09 10:19:06'),
(2, 'Lefters CF', 'LCF', 'logo_6846b506c9c569.44807671.png', '2025-06-09 09:01:20', '2025-06-09 10:18:46'),
(3, 'The Shield', 'SHI', 'logo_6846b544e67501.76517578.png', '2025-06-09 09:01:20', '2025-06-09 10:19:48'),
(4, 'Galacticos', 'GAL', 'logo_6846b526a8b1d5.41411328.png', '2025-06-09 09:01:20', '2025-06-09 10:19:18'),
(5, 'La Familia', 'LAF', 'logo_6846b538da2367.37461467.png', '2025-06-09 09:01:20', '2025-06-09 10:19:36');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin_users`
--
ALTER TABLE `admin_users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_admin_username` (`username`);

--
-- Indexes for table `images`
--
ALTER TABLE `images`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `matches`
--
ALTER TABLE `matches`
  ADD PRIMARY KEY (`id`),
  ADD KEY `home_team_id` (`home_team_id`),
  ADD KEY `away_team_id` (`away_team_id`);

--
-- Indexes for table `match_events`
--
ALTER TABLE `match_events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `match_id` (`match_id`),
  ADD KEY `player_id` (`player_id`),
  ADD KEY `fk_assist_player` (`assist_player_id`);

--
-- Indexes for table `match_statistics_tracking`
--
ALTER TABLE `match_statistics_tracking`
  ADD PRIMARY KEY (`match_id`);

--
-- Indexes for table `players`
--
ALTER TABLE `players`
  ADD PRIMARY KEY (`id`),
  ADD KEY `team_id` (`team_id`);

--
-- Indexes for table `player_statistics`
--
ALTER TABLE `player_statistics`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_player_season` (`player_id`,`season`);

--
-- Indexes for table `standings`
--
ALTER TABLE `standings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_team_season` (`team_id`,`season`);

--
-- Indexes for table `teams`
--
ALTER TABLE `teams`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin_users`
--
ALTER TABLE `admin_users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `images`
--
ALTER TABLE `images`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `matches`
--
ALTER TABLE `matches`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=65;

--
-- AUTO_INCREMENT for table `match_events`
--
ALTER TABLE `match_events`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=217;

--
-- AUTO_INCREMENT for table `players`
--
ALTER TABLE `players`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=69;

--
-- AUTO_INCREMENT for table `player_statistics`
--
ALTER TABLE `player_statistics`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=263;

--
-- AUTO_INCREMENT for table `standings`
--
ALTER TABLE `standings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=125;

--
-- AUTO_INCREMENT for table `teams`
--
ALTER TABLE `teams`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `matches`
--
ALTER TABLE `matches`
  ADD CONSTRAINT `matches_ibfk_1` FOREIGN KEY (`home_team_id`) REFERENCES `teams` (`id`),
  ADD CONSTRAINT `matches_ibfk_2` FOREIGN KEY (`away_team_id`) REFERENCES `teams` (`id`);

--
-- Constraints for table `match_events`
--
ALTER TABLE `match_events`
  ADD CONSTRAINT `fk_assist_player` FOREIGN KEY (`assist_player_id`) REFERENCES `players` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `match_events_ibfk_1` FOREIGN KEY (`match_id`) REFERENCES `matches` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `match_events_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`);

--
-- Constraints for table `match_statistics_tracking`
--
ALTER TABLE `match_statistics_tracking`
  ADD CONSTRAINT `match_statistics_tracking_ibfk_1` FOREIGN KEY (`match_id`) REFERENCES `matches` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `players`
--
ALTER TABLE `players`
  ADD CONSTRAINT `players_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `player_statistics`
--
ALTER TABLE `player_statistics`
  ADD CONSTRAINT `player_statistics_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `standings`
--
ALTER TABLE `standings`
  ADD CONSTRAINT `standings_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE;
--
-- Database: `footy_backup`
--
CREATE DATABASE IF NOT EXISTS `footy_backup` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `footy_backup`;

-- --------------------------------------------------------

--
-- Table structure for table `admin_users`
--

CREATE TABLE `admin_users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `is_super_admin` tinyint(1) DEFAULT 0,
  `last_login` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin_users`
--

INSERT INTO `admin_users` (`id`, `username`, `password_hash`, `email`, `full_name`, `is_super_admin`, `last_login`, `created_at`, `updated_at`) VALUES
(1, 'admin', '$2y$10$o0nqBlC2wqIJHCNHhKMRjekzoeqQKJuDw6HXnpAeipZjRGdB8d1g2', 'garethneville3@gmail.com', 'Gareth Neville Kisuze', 1, '2026-03-04 12:40:28', '2025-06-13 07:32:00', '2026-03-04 09:40:28');

-- --------------------------------------------------------

--
-- Table structure for table `images`
--

CREATE TABLE `images` (
  `id` int(11) NOT NULL,
  `type` enum('goal','assist','table_standings') NOT NULL,
  `filename` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `season` varchar(9) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
<div class="alert alert-danger" role="alert"><h1>Error</h1><p><strong>SQL query:</strong>  <a href="#" class="copyQueryBtn" data-text="SET SQL_QUOTE_SHOW_CREATE = 1">Copy</a>
<a href="index.php?route=/server/sql&sql_query=SET+SQL_QUOTE_SHOW_CREATE+%3D+1&show_query=1"><span class="text-nowrap"><img src="themes/dot.gif" title="Edit" alt="Edit" class="icon ic_b_edit">&nbsp;Edit</span></a>    </p>
<p>
<code class="sql"><pre>
SET SQL_QUOTE_SHOW_CREATE = 1
</pre></code>
</p>
<p>
    <strong>MySQL said: </strong><a href="./url.php?url=https%3A%2F%2Fdev.mysql.com%2Fdoc%2Frefman%2F8.0%2Fen%2Fserver-error-reference.html" target="mysql_doc"><img src="themes/dot.gif" title="Documentation" alt="Documentation" class="icon ic_b_help"></a>
</p>
<code>#2006 - MySQL server has gone away</code><br></div>
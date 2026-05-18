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

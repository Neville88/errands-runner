CREATE DATABASE IF NOT EXISTS errands_runner CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE errands_runner;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS request_status_logs;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS notifications;
DROP TABLE IF EXISTS runner_reviews;
DROP TABLE IF EXISTS assignments;
DROP TABLE IF EXISTS quotations;
DROP TABLE IF EXISTS request_items;
DROP TABLE IF EXISTS requests;
DROP TABLE IF EXISTS contact_messages;
DROP TABLE IF EXISTS profiles;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS roles;

CREATE TABLE roles (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    role_key VARCHAR(30) NOT NULL UNIQUE,
    role_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE users (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    role_id INT UNSIGNED NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(50) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    last_login_at TIMESTAMP NULL DEFAULT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_users_role FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE RESTRICT,
    INDEX idx_users_role (role_id),
    INDEX idx_users_active (is_active)
) ENGINE=InnoDB;

CREATE TABLE profiles (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNSIGNED NOT NULL UNIQUE,
    profile_image VARCHAR(255) NULL,
    address_line VARCHAR(255) NULL,
    city VARCHAR(120) NULL,
    state_region VARCHAR(120) NULL,
    postal_code VARCHAR(40) NULL,
    bio TEXT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_profiles_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE contact_messages (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL,
    phone VARCHAR(50) NULL,
    subject VARCHAR(180) NOT NULL,
    message TEXT NOT NULL,
    status ENUM('new', 'reviewed', 'closed') NOT NULL DEFAULT 'new',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_contact_messages_status (status)
) ENGINE=InnoDB;

CREATE TABLE requests (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    requester_id INT UNSIGNED NOT NULL,
    requester_role_key VARCHAR(30) NOT NULL,
    request_type ENUM('delivery_request', 'item_purchase_request', 'pickup_dropoff_errand', 'custom_errand') NOT NULL,
    title VARCHAR(180) NOT NULL,
    description TEXT NOT NULL,
    pickup_location VARCHAR(255) NOT NULL,
    destination VARCHAR(255) NOT NULL,
    budget_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    quoted_amount DECIMAL(12,2) NULL,
    payment_method ENUM('cash_on_delivery', 'bank_transfer', 'wallet', 'manual_record') NOT NULL DEFAULT 'cash_on_delivery',
    recipient_name VARCHAR(150) NOT NULL,
    recipient_phone VARCHAR(50) NOT NULL,
    delivery_window VARCHAR(120) NULL,
    special_instructions TEXT NULL,
    status ENUM('open', 'quoted', 'assigned', 'in_progress', 'completed', 'confirmed', 'cancelled') NOT NULL DEFAULT 'open',
    visibility_status ENUM('public', 'hidden') NOT NULL DEFAULT 'public',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_requests_requester FOREIGN KEY (requester_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_requests_requester (requester_id),
    INDEX idx_requests_status (status),
    INDEX idx_requests_type (request_type),
    INDEX idx_requests_visibility (visibility_status)
) ENGINE=InnoDB;

CREATE TABLE request_items (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    request_id INT UNSIGNED NOT NULL,
    item_name VARCHAR(180) NOT NULL,
    item_description TEXT NULL,
    quantity INT UNSIGNED NOT NULL DEFAULT 1,
    estimated_unit_price DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    image_path VARCHAR(255) NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_request_items_request FOREIGN KEY (request_id) REFERENCES requests(id) ON DELETE CASCADE,
    INDEX idx_request_items_request (request_id)
) ENGINE=InnoDB;

CREATE TABLE request_item_samples (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    request_id INT UNSIGNED NOT NULL,
    runner_id INT UNSIGNED NOT NULL,
    image_path VARCHAR(255) NOT NULL,
    caption VARCHAR(255) NULL,
    price_estimate DECIMAL(12,2) NULL,
    is_selected TINYINT(1) NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_request_item_samples_request FOREIGN KEY (request_id) REFERENCES requests(id) ON DELETE CASCADE,
    CONSTRAINT fk_request_item_samples_runner FOREIGN KEY (runner_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_request_item_samples_request (request_id),
    INDEX idx_request_item_samples_runner (runner_id),
    INDEX idx_request_item_samples_selected (is_selected)
) ENGINE=InnoDB;

CREATE TABLE quotations (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    request_id INT UNSIGNED NOT NULL,
    runner_id INT UNSIGNED NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    note TEXT NULL,
    status ENUM('pending', 'approved', 'rejected') NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_quotations_request FOREIGN KEY (request_id) REFERENCES requests(id) ON DELETE CASCADE,
    CONSTRAINT fk_quotations_runner FOREIGN KEY (runner_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_quotations_request (request_id),
    INDEX idx_quotations_runner (runner_id),
    INDEX idx_quotations_status (status)
) ENGINE=InnoDB;

CREATE TABLE assignments (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    request_id INT UNSIGNED NOT NULL UNIQUE,
    runner_id INT UNSIGNED NOT NULL,
    quotation_id INT UNSIGNED NULL,
    status ENUM('assigned', 'in_progress', 'completed', 'confirmed', 'cancelled') NOT NULL DEFAULT 'assigned',
    accepted_at TIMESTAMP NULL DEFAULT NULL,
    started_at TIMESTAMP NULL DEFAULT NULL,
    completed_at TIMESTAMP NULL DEFAULT NULL,
    confirmed_at TIMESTAMP NULL DEFAULT NULL,
    proof_image_path VARCHAR(255) NULL,
    proof_note TEXT NULL,
    current_lat DECIMAL(10,7) NULL,
    current_lng DECIMAL(10,7) NULL,
    last_location_at TIMESTAMP NULL DEFAULT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_assignments_request FOREIGN KEY (request_id) REFERENCES requests(id) ON DELETE CASCADE,
    CONSTRAINT fk_assignments_runner FOREIGN KEY (runner_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_assignments_quotation FOREIGN KEY (quotation_id) REFERENCES quotations(id) ON DELETE SET NULL,
    INDEX idx_assignments_runner (runner_id),
    INDEX idx_assignments_location (current_lat, current_lng),
    INDEX idx_assignments_status (status)
) ENGINE=InnoDB;

CREATE TABLE runner_reviews (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    request_id INT UNSIGNED NOT NULL UNIQUE,
    reviewer_id INT UNSIGNED NOT NULL,
    runner_id INT UNSIGNED NOT NULL,
    rating TINYINT UNSIGNED NOT NULL,
    review_text TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_runner_reviews_request FOREIGN KEY (request_id) REFERENCES requests(id) ON DELETE CASCADE,
    CONSTRAINT fk_runner_reviews_reviewer FOREIGN KEY (reviewer_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_runner_reviews_runner FOREIGN KEY (runner_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT chk_runner_reviews_rating CHECK (rating BETWEEN 1 AND 5),
    INDEX idx_runner_reviews_runner (runner_id),
    INDEX idx_runner_reviews_reviewer (reviewer_id)
) ENGINE=InnoDB;

CREATE TABLE notifications (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNSIGNED NOT NULL,
    title VARCHAR(180) NOT NULL,
    message TEXT NOT NULL,
    link_url VARCHAR(255) NULL,
    is_read TINYINT(1) NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_notifications_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_notifications_user (user_id),
    INDEX idx_notifications_read (is_read)
) ENGINE=InnoDB;

CREATE TABLE transactions (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    request_id INT UNSIGNED NOT NULL,
    payer_id INT UNSIGNED NOT NULL,
    payee_id INT UNSIGNED NULL,
    amount DECIMAL(12,2) NOT NULL,
    payment_method ENUM('cash_on_delivery', 'bank_transfer', 'wallet', 'manual_record') NOT NULL DEFAULT 'manual_record',
    payment_status ENUM('pending', 'processing', 'paid', 'cancelled') NOT NULL DEFAULT 'pending',
    transaction_reference VARCHAR(80) NOT NULL UNIQUE,
    notes TEXT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_transactions_request FOREIGN KEY (request_id) REFERENCES requests(id) ON DELETE CASCADE,
    CONSTRAINT fk_transactions_payer FOREIGN KEY (payer_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_transactions_payee FOREIGN KEY (payee_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_transactions_status (payment_status),
    INDEX idx_transactions_payer (payer_id),
    INDEX idx_transactions_payee (payee_id)
) ENGINE=InnoDB;

CREATE TABLE request_status_logs (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    request_id INT UNSIGNED NOT NULL,
    actor_id INT UNSIGNED NULL,
    status ENUM('open', 'quoted', 'assigned', 'in_progress', 'completed', 'confirmed', 'cancelled') NOT NULL,
    note TEXT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_request_status_logs_request FOREIGN KEY (request_id) REFERENCES requests(id) ON DELETE CASCADE,
    CONSTRAINT fk_request_status_logs_actor FOREIGN KEY (actor_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_request_status_logs_request (request_id)
) ENGINE=InnoDB;

INSERT INTO roles (role_key, role_name) VALUES
('seller', 'Seller'),
('buyer', 'Buyer / Customer'),
('runner', 'Runner / Delivery Agent'),
('admin', 'Administrator');

INSERT INTO users (role_id, full_name, email, phone, password_hash, is_active) VALUES
((SELECT id FROM roles WHERE role_key = 'admin'), 'Ssekiziyivu Denison', 'ssekiziyivudenison19@gmail.com', '+256706888958', '$2y$10$Gkx5wBHl1Udkob/AY70igeQgz.7cwFJ5GpZlHxyawHXOOrnWOCiN2', 1),
((SELECT id FROM roles WHERE role_key = 'seller'), 'Moses Kibirige', 'moses.kibirige@errandsrunner.test', '+256701110221', '$2y$10$Gkx5wBHl1Udkob/AY70igeQgz.7cwFJ5GpZlHxyawHXOOrnWOCiN2', 1),
((SELECT id FROM roles WHERE role_key = 'seller'), 'Irene Nakato', 'irene.nakato@errandsrunner.test', '+256701220332', '$2y$10$Gkx5wBHl1Udkob/AY70igeQgz.7cwFJ5GpZlHxyawHXOOrnWOCiN2', 1),
((SELECT id FROM roles WHERE role_key = 'buyer'), 'Sarah Nansubuga', 'sarah.nansubuga@errandsrunner.test', '+256702110223', '$2y$10$Gkx5wBHl1Udkob/AY70igeQgz.7cwFJ5GpZlHxyawHXOOrnWOCiN2', 1),
((SELECT id FROM roles WHERE role_key = 'buyer'), 'Joel Ssentamu', 'joel.ssentamu@errandsrunner.test', '+256702220334', '$2y$10$Gkx5wBHl1Udkob/AY70igeQgz.7cwFJ5GpZlHxyawHXOOrnWOCiN2', 1),
((SELECT id FROM roles WHERE role_key = 'buyer'), 'Patricia Namara', 'patricia.namara@errandsrunner.test', '+256702330445', '$2y$10$Gkx5wBHl1Udkob/AY70igeQgz.7cwFJ5GpZlHxyawHXOOrnWOCiN2', 1),
((SELECT id FROM roles WHERE role_key = 'runner'), 'Peter Walusimbi', 'peter.walusimbi@errandsrunner.test', '+256703110226', '$2y$10$Gkx5wBHl1Udkob/AY70igeQgz.7cwFJ5GpZlHxyawHXOOrnWOCiN2', 1),
((SELECT id FROM roles WHERE role_key = 'runner'), 'Samuel Kato', 'samuel.kato@errandsrunner.test', '+256704110221', '$2y$10$Gkx5wBHl1Udkob/AY70igeQgz.7cwFJ5GpZlHxyawHXOOrnWOCiN2', 1),
((SELECT id FROM roles WHERE role_key = 'runner'), 'Daniel Mugerwa', 'daniel.mugerwa@errandsrunner.test', '+256704220331', '$2y$10$Gkx5wBHl1Udkob/AY70igeQgz.7cwFJ5GpZlHxyawHXOOrnWOCiN2', 1),
((SELECT id FROM roles WHERE role_key = 'runner'), 'Brian Ssemanda', 'brian.ssemanda@errandsrunner.test', '+256704330441', '$2y$10$Gkx5wBHl1Udkob/AY70igeQgz.7cwFJ5GpZlHxyawHXOOrnWOCiN2', 1),
((SELECT id FROM roles WHERE role_key = 'runner'), 'Ruth Nankya', 'ruth.nankya@errandsrunner.test', '+256703550662', '$2y$10$Gkx5wBHl1Udkob/AY70igeQgz.7cwFJ5GpZlHxyawHXOOrnWOCiN2', 1);

INSERT INTO profiles (user_id, city, state_region, bio) VALUES
((SELECT id FROM users WHERE email = 'ssekiziyivudenison19@gmail.com'), 'Kampala', 'Central Region', 'Operations lead overseeing user support, request quality, and delivery standards across the platform.'),
((SELECT id FROM users WHERE email = 'moses.kibirige@errandsrunner.test'), 'Mbarara', 'Western Region', 'Owner of a wholesale beverages and pantry supplies business serving retail shops and small events.'),
((SELECT id FROM users WHERE email = 'irene.nakato@errandsrunner.test'), 'Kampala', 'Central Region', 'Runs a boutique and beauty retail shop that depends on careful same-day customer deliveries.'),
((SELECT id FROM users WHERE email = 'sarah.nansubuga@errandsrunner.test'), 'Kampala', 'Central Region', 'Busy working parent who uses the platform for home shopping, cake pickups, and planned family errands.'),
((SELECT id FROM users WHERE email = 'joel.ssentamu@errandsrunner.test'), 'Kampala', 'Central Region', 'Finance officer who books pharmacy and device accessory pickups during work hours.'),
((SELECT id FROM users WHERE email = 'patricia.namara@errandsrunner.test'), 'Kampala', 'Central Region', 'Office administrator coordinating branch documents, signed files, and internal parcel movement.'),
((SELECT id FROM users WHERE email = 'peter.walusimbi@errandsrunner.test'), 'Entebbe', 'Central Region', 'Steady boda rider trusted for same-day parcel handoffs, short-notice town runs, and careful retail deliveries.'),
((SELECT id FROM users WHERE email = 'samuel.kato@errandsrunner.test'), 'Kampala', 'Central Region', 'Fast boda runner trusted for market pickups and same-day town deliveries.'),
((SELECT id FROM users WHERE email = 'daniel.mugerwa@errandsrunner.test'), 'Wakiso', 'Central Region', 'Dependable dispatch rider known for careful package handling, clean handoffs, and strong customer communication.'),
((SELECT id FROM users WHERE email = 'brian.ssemanda@errandsrunner.test'), 'Mukono', 'Central Region', 'Reliable errands specialist for office runs, grocery sourcing, and customer drop-offs.'),
((SELECT id FROM users WHERE email = 'ruth.nankya@errandsrunner.test'), 'Wakiso', 'Central Region', 'Known for event sourcing, bakery pickups, and clear communication with customers and vendors.');

UPDATE profiles SET profile_image = 'profiles/samuel-kato.png' WHERE user_id = (SELECT id FROM users WHERE email = 'samuel.kato@errandsrunner.test');
UPDATE profiles SET profile_image = 'profiles/daniel-mugerwa.png' WHERE user_id = (SELECT id FROM users WHERE email = 'daniel.mugerwa@errandsrunner.test');
UPDATE profiles SET profile_image = 'profiles/brian-ssemanda.png' WHERE user_id = (SELECT id FROM users WHERE email = 'brian.ssemanda@errandsrunner.test');

INSERT INTO requests (requester_id, requester_role_key, request_type, title, description, pickup_location, destination, budget_amount, quoted_amount, payment_method, recipient_name, recipient_phone, delivery_window, special_instructions, status, visibility_status) VALUES
((SELECT id FROM users WHERE email = 'moses.kibirige@errandsrunner.test'), 'seller', 'delivery_request', 'Deliver beverage cartons to Lydia Mini Mart', 'Deliver two beverage cartons to Lydia Mini Mart before the evening rush and confirm handoff with the cashier on site.', 'Nakasero Market, Kampala', 'Ntinda, Kampala', 45000.00, 45000.00, 'cash_on_delivery', 'Lydia Namazzi', '+256705555555', 'Today 3pm - 6pm', 'Keep cartons upright and call the shop assistant on approach.', 'assigned', 'public'),
((SELECT id FROM users WHERE email = 'sarah.nansubuga@errandsrunner.test'), 'buyer', 'item_purchase_request', 'Source groceries for the Nansubuga family', 'Buy rice, cooking oil, tomatoes, onions, and seasoning from a trusted market stall and deliver them home before lunch.', 'Owino Market, Kampala', 'Naalya, Kampala', 92000.00, NULL, 'bank_transfer', 'Sarah Nansubuga', '+256702110223', 'Tomorrow morning', 'Send a quick update if tomato prices are much higher than expected.', 'quoted', 'public'),
((SELECT id FROM users WHERE email = 'joel.ssentamu@errandsrunner.test'), 'buyer', 'custom_errand', 'Pick up paid pharmacy order for Grace Namuli', 'Collect a fully paid pharmacy package and deliver it safely to the family residence with care instructions followed.', 'Acacia Mall Pharmacy, Kampala', 'Kololo, Kampala', 32000.00, 32000.00, 'bank_transfer', 'Grace Namuli', '+256707111222', 'Yesterday afternoon', 'Medicine should stay upright and dry during transport.', 'confirmed', 'public'),
((SELECT id FROM users WHERE email = 'irene.nakato@errandsrunner.test'), 'seller', 'delivery_request', 'Same-day boutique parcel drop to Najjera', 'A customer parcel with dresses and skincare items needs a careful same-day delivery and a call before arrival.', 'Arena Mall, Kampala', 'Najjera, Wakiso', 28000.00, 28000.00, 'cash_on_delivery', 'Fiona Katusiime', '+256707333444', 'Yesterday 1pm - 4pm', 'Customer requested a call 10 minutes before arrival.', 'confirmed', 'public'),
((SELECT id FROM users WHERE email = 'patricia.namara@errandsrunner.test'), 'buyer', 'pickup_dropoff_errand', 'Office document pickup for Bugolobi branch', 'Collect signed contract files from town and deliver them to the Bugolobi branch office without bending or opening the envelope.', 'NSSF Building, Kampala Road', 'Bugolobi, Kampala', 40000.00, 40000.00, 'manual_record', 'Harriet Nakafeero', '+256707555666', 'This morning', 'Keep envelope sealed and undamaged.', 'confirmed', 'public'),
((SELECT id FROM users WHERE email = 'sarah.nansubuga@errandsrunner.test'), 'buyer', 'item_purchase_request', 'Source birthday cake and party supplies', 'Buy a medium vanilla birthday cake, candles, paper plates, and juice for a family gathering this afternoon.', 'Capital Shoppers, Ntinda', 'Kisaasi, Kampala', 118000.00, 116000.00, 'bank_transfer', 'Sarah Nansubuga', '+256702110223', 'Today 1pm - 4pm', 'Cake should be written with "Happy Birthday Auntie Mary".', 'in_progress', 'public'),
((SELECT id FROM users WHERE email = 'moses.kibirige@errandsrunner.test'), 'seller', 'delivery_request', 'Deliver catering supplies to UMA conference venue', 'Move sealed catering supplies from the store to the conference venue and hand over to the event coordinator before setup begins.', 'Nakawa Industrial Area, Kampala', 'UMA Show Grounds, Lugogo', 67000.00, 67000.00, 'cash_on_delivery', 'Mildred Nassozi', '+256705888999', 'Today 9am - 12pm', 'Check item count with the coordinator before leaving.', 'in_progress', 'public'),
((SELECT id FROM users WHERE email = 'joel.ssentamu@errandsrunner.test'), 'buyer', 'custom_errand', 'Pick up laptop charger from Village Mall', 'Pick up a reserved laptop charger from the electronics shop and bring it to the office before close of business.', 'Village Mall, Bugolobi', 'Kololo, Kampala', 35000.00, NULL, 'wallet', 'Joel Ssentamu', '+256702220334', 'Today before 5pm', 'Request the shop receipt and keep the box clean.', 'open', 'public'),
((SELECT id FROM users WHERE email = 'irene.nakato@errandsrunner.test'), 'seller', 'delivery_request', 'Restock salon products from Kikuubo supplier', 'Collect a prepared salon restock from the supplier and return it to the shop before customer traffic increases.', 'Kikuubo, Kampala', 'Kansanga, Kampala', 54000.00, NULL, 'manual_record', 'Irene Nakato', '+256701220332', 'Tomorrow 10am - 1pm', 'Supplier will release stock after phone confirmation.', 'open', 'public');

INSERT INTO request_items (request_id, item_name, item_description, quantity, estimated_unit_price) VALUES
((SELECT id FROM requests WHERE title = 'Deliver beverage cartons to Lydia Mini Mart'), 'Beverage Cartons', 'Two sealed cartons packed for retail shelf delivery.', 2, 22500.00),
((SELECT id FROM requests WHERE title = 'Source groceries for the Nansubuga family'), 'Weekly Groceries', 'Rice, cooking oil, tomatoes, onions, and seasoning from a reliable market stall.', 1, 92000.00),
((SELECT id FROM requests WHERE title = 'Pick up paid pharmacy order for Grace Namuli'), 'Pharmacy Package', 'Already paid package with medicine and vitamins.', 1, 32000.00),
((SELECT id FROM requests WHERE title = 'Same-day boutique parcel drop to Najjera'), 'Boutique Parcel', 'Fashion parcel wrapped for customer delivery.', 1, 28000.00),
((SELECT id FROM requests WHERE title = 'Office document pickup for Bugolobi branch'), 'Contract Documents', 'Signed documents for internal branch processing.', 1, 40000.00),
((SELECT id FROM requests WHERE title = 'Source birthday cake and party supplies'), 'Cake and Party Supplies', 'Vanilla cake, candles, plates, tissue, and bottled juice.', 1, 118000.00),
((SELECT id FROM requests WHERE title = 'Deliver catering supplies to UMA conference venue'), 'Catering Supplies', 'Disposable trays, drinks, napkins, and serving items for an event setup.', 6, 11166.67),
((SELECT id FROM requests WHERE title = 'Pick up laptop charger from Village Mall'), 'Laptop Charger', 'Reserved original charger from the electronics store.', 1, 35000.00),
((SELECT id FROM requests WHERE title = 'Restock salon products from Kikuubo supplier'), 'Salon Restock', 'Hair food, body lotion, and related salon products packed by the supplier.', 1, 54000.00);

INSERT INTO quotations (request_id, runner_id, amount, note, status) VALUES
((SELECT id FROM requests WHERE title = 'Source groceries for the Nansubuga family'), (SELECT id FROM users WHERE email = 'peter.walusimbi@errandsrunner.test'), 98000.00, 'I can source everything early in the morning and send pricing updates before purchase.', 'pending'),
((SELECT id FROM requests WHERE title = 'Source groceries for the Nansubuga family'), (SELECT id FROM users WHERE email = 'daniel.mugerwa@errandsrunner.test'), 96000.00, 'Available from 8am and can deliver before lunch with item photos if needed.', 'pending'),
((SELECT id FROM requests WHERE title = 'Source groceries for the Nansubuga family'), (SELECT id FROM users WHERE email = 'ruth.nankya@errandsrunner.test'), 94500.00, 'I know a reliable stall in Owino and can confirm fresh produce before buying.', 'pending'),
((SELECT id FROM requests WHERE title = 'Source birthday cake and party supplies'), (SELECT id FROM users WHERE email = 'ruth.nankya@errandsrunner.test'), 116000.00, 'I can handle the bakery pickup, candles, and juice in one coordinated trip this afternoon.', 'approved'),
((SELECT id FROM requests WHERE title = 'Source birthday cake and party supplies'), (SELECT id FROM users WHERE email = 'samuel.kato@errandsrunner.test'), 121000.00, 'Available after midday with fast delivery, though bakery queue times may affect timing.', 'rejected');

INSERT INTO assignments (request_id, runner_id, quotation_id, status, accepted_at, started_at, completed_at, confirmed_at, proof_note) VALUES
((SELECT id FROM requests WHERE title = 'Deliver beverage cartons to Lydia Mini Mart'), (SELECT id FROM users WHERE email = 'peter.walusimbi@errandsrunner.test'), NULL, 'assigned', NOW(), NULL, NULL, NULL, NULL),
((SELECT id FROM requests WHERE title = 'Pick up paid pharmacy order for Grace Namuli'), (SELECT id FROM users WHERE email = 'samuel.kato@errandsrunner.test'), NULL, 'confirmed', NOW(), NOW(), NOW(), NOW(), 'Package handed over to Grace Namuli in person and delivery confirmed by phone.'),
((SELECT id FROM requests WHERE title = 'Same-day boutique parcel drop to Najjera'), (SELECT id FROM users WHERE email = 'daniel.mugerwa@errandsrunner.test'), NULL, 'confirmed', NOW(), NOW(), NOW(), NOW(), 'Customer received parcel in good condition and confirmed by call.'),
((SELECT id FROM requests WHERE title = 'Office document pickup for Bugolobi branch'), (SELECT id FROM users WHERE email = 'brian.ssemanda@errandsrunner.test'), NULL, 'confirmed', NOW(), NOW(), NOW(), NOW(), 'Envelope delivered sealed to the branch administrator.'),
((SELECT id FROM requests WHERE title = 'Source birthday cake and party supplies'), (SELECT id FROM users WHERE email = 'ruth.nankya@errandsrunner.test'), (SELECT id FROM quotations WHERE request_id = (SELECT id FROM requests WHERE title = 'Source birthday cake and party supplies') AND runner_id = (SELECT id FROM users WHERE email = 'ruth.nankya@errandsrunner.test') LIMIT 1), 'in_progress', NOW(), NOW(), NULL, NULL, 'Bakery pickup confirmed and store run underway.'),
((SELECT id FROM requests WHERE title = 'Deliver catering supplies to UMA conference venue'), (SELECT id FROM users WHERE email = 'samuel.kato@errandsrunner.test'), NULL, 'in_progress', NOW(), NOW(), NULL, NULL, 'Supplies loaded and en route to the venue.');

INSERT INTO notifications (user_id, title, message, link_url) VALUES
((SELECT id FROM users WHERE email = 'ssekiziyivudenison19@gmail.com'), 'Platform initialized', 'Named starter accounts and realistic operational data have been inserted into the errands runner database.', 'pages/admin-dashboard.php'),
((SELECT id FROM users WHERE email = 'moses.kibirige@errandsrunner.test'), 'Runner assigned', 'Peter Walusimbi has been assigned to deliver beverage cartons to Lydia Mini Mart.', 'pages/request-details.php?id=1'),
((SELECT id FROM users WHERE email = 'sarah.nansubuga@errandsrunner.test'), 'New quotations received', 'Three runners submitted quotations for your grocery sourcing errand.', 'pages/quotations.php'),
((SELECT id FROM users WHERE email = 'ruth.nankya@errandsrunner.test'), 'Quotation approved', 'Your quotation for the birthday cake and party supplies errand was approved.', 'pages/request-details.php?id=6'),
((SELECT id FROM users WHERE email = 'joel.ssentamu@errandsrunner.test'), 'Delivery confirmed', 'Your pharmacy pickup for Grace Namuli was confirmed successfully.', 'pages/request-details.php?id=3'),
((SELECT id FROM users WHERE email = 'irene.nakato@errandsrunner.test'), 'Customer handoff completed', 'The Najjera boutique parcel drop was confirmed by the customer.', 'pages/request-details.php?id=4');

INSERT INTO transactions (request_id, payer_id, payee_id, amount, payment_method, payment_status, transaction_reference, notes) VALUES
((SELECT id FROM requests WHERE title = 'Deliver beverage cartons to Lydia Mini Mart'), (SELECT id FROM users WHERE email = 'moses.kibirige@errandsrunner.test'), (SELECT id FROM users WHERE email = 'peter.walusimbi@errandsrunner.test'), 45000.00, 'cash_on_delivery', 'processing', 'TRX-2026-1001', 'Cash settlement will be completed after the cartons are handed over to the mini mart.'),
((SELECT id FROM requests WHERE title = 'Pick up paid pharmacy order for Grace Namuli'), (SELECT id FROM users WHERE email = 'joel.ssentamu@errandsrunner.test'), (SELECT id FROM users WHERE email = 'samuel.kato@errandsrunner.test'), 32000.00, 'bank_transfer', 'paid', 'TRX-2026-1002', 'Bank transfer cleared after the pharmacy order was delivered.'),
((SELECT id FROM requests WHERE title = 'Same-day boutique parcel drop to Najjera'), (SELECT id FROM users WHERE email = 'irene.nakato@errandsrunner.test'), (SELECT id FROM users WHERE email = 'daniel.mugerwa@errandsrunner.test'), 28000.00, 'cash_on_delivery', 'paid', 'TRX-2026-1003', 'Customer paid on delivery and the seller settled the runner immediately after.'),
((SELECT id FROM requests WHERE title = 'Office document pickup for Bugolobi branch'), (SELECT id FROM users WHERE email = 'patricia.namara@errandsrunner.test'), (SELECT id FROM users WHERE email = 'brian.ssemanda@errandsrunner.test'), 40000.00, 'manual_record', 'paid', 'TRX-2026-1004', 'Manual office settlement recorded after documents reached the branch.'),
((SELECT id FROM requests WHERE title = 'Source birthday cake and party supplies'), (SELECT id FROM users WHERE email = 'sarah.nansubuga@errandsrunner.test'), (SELECT id FROM users WHERE email = 'ruth.nankya@errandsrunner.test'), 116000.00, 'bank_transfer', 'processing', 'TRX-2026-1005', 'Initial transfer sent while the runner completes bakery pickup and party supply sourcing.'),
((SELECT id FROM requests WHERE title = 'Deliver catering supplies to UMA conference venue'), (SELECT id FROM users WHERE email = 'moses.kibirige@errandsrunner.test'), (SELECT id FROM users WHERE email = 'samuel.kato@errandsrunner.test'), 67000.00, 'cash_on_delivery', 'processing', 'TRX-2026-1006', 'Runner payment will be closed out after the event coordinator confirms item count.');

INSERT INTO request_status_logs (request_id, actor_id, status, note) VALUES
((SELECT id FROM requests WHERE title = 'Deliver beverage cartons to Lydia Mini Mart'), (SELECT id FROM users WHERE email = 'moses.kibirige@errandsrunner.test'), 'open', 'Moses created the beverage delivery request for a retail customer restock.'),
((SELECT id FROM requests WHERE title = 'Deliver beverage cartons to Lydia Mini Mart'), (SELECT id FROM users WHERE email = 'peter.walusimbi@errandsrunner.test'), 'assigned', 'Peter accepted the delivery and is preparing for dispatch.'),
((SELECT id FROM requests WHERE title = 'Source groceries for the Nansubuga family'), (SELECT id FROM users WHERE email = 'sarah.nansubuga@errandsrunner.test'), 'open', 'Sarah created a planned grocery sourcing errand for her household.'),
((SELECT id FROM requests WHERE title = 'Source groceries for the Nansubuga family'), NULL, 'quoted', 'Multiple runner quotations have been submitted for review.'),
((SELECT id FROM requests WHERE title = 'Pick up paid pharmacy order for Grace Namuli'), (SELECT id FROM users WHERE email = 'joel.ssentamu@errandsrunner.test'), 'open', 'Joel created the pharmacy pickup errand for Grace Namuli.'),
((SELECT id FROM requests WHERE title = 'Pick up paid pharmacy order for Grace Namuli'), (SELECT id FROM users WHERE email = 'samuel.kato@errandsrunner.test'), 'assigned', 'Samuel accepted the pharmacy pickup.'),
((SELECT id FROM requests WHERE title = 'Pick up paid pharmacy order for Grace Namuli'), (SELECT id FROM users WHERE email = 'samuel.kato@errandsrunner.test'), 'completed', 'Samuel delivered the pharmacy order safely and shared handoff confirmation.'),
((SELECT id FROM requests WHERE title = 'Pick up paid pharmacy order for Grace Namuli'), (SELECT id FROM users WHERE email = 'joel.ssentamu@errandsrunner.test'), 'confirmed', 'Joel confirmed the service was prompt and careful.'),
((SELECT id FROM requests WHERE title = 'Same-day boutique parcel drop to Najjera'), (SELECT id FROM users WHERE email = 'irene.nakato@errandsrunner.test'), 'open', 'Irene created a same-day parcel drop request for a regular boutique customer.'),
((SELECT id FROM requests WHERE title = 'Same-day boutique parcel drop to Najjera'), (SELECT id FROM users WHERE email = 'daniel.mugerwa@errandsrunner.test'), 'assigned', 'Daniel accepted the parcel delivery.'),
((SELECT id FROM requests WHERE title = 'Same-day boutique parcel drop to Najjera'), (SELECT id FROM users WHERE email = 'daniel.mugerwa@errandsrunner.test'), 'completed', 'Daniel completed the boutique parcel drop on schedule.'),
((SELECT id FROM requests WHERE title = 'Same-day boutique parcel drop to Najjera'), (SELECT id FROM users WHERE email = 'irene.nakato@errandsrunner.test'), 'confirmed', 'Irene confirmed a smooth customer handoff.'),
((SELECT id FROM requests WHERE title = 'Office document pickup for Bugolobi branch'), (SELECT id FROM users WHERE email = 'patricia.namara@errandsrunner.test'), 'open', 'Patricia created an office document pickup for branch filing.'),
((SELECT id FROM requests WHERE title = 'Office document pickup for Bugolobi branch'), (SELECT id FROM users WHERE email = 'brian.ssemanda@errandsrunner.test'), 'assigned', 'Brian accepted the office document delivery.'),
((SELECT id FROM requests WHERE title = 'Office document pickup for Bugolobi branch'), (SELECT id FROM users WHERE email = 'brian.ssemanda@errandsrunner.test'), 'completed', 'Brian delivered the office documents in good condition.'),
((SELECT id FROM requests WHERE title = 'Office document pickup for Bugolobi branch'), (SELECT id FROM users WHERE email = 'patricia.namara@errandsrunner.test'), 'confirmed', 'Patricia confirmed the documents were delivered on time.'),
((SELECT id FROM requests WHERE title = 'Source birthday cake and party supplies'), (SELECT id FROM users WHERE email = 'sarah.nansubuga@errandsrunner.test'), 'open', 'Sarah created a cake and party supplies sourcing errand for a family gathering.'),
((SELECT id FROM requests WHERE title = 'Source birthday cake and party supplies'), NULL, 'quoted', 'Competing runner quotations were submitted for the party sourcing errand.'),
((SELECT id FROM requests WHERE title = 'Source birthday cake and party supplies'), (SELECT id FROM users WHERE email = 'ruth.nankya@errandsrunner.test'), 'assigned', 'Ruth was selected based on the approved quotation.'),
((SELECT id FROM requests WHERE title = 'Source birthday cake and party supplies'), (SELECT id FROM users WHERE email = 'ruth.nankya@errandsrunner.test'), 'in_progress', 'Ruth has started the bakery pickup and related shopping.'),
((SELECT id FROM requests WHERE title = 'Deliver catering supplies to UMA conference venue'), (SELECT id FROM users WHERE email = 'moses.kibirige@errandsrunner.test'), 'open', 'Moses created a venue delivery request for conference catering supplies.'),
((SELECT id FROM requests WHERE title = 'Deliver catering supplies to UMA conference venue'), (SELECT id FROM users WHERE email = 'samuel.kato@errandsrunner.test'), 'assigned', 'Samuel accepted the catering supplies delivery.'),
((SELECT id FROM requests WHERE title = 'Deliver catering supplies to UMA conference venue'), (SELECT id FROM users WHERE email = 'samuel.kato@errandsrunner.test'), 'in_progress', 'Samuel is transporting supplies to UMA Show Grounds.'),
((SELECT id FROM requests WHERE title = 'Pick up laptop charger from Village Mall'), (SELECT id FROM users WHERE email = 'joel.ssentamu@errandsrunner.test'), 'open', 'Joel created a tech accessory pickup request for the office.'),
((SELECT id FROM requests WHERE title = 'Restock salon products from Kikuubo supplier'), (SELECT id FROM users WHERE email = 'irene.nakato@errandsrunner.test'), 'open', 'Irene created a restock request ahead of weekend salon traffic.');

INSERT INTO runner_reviews (request_id, reviewer_id, runner_id, rating, review_text) VALUES
((SELECT id FROM requests WHERE title = 'Pick up paid pharmacy order for Grace Namuli'), (SELECT id FROM users WHERE email = 'joel.ssentamu@errandsrunner.test'), (SELECT id FROM users WHERE email = 'samuel.kato@errandsrunner.test'), 5, 'Samuel kept me updated, handled the pharmacy package carefully, and arrived earlier than expected.'),
((SELECT id FROM requests WHERE title = 'Same-day boutique parcel drop to Najjera'), (SELECT id FROM users WHERE email = 'irene.nakato@errandsrunner.test'), (SELECT id FROM users WHERE email = 'daniel.mugerwa@errandsrunner.test'), 5, 'Daniel communicated beautifully with the customer and made the delivery feel premium and stress free.'),
((SELECT id FROM requests WHERE title = 'Office document pickup for Bugolobi branch'), (SELECT id FROM users WHERE email = 'patricia.namara@errandsrunner.test'), (SELECT id FROM users WHERE email = 'brian.ssemanda@errandsrunner.test'), 4, 'Brian was professional, respectful, and delivered the office documents without any issues.');

SET FOREIGN_KEY_CHECKS = 1;
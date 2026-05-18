# Errands Runner

Fast, trusted errands and delivery services for sellers and buyers.

Errands Runner is a multi-role web platform that connects:
- Sellers who need deliveries to customers
- Buyers who need item sourcing and delivery
- Runners (delivery agents) who execute errands
- Admins who monitor operations

The system is built with core PHP, MySQL, Tailwind CSS, HTML, and JavaScript.

## Core Features

- Role-based authentication (admin, seller, buyer, runner)
- Request creation and management (delivery, item purchase, pickup/dropoff, custom errands)
- Runner quotation flow and assignment workflow
- Request tracking with status logs
- In-app notifications
- Basic email prompt support via PHP `mail()`
- Payment method capture and transaction records
- Runner ratings/reviews
- Runner sample photo sharing for item sourcing errands
- Basic runner live location updates (browser geolocation + map link)
- Responsive UI for desktop and mobile

## Tech Stack

- Backend: PHP (core, no framework)
- Database: MySQL / MariaDB
- Frontend: Tailwind CSS, HTML, Vanilla JavaScript
- Server: Apache/LiteSpeed (XAMPP locally, cPanel hosting)

## Project Structure

```text
assets/                Static files, images, uploads
components/            Reusable UI PHP components
database/              SQL schema + seed data, DB connector
includes/              App config, auth, helper functions, validators
layouts/               Shared page wrappers (header/footer/sidebar)
pages/                 Role-specific and feature pages
index.php              Landing page
```

## Local Setup (XAMPP)

1. Place project in:
   - `c:\xampp\htdocs\ErrandRunner`
2. Start Apache and MySQL in XAMPP.
3. Create/import database:
   - Open `http://localhost/phpmyadmin`
   - Import `database/errands_runner.sql`
4. Open:
   - `http://localhost/ErrandRunner/`


## User Flow Summary

1. Buyer/Seller posts an errand request
2. Runners submit quotations (where applicable)
3. Request is assigned to a runner
4. Runner executes task and updates progress
5. Customer confirms completion
6. Transaction and review can be recorded

## Important Files

- `database/errands_runner.sql` - primary schema + seed data
- `pages/request-create.php` - request creation form
- `pages/request-details.php` - tracking, status, assignment, payment details
- `includes/functions.php` - major business logic
- `includes/validators.php` - input validation rules




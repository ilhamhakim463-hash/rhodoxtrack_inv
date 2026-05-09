-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3307
-- Generation Time: May 10, 2026 at 01:46 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `rhodoxtrack`
--

-- --------------------------------------------------------

--
-- Table structure for table `audit_trail`
--

CREATE TABLE `audit_trail` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `target` varchar(100) DEFAULT NULL,
  `target_id` int(11) DEFAULT NULL,
  `detail` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `audit_trail`
--

INSERT INTO `audit_trail` (`id`, `user_id`, `action`, `target`, `target_id`, `detail`, `ip_address`, `created_at`) VALUES
(1, 1, 'login', 'users', 1, 'Login berhasil', '127.0.0.1', '2026-05-09 02:53:35'),
(2, 2, 'login', 'users', 2, 'Login berhasil', '127.0.0.1', '2026-05-09 02:55:32'),
(3, 2, 'add_purchase', 'inventory_transactions', 1, 'Purchase 0.133 karung Beras Premium 5kg @ Rp93,900', '127.0.0.1', '2026-05-09 02:57:40'),
(4, 1, 'login', 'users', 1, 'Login berhasil', '127.0.0.1', '2026-05-09 02:57:59'),
(5, 1, 'create_product', 'products', 13, 'Tambah produk: samsu', '127.0.0.1', '2026-05-09 03:22:33'),
(6, 1, 'delete_product', 'products', 1, 'Nonaktifkan: Beras Premium 5kg', '127.0.0.1', '2026-05-09 03:25:41'),
(7, 1, 'delete_product', 'products', 13, 'Nonaktifkan: samsu', '127.0.0.1', '2026-05-09 03:26:38'),
(8, 1, 'login', 'users', 1, 'Login berhasil', '127.0.0.1', '2026-05-09 12:41:29'),
(9, 2, 'login', 'users', 2, 'Login berhasil', '127.0.0.1', '2026-05-09 23:35:03');

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`) VALUES
(1, 'Beras & Biji-bijian'),
(3, 'Bumbu & Rempah'),
(4, 'Gula & Pemanis'),
(9, 'Kebutuhan Rumah Tangga'),
(5, 'Minuman'),
(2, 'Minyak & Lemak'),
(8, 'Perawatan Diri'),
(7, 'Produk Susu'),
(10, 'rokok');

-- --------------------------------------------------------

--
-- Table structure for table `hpp_log`
--

CREATE TABLE `hpp_log` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `old_avg_cost` float DEFAULT NULL,
  `new_avg_cost` float DEFAULT NULL,
  `old_stock` float DEFAULT NULL,
  `new_stock` float DEFAULT NULL,
  `transaction_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `hpp_log`
--

INSERT INTO `hpp_log` (`id`, `product_id`, `old_avg_cost`, `new_avg_cost`, `old_stock`, `new_stock`, `transaction_id`, `created_at`) VALUES
(1, 1, 85000, 85078.2, 15, 15.133, 1, '2026-05-09 02:57:40');

-- --------------------------------------------------------

--
-- Table structure for table `inventory_transactions`
--

CREATE TABLE `inventory_transactions` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `type` enum('purchase','sale','adjustment','return') NOT NULL,
  `qty` float NOT NULL,
  `unit_price` float DEFAULT NULL,
  `total_price` float DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `inventory_transactions`
--

INSERT INTO `inventory_transactions` (`id`, `product_id`, `type`, `qty`, `unit_price`, `total_price`, `note`, `user_id`, `created_at`) VALUES
(1, 1, 'purchase', 0.133, 93900, 12488.7, '', 2, '2026-05-09 02:57:40');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `sku` varchar(50) NOT NULL,
  `barcode` varchar(50) DEFAULT NULL,
  `category_id` int(11) NOT NULL,
  `unit` varchar(20) NOT NULL,
  `min_stock` float DEFAULT NULL,
  `current_stock` float DEFAULT NULL,
  `avg_cost` float DEFAULT NULL,
  `selling_price` float DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `sku`, `barcode`, `category_id`, `unit`, `min_stock`, `current_stock`, `avg_cost`, `selling_price`, `is_active`, `created_at`) VALUES
(1, 'Beras Premium 5kg', 'BRS-001', NULL, 1, 'karung', 5, 15.133, 85078.2, 95000, 0, '2026-05-08 23:25:36'),
(2, 'Beras Rojolele 5kg', 'BRS-002', NULL, 1, 'karung', 5, 15, 72000, 82000, 1, '2026-05-08 23:25:36'),
(3, 'Minyak Goreng 1L', 'MNY-001', NULL, 2, 'botol', 10, 30, 17500, 20000, 1, '2026-05-08 23:25:36'),
(4, 'Minyak Goreng 2L', 'MNY-002', NULL, 2, 'botol', 5, 15, 33000, 37000, 1, '2026-05-08 23:25:36'),
(5, 'Gula Pasir 1kg', 'GUL-001', NULL, 4, 'kg', 20, 60, 13500, 15500, 1, '2026-05-08 23:25:36'),
(6, 'Gula Merah 500g', 'GUL-002', NULL, 4, 'bungkus', 10, 30, 9000, 11000, 1, '2026-05-08 23:25:36'),
(7, 'Teh Celup 25 pcs', 'MIN-001', NULL, 5, 'kotak', 15, 45, 8500, 11000, 1, '2026-05-08 23:25:36'),
(8, 'Kopi Bubuk 200g', 'MIN-002', NULL, 5, 'bungkus', 10, 30, 18000, 23000, 1, '2026-05-08 23:25:36'),
(9, 'Garam Dapur 250g', 'BUM-001', NULL, 3, 'bungkus', 20, 60, 2500, 3500, 1, '2026-05-08 23:25:36'),
(10, 'Merica Bubuk 50g', 'BUM-002', NULL, 3, 'sachet', 10, 30, 5500, 7500, 1, '2026-05-08 23:25:36'),
(11, 'Susu UHT 1L', 'SUS-001', NULL, 7, 'karton', 8, 24, 17000, 20000, 1, '2026-05-08 23:25:36'),
(12, 'Sabun Mandi', 'PER-001', NULL, 8, 'batang', 24, 72, 2800, 4000, 1, '2026-05-08 23:25:36'),
(13, 'samsu', 'Brs 21', NULL, 10, 'bungkus', 10, 0, 0, 30000, 0, '2026-05-09 03:22:33');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(80) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','kasir') NOT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `role`, `created_at`) VALUES
(1, 'admin', 'scrypt:32768:8:1$I29SIhogfq6raDSH$86b9ad82814363ab6eaa4ea9adac4a8e7bb7a8147442fcf61875929924332d639350ee52e45ab05830b2ac7e6c6f73da18f807c9cb6a89eeec6971f7a1d1c6eb', 'admin', '2026-05-08 23:25:36'),
(2, 'kasir1', 'scrypt:32768:8:1$BhYI5WT91RI2n3bL$c435b7308b437896d17550d88f903fba38abb48fd22c5b4be68933ce834437f825b3fa314f1ca2e64c93b559a143785d6d1f17183ee4e8f8c933e9a99db78b9f', 'kasir', '2026-05-08 23:25:36');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `audit_trail`
--
ALTER TABLE `audit_trail`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `hpp_log`
--
ALTER TABLE `hpp_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `transaction_id` (`transaction_id`);

--
-- Indexes for table `inventory_transactions`
--
ALTER TABLE `inventory_transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `sku` (`sku`),
  ADD UNIQUE KEY `barcode` (`barcode`),
  ADD KEY `category_id` (`category_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `audit_trail`
--
ALTER TABLE `audit_trail`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `hpp_log`
--
ALTER TABLE `hpp_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `inventory_transactions`
--
ALTER TABLE `inventory_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `audit_trail`
--
ALTER TABLE `audit_trail`
  ADD CONSTRAINT `audit_trail_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `hpp_log`
--
ALTER TABLE `hpp_log`
  ADD CONSTRAINT `hpp_log_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `hpp_log_ibfk_2` FOREIGN KEY (`transaction_id`) REFERENCES `inventory_transactions` (`id`);

--
-- Constraints for table `inventory_transactions`
--
ALTER TABLE `inventory_transactions`
  ADD CONSTRAINT `inventory_transactions_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `inventory_transactions_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

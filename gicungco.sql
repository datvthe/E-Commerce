-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: marketplace
-- ------------------------------------------------------
-- Server version	9.4.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ai_fraud_detections`
--

DROP TABLE IF EXISTS `ai_fraud_detections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ai_fraud_detections` (
  `fraud_ai_id` bigint NOT NULL AUTO_INCREMENT,
  `transaction_id` bigint DEFAULT NULL,
  `risk_score` int DEFAULT NULL,
  `recommendation` enum('block','review','allow') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `generated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`fraud_ai_id`),
  KEY `transaction_id` (`transaction_id`),
  CONSTRAINT `ai_fraud_detections_ibfk_1` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`transaction_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ai_fraud_detections`
--

LOCK TABLES `ai_fraud_detections` WRITE;
/*!40000 ALTER TABLE `ai_fraud_detections` DISABLE KEYS */;
/*!40000 ALTER TABLE `ai_fraud_detections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ai_inventory_forecasts`
--

DROP TABLE IF EXISTS `ai_inventory_forecasts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ai_inventory_forecasts` (
  `forecast_id` bigint NOT NULL AUTO_INCREMENT,
  `product_id` bigint DEFAULT NULL,
  `predicted_demand` int DEFAULT NULL,
  `period` enum('daily','weekly','monthly') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `confidence_score` decimal(5,2) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`forecast_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `ai_inventory_forecasts_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ai_inventory_forecasts`
--

LOCK TABLES `ai_inventory_forecasts` WRITE;
/*!40000 ALTER TABLE `ai_inventory_forecasts` DISABLE KEYS */;
/*!40000 ALTER TABLE `ai_inventory_forecasts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ai_moderation_flags`
--

DROP TABLE IF EXISTS `ai_moderation_flags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ai_moderation_flags` (
  `mod_flag_id` bigint NOT NULL AUTO_INCREMENT,
  `item_type` enum('product','promotion','review') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_id` bigint DEFAULT NULL,
  `reason` longtext COLLATE utf8mb4_unicode_ci,
  `confidence_score` decimal(5,2) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`mod_flag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ai_moderation_flags`
--

LOCK TABLES `ai_moderation_flags` WRITE;
/*!40000 ALTER TABLE `ai_moderation_flags` DISABLE KEYS */;
/*!40000 ALTER TABLE `ai_moderation_flags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ai_price_predictions`
--

DROP TABLE IF EXISTS `ai_price_predictions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ai_price_predictions` (
  `price_pred_id` bigint NOT NULL AUTO_INCREMENT,
  `product_id` bigint DEFAULT NULL,
  `predicted_price` decimal(15,2) DEFAULT NULL,
  `confidence_score` decimal(5,2) DEFAULT NULL,
  `valid_until` datetime DEFAULT NULL,
  PRIMARY KEY (`price_pred_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `ai_price_predictions_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ai_price_predictions`
--

LOCK TABLES `ai_price_predictions` WRITE;
/*!40000 ALTER TABLE `ai_price_predictions` DISABLE KEYS */;
/*!40000 ALTER TABLE `ai_price_predictions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ai_recommendations`
--

DROP TABLE IF EXISTS `ai_recommendations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ai_recommendations` (
  `rec_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint DEFAULT NULL,
  `product_id` bigint DEFAULT NULL,
  `score` decimal(5,2) DEFAULT NULL,
  `generated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`rec_id`),
  KEY `user_id` (`user_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `ai_recommendations_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `ai_recommendations_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ai_recommendations`
--

LOCK TABLES `ai_recommendations` WRITE;
/*!40000 ALTER TABLE `ai_recommendations` DISABLE KEYS */;
/*!40000 ALTER TABLE `ai_recommendations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ai_sales_forecasts`
--

DROP TABLE IF EXISTS `ai_sales_forecasts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ai_sales_forecasts` (
  `forecast_id` bigint NOT NULL AUTO_INCREMENT,
  `seller_id` bigint DEFAULT NULL,
  `predicted_revenue` decimal(15,2) DEFAULT NULL,
  `period` enum('daily','weekly','monthly') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `confidence_score` decimal(5,2) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`forecast_id`),
  KEY `seller_id` (`seller_id`),
  CONSTRAINT `ai_sales_forecasts_ibfk_1` FOREIGN KEY (`seller_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ai_sales_forecasts`
--

LOCK TABLES `ai_sales_forecasts` WRITE;
/*!40000 ALTER TABLE `ai_sales_forecasts` DISABLE KEYS */;
/*!40000 ALTER TABLE `ai_sales_forecasts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `audit_logs`
--

DROP TABLE IF EXISTS `audit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_logs` (
  `audit_id` bigint NOT NULL AUTO_INCREMENT,
  `admin_id` bigint DEFAULT NULL,
  `action` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `target_table` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `target_id` bigint DEFAULT NULL,
  `old_value` json DEFAULT NULL,
  `new_value` json DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`audit_id`),
  KEY `admin_id` (`admin_id`),
  CONSTRAINT `audit_logs_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_logs`
--

LOCK TABLES `audit_logs` WRITE;
/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `audit_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_sessions`
--

DROP TABLE IF EXISTS `auth_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_sessions` (
  `session_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint DEFAULT NULL,
  `access_token` longtext COLLATE utf8mb4_unicode_ci,
  `refresh_token` longtext COLLATE utf8mb4_unicode_ci,
  `ip_address` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `device_info` longtext COLLATE utf8mb4_unicode_ci,
  `login_time` datetime DEFAULT NULL,
  `logout_time` datetime DEFAULT NULL,
  PRIMARY KEY (`session_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `auth_sessions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_sessions`
--

LOCK TABLES `auth_sessions` WRITE;
/*!40000 ALTER TABLE `auth_sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `commission_settings`
--

DROP TABLE IF EXISTS `commission_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `commission_settings` (
  `commission_setting_id` bigint NOT NULL AUTO_INCREMENT,
  `category_id` bigint DEFAULT NULL,
  `base_rate` decimal(5,2) DEFAULT NULL,
  `dynamic_rate_enabled` tinyint(1) DEFAULT '0',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`commission_setting_id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `commission_settings_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `product_categories` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `commission_settings`
--

LOCK TABLES `commission_settings` WRITE;
/*!40000 ALTER TABLE `commission_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `commission_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `commissions`
--

DROP TABLE IF EXISTS `commissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `commissions` (
  `commission_id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint DEFAULT NULL,
  `seller_id` bigint DEFAULT NULL,
  `rate` decimal(5,2) DEFAULT NULL,
  `amount` decimal(15,2) DEFAULT NULL,
  `status` enum('calculated','transferred') COLLATE utf8mb4_unicode_ci DEFAULT 'calculated',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`commission_id`),
  KEY `order_id` (`order_id`),
  KEY `seller_id` (`seller_id`),
  CONSTRAINT `commissions_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  CONSTRAINT `commissions_ibfk_2` FOREIGN KEY (`seller_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `commissions`
--

LOCK TABLES `commissions` WRITE;
/*!40000 ALTER TABLE `commissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `commissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `files`
--

DROP TABLE IF EXISTS `files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `files` (
  `file_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint DEFAULT NULL,
  `file_name` longtext COLLATE utf8mb4_unicode_ci,
  `file_path` longtext COLLATE utf8mb4_unicode_ci,
  `file_type` enum('image','doc','video','other') COLLATE utf8mb4_unicode_ci DEFAULT 'image',
  `size` bigint DEFAULT NULL,
  `uploaded_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`file_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `files_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `files`
--

LOCK TABLES `files` WRITE;
/*!40000 ALTER TABLE `files` DISABLE KEYS */;
/*!40000 ALTER TABLE `files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fraud_flags`
--

DROP TABLE IF EXISTS `fraud_flags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fraud_flags` (
  `flag_id` bigint NOT NULL AUTO_INCREMENT,
  `transaction_id` bigint DEFAULT NULL,
  `reason` longtext COLLATE utf8mb4_unicode_ci,
  `risk_score` int DEFAULT NULL,
  `status` enum('pending','confirmed','dismissed') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `detected_by` enum('AI','Manager') COLLATE utf8mb4_unicode_ci DEFAULT 'AI',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`flag_id`),
  KEY `transaction_id` (`transaction_id`),
  CONSTRAINT `fraud_flags_ibfk_1` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`transaction_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fraud_flags`
--

LOCK TABLES `fraud_flags` WRITE;
/*!40000 ALTER TABLE `fraud_flags` DISABLE KEYS */;
/*!40000 ALTER TABLE `fraud_flags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory`
--

DROP TABLE IF EXISTS `inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory` (
  `inventory_id` bigint NOT NULL AUTO_INCREMENT,
  `product_id` bigint DEFAULT NULL,
  `seller_id` bigint DEFAULT NULL,
  `quantity` int DEFAULT '0',
  `reserved_quantity` int DEFAULT '0',
  `min_threshold` int DEFAULT '0',
  `last_restocked_at` datetime DEFAULT NULL,
  PRIMARY KEY (`inventory_id`),
  KEY `product_id` (`product_id`),
  KEY `seller_id` (`seller_id`),
  CONSTRAINT `inventory_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`),
  CONSTRAINT `inventory_ibfk_2` FOREIGN KEY (`seller_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory`
--

LOCK TABLES `inventory` WRITE;
/*!40000 ALTER TABLE `inventory` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `messages` (
  `message_id` bigint NOT NULL AUTO_INCREMENT,
  `sender_id` bigint DEFAULT NULL,
  `receiver_id` bigint DEFAULT NULL,
  `content` text COLLATE utf8mb4_unicode_ci,
  `type` enum('chat','system') COLLATE utf8mb4_unicode_ci DEFAULT 'chat',
  `status` enum('sent','delivered','read') COLLATE utf8mb4_unicode_ci DEFAULT 'sent',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`message_id`),
  KEY `sender_id` (`sender_id`),
  KEY `receiver_id` (`receiver_id`),
  CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`sender_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`receiver_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `moderation_queue`
--

DROP TABLE IF EXISTS `moderation_queue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `moderation_queue` (
  `queue_id` bigint NOT NULL AUTO_INCREMENT,
  `item_type` enum('product','promotion','order','review') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_id` bigint DEFAULT NULL,
  `submitted_by` bigint DEFAULT NULL,
  `status` enum('pending','approved','rejected','flagged') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `reviewed_by` bigint DEFAULT NULL,
  `review_notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `reviewed_at` datetime DEFAULT NULL,
  PRIMARY KEY (`queue_id`),
  KEY `submitted_by` (`submitted_by`),
  KEY `reviewed_by` (`reviewed_by`),
  CONSTRAINT `moderation_queue_ibfk_1` FOREIGN KEY (`submitted_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `moderation_queue_ibfk_2` FOREIGN KEY (`reviewed_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `moderation_queue`
--

LOCK TABLES `moderation_queue` WRITE;
/*!40000 ALTER TABLE `moderation_queue` DISABLE KEYS */;
/*!40000 ALTER TABLE `moderation_queue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `notification_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint DEFAULT NULL,
  `title` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `message` text COLLATE utf8mb4_unicode_ci,
  `type` enum('order','promotion','wallet','system') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('unread','read') COLLATE utf8mb4_unicode_ci DEFAULT 'unread',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`notification_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `order_item_id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint DEFAULT NULL,
  `product_id` bigint DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `price_at_purchase` decimal(15,2) DEFAULT NULL,
  `discount_applied` decimal(10,2) DEFAULT NULL,
  `subtotal` decimal(15,2) DEFAULT NULL,
  PRIMARY KEY (`order_item_id`),
  KEY `order_id` (`order_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `order_id` bigint NOT NULL AUTO_INCREMENT,
  `buyer_id` bigint DEFAULT NULL,
  `seller_id` bigint DEFAULT NULL,
  `status` enum('pending','paid','shipped','delivered','cancelled','refunded') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `total_amount` decimal(15,2) DEFAULT NULL,
  `currency` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shipping_address` longtext COLLATE utf8mb4_unicode_ci,
  `shipping_method` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tracking_number` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`order_id`),
  KEY `buyer_id` (`buyer_id`),
  KEY `seller_id` (`seller_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`buyer_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`seller_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `payment_id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint DEFAULT NULL,
  `method` enum('Wallet','VNPay','PayPal','Stripe','COD') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('pending','success','failed') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `transaction_id` bigint DEFAULT NULL,
  `paid_at` datetime DEFAULT NULL,
  PRIMARY KEY (`payment_id`),
  KEY `order_id` (`order_id`),
  CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_attributes`
--

DROP TABLE IF EXISTS `product_attributes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_attributes` (
  `attribute_id` bigint NOT NULL AUTO_INCREMENT,
  `product_id` bigint DEFAULT NULL,
  `attribute_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `attribute_value` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`attribute_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `product_attributes_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_attributes`
--

LOCK TABLES `product_attributes` WRITE;
/*!40000 ALTER TABLE `product_attributes` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_attributes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_categories`
--

DROP TABLE IF EXISTS `product_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_categories` (
  `category_id` bigint NOT NULL AUTO_INCREMENT,
  `parent_id` bigint DEFAULT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci DEFAULT 'active',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`category_id`),
  KEY `parent_id` (`parent_id`),
  CONSTRAINT `product_categories_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `product_categories` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_categories`
--

LOCK TABLES `product_categories` WRITE;
/*!40000 ALTER TABLE `product_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_images`
--

DROP TABLE IF EXISTS `product_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_images` (
  `image_id` bigint NOT NULL AUTO_INCREMENT,
  `product_id` bigint DEFAULT NULL,
  `url` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `alt_text` longtext COLLATE utf8mb4_unicode_ci,
  `is_primary` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`image_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `product_images_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_images`
--

LOCK TABLES `product_images` WRITE;
/*!40000 ALTER TABLE `product_images` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_tags`
--

DROP TABLE IF EXISTS `product_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_tags` (
  `tag_id` bigint NOT NULL AUTO_INCREMENT,
  `product_id` bigint DEFAULT NULL,
  `tag_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `source` enum('manual','ai') COLLATE utf8mb4_unicode_ci DEFAULT 'manual',
  PRIMARY KEY (`tag_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `product_tags_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_tags`
--

LOCK TABLES `product_tags` WRITE;
/*!40000 ALTER TABLE `product_tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `product_id` bigint NOT NULL AUTO_INCREMENT,
  `seller_id` bigint DEFAULT NULL,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `price` decimal(15,2) NOT NULL,
  `currency` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT 'VND',
  `status` enum('draft','pending','approved','rejected','active','inactive') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `category_id` bigint DEFAULT NULL,
  `average_rating` decimal(3,2) DEFAULT '0.00',
  `total_reviews` int DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`product_id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `seller_id` (`seller_id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`seller_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `products_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `product_categories` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `promotions`
--

DROP TABLE IF EXISTS `promotions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `promotions` (
  `promotion_id` bigint NOT NULL AUTO_INCREMENT,
  `seller_id` bigint DEFAULT NULL,
  `product_id` bigint DEFAULT NULL,
  `promotion_type` enum('percentage','fixed','coupon','flash_sale') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `discount_value` decimal(10,2) DEFAULT NULL,
  `coupon_code` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `status` enum('pending','approved','rejected','active','expired') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  PRIMARY KEY (`promotion_id`),
  KEY `seller_id` (`seller_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `promotions_ibfk_1` FOREIGN KEY (`seller_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `promotions_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promotions`
--

LOCK TABLES `promotions` WRITE;
/*!40000 ALTER TABLE `promotions` DISABLE KEYS */;
/*!40000 ALTER TABLE `promotions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reports`
--

DROP TABLE IF EXISTS `reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reports` (
  `report_id` bigint NOT NULL AUTO_INCREMENT,
  `report_type` enum('sales','revenue','fraud','user_growth','inventory') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content` json DEFAULT NULL,
  `generated_by` enum('system','admin') COLLATE utf8mb4_unicode_ci DEFAULT 'system',
  `generated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`report_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reports`
--

LOCK TABLES `reports` WRITE;
/*!40000 ALTER TABLE `reports` DISABLE KEYS */;
/*!40000 ALTER TABLE `reports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review_responses`
--

DROP TABLE IF EXISTS `review_responses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review_responses` (
  `response_id` bigint NOT NULL AUTO_INCREMENT,
  `review_id` bigint DEFAULT NULL,
  `seller_id` bigint DEFAULT NULL,
  `response_text` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`response_id`),
  KEY `review_id` (`review_id`),
  KEY `seller_id` (`seller_id`),
  CONSTRAINT `review_responses_ibfk_1` FOREIGN KEY (`review_id`) REFERENCES `reviews` (`review_id`),
  CONSTRAINT `review_responses_ibfk_2` FOREIGN KEY (`seller_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review_responses`
--

LOCK TABLES `review_responses` WRITE;
/*!40000 ALTER TABLE `review_responses` DISABLE KEYS */;
/*!40000 ALTER TABLE `review_responses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviews` (
  `review_id` bigint NOT NULL AUTO_INCREMENT,
  `product_id` bigint DEFAULT NULL,
  `buyer_id` bigint DEFAULT NULL,
  `rating` tinyint DEFAULT NULL,
  `comment` text COLLATE utf8mb4_unicode_ci,
  `images` json DEFAULT NULL,
  `status` enum('visible','hidden','flagged') COLLATE utf8mb4_unicode_ci DEFAULT 'visible',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`review_id`),
  KEY `product_id` (`product_id`),
  KEY `buyer_id` (`buyer_id`),
  CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`),
  CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`buyer_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `reviews_chk_1` CHECK ((`rating` between 1 and 5))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `role_id` int NOT NULL AUTO_INCREMENT,
  `role_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `role_name` (`role_name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'admin','System administrator with full access'),(2,'seller','Can create and manage products'),(3,'customer','Regular user who can make purchases'),(4,'moderator','Can moderate content and users');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `support_tickets`
--

DROP TABLE IF EXISTS `support_tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `support_tickets` (
  `ticket_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint DEFAULT NULL,
  `category` enum('refund','dispute','complaint','technical') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `priority` enum('low','medium','high') COLLATE utf8mb4_unicode_ci DEFAULT 'medium',
  `status` enum('open','in_progress','resolved','closed') COLLATE utf8mb4_unicode_ci DEFAULT 'open',
  `assigned_to` bigint DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `resolved_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ticket_id`),
  KEY `user_id` (`user_id`),
  KEY `assigned_to` (`assigned_to`),
  CONSTRAINT `support_tickets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `support_tickets_ibfk_2` FOREIGN KEY (`assigned_to`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `support_tickets`
--

LOCK TABLES `support_tickets` WRITE;
/*!40000 ALTER TABLE `support_tickets` DISABLE KEYS */;
/*!40000 ALTER TABLE `support_tickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system_logs`
--

DROP TABLE IF EXISTS `system_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `system_logs` (
  `log_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint DEFAULT NULL,
  `action` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ip_address` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `device_info` longtext COLLATE utf8mb4_unicode_ci,
  `details` json DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `system_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_logs`
--

LOCK TABLES `system_logs` WRITE;
/*!40000 ALTER TABLE `system_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `system_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system_settings`
--

DROP TABLE IF EXISTS `system_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `system_settings` (
  `setting_id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `value` text COLLATE utf8mb4_unicode_ci,
  `type` enum('string','int','json','bool') COLLATE utf8mb4_unicode_ci DEFAULT 'string',
  `description` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`setting_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_settings`
--

LOCK TABLES `system_settings` WRITE;
/*!40000 ALTER TABLE `system_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `system_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transactions`
--

DROP TABLE IF EXISTS `transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transactions` (
  `transaction_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint DEFAULT NULL,
  `type` enum('deposit','withdraw','order_payment','refund','commission') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `amount` decimal(15,2) DEFAULT NULL,
  `currency` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('pending','success','failed') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `reference_id` bigint DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`transaction_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transactions`
--

LOCK TABLES `transactions` WRITE;
/*!40000 ALTER TABLE `transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_roles`
--

DROP TABLE IF EXISTS `user_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_roles` (
  `user_role_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint DEFAULT NULL,
  `role_id` int DEFAULT NULL,
  `assigned_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_role_id`),
  KEY `user_id` (`user_id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `user_roles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `user_roles_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_roles`
--

LOCK TABLES `user_roles` WRITE;
/*!40000 ALTER TABLE `user_roles` DISABLE KEYS */;
INSERT INTO `user_roles` VALUES (1,1,1,'2025-09-20 10:36:31'),(2,2,2,'2025-09-20 10:36:31'),(3,3,3,'2025-09-20 10:36:31'),(4,4,4,'2025-09-20 10:36:31');
/*!40000 ALTER TABLE `user_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` bigint NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone_number` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gender` enum('male','female','other') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `address` longtext COLLATE utf8mb4_unicode_ci,
  `avatar_url` longtext COLLATE utf8mb4_unicode_ci,
  `default_role` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('active','inactive','banned','pending') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `email_verified` tinyint(1) DEFAULT '0',
  `last_login_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Admin User','admin@example.com','hashed_password_1','0901234567','male','1990-01-01','Ha Noi, Vietnam',NULL,'admin','active',1,NULL,'2025-09-20 10:36:31','2025-09-20 10:36:31',NULL),(2,'Seller One','seller1@example.com','hashed_password_2','0901234568','female','1992-03-15','Ho Chi Minh City, Vietnam',NULL,'seller','active',1,NULL,'2025-09-20 10:36:31','2025-09-20 10:36:31',NULL),(3,'Customer One','customer1@example.com','hashed_password_3','0901234569','male','1995-06-20','Da Nang, Vietnam',NULL,'customer','active',1,NULL,'2025-09-20 10:36:31','2025-09-20 10:36:31',NULL),(4,'Moderator One','moderator1@example.com','hashed_password_4','0901234570','female','1988-12-10','Can Tho, Vietnam',NULL,'moderator','active',1,NULL,'2025-09-20 10:36:31','2025-09-20 10:36:31',NULL),(10,'Nguyen Van Admin 2','admin2@example.com','hashed_password_admin2','0909876543','male','1992-02-02','456 Đường XYZ, Quận 2, TP.HCM','https://example.com/avatar/admin2.png','admin','active',1,'2025-09-20 10:54:14','2025-09-20 10:54:14','2025-09-20 10:54:14',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wallet_history`
--

DROP TABLE IF EXISTS `wallet_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wallet_history` (
  `history_id` bigint NOT NULL AUTO_INCREMENT,
  `wallet_id` bigint DEFAULT NULL,
  `transaction_id` bigint DEFAULT NULL,
  `amount` decimal(15,2) DEFAULT NULL,
  `balance_before` decimal(15,2) DEFAULT NULL,
  `balance_after` decimal(15,2) DEFAULT NULL,
  `type` enum('deposit','withdraw','payment','refund') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`history_id`),
  KEY `wallet_id` (`wallet_id`),
  KEY `transaction_id` (`transaction_id`),
  CONSTRAINT `wallet_history_ibfk_1` FOREIGN KEY (`wallet_id`) REFERENCES `wallets` (`wallet_id`),
  CONSTRAINT `wallet_history_ibfk_2` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`transaction_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wallet_history`
--

LOCK TABLES `wallet_history` WRITE;
/*!40000 ALTER TABLE `wallet_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `wallet_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wallets`
--

DROP TABLE IF EXISTS `wallets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wallets` (
  `wallet_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint DEFAULT NULL,
  `balance` decimal(15,2) DEFAULT '0.00',
  `currency` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT 'VND',
  PRIMARY KEY (`wallet_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `wallets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wallets`
--

LOCK TABLES `wallets` WRITE;
/*!40000 ALTER TABLE `wallets` DISABLE KEYS */;
/*!40000 ALTER TABLE `wallets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'marketplace'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-09-20 11:00:29

-- ========================================
-- ADDITIONAL TABLES FOR DIGITAL GOODS MARKETPLACE
-- ========================================

-- Create Digital_Goods_Codes table for storing digital codes/accounts
CREATE TABLE IF NOT EXISTS `digital_goods_codes` (
    `code_id` INT NOT NULL AUTO_INCREMENT,
    `product_id` BIGINT NOT NULL,
    `code_value` TEXT NOT NULL,
    `code_type` ENUM('serial', 'account', 'license', 'gift_card', 'file_url') NOT NULL,
    `is_used` BOOLEAN DEFAULT FALSE,
    `used_by` BIGINT DEFAULT NULL,
    `used_at` TIMESTAMP NULL,
    `expires_at` TIMESTAMP NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`code_id`),
    KEY `product_id` (`product_id`),
    KEY `is_used` (`is_used`),
    KEY `used_by` (`used_by`),
    CONSTRAINT `digital_goods_codes_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE,
    CONSTRAINT `digital_goods_codes_ibfk_2` FOREIGN KEY (`used_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Digital_Goods_Files table for downloadable files
CREATE TABLE IF NOT EXISTS `digital_goods_files` (
    `file_id` INT NOT NULL AUTO_INCREMENT,
    `product_id` BIGINT NOT NULL,
    `file_name` VARCHAR(255) NOT NULL,
    `file_path` VARCHAR(500) NOT NULL,
    `file_size` BIGINT DEFAULT NULL,
    `file_type` VARCHAR(100) DEFAULT NULL,
    `download_count` INT DEFAULT 0,
    `max_downloads` INT DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`file_id`),
    KEY `product_id` (`product_id`),
    CONSTRAINT `digital_goods_files_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Wishlist table
CREATE TABLE IF NOT EXISTS `wishlist` (
    `wishlist_id` INT NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT NOT NULL,
    `product_id` BIGINT NOT NULL,
    `added_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`wishlist_id`),
    UNIQUE KEY `user_product` (`user_id`, `product_id`),
    KEY `user_id` (`user_id`),
    KEY `product_id` (`product_id`),
    CONSTRAINT `wishlist_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
    CONSTRAINT `wishlist_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Password_Reset_Tokens table
CREATE TABLE IF NOT EXISTS `password_reset_tokens` (
    `token_id` INT NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT NOT NULL,
    `token` VARCHAR(255) NOT NULL,
    `expires_at` TIMESTAMP NOT NULL,
    `is_used` BOOLEAN DEFAULT FALSE,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`token_id`),
    KEY `user_id` (`user_id`),
    KEY `token` (`token`),
    CONSTRAINT `password_reset_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Update products table to add digital goods fields
-- Check if columns exist before adding them
SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
     WHERE TABLE_SCHEMA = DATABASE() 
     AND TABLE_NAME = 'products' 
     AND COLUMN_NAME = 'is_digital') = 0,
    'ALTER TABLE `products` ADD COLUMN `is_digital` BOOLEAN DEFAULT TRUE AFTER `currency`',
    'SELECT "Column is_digital already exists"'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
     WHERE TABLE_SCHEMA = DATABASE() 
     AND TABLE_NAME = 'products' 
     AND COLUMN_NAME = 'delivery_type') = 0,
    'ALTER TABLE `products` ADD COLUMN `delivery_type` ENUM(''instant'', ''manual'', ''email'') DEFAULT ''instant'' AFTER `is_digital`',
    'SELECT "Column delivery_type already exists"'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
     WHERE TABLE_SCHEMA = DATABASE() 
     AND TABLE_NAME = 'products' 
     AND COLUMN_NAME = 'delivery_time') = 0,
    'ALTER TABLE `products` ADD COLUMN `delivery_time` VARCHAR(50) DEFAULT ''Tức thì'' AFTER `delivery_type`',
    'SELECT "Column delivery_time already exists"'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
     WHERE TABLE_SCHEMA = DATABASE() 
     AND TABLE_NAME = 'products' 
     AND COLUMN_NAME = 'warranty_days') = 0,
    'ALTER TABLE `products` ADD COLUMN `warranty_days` INT DEFAULT 7 AFTER `delivery_time`',
    'SELECT "Column warranty_days already exists"'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Insert sample digital goods products
INSERT INTO `products` (`seller_id`, `name`, `slug`, `description`, `price`, `currency`, `is_digital`, `delivery_type`, `delivery_time`, `warranty_days`, `status`, `average_rating`, `total_reviews`, `created_at`, `updated_at`) VALUES
(2, 'Thẻ cào Viettel 100K', 'the-cao-viettel-100k', 'Thẻ cào Viettel mệnh giá 100,000 VNĐ. Giao ngay sau khi thanh toán.', 95000, 'VND', TRUE, 'instant', 'Tức thì', 7, 'active', 4.8, 156, NOW(), NOW()),
(2, 'Tài khoản PUBG Mobile VIP', 'tai-khoan-pubg-mobile-vip', 'Tài khoản PUBG Mobile cấp VIP với skin hiếm và vũ khí mạnh. Đảm bảo 100% chính chủ.', 250000, 'VND', TRUE, 'instant', 'Tức thì', 7, 'active', 4.5, 89, NOW(), NOW()),
(2, 'Adobe Photoshop 2024 Full', 'adobe-photoshop-2024-full', 'Phần mềm Adobe Photoshop 2024 bản full với license vĩnh viễn. Hỗ trợ cài đặt 24/7.', 1500000, 'VND', TRUE, 'instant', 'Tức thì', 30, 'active', 4.9, 234, NOW(), NOW()),
(2, 'Premium App Bundle', 'premium-app-bundle', 'Gói ứng dụng premium bao gồm: Spotify, Netflix, YouTube Premium, Canva Pro. Thời hạn 1 tháng.', 500000, 'VND', TRUE, 'instant', 'Tức thì', 7, 'active', 4.6, 78, NOW(), NOW()),
(2, 'Thẻ cào VinaPhone 200K', 'the-cao-vinaphone-200k', 'Thẻ cào VinaPhone mệnh giá 200,000 VNĐ. Tích điểm và nhận ưu đãi.', 195000, 'VND', TRUE, 'instant', 'Tức thì', 7, 'active', 4.7, 123, NOW(), NOW()),
(2, 'Tài khoản Genshin Impact', 'tai-khoan-genshin-impact', 'Tài khoản Genshin Impact cấp cao với nhân vật 5 sao và vũ khí mạnh. Server Asia.', 800000, 'VND', TRUE, 'instant', 'Tức thì', 7, 'active', 4.4, 67, NOW(), NOW()),
(2, 'Microsoft Office 2024', 'microsoft-office-2024', 'Bộ Microsoft Office 2024 full bao gồm Word, Excel, PowerPoint, Outlook. License vĩnh viễn.', 2000000, 'VND', TRUE, 'instant', 'Tức thì', 30, 'active', 4.8, 145, NOW(), NOW()),
(2, 'Template Website Responsive', 'template-website-responsive', 'Bộ template website responsive HTML/CSS/JS. Bao gồm 10 mẫu đẹp và code sạch.', 300000, 'VND', TRUE, 'instant', 'Tức thì', 7, 'active', 4.6, 45, NOW(), NOW());

-- Insert sample digital codes
INSERT INTO `digital_goods_codes` (`product_id`, `code_value`, `code_type`, `is_used`) VALUES
-- Viettel 100K cards
(1, 'VT100K001234567890', 'gift_card', FALSE),
(1, 'VT100K001234567891', 'gift_card', FALSE),
(1, 'VT100K001234567892', 'gift_card', FALSE),
(1, 'VT100K001234567893', 'gift_card', FALSE),
(1, 'VT100K001234567894', 'gift_card', FALSE),
-- PUBG Mobile accounts
(2, 'PUBG_ACCOUNT_001:Username:Player123|Password:Pass456|Level:50|Skins:RoyalPass', 'account', FALSE),
(2, 'PUBG_ACCOUNT_002:Username:ProGamer|Password:Game789|Level:45|Skins:ElitePass', 'account', FALSE),
(2, 'PUBG_ACCOUNT_003:Username:Winner2024|Password:Win123|Level:60|Skins:Premium', 'account', FALSE),
-- Adobe Photoshop licenses
(3, 'ADOBE_PS_2024_001:Serial:1234-5678-9012-3456|Activation:Online', 'license', FALSE),
(3, 'ADOBE_PS_2024_002:Serial:2345-6789-0123-4567|Activation:Online', 'license', FALSE),
(3, 'ADOBE_PS_2024_003:Serial:3456-7890-1234-5678|Activation:Online', 'license', FALSE),
-- App Bundle accounts
(4, 'APP_BUNDLE_001:Spotify:user1@email.com|Netflix:user1@email.com|YouTube:user1@email.com|Canva:user1@email.com', 'account', FALSE),
(4, 'APP_BUNDLE_002:Spotify:user2@email.com|Netflix:user2@email.com|YouTube:user2@email.com|Canva:user2@email.com', 'account', FALSE),
-- VinaPhone 200K cards
(5, 'VP200K001234567890', 'gift_card', FALSE),
(5, 'VP200K001234567891', 'gift_card', FALSE),
(5, 'VP200K001234567892', 'gift_card', FALSE),
-- Genshin Impact accounts
(6, 'GENSHIN_ACCOUNT_001:Username:GenshinPlayer|Password:Gen123|AR:55|Characters:5Star|Weapons:Legendary', 'account', FALSE),
(6, 'GENSHIN_ACCOUNT_002:Username:AnemoMaster|Password:Wind456|AR:50|Characters:5Star|Weapons:Epic', 'account', FALSE),
-- Microsoft Office licenses
(7, 'MS_OFFICE_2024_001:ProductKey:XXXXX-XXXXX-XXXXX-XXXXX-XXXXX|Activation:Online', 'license', FALSE),
(7, 'MS_OFFICE_2024_002:ProductKey:YYYYY-YYYYY-YYYYY-YYYYY-YYYYY|Activation:Online', 'license', FALSE),
-- Template files
(8, 'https://download.example.com/template-bundle-001.zip', 'file_url', FALSE),
(8, 'https://download.example.com/template-bundle-002.zip', 'file_url', FALSE);

-- Create indexes for better performance
-- Check if indexes exist before creating them
SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS 
     WHERE TABLE_SCHEMA = DATABASE() 
     AND TABLE_NAME = 'products' 
     AND INDEX_NAME = 'idx_products_digital') = 0,
    'CREATE INDEX `idx_products_digital` ON `products` (`is_digital`)',
    'SELECT "Index idx_products_digital already exists"'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS 
     WHERE TABLE_SCHEMA = DATABASE() 
     AND TABLE_NAME = 'products' 
     AND INDEX_NAME = 'idx_products_delivery') = 0,
    'CREATE INDEX `idx_products_delivery` ON `products` (`delivery_type`)',
    'SELECT "Index idx_products_delivery already exists"'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS 
     WHERE TABLE_SCHEMA = DATABASE() 
     AND TABLE_NAME = 'wishlist' 
     AND INDEX_NAME = 'idx_wishlist_user') = 0,
    'CREATE INDEX `idx_wishlist_user` ON `wishlist` (`user_id`)',
    'SELECT "Index idx_wishlist_user already exists"'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS 
     WHERE TABLE_SCHEMA = DATABASE() 
     AND TABLE_NAME = 'digital_goods_codes' 
     AND INDEX_NAME = 'idx_digital_codes_product') = 0,
    'CREATE INDEX `idx_digital_codes_product` ON `digital_goods_codes` (`product_id`)',
    'SELECT "Index idx_digital_codes_product already exists"'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS 
     WHERE TABLE_SCHEMA = DATABASE() 
     AND TABLE_NAME = 'digital_goods_codes' 
     AND INDEX_NAME = 'idx_digital_codes_used') = 0,
    'CREATE INDEX `idx_digital_codes_used` ON `digital_goods_codes` (`is_used`)',
    'SELECT "Index idx_digital_codes_used already exists"'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS 
     WHERE TABLE_SCHEMA = DATABASE() 
     AND TABLE_NAME = 'digital_goods_files' 
     AND INDEX_NAME = 'idx_digital_files_product') = 0,
    'CREATE INDEX `idx_digital_files_product` ON `digital_goods_files` (`product_id`)',
    'SELECT "Index idx_digital_files_product already exists"'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- ========================================
-- GOOGLE OAUTH AUTHENTICATION
-- ========================================

-- Create Google_Auth table for OAuth integration
CREATE TABLE IF NOT EXISTS `google_auth` (
    `google_auth_id` INT NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT NOT NULL,
    `google_id` VARCHAR(255) NOT NULL UNIQUE,
    `email` VARCHAR(255) NOT NULL,
    `name` VARCHAR(255) DEFAULT NULL,
    `picture_url` TEXT DEFAULT NULL,
    `access_token` TEXT DEFAULT NULL,
    `refresh_token` TEXT DEFAULT NULL,
    `token_expires_at` TIMESTAMP NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`google_auth_id`),
    KEY `user_id` (`user_id`),
    KEY `idx_google_auth_google_id` (`google_id`),
    CONSTRAINT `google_auth_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Add Google login fields to users table
SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
     WHERE TABLE_SCHEMA = DATABASE() 
     AND TABLE_NAME = 'users' 
     AND COLUMN_NAME = 'google_id') = 0,
    'ALTER TABLE `users` ADD COLUMN `google_id` VARCHAR(255) DEFAULT NULL AFTER `email`',
    'SELECT "Column google_id already exists"'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
     WHERE TABLE_SCHEMA = DATABASE() 
     AND TABLE_NAME = 'users' 
     AND COLUMN_NAME = 'auth_provider') = 0,
    'ALTER TABLE `users` ADD COLUMN `auth_provider` ENUM(''local'', ''google'', ''facebook'') DEFAULT ''local'' AFTER `google_id`',
    'SELECT "Column auth_provider already exists"'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Add unique constraint for google_id if it doesn't exist
SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS 
     WHERE TABLE_SCHEMA = DATABASE() 
     AND TABLE_NAME = 'users' 
     AND INDEX_NAME = 'google_id') = 0,
    'ALTER TABLE `users` ADD UNIQUE KEY `google_id` (`google_id`)',
    'SELECT "Unique key google_id already exists"'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Note: google_id already has UNIQUE KEY constraint above, no need for separate index

-- ========================================
-- DIGITAL GOODS MARKETPLACE ADDITIONS COMPLETE!
-- ========================================
-- Added features:
-- ✅ Digital codes management  
-- ✅ File downloads
-- ✅ User wishlist
-- ✅ Password reset functionality
-- ✅ Digital delivery system
-- ✅ Sample digital products and codes
-- ✅ Google OAuth authentication

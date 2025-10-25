-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: gicungco
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
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `product_id` bigint NOT NULL AUTO_INCREMENT,
  `seller_id` bigint DEFAULT NULL,
  `name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `price` decimal(15,2) NOT NULL,
  `currency` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'VND',
  `quantity` int DEFAULT '0',
  `is_digital` tinyint(1) DEFAULT '1',
  `delivery_type` enum('instant','manual','email') COLLATE utf8mb4_unicode_ci DEFAULT 'instant',
  `delivery_time` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'Tức thì',
  `warranty_days` int DEFAULT '7',
  `status` enum('draft','pending','approved','rejected','active','inactive') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
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
  KEY `idx_products_digital` (`is_digital`),
  KEY `idx_products_delivery` (`delivery_type`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`seller_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `products_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `product_categories` (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,2,'Thẻ cào Viettel 100K','the-cao-viettel-100k','Thẻ cào Viettel mệnh giá 100,000 VNĐ. Giao ngay sau khi thanh toán.',95000.00,'VND',0,1,'instant','Tức thì',7,'active',NULL,4.80,156,'2025-10-18 10:38:37','2025-10-18 10:38:37',NULL),(2,2,'Tài khoản PUBG Mobile VIP','tai-khoan-pubg-mobile-vip','Tài khoản PUBG Mobile cấp VIP với skin hiếm và vũ khí mạnh. Đảm bảo 100% chính chủ.',250000.00,'VND',0,1,'instant','Tức thì',7,'active',NULL,4.50,89,'2025-10-18 10:38:37','2025-10-18 10:38:37',NULL),(3,2,'Adobe Photoshop 2024 Full','adobe-photoshop-2024-full','Phần mềm Adobe Photoshop 2024 bản full với license vĩnh viễn. Hỗ trợ cài đặt 24/7.',1500000.00,'VND',0,1,'instant','Tức thì',30,'active',NULL,4.90,234,'2025-10-18 10:38:37','2025-10-18 10:38:37',NULL),(4,2,'Premium App Bundle','premium-app-bundle','Gói ứng dụng premium bao gồm: Spotify, Netflix, YouTube Premium, Canva Pro. Thời hạn 1 tháng.',500000.00,'VND',0,1,'instant','Tức thì',7,'active',NULL,4.60,78,'2025-10-18 10:38:37','2025-10-18 10:38:37',NULL),(5,2,'Thẻ cào VinaPhone 200K','the-cao-vinaphone-200k','Thẻ cào VinaPhone mệnh giá 200,000 VNĐ. Tích điểm và nhận ưu đãi.',195000.00,'VND',0,1,'instant','Tức thì',7,'active',NULL,4.70,123,'2025-10-18 10:38:37','2025-10-18 10:38:37',NULL),(6,2,'Tài khoản Genshin Impact','tai-khoan-genshin-impact','Tài khoản Genshin Impact cấp cao với nhân vật 5 sao và vũ khí mạnh. Server Asia.',800000.00,'VND',0,1,'instant','Tức thì',7,'active',NULL,4.40,67,'2025-10-18 10:38:37','2025-10-18 10:38:37',NULL),(7,2,'Microsoft Office 2024','microsoft-office-2024','Bộ Microsoft Office 2024 full bao gồm Word, Excel, PowerPoint, Outlook. License vĩnh viễn.',2000000.00,'VND',0,1,'instant','Tức thì',30,'active',NULL,4.80,145,'2025-10-18 10:38:37','2025-10-18 10:38:37',NULL),(8,2,'Template Website Responsive','template-website-responsive','Bộ template website responsive HTML/CSS/JS. Bao gồm 10 mẫu đẹp và code sạch.',300000.00,'VND',0,1,'instant','Tức thì',7,'active',NULL,4.60,45,'2025-10-18 10:38:37','2025-10-18 10:38:37',NULL);
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-10-22 11:55:22

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
-- Table structure for table `digital_goods_codes`
--

DROP TABLE IF EXISTS `digital_goods_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `digital_goods_codes` (
  `code_id` int NOT NULL AUTO_INCREMENT,
  `product_id` bigint NOT NULL,
  `code_value` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `code_type` enum('serial','account','license','gift_card','file_url') COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_used` tinyint(1) DEFAULT '0',
  `used_by` bigint DEFAULT NULL,
  `used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`code_id`),
  KEY `product_id` (`product_id`),
  KEY `is_used` (`is_used`),
  KEY `used_by` (`used_by`),
  KEY `idx_digital_codes_product` (`product_id`),
  KEY `idx_digital_codes_used` (`is_used`),
  CONSTRAINT `digital_goods_codes_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE,
  CONSTRAINT `digital_goods_codes_ibfk_2` FOREIGN KEY (`used_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `digital_goods_codes`
--

LOCK TABLES `digital_goods_codes` WRITE;
/*!40000 ALTER TABLE `digital_goods_codes` DISABLE KEYS */;
INSERT INTO `digital_goods_codes` VALUES (1,1,'VT100K001234567890','gift_card',0,NULL,NULL,NULL,'2025-10-18 03:38:37','2025-10-18 03:38:37'),(2,1,'VT100K001234567891','gift_card',0,NULL,NULL,NULL,'2025-10-18 03:38:37','2025-10-18 03:38:37'),(3,1,'VT100K001234567892','gift_card',0,NULL,NULL,NULL,'2025-10-18 03:38:37','2025-10-18 03:38:37'),(4,1,'VT100K001234567893','gift_card',0,NULL,NULL,NULL,'2025-10-18 03:38:37','2025-10-18 03:38:37'),(5,1,'VT100K001234567894','gift_card',0,NULL,NULL,NULL,'2025-10-18 03:38:37','2025-10-18 03:38:37'),(6,2,'PUBG_ACCOUNT_001:Username:Player123|Password:Pass456|Level:50|Skins:RoyalPass','account',0,NULL,NULL,NULL,'2025-10-18 03:38:37','2025-10-18 03:38:37'),(7,2,'PUBG_ACCOUNT_002:Username:ProGamer|Password:Game789|Level:45|Skins:ElitePass','account',0,NULL,NULL,NULL,'2025-10-18 03:38:37','2025-10-18 03:38:37'),(8,2,'PUBG_ACCOUNT_003:Username:Winner2024|Password:Win123|Level:60|Skins:Premium','account',0,NULL,NULL,NULL,'2025-10-18 03:38:37','2025-10-18 03:38:37'),(9,3,'ADOBE_PS_2024_001:Serial:1234-5678-9012-3456|Activation:Online','license',0,NULL,NULL,NULL,'2025-10-18 03:38:37','2025-10-18 03:38:37'),(10,3,'ADOBE_PS_2024_002:Serial:2345-6789-0123-4567|Activation:Online','license',0,NULL,NULL,NULL,'2025-10-18 03:38:37','2025-10-18 03:38:37'),(11,3,'ADOBE_PS_2024_003:Serial:3456-7890-1234-5678|Activation:Online','license',0,NULL,NULL,NULL,'2025-10-18 03:38:37','2025-10-18 03:38:37'),(12,4,'APP_BUNDLE_001:Spotify:user1@email.com|Netflix:user1@email.com|YouTube:user1@email.com|Canva:user1@email.com','account',0,NULL,NULL,NULL,'2025-10-18 03:38:37','2025-10-18 03:38:37'),(13,4,'APP_BUNDLE_002:Spotify:user2@email.com|Netflix:user2@email.com|YouTube:user2@email.com|Canva:user2@email.com','account',0,NULL,NULL,NULL,'2025-10-18 03:38:37','2025-10-18 03:38:37'),(14,5,'VP200K001234567890','gift_card',0,NULL,NULL,NULL,'2025-10-18 03:38:37','2025-10-18 03:38:37'),(15,5,'VP200K001234567891','gift_card',0,NULL,NULL,NULL,'2025-10-18 03:38:37','2025-10-18 03:38:37'),(16,5,'VP200K001234567892','gift_card',0,NULL,NULL,NULL,'2025-10-18 03:38:37','2025-10-18 03:38:37'),(17,6,'GENSHIN_ACCOUNT_001:Username:GenshinPlayer|Password:Gen123|AR:55|Characters:5Star|Weapons:Legendary','account',0,NULL,NULL,NULL,'2025-10-18 03:38:37','2025-10-18 03:38:37'),(18,6,'GENSHIN_ACCOUNT_002:Username:AnemoMaster|Password:Wind456|AR:50|Characters:5Star|Weapons:Epic','account',0,NULL,NULL,NULL,'2025-10-18 03:38:37','2025-10-18 03:38:37'),(19,7,'MS_OFFICE_2024_001:ProductKey:XXXXX-XXXXX-XXXXX-XXXXX-XXXXX|Activation:Online','license',0,NULL,NULL,NULL,'2025-10-18 03:38:37','2025-10-18 03:38:37'),(20,7,'MS_OFFICE_2024_002:ProductKey:YYYYY-YYYYY-YYYYY-YYYYY-YYYYY|Activation:Online','license',0,NULL,NULL,NULL,'2025-10-18 03:38:37','2025-10-18 03:38:37'),(21,8,'https://download.example.com/template-bundle-001.zip','file_url',0,NULL,NULL,NULL,'2025-10-18 03:38:37','2025-10-18 03:38:37'),(22,8,'https://download.example.com/template-bundle-002.zip','file_url',0,NULL,NULL,NULL,'2025-10-18 03:38:37','2025-10-18 03:38:37');
/*!40000 ALTER TABLE `digital_goods_codes` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-10-22 11:55:20

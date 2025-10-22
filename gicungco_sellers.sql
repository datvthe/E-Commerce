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
-- Table structure for table `sellers`
--

DROP TABLE IF EXISTS `sellers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sellers` (
  `seller_id` int NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `shop_name` varchar(150) NOT NULL,
  `shop_description` text,
  `main_category` varchar(100) DEFAULT NULL,
  `bank_name` varchar(100) DEFAULT NULL,
  `bank_account` varchar(50) DEFAULT NULL,
  `account_owner` varchar(100) DEFAULT NULL,
  `id_card_front` varchar(255) DEFAULT NULL,
  `id_card_back` varchar(255) DEFAULT NULL,
  `selfie_with_id` varchar(255) DEFAULT NULL,
  `deposit_amount` decimal(12,2) DEFAULT '0.00',
  `deposit_status` enum('UNPAID','PAID','REFUNDED') DEFAULT 'UNPAID',
  `deposit_proof` varchar(255) DEFAULT NULL,
  `status` enum('PENDING','APPROVED','REJECTED') DEFAULT 'PENDING',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`seller_id`),
  KEY `fk_seller_user` (`user_id`),
  CONSTRAINT `fk_seller_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sellers`
--

LOCK TABLES `sellers` WRITE;
/*!40000 ALTER TABLE `sellers` DISABLE KEYS */;
INSERT INTO `sellers` VALUES (1,11,'Phan Trung Sơn','chxon2011@gmail.com','0867268890','Tson','ưeqwe','Tài khoản game','VCB','4657982432','PHAN TRUNG SON',NULL,NULL,NULL,500000.00,'PAID','PhanTrungSon_HE191342.jpg','PENDING','2025-10-18 07:24:23','2025-10-21 05:46:44'),(2,11,'Phan Trung Sơn','chxon2011@gmail.com','0867268890','Tson','ewq','','VCB','4657982432','PHAN TRUNG SON',NULL,NULL,NULL,500000.00,'PAID','PhanTrungSon_HE191342.jpg','PENDING','2025-10-18 07:27:28','2025-10-21 05:46:44'),(3,11,'Phan Trung Sơn','chxon2011@gmail.com','0867268890','Tson','dá','Tài khoản game','VCB','4657982432','PHAN TRUNG SON',NULL,NULL,NULL,500000.00,'PAID','PhanTrungSon_HE191342.jpg','PENDING','2025-10-18 07:30:03','2025-10-21 05:46:44'),(4,11,'Phan Trung Sơn','chxon2011@gmail.com','0867268890','Tson','ád','Mã phim, phần mềm','VCB','4657982432','PHAN TRUNG SON',NULL,NULL,NULL,500000.00,'PAID','PhanTrungSon_HE191342.jpg','PENDING','2025-10-18 07:34:02','2025-10-21 05:46:44'),(5,11,'Phan Trung Sơn','chxon2011@gmail.com','0867268890','Tson','ádasd','Thẻ cào, giftcode','VCB','4657982432','PHAN TRUNG SON',NULL,NULL,NULL,500000.00,'PAID','PhanTrungSon_HE191342.jpg','PENDING','2025-10-18 07:36:01','2025-10-21 05:46:44'),(6,11,'Phan Trung Sơn','chxon2011@gmail.com','0867268890','Tson','acc lq','Tài khoản game','VCB','4657982432','PHAN TRUNG SON',NULL,NULL,NULL,500000.00,'PAID','PhanTrungSon_HE191342.jpg','PENDING','2025-10-18 07:40:04','2025-10-21 05:46:44'),(7,11,'Phan Trung Sơn','chxon2011@gmail.com','0867268890','Tson','dgf','Tài khoản game','VCB','4657982432','PHAN TRUNG SON',NULL,NULL,NULL,500000.00,'PAID','PhanTrungSon_HE191342.jpg','PENDING','2025-10-18 07:44:17','2025-10-21 05:46:44'),(8,11,'Phan Trung Sơn','chxon2011@gmail.com','0867268890','Tson','dgf','Tài khoản game','VCB','4657982432','PHAN TRUNG SON',NULL,NULL,NULL,500000.00,'PAID','PhanTrungSon_HE191342.jpg','PENDING','2025-10-18 07:44:44','2025-10-21 05:46:44'),(9,11,'Phan Trung Sơn','chxon2011@gmail.com','0867268890','Tson','ádasd','Thẻ cào, giftcode','VCB','4657982432','PHAN TRUNG SON',NULL,NULL,NULL,500000.00,'PAID','PhanTrungSon_HE191342.jpg','PENDING','2025-10-18 07:44:55','2025-10-21 05:46:44'),(10,11,'Phan Trung Sơn','chxon2011@gmail.com','0867268890','Tson','áddsa','Tài khoản game','VCB','4657982432','PHAN TRUNG SON',NULL,NULL,NULL,500000.00,'PAID','PhanTrungSon_HE191342.jpg','PENDING','2025-10-18 07:46:32','2025-10-21 05:46:44'),(11,11,'Phan Trung Sơn','chxon2011@gmail.com','0867268890','Tson','ádads','Tài khoản game','VCB','4657982432','PHAN TRUNG SON',NULL,NULL,NULL,500000.00,'PAID','PhanTrungSon_HE191342.jpg','PENDING','2025-10-18 07:48:19','2025-10-21 05:46:44'),(12,11,'Phan Trung Sơn','chxon2011@gmail.com','0867268890','Tson','sdadsad','Mã phim, phần mềm','VCB','4657982432','PHAN TRUNG SON',NULL,NULL,NULL,500000.00,'PAID','PhanTrungSon_HE191342.jpg','PENDING','2025-10-18 07:51:22','2025-10-21 05:46:44'),(13,11,'Phan Trung Sơn','chxon2011@gmail.com','0867268890','Tson','áddsa','Tài khoản game','VCB','4657982432','PHAN TRUNG SON',NULL,NULL,NULL,500000.00,'PAID','PhanTrungSon_HE191342.jpg','PENDING','2025-10-18 07:52:32','2025-10-21 05:46:44'),(14,11,'Phan Trung Sơn','chxon2011@gmail.com','0867268890','Tson','acc lol','Tài khoản game','VCB','4657982432','PHAN TRUNG SON',NULL,NULL,NULL,500000.00,'PAID','PhanTrungSon_HE191342.jpg','PENDING','2025-10-18 07:54:52','2025-10-21 05:46:44'),(15,11,'Phan Trung Sơn','chxon2011@gmail.com','0867268890','Tson','áddas','Tài khoản game','VCB','4657982432','PHAN TRUNG SON',NULL,NULL,NULL,500000.00,'PAID','PhanTrungSon_HE191342.jpg','PENDING','2025-10-18 07:56:47','2025-10-21 05:46:44'),(16,11,'Phan Trung Sơn','chxon2011@gmail.com','0867268890','Tson','ád','Tài khoản game','VCB','4657982432','PHAN TRUNG SON',NULL,NULL,NULL,500000.00,'PAID','PhanTrungSon_HE191342.jpg','PENDING','2025-10-21 05:46:35','2025-10-21 05:46:44'),(17,15,'Dâu','lunapanofficial@gmail.com','0926598668','Tson','ád','Tài khoản game','VCB','4657982432','PHAN TRUNG SON',NULL,NULL,NULL,200000.00,'PAID',NULL,'PENDING','2025-10-22 02:06:47','2025-10-22 02:06:47'),(18,15,'Phan Trung Sơn','chxon2011@gmail.com','0867268890','á','ád','Tài khoản game','đá','ád','PHAN TRUNG SON',NULL,NULL,NULL,200000.00,'PAID',NULL,'PENDING','2025-10-22 02:07:36','2025-10-22 02:07:36'),(19,15,'Phan Trung Sơn','chxon2011@gmail.com','0867268890','á','fdfsf','Tài khoản game','đá','ád','PHAN TRUNG SON',NULL,NULL,NULL,200000.00,'PAID',NULL,'PENDING','2025-10-22 02:48:37','2025-10-22 02:48:37'),(20,15,'Phan Trung Sơn','chxon2011@gmail.com','0867268890','á','ád','Tài khoản game','đá','ád','PHAN TRUNG SON',NULL,NULL,NULL,200000.00,'PAID',NULL,'PENDING','2025-10-22 02:51:13','2025-10-22 02:51:13');
/*!40000 ALTER TABLE `sellers` ENABLE KEYS */;
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

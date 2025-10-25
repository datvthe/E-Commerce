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
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` bigint NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gender` enum('male','female','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `address` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `avatar_url` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `default_role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('active','inactive','banned','pending') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `email_verified` tinyint(1) DEFAULT '0',
  `balance` double DEFAULT '0',
  `last_login_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Admin User','admin@example.com','hashed_password_1','0901234567','male','1990-01-01','Ha Noi, Vietnam',NULL,'admin','active',1,0,NULL,'2025-09-20 10:36:31','2025-09-20 10:36:31',NULL),(2,'Seller One','seller1@example.com','hashed_password_2','0901234568','female','1992-03-15','Ho Chi Minh City, Vietnam',NULL,'seller','active',1,0,NULL,'2025-09-20 10:36:31','2025-09-20 10:36:31',NULL),(3,'Customer One','customer1@example.com','hashed_password_3','0901234569','male','1995-06-20','Da Nang, Vietnam',NULL,'customer','active',1,0,NULL,'2025-09-20 10:36:31','2025-09-20 10:36:31',NULL),(4,'Moderator One','moderator1@example.com','hashed_password_4','0901234570','female','1988-12-10','Can Tho, Vietnam',NULL,'moderator','active',1,0,NULL,'2025-09-20 10:36:31','2025-09-20 10:36:31',NULL),(10,'Nguyen Van Admin 2','admin2@example.com','hashed_password_admin2','0909876543','male','1992-02-02','456 Đường XYZ, Quận 2, TP.HCM','https://example.com/avatar/admin2.png','admin','active',1,0,'2025-09-20 10:54:14','2025-09-20 10:54:14','2025-09-20 10:54:14',NULL),(11,'Phan Trung Sơn','chxon2011@gmail.com','D2pnshentCTufPAWYeWfx/XNCs/ig2pSksBkIYkR/28=:L47OfYlKWOUCfw89JUfTXQ==','0867268890',NULL,NULL,'Hòa Lạc','/WEBGMS/uploads/avatars/1761033262055_PhanTrungSon_HE191342.jpg',NULL,'active',0,0,NULL,'2025-10-18 11:30:15','2025-10-21 19:27:23',NULL),(12,'Nguyen MInh Anh','hagumi32@gmail.com','dAK1ppHIcKaU3M4obQXU2rljIa3DqvhECSQLM2Xkn/8=:vy706ykr9N864jvR07fU7A==','0353254218',NULL,NULL,'ád','/WEBGMS/uploads/avatars/1761031782279_Screenshot 2025-10-20 165618.png','customer','active',0,0,NULL,'2025-10-21 12:58:29','2025-10-21 14:29:42',NULL),(13,'Dâu','lunapanofficial@gmail.com','M78y9wbmWiwClVbnPPhtmwcTO6PIN4VUba57ooKwlCo=:vZI3KgW1vdxLKyaI7LkffA==','0926598668',NULL,NULL,NULL,NULL,'customer','active',0,0,NULL,'2025-10-21 20:00:12','2025-10-22 07:29:54',NULL),(14,'Sơn','manhboo20@gmail.com','cgSmb5yx0DswBCLryA5Jq+hrvgSts5Tajqyq91hq08E=:ttC8a0pTWdvX5zsWEb8K8g==','0798171831',NULL,NULL,NULL,NULL,'customer','active',0,0,NULL,'2025-10-22 07:37:52','2025-10-22 07:43:38',NULL),(15,'Sơn','manhboo2@gmail.com','QUFebr0qKxGRFCmWlE3rYIa9nma8dJa0XU7NBfsti90=:lh8i+5AeQFmNcVQMpxfHMQ==','0798171832',NULL,NULL,'Hola','/WEBGMS/uploads/avatars/1761096807076_PhanTrungSon_HE191342.jpg','customer','active',0,0,NULL,'2025-10-22 08:18:30','2025-10-22 08:35:59',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-10-22 11:55:21

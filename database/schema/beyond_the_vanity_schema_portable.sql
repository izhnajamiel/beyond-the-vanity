-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: localhost    Database: beyond_the_vanity
-- ------------------------------------------------------
-- Server version	8.0.44

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
-- Table structure for table `app_users`
--

DROP TABLE IF EXISTS `app_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `app_users` (
  `user_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `full_name` varchar(255) NOT NULL,
  `email` varchar(320) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `user_role` enum('COMPANY_ADMIN','STAFF','PROJECT_ADMIN') NOT NULL DEFAULT 'STAFF',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uq_app_users_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `audit_logs`
--

DROP TABLE IF EXISTS `audit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_logs` (
  `audit_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned DEFAULT NULL,
  `action_type` enum('CREATE','UPDATE','DELETE','IMPORT','LOGIN','OTHER') NOT NULL,
  `table_name` varchar(100) NOT NULL,
  `record_key` varchar(255) DEFAULT NULL,
  `action_details` json DEFAULT NULL,
  `action_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`audit_id`),
  KEY `idx_audit_user` (`user_id`),
  KEY `idx_audit_table_record` (`table_name`,`record_key`),
  KEY `idx_audit_timestamp` (`action_timestamp`),
  CONSTRAINT `fk_audit_user` FOREIGN KEY (`user_id`) REFERENCES `app_users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `brands`
--

DROP TABLE IF EXISTS `brands`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `brands` (
  `brand_id` bigint unsigned NOT NULL,
  `brand_name` varchar(500) NOT NULL,
  `company_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`brand_id`),
  KEY `idx_brands_name` (`brand_name`),
  KEY `fk_brands_company` (`company_id`),
  CONSTRAINT `fk_brands_company` FOREIGN KEY (`company_id`) REFERENCES `companies` (`company_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cas_identifiers`
--

DROP TABLE IF EXISTS `cas_identifiers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cas_identifiers` (
  `cas_id` bigint unsigned NOT NULL,
  `cas_number` varchar(50) NOT NULL,
  PRIMARY KEY (`cas_id`),
  KEY `idx_cas_number` (`cas_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chemical_reports`
--

DROP TABLE IF EXISTS `chemical_reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chemical_reports` (
  `source_record_id` bigint unsigned NOT NULL,
  `product_id` bigint unsigned NOT NULL,
  `company_id` bigint unsigned NOT NULL,
  `brand_name_source` varchar(500) DEFAULT NULL,
  `primary_category_id` bigint unsigned NOT NULL,
  `subcategory_id` bigint unsigned DEFAULT NULL,
  `csf_id` bigint unsigned DEFAULT NULL,
  `source_chemical_record_id` bigint unsigned DEFAULT NULL,
  `chemical_id` bigint unsigned NOT NULL,
  `chemical_name_source` varchar(500) DEFAULT NULL,
  `cas_id` bigint unsigned NOT NULL,
  `cas_number_source` varchar(50) DEFAULT NULL,
  `initial_date_reported` date DEFAULT NULL,
  `most_recent_date_reported` date DEFAULT NULL,
  `discontinued_date` date DEFAULT NULL,
  `chemical_created_at` date DEFAULT NULL,
  `chemical_updated_at` date DEFAULT NULL,
  `chemical_date_removed_original` varchar(30) DEFAULT NULL,
  `chemical_count` int unsigned DEFAULT NULL,
  `chemical_date_removed_cleaned` date DEFAULT NULL,
  `record_origin` enum('CSCP_IMPORT','COMPANY_ENTERED') NOT NULL DEFAULT 'CSCP_IMPORT',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`source_record_id`),
  KEY `idx_reports_product` (`product_id`),
  KEY `idx_reports_chemical` (`chemical_id`),
  KEY `idx_reports_company` (`company_id`),
  KEY `idx_reports_initial_date` (`initial_date_reported`),
  KEY `idx_reports_discontinued` (`discontinued_date`),
  KEY `idx_reports_removed_cleaned` (`chemical_date_removed_cleaned`),
  KEY `fk_reports_category` (`primary_category_id`),
  KEY `fk_reports_subcategory` (`subcategory_id`),
  KEY `fk_reports_csf` (`csf_id`),
  KEY `fk_reports_cas` (`cas_id`),
  CONSTRAINT `fk_reports_cas` FOREIGN KEY (`cas_id`) REFERENCES `cas_identifiers` (`cas_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_reports_category` FOREIGN KEY (`primary_category_id`) REFERENCES `primary_categories` (`primary_category_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_reports_chemical` FOREIGN KEY (`chemical_id`) REFERENCES `chemicals` (`chemical_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_reports_company` FOREIGN KEY (`company_id`) REFERENCES `companies` (`company_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_reports_csf` FOREIGN KEY (`csf_id`) REFERENCES `csf_descriptions` (`csf_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_reports_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_reports_subcategory` FOREIGN KEY (`subcategory_id`) REFERENCES `subcategories` (`subcategory_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chemicals`
--

DROP TABLE IF EXISTS `chemicals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chemicals` (
  `chemical_id` bigint unsigned NOT NULL,
  `chemical_name` varchar(500) NOT NULL,
  PRIMARY KEY (`chemical_id`),
  KEY `idx_chemicals_name` (`chemical_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `companies`
--

DROP TABLE IF EXISTS `companies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `companies` (
  `company_id` bigint unsigned NOT NULL,
  `company_name` varchar(500) NOT NULL,
  PRIMARY KEY (`company_id`),
  KEY `idx_companies_name` (`company_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `csf_descriptions`
--

DROP TABLE IF EXISTS `csf_descriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `csf_descriptions` (
  `csf_id` bigint unsigned NOT NULL,
  `csf_description` text,
  PRIMARY KEY (`csf_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `primary_categories`
--

DROP TABLE IF EXISTS `primary_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `primary_categories` (
  `primary_category_id` bigint unsigned NOT NULL,
  `primary_category` varchar(255) NOT NULL,
  PRIMARY KEY (`primary_category_id`),
  UNIQUE KEY `uq_primary_category_name` (`primary_category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_chemical`
--

DROP TABLE IF EXISTS `product_chemical`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_chemical` (
  `product_chemical_id` bigint unsigned NOT NULL,
  `product_id` bigint unsigned NOT NULL,
  `chemical_id` bigint unsigned NOT NULL,
  `cas_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`product_chemical_id`),
  KEY `idx_product_chemical_product` (`product_id`),
  KEY `idx_product_chemical_chemical` (`chemical_id`),
  KEY `idx_product_chemical_cas` (`cas_id`),
  CONSTRAINT `fk_product_chemical_cas` FOREIGN KEY (`cas_id`) REFERENCES `cas_identifiers` (`cas_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_product_chemical_chemical` FOREIGN KEY (`chemical_id`) REFERENCES `chemicals` (`chemical_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_product_chemical_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `product_id` bigint unsigned NOT NULL,
  `product_name` text NOT NULL,
  `company_id` bigint unsigned NOT NULL,
  `brand_id` bigint unsigned DEFAULT NULL,
  `brand_name_source` varchar(500) DEFAULT NULL,
  `primary_category_id` bigint unsigned NOT NULL,
  `subcategory_id` bigint unsigned DEFAULT NULL,
  `csf_id` bigint unsigned DEFAULT NULL,
  `record_origin` enum('CSCP_IMPORT','COMPANY_ENTERED') NOT NULL DEFAULT 'CSCP_IMPORT',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`product_id`),
  KEY `idx_products_name` (`product_name`(191)),
  KEY `idx_products_company` (`company_id`),
  KEY `idx_products_brand` (`brand_id`),
  KEY `idx_products_category` (`primary_category_id`),
  KEY `fk_products_subcategory` (`subcategory_id`),
  KEY `fk_products_csf` (`csf_id`),
  CONSTRAINT `fk_products_brand` FOREIGN KEY (`brand_id`) REFERENCES `brands` (`brand_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_products_category` FOREIGN KEY (`primary_category_id`) REFERENCES `primary_categories` (`primary_category_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_products_company` FOREIGN KEY (`company_id`) REFERENCES `companies` (`company_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_products_csf` FOREIGN KEY (`csf_id`) REFERENCES `csf_descriptions` (`csf_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_products_subcategory` FOREIGN KEY (`subcategory_id`) REFERENCES `subcategories` (`subcategory_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stg_brands`
--

DROP TABLE IF EXISTS `stg_brands`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stg_brands` (
  `brand_id` varchar(2000) DEFAULT NULL,
  `brand_name` varchar(2000) DEFAULT NULL,
  `company_id` varchar(2000) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stg_cas_identifiers`
--

DROP TABLE IF EXISTS `stg_cas_identifiers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stg_cas_identifiers` (
  `cas_id` varchar(2000) DEFAULT NULL,
  `cas_number` varchar(2000) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stg_chemical_reports`
--

DROP TABLE IF EXISTS `stg_chemical_reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stg_chemical_reports` (
  `source_record_id` text,
  `product_id` text,
  `company_id` text,
  `brand_name` text,
  `primary_category_id` text,
  `subcategory_id` text,
  `csf_id` text,
  `source_chemical_record_id` text,
  `chemical_id` text,
  `chemical_name` text,
  `cas_id` text,
  `cas_number` text,
  `initial_date_reported` text,
  `most_recent_date_reported` text,
  `discontinued_date` text,
  `chemical_created_at` text,
  `chemical_updated_at` text,
  `chemical_date_removed` text,
  `chemical_count` text,
  `chemical_date_removed_cleaned` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stg_chemicals`
--

DROP TABLE IF EXISTS `stg_chemicals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stg_chemicals` (
  `chemical_id` varchar(2000) DEFAULT NULL,
  `chemical_name` varchar(2000) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stg_companies`
--

DROP TABLE IF EXISTS `stg_companies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stg_companies` (
  `company_id` varchar(2000) DEFAULT NULL,
  `company_name` varchar(2000) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stg_csf_descriptions`
--

DROP TABLE IF EXISTS `stg_csf_descriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stg_csf_descriptions` (
  `csf_id` varchar(2000) DEFAULT NULL,
  `csf_description` varchar(2000) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stg_primary_categories`
--

DROP TABLE IF EXISTS `stg_primary_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stg_primary_categories` (
  `primary_category_id` varchar(2000) DEFAULT NULL,
  `primary_category` varchar(2000) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stg_product_chemical`
--

DROP TABLE IF EXISTS `stg_product_chemical`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stg_product_chemical` (
  `product_chemical_id` text,
  `product_id` text,
  `chemical_id` text,
  `cas_id` text,
  `cas_number` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stg_products`
--

DROP TABLE IF EXISTS `stg_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stg_products` (
  `product_id` varchar(2000) DEFAULT NULL,
  `product_name` varchar(2000) DEFAULT NULL,
  `company_id` varchar(2000) DEFAULT NULL,
  `brand_id` varchar(2000) DEFAULT NULL,
  `brand_name` varchar(2000) DEFAULT NULL,
  `primary_category_id` varchar(2000) DEFAULT NULL,
  `subcategory_id` varchar(2000) DEFAULT NULL,
  `csf_id` varchar(2000) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stg_subcategories`
--

DROP TABLE IF EXISTS `stg_subcategories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stg_subcategories` (
  `subcategory_id` varchar(2000) DEFAULT NULL,
  `subcategory` varchar(2000) DEFAULT NULL,
  `primary_category_id` varchar(2000) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `subcategories`
--

DROP TABLE IF EXISTS `subcategories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subcategories` (
  `subcategory_id` bigint unsigned NOT NULL,
  `subcategory` varchar(500) NOT NULL,
  `primary_category_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`subcategory_id`),
  KEY `idx_subcategories_name` (`subcategory`),
  KEY `fk_subcategories_category` (`primary_category_id`),
  CONSTRAINT `fk_subcategories_category` FOREIGN KEY (`primary_category_id`) REFERENCES `primary_categories` (`primary_category_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `vw_brand_summary`
--

DROP TABLE IF EXISTS `vw_brand_summary`;
/*!50001 DROP VIEW IF EXISTS `vw_brand_summary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_brand_summary` AS SELECT 
 1 AS `brand_id`,
 1 AS `brand_name`,
 1 AS `company_id`,
 1 AS `distinct_products`,
 1 AS `report_record_count`,
 1 AS `distinct_chemicals`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_category_summary`
--

DROP TABLE IF EXISTS `vw_category_summary`;
/*!50001 DROP VIEW IF EXISTS `vw_category_summary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_category_summary` AS SELECT 
 1 AS `primary_category_id`,
 1 AS `primary_category`,
 1 AS `report_record_count`,
 1 AS `distinct_products`,
 1 AS `distinct_chemicals`,
 1 AS `discontinued_records`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_chemical_frequency`
--

DROP TABLE IF EXISTS `vw_chemical_frequency`;
/*!50001 DROP VIEW IF EXISTS `vw_chemical_frequency`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_chemical_frequency` AS SELECT 
 1 AS `chemical_id`,
 1 AS `chemical_name`,
 1 AS `report_record_count`,
 1 AS `distinct_products`,
 1 AS `distinct_companies`,
 1 AS `distinct_cas_numbers`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_company_summary`
--

DROP TABLE IF EXISTS `vw_company_summary`;
/*!50001 DROP VIEW IF EXISTS `vw_company_summary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_company_summary` AS SELECT 
 1 AS `company_id`,
 1 AS `company_name`,
 1 AS `report_record_count`,
 1 AS `distinct_products`,
 1 AS `distinct_chemicals`,
 1 AS `discontinued_records`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_data_quality_summary`
--

DROP TABLE IF EXISTS `vw_data_quality_summary`;
/*!50001 DROP VIEW IF EXISTS `vw_data_quality_summary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_data_quality_summary` AS SELECT 
 1 AS `total_report_records`,
 1 AS `records_with_cas_number`,
 1 AS `records_without_cas_number`,
 1 AS `cas_coverage_percent`,
 1 AS `records_with_discontinued_date`,
 1 AS `records_without_discontinued_date`,
 1 AS `discontinued_date_coverage_percent`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_yearly_reporting_summary`
--

DROP TABLE IF EXISTS `vw_yearly_reporting_summary`;
/*!50001 DROP VIEW IF EXISTS `vw_yearly_reporting_summary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_yearly_reporting_summary` AS SELECT 
 1 AS `report_year`,
 1 AS `report_record_count`,
 1 AS `distinct_products`,
 1 AS `distinct_chemicals`,
 1 AS `distinct_companies`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `vw_brand_summary`
--

/*!50001 DROP VIEW IF EXISTS `vw_brand_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY DEFINER */
/*!50001 VIEW `vw_brand_summary` AS select `b`.`brand_id` AS `brand_id`,`b`.`brand_name` AS `brand_name`,`b`.`company_id` AS `company_id`,count(distinct `p`.`product_id`) AS `distinct_products`,count(`r`.`source_record_id`) AS `report_record_count`,count(distinct `r`.`chemical_id`) AS `distinct_chemicals` from ((`brands` `b` left join `products` `p` on((`p`.`brand_id` = `b`.`brand_id`))) left join `chemical_reports` `r` on((`r`.`product_id` = `p`.`product_id`))) group by `b`.`brand_id`,`b`.`brand_name`,`b`.`company_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_category_summary`
--

/*!50001 DROP VIEW IF EXISTS `vw_category_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY DEFINER */
/*!50001 VIEW `vw_category_summary` AS select `pc`.`primary_category_id` AS `primary_category_id`,`pc`.`primary_category` AS `primary_category`,count(`r`.`source_record_id`) AS `report_record_count`,count(distinct `r`.`product_id`) AS `distinct_products`,count(distinct `r`.`chemical_id`) AS `distinct_chemicals`,sum((`r`.`discontinued_date` is not null)) AS `discontinued_records` from (`primary_categories` `pc` left join `chemical_reports` `r` on((`r`.`primary_category_id` = `pc`.`primary_category_id`))) group by `pc`.`primary_category_id`,`pc`.`primary_category` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_chemical_frequency`
--

/*!50001 DROP VIEW IF EXISTS `vw_chemical_frequency`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY DEFINER */
/*!50001 VIEW `vw_chemical_frequency` AS select `c`.`chemical_id` AS `chemical_id`,`c`.`chemical_name` AS `chemical_name`,count(`r`.`source_record_id`) AS `report_record_count`,count(distinct `r`.`product_id`) AS `distinct_products`,count(distinct `r`.`company_id`) AS `distinct_companies`,count(distinct `r`.`cas_id`) AS `distinct_cas_numbers` from (`chemicals` `c` left join `chemical_reports` `r` on((`r`.`chemical_id` = `c`.`chemical_id`))) group by `c`.`chemical_id`,`c`.`chemical_name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_company_summary`
--

/*!50001 DROP VIEW IF EXISTS `vw_company_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY DEFINER */
/*!50001 VIEW `vw_company_summary` AS select `co`.`company_id` AS `company_id`,`co`.`company_name` AS `company_name`,count(`r`.`source_record_id`) AS `report_record_count`,count(distinct `r`.`product_id`) AS `distinct_products`,count(distinct `r`.`chemical_id`) AS `distinct_chemicals`,sum((`r`.`discontinued_date` is not null)) AS `discontinued_records` from (`companies` `co` left join `chemical_reports` `r` on((`r`.`company_id` = `co`.`company_id`))) group by `co`.`company_id`,`co`.`company_name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_data_quality_summary`
--

/*!50001 DROP VIEW IF EXISTS `vw_data_quality_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY DEFINER */
/*!50001 VIEW `vw_data_quality_summary` AS select count(0) AS `total_report_records`,sum(((`chemical_reports`.`cas_number_source` is not null) and (`chemical_reports`.`cas_number_source` <> ''))) AS `records_with_cas_number`,sum(((`chemical_reports`.`cas_number_source` is null) or (`chemical_reports`.`cas_number_source` = ''))) AS `records_without_cas_number`,round(((100 * sum(((`chemical_reports`.`cas_number_source` is not null) and (`chemical_reports`.`cas_number_source` <> '')))) / nullif(count(0),0)),2) AS `cas_coverage_percent`,sum((`chemical_reports`.`discontinued_date` is not null)) AS `records_with_discontinued_date`,sum((`chemical_reports`.`discontinued_date` is null)) AS `records_without_discontinued_date`,round(((100 * sum((`chemical_reports`.`discontinued_date` is not null))) / nullif(count(0),0)),2) AS `discontinued_date_coverage_percent` from `chemical_reports` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_yearly_reporting_summary`
--

/*!50001 DROP VIEW IF EXISTS `vw_yearly_reporting_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY DEFINER */
/*!50001 VIEW `vw_yearly_reporting_summary` AS select year(`chemical_reports`.`initial_date_reported`) AS `report_year`,count(0) AS `report_record_count`,count(distinct `chemical_reports`.`product_id`) AS `distinct_products`,count(distinct `chemical_reports`.`chemical_id`) AS `distinct_chemicals`,count(distinct `chemical_reports`.`company_id`) AS `distinct_companies` from `chemical_reports` where (`chemical_reports`.`initial_date_reported` is not null) group by year(`chemical_reports`.`initial_date_reported`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-20  2:55:38

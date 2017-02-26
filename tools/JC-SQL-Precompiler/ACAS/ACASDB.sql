-- MySQL dump 10.15  Distrib 10.0.29-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: localhost
-- ------------------------------------------------------
-- Server version	10.0.29-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ANALYSIS-REC`
--

DROP TABLE IF EXISTS `ANALYSIS-REC`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ANALYSIS-REC` (
  `PA-CODE` char(3) NOT NULL,
  `PA-GL` mediumint(6) unsigned NOT NULL,
  `PA-DESC` char(24) NOT NULL,
  `PA-PRINT` char(3) NOT NULL,
  PRIMARY KEY (`PA-CODE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ANALYSIS-REC`
--

LOCK TABLES `ANALYSIS-REC` WRITE;
/*!40000 ALTER TABLE `ANALYSIS-REC` DISABLE KEYS */;
/*!40000 ALTER TABLE `ANALYSIS-REC` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DELIVERY-RECORD`
--

DROP TABLE IF EXISTS `DELIVERY-RECORD`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DELIVERY-RECORD` (
  `DELIV-KEY` char(8) NOT NULL,
  `DELIV-NAME` char(30) NOT NULL,
  `DELIV-ADDRESS` char(96) NOT NULL,
  PRIMARY KEY (`DELIV-KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DELIVERY-RECORD`
--

LOCK TABLES `DELIVERY-RECORD` WRITE;
/*!40000 ALTER TABLE `DELIVERY-RECORD` DISABLE KEYS */;
/*!40000 ALTER TABLE `DELIVERY-RECORD` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `GLBATCH-REC`
--

DROP TABLE IF EXISTS `GLBATCH-REC`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `GLBATCH-REC` (
  `BATCH-KEY` mediumint(6) unsigned NOT NULL,
  `ITEMS` tinyint(2) unsigned NOT NULL,
  `BATCH-STATUS` tinyint(1) unsigned NOT NULL,
  `CLEARED-STATUS` tinyint(1) unsigned NOT NULL,
  `BCYCLE` tinyint(2) unsigned NOT NULL,
  `ENTERED` int(8) unsigned NOT NULL,
  `PROOFED` int(8) unsigned NOT NULL,
  `POSTED` int(8) unsigned NOT NULL,
  `STORED` int(8) unsigned NOT NULL,
  `INPUT-GROSS` decimal(14,2) unsigned NOT NULL,
  `INPUT-VAT` decimal(14,2) unsigned NOT NULL,
  `ACTUAL-GROSS` decimal(14,2) unsigned NOT NULL,
  `ACTUAL-VAT` decimal(14,2) unsigned NOT NULL,
  `DESCRIPTION` char(24) NOT NULL,
  `BDEFAULT` tinyint(2) unsigned NOT NULL,
  `CONVENTION` char(2) NOT NULL,
  `BATCH-DEF-AC` mediumint(6) unsigned NOT NULL,
  `BATCH-DEF-PC` tinyint(2) unsigned NOT NULL,
  `BATCH-DEF-CODE` char(2) NOT NULL,
  `BATCH-DEF-VAT` char(1) NOT NULL,
  `BATCH-START` mediumint(5) unsigned NOT NULL,
  PRIMARY KEY (`BATCH-KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GLBATCH-REC`
--

LOCK TABLES `GLBATCH-REC` WRITE;
/*!40000 ALTER TABLE `GLBATCH-REC` DISABLE KEYS */;
/*!40000 ALTER TABLE `GLBATCH-REC` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `GLLEDGER-REC`
--

DROP TABLE IF EXISTS `GLLEDGER-REC`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `GLLEDGER-REC` (
  `LEDGER-KEY` int(8) unsigned NOT NULL,
  `LEDGER-TYPE` tinyint(1) unsigned NOT NULL,
  `LEDGER-PLACE` char(1) NOT NULL,
  `LEDGER-LEVEL` tinyint(1) unsigned NOT NULL,
  `LEDGER-NAME` char(24) NOT NULL,
  `LEDGER-BALANCE` decimal(10,2) NOT NULL,
  `LEDGER-LAST` decimal(10,2) NOT NULL,
  `LEDGER-Q1` decimal(10,2) NOT NULL,
  `LEDGER-Q2` decimal(10,2) NOT NULL,
  `LEDGER-Q3` decimal(10,2) NOT NULL,
  `LEDGER-Q4` decimal(10,2) NOT NULL,
  PRIMARY KEY (`LEDGER-KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GLLEDGER-REC`
--

LOCK TABLES `GLLEDGER-REC` WRITE;
/*!40000 ALTER TABLE `GLLEDGER-REC` DISABLE KEYS */;
/*!40000 ALTER TABLE `GLLEDGER-REC` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `GLPOSTING-REC`
--

DROP TABLE IF EXISTS `GLPOSTING-REC`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `GLPOSTING-REC` (
  `POST-RRN` mediumint(5) unsigned NOT NULL COMMENT 'Rel. replacement',
  `POST-KEY` bigint(10) unsigned NOT NULL,
  `POST-CODE` char(2) NOT NULL,
  `POST-DAT` char(8) NOT NULL,
  `POST-DR` mediumint(6) unsigned NOT NULL,
  `DR-PC` tinyint(2) unsigned NOT NULL,
  `POST-CR` mediumint(6) unsigned NOT NULL,
  `CR-PC` tinyint(2) unsigned NOT NULL,
  `POST-AMOUNT` decimal(10,2) NOT NULL,
  `POST-LEGEND` char(32) NOT NULL,
  `VAT-AC` mediumint(6) unsigned NOT NULL,
  `VAT-PC` tinyint(2) unsigned NOT NULL,
  `POST-VAT-SIDE` char(2) NOT NULL,
  `VAT-AMOUNT` decimal(10,2) NOT NULL,
  PRIMARY KEY (`POST-RRN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GLPOSTING-REC`
--

LOCK TABLES `GLPOSTING-REC` WRITE;
/*!40000 ALTER TABLE `GLPOSTING-REC` DISABLE KEYS */;
/*!40000 ALTER TABLE `GLPOSTING-REC` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `IRSDFLT-REC`
--

DROP TABLE IF EXISTS `IRSDFLT-REC`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `IRSDFLT-REC` (
  `DEF-REC-KEY` tinyint(2) unsigned NOT NULL,
  `DEF-ACS` decimal(5,0) unsigned NOT NULL,
  `DEF-CODES` char(2) NOT NULL,
  `DEF-VAT` char(1) NOT NULL,
  PRIMARY KEY (`DEF-REC-KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Defaults table for IRS';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `IRSDFLT-REC`
--

LOCK TABLES `IRSDFLT-REC` WRITE;
/*!40000 ALTER TABLE `IRSDFLT-REC` DISABLE KEYS */;
/*!40000 ALTER TABLE `IRSDFLT-REC` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `IRSFINAL-REC`
--

DROP TABLE IF EXISTS `IRSFINAL-REC`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `IRSFINAL-REC` (
  `IRS-FINAL-ACC-REC-KEY` tinyint(2) unsigned NOT NULL,
  `IRS-AR1` char(24) NOT NULL,
  `IRS-AR2` char(1) NOT NULL,
  PRIMARY KEY (`IRS-FINAL-ACC-REC-KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `IRSFINAL-REC`
--

LOCK TABLES `IRSFINAL-REC` WRITE;
/*!40000 ALTER TABLE `IRSFINAL-REC` DISABLE KEYS */;
/*!40000 ALTER TABLE `IRSFINAL-REC` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `IRSNL-REC`
--

DROP TABLE IF EXISTS `IRSNL-REC`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `IRSNL-REC` (
  `KEY-1` bigint(10) unsigned NOT NULL,
  `TIPE` char(1) NOT NULL,
  `NL-NAME` char(24) NOT NULL,
  `DR` decimal(10,2) unsigned NOT NULL,
  `CR` decimal(10,2) unsigned NOT NULL,
  `DR-LAST-01` decimal(10,2) unsigned NOT NULL,
  `CR-LAST-01` decimal(10,2) unsigned NOT NULL,
  `DR-LAST-02` decimal(10,2) unsigned NOT NULL,
  `CR-LAST-02` decimal(10,2) unsigned NOT NULL,
  `DR-LAST-03` decimal(10,2) unsigned NOT NULL,
  `CR-LAST-03` decimal(10,2) unsigned NOT NULL,
  `DR-LAST-04` decimal(10,2) unsigned NOT NULL,
  `CR-LAST-04` decimal(10,2) unsigned NOT NULL,
  `AC` char(1) NOT NULL,
  `REC-POINTER` mediumint(5) unsigned NOT NULL,
  PRIMARY KEY (`KEY-1`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `IRSNL-REC`
--

LOCK TABLES `IRSNL-REC` WRITE;
/*!40000 ALTER TABLE `IRSNL-REC` DISABLE KEYS */;
/*!40000 ALTER TABLE `IRSNL-REC` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `IRSPOSTING-REC`
--

DROP TABLE IF EXISTS `IRSPOSTING-REC`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `IRSPOSTING-REC` (
  `KEY-4` mediumint(5) unsigned NOT NULL,
  `POST4-CODE` char(2) NOT NULL,
  `POST4-DAT` char(8) NOT NULL,
  `POST4-DAY` tinyint(2) unsigned NOT NULL,
  `POST4-MONTH` tinyint(2) unsigned NOT NULL,
  `POST4-YEAR` tinyint(2) unsigned NOT NULL,
  `POST4-DR` mediumint(5) unsigned NOT NULL,
  `POST4-CR` mediumint(5) unsigned NOT NULL,
  `POST4-AMOUNT` decimal(9,2) NOT NULL,
  `POST4-LEGEND` char(32) NOT NULL,
  `VAT-AC-DEF4` tinyint(2) unsigned NOT NULL,
  `POST4-VAT-SIDE` char(2) NOT NULL,
  `VAT-AMOUNT4` decimal(9,2) NOT NULL,
  PRIMARY KEY (`KEY-4`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `IRSPOSTING-REC`
--

LOCK TABLES `IRSPOSTING-REC` WRITE;
/*!40000 ALTER TABLE `IRSPOSTING-REC` DISABLE KEYS */;
/*!40000 ALTER TABLE `IRSPOSTING-REC` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PLPAY-REC`
--

DROP TABLE IF EXISTS `PLPAY-REC`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PLPAY-REC` (
  `PAY-KEY` char(9) NOT NULL,
  `PAY-CONT` char(1) NOT NULL,
  `PAY-DAT` int(8) unsigned NOT NULL,
  `PAY-CHEQUE` int(8) unsigned NOT NULL,
  `PAY-SORTCODE` int(6) unsigned NOT NULL,
  `PAY-ACCOUNT` int(8) unsigned NOT NULL,
  `PAY-GROSS` decimal(10,2) NOT NULL,
  PRIMARY KEY (`PAY-KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PLPAY-REC`
--

LOCK TABLES `PLPAY-REC` WRITE;
/*!40000 ALTER TABLE `PLPAY-REC` DISABLE KEYS */;
/*!40000 ALTER TABLE `PLPAY-REC` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PLPAY-RECrg01`
--

DROP TABLE IF EXISTS `PLPAY-RECrg01`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PLPAY-RECrg01` (
  `PAY-FOLIO` int(8) unsigned NOT NULL,
  `PAY-PERIOD` tinyint(2) unsigned NOT NULL,
  `PAY-VALUE` decimal(14,4) NOT NULL,
  `PAY-DEDUCT` decimal(14,4) NOT NULL,
  `PAY-INVOICE` char(10) NOT NULL,
  `LEVEL-J` tinyint(1) unsigned NOT NULL,
  `PAY-KEY` char(9) NOT NULL,
  PRIMARY KEY (`PAY-KEY`,`LEVEL-J`),
  UNIQUE KEY `PLPAY-RECrg01-IDX` (`PAY-KEY`,`LEVEL-J`),
  CONSTRAINT `PLPAY-RECrg01-ri` FOREIGN KEY (`PAY-KEY`) REFERENCES `PLPAY-REC` (`PAY-KEY`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PLPAY-RECrg01`
--

LOCK TABLES `PLPAY-RECrg01` WRITE;
/*!40000 ALTER TABLE `PLPAY-RECrg01` DISABLE KEYS */;
/*!40000 ALTER TABLE `PLPAY-RECrg01` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PSIRSPOST-REC`
--

DROP TABLE IF EXISTS `PSIRSPOST-REC`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PSIRSPOST-REC` (
  `IRS-POST-KEY` bigint(11) NOT NULL,
  `IRS-POST-CODE` char(2) NOT NULL,
  `IRS-POST-DAT` char(8) NOT NULL,
  `IRS-POST-DR` int(5) unsigned NOT NULL,
  `IRS-POST-CR` int(5) unsigned NOT NULL,
  `IRS-POST-AMOUNT` decimal(9,2) NOT NULL,
  `IRS-POST-LEGEND` char(32) NOT NULL,
  `IRS-VAT-AC-DEF` tinyint(2) unsigned NOT NULL,
  `IRS-POST-VAT-SIDE` char(2) NOT NULL,
  `IRS-VAT-AMOUNT` decimal(9,2) NOT NULL,
  PRIMARY KEY (`IRS-POST-KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PSIRSPOST-REC`
--

LOCK TABLES `PSIRSPOST-REC` WRITE;
/*!40000 ALTER TABLE `PSIRSPOST-REC` DISABLE KEYS */;
/*!40000 ALTER TABLE `PSIRSPOST-REC` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PUDELINV-REC`
--

DROP TABLE IF EXISTS `PUDELINV-REC`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PUDELINV-REC` (
  `DEL-INV-NOS` int(8) unsigned NOT NULL,
  `DEL-INV-DAT` int(8) unsigned NOT NULL,
  `DEL-INV-CUS` char(7) NOT NULL,
  PRIMARY KEY (`DEL-INV-NOS`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PUDELINV-REC`
--

LOCK TABLES `PUDELINV-REC` WRITE;
/*!40000 ALTER TABLE `PUDELINV-REC` DISABLE KEYS */;
/*!40000 ALTER TABLE `PUDELINV-REC` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PUINVOICE-REC`
--

DROP TABLE IF EXISTS `PUINVOICE-REC`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PUINVOICE-REC` (
  `INVOICE-KEY` bigint(11) unsigned NOT NULL,
  `INVOICE-SUPPLIER` char(7) NOT NULL,
  `INVOICE-DAT` int(8) unsigned NOT NULL,
  `INV-ORDER` char(10) NOT NULL,
  `INVOICE-TYPE` tinyint(1) unsigned NOT NULL,
  `IH-INVOICE` int(8) unsigned NOT NULL,
  `IH-TEST` tinyint(3) unsigned NOT NULL,
  `IH-SUPPLIER` char(7) NOT NULL,
  `IH-DAT` int(8) unsigned NOT NULL,
  `IH-ORDER` char(10) NOT NULL,
  `IH-TYPE` tinyint(1) unsigned NOT NULL,
  `IH-REF` char(10) NOT NULL,
  `IH-P-C` decimal(9,2) NOT NULL,
  `IH-NET` decimal(9,2) NOT NULL,
  `IH-EXTRA` decimal(9,2) NOT NULL,
  `IH-CARRIAGE` decimal(9,2) NOT NULL,
  `IH-VAT` decimal(9,2) NOT NULL,
  `IH-DISCOUNT` decimal(9,2) NOT NULL,
  `IH-E-VAT` decimal(9,2) NOT NULL,
  `IH-C-VAT` decimal(9,2) NOT NULL,
  `IH-STATUS` char(1) NOT NULL,
  `IH-LINES` tinyint(3) unsigned NOT NULL,
  `IH-DEDUCT-DAYS` tinyint(3) unsigned NOT NULL,
  `IH-DEDUCT-AMT` decimal(5,3) unsigned NOT NULL,
  `IH-DEDUCT-VAT` decimal(5,3) unsigned NOT NULL,
  `IH-DAYS` tinyint(3) unsigned NOT NULL,
  `IH-CR` int(8) unsigned NOT NULL,
  `IH-DAY-BOOK-FLAG` char(1) NOT NULL,
  `IH-UPDATE` char(1) NOT NULL,
  `IL-INVOICE` int(8) unsigned NOT NULL,
  `IL-LINE` tinyint(3) unsigned NOT NULL,
  `IL-PRODUCT` char(13) NOT NULL,
  `IL-PA` char(2) NOT NULL,
  `IL-QTY` tinyint(3) unsigned NOT NULL,
  `IL-TYPE` char(1) NOT NULL,
  `IL-DESCRIPTION` char(24) NOT NULL,
  `IL-NET` decimal(9,2) NOT NULL,
  `IL-UNIT` decimal(9,2) NOT NULL,
  `IL-DISCOUNT` decimal(4,2) unsigned NOT NULL,
  `IL-VAT` decimal(9,2) NOT NULL,
  `IL-VAT-CODE` tinyint(1) unsigned NOT NULL,
  `IL-UPDATE` char(1) NOT NULL,
  PRIMARY KEY (`INVOICE-KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PUINVOICE-REC`
--

LOCK TABLES `PUINVOICE-REC` WRITE;
/*!40000 ALTER TABLE `PUINVOICE-REC` DISABLE KEYS */;
/*!40000 ALTER TABLE `PUINVOICE-REC` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PULEDGER-REC`
--

DROP TABLE IF EXISTS `PULEDGER-REC`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PULEDGER-REC` (
  `PURCH-KEY` char(7) NOT NULL,
  `PURCH-STATUS` tinyint(1) unsigned NOT NULL,
  `PURCH-NOTES-TAG` tinyint(1) unsigned NOT NULL,
  `PURCH-NAME` char(30) NOT NULL,
  `PURCH-ADDRESS` char(96) NOT NULL,
  `PURCH-PHONE` char(13) NOT NULL,
  `PURCH-EXT` char(4) NOT NULL,
  `PURCH-FAX` char(13) NOT NULL,
  `PURCH-EMAIL` char(30) NOT NULL,
  `PURCH-DISCOUNT` decimal(4,2) unsigned NOT NULL,
  `PURCH-CREDIT` mediumint(2) unsigned NOT NULL,
  `PURCH-SORTCODE` mediumint(6) unsigned NOT NULL,
  `PURCH-ACCOUNTNO` int(8) unsigned NOT NULL,
  `PURCH-LIMIT` int(8) unsigned NOT NULL,
  `PURCH-ACTIVETY` int(8) unsigned NOT NULL,
  `PURCH-LAST-INV` int(8) unsigned NOT NULL,
  `PURCH-LAST-PAY` int(8) unsigned NOT NULL,
  `PURCH-AVERAGE` int(8) unsigned NOT NULL,
  `PURCH-CREATE-DAT` int(8) unsigned NOT NULL,
  `PURCH-PAY-ACTIVETY` int(8) unsigned NOT NULL,
  `PURCH-PAY-AVERAGE` int(8) unsigned NOT NULL,
  `PURCH-PAY-WORST` int(8) unsigned NOT NULL,
  `PURCH-CURRENT` decimal(10,2) NOT NULL,
  `PURCH-LAST` decimal(10,2) NOT NULL,
  `TURNOVER-Q1` decimal(10,2) NOT NULL,
  `TURNOVER-Q2` decimal(10,2) NOT NULL,
  `TURNOVER-Q3` decimal(10,2) NOT NULL,
  `TURNOVER-Q4` decimal(10,2) NOT NULL,
  `PURCH-UNAPPLIED` decimal(10,2) NOT NULL,
  PRIMARY KEY (`PURCH-KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PULEDGER-REC`
--

LOCK TABLES `PULEDGER-REC` WRITE;
/*!40000 ALTER TABLE `PULEDGER-REC` DISABLE KEYS */;
/*!40000 ALTER TABLE `PULEDGER-REC` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PUOIFILE5-REC`
--

DROP TABLE IF EXISTS `PUOIFILE5-REC`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PUOIFILE5-REC` (
  `INVOICE-NOS` int(8) unsigned NOT NULL,
  `ITEM-NOS` tinyint(3) unsigned NOT NULL,
  `OI5-INVOICE-KEY` char(10) NOT NULL,
  `INVOICE-SUPPLIER` char(7) NOT NULL,
  `INVOICE-DAT` int(11) NOT NULL,
  `INV-ORDER` char(10) NOT NULL,
  `INVOICE-TYPE` int(11) NOT NULL,
  `IH-INVOICE` int(8) unsigned NOT NULL,
  `IH-TEST` tinyint(3) unsigned NOT NULL,
  `IH-SUPPLIER` char(7) NOT NULL,
  `IH-DAT` int(8) unsigned NOT NULL,
  `IH-ORDER` char(10) NOT NULL,
  `IH-TYPE` tinyint(1) unsigned NOT NULL,
  `IH-REF` char(10) NOT NULL,
  `IH-P-C` decimal(9,2) NOT NULL,
  `IH-NET` decimal(9,2) NOT NULL,
  `IH-EXTRA` decimal(9,2) NOT NULL,
  `IH-CARRIAGE` decimal(9,2) NOT NULL,
  `IH-VAT` decimal(9,2) NOT NULL,
  `IH-DISCOUNT` decimal(9,2) NOT NULL,
  `IH-E-VAT` decimal(9,2) NOT NULL,
  `IH-C-VAT` decimal(9,2) NOT NULL,
  `IH-STATUS` char(1) NOT NULL,
  `IH-LINES` tinyint(3) unsigned NOT NULL,
  `IH-DEDUCT-DAYS` tinyint(3) unsigned NOT NULL,
  `IH-DEDUCT-AMT` decimal(5,2) unsigned NOT NULL,
  `IH-DEDUCT-VAT` decimal(5,2) unsigned NOT NULL,
  `IH-DAYS` tinyint(3) unsigned NOT NULL,
  `IH-CR` int(8) unsigned NOT NULL,
  `IH-DAY-BOOK-FLAG` char(1) NOT NULL,
  `IH-UPDATE` char(1) NOT NULL,
  `IL-INVOICE` int(8) unsigned NOT NULL,
  `IL-LINE` tinyint(3) unsigned NOT NULL,
  `IL-PRODUCT` char(12) NOT NULL,
  `IL-PA` char(2) NOT NULL,
  `IL-QTY` tinyint(3) unsigned NOT NULL,
  `IL-TYPE` char(1) NOT NULL,
  `IL-DESCRIPTION` char(24) NOT NULL,
  `IL-NET` decimal(9,2) NOT NULL,
  `IL-UNIT` decimal(9,2) NOT NULL,
  `IL-DISCOUNT` decimal(4,2) unsigned NOT NULL,
  `IL-VAT` decimal(9,2) NOT NULL,
  `IL-VAT-CODE` tinyint(1) unsigned NOT NULL,
  `IL-UPDATE` char(1) NOT NULL,
  PRIMARY KEY (`OI5-INVOICE-KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PUOIFILE5-REC`
--

LOCK TABLES `PUOIFILE5-REC` WRITE;
/*!40000 ALTER TABLE `PUOIFILE5-REC` DISABLE KEYS */;
/*!40000 ALTER TABLE `PUOIFILE5-REC` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SADELINV-REC`
--

DROP TABLE IF EXISTS `SADELINV-REC`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SADELINV-REC` (
  `DEL-INV-NOS` int(8) unsigned NOT NULL,
  `DEL-INV-DAT` int(8) unsigned NOT NULL,
  `DEL-INV-CUS` char(7) NOT NULL,
  PRIMARY KEY (`DEL-INV-NOS`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SADELINV-REC`
--

LOCK TABLES `SADELINV-REC` WRITE;
/*!40000 ALTER TABLE `SADELINV-REC` DISABLE KEYS */;
/*!40000 ALTER TABLE `SADELINV-REC` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SAINV-LINES-REC`
--

DROP TABLE IF EXISTS `SAINV-LINES-REC`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SAINV-LINES-REC` (
  `IL-LINE-KEY` char(10) NOT NULL,
  `IL-INVOICE` int(8) unsigned NOT NULL,
  `IL-LINE` tinyint(2) unsigned NOT NULL,
  `IL-PRODUCT` char(13) NOT NULL,
  `IL-PA` char(2) NOT NULL,
  `IL-QTY` smallint(6) unsigned NOT NULL,
  `IL-TYPE` char(1) NOT NULL,
  `IL-DESCRIPTION` char(32) NOT NULL,
  `IL-NET` decimal(9,2) NOT NULL,
  `IL-UNIT` decimal(9,2) NOT NULL,
  `IL-DISCOUNT` decimal(4,2) unsigned NOT NULL,
  `IL-VAT` decimal(9,2) NOT NULL,
  `IL-VAT-CODE` tinyint(1) unsigned NOT NULL,
  `IL-UPDATE` char(1) NOT NULL,
  PRIMARY KEY (`IL-LINE-KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SAINV-LINES-REC`
--

LOCK TABLES `SAINV-LINES-REC` WRITE;
/*!40000 ALTER TABLE `SAINV-LINES-REC` DISABLE KEYS */;
/*!40000 ALTER TABLE `SAINV-LINES-REC` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SAINVOICE-REC`
--

DROP TABLE IF EXISTS `SAINVOICE-REC`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SAINVOICE-REC` (
  `SINVOICE-KEY` char(10) NOT NULL,
  `IH-INVOICE` int(8) unsigned NOT NULL,
  `IH-TEST` tinyint(2) unsigned NOT NULL,
  `IH-CUSTOMER` char(7) NOT NULL,
  `IH-DAT` int(8) unsigned NOT NULL,
  `IH-ORDER` char(10) NOT NULL,
  `IH-TYPE` tinyint(1) unsigned NOT NULL,
  `IH-REF` char(10) NOT NULL,
  `IH-DESCRIPTION` char(32) NOT NULL,
  `IH-P-C` decimal(9,2) NOT NULL,
  `IH-NET` decimal(9,2) NOT NULL,
  `IH-EXTRA` decimal(9,2) NOT NULL,
  `IH-CARRIAGE` decimal(9,2) NOT NULL,
  `IH-VAT` decimal(9,2) NOT NULL,
  `IH-DISCOUNT` decimal(9,2) NOT NULL,
  `IH-E-VAT` decimal(9,2) NOT NULL,
  `IH-C-VAT` decimal(9,2) NOT NULL,
  `IH-STATUS` char(1) NOT NULL,
  `IH-STATUS-P` char(1) NOT NULL,
  `IH-STATUS-L` char(1) NOT NULL,
  `IH-STATUS-C` char(1) NOT NULL,
  `IH-STATUS-A` char(1) NOT NULL,
  `IH-STATUS-I` char(1) NOT NULL,
  `IH-DEDUCT-DAYS` tinyint(3) unsigned NOT NULL,
  `IH-DEDUCT-AMT` decimal(5,2) unsigned NOT NULL,
  `IH-DEDUCT-VAT` decimal(5,2) unsigned NOT NULL,
  `IH-DAYS` tinyint(3) unsigned NOT NULL,
  `IH-CR` int(8) unsigned NOT NULL,
  `IH-LINES` tinyint(2) unsigned NOT NULL,
  `IH-DAY-BOOK-FLAG` char(1) NOT NULL,
  `IH-UPDATE` char(1) NOT NULL,
  `OIT3-KEY` char(15) NOT NULL,
  `OIT3-APPLIED` char(1) NOT NULL,
  `OIT3-BATCH` char(8) NOT NULL,
  `OIT3-DATE-CLEARED` int(8) unsigned NOT NULL,
  `OIT3-HOLD-FLAG` char(1) NOT NULL,
  `OIT3-PAID` decimal(9,2) NOT NULL,
  `OIT3-UNAPL` char(1) NOT NULL,
  PRIMARY KEY (`SINVOICE-KEY`),
  UNIQUE KEY `OIT3-KEY` (`OIT3-KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SAINVOICE-REC`
--

LOCK TABLES `SAINVOICE-REC` WRITE;
/*!40000 ALTER TABLE `SAINVOICE-REC` DISABLE KEYS */;
/*!40000 ALTER TABLE `SAINVOICE-REC` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SAITM3-REC`
--

DROP TABLE IF EXISTS `SAITM3-REC`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SAITM3-REC` (
  `OI3-KEY` char(15) NOT NULL,
  `OI3-CUSTOMER` char(7) NOT NULL,
  `OI3-INVOICE` int(8) unsigned NOT NULL,
  `OI3-DAT` int(8) unsigned NOT NULL,
  `OI3-BATCH` char(8) NOT NULL,
  `OI3-BATCH-NOS` char(5) NOT NULL COMMENT 'Batch content',
  `OI3-BATCH-ITEM` char(3) NOT NULL COMMENT 'Batch content',
  `OI3-TYPE` char(1) NOT NULL,
  `OI3-DESCRIPTION` char(32) NOT NULL,
  `OI3-HOLD-FLAG` char(1) NOT NULL,
  `OI3-UNAPL` char(1) NOT NULL,
  `OI3-P-C` decimal(9,2) NOT NULL,
  `OI3-NET` decimal(9,2) NOT NULL COMMENT 'Also called Approp',
  `OI3-EXTRA` decimal(9,2) NOT NULL,
  `OI3-CARRIAGE` decimal(9,2) NOT NULL,
  `OI3-VAT` decimal(9,2) NOT NULL,
  `OI3-DISCOUNT` decimal(9,2) NOT NULL,
  `OI3-E-VAT` decimal(9,2) NOT NULL,
  `OI3-C-VAT` decimal(9,2) NOT NULL,
  `OI3-PAID` decimal(9,2) NOT NULL,
  `OI3-STATUS` char(1) NOT NULL,
  `OI3-DEDUCT-DAYS` tinyint(3) unsigned NOT NULL,
  `OI3-DEDUCT-AMT` decimal(5,2) NOT NULL,
  `OI3-DEDUCT-VAT` decimal(5,2) NOT NULL,
  `OI3-DAYS` tinyint(3) unsigned NOT NULL,
  `OI3-CR` int(8) NOT NULL,
  `OI3-APPLIED` char(1) NOT NULL,
  `OI3-DATE-CLEARED` int(8) unsigned NOT NULL,
  PRIMARY KEY (`OI3-KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SAITM3-REC`
--

LOCK TABLES `SAITM3-REC` WRITE;
/*!40000 ALTER TABLE `SAITM3-REC` DISABLE KEYS */;
/*!40000 ALTER TABLE `SAITM3-REC` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SALEDGER-REC`
--

DROP TABLE IF EXISTS `SALEDGER-REC`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SALEDGER-REC` (
  `SALES-KEY` char(7) NOT NULL,
  `SALES-NAME` char(30) NOT NULL,
  `SALES-ADDRESS` char(96) NOT NULL,
  `SALES-PHONE` char(13) NOT NULL,
  `SALES-EXT` char(4) NOT NULL,
  `SALES-EMAIL` char(30) NOT NULL,
  `SALES-FAX` char(13) NOT NULL,
  `SALES-STATUS` tinyint(1) unsigned NOT NULL,
  `SALES-LATE` tinyint(1) unsigned NOT NULL,
  `SALES-DUNNING` tinyint(1) unsigned NOT NULL,
  `EMAIL-INVOICE` tinyint(1) unsigned NOT NULL,
  `EMAIL-STATEMENT` tinyint(1) unsigned NOT NULL,
  `EMAIL-LETTERS` tinyint(1) unsigned NOT NULL,
  `DELIVERY-TAG` tinyint(1) unsigned NOT NULL,
  `NOTES-TAG` tinyint(1) unsigned NOT NULL,
  `SALES-CREDIT` tinyint(2) unsigned NOT NULL,
  `SALES-DISCOUNT` decimal(4,2) unsigned NOT NULL,
  `SALES-LATE-MIN` smallint(4) unsigned NOT NULL,
  `SALES-LATE-MAX` smallint(4) unsigned NOT NULL,
  `SALES-LIMIT` int(8) unsigned NOT NULL,
  `SALES-ACTIVETY` int(8) unsigned NOT NULL,
  `SALES-LAST-INV` int(8) unsigned NOT NULL,
  `SALES-LAST-PAY` int(8) unsigned NOT NULL,
  `SALES-AVERAGE` int(8) unsigned NOT NULL,
  `SALES-PAY-ACTIVETY` int(8) unsigned NOT NULL,
  `SALES-PAY-AVERAGE` int(8) unsigned NOT NULL,
  `SALES-PAY-WORST` int(8) unsigned NOT NULL,
  `SALES-CREATE-DAT` int(8) unsigned NOT NULL,
  `SALES-CURRENT` decimal(10,2) NOT NULL,
  `SALES-LAST` decimal(10,2) NOT NULL,
  `TURNOVER-Q1` decimal(10,2) NOT NULL,
  `TURNOVER-Q2` decimal(10,2) NOT NULL,
  `TURNOVER-Q3` decimal(10,2) NOT NULL,
  `TURNOVER-Q4` decimal(10,2) NOT NULL,
  `SALES-UNAPPLIED` decimal(10,2) NOT NULL,
  PRIMARY KEY (`SALES-KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SALEDGER-REC`
--

LOCK TABLES `SALEDGER-REC` WRITE;
/*!40000 ALTER TABLE `SALEDGER-REC` DISABLE KEYS */;
/*!40000 ALTER TABLE `SALEDGER-REC` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `STOCK-REC`
--

DROP TABLE IF EXISTS `STOCK-REC`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `STOCK-REC` (
  `STOCK-KEY` char(13) NOT NULL,
  `STOCK-ABREV-KEY` char(7) NOT NULL,
  `STOCK-SUPPLIER-P1` char(7) NOT NULL,
  `STOCK-SUPPLIER-P2` char(7) NOT NULL,
  `STOCK-SUPPLIER-P3` char(7) NOT NULL,
  `STOCK-DESC` char(32) NOT NULL,
  `STOCK-CONSTRUCT-ITEM` char(13) NOT NULL,
  `STOCK-LOCATION` char(10) NOT NULL,
  `STOCK-PA-CODE` char(3) NOT NULL,
  `STOCK-SA-CODE` char(3) NOT NULL,
  `STOCK-SERVICES-FLAG` char(1) NOT NULL,
  `STOCK-LAST-ACTUAL-COST` decimal(9,2) unsigned NOT NULL,
  `STOCK-CONSTRUCT-BUNDLE` int(6) NOT NULL,
  `STOCK-UNDER-CONSTRUCTION` int(6) NOT NULL,
  `STOCK-WORK-IN-PROGRESS` int(6) NOT NULL,
  `STOCK-REORDER-PNT` int(6) NOT NULL,
  `STOCK-STD-REORDER` int(6) NOT NULL,
  `STOCK-BACK-ORDERED` int(6) NOT NULL,
  `STOCK-ON-ORDER` int(6) NOT NULL,
  `STOCK-HELD` int(6) NOT NULL,
  `STOCK-PRE-SALES` int(6) NOT NULL,
  `STOCK-RETAIL` decimal(9,2) unsigned NOT NULL,
  `STOCK-COST` decimal(11,4) unsigned NOT NULL,
  `STOCK-VALUE` decimal(11,2) unsigned NOT NULL,
  `STOCK-ORDER-DUE` int(8) unsigned NOT NULL,
  `STOCK-ORDER-DAT` int(8) unsigned NOT NULL,
  `STOCK-ADDS` int(8) unsigned NOT NULL,
  `STOCK-DEDUCTS` int(8) unsigned NOT NULL,
  `STOCK-WIP-ADDS` int(8) unsigned NOT NULL,
  `STOCK-WIP-DEDS` int(8) unsigned NOT NULL,
  `STOCK-TD-ADDS-01` int(8) unsigned NOT NULL,
  `STOCK-TD-ADDS-02` int(8) unsigned NOT NULL,
  `STOCK-TD-ADDS-03` int(8) unsigned NOT NULL,
  `STOCK-TD-ADDS-04` int(8) unsigned NOT NULL,
  `STOCK-TD-ADDS-05` int(8) unsigned NOT NULL,
  `STOCK-TD-ADDS-06` int(8) unsigned NOT NULL,
  `STOCK-TD-ADDS-07` int(8) unsigned NOT NULL,
  `STOCK-TD-ADDS-08` int(8) unsigned NOT NULL,
  `STOCK-TD-ADDS-09` int(8) unsigned NOT NULL,
  `STOCK-TD-ADDS-10` int(8) unsigned NOT NULL,
  `STOCK-TD-ADDS-11` int(8) unsigned NOT NULL,
  `STOCK-TD-ADDS-12` int(8) unsigned NOT NULL,
  `STOCK-TD-DEDS-01` int(8) unsigned NOT NULL,
  `STOCK-TD-DEDS-02` int(8) unsigned NOT NULL,
  `STOCK-TD-DEDS-03` int(8) unsigned NOT NULL,
  `STOCK-TD-DEDS-04` int(8) unsigned NOT NULL,
  `STOCK-TD-DEDS-05` int(8) unsigned NOT NULL,
  `STOCK-TD-DEDS-06` int(8) unsigned NOT NULL,
  `STOCK-TD-DEDS-07` int(8) unsigned NOT NULL,
  `STOCK-TD-DEDS-08` int(8) unsigned NOT NULL,
  `STOCK-TD-DEDS-09` int(8) unsigned NOT NULL,
  `STOCK-TD-DEDS-10` int(8) unsigned NOT NULL,
  `STOCK-TD-DEDS-11` int(8) unsigned NOT NULL,
  `STOCK-TD-DEDS-12` int(8) unsigned NOT NULL,
  `STOCK-TD-WIP-ADDS-01` int(8) unsigned NOT NULL,
  `STOCK-TD-WIP-ADDS-02` int(8) unsigned NOT NULL,
  `STOCK-TD-WIP-ADDS-03` int(8) unsigned NOT NULL,
  `STOCK-TD-WIP-ADDS-04` int(8) unsigned NOT NULL,
  `STOCK-TD-WIP-ADDS-05` int(8) unsigned NOT NULL,
  `STOCK-TD-WIP-ADDS-06` int(8) unsigned NOT NULL,
  `STOCK-TD-WIP-ADDS-07` int(8) unsigned NOT NULL,
  `STOCK-TD-WIP-ADDS-08` int(8) unsigned NOT NULL,
  `STOCK-TD-WIP-ADDS-09` int(8) unsigned NOT NULL,
  `STOCK-TD-WIP-ADDS-10` int(8) unsigned NOT NULL,
  `STOCK-TD-WIP-ADDS-11` int(8) unsigned NOT NULL,
  `STOCK-TD-WIP-ADDS-12` int(8) unsigned NOT NULL,
  `STOCK-TD-WIP-DEDS-01` int(8) unsigned NOT NULL,
  `STOCK-TD-WIP-DEDS-02` int(8) unsigned NOT NULL,
  `STOCK-TD-WIP-DEDS-03` int(8) unsigned NOT NULL,
  `STOCK-TD-WIP-DEDS-04` int(8) unsigned NOT NULL,
  `STOCK-TD-WIP-DEDS-05` int(8) unsigned NOT NULL,
  `STOCK-TD-WIP-DEDS-06` int(8) unsigned NOT NULL,
  `STOCK-TD-WIP-DEDS-07` int(8) unsigned NOT NULL,
  `STOCK-TD-WIP-DEDS-08` int(8) unsigned NOT NULL,
  `STOCK-TD-WIP-DEDS-09` int(8) unsigned NOT NULL,
  `STOCK-TD-WIP-DEDS-10` int(8) unsigned NOT NULL,
  `STOCK-TD-WIP-DEDS-11` int(8) unsigned NOT NULL,
  `STOCK-TD-WIP-DEDS-12` int(8) unsigned NOT NULL,
  PRIMARY KEY (`STOCK-KEY`),
  KEY `STCKRCAltNdx01` (`STOCK-ABREV-KEY`),
  KEY `STCKRCAltNdx02` (`STOCK-DESC`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `STOCK-REC`
--

LOCK TABLES `STOCK-REC` WRITE;
/*!40000 ALTER TABLE `STOCK-REC` DISABLE KEYS */;
INSERT INTO `STOCK-REC` VALUES ('0000000000001','0000001','','','','Test stock item 1','','In-De-Kitn','Pa1','Sa1','N',0.00,0,0,0,2,2,0,0,0,0,2.50,1.8500,0.00,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),('0000000000002','0000002','','','','Test WIP block','','kitchen','Pa1','Sa1','N',0.00,0,0,0,0,0,0,0,0,0,2.55,1.9500,0.00,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),('00080484','MACKERL','','','','Sainsbury\'s Mackeral Fillets 125','','kitchen-c1','','','N',0.00,0,0,0,0,2,0,0,1,0,0.40,0.4000,0.40,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),('00358477','S-BEENS','','','','Sainsbury\'s Baked Beans 220g','','kitchen-c1','','','N',0.00,0,0,0,1,5,0,0,2,0,0.30,0.3000,0.60,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),('5000436408451','TESCOTM','','','','\r\nTesco Value Chopped Tomatoes','','kitchen-c1','','','N',0.00,0,0,0,1,5,0,0,2,0,0.40,0.4000,0.80,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),('5018374294401','ANCHOVY','','','','Tesco Anchovy Fillets 50g (30g)','','','','','',0.00,0,0,0,0,0,0,0,0,0,0.40,0.4000,0.40,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),('8000320010118','CIRIOTM','','','','Cirio Chopped Tomatoes','','kitchen-C1','','','N',0.00,0,0,0,1,5,0,0,1,0,0.45,0.4500,0.45,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),('800320010118','\r\nCIRIO','','','','Cirio Chopped Tomatoes','','Kitch-C-1','P','','N',0.00,0,0,0,2,5,0,0,1,0,1.00,1.0000,1.00,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
/*!40000 ALTER TABLE `STOCK-REC` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `STOCKAUDIT-REC`
--

DROP TABLE IF EXISTS `STOCKAUDIT-REC`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `STOCKAUDIT-REC` (
  `AUDIT-ID` int(6) unsigned NOT NULL AUTO_INCREMENT,
  `AUDIT-KEY` char(14) NOT NULL,
  `AUDIT-INVOICE-PO` int(8) unsigned NOT NULL,
  `AUDIT-CR-FOR-INVOICE` int(8) unsigned NOT NULL,
  `AUDIT-DESC` char(32) NOT NULL,
  `AUDIT-PROCESS-DAT` char(10) NOT NULL,
  `AUDIT-REVERSE-TRANSACTION` tinyint(1) unsigned NOT NULL,
  `AUDIT-TRANSACTION-QTY` mediumint(6) NOT NULL,
  `AUDIT-UNIT-COST` decimal(10,4) NOT NULL,
  `AUDIT-STOCK-VALUE-CHANGE` decimal(10,2) NOT NULL,
  `AUDIT-NO` mediumint(5) unsigned NOT NULL,
  PRIMARY KEY (`AUDIT-ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `STOCKAUDIT-REC`
--

LOCK TABLES `STOCKAUDIT-REC` WRITE;
/*!40000 ALTER TABLE `STOCKAUDIT-REC` DISABLE KEYS */;
/*!40000 ALTER TABLE `STOCKAUDIT-REC` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SYSDEFLT-REC`
--

DROP TABLE IF EXISTS `SYSDEFLT-REC`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SYSDEFLT-REC` (
  `DEF-REC-KEY` tinyint(2) unsigned NOT NULL,
  `DEF-ACS` decimal(6,2) unsigned NOT NULL,
  `DEF-CODES` char(2) NOT NULL,
  `DEF-VAT` char(1) NOT NULL,
  PRIMARY KEY (`DEF-REC-KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SYSDEFLT-REC`
--

LOCK TABLES `SYSDEFLT-REC` WRITE;
/*!40000 ALTER TABLE `SYSDEFLT-REC` DISABLE KEYS */;
/*!40000 ALTER TABLE `SYSDEFLT-REC` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SYSFINAL-REC`
--

DROP TABLE IF EXISTS `SYSFINAL-REC`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SYSFINAL-REC` (
  `FINAL-ACC-REC-KEY` tinyint(2) unsigned NOT NULL,
  `AR1` char(16) NOT NULL,
  PRIMARY KEY (`FINAL-ACC-REC-KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SYSFINAL-REC`
--

LOCK TABLES `SYSFINAL-REC` WRITE;
/*!40000 ALTER TABLE `SYSFINAL-REC` DISABLE KEYS */;
/*!40000 ALTER TABLE `SYSFINAL-REC` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SYSTEM-REC`
--

DROP TABLE IF EXISTS `SYSTEM-REC`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SYSTEM-REC` (
  `SYSTEM-REC-KEY` tinyint(1) unsigned NOT NULL,
  `SYSTEM-RECORD-VERSION-PRIME` tinyint(2) unsigned NOT NULL,
  `SYSTEM-RECORD-VERSION-SECONDAR` tinyint(2) unsigned NOT NULL,
  `VAT-RATE-1` decimal(4,2) unsigned NOT NULL,
  `VAT-RATE-2` decimal(4,2) unsigned NOT NULL,
  `VAT-RATE-3` decimal(4,2) unsigned NOT NULL,
  `VAT-RATE-4` decimal(4,2) unsigned NOT NULL,
  `VAT-RATE-5` decimal(4,2) unsigned NOT NULL,
  `CYCLEA` tinyint(2) unsigned NOT NULL,
  `PERIOD` tinyint(2) unsigned NOT NULL,
  `PAGE-LINES` tinyint(3) unsigned NOT NULL,
  `NEXT-INVOICE` int(8) unsigned NOT NULL,
  `RUN-DAT` int(8) unsigned NOT NULL,
  `START-DAT` int(8) unsigned NOT NULL,
  `END-DAT` int(8) unsigned NOT NULL,
  `SUSER` char(32) NOT NULL,
  `USER-CODE` char(32) NOT NULL,
  `ADDRESS-1` char(24) NOT NULL,
  `ADDRESS-2` char(24) NOT NULL,
  `ADDRESS-3` char(24) NOT NULL,
  `ADDRESS-4` char(24) NOT NULL,
  `POST-CODE` char(12) NOT NULL,
  `COUNTRY` char(24) NOT NULL,
  `PRINT-SPOOL-NAME` char(48) NOT NULL,
  `FILE-STATUSES` char(32) NOT NULL,
  `PASS-VALUE` tinyint(1) unsigned NOT NULL,
  `LEVEL-1` tinyint(1) unsigned NOT NULL,
  `LEVEL-2` tinyint(1) unsigned NOT NULL,
  `LEVEL-3` tinyint(1) unsigned NOT NULL,
  `LEVEL-4` tinyint(1) unsigned NOT NULL,
  `LEVEL-5` tinyint(1) unsigned NOT NULL,
  `LEVEL-6` tinyint(1) unsigned NOT NULL,
  `PASS-WORD` char(4) NOT NULL DEFAULT '',
  `HOST` tinyint(1) unsigned NOT NULL,
  `OP-SYSTEM` tinyint(1) unsigned NOT NULL,
  `CURRENT-QUARTER` tinyint(1) unsigned NOT NULL,
  `FILE-SYSTEM-USED` tinyint(1) unsigned NOT NULL,
  `FILE-DUPLICATES-IN-USE` tinyint(1) unsigned NOT NULL,
  `MAPS-SER` char(6) NOT NULL,
  `DATE-FORM` tinyint(1) unsigned NOT NULL,
  `DATA-CAPTURE-USED` tinyint(1) unsigned NOT NULL,
  `RDBMS-DB-NAME` char(12) NOT NULL,
  `RDBMS-USER` char(12) NOT NULL,
  `RDBMS-PASSWD` char(12) NOT NULL,
  `RDBMS-PORT` char(5) NOT NULL,
  `RDBMS-HOST` char(32) NOT NULL,
  `RDBMS-SOCKET` char(64) NOT NULL,
  `VAT-REG-NUMBER` char(11) NOT NULL,
  `PARAM-RESTRICT` char(1) NOT NULL,
  `P-C` char(1) NOT NULL,
  `P-C-GROUPED` char(1) NOT NULL,
  `P-C-LEVEL` char(1) NOT NULL,
  `COMPS` char(1) NOT NULL,
  `COMPS-ACTIVE` char(1) NOT NULL,
  `M-V` char(1) NOT NULL,
  `ARCH` char(1) NOT NULL,
  `TRANS-PRINT` char(1) NOT NULL,
  `TRANS-PRINTED` char(1) NOT NULL,
  `HEADER-LEVEL` tinyint(1) unsigned NOT NULL,
  `SALES-RANGE` tinyint(1) unsigned NOT NULL,
  `PURCHASE-RANGE` tinyint(1) unsigned NOT NULL,
  `VAT` char(1) NOT NULL,
  `BATCH-ID` char(1) NOT NULL,
  `LEDGER-2ND-INDEX` char(1) NOT NULL,
  `IRS-INSTEAD` char(1) NOT NULL,
  `LEDGER-SEC` smallint(4) unsigned NOT NULL,
  `UPDATES` smallint(4) unsigned NOT NULL,
  `POSTINGS` smallint(4) unsigned NOT NULL,
  `NEXT-BATCH` smallint(4) unsigned NOT NULL,
  `EXTRA-CHARGE-AC` int(8) unsigned NOT NULL,
  `VAT-AC` int(8) unsigned NOT NULL,
  `PRINT-SPOOL-NAME2` char(48) NOT NULL,
  `NEXT-FOLIO` int(8) unsigned NOT NULL,
  `BL-PAY-AC` int(8) unsigned NOT NULL,
  `P-CREDITORS` int(8) unsigned NOT NULL,
  `BL-PURCH-AC` int(8) unsigned NOT NULL,
  `BL-END-CYCLE-DAT` int(1) unsigned NOT NULL,
  `BL-NEXT-BATCH` smallint(4) unsigned NOT NULL,
  `AGE-TO-PAY` smallint(4) unsigned NOT NULL,
  `PURCHASE-LEDGER` char(1) NOT NULL,
  `PL-DELIM` char(1) NOT NULL,
  `ENTRY-LEVEL` tinyint(1) unsigned NOT NULL,
  `P-FLAG-A` tinyint(1) unsigned NOT NULL,
  `P-FLAG-I` tinyint(1) unsigned NOT NULL,
  `P-FLAG-P` tinyint(1) unsigned NOT NULL,
  `PL-STOCK-LINK` char(1) NOT NULL,
  `PRINT-SPOOL-NAME3` char(48) NOT NULL,
  `SALES-LEDGER` char(1) NOT NULL,
  `SL-DELIM` char(1) NOT NULL,
  `OI-3-FLAG` char(1) NOT NULL,
  `CUST-FLAG` char(1) NOT NULL,
  `OI-5-FLAG` char(1) NOT NULL,
  `S-FLAG-OI-3` char(1) NOT NULL,
  `FULL-INVOICING` tinyint(1) unsigned NOT NULL,
  `S-FLAG-A` tinyint(1) unsigned NOT NULL,
  `S-FLAG-I` tinyint(1) unsigned NOT NULL,
  `S-FLAG-P` tinyint(1) unsigned NOT NULL,
  `SL-DUNNING` tinyint(1) unsigned NOT NULL,
  `SL-CHARGES` tinyint(1) unsigned NOT NULL,
  `SL-OWN-NOS` char(1) NOT NULL,
  `SL-STATS-RUN` tinyint(1) unsigned NOT NULL,
  `SL-DAY-BOOK` tinyint(1) unsigned NOT NULL,
  `INVOICER` tinyint(1) unsigned NOT NULL,
  `EXTRA-DESC` char(14) NOT NULL,
  `EXTRA-TYPE` char(1) NOT NULL,
  `EXTRA-PRINT` char(1) NOT NULL,
  `SL-STOCK-LINK` char(1) NOT NULL,
  `SL-STOCK-AUDIT` char(1) NOT NULL,
  `SL-LATE-PER` decimal(4,2) unsigned NOT NULL,
  `SL-DISC` decimal(4,2) unsigned NOT NULL,
  `EXTRA-RATE` decimal(4,2) unsigned NOT NULL,
  `SL-DAYS-1` smallint(3) unsigned NOT NULL,
  `SL-DAYS-2` smallint(3) unsigned NOT NULL,
  `SL-DAYS-3` smallint(3) unsigned NOT NULL,
  `SL-CREDIT` smallint(3) unsigned NOT NULL,
  `SL-MIN` smallint(4) unsigned NOT NULL,
  `SL-MAX` smallint(4) unsigned NOT NULL,
  `PF-RETENTION` smallint(4) unsigned NOT NULL,
  `FIRST-SL-BATCH` smallint(4) unsigned NOT NULL,
  `FIRST-SL-INV` int(8) unsigned NOT NULL,
  `SL-LIMIT` int(8) unsigned NOT NULL,
  `SL-PAY-AC` int(8) unsigned NOT NULL,
  `S-DEBTORS` int(8) unsigned NOT NULL,
  `SL-SALES-AC` int(8) unsigned NOT NULL,
  `S-END-CYCLE-DAT` int(8) unsigned NOT NULL,
  `SL-COMP-HEAD-PICK` char(1) NOT NULL,
  `SL-COMP-HEAD-INV` char(1) NOT NULL,
  `SL-COMP-HEAD-STAT` char(1) NOT NULL,
  `SL-COMP-HEAD-LETS` char(1) NOT NULL,
  `SL-VAT-PRINTED` char(1) NOT NULL,
  `STK-ABREV-REF` char(6) NOT NULL,
  `STK-DEBUG` tinyint(1) unsigned NOT NULL,
  `STK-MANU-USED` tinyint(1) unsigned NOT NULL,
  `STK-OE-USED` tinyint(1) unsigned NOT NULL,
  `STK-AUDIT-USED` tinyint(1) unsigned NOT NULL,
  `STK-MOV-AUDIT` tinyint(1) unsigned NOT NULL,
  `STK-PERIOD-CUR` char(1) NOT NULL,
  `STK-PERIOD-DAT` char(1) NOT NULL,
  `STOCK-CONTROL` char(1) NOT NULL,
  `STK-AVERAGING` tinyint(1) unsigned NOT NULL,
  `STK-ACTIVITY-REP-RUN` tinyint(1) unsigned NOT NULL,
  `STK-PAGE-LINES` tinyint(4) unsigned NOT NULL,
  `STK-AUDIT-NO` tinyint(4) unsigned NOT NULL,
  `CLIENT` char(24) NOT NULL,
  `NEXT-POST` mediumint(5) unsigned NOT NULL,
  `VAT1` decimal(4,2) unsigned NOT NULL,
  `VAT2` decimal(4,2) unsigned NOT NULL,
  `VAT3` decimal(4,2) unsigned NOT NULL,
  `IRS-PASS-VALUE` tinyint(1) unsigned NOT NULL,
  `SAVE-SEQU` tinyint(1) unsigned NOT NULL,
  `SYSTEM-WORK-GROUP` char(18) NOT NULL,
  `PL-APP-CREATED` char(1) NOT NULL,
  `PL-APPROP-AC` mediumint(5) unsigned NOT NULL,
  `1ST-TIME-FLAG` tinyint(1) unsigned NOT NULL,
  `PL-APPROP-AC6` mediumint(6) unsigned NOT NULL,
  PRIMARY KEY (`SYSTEM-REC-KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SYSTEM-REC`
--

LOCK TABLES `SYSTEM-REC` WRITE;
/*!40000 ALTER TABLE `SYSTEM-REC` DISABLE KEYS */;
INSERT INTO `SYSTEM-REC` VALUES (1,1,3,20.00,5.00,0.00,0.00,0.00,1,13,48,1,151837,150206,150570,'Dykegrove Ltd','ORLLAKU J JQK','17 Stag Green Avenue','Hatfield','Hertfordshire','','AL9 5EB','United Kingdom','Officejet_Pro_8600','00000000000000000000000000000000',0,1,1,1,1,1,0,'CEJE',1,6,1,1,0,'mp9999',1,0,'ACASDB','dev-prog-001','mysqlpass','3306','localhost','/home/mysql/mysql.sock','493 2363 35','N','','','','Y','','','','','',0,1,2,'Y','','Y','Y',0,0,1,2,331,377,'Officejet_Pro_8600_2',0,299,280,104,0,1,0,'N','!',0,0,0,0,'Y','Officejet_Pro_8600_3','Y','!','N','','','',1,0,2,0,0,0,'N',0,0,2,'','','','Y','Y',0.00,0.00,0.00,0,0,0,28,0,0,30,1,0,500,299,171,102,0,'Y','Y','Y','Y','Y','',0,1,0,1,1,'M','Y','Y',1,1,48,1,'',0,0.00,0.00,0.00,0,0,'','',0,0,0);
/*!40000 ALTER TABLE `SYSTEM-REC` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SYSTOT-REC`
--

DROP TABLE IF EXISTS `SYSTOT-REC`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SYSTOT-REC` (
  `LEDGER-TOTALS-REC-KEY` tinyint(1) unsigned NOT NULL,
  `SL-OS-BAL-LAST-MONTH` decimal(10,2) NOT NULL,
  `SL-OS-BAL-THIS-MONTH` decimal(10,2) NOT NULL,
  `SL-INVOICES-THIS-MONTH` decimal(10,2) NOT NULL,
  `SL-CREDIT-NOTES-THIS-MONTH` decimal(10,2) NOT NULL,
  `SL-VARIANCE` decimal(10,2) NOT NULL,
  `SL-CREDIT-DEDUCTIONS` decimal(10,2) NOT NULL,
  `SL-CN-UNAPPL-THIS-MONTH` decimal(10,2) NOT NULL,
  `SL-PAYMENTS` decimal(10,2) NOT NULL,
  `SL4-SPARE1` decimal(10,2) NOT NULL,
  `SL4-SPARE2` decimal(10,2) NOT NULL,
  `PL-OS-BAL-LAST-MONTH` decimal(10,2) NOT NULL,
  `PL-OS-BAL-THIS-MONTH` decimal(10,2) NOT NULL,
  `PL-INVOICES-THIS-MONTH` decimal(10,2) NOT NULL,
  `PL-CREDIT-NOTES-THIS-MONTH` decimal(10,2) NOT NULL,
  `PL-VARIANCE` decimal(10,2) NOT NULL,
  `PL-CREDIT-DEDUCTIONS` decimal(10,2) NOT NULL,
  `PL-CN-UNAPPL-THIS-MONTH` decimal(10,2) NOT NULL,
  `PL-PAYMENTS` decimal(10,2) NOT NULL,
  `SL4-SPARE3` decimal(10,2) NOT NULL,
  `SL4-SPARE4` decimal(10,2) NOT NULL,
  PRIMARY KEY (`LEDGER-TOTALS-REC-KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SYSTOT-REC`
--

LOCK TABLES `SYSTOT-REC` WRITE;
/*!40000 ALTER TABLE `SYSTOT-REC` DISABLE KEYS */;
/*!40000 ALTER TABLE `SYSTOT-REC` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `VALUEANAL-REC`
--

DROP TABLE IF EXISTS `VALUEANAL-REC`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `VALUEANAL-REC` (
  `VA-CODE` char(3) NOT NULL,
  `VA-GL` mediumint(6) unsigned NOT NULL,
  `VA-DESC` char(24) NOT NULL,
  `VA-PRINT` char(3) NOT NULL,
  `VA-T-THIS` mediumint(5) unsigned NOT NULL,
  `VA-T-LAST` mediumint(5) unsigned NOT NULL,
  `VA-T-YEAR` mediumint(5) unsigned NOT NULL,
  `VA-V-THIS` decimal(10,2) unsigned NOT NULL,
  `VA-V-LAST` decimal(10,2) unsigned NOT NULL,
  `VA-V-YEAR` decimal(10,2) unsigned NOT NULL,
  PRIMARY KEY (`VA-CODE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `VALUEANAL-REC`
--

LOCK TABLES `VALUEANAL-REC` WRITE;
/*!40000 ALTER TABLE `VALUEANAL-REC` DISABLE KEYS */;
/*!40000 ALTER TABLE `VALUEANAL-REC` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'ACASDB'
--

--
-- Dumping routines for database 'ACASDB'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-02-26  0:00:02

-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 02, 2023 at 11:21 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `payroll`
--
CREATE DATABASE IF NOT EXISTS `payroll` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `payroll`;

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`202011014`@`localhost` PROCEDURE `addEmployee` (IN `var_empcode` VARCHAR(10), IN `var_fname` VARCHAR(50), IN `var_mname` VARCHAR(50), IN `var_lname` VARCHAR(50), IN `var_extname` VARCHAR(6), IN `var_region` TEXT, IN `var_province` TEXT, IN `var_citymun` TEXT, IN `var_brgy` TEXT, IN `var_house` TEXT, IN `var_position` VARCHAR(50), IN `var_email` VARCHAR(100), IN `var_civil` TINYINT(1), IN `var_sex` TINYINT(1), IN `var_bdate` DATE, IN `var_username` VARCHAR(50), IN `var_password` VARCHAR(100), IN `var_role` TINYINT(1), IN `var_basicpay` DECIMAL(9,2), IN `var_sssded` DECIMAL(9,2), IN `var_phded` DECIMAL(9,2), IN `var_wtaxded` DECIMAL(9,2), IN `var_pagibig` DECIMAL(9,2))  NO SQL BEGIN
	DECLARE EXIT HANDLER FOR SQLWARNING
    BEGIN
    	ROLLBACK;
    END;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
    	ROLLBACK;
    END;
    
	START TRANSACTION;
        INSERT INTO tbl_employees(fld_empcode, fld_fname, fld_mname, fld_lname, fld_extname, fld_region, fld_province, fld_citymun, fld_brgy, fld_house, fld_position, fld_email, fld_civil, fld_sex, fld_bdate) VALUES (var_empcode, var_fname, var_mname, var_lname, var_extname, var_region, var_province, var_citymun, var_brgy, var_house, var_position, var_email, var_civil, var_sex, var_bdate);

        INSERT INTO tbl_accounts(fld_empcode, fld_username, fld_password, fld_role) VALUES (var_empcode, var_username, var_password, var_role);

        INSERT INTO tbl_payinfo(fld_empcode, fld_basicpay, fld_sssded, fld_phded, fld_wtaxded, fld_pagibig) VALUES (var_empcode, var_basicpay, var_sssded, var_phded, var_wtaxded, var_pagibig);
    COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `addPayroll` (IN `var_empcode` VARCHAR(10), IN `var_ot` DECIMAL(9,2), IN `var_netpay` DECIMAL(9,2), IN `var_grosspay` DECIMAL(9,2), IN `var_startperiod` DATE, IN `var_endperiod` DATE)   BEGIN
	DECLARE EXIT HANDLER FOR SQLWARNING
    BEGIN
    	ROLLBACK;
    END;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
    	ROLLBACK;
    END;
    
	START TRANSACTION;
		INSERT INTO `tbl_payroll`(`fld_empcode`, `fld_ot`, `fld_netpay`, `fld_grosspay`, `fld_startperiod`, `fld_endperiod`) VALUES (var_empcode, var_ot, var_netpay, var_grosspay, var_startperiod, var_endperiod);
    COMMIT;
END$$

CREATE DEFINER=`202011014`@`localhost` PROCEDURE `authLogin` (IN `var_username` VARCHAR(50))  MODIFIES SQL DATA SELECT * FROM tbl_accounts WHERE fld_username=var_username$$

CREATE DEFINER=`202011014`@`localhost` PROCEDURE `changePass` (IN `var_username` VARCHAR(50), IN `var_password` VARCHAR(50))   UPDATE tbl_accounts SET 
fld_password = var_password WHERE fld_username = var_username$$

CREATE DEFINER=`202011014`@`localhost` PROCEDURE `deleteEmployees` (IN `var_empcode` INT)   BEGIN
    START TRANSACTION;

    -- Delete from tbl_employees
    DELETE FROM tbl_employees WHERE fld_empcode = var_empcode;

    -- Delete from tbl_accounts
    DELETE FROM tbl_accounts WHERE fld_empcode = var_empcode;

    -- Delete from tbl_payroll
    DELETE FROM tbl_payroll WHERE fld_empcode = var_empcode;

    -- Delete from tbl_payinfo
    DELETE FROM tbl_payinfo WHERE fld_empcode = var_empcode;

    COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getEmployee` (IN `var_empcode` INT)   SELECT 
	tbl_employees.*,
    tbl_payinfo.*
FROM tbl_employees
INNER JOIN tbl_payinfo USING (fld_empcode)
WHERE fld_empcode = var_empcode$$

CREATE DEFINER=`202011014`@`localhost` PROCEDURE `getEmployees` ()  NO SQL SELECT 
	tbl_employees.*,
    tbl_payinfo.*
FROM tbl_employees
INNER JOIN tbl_payinfo USING (fld_empcode)$$

CREATE DEFINER=`202011014`@`localhost` PROCEDURE `updateEmployeeInfo` (IN `var_empcode` VARCHAR(10), IN `var_fname` VARCHAR(50), IN `var_mname` VARCHAR(50), IN `var_lname` VARCHAR(50), IN `var_extname` VARCHAR(4), IN `var_region` TEXT, IN `var_province` TEXT, IN `var_citymun` TEXT, IN `var_brgy` TEXT, IN `var_house` TEXT, IN `var_position` VARCHAR(50), IN `var_email` VARCHAR(100), IN `var_civil` TINYINT(1), IN `var_sex` TINYINT(1), IN `var_bdate` DATE)   UPDATE tbl_employees SET 
    fld_fname = var_fname, fld_mname = var_mname, fld_lname = var_lname, fld_extname = var_extname, fld_region = var_region, fld_province = var_province, fld_citymun = var_citymun, fld_brgy = var_brgy, fld_house = var_house, fld_position = var_position, fld_email = var_email, fld_civil = var_civil, fld_sex = var_sex, fld_bdate = var_bdate 
    WHERE fld_empcode = var_empcode$$

CREATE DEFINER=`202011014`@`localhost` PROCEDURE `updatePayInfo` (IN `var_empcode` VARCHAR(10), IN `var_basicpay` DECIMAL(9,2), IN `var_sssded` DECIMAL(9,2), IN `var_wtaxded` DECIMAL(9,2), IN `var_pagibig` DECIMAL(9,2), IN `var_phded` DECIMAL(9,2))   UPDATE tbl_payinfo SET
fld_basicpay = var_basicpay, fld_sssded = var_sssded, fld_wtaxded = var_wtaxded, fld_pagibig = var_pagibig , fld_phded = var_phded
WHERE fld_empcode = var_empcode$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_accounts`
--

CREATE TABLE `tbl_accounts` (
  `fld_empcode` varchar(10) NOT NULL,
  `fld_username` varchar(50) DEFAULT NULL,
  `fld_password` varchar(100) DEFAULT NULL,
  `fld_role` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_accounts`
--

INSERT INTO `tbl_accounts` (`fld_empcode`, `fld_username`, `fld_password`, `fld_role`) VALUES
('3274', 'none', '321', 1),
('69', 'a', '32432', 1),
('69420', 'superzine', 'password', 1),
('420', 'superzine', 'password', 1);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_employees`
--

CREATE TABLE `tbl_employees` (
  `fld_empcode` varchar(10) NOT NULL,
  `fld_fname` varchar(50) DEFAULT NULL,
  `fld_mname` varchar(50) DEFAULT NULL,
  `fld_lname` varchar(50) DEFAULT NULL,
  `fld_extname` varchar(4) DEFAULT NULL,
  `fld_region` text DEFAULT NULL,
  `fld_province` text DEFAULT NULL,
  `fld_citymun` text DEFAULT NULL,
  `fld_brgy` text DEFAULT NULL,
  `fld_house` text DEFAULT NULL,
  `fld_position` varchar(50) DEFAULT NULL,
  `fld_email` varchar(100) DEFAULT NULL,
  `fld_civil` tinyint(1) NOT NULL DEFAULT 0,
  `fld_sex` tinyint(1) NOT NULL DEFAULT 0,
  `fld_bdate` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_employees`
--

INSERT INTO `tbl_employees` (`fld_empcode`, `fld_fname`, `fld_mname`, `fld_lname`, `fld_extname`, `fld_region`, `fld_province`, `fld_citymun`, `fld_brgy`, `fld_house`, `fld_position`, `fld_email`, `fld_civil`, `fld_sex`, `fld_bdate`) VALUES
('3274', 'Carlos', 'Dadors', 'Ramos', 'II', 'Region III', 'Zambales', 'Olongapo', 'Sta Rita', 'Jasmin', 'Sixty Nine', '202011012@gordoncollege.edu.ph', 1, 1, '2002-09-09'),
('69', 'a', 'a', 'Pogi', 'II', 'a', 'a', 'Olongapo', 'Sta Rita', 'Jasmin', 'Sixty Nine', 'johncarlodramos08@gmail.com', 1, 1, '2002-09-09'),
('69420', 'Totoy', 'Totoyan', 'Tinotoy', 'Toy', 'III', 'Zambales', 'Olongapo', 'Santa Rita', 'Jasmin Street', 'Sixty Nine', '202011014@gordoncollege.edu.ph', 1, 1, '2002-09-09'),
('420', 'Tinototoyan', 'Totoyan', 'Tinotoy', 'Toy', 'III', 'Zambales', 'Olongapo', 'Santa Rita', 'Jasmin Street', 'Sixty Nine', '202011014@gordoncollege.edu.ph', 1, 1, '2002-09-09');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_payinfo`
--

CREATE TABLE `tbl_payinfo` (
  `fld_empcode` varchar(10) NOT NULL,
  `fld_basicpay` decimal(9,2) NOT NULL DEFAULT 0.00,
  `fld_sssded` decimal(9,2) NOT NULL DEFAULT 0.00,
  `fld_phded` decimal(9,2) NOT NULL DEFAULT 0.00,
  `fld_wtaxded` decimal(9,2) NOT NULL DEFAULT 0.00,
  `fld_pagibig` decimal(9,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_payinfo`
--

INSERT INTO `tbl_payinfo` (`fld_empcode`, `fld_basicpay`, `fld_sssded`, `fld_phded`, `fld_wtaxded`, `fld_pagibig`) VALUES
('3274', 0.01, 0.01, 0.01, 0.01, 0.01),
('69', 100.10, 100.10, 100.10, 100.10, 100.10),
('69420', 69.42, 69.42, 69.42, 69.42, 69.42),
('420', 69.42, 69.42, 69.42, 69.42, 69.42);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_payroll`
--

CREATE TABLE `tbl_payroll` (
  `fld_empcode` varchar(10) NOT NULL,
  `fld_ot` decimal(9,2) NOT NULL DEFAULT 0.00,
  `fld_netpay` decimal(9,2) NOT NULL DEFAULT 0.00,
  `fld_grosspay` decimal(9,2) NOT NULL DEFAULT 0.00,
  `fld_startperiod` date DEFAULT NULL,
  `fld_endperiod` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_payroll`
--

INSERT INTO `tbl_payroll` (`fld_empcode`, `fld_ot`, `fld_netpay`, `fld_grosspay`, `fld_startperiod`, `fld_endperiod`) VALUES
('420', 69.42, 69.42, 69.42, '2023-06-23', '2023-06-23');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

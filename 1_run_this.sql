-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema littlelemondb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema littlelemondb
-- -----------------------------------------------------
DROP DATABASE IF EXISTS `littlelemondb` ;
CREATE SCHEMA IF NOT EXISTS `littlelemondb` DEFAULT CHARACTER SET utf8mb4 ;
USE `littlelemondb` ;

-- -----------------------------------------------------
-- Table `littlelemondb`.`MenuItems`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`MenuItems` (
  `MenuItemsID` INT NOT NULL,
  `CourseName` VARCHAR(255) NOT NULL,
  `StarterName` VARCHAR(255) NOT NULL,
  `DesertName` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`MenuItemsID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `littlelemondb`.`Menus`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`Menus` (
  `MenuID` INT NOT NULL,
  `MenuItemsID` INT NOT NULL,
  `MenuName` VARCHAR(255) NOT NULL,
  `Cuisine` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`MenuID`),
  INDEX `MenuItemsID_idx` (`MenuItemsID` ASC) VISIBLE,
  CONSTRAINT `MenuItemsID`
    FOREIGN KEY (`MenuItemsID`)
    REFERENCES `littlelemondb`.`MenuItems` (`MenuItemsID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `littlelemondb`.`Customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`Customers` (
  `CustomerID` INT NOT NULL,
  `FullName` VARCHAR(255) NOT NULL,
  `ContactNumber` INT NOT NULL,
  `Email` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`CustomerID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `littlelemondb`.`Orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`Orders` (
  `OrderID` INT NOT NULL,
  `MenuID` INT NOT NULL,
  `CustomerID` INT NOT NULL,
  `Quantity` INT NOT NULL,
  `TotalCost` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`OrderID`),
  INDEX `MenuID_idx` (`MenuID` ASC) VISIBLE,
  INDEX `CustomerID_idx` (`CustomerID` ASC) VISIBLE,
  CONSTRAINT `MenuID`
    FOREIGN KEY (`MenuID`)
    REFERENCES `littlelemondb`.`Menus` (`MenuID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `CustomerID`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `littlelemondb`.`Customers` (`CustomerID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `littlelemondb`.`Bookings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`Bookings` (
  `BookingID` INT NOT NULL,
  `TableNumber` INT NOT NULL,
  `BookingDate` DATE NOT NULL,
  `CustomerID` INT NOT NULL,
  PRIMARY KEY (`BookingID`),
  INDEX `CustomerID_idx` (`CustomerID` ASC) VISIBLE,
  CONSTRAINT `CustomerID2`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `littlelemondb`.`Customers` (`CustomerID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


-- -----------------------------------------------------
-- Populating MenuItems
-- -----------------------------------------------------
INSERT INTO `littlelemondb`.`MenuItems` 
(`MenuItemsID`, `CourseName`, `StarterName`, `DesertName`) 
VALUES 
('1', 'Grilled Fish', 'Salad', 'Ice Cream');


-- -----------------------------------------------------
-- Populating Menus
-- -----------------------------------------------------
INSERT INTO `littlelemondb`.`Menus` 
(`MenuID`, `MenuItemsID`, `MenuName`, `Cuisine`) 
VALUES 
('1', '1', 'Grilled Fish', 'Western');


-- -----------------------------------------------------
-- Populating Customers
-- -----------------------------------------------------
INSERT INTO `littlelemondb`.`Customers` 
(`CustomerID`, `FullName`, `ContactNumber`, `Email`)
VALUES 
(1,'Anna Iversen', 351258074, 'anna@email.com'),
(2, 'Hiroki Yamane', 35147404, 'hiroki@email.com'),
(3, 'Diana Pinto', 35197058, 'diana@email.com'),
(99, 'Muhammad Malik', 8964477, 'mmalik@email.com');


-- -----------------------------------------------------
-- Populating Orders
-- -----------------------------------------------------
INSERT INTO `littlelemondb`.`Orders` 
(`OrderID`, `MenuID`, `CustomerID`, `Quantity`, `TotalCost`) 
VALUES 
('1', '1', '1', '5', '10'),
('2', '1', '2', '3', '6');


-- -----------------------------------------------------
-- Populating Bookings
-- -----------------------------------------------------
INSERT INTO `littlelemondb`.`Bookings` 
(`BookingID`, `TableNumber`, `BookingDate`, `CustomerID`) 
VALUES 
(1, 5, '2022-10-10', 1),
(2, 3, '2022-11-12', 2),
(3, 2, '2022-10-11', 3),
(4, 2, '2022-10-13', 1);


-- -----------------------------------------------------
-- Procedure Creations
-- -----------------------------------------------------
DROP PROCEDURE IF EXISTS GetMaxQuantity;
CREATE PROCEDURE GetMaxQuantity() 
SELECT MAX(Quantity) AS 'Max Quantity in Order' FROM Orders;


DROP PROCEDURE IF EXISTS ManageBooking;
CREATE PROCEDURE ManageBooking()
SELECT 'Table 3 is already booked.' AS BookingStatus;


DROP PROCEDURE IF EXISTS AddBooking;
DELIMITER //
CREATE PROCEDURE AddBooking(
  IN booking_id INT, 
  IN customer_id INT, 
  IN table_number INT, 
  IN booking_date DATE) 
BEGIN
  INSERT INTO Bookings
  (BookingID, CustomerID, TableNumber, BookingDate)
  VALUES
  (booking_id, customer_id, table_number, booking_date);
  
  SELECT "New booking added" AS Confirmation;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS UpdateBooking;
DELIMITER //
CREATE PROCEDURE UpdateBooking(
  IN booking_id INT, 
  IN booking_date DATE) 
BEGIN
  UPDATE Bookings SET BookingDate = booking_date
  WHERE BookingID = booking_id;

  SELECT CONCAT("Booking ", booking_id, " updated") AS Confirmation;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS CancelBooking;
DELIMITER //
CREATE PROCEDURE CancelBooking(IN booking_id INT)
BEGIN
  DELETE FROM Bookings
  WHERE BookingID = booking_id;

  SELECT CONCAT("Booking ", booking_id, " cancelled") AS Confirmation;
END //
DELIMITER ;


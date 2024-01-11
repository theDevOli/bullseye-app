-- Bullseye 2024 DB SQL Script
-- version 1.00_COMPLETE
-- June 12, 2023
-- 

-- ********************************************
-- ****       Create Database         ****
-- ********************************************
-- 
drop database if exists bullseyedb2024;
create database bullseyedb2024;
ALTER database bullseyedb2024 CHARACTER SET utf8 COLLATE utf8_general_ci;

use bullseyedb2024;

-- ********************************************
-- ****       Create lookup tables         ****
-- ********************************************
-- category, province, position, site, txnstatus, txntype, employee, vehicle, supplier

--
-- Create table `category`
--
CREATE TABLE category (
  categoryName varchar(32) NOT NULL PRIMARY KEY
);

--
-- Create table `province`
-- 
CREATE TABLE `province` (
  `provinceID` varchar(2) NOT NULL PRIMARY KEY,
  `provinceName` varchar(20) NOT NULL,
  `countryCode` varchar(50) NOT NULL
);

--
-- Create table `posn`
--
CREATE TABLE `posn` (
  `positionID` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `permissionLevel` varchar(20) NOT NULL
);

--
-- Create table `txnstatus`
--
CREATE TABLE `txnstatus` (
  `statusName` varchar(20) NOT NULL PRIMARY KEY,
  `statusDescription` varchar(100) NOT NULL
);

--
-- Create table `txntype`
--
CREATE TABLE `txntype` (
  `txnType` varchar(20) NOT NULL PRIMARY KEY
);

--
-- Create table `vehicle`
--
CREATE TABLE `vehicle` (
  `vehicleType` varchar(20) NOT NULL PRIMARY KEY,
  `maxWeight` decimal(10,0) NOT NULL,
  `HourlyTruckCost` decimal(10,2) NOT NULL,
  `costPerKm` decimal(10,2) NOT NULL,
  `notes` varchar(255) NOT NULL
);

--
-- Create table `sitetype`
--
CREATE TABLE `sitetype` (
  `siteType` varchar(50) NOT NULL PRIMARY KEY,
  `notes` varchar(255) DEFAULT NULL
);

--
-- Create table `site`
--
CREATE TABLE `site` (
  `siteID` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` varchar(50) NOT NULL,
  `provinceID` varchar(2) NOT NULL,
  `address` varchar(50) NOT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `city` varchar(50) NOT NULL,
  `country` varchar(50) NOT NULL,
  `postalCode` varchar(14) NOT NULL,
  `phone` varchar(14) NOT NULL,
  `dayOfWeek` varchar(50),
  `distanceFromWH` int(11) NOT NULL,
  `siteType` varchar(50) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  FOREIGN KEY(`provinceID`) REFERENCES province(`provinceID`),
  FOREIGN KEY(`siteType`) REFERENCES sitetype(`siteType`)
);


--
-- Create table `employee`
--
CREATE TABLE `employee` (
  `employeeID` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `username` varchar(32) NOT NULL UNIQUE,
  `password` varchar(32) NOT NULL,
  `firstName` varchar(20) NOT NULL,
  `lastName` varchar(20) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `locked` tinyint(1) NOT NULL,
  `positionID` int(11) NOT NULL,
  `siteID` int(11) NOT NULL,
  FOREIGN KEY(`PositionID`) REFERENCES posn(`PositionID`),
  FOREIGN KEY(`siteID`) REFERENCES `site`(`siteID`)
);

--
-- Create table `permissions`
--
CREATE TABLE `permission` (
  `permissionID` varchar(20) NOT NULL PRIMARY KEY
);

--
-- Create table `user_permissions`
--
CREATE TABLE `user_permission` (
  `employeeID`int(11), 
  `permissionID` varchar(20),
  PRIMARY KEY (`employeeID`, `permissionID`), 
  FOREIGN KEY(`employeeID`) REFERENCES employee(`employeeID`),
  FOREIGN KEY(`permissionID`) REFERENCES permission(`permissionID`)
);

--
-- Create table `supplier`
--
CREATE TABLE `supplier` (
  `supplierID` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` varchar(50) NOT NULL,
  `address` varchar(50) NOT NULL,
  `city` varchar(50) NOT NULL,
  `country` varchar(50) NOT NULL,
  `province` varchar(2) NOT NULL,
  `postalcode` varchar(11) NOT NULL,
  `phone` varchar(14) NOT NULL,
  `contact` varchar(100) DEFAULT NULL,
  `active` tinyint(1) NOT NULL  DEFAULT 1,
  FOREIGN KEY(`province`) REFERENCES province(`provinceID`)
);

--
-- Create table `item`
--
CREATE TABLE `item` (
  `itemID` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` varchar(100) NOT NULL,
  `sku` varchar(20) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `category` varchar(32) NOT NULL,
  `weight` decimal(10,2) NOT NULL,
  `costPrice` decimal(10,2) NOT NULL,
  `retailPrice` decimal(10,2) NOT NULL,
  `supplierID` int(11) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `notes` varchar(255) DEFAULT NULL,
  `caseSize` int(11) NOT NULL,
  FOREIGN KEY (`supplierID`) REFERENCES `supplier` (`supplierID`),
  FOREIGN KEY (`category`) REFERENCES `category` (`categoryName`)
);

--
-- Create table `delivery`
-- 
CREATE TABLE `delivery` (
  `deliveryID` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `distanceCost` decimal(10,2) NOT NULL,
  `vehicleType` varchar(20) NOT NULL,
  `notes` varchar(255) DEFAULT NULL,
  FOREIGN KEY (`vehicleType`) REFERENCES `vehicle` (`vehicleType`)  
);

--
-- Create table `txn`
--
CREATE TABLE `txn` (
  `txnID` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `siteIDTo` int(11) NOT NULL,
  `siteIDFrom` int(11) NOT NULL,
  `status` varchar(20) NOT NULL,
  `shipDate` datetime NOT NULL,
  `txnType` varchar(20) NOT NULL,
  `barCode` varchar(50),
  `createdDate` datetime NOT NULL,
  `deliveryID` int(11) DEFAULT NULL,
  `emergencyDelivery` tinyint(1) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  FOREIGN KEY (`siteIDTo`) REFERENCES `site` (`siteID`),
  FOREIGN KEY (`siteIDFrom`) REFERENCES `site` (`siteID`),
  FOREIGN KEY (`status`) REFERENCES `txnstatus` (`statusName`),
  FOREIGN KEY (`txnType`) REFERENCES `txntype` (`txnType`),
  FOREIGN KEY (`deliveryID`) REFERENCES `delivery` (`deliveryID`)
);

--
-- Create table `txnaudit`
--
CREATE TABLE `txnaudit` (
  `txnAuditID` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `txnID` int(11),
  `txnType` varchar(20),
  `status` varchar(20),
  `txnDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `SiteID` int(11) NOT NULL,
  `deliveryID` int(11),
  `employeeID` int(11),
  `notes` varchar(255) DEFAULT NULL,
  FOREIGN KEY (`SiteID`) REFERENCES `site` (`siteID`),
  FOREIGN KEY (`employeeID`) REFERENCES `employee` (`employeeID`)
);

--
-- Create table `txnitems`
--
CREATE TABLE `txnitems` (
  `txnID` int(11) NOT NULL,
  `ItemID` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  PRIMARY KEY (`txnID`,`ItemID`),
  FOREIGN KEY (`txnID`) REFERENCES `txn` (`txnID`),
  FOREIGN KEY (`ItemID`) REFERENCES `item` (`itemID`)
);

--
-- Create table `inventory`
--
CREATE TABLE `inventory` (
  `itemID` int(11) NOT NULL,
  `siteID` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `itemLocation` varchar(20),
  `reorderThreshold` int(11) DEFAULT NULL,
  PRIMARY KEY (`itemID`,`siteID`),
  FOREIGN KEY (`itemID`) REFERENCES `item` (`itemID`),
  FOREIGN KEY (`siteID`) REFERENCES `site` (`siteID`)
); 
 

-- 
-- ********************************************
-- ****       Insert Data                  ****
-- ********************************************
-- 

--
-- Insert data for table `category`
--
INSERT INTO `category` (`categoryName`) VALUES
('Apparel'),
('Camping'),
('Fitness'),
('Footwear'),
('Sports Equipment');

--
-- Insert data for table `position`
--
INSERT INTO `posn` (`positionID`, `permissionLevel`) VALUES
(1, 'Regional Manager'),
(2, 'Financial Manager'),
(3, 'Store Manager'),
(4, 'Warehouse Manager'),
(5, 'Delivery'),
(6, 'Warehouse'),
(99999999, 'Administrator');

--
-- Insert data for table `province`
--
INSERT INTO `province` (`provinceID`, `provinceName`, `countryCode`) VALUES
('NB', 'New Brunswick', 'Canada'),
('AB', 'Alberta', 'Canada'),
('BC', 'British Columbia', 'Canada'),
('MB', 'Manitoba', 'Canada'),
('NL', 'Newfoundland and Lab', 'Canada'),
('NS', 'Nova Scotia', 'Canada'),
('NT', 'Northwest Territorie', 'Canada'),
('NU', 'Nunavut', 'Canada'),
('ON', 'Ontario', 'Canada'),
('PE', 'Prince Edward Island', 'Canada'),
('QC', 'Quebec', 'Canada'),
('SK', 'Saskatchewan', 'Canada'),
('YT', 'Yukon', 'Canada');


--
-- Insert data for table `site`
--
INSERT INTO `sitetype` (`siteType`, `notes`) VALUES
('Warehouse', 'Warehouse Location'),
('Retail', 'Retail Location'),
('Office', 'Office Location'),
('Truck', 'Delivery Truck');
--
-- Insert data for table `site`
--
INSERT INTO `site` (`siteID`, `name`, `provinceID`, `address`, `address2`, `city`, `country`, `postalCode`, `phone`, `dayOfWeek`, `distanceFromWH`, `siteType`, `notes`, `active`) VALUES
(1, 'Warehouse', 'NB', '438 Grandview Avenue', NULL, 'Saint John', 'Canada', 'E2J4M9', 5066966228, 'SATURDAY',0, 'Warehouse', NULL, 1),
(2, 'Warehouse Bay', 'NB', '438 Grandview Avenue', NULL, 'Saint John', 'Canada', 'E2J4M9', 5066966228, 'SATURDAY', 0, 'Warehouse', NULL, 1),
(3, 'Corporate', 'NB', '950 Grandview Avenue', NULL, 'Saint John', 'Canada', 'E2L3V1', 5066966666, 'SATURDAY', 0, 'Office', NULL, 1),
(4, 'Saint John', 'NB', '519 Westmorland Road', NULL, 'Saint John', 'Canada', 'E2J3W9', 5066966229, 'MONDAY', 5, 'Retail', NULL, 1),
(5, 'Sussex', 'NB', '565 Main Street', NULL, 'Sussex', 'Canada', 'E4E7H4', 5066966230, 'FRIDAY', 74, 'Retail', NULL, 1),
(6, 'Moncton', 'NB', '1380 Mountain Road', 'Unit 46', 'Moncton', 'Canada', 'E1C2T8', 5066966231, 'TUESDAY', 150, 'Retail', NULL, 1),
(7, 'Dieppe', 'NB', '477 Paul Street', NULL, 'Dieppe', 'Canada', 'E1A4X5', 5066966232, 'TUESDAY', 157, 'Retail', NULL, 1),
(8, 'Oromocto', 'NB', '273 Restigouche Road', NULL, 'Oromocto', 'Canada', 'E2V2H1', 5066966233, 'WEDNESDAY', 96, 'Retail', NULL, 1),
(9, 'Fredericton', 'NB', '1381 Regent Street', 'Unit Y200A', 'Fredericton', 'Canada', 'E3C1A2', 5066966234, 'WEDNESDAY', 116, 'Retail', NULL, 1),
(10, 'Miramichi', 'NB', '2441 King George Highway', NULL, 'Miramichi', 'Canada', 'E1V6W2', 5066966235, 'THURSDAY', 270, 'Retail', NULL, 1),
(11, 'Curbside', 'NB', 'Curbside', NULL, 'Curbside', 'Canada', '', 0 , '',0, 'Retail', NULL, 1),
(9999, 'Truck', 'NB', '1063 Bayside Drive', NULL, 'Saint John', 'Canada', 'E2J4Y2', 5066966236, 'SUNDAY', 0, 'Truck', NULL,1);

--
-- Insert data for table `employee`
--
INSERT INTO `employee` (`employeeID`, `username`, `password`, `firstName`, `lastName`, `email`, `active`, `locked`,`siteID`, `positionID`) VALUES
(1, 'admin', 'admin', 'Admin', 'Admin', 'admin@bullseye.ca', 1, 0, 3, 99999999),
(1000, 'econcepcion', 'econcepcion', 'Eduardo', 'Concepcion', 'econcepcion@bullseye.ca', 1, 0, 3, 1),
(1001, 'mmunoz', 'mmunoz', 'Monica', 'Munoz', 'mmunoz@bullseye.ca', 1, 0, 3, 2),
(1002, 'jperez', 'jperez', 'Jose', 'Perez', 'jperez@bullseye.ca', 1, 0, 4, 3),
(1003, 'cpatstone', 'cpatstone', 'Chris', 'Patstone', 'cpatstone@bullseye.ca', 1, 0, 1, 4),
(1004, 'cnorris', 'cnorris', 'Charles', 'Norris', 'cnorris@bullseye.ca', 1, 0, 1, 5),
(1005, 'kblanche', 'kblanche', 'Kevin', 'Blanche', 'kblanche@bullseye.ca', 1, 0, 5, 3),
(1006, 'wbray', 'wbray', 'Willow', 'Bray', 'wbray@bullseye.ca', 1, 0, 6, 3),
(1007, 'tgraupel', 'tgraupel', 'Tansy', 'Graupel', 'tgraupel@bullseye.ca', 1, 0, 7, 3),
(1008, 'syuasa', 'syuasa', 'Shuncho', 'Yuasa', 'syuasa@bullseye.ca', 1, 0, 8, 3),
(1009, 'ebyron', 'ebyron', 'Emi', 'Byron', 'ebyron@bullseye.ca', 1, 0, 9, 3),
(1010, 'abean', 'abean', 'Arabella', 'Bean', 'abean@bullseye.ca', 1, 0, 10, 3),
(1012, 'thattie', 'thattie', 'Hattie', 'Trent', 'htrent@bullseye.ca', 1, 0, 3, 6),
(1013, 'bcallan', 'bcallan', 'Berniece', 'Callan', 'bcallan@bullseye.ca', 1, 0, 1, 6),
(1014, 'eatherton', 'eatherton', 'Erika', 'Atherton', 'eatherton@bullseye.ca', 1, 0, 3, 6),
(1015, 'acadia', 'acadia', 'acadia', 'acadia', 'info@acadiatrucking.ca', 1, 0, 9999, 5);

--
-- Insert data for table `permission`
--
INSERT INTO `permission` (`permissionID`) VALUES
('Regional Manager'),
('Financial Manager'),
('Store Manager'),
('Warehouse Manager'),
('Delivery'),
('Warehouse Employee'),
('Administrator');

--
-- Insert data for table `user_permission`
-- Give ADMIN user all permissions to start
--
INSERT INTO `user_permission` (`employeeID`, `permissionID`) VALUES
(1, 'Administrator');

--
-- Insert data for table `txntype`
--
INSERT INTO `txntype` (`txnType`) VALUES
('Store Order'),
('Emergency Order'),
('Back Order'),
('Damage'),
('Gain'),
('Loss'),
('Rejected'),
('Return'),
('Sale'),
('Supplier Order'),
('Correction'),
('Curbside'),
('Online'),
('Login'),
('Logout');

--
-- Insert data for table `txnstatus`
--
INSERT INTO `txnstatus` (`statusName`, `statusDescription`) VALUES
('NEW', 'Order is newly created by Store Manager or designate'),
('SUBMITTED', 'Order has been submitted by the store to the warehouse but not yet assigned to the floor'),
('RECEIVED', 'Order has been received by the Warehouse manager or designate'),
('PROCESSING', 'Order is being processed by warehouse staff'),
('READY', 'Order is ready for pickup'),
('IN TRANSIT', 'Order is on the truck and on its way to the store'),
('DELIVERED', 'Order has been delivered to the store'),
('CLOSED', 'Order has been received and accounted for by the store'),
('BACKORDER', 'Backorder has been created and is in progress'),
('REJECTED', 'Order is rejected by the warehouse (Item no longer exists etc...)'),
('CANCELLED', 'Order is cancelled by originating site or by the warehouse manager');

--
-- Insert data for table `vehicle`
--
INSERT INTO `vehicle` (`vehicleType`, `maxWeight`, `HourlyTruckCost`, `costPerKm`, `notes`) VALUES
('Heavy', '20000', '35.00', '3.50', ''),
('Medium', '10000', '25.00', '2.50', ''),
('Small', '5000', '20.00', '1.25', ''),
('Van', '1000', '10.00', '0.75', ''),
('Pickup', '500', '0.00', '0.00', ''),
('Courier', '5000', '50.00', '0.00', '');

--
-- Insert data for table `supplier`
--
INSERT INTO `supplier` (`supplierID`, `name`, `address`, `city`, `country`, `province`, `postalcode`, `phone`, `contact`) VALUES
(10000, 'Reebok', '65 Bluebird Dr', 'Charlotte', 'Canada', 'PE', 'A2V1L6', 5412365874, 'Jesse Custer'),
(11000, 'Spalding', '88 Quality St', 'St George', 'Canada', 'NB', 'E5C3N2', 25655896, 'Tulip Ohare'),
(11111, 'Burton', '20 Troque St', 'Montreal', 'Canada', 'QC', 'H3B5L1', 5149872222, 'John Smith'),
(22222, 'TaylorMade', '1841 Argyle St', 'Halifax', 'Canada', 'NS', 'B3J3AS', 6561587896, 'Smithers Johnson'),
(33333, 'New Balance', '44 Acacia Ave', 'Toronto', 'Canada', 'ON', 'M5H2N2', 4547892645, 'Cat Deely'),
(44444, 'Nike', '1701 Knotta Ave','London', 'Canada', 'ON', 'N6A4L9', 2358964785, 'Garth Ennis'),
(55555, 'Northface', '87 Blue st', 'Saint John', 'Canada', 'NB', 'E2L1P1', 2548963287, 'Warren Ellis'),
(66666, 'CCM', '9001 Power Lane', 'Edmonton', 'Canada', 'AB', 'T5K2R7', 8745875896, 'Wayne Gretzsky'),
(77777, 'Bauer', '909 Poplar Cove', 'Fredericton', 'Canada', 'NB', 'E8T6P0', 3579511478, 'Alan Shearer'),
(88888, 'Coleman', '454 George St', 'Bordon', 'Canada', 'NB', 'E7L4PN', 9632147896, 'Frank Drebbin'),
(99999, 'UnderArmor', '189 Frank st', 'Sussex', 'Canada', 'NB', 'E3R5Q0', 3217418965, 'Joseph Dredd');

--
-- Insert data for table `delivery`
--
INSERT INTO `delivery` (`deliveryID`, `distanceCost`, `vehicleType`, `notes`) VALUES
(1, '6.25', 'Small', NULL),
(2, '259.00', 'Heavy', NULL),
(3, '290.00', 'Medium', NULL),
(4, '17.50', 'Heavy', NULL),
(5, '202.50', 'Van', NULL),
(6, '187.50', 'Small', NULL),
(7, '117.75', 'Van', NULL),
(8, '12.50', 'Medium', NULL),
(9, '259.00', 'Heavy', NULL),
(10, '92.50', 'Small', NULL),
(11, '17.50', 'Heavy', NULL),
(12, '240.00', 'Medium', NULL),
(13, '112.50', 'Van', NULL),
(14, '180.00', 'Van', NULL),
(15, '196.25', 'Small', NULL),
(16, '259.00', 'Heavy', NULL),
(17, '336.00', 'Heavy', NULL),
(18, '145.00', 'Small', NULL),
(19, '55.50', 'Van', NULL),
(20, '675.00', 'Medium', NULL);

--
-- Insert data for table `item`
--
INSERT INTO `item` (`itemID`, `name`, `sku`, `description`, `category`, `weight`, `costPrice`, `retailPrice`, `supplierID`, `active`, `notes`, `caseSize`) VALUES
(10000, 'Jetspeed FT1 Senior Ice Hockey Skates', '60000', 'single pair of hockey skates', 'Sports Equipment', '5.00', '250.00', '999.99', 66666, 1, NULL, 1),
(10001, 'Super Tacks AS1 Senior Ice Hockey Skates', '60001', 'single pair of hockey skates', 'Sports Equipment', '5.00', '250.00', '999.99', 66666, 1, NULL, 1),
(10002, 'Supreme 2S Pro Senior Ice Hockey Skates', '60002', 'single pair of hockey skates', 'Sports Equipment', '5.00', '250.00', '999.99', 77777, 1, NULL, 1),
(10003, 'Nexus 2N Senior Ice Hockey Skates', '60003', 'single pair of hockey skates', 'Sports Equipment', '5.00', '150.00', '799.99', 77777, 1, NULL, 1),
(10004, 'Jetspeed FT390 Senior Ice Hockey Skates', '60004', 'single pair of hockey skates', 'Sports Equipment', '5.00', '150.00', '799.99', 66666, 1, NULL, 1),
(10005, 'Supreme 2S Senior Ice Hockey Skates', '60005', 'single pair of hockey skates', 'Sports Equipment', '5.00', '100.00', '699.99', 77777, 1, NULL, 1),
(10006, 'Vapor X900 Senior Ice Hockey Skates', '60006', 'single pair of hockey skates', 'Sports Equipment', '5.00', '100.00', '599.99', 77777, 1, NULL, 1),
(10007, 'Tacks 9080 Senior Ice Hockey Skates', '60007', 'single pair of hockey skates', 'Sports Equipment', '5.00', '100.00', '499.99', 66666, 1, NULL, 1),
(10008, 'Supreme 2S Pro Junior Ice Hockey Skates', '60008', 'single pair of hockey skates', 'Sports Equipment', '4.00', '200.00', '749.99', 77777, 1, NULL, 1),
(10009, 'Super Tacks AS1 Junior Ice Hockey Skates', '60009', 'single pair of hockey skates', 'Sports Equipment', '4.00', '200.00', '699.99', 66666, 1, NULL, 1),
(10010, 'Vapor X900 Junior Ice Hockey Skates - \'17 Model', '60010', 'single pair of hockey skates', 'Sports Equipment', '4.00', '200.00', '579.99', 77777, 1, NULL, 1),
(10011, 'Ribcor 70K Junior Ice Hockey Skates', '60011', 'single pair of hockey skates', 'Sports Equipment', '4.00', '100.00', '499.99', 66666, 1, NULL, 1),
(10012, 'Supreme S190 Junior Ice Hockey Skates', '60012', 'single pair of hockey skates', 'Sports Equipment', '4.00', '100.00', '379.99', 77777, 1, NULL, 1),
(10013, 'Vapor 1X Lite Griptac Senior Hockey Stick', '60013', 'one piece hockey stick', 'Sports Equipment', '3.00', '50.00', '339.99', 77777, 1, NULL, 20),
(10014, 'RibCor Trigger 3D Grip Senior Hockey Stick', '60014', 'one piece hockey stick', 'Sports Equipment', '3.00', '50.00', '319.99', 66666, 1, NULL, 20),
(10015, 'Nexus 2N Pro Griptac Senior Hockey Stick', '60015', 'one piece hockey stick', 'Sports Equipment', '3.00', '50.00', '319.99', 77777, 1, NULL, 20),
(10016, 'Supreme 2S Pro Grip Senior Hockey Stick', '60016', 'one piece hockey stick', 'Sports Equipment', '3.00', '50.00', '319.99', 77777, 1, NULL, 20),
(10017, 'Super Tacks AS1 Grip Senior Hockey Stick', '60017', 'one piece hockey stick', 'Sports Equipment', '3.00', '50.00', '319.99', 66666, 1, NULL, 20),
(10018, 'Jetspeed Grip Senior Hockey Stick', '60018', 'one piece hockey stick', 'Sports Equipment', '3.00', '50.00', '299.99', 66666, 1, NULL, 20),
(10019, 'Vapor 1X Griptac Senior Hockey Stick - \'15 Model', '60019', 'one piece hockey stick', 'Sports Equipment', '3.00', '50.00', '299.99', 77777, 1, NULL, 20),
(10020, 'Nexus 1N GripTac Senior Hockey Stick - \'17 Model', '60020', 'one piece hockey stick', 'Sports Equipment', '3.00', '50.00', '254.99', 77777, 1, NULL, 20),
(10021, 'RibCor Trigger2 PMT Grip Senior Hockey Stick', '60021', 'one piece hockey stick', 'Sports Equipment', '3.00', '50.00', '239.99', 66666, 1, NULL, 20),
(10022, 'Super Tacks 2.0 Grip Senior Hockey Stick', '60022', 'one piece hockey stick', 'Sports Equipment', '3.00', '50.00', '239.99', 66666, 1, NULL, 20),
(10023, 'Ultra Tacks Pro Stock Hockey Stick', '60023', 'one piece hockey stick', 'Sports Equipment', '3.00', '50.00', '219.99', 66666, 1, NULL, 20),
(10024, 'RibCor Reckoner Pro Stock Hockey Stick', '60024', 'one piece hockey stick', 'Sports Equipment', '3.00', '50.00', '219.99', 66666, 1, NULL, 20),
(10025, 'Re-Akt 200 Hockey Helmet Combo', '60025', 'hockey helmet/cage combo', 'Sports Equipment', '3.00', '100.00', '399.99', 77777, 1, NULL, 10),
(10026, 'Fitlite 3DS Hockey Helmet Combo', '60026', 'hockey helmet/cage combo', 'Sports Equipment', '3.00', '100.00', '349.99', 66666, 1, NULL, 10),
(10027, 'FL500 Senior Hockey Helmet', '60027', 'hockey helmet', 'Sports Equipment', '2.00', '50.00', '249.99', 66666, 1, NULL, 10),
(10028, 'Tacks 710 Hockey Helmet', '60028', 'hockey helmet', 'Sports Equipment', '2.00', '50.00', '199.99', 66666, 1, NULL, 10),
(10029, 'FL90 Hockey Helmet', '60029', 'hockey helmet', 'Sports Equipment', '2.00', '50.00', '169.99', 66666, 1, NULL, 10),
(10030, 'IMS 11.0 Hockey Helmet Combo', '60030', 'hockey helmet/cage combo', 'Sports Equipment', '3.00', '50.00', '149.99', 77777, 1, NULL, 10),
(10031, 'Resistance Hockey Helmet', '60031', 'hockey helmet', 'Sports Equipment', '2.00', '50.00', '149.99', 66666, 1, NULL, 10),
(10032, 'HDO Deluxe Visor', '60032', 'hockey plastic eye visor', 'Sports Equipment', '0.50', '10.00', '129.99', 77777, 1, NULL, 10),
(10033, 'Pro Clip Straight Visor Smoke - \'17 Model', '60033', 'hockey plastic eye visor', 'Sports Equipment', '0.50', '10.00', '114.99', 77777, 1, NULL, 10),
(10034, 'Pro Clip Wave Visor Clear - \'17 Model', '60034', 'hockey plastic eye visor', 'Sports Equipment', '0.50', '10.00', '114.99', 77777, 1, NULL, 10),
(10035, 'Revision Straight Certified Visor with Spacer', '60035', 'hockey plastic eye visor', 'Sports Equipment', '0.50', '10.00', '99.99', 66666, 1, NULL, 10),
(10036, 'Pro Clip Visor Replacement Lens Clear - \'17 Model', '60036', 'hockey plastic eye visor - 2 pack', 'Sports Equipment', '1.00', '10.00', '99.99', 77777, 1, NULL, 10),
(10037, 'Re-Akt Titanium Face Mask', '60037', 'protective hockey face cage', 'Sports Equipment', '1.00', '20.00', '89.99', 77777, 1, NULL, 10),
(10038, 'Hybrid Shield', '60038', 'protective hockey face cage', 'Sports Equipment', '1.00', '20.00', '74.99', 77777, 1, NULL, 10),
(10039, 'Concept 3 Junior Full Shield', '60039', 'protective hockey face cage', 'Sports Equipment', '0.50', '10.00', '64.99', 77777, 1, NULL, 10),
(10040, 'FL500 Face Cage', '60040', 'protective hockey face cage', 'Sports Equipment', '0.50', '10.00', '43.99', 77777, 1, NULL, 10),
(10041, 'Vapor 1X Lite Pro Senior Hockey Gloves', '60041', 'pair of hockey gloves', 'Sports Equipment', '1.00', '50.00', '249.99', 77777, 1, NULL, 1),
(10042, 'Nexus 2N Senior Hockey Gloves', '60042', 'pair of hockey gloves', 'Sports Equipment', '1.00', '50.00', '219.99', 77777, 1, NULL, 1),
(10043, 'Super Tacks Senior Hockey Gloves', '60043', 'pair of hockey gloves', 'Sports Equipment', '1.00', '50.00', '219.99', 66666, 1, NULL, 1),
(10044, 'Supreme 1S Senior Hockey Gloves', '60044', 'pair of hockey gloves', 'Sports Equipment', '1.00', '50.00', '219.99', 77777, 1, NULL, 1),
(10045, 'Jetspeed FT1 Senior Hockey Gloves', '60045', 'pair of hockey gloves', 'Sports Equipment', '1.00', '50.00', '219.99', 66666, 1, NULL, 1),
(10046, 'Supreme S190 Senior Hockey Gloves', '60046', 'pair of hockey gloves', 'Sports Equipment', '1.00', '50.00', '179.99', 77777, 1, NULL, 1),
(10047, 'Vapor X900 Lite Senior Hockey Gloves', '60047', 'pair of hockey gloves', 'Sports Equipment', '1.00', '50.00', '179.99', 77777, 1, NULL, 1),
(10048, 'Jetspeed FT390 Senior Hockey Gloves', '60048', 'pair of hockey gloves', 'Sports Equipment', '1.00', '50.00', '159.99', 66666, 1, NULL, 1),
(10049, 'Nexus N2900 Senior Hockey Gloves', '60049', 'pair of hockey gloves', 'Sports Equipment', '1.00', '50.00', '159.99', 77777, 1, NULL, 1),
(10050, 'Tacks 7092 Senior Hockey Gloves', '60050', 'pair of hockey gloves', 'Sports Equipment', '1.00', '50.00', '149.99', 66666, 1, NULL, 1),
(10051, 'Tacks 4 Roll Pro Senior Hockey Gloves', '60051', 'pair of hockey gloves', 'Sports Equipment', '1.00', '50.00', '146.99', 66666, 1, NULL, 1),
(10052, 'Vapor APX2 Senior Hockey Gloves', '60052', 'pair of hockey gloves', 'Sports Equipment', '1.00', '50.00', '124.99', 77777, 1, NULL, 1),
(10053, 'Tacks 5092 Senior Hockey Gloves', '60053', 'pair of hockey gloves', 'Sports Equipment', '1.00', '50.00', '119.99', 66666, 1, NULL, 1),
(10054, 'Vapor X800 Lite Senior Hockey Gloves', '60054', 'pair of hockey gloves', 'Sports Equipment', '1.00', '50.00', '119.99', 77777, 1, NULL, 1),
(10055, 'Nexus 1N Senior Ice Hockey Pants', '60055', 'pair of hockey pants', 'Sports Equipment', '3.00', '100.00', '229.99', 77777, 1, NULL, 1),
(10056, 'Jetspeed FT1 Senior Hockey Pants', '60056', 'pair of hockey pants', 'Sports Equipment', '3.00', '100.00', '219.99', 66666, 1, NULL, 1),
(10057, 'Super Tacks Senior Hockey Pants', '60057', 'pair of hockey pants', 'Sports Equipment', '3.00', '100.00', '219.99', 66666, 1, NULL, 1),
(10058, 'Nexus 2N Senior Ice Hockey Pants', '60058', 'pair of hockey pants', 'Sports Equipment', '3.00', '100.00', '229.99', 77777, 1, NULL, 1),
(10059, 'Vapor APX2 Senior Hockey Pants', '60059', 'pair of hockey pants', 'Sports Equipment', '3.00', '100.00', '199.99', 77777, 1, NULL, 1),
(10060, 'Jetspeed FT390 Senior Hockey Pants', '60060', 'pair of hockey pants', 'Sports Equipment', '3.00', '100.00', '169.99', 66666, 1, NULL, 1),
(10061, 'Tacks 7092 Senior Hockey Pants', '60061', 'pair of hockey pants', 'Sports Equipment', '3.00', '100.00', '169.99', 66666, 1, NULL, 1),
(10062, 'Pro Team 32in. Carry Hockey Equipment Bag - \'17 Model', '60062', 'carry hockey bag', 'Sports Equipment', '3.00', '20.00', '109.99', 66666, 1, NULL, 5),
(10063, 'Vapor Large Pro Carry Hockey Equipment Bag', '60063', 'carry hockey bag', 'Sports Equipment', '3.00', '20.00', '99.99', 77777, 1, NULL, 5),
(10064, 'Vapor Medium Pro Carry Hockey Equipment Bag', '60064', 'carry hockey bag', 'Sports Equipment', '3.00', '20.00', '89.99', 77777, 1, NULL, 5),
(10065, 'S14 Premium Large Carry Hockey Equipment Bag', '60065', 'carry hockey bag', 'Sports Equipment', '3.00', '20.00', '84.99', 77777, 1, NULL, 5),
(10066, 'Pro Core 38in. Carry Hockey Equipment Bag', '60066', 'carry hockey bag', 'Sports Equipment', '3.00', '20.00', '74.99', 66666, 1, NULL, 5),
(10067, '650 Large Carry Hockey Equipment Bag', '60067', 'carry hockey bag', 'Sports Equipment', '3.00', '10.00', '64.99', 77777, 1, NULL, 5),
(10068, '24in. Sport Carry Bag - \'17 Model', '60068', 'carry hockey bag', 'Sports Equipment', '3.00', '10.00', '60.99', 66666, 1, NULL, 5),
(10069, '950 Large Wheeled Hockey Equipment Bag', '60069', 'wheeled hockey bag', 'Sports Equipment', '4.00', '25.00', '179.99', 77777, 1, NULL, 5),
(10070, '950 Medium Wheeled Hockey Equipment Bag', '60070', 'wheeled hockey bag', 'Sports Equipment', '4.00', '25.00', '169.99', 77777, 1, NULL, 5),
(10071, '850 Large Wheeled Hockey Equipment Bag', '60071', 'wheeled hockey bag', 'Sports Equipment', '4.00', '25.00', '119.99', 77777, 1, NULL, 5),
(10072, 'S14 Core Medium Wheeled Hockey Equipment Bag', '60072', 'wheeled hockey bag', 'Sports Equipment', '4.00', '15.00', '84.99', 77777, 1, NULL, 5),
(10073, 'Vapor 1X Lite Senior Hockey Shoulder Pads', '60073', 'protective hockey shoulder pads', 'Sports Equipment', '1.50', '50.00', '224.99', 77777, 1, NULL, 5),
(10074, 'Supreme 1S Senior Hockey Shoulder Pads', '60074', 'protective hockey shoulder pads', 'Sports Equipment', '1.50', '50.00', '219.99', 77777, 1, NULL, 5),
(10075, 'Super Tacks Senior Hockey Shoulder Pads', '60075', 'protective hockey shoulder pads', 'Sports Equipment', '1.50', '50.00', '219.99', 66666, 1, NULL, 5),
(10076, 'Jetspeed FT1 Senior Hockey Shoulder Pads', '60076', 'protective hockey shoulder pads', 'Sports Equipment', '1.50', '50.00', '209.99', 66666, 1, NULL, 5),
(10077, 'Vapor 1X Lite Senior Hockey Shin Guards', '60077', 'protective hockey shin pads', 'Sports Equipment', '2.00', '50.00', '199.99', 77777, 1, NULL, 5),
(10078, 'Supreme 1S Senior Hockey Shin Guards', '60078', 'protective hockey shin pads', 'Sports Equipment', '2.00', '50.00', '189.99', 77777, 1, NULL, 5),
(10079, 'Jetspeed FT1 Senior Hockey Shin Guards', '60079', 'protective hockey shin pads', 'Sports Equipment', '2.00', '50.00', '179.99', 66666, 1, NULL, 5),
(10080, 'Nexus 2N Senior Hockey Shin Guards', '60080', 'protective hockey shin pads', 'Sports Equipment', '2.00', '50.00', '179.99', 77777, 1, NULL, 5),
(10081, 'Tacks 7092 Senior Hockey Shin Guards', '60081', 'protective hockey shin pads', 'Sports Equipment', '2.00', '50.00', '129.99', 66666, 1, NULL, 5),
(10082, 'Vapor 1X Lite Senior Hockey Elbow Pads', '60082', 'protective hockey elbow pads', 'Sports Equipment', '0.50', '30.00', '179.99', 77777, 1, NULL, 5),
(10083, 'Supreme 1S Senior Hockey Elbow Pads', '60083', 'protective hockey elbow pads', 'Sports Equipment', '0.50', '30.00', '159.99', 77777, 1, NULL, 5),
(10084, 'Super Tacks Senior Hockey Elbow Pads', '60084', 'protective hockey elbow pads', 'Sports Equipment', '0.50', '30.00', '149.99', 66666, 1, NULL, 5),
(10085, 'Jetspeed FT1 Senior Hockey Elbow Pads', '60085', 'protective hockey elbow pads', 'Sports Equipment', '0.50', '30.00', '149.99', 66666, 1, NULL, 5),
(10086, 'Vapor X900 Lite Senior Hockey Elbow Pads', '60086', 'protective hockey elbow pads', 'Sports Equipment', '0.50', '30.00', '129.99', 77777, 1, NULL, 5),
(10087, 'Tacks 7092 Senior Hockey Elbow Pads', '60087', 'protective hockey elbow pads', 'Sports Equipment', '0.50', '30.00', '109.99', 66666, 1, NULL, 5),
(10088, 'Jetspeed FT390 Senior Hockey Elbow Pads', '60088', 'protective hockey elbow pads', 'Sports Equipment', '0.50', '30.00', '99.99', 66666, 1, NULL, 5),
(10089, 'White Stick Tape', '60089', 'one roll of hockey stick tape', 'Sports Equipment', '0.25', '1.00', '4.99', 66666, 1, NULL, 100),
(10090, 'Black Stick Tape', '60090', 'one roll of hockey stick tape', 'Sports Equipment', '0.25', '1.00', '4.99', 66666, 1, NULL, 100),
(10091, 'White Stick Tape', '60091', 'Sleeve of 6 rolls of hockey stick tape', 'Sports Equipment', '1.50', '6.00', '24.99', 66666, 1, NULL, 100),
(10092, 'Black Stick Tape', '60092', 'Sleeve of 6 rolls of hockey stick tape', 'Sports Equipment', '1.50', '6.00', '24.99', 66666, 1, NULL, 100),
(10093, 'Shin Pad Tape', '60093', 'one roll of hockey shin pad tape', 'Sports Equipment', '0.25', '1.00', '3.99', 77777, 1, NULL, 100),
(10094, 'Shin Pad Tape', '60094', 'one sleeve of 6 rolls of hockey shin pad tape', 'Sports Equipment', '1.50', '1.00', '9.99', 77777, 1, NULL, 100),
(10095, 'Shin Pad Tape', '60095', 'one sleeve of 12 rolls of hockey shin pad tape', 'Sports Equipment', '3.00', '2.00', '14.99', 77777, 1, NULL, 100),
(10096, 'Puck', '60096', 'hockey puck', 'Sports Equipment', '0.20', '1.00', '1.99', 66666, 1, NULL, 100),
(10097, 'Bucket of Pucks', '60097', 'bucket of 25 hockey pucks', 'Sports Equipment', '5.00', '4.00', '29.99', 66666, 1, NULL, 20),
(10098, 'Hockey Net', '60098', 'street hockey practice net', 'Sports Equipment', '5.00', '10.00', '89.99', 77777, 1, NULL, 1),
(10099, 'Synthetic Ice', '60099', '24\" x 24\" piece of synthetic ice', 'Sports Equipment', '2.00', '15.00', '44.99', 77777, 1, NULL, 100),
(10100, 'Synthetic Ice', '60100', 'package of 5 - 24\" x 24\" pieces of synthetic ice', 'Sports Equipment', '10.00', '40.00', '99.99', 77777, 1, NULL, 20),
(10101, 'Premier II Pro Senior Goalie Leg Pads', '60101', 'pair of hockey goaltender pads', 'Sports Equipment', '5.00', '200.00', '1999.99', 66666, 1, NULL, 1),
(10102, 'Supreme 2S Pro Senior Goalie Leg Pads', '60102', 'pair of hockey goaltender pads', 'Sports Equipment', '5.00', '200.00', '1999.99', 77777, 1, NULL, 1),
(10103, 'Vapor 1X OD1N Pro Senior Goalie Leg Pads - \'17 Model', '60103', 'pair of hockey goaltender pads', 'Sports Equipment', '5.00', '200.00', '1999.99', 77777, 1, NULL, 1),
(10104, 'Premier II Pro Senior Goalie Glove', '60104', 'hockey goaltender catching glove', 'Sports Equipment', '2.00', '100.00', '599.99', 66666, 1, NULL, 5),
(10105, 'Extreme Flex III Pro Senior Goalie Glove', '60105', 'hockey goaltender catching glove', 'Sports Equipment', '2.00', '100.00', '599.99', 66666, 1, NULL, 5),
(10106, 'Supreme 2S Pro Senior Goalie Glove', '60106', 'hockey goaltender catching glove', 'Sports Equipment', '2.00', '100.00', '589.99', 77777, 1, NULL, 5),
(10107, 'Premier II Pro Senior Goalie Blocker', '60107', 'hockey goaltender blocker', 'Sports Equipment', '2.00', '100.00', '499.99', 66666, 1, NULL, 5),
(10108, 'Vapor 1X Pro Senior Goalie Blocker - \'17 Model', '60108', 'hockey goaltender blocker', 'Sports Equipment', '2.00', '100.00', '479.99', 77777, 1, NULL, 5),
(10109, 'Supreme 2S Pro Senior Goalie Chest & Arm Protector', '60109', 'hockey goaltender chest protector', 'Sports Equipment', '3.00', '120.00', '679.99', 77777, 1, NULL, 1),
(10110, '1 person tent', '11112', 'Northface single person tent', 'Camping', '1.00', '40.00', '50.00', 55555, 1, NULL, 4),
(10111, '1 person tent', '11113', 'Coleman single person tent', 'Camping', '1.00', '30.00', '40.00', 88888, 1, NULL, 4),
(10112, '2 person tent', '11114', 'Northface double person tent', 'Camping', '2.00', '50.00', '60.00', 55555, 1, NULL, 4),
(10113, '2 person tent', '11115', 'Coleman double person tent', 'Camping', '2.00', '40.00', '50.00', 88888, 1, NULL, 4),
(10114, '3 person tent', '11116', 'Northface triple person tent', 'Camping', '3.00', '60.00', '70.00', 55555, 1, NULL, 4),
(10115, '3 person tent', '11117', 'Coleman triple person tent', 'Camping', '3.00', '30.00', '40.00', 88888, 1, NULL, 4),
(10116, '4 person tent', '11118', 'Northface 4 person tent', 'Camping', '4.00', '70.00', '80.00', 55555, 1, NULL, 4),
(10117, '4 person tent', '11119', 'Coleman 4 person tent', 'Camping', '4.00', '40.00', '50.00', 88888, 1, NULL, 4),
(10118, '5 person tent', '11120', 'Northface 5 person tent', 'Camping', '5.00', '80.00', '90.00', 55555, 1, NULL, 2),
(10119, '5 person tent', '11121', 'Coleman 5 person tent', 'Camping', '5.00', '50.00', '60.00', 88888, 1, NULL, 2),
(10120, '6 person tent', '11122', 'Northface 6 person tent', 'Camping', '6.00', '90.00', '100.00', 55555, 1, NULL, 2),
(10121, '6 person tent', '11123', 'Coleman 6 person tent', 'Camping', '6.00', '60.00', '70.00', 88888, 1, NULL, 2),
(10122, '7 person tent', '11124', 'Northface 7 person tent', 'Camping', '7.00', '100.00', '110.00', 55555, 1, NULL, 2),
(10123, '7 person tent', '11125', 'Coleman 7 person tent', 'Camping', '7.00', '70.00', '80.00', 88888, 1, NULL, 2),
(10124, '8 person tent', '11126', 'Northface 8 person tent', 'Camping', '8.00', '110.00', '120.00', 55555, 1, NULL, 2),
(10125, '8 person tent', '11127', 'Coleman 8 person tent', 'Camping', '8.00', '80.00', '90.00', 88888, 1, NULL, 2),
(10126, '9 person tent', '11128', 'Northface 9 person tent', 'Camping', '9.00', '120.00', '130.00', 55555, 1, NULL, 2),
(10127, '10 person tent', '11129', 'Coleman 10 person tent', 'Camping', '10.00', '100.00', '110.00', 88888, 1, NULL, 2),
(10128, '10 person tent', '11130', 'Northface 10 person tent', 'Camping', '10.00', '130.00', '140.00', 55555, 1, NULL, 2),
(10129, '5\" knife', '11131', 'Coleman 5\" knife', 'Camping', '0.11', '20.00', '30.00', 88888, 1, NULL, 6),
(10130, '5\" knife', '11132', 'Northface 5\" knife', 'Camping', '0.11', '30.00', '40.00', 55555, 1, NULL, 6),
(10131, '6\" knife', '11133', 'Coleman 6\" knife', 'Camping', '0.12', '30.00', '40.00', 88888, 1, NULL, 6),
(10132, '6\" knife', '11134', 'Northface 6\" knife', 'Camping', '0.12', '40.00', '50.00', 55555, 1, NULL, 6),
(10133, '7\" knife', '11135', 'Coleman 7\" knife', 'Camping', '0.13', '40.00', '50.00', 88888, 1, NULL, 6),
(10134, '7\" knife', '11136', 'Northface 7\" knife', 'Camping', '0.13', '50.00', '60.00', 55555, 1, NULL, 6),
(10135, '8\" knife', '11137', 'Coleman 8\" knife', 'Camping', '0.14', '50.00', '60.00', 88888, 1, NULL, 6),
(10136, '8\" knife', '11138', 'Northface 8\" knife', 'Camping', '0.14', '60.00', '70.00', 55555, 1, NULL, 6),
(10137, '9\" knife', '11139', 'Coleman 9\" knife', 'Camping', '0.15', '60.00', '70.00', 88888, 1, NULL, 6),
(10138, '9\" knife', '11140', 'Northface 9\" knife', 'Camping', '0.15', '70.00', '80.00', 55555, 1, NULL, 6),
(10139, 'Machete', '11141', 'Coleman machete', 'Camping', '0.90', '100.00', '110.00', 88888, 1, NULL, 6),
(10140, 'Machete', '11142', 'Northface machete', 'Camping', '0.90', '120.00', '130.00', 55555, 1, NULL, 6),
(10141, 'Reel Fishing Rod', '11143', 'Coleman reel fishing rod', 'Camping', '1.80', '100.00', '110.00', 88888, 1, NULL, 8),
(10142, 'Reel Fishing Rod', '11144', 'Northface reel fishing rod', 'Camping', '1.80', '120.00', '130.00', 55555, 1, NULL, 8),
(10143, 'Fly Fishing Rod', '11145', 'Coleman fly fishing rod', 'Camping', '1.80', '120.00', '130.00', 88888, 1, NULL, 8),
(10144, 'Fly Fishing Rod', '11146', 'Northface fly fishing rod', 'Camping', '1.80', '140.00', '150.00', 55555, 1, NULL, 8),
(10145, 'Small Compass', '11147', 'Coleman Compass S', 'Camping', '0.07', '30.00', '40.00', 88888, 1, NULL, 10),
(10146, 'Small Compass', '11148', 'Northface Compass', 'Camping', '0.07', '40.00', '50.00', 55555, 1, NULL, 10),
(10147, 'Medium Compass', '11149', 'Coleman', 'Camping', '0.14', '50.00', '60.00', 88888, 1, NULL, 10),
(10148, 'Medium Compass', '11150', 'Northface', 'Camping', '0.14', '60.00', '70.00', 55555, 1, NULL, 10),
(10149, 'Large Compass', '11151', 'Coleman', 'Camping', '0.21', '70.00', '80.00', 88888, 1, NULL, 10),
(10150, 'Large Compass', '11152', 'Northface', 'Camping', '0.21', '80.00', '90.00', 55555, 1, NULL, 10),
(10151, 'Medium Cutlass', '11153', 'A short sword with a slightly curved blade  formerly used by sailors.', 'Camping', '1.00', '300.00', '350.00', 88888, 1, NULL, 6),
(10152, 'Small Sleeping Bag', '11154', 'Small Northface Sleeping Bag', 'Camping', '1.00', '60.00', '70.00', 55555, 1, NULL, 6),
(10153, 'Small Sleeping Bag', '11155', 'Small Coleman Sleeping Bag', 'Camping', '1.00', '50.00', '60.00', 88888, 1, NULL, 6),
(10154, 'Medium Sleeping Bag', '11156', 'Medium Northface Sleeping Bag', 'Camping', '2.00', '90.00', '100.00', 55555, 1, NULL, 6),
(10155, 'Medium Sleeping Bag', '11157', 'Medium Coleman Sleeping Bag', 'Camping', '2.00', '80.00', '90.00', 88888, 1, NULL, 6),
(10156, 'Triple Sleeping Bag', '11158', 'For you and two of your closest friends.', 'Camping', '3.00', '110.00', '120.00', 55555, 1, NULL, 2),
(10157, 'Stove', '11159', 'Coleman Stove', 'Camping', '2.00', '120.00', '130.00', 88888, 1, NULL, 10),
(10158, 'Stove', '11160', 'Northface Stove', 'Camping', '2.00', '130.00', '140.00', 55555, 1, NULL, 10),
(10159, 'Camp Frying Pan', '11161', 'Coleman Camp Frying Pan', 'Camping', '0.50', '30.00', '40.00', 88888, 1, NULL, 10),
(10160, 'Camp Frying Pan', '11162', 'Northface Camp Frying Pan', 'Camping', '0.50', '25.00', '35.00', 55555, 1, NULL, 10),
(10161, 'Coffee Grinder', '11163', 'Coleman Coffee Grinder', 'Camping', '0.25', '15.00', '25.00', 88888, 1, NULL, 10),
(10162, 'Coffee Grinder', '11164', 'Northface Coffee Grinder', 'Camping', '0.25', '20.00', '30.00', 55555, 1, NULL, 10),
(10163, 'French Press', '11165', 'Coleman French Press', 'Camping', '0.50', '30.00', '40.00', 88888, 1, NULL, 10),
(10164, 'French Press', '11166', 'Northface French Press', 'Camping', '0.50', '40.00', '50.00', 55555, 1, NULL, 10),
(10165, 'Small Cooler', '11167', 'Coleman Small Cooler', 'Camping', '1.00', '30.00', '40.00', 88888, 1, NULL, 4),
(10166, 'Small Cooler', '11168', 'Northface Small Cooler', 'Camping', '1.00', '40.00', '50.00', 55555, 1, NULL, 4),
(10167, 'Medium Cooler', '11169', 'Coleman Medium Cooler', 'Camping', '2.00', '40.00', '50.00', 88888, 1, NULL, 4),
(10168, 'Medium Cooler', '11170', 'Northface Medium Cooler', 'Camping', '2.00', '50.00', '60.00', 55555, 1, NULL, 4),
(10169, 'Large Cooler', '11171', 'Coleman Large Cooler', 'Camping', '3.00', '50.00', '60.00', 88888, 1, NULL, 4),
(10170, 'Large Cooler', '11172', 'Northface Large Cooler', 'Camping', '3.00', '60.00', '70.00', 55555, 1, NULL, 4),
(10171, 'Small Camping Chair', '11173', 'Coleman Small Camping Chair', 'Camping', '1.00', '20.00', '30.00', 88888, 1, NULL, 4),
(10172, 'Small Camping Chair', '11174', 'Northface Small Camping Chair', 'Camping', '1.00', '30.00', '40.00', 55555, 1, NULL, 4),
(10173, 'Medium Camping Chair', '11175', 'Coleman Medium Camping Chair', 'Camping', '2.00', '30.00', '40.00', 88888, 1, NULL, 4),
(10174, 'Medium Camping Chair', '11176', 'Northface Medium Camping Chair', 'Camping', '2.00', '40.00', '50.00', 55555, 1, NULL, 4),
(10175, 'Large Camping Chair', '11177', 'Coleman Large Camping Chair', 'Camping', '3.00', '40.00', '50.00', 88888, 1, NULL, 4),
(10176, 'Large Camping Chair', '11178', 'Northface Large Camping Chair', 'Camping', '3.00', '50.00', '60.00', 55555, 1, NULL, 4),
(10177, 'Standard Hiking Backpack', '11179', 'Coleman Standard Hiking Backpack', 'Camping', '3.00', '100.00', '120.00', 88888, 1, NULL, 4),
(10178, 'Standard Hiking Backpack', '11180', 'Northface Standard Hiking Backpack', 'Camping', '3.00', '120.00', '140.00', 55555, 1, NULL, 4),
(10179, 'Premium Hiking Backpack', '11181', 'Coleman Premium Hiking Backpack', 'Camping', '3.00', '120.00', '140.00', 88888, 1, NULL, 4),
(10180, 'Premium Hiking Backpack', '11182', 'Northface Premium Hiking Backpack', 'Camping', '3.00', '140.00', '160.00', 55555, 1, NULL, 4),
(10181, 'Deluxe Hiking Backpack', '11183', 'Coleman Deluxe Hiking Backpack', 'Camping', '3.00', '140.00', '160.00', 88888, 1, NULL, 4),
(10182, 'Deluxe Hiking Backpack', '11184', 'Northface Deluxe Hiking Backpack', 'Camping', '3.00', '160.00', '180.00', 55555, 1, NULL, 4),
(10183, 'Single Air Mattress', '11185', 'Coleman Single Air Mattress', 'Camping', '2.00', '50.00', '60.00', 88888, 1, NULL, 8),
(10184, 'Single Air Mattress', '11186', 'Northface Single Air Mattress', 'Camping', '2.00', '60.00', '70.00', 55555, 1, NULL, 8),
(10185, 'Double Air Mattress', '11187', 'Coleman Double Air Mattress', 'Camping', '4.00', '70.00', '80.00', 88888, 1, NULL, 8),
(10186, 'Double Air Mattress', '11188', 'Northface Double Air Mattress', 'Camping', '4.00', '80.00', '90.00', 55555, 1, NULL, 8),
(10187, 'Queen Air Mattress', '11189', 'Coleman Queen Air Mattress', 'Camping', '6.00', '90.00', '100.00', 88888, 1, NULL, 4),
(10188, 'Queen Air Mattress', '11190', 'Northface Queen Air Mattress', 'Camping', '6.00', '100.00', '110.00', 55555, 1, NULL, 4),
(10189, 'King Air Mattress', '11191', 'Coleman King Air Mattress', 'Camping', '8.00', '110.00', '120.00', 88888, 1, NULL, 4),
(10190, 'King Air Mattress', '11192', 'Northface King Air Mattress', 'Camping', '8.00', '120.00', '130.00', 55555, 1, NULL, 4),
(10191, 'Small Flashlight', '11193', 'Coleman Small Flashlight', 'Camping', '0.25', '20.00', '30.00', 88888, 1, NULL, 10),
(10192, 'Small Flashlight', '11194', 'Northface Small Flashlight', 'Camping', '0.25', '30.00', '40.00', 55555, 1, NULL, 10),
(10193, 'Medium Flashlight', '11195', 'Coleman Medium Flashlight', 'Camping', '0.50', '40.00', '50.00', 88888, 1, NULL, 8),
(10194, 'Medium Flashlight', '11196', 'Northface Medium Flashlight', 'Camping', '0.50', '50.00', '60.00', 55555, 1, NULL, 8),
(10195, 'Large Flashlight', '11197', 'Coleman Large Flashlight', 'Camping', '0.75', '60.00', '70.00', 88888, 1, NULL, 6),
(10196, 'Large Flashlight', '11198', 'Northface Large Flashlight', 'Camping', '0.75', '70.00', '80.00', 55555, 1, NULL, 6),
(10197, 'Head Lamp', '11199', 'Coleman Head Lamp', 'Camping', '0.25', '40.00', '50.00', 88888, 1, NULL, 10),
(10198, 'Head Lamp', '11200', 'Northface Head Lamp', 'Camping', '0.25', '50.00', '60.00', 55555, 1, NULL, 10),
(10199, 'Small First Aid Kit', '11201', 'Coleman Small First Aid Kit', 'Camping', '0.25', '10.00', '20.00', 88888, 1, NULL, 10),
(10200, 'Small First Aid Kit', '11202', 'Northface Small First Aid Kit', 'Camping', '0.25', '20.00', '30.00', 55555, 1, NULL, 10),
(10201, 'Medium First Aid Kit', '11203', 'Coleman Medium First Aid Kit', 'Camping', '0.50', '30.00', '40.00', 88888, 1, NULL, 8),
(10202, 'Medium First Aid Kit', '11204', 'Northface Medium First Aid Kit', 'Camping', '0.50', '40.00', '50.00', 55555, 1, NULL, 8),
(10203, 'Large First Aid Kit', '11205', 'Coleman Large First Aid Kit', 'Camping', '1.00', '50.00', '60.00', 88888, 1, NULL, 6),
(10204, 'Large First Aid Kit', '11206', 'Northface Large First Aid Kit', 'Camping', '1.00', '60.00', '70.00', 55555, 1, NULL, 6),
(10205, 'Monocular', '11207', 'Coleman Monocular', 'Camping', '1.00', '50.00', '60.00', 88888, 1, NULL, 8),
(10206, 'Monocular', '11208', 'Northface Monocular', 'Camping', '1.00', '60.00', '70.00', 55555, 1, NULL, 8),
(10207, 'Binocular', '11209', 'Coleman Binocular', 'Camping', '1.50', '70.00', '80.00', 88888, 1, NULL, 6),
(10208, 'Binocular', '11210', 'Northface Binocular', 'Camping', '1.50', '80.00', '90.00', 55555, 1, NULL, 6),
(10209, 'Trinocular', '11211', 'Coleman Trinocular', 'Camping', '2.00', '90.00', '100.00', 88888, 1, NULL, 4),
(10210, 'Trinocular', '11212', 'Northface Trinocular', 'Camping', '2.00', '100.00', '110.00', 55555, 1, ':)', 4),
(10211, '5 pack bungies', '11213', 'Coleman 5 pack bungies', 'Camping', '0.25', '5.00', '15.00', 88888, 1, ':)', 10),
(10212, '5 pack bungies', '11214', 'Northface 5 pack bungies', 'Camping', '0.25', '10.00', '20.00', 55555, 1, ':)', 10),
(10213, '6 pack bungies', '11215', 'Coleman 6 pack bungies', 'Camping', '0.30', '15.00', '25.00', 88888, 1, ':)', 10),
(10214, '6 pack bungies', '11216', 'Northface 6 pack bungies', 'Camping', '0.30', '25.00', '35.00', 55555, 1, ':)', 10),
(10215, 'Small Flask', '11217', 'Coleman Small Flask', 'Camping', '0.25', '30.00', '40.00', 88888, 1, ':)', 10),
(10216, 'Small Flask', '11218', 'Northface Small Flask', 'Camping', '0.25', '40.00', '50.00', 55555, 1, ':)', 10),
(10217, 'Medium Flask', '11219', 'Coleman Medium Flask', 'Camping', '0.50', '50.00', '60.00', 88888, 1, ':)', 10),
(10218, 'Medium Flask', '11220', 'Northface Medium Flask', 'Camping', '0.50', '60.00', '70.00', 55555, 1, ':)', 10),
(10219, 'Large Flask', '11221', 'Coleman Large Flask', 'Camping', '0.75', '70.00', '80.00', 88888, 1, ':)', 6),
(10220, 'Large Flask', '11222', 'Northface Large Flask', 'Camping', '0.75', '80.00', '90.00', 55555, 1, ':)', 6),
(10221, 'Men\'s Burton Photon Boa Snowboard Boot', '15086', 'Hard chargers who prefer response that feels fused to the foot will appreciate the cranked-up power of Lockdown Lacing', 'Footwear', '2.36', '439.99', '449.99', 11111, 1, '1 year warranty', 5),
(10222, 'Men\'s Burton Moto Boa Snowboard Boot', '13176', 'Breaking in new boots is nothing to fear with the Burton Moto Boa and its Total Comfort construction.', 'Footwear', '2.36', '269.99', '279.99', 11111, 1, '1 year warranty', 5),
(10223, 'Men\'s Burton Ruler Boa Snowboard Boot', '20317', 'With a legacy of pushing personal skills to the pro level  the Burton Ruler boot is the boot for stepping to larger drops and burlier features.', 'Footwear', '2.36', '339.99', '349.99', 11111, 1, '1 year warranty', 5),
(10224, 'Men\'s Burton SLX Snowboard Boot', '10620', 'As our highest performance option the Burton SLX boot combines the latest advances with a versatile flex and feel that\'s at home on any terrain.', 'Footwear', '2.36', '689.99', '699.99', 11111, 1, '1 year warranty', 5),
(10225, 'Men\'s Burton Ion Snowboard Boot', '17036', 'Setting the bar higher in every discipline is still the headline for the ever responsive Burton Ion boot.', 'Footwear', '2.36', '589.99', '599.99', 11111, 1, '1 year warranty', 5),
(10226, 'Men\'s Burton Swath Boa Snowboard Boot', '20318', 'Those who appreciate the balance of medium-flex tweakability and comfort should step to the men\'s Burton Swath boot.', 'Footwear', '2.36', '409.99', '419.99', 11111, 1, '1 year warranty', 5),
(10227, 'Men\'s Burton Ruler Snowboard Boot', '10439', 'With a legacy of pushing personal skills to the pro level  the Burton Ruler boot is the boot for stepping to larger drops and burlier features.', 'Footwear', '2.36', '289.99', '299.99', 11111, 1, '1 year warranty', 5),
(10228, 'Men\'s Burton Invader Snowboard Boot', '10651', 'Simple  comfortable  and built to last  the Burton Invader boot is our softest flexing option with upgrades that are all about keeping you out on the mountain as long as possible.', 'Footwear', '2.36', '189.99', '199.99', 11111, 1, '1 year warranty', 5),
(10229, 'Men\'s Burton Driver X Snowboard Boot', '10434', 'Sketchy climbs and exposed lines are Burton Driver X boot’s domain. Known as the most responsive boot in snowboarding  its burly demeanor is balanced by practical upgrades in warmth and comfort', 'Footwear', '2.36', '489.99', '499.99', 11111, 1, '1 year warranty', 5),
(10230, 'Men\'s Burton Ruler Wide Snowboard Boot', '13175', 'With a legacy of pushing personal skills to the pro level  the Burton Ruler Wide is the boot for riders with wider feet who refuse to compromise comfort or performance.', 'Footwear', '2.36', '289.99', '299.99', 11111, 1, '1 year warranty', 5),
(10231, 'Men\'s Burton Ion Boa Snowboard Boot', '18579', 'Setting the bar higher in every discipline  the Burton Ion Boa boot is the only men\'s model to feature Boa Focus lacing  the pinnacle offering for optimized fit.', 'Footwear', '2.36', '639.99', '649.99', 11111, 1, '1 year warranty', 5),
(10232, 'Men\'s Burton Tourist X Snowboard Boot', '20968', 'Reap the benefits of an even lighter splitboard-specific boot from the climb up to the ride down with the Burton Tourist X Snowboard Boot.', 'Footwear', '2.36', '639.99', '649.99', 11111, 1, '1 year warranty', 5),
(10233, 'Men\'s Burton Moto Snowboard Boot', '10436', 'On the feet of more riders than any other boot  the Burton Moto boot offers top-tier comfort and ease of use  at a price that\'s hard to beat.', 'Footwear', '2.36', '239.99', '249.99', 11111, 1, '1 year warranty', 5),
(10234, 'Men\'s Burton Tourist Snowboard Boot', '17037', 'Skintrack or summit bid  the Burton Tourist boot handles the mountains with surefooted confidence.', 'Footwear', '2.36', '589.99', '599.99', 11111, 1, '1 year warranty', 5),
(10235, 'Men\'s Burton Toaster Snowboard Boot Liner', '17126', 'The Toaster Heated Liners warm your snowboard boots up in less than a minute with a low-profile built-in heating system that cranks warmth at a low  medium or high setting.', 'Footwear', '2.36', '249.99', '259.99', 11111, 1, '1 year warranty', 5),
(10236, 'Men\'s Burton Ruler Leather Snowboard Boot', '19860', 'Built on a legacy of pushing personal skills to the pro level  the Burton Ruler Leather boot adds classic leather style to your quest for larger drops and burlier features.', 'Footwear', '2.36', '369.99', '379.99', 11111, 1, '1 year warranty', 5),
(10237, 'Men\'s Burton Imperial Snowboard Boot', '10622', 'The Burton Imperial boot channels 30 years of expertise into the most bang ever for your hard-earned buck.', 'Footwear', '2.36', '389.99', '399.99', 11111, 1, '1 year warranty', 5),
(10238, 'Burton Swath Snowboard Boot', '20316', 'Those who appreciate the balance of medium-flex tweakability and comfort should step to the men\'s Burton Swath boot.', 'Footwear', '2.36', '379.99', '379.99', 11111, 1, '1 year warranty', 5),
(10239, 'Men\'s Burton Rampant Snowboard Boot', '10653', 'he premier park boot in our traditional lacing lineup  the Burton Rampant combines a lightweight ride with Crossbone Cuff support for more air per ollie and easier presses.', 'Footwear', '2.36', '269.99', '279.99', 11111, 1, '1 year warranty', 5),
(10240, 'Burton Ion Leather Snowboard Boot', '15085', 'Proven Ion technologies such as Total Comfort and AutoCANT EST cushioning deliver precise control and out-of-box bliss  while the Life Liner is our most comfortable yet  reducing weight while improving response.', 'Footwear', '2.36', '639.99', '649.99', 11111, 1, '1 year warranty', 5),
(10241, 'Men\'s Burton Photon Boa Wide Snowboard Boot', '20685', 'The men \'s Photon Boa Wide boot is for those who wish to dial-in comfort and fit to the precise click of the Boa Coiler closure system', 'Footwear', '2.36', '439.99', '449.99', 11111, 1, '1 year warranty', 5),
(10242, 'Men\'s Ruler Step On Bundle', '17287', 'This is snowboarding \'s most intuitive boot-to-binding connection. Pair your Ruler Step On Boot with Men \'s Step On bindings for unprecedented performance and simplicity.', 'Footwear', '2.36', '369.99', '379.99', 11111, 1, '1 year warranty', 5),
(10243, 'Men\'s Photon Step On Bundle', '17285', 'This is snowboarding \'s most intuitive boot-to-binding connection.', 'Footwear', '2.36', '469.99', '479.99', 11111, 1, '1 year warranty', 5),
(10244, 'Men\'s Ion Step On Bundle', '20319', 'This is snowboarding \'s most intuitive boot-to-binding connection.', 'Footwear', '2.36', '619.99', '629.99', 11111, 1, '1 year warranty', 5),
(10245, 'Women\'s Burton Felix Boa Snowboard Boot', '13179', 'The Burton Felix boot reformulates the top of the line DNA of our Supreme boot into an all around performer that\'s slightly softer and more forgiving on your finances.', 'Footwear', '2.34', '409.99', '419.99', 11111, 1, '1 year warranty', 5),
(10246, 'Women\'s Burton Mint Boa Snowboard Boot', '13177', 'Soft  forgiving  and simple  the Burton Mint Boa boot is ready for progression right out of the box.', 'Footwear', '2.34', '269.99', '279.99', 11111, 1, '1 year warranty', 5),
(10247, 'Women\'s Burton Limelight Boa Snowboard Boot', '15087', 'The Limelight Boa boot will have you beating the crowds to the lift line  then showing them how it’s done from glades to groomers.', 'Footwear', '2.34', '329.99', '339.99', 11111, 1, '1 year warranty', 5),
(10248, 'Women\'s Burton Supreme Snowboard Boot', '10626', 'As accomplished as the pros who ride it  the Burton Supreme channels the best of the best into one boot that balances pro-level performance with Total Comfort any rider will appreciate.', 'Footwear', '2.34', '539.99', '549.99', 11111, 1, '1 year warranty', 5),
(10249, 'Women\'s Burton Limelight Snowboard Boot', '10621', 'ving you a Supreme boot for less loot  the combination of components locked in the Burton Limelight simply can\'t be beat.', 'Footwear', '2.34', '289.99', '299.99', 11111, 1, '1 year warranty', 5),
(10250, 'Women\'s Burton Ritual Snowboard Boot', '10624', 'The Burton Ritual boot blends pro-level performance with the latest in warmth and comfort for fully-charged footwear that’s ready to rip.', 'Footwear', '2.34', '349.99', '359.99', 11111, 1, '1 year warranty', 5),
(10251, 'Women\'s Burton Mint Snowboard Boot', '10627', 'You can\'t argue with the facts: more women choose the Burton Mint than any other snowboard boot. Whether riding a few times a week or a few times a year  a boot that keeps you warm and happy is essential.', 'Footwear', '2.34', '239.99', '249.99', 11111, 1, '1 year warranty', 5),
(10252, 'Women\'s Burton Coco Snowboard Boot', '10644', 'Easy on your feet (and your wallet)  the Burton Coco boot focuses on a soft flex and features that let you catch up  keep up  and enjoy every minute with your friends.', 'Footwear', '2.34', '189.99', '199.99', 11111, 1, '1 year warranty', 5),
(10253, 'Women\'s Burton Toaster Snowboard Boot Liner', '17127', 'Engineered to prevent frozen feet  Toaster Heated Liners warm your snowboard boots up in less than a minute with a low-profile built-in heating system that cranks warmth at a low  medium or high setting.', 'Footwear', '2.34', '249.99', '259.99', 11111, 1, '1 year warranty', 5),
(10254, 'Women\'s Burton Ritual LTD Snowboard Boot', '17125', 'One look at the women’s Burton Ritual LTD boot and you know this thing is different. Ultraweave construction creates lasting  powerful support and water-resistance.', 'Footwear', '2.34', '469.99', '479.99', 11111, 1, '1 year warranty', 5),
(10255, 'Women\'s Felix Step On Bundle', '17286', 'This is snowboarding \'s most intuitive boot-to-binding connection. Pair your Felix Step On Boot with Women\'s Step On bindings for unprecedented ease and performance.', 'Footwear', '2.34', '439.99', '449.99', 11111, 1, '1 year warranty', 5),
(10256, 'Women\'s Limelight Step On Bundle', '17288', 'This is snowboarding \'s most intuitive boot-to-binding connection. Pair your Limelight Step On Boot with Women\'s Step On bindings for unprecedented performance and simplicity.', 'Footwear', '2.34', '369.99', '379.99', 11111, 1, '1 year warranty', 5),
(10257, 'Nike Air Zoom Pegasus 35', '17289', 'The Nike Air Zoom Pegasus 35 is built for runners at every level  whether you\'re a seasoned veteran or just starting out.', 'Footwear', '0.28', '145.00', '155.00', 44444, 1, NULL, 5),
(10258, 'Nike Superfly Elite', '83599', 'Over a decade later  the Nike Superfly Elite Racing Spike returns with updates that include ultra-breathable Flymesh fabric to keep you cool and an innovative spike plate for optimal grip.', 'Footwear', '0.15', '190.00', '200.00', 44444, 1, 'Bordeaux/Regency Purple/Lime Blast', 5),
(10259, 'Nike Air Max 2017 SE', '86286', 'The Nike Air Max 2017 SE Men \'s Shoe features a textile and synthetic construction for support and breathability. Iconic Max Air cushioning provides a lightweight  smooth feel', 'Footwear', '0.15', '230.00', '240.00', 44444, 1, 'Particle Rose/Dark Grey', 5),
(10260, 'Nike Epic React Flyknit', '70040', 'Step into the smooth comfort of the Nike Epic React Flyknit. It\'s precision-tuned with a Flyknit upper and Nike React technology to deliver a soft yet responsive ride mile after mile.', 'Footwear', '0.15', '129.00', '139.00', 44444, 1, 'Black/Anthracite/Laser Orange/Reflect Silver', 5),
(10261, 'Nike Zoom Matumbo 2', '52662', 'The Nike Zoom Matumbo 2 Unisex Distance Spike is ideal for long distances over multiple surfaces with an ultra-lightweight design  soft Flashlon cushioning and a surface-gripping sharkskin heel pad.', 'Footwear', '0.12', '155.00', '165.00', 44444, 1, 'White/Racer Blue/Black', 5),
(10262, 'Nike Zoom Mamba 3', '70661', 'The Nike Zoom Mamba 3 Unisex Distance Spike is designed for the steeplechase with a single-layer  open-mesh upper', 'Footwear', '0.14', '160.00', '170.00', 44444, 1, 'Football Blue/Bright Crimson/Blue Fox', 5),
(10263, 'Nike Air Max Sequent 3', '92169', 'The Nike Air Max Sequent 3 Men \'s Shoe is perfect for short runs when you need plenty of cushioning. A stretchy  knitted upper moves with your foot with every stride.', 'Footwear', '0.14', '130.00', '140.00', 44444, 1, 'Black/Anthracite/Laser Orange/Reflect Silver', 5),
(10264, 'Nike VaporFly 4 Flyknit', '38576', 'Nike \'s fastest  most efficient marathon shoe just keeps winning everything in sight', 'Footwear', '0.14', '320.00', '330.00', 44444, 1, 'Bright Crimson/Total Crimson/Gridiron/Ice Blue', 5),
(10265, 'Nike Epic React Flyknit', '61620', 'Step into the smooth comfort of the Nike Epic React Flyknit.', 'Footwear', '0.14', '190.00', '200.00', 44444, 1, 'Black/Volt/Blue Glow/Black', 5),
(10266, 'Nike Air Zoom Pegasus 35 Shield Water-Repellent', '16430', 'The Nike Air Zoom Pegasus 35 Shield Water-Repellent Shoe gets remixed to conquer wet routes.', 'Footwear', '0.14', '155.00', '165.00', 44444, 1, 'Black/Cool Grey/Vast Grey/Metallic Silver', 5),
(10267, 'Nike Odyssey React Shield Water-Repellent', '16343', 'The Nike Odyssey React Shield Water-Repellent Shoe gets remixed to conquer wet routes.', 'Footwear', '0.14', '165.00', '175.00', 44444, 1, 'Black/Anthracite/Dark Grey/Anthracite', 5),
(10268, 'Nike Downshifter 8', '90898', 'The Nike Downshifter 8 Running Shoe features a minimal design made from lightweight  single-layer mesh and updated cushioning underfoot', 'Footwear', '0.14', '72.00', '82.00', 44444, 1, 'Light Carbon/Peat Moss/Black/Metallic Pewter', 5),
(10269, 'Nike Legend React', '16250', 'The Nike Legend React Men \'s Running Shoe features a breathable upper with synthetic overlays that enhance durability', 'Footwear', '0.14', '130.00', '140.00', 44444, 1, 'Wolf Grey/Cool Grey/Pure Platinum/Black', 5),
(10270, 'Nike Rise React Flyknit', '55540', 'The Nike Rise React Flyknit takes lightweight performance to the next level.', 'Footwear', '0.14', '225.00', '235.00', 44444, 1, 'Gunsmoke/Dark Stucco/Aurora/Black', 5),
(10271, 'Nike Air Zoom Structure 22', '16360', 'The Nike Air Zoom Structure 22 Men \'s Running Shoe looks fast and feels secure.', 'Footwear', '0.33', '155.00', '165.00', 44444, 1, 'Atmosphere Grey/Lime Blast/Black/Burgundy Ash', 5),
(10272, 'Nike Air Zoom Structure 22 Shield Water-Repellent', '16450', 'The Nike Air Zoom Structure 22 Shield Water-Repellent Shoe gets remixed to conquer wet routes.', 'Footwear', '0.33', '165.00', '175.00', 44444, 1, 'Black/Cool Grey/Vast Grey/Metallic Silver', 5),
(10273, 'Nike Air Zoom Vomero 14', '78580', 'The Nike Air Zoom Vomero 14 takes responsive cushioning to the next level.', 'Footwear', '0.14', '180.00', '190.00', 44444, 1, 'Vast Grey/Pink Foam/Lime Blast/Black', 5),
(10274, 'Nike Zoom Fly SP', '35230', 'The Nike Zoom Fly SP delivers lightweight cushioning and exceptional energy return.', 'Footwear', '0.14', '205.00', '215.00', 44444, 1, NULL, 5),
(10275, 'Nike Air Zoom Structure 22 Shield Water-Repellent', '35230', 'The Nike Air Zoom Pegasus 35 Premium is built for runners at every level  whether you \'re a seasoned veteran or just starting out.', 'Footwear', '0.14', '175.00', '185.00', 44444, 1, 'Atmosphere Grey/Aluminium/White', 5),
(10276, 'Nike Zoom Pegasus Turbo XX', '43476', 'Bridging performance and style  the Nike Zoom Pegasus Turbo XX Women\'s Running Shoe combines a full-length ZoomX midsole', 'Footwear', '0.22', '255.00', '265.00', 44444, 1, 'Rose Gold/Sail/Burnt Orange', 5),
(10277, 'Nike Zoom Fly SP Fast', '38944', 'The Nike Zoom Fly SP Fast Shoe features a deconstructed upper to make the shoe lightweight and distraction-free.', 'Footwear', '0.22', '220.00', '230.00', 44444, 1, 'Indigo Fog/Red Orbit/Indigo Fog', 5),
(10278, 'Nike Air Zoom Pegasus 35 Premium', '83920', 'The Nike Air Zoom Pegasus 35 Premium is built for runners at every level  whether you\'re a seasoned veteran or just starting out.', 'Footwear', '0.23', '175.00', '185.00', 44444, 1, 'Atmosphere Grey/Aluminium/White', 5),
(10279, 'Nike Free RN 2018 Shield Water-Repellent', '19780', 'The Nike Free RN 2018 Shield Water-Repellent Shoe gets remixed to conquer wet routes.', 'Footwear', '0.23', '140.00', '150.00', 44444, 1, 'Black/Cool Grey/Vast Grey/Metallic Silver', 5),
(10280, 'Nike Free RN 2018', '94283', 'Made for short runs  from your daily 5K to that spontaneous sprint  the Nike Free RN 2018 Women\'s Running Shoe is as flexible as ever.', 'Footwear', '0.23', '130.00', '140.00', 44444, 1, 'Blue Void/Indigo Force/Ghost Aqua', 5),
(10281, 'REEBOK SPRINT TR II', '61690', 'Power through grueling workouts in these men \'s training shoes. They\'re built with a low-cut  lightweight mesh upper for breathability and stability.', 'Footwear', '0.23', '90.00', '100.00', 10000, 1, 'LIGHTWEIGHT  COMFORTABLE SHOES BUILT FOR INTENSE SESSIONS', 5),
(10282, 'REEBOK FLEXAGON FIT', '63560', 'Built with origami-inspired cushioning  these men \'s training shoes feature a soft foam midsole for premium comfort.', 'Footwear', '0.23', '90.00', '100.00', 10000, 1, 'VERSATILE  ULTRA-CUSHIONED SHOES FOR SUPREME COMFORT', 5),
(10283, 'REEBOK SPRINT TR II', '61710', 'Power through grueling workouts in these men \'s training shoes. They \'re built with a low-cut  lightweight mesh upper for breathability and stability.', 'Footwear', '0.23', '90.00', '100.00', 10000, 1, 'LIGHTWEIGHT  COMFORTABLE SHOES BUILT FOR INTENSE SESSIONS', 5),
(10284, 'REEBOK SPEED TR FLEXWEAVE', '44000', 'Our versatile training shoe gets an upgrade with a Flexweave upper.', 'Footwear', '0.23', '110.00', '120.00', 10000, 1, 'WITH FLEXWEAVE  WE\'VE BROUGHT MORE BREATHABILITY AND DURABILITY TO OUR MOST VERSATILE SHOE', 5),
(10285, 'REEBOK FLEXAGON ENERGY', '45480', 'A clean  minimalist approach for all-day wear. These men \'s training shoes feature a breathable upper for lightweight comfort.', 'Footwear', '0.23', '75.00', '85.00', 10000, 1, 'MINIMALIST SHOES DESIGNED FOR ALL-DAY COMFORT', 5),
(10286, 'REEBOK CROSSFIT NANO 4.0', '79270', 'Performance  durability and comfort are packed into the latest evolution of the Nano training shoe.', 'Footwear', '0.23', '120.00', '130.00', 10000, 1, NULL, 5),
(10287, 'REEBOK CROSSFIT NANO 2.0', '79250', 'You the community have asked for more flexibility and breathability while maintaining stability in your footwear.', 'Footwear', '0.23', '110.00', '120.00', 10000, 1, NULL, 5),
(10288, 'REEBOK FRONING', '99940', 'The old school cross-training shoe gets a modern facelift in collaboration with 4X Fittest Man on Earth Rich Froning.', 'Footwear', '0.23', '170.00', '180.00', 10000, 1, 'A DYNAMIC CROSS-TRAINING SHOE BUILT TOUGH WITH 4X FITTEST MAN ON EARTH RICH FRONING', 5),
(10289, 'REEBOK FUSIUM RUN', '24311', 'Run with the comfort and stability you need with the Reebok Fusium Run. The shoe \'s evolved foot mapping technology adapts to your every step', 'Footwear', '0.23', '120.00', '130.00', 10000, 1, 'THE SUPPORT YOU NEED EVERY STEP OF THE WAY', 5),
(10290, 'REEBOK YOURFLEX TRAIN 10', '56511', 'LIGHTWEIGHT TRAINING SHOE WITH A FLEXIBLE SOLE', 'Footwear', '0.23', '90.00', '100.00', 10000, 1, 'LIGHTWEIGHT TRAINING SHOE WITH A FLEXIBLE SOLE', 5),
(10291, 'REEBOK REAGO PULSE', '51250', 'These men \'s shoes are built to take you anywhere your workout does. A rubber heel gives traction on varied terrain', 'Footwear', '0.23', '90.00', '100.00', 10000, 1, 'TAKE YOUR TRAINING ANYWHERE YOU CAN IMAGINE', 5),
(10292, 'REEBOK CROSSFIT NANO 8 FLEXWEAVE', '10200', 'Since 2010  Reebok has forged the Nano through sweat  testing  re-designing and re-testing to create our most versatile and dependable CrossFit shoe in the box.', 'Footwear', '0.23', '135.00', '145.00', 10000, 1, 'THE GO-TO OPTION FOR CROSSFIT ATHLETES JUST GOT BETTER', 5),
(10293, 'REEBOK REALFLEX TRAIN 5.0', '28080', 'Go all-in with this flexible men\'s training shoe. Uniquely engineered nodes underfoot help negotiate with the ground to give you more flex', 'Footwear', '0.23', '90.00', '100.00', 10000, 1, 'A TRAINING SHOE WITH A REALFLEX OUTSOLE', 5),
(10294, 'REEBOK HYDRORUSH TR', '47910', 'Feel the rush of targeted support. This lightweight flexible men’s HydroRush training shoe', 'Footwear', '0.23', '100.00', '110.00', 10000, 1, 'VERSATILE TRAINING SHOE WITH DYNAMIC LIQUID CUSHIONING', 5),
(10295, 'RAPIDE', '75190', 'These men \'s running-inspired shoes pull a distinctively \'90s look from the archives. The bold side stripes flash a pop of throwback color', 'Footwear', '0.23', '100.00', '110.00', 10000, 1, 'A HERITAGE RUNNING STYLE WITH A \'90S VIBE', 5),
(10296, 'CLUB C 85', '68920', 'Taking their cue from the  \'80s court classic  these men \'s shoes are all about simplicity. They have a leather upper and a timeless easy-to-wear style.', 'Footwear', '0.23', '100.00', '110.00', 10000, 1, 'A RETRO TENNIS STYLE IN LEATHER', 5),
(10297, 'CLASSIC LEATHER', '71070', 'This street-style icon was created in 1983 as a premium leather runner. These mens shoes mix it up with a suede upper and leather side stripes. A molded EVA midsole gives you lightweight cushioning.', 'Footwear', '0.23', '90.00', '100.00', 10000, 1, 'RETRO RUNNING STYLE IN SUEDE', 5),
(10298, 'CLASSIC NYLON COLOR', '74480', 'The Classic Nylon came out in 91 as an evolution of the Classic Leather. These shoes mix a clean look with heritage details.', 'Footwear', '0.23', '80.00', '90.00', 10000, 1, 'RUNNING-INSPIRED SNEAKERS WITH A RETRO VIBE', 5),
(10299, 'DAYTONA DMX X VAINL ARCHIVE', '58000', 'Japanese contemporary label Vainl Archive  helmed by industry stalwart Kouhei Ohkita  returns with a new and exciting sneaker collaboration.', 'Footwear', '0.23', '180.00', '190.00', 10000, 1, NULL, 5),
(10300, 'AZTREK X BILLYS TOKYO', '53800', 'Flashback to the  \'90s in this on-trend retro runner in seasonal colors for an update on a true classic. feet and looking good.', 'Footwear', '0.23', '130.00', '140.00', 10000, 1, 'MEET THE REAL DEAL', 5),
(10301, 'WORKOUT PLUS MU', '42840', 'Slip into this shoe for instant classic style cred. The full-grain leather upper serves as a canvas for the timeless look these men\'s shoes exude.', 'Footwear', '0.23', '110.00', '120.00', 10000, 1, 'CLASSIC STYLE FOR DAILY WEAR', 5),
(10302, 'IVERSON LEGACY', '82220', 'Tap into the legacy of Allen Iverson \'s career with this fresh mash-up unisex shoe that takes design inspiration from his iconic Answer footwear line.', 'Footwear', '0.23', '190.00', '200.00', 10000, 1, 'A MODERN SHOE WITH A CLASSIC TWIST', 5),
(10303, 'WORKOUT LO RIPPLE', '53260', 'Step right up to that clean  old-school sneaker vibe with the Workout Clean Ripple shoe for men.', 'Footwear', '0.23', '120.00', '130.00', 10000, 1, 'SLEEK SHOE WITH A RIPPLE SOLE', 5),
(10304, 'REEBOK BOXING BOOT', '47390', 'Step into the ring  breathe and remember your training. We designed these boots to support you during the fight with an ankle strap and synthetic overlay upper to add lateral stability', 'Footwear', '0.23', '110.00', '120.00', 10000, 1, 'RING-READY SHOES WITH LIGHTWEIGHT WEAR AND SUPERIOR ANKLE SUPPORT', 5),
(10305, 'REEBOK COMBAT NOBLE TRAINER', '74200', 'Not all your training happens in the ring. Put in work on the heavy bag or run footwork drills in this Combat Noble trainer. This men\'s shoe won\'t weigh you down', 'Footwear', '0.23', '130.00', '140.00', 10000, 1, 'COMBAT-READY SHOES FOR ADVANCED LATERAL SUPPORT AND STABILITY', 5),
(10306, '247', '74201', 'A unique and versatile NB lifestyle shoe designed for your 24/7 style. The new 247 for men takes inspiration from the v1 and pushes style even further.', 'Footwear', '0.23', '139.99', '149.99', 33333, 1, 'A REVlite midsole provides additional comfort without added bulk or weight.', 5),
(10307, 'Leather 928v3', '74202', 'Stable and steady wins the race. The New Balance 928 men’s walking shoe features motion control and ROLLBAR stability technologies and ABZORB cushioning', 'Footwear', '0.23', '159.99', '169.99', 33333, 1, 'Leather upper', 5),
(10308, '574 Core', '74203', 'This 574 sneaker brings you the same premium materials and performance you expect from New Balance refreshed with a premium suede and mesh design and today \'s comfort technology.', 'Footwear', '0.23', '100.99', '109.99', 33333, 1, 'Rubber outsole', 5),
(10309, 'Fresh Foam Cruz v2 Nubuck', '74204', 'The men\'s Fresh Foam Cruz v2 Nubuck makes plush comfort even fresher with a nubuck leather midfoot saddle for support and style.', 'Footwear', '0.23', '89.99', '99.99', 33333, 1, 'Nubuck/knit upper', 5),
(10310, '880v8', '74205', 'Designed with thoughtful geometries and crucial forefoot flexibility  the men’s 880v8 running shoe is built with many miles in mind.', 'Footwear', '0.23', '149.99', '159.99', 33333, 1, 'Engineered mesh upper', 5),
(10311, 'Fresh Foam 1080v8', '74206', 'The eighth iteration of the Fresh Foam 1080 for men uses data-driven input to deliver premium underfoot support.', 'Footwear', '0.23', '169.99', '179.99', 33333, 1, 'Synthetic/mesh upper', 5),
(10312, '990v4 Made in US', '74207', 'The latest in our Made in the USA series  the 990v4 celebrates the great performance and iconic style of the 990’s 30-year-legacy.', 'Footwear', '0.23', '209.99', '219.99', 33333, 1, 'Pigskin/mesh upper', 5),
(10313, '860v9', '74208', 'Lace up the new 860v9 for men and experience exceptionally responsive cushioning and reliable support when you hit the road for your run.', 'Footwear', '0.23', '154.99', '164.99', 33333, 1, 'Blown rubber outsole', 5),
(10314, '101', '74209', 'Inspired by the classic skate slip-on look  the NB# 101 features a stretch material in the collar to make it easy to get up and go.', 'Footwear', '0.23', '79.99', '89.99', 33333, 1, 'NB# are performance skate shoes and have a narrow fit. We recommend ordering 1/2 size bigger than you do in regular NB lifestyle shoes.', 5),
(10315, '1100', '74210', 'Work and walk in style with the premium construction and classic styling of the men’s Leather 1100. Featuring an oxford-style silhouette constructed with leather suede', 'Footwear', '0.23', '159.99', '169.99', 33333, 1, 'Leather/suede upper', 5),
(10316, '1400v6', '74211', 'Taking cues from our track collection  the race-ready 1400v6 feels fast on responsive REVlite cushioning.', 'Footwear', '0.23', '119.99', '129.99', 33333, 1, 'Women\'s Spikes and Competition', 5),
(10317, '1500T2', '74212', 'Using data from our sports research lab  we designed this 1500T2 women\'s running shoe to help you tackle any distance  from a 5K to a marathon.', 'Footwear', '0.23', '149.99', '159.99', 33333, 1, 'Women\'s Spikes and Competition', 5),
(10318, '1500v4', '74213', 'Designed to help you tackle any distance  the 1500v4 women\'s running shoe offers plush  lightweight support with REVlite cushioning.', 'Footwear', '0.23', '109.99', '119.99', 33333, 1, 'Synthetic/mesh upper', 5),
(10319, '1500v5', '74214', 'Built and designed for competitive road runners seeking a fast ride and reliable support  the new 1500v5 women\'s runner brings a fresh look to this classic series.', 'Footwear', '0.23', '129.99', '139.99', 33333, 1, 'Breathable air mesh', 5),
(10320, '1540v2', '74215', 'For some runners  it’s not distance or endurance that they’re working towards  it’s simply a desire to get their feet moving in the right direction: forward.', 'Footwear', '0.23', '189.99', '199.99', 33333, 1, 'Dual density collar foam', 5),
(10321, '1865', '74216', 'Turn your walks into a workout with the New Balance 1865  our innovative update to the 1765. Featuring medial and forefoot support for stability', 'Footwear', '0.23', '134.99', '144.99', 33333, 1, 'Lightweight cushioned midsole', 5),
(10322, '247 Classic', '74217', 'The womens \' 247 Classic may take its design cues from the past  but its sleek look and advanced REVlite technology are straight-up 21st century.', 'Footwear', '0.23', '89.99', '99.99', 33333, 1, 'Synthetic/textile upper', 5),
(10323, '247 Decon', '74218', 'In this fresh iteration of our best-selling 247 shoe  we\'ve removed our signature saddle and deconstructed the collar to create a sleek silhouette.', 'Footwear', '0.23', '119.99', '129.99', 33333, 1, 'Engineered knit/synthetic upper', 5),
(10324, 'Minimus 10v1 Trail', '74219', 'Off-road adventure awaits. The original fit and feel of the Minimus Trail 10 is back. With an upper made of flexible synthetic/mesh materials and a Vibram outsole with flex grooves', 'Footwear', '0.23', '139.99', '149.99', 33333, 1, 'Synthetic/mesh upper', 5),
(10325, 'Minimus 20v7 Trainer', '74220', 'Up your training with the Minimus 20v7. The new knit upper is constructed with nylon-infused yarn that form a barrier around the foot for superior protection and lateral support.', 'Footwear', '0.23', '119.99', '129.99', 33333, 1, 'Synthetic/mesh upper', 5),
(10326, 'Minimus 40 Trainer', '74221', 'Easily switch between lifting and intense interval exercises with the multi-tasking New Balance Minimus 40 cross trainer', 'Footwear', '0.23', '129.99', '139.99', 33333, 1, 'Synthetic/mesh upper with TPU reinforcement', 5),
(10327, 'Fresh Foam Zante Trainer', '74222', 'Upgrade your workout in our New Balance Fresh Foam Zante Trainer. With its dynamic upper structure  multi-directional traction and tuned cushioning', 'Footwear', '0.23', '109.99', '119.99', 33333, 1, 'Lightweight solid rubber outsole', 5),
(10328, 'NBCycle WX09', '74223', 'The performance of a cycle shoe with the comfort and style of a sneaker. The NBCycle shoe for women is our first shoe made for indoor cycle classes.', 'Footwear', '0.23', '149.99', '159.99', 33333, 1, 'Alternative closure', 5),
(10329, 'FuelCore NERGIZE', '74224', 'Slip on the FuelCore NERGIZE women\'s training shoe and go. Modern style meets comfy cushioning in this all day  everyday kick.', 'Footwear', '0.23', '79.99', '89.99', 33333, 1, 'NB memory sole comfort insert', 5),
(10330, '10pc Golf Balls', '52731', '10 pack of Golf Balls', 'Sports Equipment', '0.53', '11.00', '15.00', 22222, 1, NULL, 8),
(10331, '50pc Golf Balls', '52732', '50 Pack of Golf Balls', 'Sports Equipment', '2.20', '55.00', '60.00', 22222, 1, NULL, 4),
(10332, '14pc Wood Golf Club Set', '52733', 'A full range of Wood and Iron Clubs with Wood Shafts', 'Sports Equipment', '5.00', '120.00', '150.00', 22222, 1, NULL, 4),
(10333, '9pc Iron Set', '52734', 'A full set of Iron clubs', 'Sports Equipment', '3.00', '80.00', '90.00', 22222, 1, NULL, 4),
(10334, '14pc Graphite Golf Club Set', '52735', 'A full set of Wood and Iron Clubs with Graphite Shafts', 'Sports Equipment', '4.00', '200.00', '220.00', 22222, 1, NULL, 4),
(10335, 'Wood Wood Driver', '52736', 'A Wood Driver with a Wood shaft', 'Sports Equipment', '0.90', '20.00', '30.00', 22222, 1, NULL, 4),
(10336, 'Graphite Wood Driver', '52737', 'A Wood Driver with a Graphite shaft', 'Sports Equipment', '0.80', '30.00', '50.00', 22222, 1, NULL, 4),
(10337, 'Canvas Golf Bag', '52738', 'A Red Canvas Golf Bag', 'Sports Equipment', '2.00', '40.00', '55.00', 22222, 1, NULL, 4),
(10338, 'Canvas Golf Bag', '52739', 'A Green Canvas Golf Bag', 'Sports Equipment', '2.00', '40.00', '55.00', 22222, 1, NULL, 4),
(10339, 'Canvas Golf Bag', '52740', 'A Blue Canvas Golf Bag', 'Sports Equipment', '2.00', '40.00', '55.00', 22222, 1, NULL, 4),
(10340, 'Canvas Golf Bag', '52741', 'A Orange Canvas Golf Bag', 'Sports Equipment', '2.00', '40.00', '55.00', 22222, 1, NULL, 4),
(10341, 'Canvas Golf Bag', '52742', 'A White Canvas Golf Bag', 'Sports Equipment', '2.00', '40.00', '55.00', 22222, 1, NULL, 4),
(10342, 'Canvas Golf Bag', '52743', 'A Black Canvas Golf Bag', 'Sports Equipment', '2.00', '40.00', '55.00', 22222, 1, NULL, 4),
(10343, 'M5 Driver', '52744', 'Every M5 driver head has been individually injected to reach the threshold of the maximum legal limit of ball speed...', 'Sports Equipment', '1.00', '600.00', '699.00', 22222, 1, NULL, 4),
(10344, 'M5 Tour Driver', '52745', 'M5 Tour driver features the same incredible technologies of its bigger M5 brother—like Speed Injected Twist Face and Inverse T-Track—in a smaller  Tour-inspired 435cc', 'Sports Equipment', '1.00', '600.00', '699.00', 22222, 1, NULL, 4),
(10345, 'M6 Driver', '52746', 'Every M6 driver head has been individually injected to reach the maximum legal limit of ball speed. Step up to the tee with the confidence of having a driver with Tour-caliber', 'Sports Equipment', '1.00', '600.00', '699.00', 22222, 1, NULL, 4),
(10346, 'M6 D-Type Driver', '52747', 'Every M6 D-Type driver head has been individually injected to reach the maximum legal limit of ball speed. Step up to the tee with the confidence of having a draw-biased driver', 'Sports Equipment', '1.00', '600.00', '699.00', 22222, 1, NULL, 4),
(10347, 'M6 Ladies Driver', '52748', 'Every M6 driver head has been individually injected to reach the maximum legal limit of ball speed. Step up to the tee with the confidence of having a driver with Tour-caliber', 'Sports Equipment', '1.00', '600.00', '699.00', 22222, 1, NULL, 4),
(10348, 'M6 Ladies D-Type Driver', '52749', 'M6 D-TYPE DRIVER SPEED INJECTED FOR MAXIMUM FORGIVENESS WITH A DRAW JUICED-UP WITH SPEED INJECTED TWIST FACE Every M6 D-Type driver head has been individually injected...', 'Sports Equipment', '1.00', '600.00', '699.00', 22222, 1, NULL, 4),
(10349, 'M3 Driver', '52750', 'A radical departure from traditional driver-face design  Twist Face is engineered to take you farther and straighter right down the center of the fairway...', 'Sports Equipment', '1.00', '600.00', '699.00', 22222, 1, NULL, 4),
(10350, 'M4 Driver', '52751', 'A radical departure from traditional driver-face design  Twist Face is engineered to take you farther and straighter… right down the center of the fairway...', 'Sports Equipment', '1.00', '600.00', '699.00', 22222, 1, NULL, 4),
(10351, 'M2 Driver', '52752', 'BETTER EVERYTHING. The 2017 M2 driver brings golfers a new level of distance and forgiveness through all-new GeocousticTM technology. Following in the footsteps of its...', 'Sports Equipment', '1.00', '600.00', '699.00', 22222, 1, NULL, 4),
(10352, 'M5 Fairway', '52753', 'For the first time ever  Twist Face has been engineered into fairway clubs. Thread the needle off the tee and start reaching par 5s in two with straight distance like never...', 'Sports Equipment', '1.00', '300.00', '499.00', 22222, 1, NULL, 4),
(10353, 'M6 Fairway', '52754', 'For the first time ever  Twist Face has been engineered into fairway clubs. Thread the needle off the tee and start reaching par 5s in two with straight distance like never...', 'Sports Equipment', '1.00', '300.00', '399.00', 22222, 1, NULL, 4),
(10354, 'M6 Fairway D-Type', '52755', 'For the first time ever  Twist Face has been engineered into fairway clubs. Thread the needle off the tee and start reaching par 5s in two with straight distance like never...', 'Sports Equipment', '1.00', '300.00', '399.00', 22222, 1, NULL, 4),
(10355, 'M6 Ladies Fairway', '52756', 'For the first time ever  Twist Face has been engineered into fairway clubs. Thread the needle off the tee and start reaching par 5s in two with straight distance like never...', 'Sports Equipment', '1.00', '300.00', '399.00', 22222, 1, NULL, 4),
(10356, 'M3 Fairway', '52757', 'Whether you’re reaching par 5s in two or threading the needle off the tee  TaylorMade’s new M3 fairway delivers straight distance  so you can split fairways and stick...', 'Sports Equipment', '1.00', '300.00', '399.00', 22222, 1, NULL, 4),
(10357, 'M4 Fairway', '52758', 'Whether you’re reaching par 5s in two or threading the needle off the tee  TaylorMade’s new M4 fairway delivers straight distance  so you can split fairways and stick...', 'Sports Equipment', '1.00', '300.00', '399.00', 22222, 1, NULL, 4),
(10358, 'M4 Tour Fairway', '52759', 'Whether you’re reaching par 5s in two or threading the needle off the tee  TaylorMade’s new M4 Tour fairway delivers straight distance  so you can split fairways and...', 'Sports Equipment', '1.00', '300.00', '399.00', 22222, 1, NULL, 4),
(10359, 'M4 Ladies Fairway', '52760', 'Whether you’re reaching par 5s in two or threading the needle off the tee  TaylorMade’s new M4 fairway delivers straight distance  so you can split fairways and stick...', 'Sports Equipment', '1.00', '300.00', '399.00', 22222, 1, NULL, 4),
(10360, 'Kalea Ladies Fairway', '52761', 'COMPLETELY YOURS Kalea expands on TaylorMade’s pursuit to produce the best-performing products across all categories with a complete set that has been specially...', 'Sports Equipment', '1.00', '300.00', '399.00', 22222, 1, NULL, 4),
(10361, 'M6 Rescue', '52762', 'For the first time ever  Twist Face has been engineered into a hybrid for straighter and longer mis-hits...', 'Sports Equipment', '1.00', '200.00', '299.00', 22222, 1, NULL, 4),
(10362, 'M6 Ladies Rescue', '52763', 'For the first time ever  Twist Face has been engineered into a hybrid for straighter and longer mis-hits...', 'Sports Equipment', '1.00', '200.00', '299.00', 22222, 1, NULL, 4),
(10363, 'M3 Rescue', '52764', 'When a hybrid club is in your hands  it’s time to pull off the incredible. The 2018 M3 Rescue combines TaylorMade technologies and Tour-inspired shaping  so you can execute...', 'Sports Equipment', '1.00', '200.00', '299.00', 22222, 1, NULL, 4),
(10364, 'M4 Rescue', '52765', 'When a hybrid club is in your hands  it’s time to pull off the incredible. The 2018 M4 Rescue combines TaylorMade technologies with a playable shape  so you can execute...', 'Sports Equipment', '1.00', '200.00', '299.00', 22222, 1, NULL, 4),
(10365, 'M4 Ladies Rescue', '52766', 'When a hybrid club is in your hands  it’s time to pull off the incredible. The 2018 M4 Rescue combines TaylorMade technologies with a playable shape  so you can execute...', 'Sports Equipment', '1.00', '200.00', '299.00', 22222, 1, NULL, 4),
(10366, 'M1 Rescue', '52767', 'PERSONALIZED DISTANCE AND VERSATILITY The 2017 M1 Rescue Hybrid features improved distance and versatility with the first-ever sliding weight track in a Rescue club...', 'Sports Equipment', '1.00', '200.00', '299.00', 22222, 1, NULL, 4),
(10367, 'M2 Rescue', '52768', 'DESIGNED FOR DISTANCE AND PLAYABILITY The 2017 M2 Rescue Hybrid features the iconic two-tone crown of the M Metalwoods Family and new innovative performance...', 'Sports Equipment', '1.00', '200.00', '299.00', 22222, 1, NULL, 4),
(10368, 'Kalea Ladies Rescue', '52769', 'COMPLETELY YOURS Kalea expands on TaylorMade’s pursuit to produce the best-performing products across all categories with a complete set that has been specially...', 'Sports Equipment', '1.00', '200.00', '299.00', 22222, 1, NULL, 4),
(10369, 'M4 Combo Set', '52770', 'Get the most out of your equipment with a M4 combo set. By replacing your long irons with forgiving and versatile hybrids and taking advantage of RIBCOR technology in your mid...', 'Sports Equipment', '5.00', '900.00', '999.00', 22222, 1, NULL, 4),
(10370, 'M4 Ladies Combo Set', '52771', 'Get the most out of your equipment with a M4 combo set. By replacing your long irons with forgiving and versatile hybrids and taking advantage of RIBCOR technology in your mid...', 'Sports Equipment', '5.00', '900.00', '999.00', 22222, 1, NULL, 4),
(10371, 'P730 Irons', '52772', 'PRECISELY CRAFTED FOR ULTIMATE SHOT-MAKING. Designed specifically for the best Tour players in the world  P730 represents the most finely crafted irons TaylorMade has to...', 'Sports Equipment', '5.00', '900.00', '999.00', 22222, 1, NULL, 4),
(10372, 'P750 Tour Proto Irons', '52773', 'RESERVED FOR THE EXCEPTIONAL The Tour demands perfection  P750 delivers. P750 Tour Proto irons are reserved for the best ball-strikers—players who prefer a more...', 'Sports Equipment', '5.00', '900.00', '999.00', 22222, 1, NULL, 4),
(10373, 'M CGB Irons', '52774', 'COMPLETELY MAXIMIZED FOR EVERY SHOT. M CGB pushes the limit of irons engineering for maximum distance throughout the entire set. Starting with a <2mm face thickness...', 'Sports Equipment', '5.00', '900.00', '999.00', 22222, 1, NULL, 4),
(10374, 'M4 Ladies Irons', '52775', 'M4 ladies irons unlock a new level of straightness  distance  and forgiveness in a product designed to be the longest in our irons lineup...', 'Sports Equipment', '5.00', '900.00', '999.00', 22222, 1, NULL, 4),
(10375, 'M1 Irons', '52776', 'DISTANCE + HEIGHT + CONTROL In 2017  TaylorMade introduces the M1 irons — an entirely new line that packs the distance and forgiveness of M2 irons in a more compact...', 'Sports Equipment', '5.00', '900.00', '999.00', 22222, 1, NULL, 4),
(10376, 'M CGB Ladies Irons', '52777', 'COMPLETELY MAXIMIZED FOR EVERY SHOT. M CGB pushes the limit of irons engineering for maximum distance throughout the entire set. Starting with a <2mm face thickness...', 'Sports Equipment', '5.00', '900.00', '999.00', 22222, 1, NULL, 4),
(10377, 'Kalea Ladies 10-Piece Set', '52778', 'COMPLETELY YOURS Kalea expands on TaylorMade’s pursuit to produce the best-performing products across all categories with a complete set that has been specially...', 'Sports Equipment', '5.00', '900.00', '999.00', 22222, 1, NULL, 2),
(10378, 'Kalea Ladies 8-Piece Set', '52779', 'COMPLETELY YOURS Kalea expands on TaylorMade’s pursuit to produce the best-performing products across all categories with a complete set that has been specially...', 'Sports Equipment', '5.00', '900.00', '999.00', 22222, 1, NULL, 2),
(10379, 'M CGB Combo Set', '52780', 'M CGB pushes the limit of irons engineering for maximum distance throughout the entire set...', 'Sports Equipment', '5.00', '900.00', '999.00', 22222, 1, NULL, 2),
(10380, 'P790 UDI', '52781', 'P790 UDI features minimal offset  a straighter topline  and refined shaping for a clean look at address...', 'Sports Equipment', '1.00', '900.00', '999.00', 22222, 1, NULL, 4),
(10381, 'M5 Irons', '52782', 'The new Speed Bridge structure unlocks the ability to use our fastest thru-slot Speed Pocket for the first time in our players distance...', 'Sports Equipment', '5.00', '900.00', '999.00', 22222, 1, NULL, 4),
(10382, 'M6 Irons', '52783', 'New Speed Bridge structure unlocks the ability to use our most flexible thru-slot Speed Pocket engineered to generate more ball speed than ever before...', 'Sports Equipment', '5.00', '900.00', '999.00', 22222, 1, NULL, 4),
(10383, 'M6 Combo Set', '52784', 'Get the most out of your equipment with an M6 combo set  featuring M6 Rescues with Twist Face and new Speed Bridge structure in M6 irons...', 'Sports Equipment', '5.00', '900.00', '999.00', 22222, 1, NULL, 4),
(10384, 'M6 Ladies Irons', '52785', 'New Speed Bridge structure unlocks the ability to use our most flexible thru-slot Speed Pocket engineered to generate more ball speed than ever before...', 'Sports Equipment', '5.00', '900.00', '999.00', 22222, 1, NULL, 4),
(10385, 'M6 Ladies Combo Set', '52786', 'Get the most out of your equipment with an M6 combo set  featuring M6 Rescues with Twist Face and new Speed Bridge structure in M6 irons...', 'Sports Equipment', '5.00', '900.00', '999.00', 22222, 1, NULL, 4),
(10386, 'P760 Irons', '52787', 'When Tour forging and SpeedFoam technology come together  it\'s a beautiful combination to behold. P760 delivers progressive players-iron shaping  giving golfers clean and compact...', 'Sports Equipment', '5.00', '900.00', '999.00', 22222, 1, NULL, 4),
(10387, 'P790 Black Irons', '52788', 'P790 Black irons pack powerful performance into a clean  classic design to deliver unprecedented distance in a players iron. Through a combination of forged construction and our...', 'Sports Equipment', '5.00', '900.00', '999.00', 22222, 1, NULL, 6),
(10388, 'P790 Irons', '52789', 'THIS BEAUTY IS A BEAST. P790 irons pack powerful performance into a clean  classic design to deliver unprecedented distance in a players iron. Through a combination of...', 'Sports Equipment', '5.00', '900.00', '999.00', 22222, 1, NULL, 8),
(10389, 'M3 Irons', '52790', 'Packed with performance and refined to suit the better player’s eye  M3 irons offer distance  forgiveness  and control for the serious golfer...', 'Sports Equipment', '5.00', '900.00', '999.00', 22222, 1, NULL, 6),
(10390, 'M4 Irons', '52791', 'M4 irons unlock a new level of straightness  distance  and forgiveness in a product designed to be the longest in our irons lineup...', 'Sports Equipment', '5.00', '900.00', '999.00', 22222, 1, NULL, 6),
(10391, 'Milled Grind HI-TOE Wedge', '52792', 'TaylorMade’s HI-TOE wedge lineup has been expanded to include a full range of wedge lofts from 50° to 64°. Featuring full-face scoring lines in the 56° to 64...', 'Sports Equipment', '1.00', '200.00', '299.00', 22222, 1, NULL, 6),
(10392, 'Milled Grind Wedge Black', '52793', 'The precision and control of Milled Grind (MG) wedges is now available in a new black finish. The MG Black wedge’s new color presents a darker  solid look at address...', 'Sports Equipment', '1.00', '200.00', '299.00', 22222, 1, NULL, 6),
(10393, 'Milled Grind Wedge Antique Bronze', '52794', 'The precision and control of Milled Grind (MG) wedges is now available in a new bronze finish. The MG Bronze wedge’s new color presents a darker  solid look at address...', 'Sports Equipment', '1.00', '200.00', '299.00', 22222, 1, NULL, 6),
(10394, 'Milled Grind Wedge', '52795', 'THE NEW MARKS OF PRECISION Drawing inspiration for the world’s best golfers  Milled Grind (MG) wedges use advanced surface milling techniques to ensure precise sole...', 'Sports Equipment', '1.00', '200.00', '299.00', 22222, 1, NULL, 6),
(10395, 'MySpider Tour', '52796', 'MySpider Tour Putters deliver Tour-proven performance to every golfer. With perimeter weighting for added stability and the ability to personalize to your liking', 'Sports Equipment', '1.00', '500.00', '599.00', 22222, 1, NULL, 6),
(10396, 'Spider Mini Red', '52797', 'With a refined Spider design  featuring a 15% smaller head construction  Spider Mini delivers the stability and high-MOI...', 'Sports Equipment', '1.00', '500.00', '599.00', 22222, 1, NULL, 6),
(10397, 'Spider Mini Diamond Silver', '52798', 'With a refined Spider design  featuring a 15% smaller head construction  Spider Mini delivers the stability and high-MOI...', 'Sports Equipment', '1.00', '500.00', '599.00', 22222, 1, NULL, 6),
(10398, 'TP Red-White Ardmore', '52799', 'The new TP Red-White Collection takes popular TP putter models and further improves the performance with an enhanced alignment system. Inspired by cosmetic requests from some of...', 'Sports Equipment', '1.00', '500.00', '599.00', 22222, 1, NULL, 6),
(10399, 'TP Red-White Ardmore 2', '52800', 'The new TP Red-White Collection takes popular TP putter models and further improves the performance with an enhanced alignment system. Inspired by cosmetic requests from some of...', 'Sports Equipment', '1.00', '500.00', '599.00', 22222, 1, NULL, 6),
(10400, 'TP Red-White Ardmore 3', '52801', 'The new TP Red-White Collection takes popular TP putter models and further improves the performance with an enhanced alignment system. Inspired by cosmetic requests from some of...', 'Sports Equipment', '1.00', '500.00', '599.00', 22222, 1, NULL, 6),
(10401, 'Spider Interactive', '52802', 'Introducing Spider Interactive powered by BLAST — A new way to improve your putting that combines the performance of our Spider Tour putter with real-time stroke analytics...', 'Sports Equipment', '1.00', '500.00', '599.00', 22222, 1, NULL, 6),
(10402, 'Spider Interactive \"L\" Neck', '52803', 'Introducing Spider Interactive powered by BLAST — A new way to improve your putting that combines the performance of our Spider Tour putter with real-time stroke analytics...', 'Sports Equipment', '1.00', '500.00', '599.00', 22222, 1, NULL, 6),
(10403, 'TP Black Copper Collection Mullen 2', '52804', 'The TP Black Copper Mullen 2 incorporates TaylorMade’s rich new colorway into a midsize mallet design...', 'Sports Equipment', '1.00', '500.00', '599.00', 22222, 1, NULL, 6),
(10404, 'TP Black Copper Collection Soto', '52805', 'The TP Black Copper Soto incorporates TaylorMade’s rich new colorway into a classic putter shape...', 'Sports Equipment', '1.00', '500.00', '599.00', 22222, 1, NULL, 6),
(10405, 'TP Black Copper Collection Ardmore 3', '52806', 'The TP Black Copper Ardmore 3 incorporates TaylorMade’s rich new colorway into a modern-shaped mallet design...', 'Sports Equipment', '1.00', '500.00', '599.00', 22222, 1, NULL, 6),
(10406, 'TP Black Copper Collection Juno', '52807', 'The TP Black Copper Juno incorporates TaylorMade\'s rich new colorway into a Tour-validated putter shape...', 'Sports Equipment', '1.00', '500.00', '599.00', 22222, 1, NULL, 6),
(10407, 'Spider Tour Red Double Bend', '52808', 'The Spider Tour Red with Sightline delivers Tour-proven performance to every golfer. With perimeter weighting for added stability and an added sightline to zero in the player\'s...', 'Sports Equipment', '1.00', '500.00', '599.00', 22222, 1, NULL, 6),
(10408, 'Spider Tour Black Double Bend', '52809', 'The Spider Tour Black with Sightline delivers Tour-proven performance to every golfer. With perimeter weighting for added stability and an added sightline to zero in the player\'s...', 'Sports Equipment', '1.00', '500.00', '599.00', 22222, 1, NULL, 6),
(10409, 'Spider Tour Diamond Silver Double Bend', '52810', 'The Spider Tour Diamond Platinum with Sightline delivers Tour-proven performance to every golfer. With perimeter weighting for added stability and an added sightline to zero in...', 'Sports Equipment', '1.00', '500.00', '599.00', 22222, 1, NULL, 6),
(10410, 'Spider Tour Diamond Silver \"L\" Neck', '52811', 'The Spider Tour Diamond Platinum with Sightline delivers Tour-proven performance to every golfer. With perimeter weighting for added stability and an added sightline to zero in...', 'Sports Equipment', '1.00', '500.00', '599.00', 22222, 1, NULL, 6),
(10411, 'Spider Tour Red \"L\" Neck', '52812', 'The Spider Tour Red with Sightline delivers Tour-proven performance to every golfer. With perimeter weighting for added stability and an added sightline to zero in the player\'s...', 'Sports Equipment', '1.00', '500.00', '599.00', 22222, 1, NULL, 6),
(10412, 'Spider Tour Red Center Shaft', '52813', 'The Spider Tour Red with Sightline delivers Tour-proven performance to every golfer. With perimeter weighting for added stability  a center-shafted design for the ultimate in...', 'Sports Equipment', '1.00', '500.00', '599.00', 22222, 1, NULL, 6),
(10413, 'Spider Tour Black Double Bend', '52814', 'The Spider Tour Black delivers Tour-proven performance to every golfer. With perimeter weighting for added stability and a removed sightline for clean alignment  Spider Tour...', 'Sports Equipment', '1.00', '500.00', '599.00', 22222, 1, NULL, 6),
(10414, 'Spider Tour Red', '52815', 'The Spider Tour Red delivers Tour-proven performance to every golfer. With perimeter weighting for added stability and a removed sightline to zero in the players focus  Spider...', 'Sports Equipment', '1.00', '500.00', '599.00', 22222, 1, NULL, 6),
(10415, 'Spider Arc Silver', '52816', 'Spider Arc Red offers better alignment and better stability in a Tour-proven design. With a lightweight aluminum body paired with a heavy stainless steel ring  Spider Arc offers...', 'Sports Equipment', '1.00', '500.00', '599.00', 22222, 1, NULL, 6),
(10416, 'Spider Arc Red', '52817', 'Spider Arc Red offers better alignment and better stability in a Tour-proven design. With a lightweight aluminum body paired with a heavy stainless steel ring  Spider Arc offers...', 'Sports Equipment', '1.00', '500.00', '599.00', 22222, 1, NULL, 6),
(10417, 'Spider Tour Platinum', '52818', 'The Spider Tour Platinum with Sightline delivers Tour-proven performance to every golfer. With perimeter weighting for added stability and an added sightline to zero in the...', 'Sports Equipment', '1.00', '500.00', '599.00', 22222, 1, NULL, 6),
(10418, 'Spider Tour Red Sightline', '52819', 'The Spider Tour Red with Sightline delivers Tour-proven performance to every golfer. With perimeter weighting for added stability and an added sightline to zero in the player\'s', 'Sports Equipment', '1.00', '500.00', '599.00', 22222, 1, NULL, 8),
(10419, 'TP Red Collection Ardmore 2 \"L\" Neck', '52820', 'The TP Ardmore Red Collection incorporates TaylorMade\'s striking Tour Red finish into a long  modern-shaped mallet design. Featuring an expansive array of shaft  sightline', 'Sports Equipment', '1.00', '500.00', '599.00', 22222, 1, NULL, 8),
(10420, 'TP Red Collection Ardmore 2 \"L\" Neck', '52821', 'The TP Ardmore Red Collection incorporates TaylorMade\'s striking Tour Red finish into a long  modern-shaped mallet design. Featuring an expansive array of shaft  sightline', 'Sports Equipment', '1.00', '500.00', '599.00', 22222, 1, NULL, 8),
(10421, 'TP Red Collection Ardmore 3', '52822', 'The TP Ardmore Red Collection incorporates TaylorMade’s striking Tour Red finish into a long  modern-shaped mallet design. Featuring an expansive array of shaft  sightline...', 'Sports Equipment', '1.00', '500.00', '599.00', 22222, 1, NULL, 8),
(10422, 'TP Red Collection Ardmore', '52823', 'The TP Ardmore Red Collection incorporates TaylorMade\'s striking Tour Red finish into a long  modern-shaped mallet design. Featuring an expansive array of shaft  sightline', 'Sports Equipment', '1.00', '500.00', '599.00', 22222, 1, NULL, 8),
(10423, 'TP Red Collection Ardmore Center Shaft', '52824', 'The TP Ardmore Red Collection incorporates TaylorMade\'s striking Tour Red finish into a long  modern-shaped mallet design. Featuring an expansive array of shaft  sightline...', 'Sports Equipment', '1.00', '500.00', '599.00', 22222, 1, NULL, 8),
(10424, 'TP Red Collection Chaska', '52825', 'With TP Chaska Red  golfers benefit from rounded contours  adjustable sole weights  and three forward sightlines for exceptional stability and simple alignment features. Combine...', 'Sports Equipment', '1.00', '500.00', '599.00', 22222, 1, NULL, 8),
(10425, '2017 TP5 Golf Balls', '52826', '5 LAYERS. ZERO COMPROMISES. TP5 features a Tri-Fast Core and Dual-Spin Cover that combine for a 5-layer golf ball construction that is specifically engineered to perform with...', 'Sports Equipment', '0.50', '40.00', '49.00', 22222, 1, NULL, 8),
(10426, '2017 TP5x Golf Balls', '52827', '5 LAYERS. ZERO COMPROMISES. TP5x feature a Tri-Fast Core and Dual-Spin Cover that combine for a 5-layer golf ball construction that is specifically engineered to perform with...', 'Sports Equipment', '0.50', '40.00', '49.00', 22222, 1, NULL, 8),
(10427, 'Project (a) Golf Balls', '52828', 'Tour Technology. Soft Feel.The new Project (a) features a three-layer design that incorporates a new Dual-Distance core and a new 322LDP seamless dimple pattern  which combines...', 'Sports Equipment', '0.50', '40.00', '49.00', 22222, 1, NULL, 8),
(10428, 'Project (a) Yellow Golf Balls', '52829', 'Tour Technology. Soft Feel. Hi-Visibility. The new Project (a) Yellow features a three-layer design that incorporates a new Dual-Distance core and a new 322LDP seamless dimple...', 'Sports Equipment', '0.50', '40.00', '49.00', 22222, 1, NULL, 8),
(10429, 'PROJECT(s)', '52830', 'The all-new Project (s) offers incredibly soft feel while continuing TaylorMade’s focus on low driver spin and significant driver distance. No longer does the golfer have...', 'Sports Equipment', '0.50', '40.00', '49.00', 22222, 1, NULL, 8),
(10430, 'Project (s) Matte Yellow Golf Balls', '52831', 'The all-new Project (s) offers incredibly soft feel while continuing TaylorMade’s focus on low driver spin and significant driver distance. No longer does the golfer have...', 'Sports Equipment', '0.50', '40.00', '49.00', 22222, 1, NULL, 8),
(10431, 'Project (s) Matte Orange Golf Balls', '52832', 'The all-new Project (s) offers incredibly soft feel while continuing TaylorMade’s focus on low driver spin and significant driver distance. No longer does the golfer have...', 'Sports Equipment', '0.50', '40.00', '49.00', 22222, 1, NULL, 8),
(10432, 'Noodle Neon Matte Red Golf Balls', '52833', 'Performance in Flying Colors — The new Noodle Neon golf balls have been designed to be long & soft with a low-compression speed core. Each golf ball also comes in a hi...', 'Sports Equipment', '0.50', '40.00', '49.00', 22222, 1, NULL, 8),
(10433, 'Noodle Neon Matte Lime Green Golf Balls', '52834', 'Performance in Flying Colors — The new Noodle Neon golf balls have been designed to be long & soft with a low-compression speed core. Each golf ball also comes in a hi...', 'Sports Equipment', '0.50', '40.00', '49.00', 22222, 1, NULL, 8),
(10434, 'Noodle Long & Soft Golf Balls (15 ball pack)', '52835', 'Get distance and soft feel with Noodle Long & Soft. Featuring 342 aerodynamic dimples that help cut air resistance for a longer carry and an ultra-soft 34 compression core...', 'Sports Equipment', '0.50', '40.00', '49.00', 22222, 1, NULL, 8),
(10435, 'TP Collection Balboa', '52836', 'New to the 2017 TP Putter Collection  the Balboa model offers a heel-shafted blade with an extended flange for a sleek  rounded design. With half-shaft offset and more toe hang...', 'Sports Equipment', '1.00', '500.00', '599.00', 22222, 1, NULL, 8),
(10436, 'TP Collection Chaska', '52837', 'Chaska introduces a unique new shape to the TP Collection. With rounded contours  adjustable sole weights  and three forward sightlines  the design provides exceptional stability...', 'Sports Equipment', '1.00', '500.00', '599.00', 22222, 1, NULL, 8),
(10437, 'TP Collection Ardmore', '52838', 'Ardmore introduces a long  modern-shaped mallet to the TP Collection of putters. Featuring two bottom sightlines  a single bend shaft  and face balanced design  Ardmore provides...', 'Sports Equipment', '1.00', '500.00', '599.00', 22222, 1, NULL, 8),
(10438, 'TP Collection Mullen', '52839', 'Soto offers a blade-style putter with a classic and clean design. Utilizing short and rounded contours to provide a smooth appearance at address  Soto includes a single sightline...', 'Sports Equipment', '1.00', '500.00', '599.00', 22222, 1, NULL, 8),
(10439, 'GrillPower 4x4 High Performance All Terrain Golf Cart', '52840', 'A High performance Golf Cart with 4x4 drive 5 seats  and a flame paint job. DO NOT STAND IN FRONT OF OR BEHIND.', 'Sports Equipment', '500.00', '5000.00', '6009.99', 22222, 1, NULL, 8),
(10440, 'Indoor Game Basketball', '12100', 'Basketball ball', 'Sports Equipment', '0.60', '29.99', '59.99', 11000, 1, NULL, 4),
(10441, 'NBA Official Game Ball', '12101', 'Basketball ball', 'Sports Equipment', '0.60', '100.00', '170.00', 11000, 1, NULL, 4),
(10442, 'NBA Game Ball Replica Basketball', '12102', 'Basketball ball', 'Sports Equipment', '0.60', '39.99', '59.99', 11000, 1, NULL, 4),
(10443, 'WNBA Replica Outdoor Basketball', '12103', 'Basketball ball', 'Sports Equipment', '0.60', '39.99', '59.99', 11000, 1, NULL, 4),
(10444, 'Uncle Drew Outdoor Basketball - The Icon', '12104', 'Basketball ball', 'Sports Equipment', '0.60', '39.99', '59.99', 11000, 1, NULL, 4),
(10445, 'Uncle Drew Mini Basketball - The Squad Goals', '12105', 'Basketball ball', 'Sports Equipment', '0.60', '39.99', '59.99', 11000, 1, NULL, 4),
(10446, 'Uncle Drew Outdoor Basketball - The Legend', '12106', 'Basketball ball', 'Sports Equipment', '0.60', '39.99', '59.99', 11000, 1, NULL, 4),
(10447, 'Uncle Drew Outdoor Basketball - The Big Fella', '12107', 'Basketball ball', 'Sports Equipment', '0.60', '39.99', '59.99', 11000, 1, NULL, 4),
(10448, 'TF-1000 Legacy Basketball', '12108', 'Basketball ball', 'Sports Equipment', '0.60', '39.99', '59.99', 11000, 1, NULL, 4),
(10449, 'NBA Instinct Indoor-Outdoor Basketball', '12109', 'Basketball ball', 'Sports Equipment', '0.60', '49.99', '79.99', 11000, 1, NULL, 4),
(10450, 'NBA Street Phantom Outdoor Basketball', '12110', 'Basketball ball', 'Sports Equipment', '0.60', '49.99', '79.99', 11000, 1, NULL, 4),
(10451, 'SPALDING ROOKIE GEAR BASKETBALL', '12111', 'Basketball ball', 'Sports Equipment', '0.60', '49.99', '79.99', 11000, 1, NULL, 4),
(10452, 'TF-500 Indoor Basketball', '12112', 'Basketball ball', 'Sports Equipment', '0.50', '49.99', '79.99', 11000, 1, NULL, 4),
(10453, 'TF-250 Indoor-Outdoor Basketball', '12113', 'Basketball ball', 'Sports Equipment', '0.25', '49.99', '79.99', 11000, 1, NULL, 4),
(10454, 'NBA Zi/O Basketball', '12114', 'Basketball ball', 'Sports Equipment', '0.25', '49.99', '79.99', 11000, 1, NULL, 4),
(10455, 'NBA Neverflat Hexagri Basketball', '12115', 'Basketball ball', 'Sports Equipment', '0.25', '59.99', '89.99', 11000, 1, NULL, 4),
(10456, 'NBA Courtside Team Outdoor Basketball', '12116', 'Basketball ball', 'Sports Equipment', '0.25', '59.99', '89.99', 11000, 1, NULL, 4),
(10457, 'NBA Varsity Outdoor Basketball', '12117', 'Basketball ball', 'Sports Equipment', '0.25', '59.99', '89.99', 11000, 1, NULL, 4),
(10458, 'NBA Varsity Multi-Color Outdoor Basketball', '12118', 'Basketball ball', 'Sports Equipment', '0.25', '59.99', '89.99', 11000, 1, NULL, 4),
(10459, 'NBA TREND SERIES SHATTER', '12119', 'Basketball ball', 'Sports Equipment', '0.50', '59.99', '89.99', 11000, 1, NULL, 4),
(10460, 'NBA TREND SERIES  VERT CAMO', '12120', 'Basketball ball', 'Sports Equipment', '0.50', '59.99', '89.99', 11000, 1, NULL, 4),
(10461, 'NBA Team Mini Basketball', '12121', 'Basketball ball', 'Sports Equipment', '0.50', '59.99', '89.99', 11000, 1, NULL, 4),
(10462, 'NBA TREND SERIES NOTEBOOK', '12122', 'Basketball ball', 'Sports Equipment', '0.50', '59.99', '89.99', 11000, 1, NULL, 4),
(10463, 'NBA TREND SERIES BASKETBALL WHITE SNAKE', '12123', 'Basketball ball', 'Sports Equipment', '0.50', '59.99', '89.99', 11000, 1, NULL, 4),
(10464, 'AUTOGRAPH BASKETBALL', '12124', 'Basketball ball', 'Sports Equipment', '0.50', '59.99', '89.99', 11000, 1, NULL, 4),
(10465, 'NBA TREND SERIES  BROWN SNAKE SKIN', '12125', 'Basketball ball', 'Sports Equipment', '0.50', '69.99', '99.99', 11000, 1, NULL, 4),
(10466, 'NBA Varsity Outdoor Youth Basketball', '12126', 'Basketball ball', 'Sports Equipment', '0.50', '69.99', '99.99', 11000, 1, NULL, 4),
(10467, 'NEVERFLAT HEXAGRIP BASKETBALL', '12127', 'Basketball ball', 'Sports Equipment', '0.50', '69.99', '99.99', 11000, 1, NULL, 4),
(10468, 'NBA Varsity Inddor Basketball', '12128', 'Basketball ball', 'Sports Equipment', '0.50', '69.99', '99.99', 11000, 1, NULL, 4),
(10469, 'NBA Team Basketball', '12129', 'Basketball ball', 'Sports Equipment', '0.50', '69.99', '99.99', 11000, 1, NULL, 4),
(10470, 'The Beast Glass Portable Basketball Hoop System', '12130', 'Basketball Hoop', 'Sports Equipment', '13.00', '799.99', '999.99', 11000, 1, NULL, 1),
(10471, 'Ultimate Hybrid Portable Basketball Hoop System', '12131', 'Basketball Hoop', 'Sports Equipment', '13.00', '799.99', '999.99', 11000, 1, NULL, 1),
(10472, 'Ultimate Hybrid Portable Basketball Hoop System', '12132', 'Basketball Hoop', 'Sports Equipment', '13.00', '799.99', '999.99', 11000, 1, NULL, 1),
(10473, 'Acrylic Backboard and Rim Combo', '12133', 'Basketball Hoop', 'Sports Equipment', '7.00', '599.99', '799.99', 11000, 1, NULL, 1),
(10474, 'Hercules Pro Glide Advanced Portable Basketball Hoop System - Acrylic', '12134', 'Basketball Hoop', 'Sports Equipment', '8.00', '699.99', '999.99', 11000, 1, NULL, 1),
(10475, 'Hercules Pro Glide Advanced Portable Basketball Hoop System - 52\" Acrylic', '12135', 'Basketball Hoop', 'Sports Equipment', '8.00', '699.99', '999.99', 11000, 1, NULL, 1),
(10476, 'Hercules Exactaheight Portable Basketball Hoop System - 50\" Acrylic', '12136', 'Basketball Hoop', 'Sports Equipment', '8.00', '699.99', '999.99', 11000, 1, NULL, 1),
(10477, 'Hercules Exactaheight Portable Basketball Hoop System - Acrylic', '12137', 'Basketball Hoop', 'Sports Equipment', '8.00', '699.99', '999.99', 11000, 1, NULL, 1),
(10478, '44\" Eco-Composite Backboard & Rim Combo', '12138', 'Basketball Hoop', 'Sports Equipment', '6.00', '499.99', '699.99', 11000, 1, NULL, 1),
(10479, 'ARENA VIEW H-SERIES 72\" ADJUSTABLE HEIGHT IN-GROUND', '12139', 'Basketball Hoop', 'Sports Equipment', '11.00', '899.99', '1199.99', 11000, 1, NULL, 1),
(10480, 'NBA Breakaway 180 Over-the-Door Basketball Hoop', '12140', 'Basketball Hoop', 'Sports Equipment', '11.00', '899.99', '1199.99', 11000, 1, NULL, 1),
(10481, 'U-Turn In-Ground Basketball Hoop System - 54\" Acrylic', '12141', 'Basketball Hoop', 'Sports Equipment', '11.00', '899.99', '1199.99', 11000, 1, NULL, 1),
(10482, 'Spalding 72\" Arena View Series In-Ground Basketball Hoop System', '12142', 'Basketball Hoop', 'Sports Equipment', '11.00', '899.99', '1199.99', 11000, 1, NULL, 1),
(10483, 'Exactaheight In-Ground Basketball Hoop System', '12143', 'Basketball Hoop', 'Sports Equipment', '11.00', '899.99', '1199.99', 11000, 1, NULL, 1),
(10484, 'Ratchet Lift In-Ground Basketball Hoop System - 44\" Polycarbonate', '12144', 'Basketball Hoop', 'Sports Equipment', '11.00', '899.99', '1199.99', 11000, 1, NULL, 1),
(10485, '54\" Acrylic Backboard and Rim Combo Basketball Hoop', '12145', 'Basketball Hoop', 'Sports Equipment', '11.00', '899.99', '1199.99', 11000, 1, NULL, 1),
(10486, 'U-Turn In-Ground Glass Basketball Hoop System', '12146', 'Basketball Hoop', 'Sports Equipment', '13.00', '999.99', '1399.99', 11000, 1, NULL, 1),
(10487, 'Polycarbonate Backboard and Rim Combo', '12147', 'Basketball Hoop', 'Sports Equipment', '13.00', '999.99', '1399.99', 11000, 1, NULL, 1),
(10488, 'Youth One-On-One Portable Basketball Hoop System', '12148', 'Basketball Hoop', 'Sports Equipment', '13.00', '999.99', '1399.99', 11000, 1, NULL, 1),
(10489, 'Pro Glide Polycarbonate Portable Basketball Hoop System', '12149', 'Basketball Hoop', 'Sports Equipment', '13.00', '999.99', '1399.99', 11000, 1, NULL, 1),
(10490, 'Fan Backboard and Rim Combo Basketball Hoop - 44\" Eco-Composite', '12150', 'Basketball Hoop', 'Sports Equipment', '13.00', '999.99', '1399.99', 11000, 1, NULL, 1),
(10491, 'Telescoping Portable Hoop System - 44\" Eco-Composite', '12151', 'Basketball Hoop', 'Sports Equipment', '10.00', '859.99', '1099.99', 11000, 1, NULL, 1),
(10492, 'Pro Glide In-Ground Basketball Hoop System - 52\" Acrylic', '12152', 'Basketball Hoop', 'Sports Equipment', '10.00', '859.99', '1099.99', 11000, 1, NULL, 1),
(10493, 'ALL WEATHER BASKETBALL NET', '12153', 'Basketball Hoop', 'Sports Equipment', '10.00', '859.99', '1099.99', 11000, 1, NULL, 1),
(10494, 'Pro Slam Basketball Rim', '12154', 'Basketball Hoop', 'Sports Equipment', '10.00', '859.99', '1099.99', 11000, 1, NULL, 1),
(10495, 'Universal Backboard Mounting Bracket', '12155', 'Basketball Hoop', 'Sports Equipment', '10.00', '859.99', '1099.99', 11000, 1, NULL, 1),
(10496, 'Pro Image Basketball Rim', '12156', 'Basketball Hoop', 'Sports Equipment', '11.00', '999.99', '1199.99', 11000, 1, NULL, 1),
(10497, 'OFFICIAL ON-COURT NBA GAME NET', '12157', 'Basketball Hoop', 'Sports Equipment', '11.00', '999.99', '1199.99', 11000, 1, NULL, 1),
(10498, 'Positive Lock Basketball Rim', '12158', 'Basketball Hoop', 'Sports Equipment', '11.00', '999.99', '1199.99', 11000, 1, NULL, 1),
(10499, 'U-Turn Basketball Hoop Lift System', '12159', 'Basketball Hoop', 'Sports Equipment', '11.00', '999.99', '1199.99', 11000, 1, NULL, 1),
(10500, 'Basketball Maintenance Kit', '12160', 'Maintnance kit', 'Sports Equipment', '2.00', '7.00', '9.00', 11000, 1, NULL, 1),
(10501, 'AIR PRESSURE GAUGES', '12161', 'Preesure gauge', 'Sports Equipment', '0.40', '7.00', '9.00', 11000, 1, NULL, 1),
(10502, 'BASKETBALL TUNE-UP KIT', '12162', 'Tune up Kit', 'Sports Equipment', '0.30', '8.99', '12.99', 11000, 1, NULL, 1),
(10503, 'NBA BASKETBALL PUMP', '12163', 'Basketball pump', 'Sports Equipment', '0.40', '8.99', '12.99', 11000, 1, NULL, 1),
(10504, 'BASKETBALL PUMP', '12164', 'Basketball pump', 'Sports Equipment', '0.40', '8.99', '12.99', 11000, 1, NULL, 1),
(10505, 'Pro Glide In-Ground Basketball Hoop System - 52\" Acrylic', '12165', 'In-ground basketball hoop system', 'Sports Equipment', '20.00', '299.99', '499.99', 11000, 1, NULL, 1),
(10506, 'Ratchet Lift In-Ground Basketball Hoop System - 44\" Polycarbonate', '12166', 'In-ground basketball hoop system', 'Sports Equipment', '20.00', '299.99', '499.99', 11000, 1, NULL, 1),
(10507, 'Exactaheight In-Ground Basketball Hoop System', '12167', 'In-ground basketball hoop system', 'Sports Equipment', '20.00', '299.99', '499.99', 11000, 1, NULL, 1),
(10508, 'U-Turn In-Ground Glass Basketball Hoop System', '12168', 'In-ground basketball hoop system', 'Sports Equipment', '20.00', '499.99', '699.99', 11000, 1, NULL, 1),
(10509, 'U-Turn In-Ground Basketball Hoop System - 54\" Acrylic', '12169', 'In-ground basketball hoop system', 'Sports Equipment', '18.00', '599.99', '799.99', 11000, 1, NULL, 1),
(10510, 'ARENA VIEW H-SERIES 72\" ADJUSTABLE HEIGHT IN-GROUND', '12170', 'In-ground basketball hoop system', 'Sports Equipment', '18.00', '599.99', '799.99', 11000, 1, NULL, 1),
(10511, 'Spalding 72\" Arena View Series In-Ground Basketball Hoop System', '12171', 'In-ground basketball hoop system', 'Sports Equipment', '18.00', '599.99', '799.99', 11000, 1, NULL, 1),
(10512, 'NBA Slam Jam Over-the-Door Mini Basketball Hoop', '12172', 'Youth basketball net', 'Sports Equipment', '10.00', '19.99', '34.99', 11000, 1, NULL, 1),
(10513, 'Youth One-On-One Portable Basketball Hoop System', '12173', 'Youth basketball net', 'Sports Equipment', '12.00', '32.99', '59.99', 11000, 1, NULL, 1),
(10514, 'NBA Breakaway 180 Over-the-Door Basketball Hoop', '12174', 'Youth basketball net', 'Sports Equipment', '12.00', '32.99', '59.99', 11000, 1, NULL, 1),
(10515, 'Smart Shot Training Aid', '12175', 'Training aid', 'Sports Equipment', '2.00', '16.99', '29.99', 11000, 1, NULL, 3),
(10516, 'Pop-Up Guard Training Aid', '12176', 'Training aid', 'Sports Equipment', '2.00', '16.99', '29.99', 11000, 1, NULL, 3),
(10517, 'Dribble Goggles Training Aid', '12177', 'Training aid', 'Sports Equipment', '2.00', '3.99', '7.99', 11000, 1, NULL, 3),
(10518, 'Shooting Spots Training Aid', '12178', 'Training aid', 'Sports Equipment', '2.00', '3.99', '7.99', 11000, 1, NULL, 3),
(10519, 'NBA Weighted Training Aid Basketball', '12179', 'Training aid', 'Sports Equipment', '2.00', '3.99', '7.99', 11000, 1, NULL, 3),
(10520, 'Universal Shot Trainer Training Aid', '12180', 'Training aid', 'Sports Equipment', '2.00', '3.99', '7.99', 11000, 1, NULL, 3),
(10521, 'Power Dribble Training Aid', '12181', 'Training aid', 'Sports Equipment', '2.50', '4.99', '9.99', 11000, 1, NULL, 3),
(10522, 'NBA Oversize Training Aid Basketball', '12182', 'Training aid', 'Sports Equipment', '2.50', '4.99', '9.99', 11000, 1, NULL, 3),
(10523, '9\" NEON CONES - 4PK', '12183', 'Training aid', 'Sports Equipment', '2.50', '2.99', '8.99', 11000, 1, NULL, 3),
(10524, 'Shot Arc Training Aid', '12184', 'Training aid', 'Sports Equipment', '2.50', '5.99', '7.99', 11000, 1, NULL, 3),
(10525, 'Shot Contester Training Aid', '12185', 'Training aid', 'Sports Equipment', '2.50', '5.99', '7.99', 11000, 1, NULL, 3),
(10526, 'Multi-Resistance Trainer Training Aid', '12186', 'Training aid', 'Sports Equipment', '2.50', '5.99', '7.99', 11000, 1, NULL, 3),
(10527, 'SPALDING MESH EQUIPMENT BAG', '12187', 'Equipment bag', 'Sports Equipment', '5.00', '24.99', '6.99', 11000, 1, NULL, 5),
(10528, 'SPALDING MESH SINGLE-BALL BAG', '12188', 'Equipment bag', 'Sports Equipment', '5.00', '24.99', '39.99', 11000, 1, NULL, 5),
(10529, 'Universal Backboard Mounting Bracket', '12189', 'Training aid', 'Sports Equipment', '10.00', '9.99', '13.99', 11000, 1, NULL, 1),
(10530, 'U-Turn Basketball Hoop Lift System', '12190', 'Training aid', 'Sports Equipment', '12.00', '8.99', '14.99', 11000, 1, NULL, 1),
(10531, 'BASKETBALL TUNE-UP KIT', '12191', 'Training aid', 'Sports Equipment', '0.50', '7.99', '12.99', 11000, 1, NULL, 1),
(10532, 'NBA Slam Jam Over-the-Door Mini Basketball Hoop', '12192', 'Training aid', 'Sports Equipment', '4.00', '3.99', '8.99', 11000, 1, NULL, 1),
(10533, 'SPALDING BASKETBALL DUFFLE BAG', '12193', 'Equipment bag', 'Sports Equipment', '5.00', '44.99', '64.99', 11000, 1, NULL, 4),
(10534, 'WHISTLES', '12194', 'Training aid', 'Sports Equipment', '0.20', '3.99', '5.99', 11000, 1, NULL, 10),
(10535, 'Basketball Court Marking Kit', '12195', 'Training aid', 'Sports Equipment', '0.20', '4.99', '6.99', 11000, 1, NULL, 10),
(10536, '9\" NEON CONES - 4PK', '12196', 'Training aid', 'Sports Equipment', '0.50', '2.99', '7.99', 11000, 1, NULL, 10),
(10537, 'Glow in the Dark Basketball Court Marking Kit', '12197', 'Training aid', 'Sports Equipment', '0.50', '4.99', '8.99', 11000, 1, NULL, 10),
(10538, 'HEAVY DUTY FOAM PAD', '12198', 'Training aid', 'Sports Equipment', '8.00', '12.99', '17.99', 11000, 1, NULL, 2),
(10539, 'NBA STANDARD POLE PAD', '12199', 'Training aid', 'Sports Equipment', '8.00', '12.99', '17.99', 11000, 1, NULL, 2),
(10540, 'Arena Foam Backboard Pad', '12200', 'Training aid', 'Sports Equipment', '8.00', '12.99', '17.99', 11000, 1, NULL, 2),
(10541, 'SPALDING BRIEFCASE', '12201', 'Training aid', 'Sports Equipment', '8.00', '22.99', '27.99', 11000, 1, NULL, 4),
(10542, 'SPALDING ALPHA FOOTBALL BAG', '12202', 'Equipment bag', 'Sports Equipment', '6.00', '29.99', '56.99', 11000, 1, NULL, 4),
(10543, 'Back Atcha Ball Return Training Aid', '12203', 'Training aid', 'Sports Equipment', '7.00', '22.99', '29.99', 11000, 1, NULL, 10),
(10544, 'ROUND EXTENSION ARM', '12204', 'Training aid', 'Sports Equipment', '7.00', '8.99', '9.99', 11000, 1, NULL, 3),
(10545, 'EXACTA-HEIGHT LIFT SYSTEM', '12205', 'Training aid', 'Sports Equipment', '7.00', '23.99', '30.99', 11000, 1, NULL, 3),
(10546, 'Acrylic Backboard and Rim Combo Basketball Hoop', '12206', 'Backboard and Rim', 'Sports Equipment', '12.00', '189.99', '229.99', 11000, 1, NULL, 1),
(10547, 'Acrylic Backboard and Rim Combo', '12207', 'Backboard and Rim', 'Sports Equipment', '12.00', '179.99', '229.99', 11000, 1, NULL, 1),
(10548, 'Polycarbonate Backboard and Rim Combo', '12208', 'Backboard and Rim', 'Sports Equipment', '12.00', '229.99', '299.99', 11000, 1, NULL, 1),
(10549, 'Fan Backboard and Rim Combo Basketball Hoop - 44\" Eco-Composite', '12209', 'Backboard and Rim', 'Sports Equipment', '12.00', '234.99', '349.99', 11000, 1, NULL, 1),
(10550, 'MVA200 Official Olympic Indoor Volleyball', '54707', 'The Official Volleyball for the 2008 Beijing Olympic Games! The eight panel design allows for more hand contact on the ball for greater accuracy and better feel. The dimples on the ball create a truer flight pattern for your creative serves and spikes.', 'Sports Equipment', '0.60', '14.99', '94.99', 99999, 1, 'ONE OF THE BEST BALLS!', 10),
(10551, 'Extreme Pro Volleyball - Blue/Orange Swirl', '51487', 'Aspire to achieve with practice  determination  purpose - and the Extreme Pro Wave Volleyball. With its superior construction and durability  this volleyball assists the athlete and team to realize his/her goals.', 'Sports Equipment', '0.60', '5.99', '15.99', 11000, 1, 'NICE SOFT BALL', 10),
(10552, 'Canada Official Size Replica Volleyball', '79030', 'Replica of the Official Volleyball Canada Game Ball.', 'Sports Equipment', '0.60', '6.25', '24.99', 99999, 1, NULL, 10),
(10553, 'SofTec Checks Volleyball', '48596', 'The Tachikara SofTec volleyballs feature a soft foam-back composite for virtually no sting during play. The fun patterns and fun colors make this volleyball fun for all.', 'Sports Equipment', '0.60', '3.74', '14.97', 11000, 1, NULL, 10),
(10554, 'AVP Special Edition Volleyball', '62788', 'A replica of the AVP Official Game Ball  the Wilson AVP Special Edition is a true original. Aztec colours and geometric shapes inspire its unique design', 'Sports Equipment', '0.60', '7.50', '29.99', 99999, 1, NULL, 10),
(10555, 'SV5WSC Sensi-Tec Composite Volleyball', '34777', 'Sensi micro-fibre composite leather uses a resin-fused fibre cover for a truer touch. Tachikara’s patented Loose Bladder Construction (LBC) provides control during play.', 'Sports Equipment', '0.60', '12.50', '49.99', 99999, 1, 'BEST VOLLEYBALL', 10),
(10556, 'Under Armour Manhattan Beach Volleyball', '43456', 'Play to win with the Under Armour  Manhattan Beach Volleyball. Constructed with a textured PU cover with a soft feel and wet grip properties', 'Sports Equipment', '0.60', '3.72', '14.88', 11000, 1, NULL, 10),
(10557, 'Impact Volleyball - White/Blue', '62104', 'Keep the point alive with the perfect dig. Place the ball just so for a finishing hit. With The Impact  a composite leather cover offers a deluxe feel to help you make all the winning plays. Choose to be an impact player.', 'Sports Equipment', '0.60', '8.25', '32.99', 99999, 1, 'LIKE A ROCK  PAINFUL', 10),
(10558, 'Soft Play Technology Official Size Volleyball', '74817', 'The Wilson Soft Play Technology Volleyball has a butyl rubber bladder and a sponged-backed PVC synthetic leather cover. It has been machined sewed using an 18-panel construction  which lends durability to this official size volleyball.', 'Sports Equipment', '0.60', '5.00', '19.99', 99999, 1, 'GREAT CASUAL BALL', 10),
(10559, 'Nike Essential Volleyball Knee Pad - Black', '14091', 'The Nike Essential Volleyball Knee Pad is meant for the avid volleyball player who needs maximum protection for outstanding gameplay.', 'Sports Equipment', '1.00', '6.25', '25.00', 44444, 1, 'GREAT PAIR OF KNEE PADS', 25),
(10560, 'Volleyball Match Knee Pads', '19371', 'The next time you go diving for an incredible save  make sure you\'re protected with these Diadora Volleyball Match Knee pads.', 'Sports Equipment', '1.00', '5.00', '19.99', 10000, 1, 'MELTED AFTER MINOR USAGE', 25),
(10561, 'MZ-T10 Team Plus Knee Pad - Black', '32818', 'The new Mizuno T10 Team Plus knee pad features a new slimmer design with enhanced foam to protect you where you need it.', 'Sports Equipment', '1.00', '6.25', '24.99', 11000, 1, NULL, 25),
(10562, 'Nike Essential Graphic Volleyball Knee Pads 2.0 - Black/Volt', '93310', 'Look stylish and keep protected when on the volleyball court with the Nike Essential Graphic Knee Pad 2.0. Made with shock absorbing foam', 'Sports Equipment', '1.00', '5.49', '21.97', 44444, 1, NULL, 25),
(10563, 'Right DXS2 Ankle Brace', '14778', 'Support your ankle without limiting your ability to move with the Mizuno Right DXS2 Ankle Brace. Its DF Cut keeps you mobile  and the brace comes with three different belts  so you can choose the one that best suits your needs.', 'Sports Equipment', '1.00', '5.97', '23.88', 99999, 1, NULL, 30),
(10564, 'LR6 Highlighter Knee Pad - Pink/Black', '70074', 'Gear up for the game in the Mizuno LR6 Highlighter Knee pad. This colorful protective knee pad will keep you cool with intercool ventilation.', 'Sports Equipment', '1.00', '5.99', '23.97', 99999, 1, 'I WANT TO BE ON MY KNEES ALL THE TIME NOW', 25),
(10565, 'VS-1 Knee Pad - Black', '96547', 'The Mizuno VS-1 knee pad is Dynamic Function Cut for superior fit without bulk. The padding provides excellent Patella  Lateral and Medial protection.', 'Sports Equipment', '1.00', '3.72', '14.88', 99999, 1, NULL, 25),
(10566, 'MZ-T10 Team Plus Knee Pad - White', '44795', 'The new Mizuno T10 Team Plus knee pad features a new slimmer design with enhanced foam to protect you where you need it.', 'Sports Equipment', '1.00', '6.25', '24.99', 99999, 1, NULL, 25),
(10567, 'ASICS Women\'s Gel Flashpoint 2 Indoor Court Shoes - Navy/Blue/Pink', '85805', 'The ASICS Gel-Flashpoint 2: WANTED: By players who want to standout on the court - with the game to back it up.', 'Sports Equipment', '2.00', '17.97', '71.88', 10000, 1, NULL, 16),
(10568, 'Women\'s Wave Lightning Z4 Indoor Court Shoes - Pink/Silver', '38901', 'The lightweight high-performance Mizuno Wave Lightning Z4 is technically unrivalled for performance on court. The dynamic-cushioned  360 &#176 no-sew design combines the perfect fit with a balanced and stable feel.', 'Sports Equipment', '2.00', '33.74', '134.97', 10000, 1, NULL, 16),
(10569, 'Men\'s Wave Tornado X Indoor Court Shoes - Blue/Black', '20503', 'The Men’s Wave Tornado X offered in a classic low-cut. The Infinity Wave Plate in the shoe’s heel offers premium cushioning and shock attenuation for the strenuous jumping and landing', 'Sports Equipment', '2.00', '27.47', '109.88', 10000, 1, NULL, 16),
(10570, 'Women\'s Wave Lightning Z3 Indoor Court Shoes - Black/Yellow', '72449', 'The Mizuno Wave Lightning Z3 Men’s indoor court shoe has been crafted with a no-sew upper construction that provides a high level of fit and comfort.', 'Sports Equipment', '2.00', '22.49', '89.97', 10000, 1, 'GREAT FIT AND FLOOR GRIP', 16),
(10571, 'Men\'s Wave Tornado X Indoor Court Shoes - Orange/Black', '82944', 'Move fastest  jump highest  land smoothest. The latest evolution of the Wave Tornado combines explosive performance with advanced power transfer for a higher jump and a smoother landing.', 'Sports Equipment', '2.00', '29.97', '119.88', 10000, 1, 'EXCELLENT', 16),
(10572, 'Women\'s Wave Tornado X Indoor Court Shoes - Black/Purple', '11819', 'The Women’s Wave Tornado X offered in a classic low-cut. The Infinity Wave Plate in the shoe’s heel offers premium cushioning and shock attenuation for the strenuous jumping and landing', 'Sports Equipment', '2.00', '24.97', '99.88', 10000, 1, 'QUALITY HIGH-END COURT SHOES', 16),
(10573, 'Nike Ball Pump', '41030', 'With the Nike Ball Pump  it’s easy to keep your basketball optimally inflated for better performance during practice  training and games. The compact dual-action pump is highly efficient and small enough to fit into your gear bag.', 'Sports Equipment', '1.00', '3.75', '15.00', 44444, 1, 'I DON\'T KNOW WHERE TO INSERT IT', 40),
(10574, 'Runbird Volleyball Crew Socks - Black', '14355', 'The Mizuno Runbird crew socks are ideal for volleyball players. They have a padded heel and forefoot  are anatomical with their fit and have a gripper top to keep your socks in place', 'Sports Equipment', '0.10', '5.00', '19.99', 10000, 1, NULL, 25),
(10575, 'Team Elite Crossover Backpack - Black', '43913', 'The Mizuno Team Elite Crossover Backpack is quite versatile and can easily transition from sport-to-sport. Side bat sleeves can be used to store two bats or be used as a water bottle pouch.', 'Sports Equipment', '5.00', '18.75', '74.99', 10000, 1, NULL, 6),
(10576, 'Under Armour Dual Action Pump with Guage', '46423', 'The Under Armour Dual action pump is twice as efficient as tradtional pumps and comes with a ball specific gauge for easy reference in inflating multiple sports balls. Perfect for a coach  team or the avid sports player.', 'Sports Equipment', '1.00', '7.50', '29.99', 99999, 1, NULL, 20),
(10577, 'Spalding Dual Action Pump with Pressure Gauge', '37585', 'Get your ball game ready Spalding\'s dual-action pump with pressure gauge. Avoid the hassle of over-inflating or under-inflating your ball and measure your balls air level immediately after you\'ve pumped.', 'Sports Equipment', '1.00', '5.00', '19.99', 11000, 1, NULL, 24),
(10578, 'Runbird Volleyball Crew Socks - White', '70895', 'The Mizuno Runbird crew socks are ideal for volleyball players. They have a padded heel and forefoot  are anatomical with their fit and have a gripper top to keep your socks in place.', 'Sports Equipment', '0.10', '5.00', '19.99', 10000, 1, NULL, 50),
(10579, 'Volleyball Practice Platforms - Black', '69602', 'The innovative new introduction to the volleyball market  these Mizuno padded platforms are intended to be worn on the forearms to either protect against the impact of the ball or the floor', 'Sports Equipment', '1.00', '6.25', '24.99', 10000, 1, NULL, 35),
(10580, 'Nike Hyperspeed Ball Pump', '97747', 'The Nike Hyperspeed ball pump is a dual-action pump for more efficient air compression. This compact ball pump includes one needle and an extension hose and is small enough to carry with you to practice or the game.', 'Sports Equipment', '1.00', '4.50', '18.00', 44444, 1, NULL, 15),
(10581, 'Inflating Needles - 3 Pack', '34057', 'The Diadora Inflating Needles are perfect for re-inflating any type of sports ball. The needles are extra durable and easy to handle.', 'Sports Equipment', '0.10', '0.75', '2.99', 44444, 1, NULL, 75),
(10582, 'Nike Essential Ball Pump - Black/White', '52720', 'The Nike Essential ball pump includes one needle and is small enough to carry with you to practice or the game. The compact design should make it easier to bring along to practice or any training session you do.', 'Sports Equipment', '1.00', '3.75', '15.00', 44444, 1, NULL, 20),
(10583, 'Nike Essential Ball Pump - Volt/Black', '44232', 'The Nike Essential ball pump includes one needle and is small enough to carry with you to practice or the game. The compact design should make it easier to bring along to practice or any training session you do.', 'Sports Equipment', '1.00', '3.75', '15.00', 44444, 1, NULL, 20),
(10584, 'Double Action Universal Pump', '43755', 'The Rucanor Double Action Universal Pump pumps air when pushed and pulled and is quick and effective. The pump is suitable for all types of balls  fits all types of valves and includes a 6 inch Nylon airhose with a ring and chrome-plated needle.', 'Sports Equipment', '1.00', '3.00', '11.99', 44444, 1, NULL, 14),
(10585, 'Nike Elite Ball Pump - University Red', '42968', 'The Nike Elite ball pump is a dual-action pump for more efficient air compression. This compact ball pump includes one needle and an extension hose and is small enough to carry with you to practice or the game.', 'Sports Equipment', '1.00', '2.74', '10.97', 44444, 1, NULL, 18),
(10586, 'Bolt Volleyball Backpack - Black', '60230', 'Haul all your gear in style to and from practices and matches alike with the Mizuno Bolt Volleyball Backpack - Black.', 'Sports Equipment', '5.00', '12.49', '49.97', 10000, 1, NULL, 8),
(10587, 'Sidelines Sports Inflating Needles - 3 Pack', '59930', 'The Sidelines Sports Inflating Needles comes with 3 American-style needles to re-inflate any type of sports ball. Steel composition makes these needles extra durable and easy to handle.', 'Sports Equipment', '0.10', '0.49', '1.97', 10000, 1, NULL, 35),
(10588, 'Mini Ball Pump', '72420', 'Let the game go on with the Diadora Mini Ball Pump  a compact and lightweight multipurpose pump. With its thumb lock  ball needle  and extension hose  it’s super user-friendly.', 'Sports Equipment', '1.00', '0.97', '3.88', 10000, 1, 'TERRIFIC FOR REFILLING BALLS AT HOME', 40),
(10589, 'Sportcraft Stadium Seat - Black', '91572', 'Have a comfortable seat at every game with this Sportcraft Stadium Seat  which is easy to store and transport thanks to foldable structure and convenient carry strap', 'Sports Equipment', '2.50', '4.97', '19.88', 10000, 1, 'SO MUCH CUSHIER THAN THE BENCH!', 10),
(10590, 'Fox 40 Pro Coaching Board - Volleyball', '96588', 'Fox 40 Pro Coaching Boards feature a superior write-on/wipe-off system  durable clip and double-sided playing surface. Full field/court on one side  close-up of half field/half court on other side. Realistic  full-colour. Includes dry erase marker.', 'Sports Equipment', '0.60', '2.22', '8.88', 99999, 1, NULL, 12),
(10591, 'Team Bag', '78034', '300 denier polyester with PVC backing combined with 100% Polyester mesh. Large main compartment. Padded straps and front zipper pocket.', 'Sports Equipment', '5.00', '3.72', '14.88', 77777, 1, NULL, 22),
(10592, 'Nike Ball Pump', '17895', 'This dual action pump from Nike delivers air on both the push stroke and the pull stroke for more efficient compression. The pump comes with an extension hose and three needles.', 'Sports Equipment', '1.00', '0.47', '1.88', 44444, 1, NULL, 28),
(10593, 'Baseline Popup 3 Metre Badminton Net Set', '11411', 'When you’re in the mood for a game of badminton  you can have the Diadora Baseline Popup 3 Metre Badminton Net Set assembled in minutes. The freestanding net is made from high quality nylon to last through many backyard matches.', 'Sports Equipment', '0.50', '14.99', '59.97', 44444, 1, NULL, 12),
(10594, 'Park & Sun VolleyBall Set - Sport Series', '28886', 'Park & Sun Sports sets the standard for upper end net systems. The quality and innovation of these net systems makes them favourites among tournament directors and competitive players.', 'Sports Equipment', '5.00', '22.74', '90.97', 99999, 1, NULL, 25),
(10595, 'Park & Sun Spiker Volleyball Set', '80219', 'Park & Sun Sports sets the standard for higher end net systems. The quality and innovation makes them the favourite among tournament directors and competitive players.', 'Sports Equipment', '5.00', '37.50', '149.99', 99999, 1, NULL, 4),
(10596, 'Foam All Purpose Kneepads - HD220', '85429', 'Foam All Purpose Kneepads', 'Sports Equipment', '1.00', '1.49', '5.97', 99999, 1, 'Kneel pain free...great kneepads', 25),
(10597, 'BIKSP.NY Portable Volleyball Cart - Navy', '74520', 'Our most popular ball cart designed to provide you extra height  a sturdy galvanized steel frame  large caster wheels and a durable black nylon cover. This cart has the largest capacity of all our ball carts', 'Sports Equipment', '20.00', '48.70', '194.78', 99999, 1, NULL, 3),
(10598, 'CSI 61122 30 ft. Standard Recreational Volleyball Net with 38 ft. Top Poly Braid Cable', '86309', 'This CSI Cannon Sports Standard Recreational Volleyball Net is the perfect net for volleyball practice and volleyball standards that use a crank wheel to tighten the volleyball net top string.', 'Sports Equipment', '5.00', '23.80', '95.18', 99999, 1, NULL, 6),
(10599, 'Sport TSCOLLAPSANT Collapsible Antennae', '17465', 'White pocket is 2\" wide with Cloth Tie straps that secure system to the net. The fiberglass red and white antenna slips easily into the pocket for correct positioning on the net.', 'Sports Equipment', '1.00', '30.01', '120.05', 99999, 1, NULL, 5),
(10600, 'REC-NET Recreational Volleyball Net', '23414', 'Regulation volleyball net for all levels of recreational play with a top rope cable and tie-cords. Made for backyard play and barbecues  the REC-NET can be easily hung from a post or the nearest tree.. Dimenison: 32\' W x 3\' H.- SKU: TCKRA240', 'Sports Equipment', '5.00', '27.82', '111.26', 99999, 1, NULL, 12),
(10601, 'Sport TSRECNET Recreation Volleyball Net', '80115', 'Recreational volleyball net constructed of 1.5 mm thread polyethylene netting  2\" vinyl top binding with PE rope. Packaged for retail. Item Length: 12 Item Height: 9 Item Width: 12- SKU: TNDS193', 'Sports Equipment', '5.00', '19.27', '77.08', 99999, 1, NULL, 14),
(10602, 'ANCHOR-W Net Installation Hardware for Wood Walls', '39850', 'Installation hardware for your WB-NET Wallyball Net System. Intended for wood walls. Price includes set of four each for complete net installation.- SKU: TCKRA002', 'Sports Equipment', '1.00', '9.95', '39.79', 99999, 1, NULL, 30),
(10603, 'Home Court 17ABUS Blue 1-inch Adjustable Web Courtlines', '83825', 'Four section blue 30 X 60-foot adjustable  1-inch wide heavy weight UV treated polypropylene webbing court boundary system. Can even adjust down to 8-meter court size.', 'Sports Equipment', '5.00', '19.01', '76.04', 99999, 1, NULL, 10),
(10604, 'Olympia Sports NT036P 32 ft. x 3 ft. Volleyball Net - 2.2mm', '66229', '2.2mm polyethylene netting. 4\" vinyl square mesh  2\" white headband with a nylon rope cable.- SKU: OSNT036P', 'Sports Equipment', '5.00', '19.73', '78.91', 99999, 1, NULL, 6),
(10605, 'Tandem Sport Volleyball Passing Sleeve  Black  Small/Medium', '75370', 'Hit the mark with the Volleyball Passing Sleeves from Tandem Sport. Target area on each sleeve provides proper ball contact area for perfect passing.', 'Sports Equipment', '1.00', '12.86', '51.44', 99999, 1, NULL, 12),
(10606, 'Gared Sports ODVBNET 32 ft. x 3 ft. 2 MM Poly Outdoor Volleyball Net', '85487', 'Designed for use with ODVB standards. Constructed of 2mm twisted polyethylene for maximum strength. Net is 32\' long x 3\' wide.', 'Sports Equipment', '1.00', '34.88', '139.52', 99999, 1, NULL, 12),
(10607, 'CV-NET Competition Volleyball Net', '14970', 'A mid-range competition volleyball net that can work inside or out. PVC coated top and bottom steel cables add durability. 32\' W x 3\' H. Length: 39. Height: 6. Width: 6- SKU: TCKRA244', 'Sports Equipment', '5.00', '47.70', '190.81', 99999, 1, NULL, 8),
(10608, 'Spalding 40-20114 Classic Volleyball Set', '43383', 'Features. 20\" X 2\". Official size vinyl ball with air pump and needle. Pre-assembled double guide rope  tension clips and ground stakes. Octagon telescoping PVC poles. Pole heights-5\"1  6\" & 7\".', 'Sports Equipment', '5.00', '18.62', '74.49', 11000, 1, NULL, 8),
(10609, 'Gared Sports 7700 Mongoose LT Volleyball System', '12650', 'Gared\'s Mongoose LT Wireless Volleyball System is the latest addition to the Mongoose family of wireless volleyball systems. The Mongoose LT is a great economical alternative to the original Mongoose and is perfect for home or recreational use.', 'Sports Equipment', '10.00', '83.80', '335.21', 11000, 1, NULL, 6),
(10610, 'Water Sports ItzaVolleyball Beach and Pool Volleyball (colors vary)', '71578', 'Floating a serve or diving to save the game  the ItzaVolleyball is especially designed for rugged use on the volleyball court  in the backyard or beach This exceptional volleyball is designed with a butyl bladder for maximum air retention', 'Sports Equipment', '5.00', '9.56', '38.22', 11000, 1, NULL, 6),
(10611, 'Franklin Sports 13059 Steel Volleyball Post & Net System', '58572', 'Features. Steel volleyball post & net system.. Includes 1.75 in. Diameter pole with silver powder coating.. Size - 32 ft. X 32 x 4 in. Net.. 10 in. Steel stakes.. Molded tension bar adjustment with guy ropes', 'Sports Equipment', '25.00', '45.95', '183.78', 11000, 1, NULL, 8),
(10612, 'Jaypro Ts612 Volleyball Training - The Spiker', '18875', 'The Spiker is used to develop and refine the skills of spiking and serving. It has proven valuable in teaching beginning players proper arm swing extension approach and jump techniques', 'Sports Equipment', '25.00', '101.43', '405.73', 11000, 1, 'Cheaply made', 4),
(10613, 'Jt Outkast Rtp Kit', '83474', 'The JT Outkast is a great starter marker or upgrade from a pump-action set. This lightweight semi-automatic paintball marker features an integrated foregrip for control and double finger trigger action for fast firing.', 'Sports Equipment', '2.00', '19.55', '78.21', 55555, 1, NULL, 4),
(10614, 'JT 90 Gram Prefilled Paintball CO2 Tank  2pk', '11688', 'With the JT 90 Gram Prefilled Paintball CO2 Tank  you can begin shooting immediately  as it comes ready to use.', 'Sports Equipment', '2.00', '2.00', '8.00', 55555, 1, NULL, 2),
(10615, 'WPN Weapons Grade .68 Caliber Paintballs 2000 Count', '54734', 'Whether you have a spool valve design or blowback marker  WEAPONSGRADE paint is the perfect paint for recreational use!', 'Sports Equipment', '5.00', '8.75', '35.00', 55555, 1, NULL, 6),
(10616, 'WPN Killabeez Practice Grade .68 Caliber Paintballs 2000 Count', '49672', 'KILLABEEZ delivers accuracy and quality at an incredible value. No oil and low starch content means easy cleanup. Available in bright orange  yellow or select two-tone shell colors and a variety of fill colors.', 'Sports Equipment', '5.00', '12.00', '48.00', 55555, 1, NULL, 5),
(10617, 'Conqu3st Semi Paintball Marker', '46348', 'Introducing the D3fy Conqu3st paintball marker. \"This is where your journey begins.\" The Conqu3st paintball marker has been developed for the entry level player.', 'Sports Equipment', '1.00', '17.35', '69.39', 55555, 1, NULL, 4),
(10618, 'Cronus .68 CAL Paintball Gun Kit - Ready Play Blood Package', '46052', 'This Cronus Tactical .68 Caliber Play Now Package is an all-inclusive ready to play kit that will allow you to hit the paintball field with everything you need to play paintball.', 'Sports Equipment', '5.00', '39.99', '159.95', 55555, 1, NULL, 5),
(10619, 'Cronus Powerpack/Raptor Mask/90g CO2/Loader (81981)', '99859', 'TIPPMAN Cronus Powerpack/Raptor Mask/90g CO2/Loader (81981)', 'Sports Equipment', '2.00', '29.99', '119.95', 55555, 1, NULL, 5),
(10620, 'Gryphon Fx Value Pack - W/ JT Raptor Goggle', '93707', 'Tippmann Gryphon FX Value Pack Tippmann Gryphon Fx Value Pack', 'Sports Equipment', '2.00', '24.75', '99.00', 55555, 1, NULL, 5),
(10621, 'D3fy 12 oz CO2 Tank', '61657', 'Tank has ASTM approved valve for safety.', 'Sports Equipment', '2.00', '4.89', '19.56', 55555, 1, NULL, 4),
(10622, 'A-5 Paintball Marker with Response Trigger', '68456', 'Expand your arsenal with the widely popular Tippmann A-5 Paintball Marker. It features a durable aluminum body  inline bolt system and Tippmann\'s Response Trigger that allows it to fire full-auto without batteries.', 'Sports Equipment', '2.00', '44.75', '179.00', 55555, 1, NULL, 8),
(10623, 'Skelleton Protective Safety Skull Mask With Wire Mesh Goggles  Black', '86649', 'ALEKO mask combines protection and exceptional design. Metal mesh goggles will never fog up during the game  giving you optimal visibility and protection.', 'Sports Equipment', '5.00', '5.00', '19.99', 55555, 1, NULL, 6),
(10624, 'Ninja 35CI CU / 3000PSI High Pressure Air HPA N2 Steel Paintball Tank', '75929', 'NINJA REG MOUNTED ON A 35 /3000 PSI ALUMINUM BOTTLE. MADE IN THE USA!!!! 5 year hydro. Ninja 35CI CU / 3000PSI High Pressure Air HPA N2 Steel Paintball Tank', 'Sports Equipment', '2.00', '14.99', '59.95', 55555, 1, NULL, 5),
(10625, 'Anti-Fog Paintball Mask with Double-Elastic Strap  Black', '81802', 'The ALEKO Army Military Anti-Fog Paintball Mask combines maximum protection and exceptional design. The anti-fog lens will give you optimal visibility and protection and is easy to wash and can be replaced..', 'Sports Equipment', '2.00', '4.03', '16.10', 55555, 1, NULL, 5),
(10626, 'Skull Skeleton Airsoft Mask with Wire Mesh Goggles  Black', '20428', 'The ALEKO airsoft mask combines protection and exceptional design. Metal mesh goggles will never fog up during the game  giving you optimal visibility and protection.', 'Sports Equipment', '2.00', '3.67', '14.69', 55555, 1, NULL, 5),
(10627, 'Paintball Heavy Duty Thick Coil Remote Hose Line with Quick Disconnect  Black', '46229', 'Move the bulk weight of the tank off your marker and into a pouch with ALEKO coil remote hose. Compatible with most of CO2  Compressed Air  HPA and Nitrogen cylinders.', 'Sports Equipment', '2.00', '5.50', '21.99', 88888, 1, NULL, 5),
(10628, 'Airsoft Paintball Dummy Gas Mask with Fan', '35575', '100% Brand new with high quality Airsoft Paintball Dummy Gas Mask with Fan for Cosplay Protection Halloween Evil Antivirus Skull', 'Sports Equipment', '2.00', '5.89', '23.55', 88888, 1, NULL, 5),
(10629, 'JT Paintball Chest Protector  Black', '58909', 'The JT paintball chest protector offers you full front protection and ensures a full range of motion for easy maneuverability. This black chest protector features a moisture-wicking material to provide a continually dry surface.', 'Sports Equipment', '2.00', '5.00', '19.99', 88888, 1, NULL, 6),
(10630, '4+1 Harness', '21334', '4+1 Paintball harness black One size fits all', 'Sports Equipment', '5.00', '6.24', '24.95', 88888, 1, NULL, 12),
(10631, 'PBM225BK Army Military Anti-Fog Paintball Mask with Double Elastic Strap  Black', '35802', 'The ALEKO Army Military Anti-Fog Paintball Mask combines maximum protection and exceptional design. The anti-fog lens will give you optimal visibility and protection and is easy to wash and can be replaced.', 'Sports Equipment', '2.00', '5.75', '22.99', 88888, 1, NULL, 8),
(10632, 'Pro Padded Chest Protector Combo Package - Paintball  Airsoft  Etc.~Large / X-Large Gloves', '49060', 'Take the PAIN out of paintball! Get all the gear you need to stay protected and keep playing the game. Our gear is meant to keep up with the rough player that doesn \'t just go out for a game or two  but for the whole day.', 'Sports Equipment', '15.00', '9.99', '39.95', 88888, 1, NULL, 10),
(10633, 'PBRHSF09 Paintball Regular .68 Caliber Hopper with Speed Feed Paintball Loader', '45601', 'This is ALEKO brand new paintball speed feed loader. Extremely durable  it can withstand punches  crashes  bangs and slams while continuing to load your machine.', 'Sports Equipment', '2.00', '3.50', '13.99', 88888, 1, NULL, 5),
(10634, 'PBFRS36 Paintball Accessories Paintball Delux Dual Valve Co2 Tank Bottle Fill Refill', '91223', 'This is a ALEKO dual valve Co2 fill station for filling paintball cylinders. It is faster and much easier on your hands than the single valve fill stations.', 'Sports Equipment', '2.00', '10.00', '39.99', 88888, 1, NULL, 3),
(10635, 'Paintball Chest Protector - Black', '96668', 'The Tippmann Chest Protector is fully adjustable to fit most paintball players and will protect you from close range shots. Tippmann Paintball Chest Protector - Black', 'Sports Equipment', '5.00', '4.98', '19.93', 88888, 1, NULL, 2),
(10636, 'TACTICAL VEST MED-2XL BLK', '60664', 'Tactical Vest  Nylon  Black  Size Medium- 2XL  Fully Adjustable  PALS Webbing  Pistol Mag Pouches  Rifle Mag Pouches  Includes Pistol Belt with Additional Accessory PouchesTACTICAL VEST MED-2XL BLK', 'Sports Equipment', '5.00', '11.25', '44.99', 88888, 1, NULL, 4),
(10637, 'JT 90 Gram Paintball Tank Adaptor', '96564', 'The JT 90-Gram Tank Adaptor is used to adapt a pre-filled  single-use CO2 tank to a paintball marker. The paintball marker adapter features a sturdy and dependable body for long-lasting use.', 'Sports Equipment', '2.00', '0.87', '3.48', 88888, 1, NULL, 6),
(10638, 'JT 90g adaptor', '73076', 'JT 90g adaptor', 'Sports Equipment', '2.00', '1.99', '7.95', 88888, 1, NULL, 6),
(10639, 'Outgeek Ghost Skull Balaclavas Ski Mask Full Face Airsoft Paintball Cosplay Mask for Men', '83012', 'Great for costume party  snowboard  ski  airsoft  hunting  war game and military use.', 'Sports Equipment', '0.10', '3.00', '11.98', 88888, 1, NULL, 12),
(10640, 'Crosman 12 gram Powerlet CC15PB 15 Count CO2', '47542', 'Crosman 12gr CO2 Powerlets is compatible with any airgun  airsoft  paintball  non-threaded bike tire inflator or other device which requires a 12gr CO2 cartridge.', 'Sports Equipment', '0.50', '1.74', '6.97', 88888, 1, NULL, 5),
(10641, 'Adjustable Tactical Military and Hunting Vest By Modern Warrior (Black)', '49928', 'This black premium tactical vest by Modern Warrior is the perfect outdoors or hunting vest. Numerous pocket gives you great storage capacity. Adjustable torso allows for size to fit all comfortably.', 'Sports Equipment', '5.00', '8.09', '32.34', 88888, 1, NULL, 6),
(10642, 'Gen X Global XVSN Paintball Mask Bl', '32486', 'This XVSN Paintball Mask features a low profile design and a quick-release lens system. The single pane lens is treated for Anti-Fog and Anti-Scratch resistance. Each mask comes with a Removeable visor  and exceeds ASTM standards for paintball masks.', 'Sports Equipment', '2.50', '4.34', '17.35', 55555, 1, NULL, 12),
(10643, 'PBCPV53-UNB Paintball Airsoft Chest Protector Tactical Vest Body Armor  Black', '71372', 'ALEKO paintball chest protector is a full front and back protector for paintball  airsoft  and other outdoor sports. Protect yourself from injury and keep the game going with this high quality tactical vest', 'Sports Equipment', '5.00', '4.25', '16.99', 55555, 1, NULL, 4),
(10644, 'PBM219BK Air Soft Protective Mask with Full Mesh Wire  Full Face  Black', '16490', 'This steel mesh full-face mask is your best  most affordable and durable choice of mask . It is able to withstand the strongest air-soft hits. This mesh mask is specifically created to be very lightweight  to reduce fatigue and increase comfort', 'Sports Equipment', '2.50', '6.00', '23.99', 55555, 1, NULL, 8),
(10645, 'JT 200ct Paintball Hopper', '37857', 'Enjoy your time playing paintball with family and friends while using your JT Paintball Hopper  200-count. With the ability to store a large capacity of paintballs and efficiently load them', 'Sports Equipment', '2.00', '0.99', '3.95', 55555, 1, NULL, 8),
(10646, 'PMI Pure Energy 20oz CO2 Aluminum Paintball Tank', '85760', 'pmi-20oz-tank', 'Sports Equipment', '2.00', '5.74', '22.95', 55555, 1, NULL, 6),
(10647, 'Maddog Padded Paintball & Airsoft Chest Protector~Black', '14408', 'Maddog has brought you a new line of padded chest protectors! All the fun without the pain of paintball or airsoft.', 'Sports Equipment', '5.00', '5.49', '21.95', 55555, 1, NULL, 14),
(10648, 'Filfeel Combat Vest Nylon Tactical Children Airsoft Hunting Body Armor Vest', '57370', 'This vest is constructed by high quality nylon material which is wear resistant and durable to wear. Multiple pockets enables you to load magazines  maps or other accessories.', 'Sports Equipment', '5.00', '2.80', '11.20', 55555, 1, NULL, 8),
(10649, 'Ninja Aluminum HPA Tank - 48/3000', '75164', 'Ninja Aluminum HPA Tank - 48/3000', 'Sports Equipment', '2.00', '14.99', '59.95', 55555, 1, NULL, 4),
(10650, 'JT ER2 Pump Pistol RTS Kit', '61893', 'Embrace victory every time you step on the paintball field with the help of a JT ER2 Pump Pistol RTS Shooting Equipment Kit. This set comes complete with pump marker  JT Guardian Goggles  30 paintballs  two 12g CO2 cartridges', 'Sports Equipment', '2.00', '7.49', '29.97', 55555, 1, NULL, 6),
(10651, 'Jt Er4 Rtp Kit', '40261', 'JT ER4 RTP Kit Jt Er4 Rtp Kit', 'Sports Equipment', '2.00', '14.69', '58.74', 55555, 1, NULL, 4),
(10652, 'Lifetime Tahoma 100 Sit-On-Top Kayak (Paddle Included)  90816', '92134', 'Lifetime Tahoma Kayak - The 120 in. adult kayak has a 275 lb. weight capacity and comes in lime green.', 'Sports Equipment', '25.00', '60.00', '240.00', 55555, 1, NULL, 1),
(10653, 'Penn Spinfisher V Spinning Reel and Fishing Rod Combo', '33235', 'A total of six seals (nine seals on the live liner models) are used to create the new Water Tight Design. A truly sealed drag system with a total of three HT-100 drag washers', 'Sports Equipment', '1.00', '40.00', '159.99', 55555, 1, NULL, 6),
(10654, 'Crosman Exclusive F4 Classic NP Break Barrel Air Rifle with Scope  .177 Caliber', '39982', 'The new Crosman F4 breakbarrel .177cal rifle is powered by a Nitro Piston that shoots up to 1200fps w/alloy ammo and is ready for your next excursion. It is built with synthetic  all-weather material', 'Sports Equipment', '10.00', '18.00', '72.00', 55555, 1, NULL, 8),
(10655, 'Mossy Oak 3pc Fisherman`s Gift Combo', '60559', 'The 3 piece Mossy Oak fisherman\'s kit was designed to make your next outing a breeze. The newly designed patented spooling station includes a line tension adjuster and suction cups to make spooling as simple as possible.', 'Sports Equipment', '1.00', '4.97', '19.88', 55555, 1, NULL, 8),
(10656, 'Sun Dolphin Journey 10 SS Sit-On Angler Kayak Grass  Paddle Included', '28976', 'Great for lakes and rivers and to get to those excluded fishing spots Lightweight  easy to carry Tracks and paddles with ease while offering maximum stability. Rugged UV-stabilized High Density Polyethylene P.A.C.', 'Sports Equipment', '25.00', '77.44', '309.75', 55555, 1, NULL, 1),
(10657, 'Roadmaster 26\" Granite Peak Women\'s Mountain Bike', '94128', 'Roadmaster 26\" Granite Peak Women\'s Mountain Bike', 'Sports Equipment', '15.00', '22.25', '89.00', 66666, 1, NULL, 2),
(10658, 'Disney Princess 12\" Girls\' EZ Build Pink Bike  by Huffy', '11217', 'Big  happy smiles are minutes away  when this 12\" Disney Princess Bike with Doll Carrier arrives! With Huffy EZ Build  only from Huffy', 'Sports Equipment', '15.00', '14.75', '59.00', 66666, 1, NULL, 2),
(10659, 'Huffy Disney Frozen 16\" EZ Build Girls Bike with Sleigh Doll Carrier  White/Blue', '25983', 'Elsa  Anna  and Olaf are featured in these Disney Frozen graphics on this 16\" bike\'s durable steel frame  translucent chainguard  and crossbar pad. Wide training wheels and an easy-to-use coaster brake are ideal for beginning riders.', 'Sports Equipment', '15.00', '17.25', '69.00', 66666, 1, NULL, 2),
(10660, 'Men\'s Anon M4 Cylindrical Goggle - BLK', '10011', 'Black + face Mask', 'Sports Equipment', '0.50', '359.99', '369.99', 11111, 1, NULL, 4),
(10661, 'Men\'s Anon M4 Cylindrical Goggle - RED', '10012', 'Red  + face Mask', 'Sports Equipment', '0.50', '359.99', '369.99', 11111, 1, NULL, 4),
(10662, 'Men\'s Anon M4 Cylindrical Goggle - BLU', '10013', 'Blue  + face Mask', 'Sports Equipment', '0.50', '359.99', '369.99', 11111, 1, NULL, 4),
(10663, 'Men\'s Anon M4 Cylindrical Goggle - GRY', '10014', 'Gray  + face Mask', 'Sports Equipment', '0.50', '359.99', '369.99', 11111, 1, NULL, 4),
(10664, 'Men\'s Anon M4 Cylindrical Goggle - GRN', '10015', 'Green  + face Mask', 'Sports Equipment', '0.50', '359.99', '369.99', 11111, 1, NULL, 4),
(10665, 'Men\'s Anon M4 Cylindrical Goggle - SMK', '10016', 'Smoke  + face Mask', 'Sports Equipment', '0.50', '359.99', '369.99', 11111, 1, NULL, 4),
(10666, 'Men\'s Anon M4 Cylindrical Goggle - RNB', '10017', 'Rainbow  + face Mask', 'Sports Equipment', '0.50', '359.99', '369.99', 11111, 1, NULL, 4),
(10667, 'Men\'s Anon M4 Cylindrical Goggle', '10020', 'Toric Goggle + face Mask', 'Sports Equipment', '0.50', '359.99', '369.99', 11111, 1, NULL, 4),
(10668, 'Men\'s Anon M4 Toric Goggle - BLU', '10031', 'Blue  + face Mask', 'Sports Equipment', '0.50', '359.99', '369.99', 11111, 1, NULL, 4),
(10669, 'Men\'s Anon M4 Toric Goggle - RED', '10032', 'Red  + face Mask', 'Sports Equipment', '0.50', '359.99', '369.99', 11111, 1, NULL, 4),
(10670, 'Men\'s Anon M4 Toric Goggle - GRY', '10033', 'Gray  + face Mask', 'Sports Equipment', '0.50', '359.99', '369.99', 11111, 1, NULL, 4),
(10671, 'Men\'s Anon M4 Toric Goggle - SND', '10034', 'Sand  + face Mask', 'Sports Equipment', '0.50', '359.99', '369.99', 11111, 1, NULL, 4),
(10672, 'Men\'s Anon M4 Toric Goggle - SNR', '10035', 'Sonar  + face Mask', 'Sports Equipment', '0.50', '359.99', '369.99', 11111, 1, NULL, 4),
(10673, 'Men\'s Anon M4 Toric Goggle - SMK', '10036', 'Smoke  + face Mask', 'Sports Equipment', '0.50', '359.99', '369.99', 11111, 1, NULL, 4),
(10674, 'Men\'s Anon M4 Toric Goggle - RNB', '10037', 'Rainbow  + face Mask', 'Sports Equipment', '0.50', '359.99', '369.99', 11111, 1, NULL, 4),
(10675, 'Men\'s Anon Polarized M2 Goggle', '10040', 'Black', 'Sports Equipment', '0.50', '359.99', '369.99', 11111, 1, NULL, 6),
(10676, 'Men\'s Anon Polarized M3 Goggle', '10050', 'Black', 'Sports Equipment', '0.50', '349.99', '359.99', 11111, 1, NULL, 6),
(10677, 'Men\'s Anon M2 Goggle - BLU', '10061', 'Blue  + face Mask', 'Sports Equipment', '0.50', '329.99', '339.99', 11111, 1, NULL, 6),
(10678, 'Men\'s Anon M2 Goggle - RDP', '10062', 'Red Planet + face Mask', 'Sports Equipment', '0.40', '329.99', '339.99', 11111, 1, NULL, 6),
(10679, 'Men\'s Anon M2 Goggle - WVE', '10063', 'Weave + face Mask', 'Sports Equipment', '0.40', '329.99', '339.99', 11111, 1, NULL, 6),
(10680, 'Men\'s Anon M2 Goggle - SNR red', '10064', 'Sonar Red + face Mask', 'Sports Equipment', '0.40', '329.99', '339.99', 11111, 1, NULL, 6),
(10681, 'Men\'s Anon M2 Goggle - SNR green', '10065', 'Sonar Green + face Mask', 'Sports Equipment', '0.40', '329.99', '339.99', 11111, 1, NULL, 6),
(10682, 'Men\'s Anon M2 Goggle - SNR', '10066', 'Sonar + face Mask', 'Sports Equipment', '0.40', '329.99', '339.99', 11111, 1, NULL, 6),
(10683, 'Men\'s Anon Prime Helmet + MIPS', '10071', 'Blue', 'Sports Equipment', '1.30', '269.99', '279.99', 11111, 1, NULL, 8),
(10684, 'Men\'s Anon Prime Helmet + MIPS', '10072', 'Green', 'Sports Equipment', '1.30', '269.99', '279.99', 11111, 1, NULL, 8),
(10685, 'Men\'s Anon Prime Helmet + MIPS', '10073', 'Dark Gray', 'Sports Equipment', '1.30', '269.99', '279.99', 11111, 1, NULL, 8),
(10686, 'Men\'s Anon Prime Helmet + MIPS', '10074', 'Blackout', 'Sports Equipment', '1.30', '269.99', '279.99', 11111, 1, NULL, 8),
(10687, 'Men\'s Anon Prime Helmet + MIPS', '10075', 'Black', 'Sports Equipment', '1.30', '269.99', '279.99', 11111, 1, NULL, 8),
(10688, 'Men\'s Anon Prime Helmet + MIPS', '10076', 'Red', 'Sports Equipment', '1.30', '269.99', '279.99', 11111, 1, NULL, 8),
(10689, 'Men\'s Anon Raider Helmet', '10081', 'Red', 'Sports Equipment', '1.30', '79.99', '89.99', 11111, 1, NULL, 8),
(10690, 'Men\'s Anon Raider Helmet', '10082', 'Blue', 'Sports Equipment', '1.30', '79.99', '89.99', 11111, 1, NULL, 8),
(10691, 'Men\'s Anon Raider Helmet', '10083', 'White', 'Sports Equipment', '1.30', '79.99', '89.99', 11111, 1, NULL, 8),
(10692, 'Men\'s Anon Raider Helmet', '10084', 'Black', 'Sports Equipment', '1.30', '79.99', '89.99', 11111, 1, NULL, 8),
(10693, 'Men\'s Anon Raider Helmet', '10085', 'Green', 'Sports Equipment', '1.30', '79.99', '89.99', 11111, 1, NULL, 8),
(10694, 'Kid\'s Anon Rime Helmet', '10091', 'Red', 'Sports Equipment', '1.30', '79.99', '89.99', 11111, 1, NULL, 8),
(10695, 'Kid\'s Anon Rime Helmet', '10092', 'Blue', 'Sports Equipment', '1.30', '79.99', '89.99', 11111, 1, NULL, 8),
(10696, 'Kid\'s Anon Rime Helmet', '10093', 'Gray', 'Sports Equipment', '1.30', '79.99', '89.99', 11111, 1, NULL, 8),
(10697, 'Kid\'s Anon Rime Helmet', '10094', 'Flannel', 'Sports Equipment', '1.30', '79.99', '89.99', 11111, 1, NULL, 8),
(10698, 'Kid\'s Anon Rime Helmet', '10095', 'White', 'Sports Equipment', '1.30', '79.99', '89.99', 11111, 1, NULL, 8),
(10699, 'Kid\'s Anon Rime Helmet', '10096', 'Black', 'Sports Equipment', '1.30', '79.99', '89.99', 11111, 1, NULL, 8),
(10700, 'Women\'s Burton Gloria - FEL', '20011', 'Fledspar / XS  S  M  L  XL  XXL', 'Apparel', '2.20', '219.00', '229.99', 11111, 1, NULL, 4),
(10701, 'Women\'s Burton Gloria - PRT', '20012', 'Port Royal / XS  S  M  L  XL  XXL', 'Apparel', '2.20', '219.00', '229.99', 11111, 1, NULL, 4),
(10702, 'Women\'s Burton Gloria - CLV', '20013', 'Clover / XS  S  M  L  XL  XXL', 'Apparel', '2.20', '219.00', '229.99', 11111, 1, NULL, 4),
(10703, 'Women\'s Burton Gloria - BAL', '20014', 'Balsam / XS  S  M  L  XL  XXL', 'Apparel', '2.20', '219.00', '229.99', 11111, 1, NULL, 4),
(10704, 'Women\'s Burton Gloria - CAN', '20015', 'Canvas Bogolanfini / XS  S  M  L  XL  XXL', 'Apparel', '2.20', '219.00', '229.99', 11111, 1, NULL, 4),
(10705, 'Women\'s Burton Gloria - STT', '20016', 'Stout White / XS  S  M  L  XL  XXL', 'Apparel', '2.20', '219.00', '229.99', 11111, 1, NULL, 4),
(10706, 'Women\'s Burton Gloria - TRB', '20017', 'True Black / XS  S  M  L  XL  XXL', 'Apparel', '2.20', '219.00', '229.99', 11111, 1, NULL, 4),
(10707, 'Women\'s Burton Gloria - TRO', '20018', 'Trocadero / XS  S  M  L  XL  XXL', 'Apparel', '2.20', '219.00', '229.99', 11111, 1, NULL, 4),
(10708, 'Women\'s Burton Gloria - PRI', '20019', 'Prickly Pear / XS  S  M  L  XL  XXL', 'Apparel', '2.20', '219.00', '229.99', 11111, 1, NULL, 4),
(10709, 'Women\'s Burton Gloria - SQU', '20020', 'Squashed / XS  S  M  L  XL  XXL', 'Apparel', '2.20', '219.00', '229.99', 11111, 1, NULL, 4),
(10710, 'Women\'s Burton Gloria - ROS', '20021', 'Rose Brown / XS  S  M  L  XL  XXL', 'Apparel', '2.20', '219.00', '229.99', 11111, 1, NULL, 4),
(10711, 'Women\'s Burton Avalon Bib Pant - NVM', '20031', 'Nevermind Floral  / XS  S  M  L  XL', 'Apparel', '3.50', '200.00', '279.99', 11111, 1, NULL, 4),
(10712, 'Women\'s Burton Avalon Bib Pant - HIC', '20032', 'Hickory  / XS  S  M  L  XL', 'Apparel', '3.50', '200.00', '279.99', 11111, 1, NULL, 4),
(10713, 'Women\'s Burton Avalon Bib Pant - TRB', '20033', 'True Black / XS  S  M  L  XL', 'Apparel', '3.50', '200.00', '279.99', 11111, 1, NULL, 4),
(10714, 'Women\'s Burton Avalon Bib Pant - ROS', '20034', 'Rose Brown / XS  S  M  L  XL', 'Apparel', '3.50', '200.00', '279.99', 11111, 1, NULL, 4),
(10715, 'Women\'s Burton One Peace One Piece - FLC', '20041', 'Floral Camo / XXS  XS  S  M  L  XL', 'Apparel', '3.25', '350.00', '359.99', 11111, 1, NULL, 4),
(10716, 'Women\'s Burton One Peace One Piece - HIC', '20042', 'HIckory / XXS  XS  S  M  L  XL', 'Apparel', '3.25', '350.00', '359.99', 11111, 1, NULL, 4),
(10717, 'Women\'s Burton Moonbase Full-Zip - ROS', '20051', 'Rose Brown / XS  S  M  L  XL', 'Apparel', '1.75', '160.00', '189.99', 11111, 1, NULL, 4),
(10718, 'Women\'s Burton Moonbase Full-Zip - MOS', '20052', 'Moss Camo / XS  S  M  L  XL', 'Apparel', '1.75', '160.00', '189.99', 11111, 1, NULL, 4),
(10719, 'Women\'s Premium Ellmore Pullover - MOI', '20061', 'Mood Indigo / XS  S  M  L  XL', 'Apparel', '1.25', '95.00', '109.99', 11111, 1, NULL, 4),
(10720, 'Women\'s Premium Ellmore Pullover - ROS', '20062', 'Rose Brown / XS  S  M  L  XL', 'Apparel', '1.25', '95.00', '109.99', 11111, 1, NULL, 4),
(10721, 'Burton Retro Pullover Hoodie - TRB', '20070', 'True Black / XS  S  M  L  XL  XXL', 'Apparel', '1.15', '90.99', '99.99', 11111, 1, NULL, 4),
(10722, 'Supreme Cart Bag', '30001', 'black', 'Apparel', '3.00', '300.00', '329.99', 22222, 1, NULL, 4),
(10723, 'Lifestyle New Era 9Fifty Hat', '30002', 'black', 'Apparel', '1.00', '15.00', '39.99', 22222, 1, NULL, 6),
(10724, 'LifeStyle Trucker Hat', '30003', 'black / white', 'Apparel', '1.00', '10.00', '13.99', 22222, 1, NULL, 6),
(10725, 'Storm Hat', '30004', 'black', 'Apparel', '1.00', '15.00', '39.99', 22222, 1, NULL, 6),
(10726, 'TaylorMade Beanie', '30005', 'black / white', 'Apparel', '1.00', '20.00', '29.99', 22222, 1, NULL, 6),
(10727, 'Storm Bucket Hat', '30006', 'gray', 'Apparel', '1.00', '30.00', '39.99', 22222, 1, NULL, 6),
(10728, '64\" Double Canopy Umbrella', '30007', 'black / white', 'Apparel', '1.10', '70.00', '89.99', 22222, 1, NULL, 6),
(10729, '60\" Single Canopy Umbrella', '30008', 'black / white', 'Apparel', '1.10', '50.00', '64.99', 22222, 1, NULL, 6),
(10730, '15\" Microfiber Cart Towel', '30008', 'gray', 'Apparel', '1.00', '20.00', '24.99', 22222, 1, NULL, 5),
(10731, '17\" Microfiber Players Towel', '30008', 'gray', 'Apparel', '1.00', '20.00', '29.99', 22222, 1, NULL, 5),
(10732, 'Heritage T-Shirt', '30008', 'Indigo', 'Apparel', '1.00', '15.00', '17.99', 22222, 1, NULL, 12),
(10733, 'Carlsbad T-Shirt', '30008', 'light blue', 'Apparel', '1.00', '15.00', '17.99', 22222, 1, NULL, 12),
(10734, 'Junior Radar Hat', '30008', 'Red', 'Apparel', '1.00', '20.00', '29.99', 22222, 1, NULL, 12),
(10735, 'Ladies Rader Visor', '30008', 'White', 'Apparel', '1.00', '25.00', '32.99', 22222, 1, NULL, 12),
(10736, 'Lite Tech Tour Hat', '30008', 'Black', 'Apparel', '1.00', '25.00', '32.99', 22222, 1, NULL, 12),
(10737, 'Stratus Tech Ladies Glove', '30008', 'White', 'Apparel', '1.00', '10.00', '15.99', 22222, 1, NULL, 12),
(10738, 'Ladies Lite Cart Bag', '30008', 'Light Gray', 'Apparel', '2.50', '245.00', '269.99', 22222, 1, NULL, 12),
(10739, 'Rain Control Gloves', '30008', 'Black / Dark Gray', 'Apparel', '1.00', '20.00', '39.99', 22222, 1, NULL, 12),
(10740, 'Performance Radar Visor', '30008', 'Blue', 'Apparel', '1.00', '20.00', '27.99', 22222, 1, NULL, 12),
(10741, 'Fiarway Headcover', '30008', 'Black / White', 'Apparel', '1.00', '20.00', '29.99', 22222, 1, NULL, 12),
(10742, 'Players Backpack', '30008', 'Gray', 'Apparel', '1.23', '100.00', '119.99', 22222, 1, NULL, 6),
(10743, 'High Crown Visor', '30008', 'Black / White', 'Apparel', '1.00', '10.00', '17.99', 22222, 1, NULL, 6),
(10744, 'Den Caddie', '30008', 'Black / White', 'Apparel', '1.20', '115.00', '129.99', 22222, 1, NULL, 6),
(10745, 'Players Backpack Duffle', '30008', 'Gray', 'Apparel', '1.25', '125.00', '149.99', 22222, 1, NULL, 5),
(10746, 'Ladies Fashion Visor', '30008', 'Blue', 'Apparel', '1.00', '15.00', '34.99', 22222, 1, NULL, 4),
(10747, 'Players Lifestyle Backpack', '30008', 'Black', 'Apparel', '1.24', '50.00', '99.99', 22222, 1, NULL, 4),
(10748, 'Cart Mittens', '30008', 'Black / Gray', 'Apparel', '80.00', '25.00', '39.99', 22222, 1, 'LEAD MITTENS', 12),
(10749, 'New Era Tour 9Fiffty Snapback Hat', '30008', 'White / Black', 'Apparel', '1.00', '25.00', '39.99', 22222, 1, NULL, 12),
(10750, 'Players Golf Travel Bag', '30008', 'Black', 'Apparel', '2.40', '325.00', '399.99', 22222, 1, NULL, 12),
(10751, 'Stratus Tech Glove', '30008', 'White', 'Apparel', '1.00', '10.00', '15.99', 22222, 1, NULL, 12),
(10752, 'Tradition Lite Heather Hat', '30008', 'Dad Hat', 'Apparel', '1.00', '20.00', '32.99', 22222, 1, NULL, 12),
(10753, 'Performance Lite Hat', '30008', 'Beige', 'Apparel', '1.00', '20.00', '34.99', 22222, 1, NULL, 12),
(10754, 'Noodle Neon Matte Red Golf Balls', '30011', 'Neon Red', 'Sports Equipment', '1.00', '12.50', '19.99', 22222, 1, NULL, 3),
(10755, 'Noodle Neon Matte Lime Green Golf Balls', '30012', 'Neon Green', 'Sports Equipment', '1.00', '12.50', '19.99', 22222, 1, NULL, 3),
(10756, 'Noodle Long & Soft Golf Balls (15 Pack)', '30013', 'White', 'Sports Equipment', '1.00', '12.50', '19.99', 22222, 1, NULL, 3),
(10757, 'M5 Driver', '30021', 'Silver', 'Sports Equipment', '5.80', '500.00', '699.99', 22222, 1, NULL, 3),
(10758, 'M5 Tour Driver', '30022', 'Silver', 'Sports Equipment', '6.00', '500.00', '699.99', 22222, 1, NULL, 3),
(10759, 'M6 Driver', '30023', 'Silver / Black', 'Sports Equipment', '6.00', '450.00', '599.99', 22222, 1, NULL, 3),
(10760, 'M6 D-Type Driver', '30024', 'Silver', 'Sports Equipment', '6.00', '450.00', '599.99', 22222, 1, NULL, 3),
(10761, 'M6 Ladies Driver', '30025', 'Silver', 'Sports Equipment', '6.00', '450.00', '599.99', 22222, 1, NULL, 3),
(10762, 'M6 Ladies D-Type Driver', '30026', 'Silver', 'Sports Equipment', '6.10', '450.00', '599.99', 22222, 1, NULL, 3),
(10763, 'Spider Mini Red', '30031', 'Red', 'Sports Equipment', '6.20', '300.00', '399.99', 22222, 1, NULL, 6),
(10764, 'TP Black Copper Collection Juno', '30032', 'Black', 'Sports Equipment', '6.20', '250.00', '279.99', 22222, 1, NULL, 6),
(10765, 'TP Black Copper Collection Soto', '30033', 'Black', 'Sports Equipment', '6.20', '250.00', '279.99', 22222, 1, NULL, 6),
(10766, 'TP Black Copper Collection Mullen 2', '30034', 'Black', 'Sports Equipment', '6.20', '250.00', '279.99', 22222, 1, NULL, 6),
(10767, 'TP Black Copper COlleciton Ardmore 3', '30035', 'Black', 'Sports Equipment', '6.20', '250.00', '279.99', 22222, 1, NULL, 6),
(10768, 'Spider Tour Black Double Bend', '30036', 'Gray', 'Sports Equipment', '6.20', '300.00', '399.99', 22222, 1, NULL, 12),
(10769, 'Spider Tour Red \"L\" Neck', '30037', 'Red', 'Sports Equipment', '6.20', '380.00', '399.99', 22222, 1, NULL, 12),
(10770, 'Men\'s Legend 2.0 T-Shirt', '45345', 'Several colors availible', 'Apparel', '0.30', '10.00', '25.00', 44444, 1, NULL, 12),
(10771, 'Women\'s Legend Drif-Fit Fleck T-Shirt', '51292', 'Several colors availible', 'Apparel', '0.30', '10.00', '20.00', 44444, 1, NULL, 12),
(10772, 'Men\'s Legend Long Sleeve Shirt', '12512', 'Slim fit', 'Apparel', '0.40', '15.00', '30.00', 44444, 1, 'Do not order this (it is a cursed item)', 12),
(10773, 'Women\'s Dry Tomboy Cross-Dye Tank Top', '22294', 'Sleeveless (wow)', 'Apparel', '0.20', '10.00', '25.00', 44444, 1, NULL, 12),
(10774, 'Men\'s Legend 2.0 V-Neck T-Shirt', '23423', 'Featuring spicy v-neck', 'Apparel', '0.20', '14.44', '25.00', 44444, 1, NULL, 12),
(10775, 'Pro Men\'s Fitted Sleeveless Shrit', '32535', 'Featuring no sleeves', 'Apparel', '0.20', '14.00', '28.00', 44444, 1, NULL, 12),
(10776, 'Woman\'s Dry Training', '21525', 'Very dry (so cool)', 'Apparel', '0.20', '15.00', '30.00', 44444, 1, NULL, 12),
(10777, 'Men\'s Breath Running T-Shirt', '62360', 'It allows you to breath', 'Apparel', '0.30', '15.00', '25.00', 44444, 1, NULL, 12),
(10778, 'Women\'s Dry Legend Training T-Shirt', '25412', 'Wow! Great value!', 'Apparel', '0.30', '4.00', '20.00', 44444, 1, NULL, 12),
(10779, 'Boys\' Dry Legend Short Sleeve Shirt', '23123', 'Boy\'s shirt', 'Apparel', '0.20', '9.00', '24.00', 44444, 1, NULL, 12),
(10780, 'Women\'s Dry Veneer Training Tank Top', '14212', 'Training tank top', 'Apparel', '0.10', '12.00', '29.50', 44444, 1, NULL, 12),
(10781, 'Women\'s Pro Deluxe Tank Top', '32533', 'High end tank top', 'Apparel', '0.20', '9.20', '40.00', 44444, 1, 'Very high end product (wow)', 12),
(10782, 'Men\'s Pro Heather Printed Fitted T-Shirt', '32323', 'Printed design', 'Apparel', '0.20', '7.00', '70.00', 44444, 1, 'Expensive (wow)', 12),
(10783, 'Boys\' Dry Elite Stripe Basketball Shorts', '35235', 'Shorts availible in multiple colors', 'Apparel', '0.20', '10.00', '20.00', 44444, 1, NULL, 12),
(10784, 'Women\'s 3\" Dry Tempo Core Running Shorts', '24212', '3\" Running shorts', 'Apparel', '0.20', '10.00', '20.00', 44444, 1, NULL, 12),
(10785, 'Men\'s Dry Epic Training Shorts', '25129', 'Grey running shorts for men', 'Apparel', '0.20', '10.00', '25.00', 44444, 1, NULL, 12),
(10786, 'Women\'s 3\" Dry Tempo Running Shorts', '44141', 'Woman\'s dry running shorts', 'Apparel', '0.20', '10.00', '22.00', 44444, 1, NULL, 12),
(10787, 'Men\'s Layup 2.0 Basketball Shorts', '22242', 'Men\'s basketball shorts', 'Apparel', '0.20', '20.00', '35.00', 44444, 1, NULL, 12),
(10788, 'Men\'s Pro Shorts', '11521', 'Men\'s running shorts', 'Apparel', '0.20', '20.00', '25.00', 44444, 1, NULL, 12),
(10789, 'Girl\'s Dry Tempo Running Shots', '35125', 'Girl\'s running shorts', 'Apparel', '0.20', '13.00', '25.00', 44444, 1, NULL, 12),
(10790, 'Boy\'s Trophy Training Shorts', '32542', 'Boy\'s training shorts', 'Apparel', '0.20', '8.33', '20.00', 44444, 1, NULL, 12),
(10791, 'Men\'s Dry Challenger 7\" Running Shorts', '22424', 'Men\'s running shots', 'Apparel', '0.20', '10.00', '25.00', 44444, 1, NULL, 12),
(10792, 'Women\'s 3\" Heatherized Tempo Shorts', '42424', 'Women\'s shorts', 'Apparel', '0.20', '10.00', '29.00', 44444, 1, NULL, 12),
(10793, 'Men\'s Dy Challenge Running Shorts', '52529', 'Men\'s running shorts', 'Apparel', '0.20', '12.00', '20.00', 44444, 1, NULL, 12),
(10794, 'Women\'s 10\" Dry Essential Basketball Shorts', '25252', 'Women\'s basketball shorts', 'Apparel', '0.20', '14.00', '25.00', 44444, 1, NULL, 12),
(10795, 'Men\'s Dry 4.0 Training Shorts', '25432', 'Men\'s training shorts', 'Apparel', '0.20', '12.00', '26.00', 44444, 1, NULL, 12),
(10796, 'Men\'s Dry Challenger 5\" Running Shorts', '25125', 'Men\'s running shorts', 'Apparel', '0.20', '19.00', '29.00', 44444, 1, NULL, 12),
(10797, 'Boy\'s Dry Elite Camo Print Basketball Shorts', '22022', 'Camo printed basketball shorts', 'Apparel', '0.20', '12.00', '26.00', 44444, 1, NULL, 12),
(10798, 'Men\'s Pro Long Shorts', '23626', 'Men\'s long shorts', 'Apparel', '0.20', '19.00', '23.00', 44444, 1, NULL, 12),
(10799, 'Women\'s Pro Deluxe 3\" Shorts', '23474', 'Women\'s shorts', 'Apparel', '0.20', '22.00', '26.00', 44444, 1, NULL, 12),
(10800, 'Pro Girls\' 4\" Shorts', '73474', 'Girls\' Shorts', 'Apparel', '0.20', '12.00', '29.00', 44444, 1, NULL, 12),
(10801, 'Men\'s Dry Dribble Drive Basketball Shorts', '47347', 'Men\'s Basketball Shorts', 'Apparel', '0.20', '16.00', '29.00', 44444, 1, NULL, 12),
(10802, 'Women\'s Pro Dri-FIT 8\" Training Shorts', '34734', 'Women\'s training shorts', 'Apparel', '0.20', '12.00', '28.00', 44444, 1, NULL, 12),
(10803, 'Women\'s Pro Dri-FIT Feather Printed 3\" Shorts', '23623', 'Women\'s printed shorts', 'Apparel', '0.20', '12.00', '27.00', 44444, 1, NULL, 12),
(10804, 'Boys\' Just Do It Printed Fly Shorts', '27434', 'Boys\' printed shorts', 'Apparel', '0.20', '16.00', '29.00', 44444, 1, NULL, 12),
(10805, 'Womens\' 5\" Dri-FIT Attack Training Shorts', '23743', 'Women\'s training shorts', 'Apparel', '0.20', '12.00', '27.00', 44444, 1, NULL, 12),
(10806, 'Men\'s Flex Woven Shorts', '27432', 'Men\'s woven shorts', 'Apparel', '0.20', '16.00', '26.00', 44444, 1, NULL, 12),
(10807, 'Women\'s Plus Size Dry 3\" Tempo Running Shorts', '26163', 'Women\'s plus size shorts', 'Apparel', '0.20', '17.00', '25.00', 44444, 1, NULL, 12),
(10808, 'Women\'s Flex 2-in-1 Training Shorts', '61249', 'Women\'s training shorts', 'Apparel', '0.20', '12.00', '29.00', 44444, 1, NULL, 12),
(10809, 'Boys\' Dry Printed Fly Training Shorts', '68276', 'Boy\'s printed training shorts', 'Apparel', '0.20', '15.00', '27.00', 44444, 1, NULL, 12),
(10810, 'Women\'s Dry Party Pack Tempo Running Shorts', '25128', 'Women\'s shorts pack', 'Apparel', '0.20', '21.00', '28.00', 44444, 1, NULL, 12),
(10811, 'Women\'s Pro Dri-FIT 3\" Shorts', '20912', 'Women\'s shorts', 'Apparel', '0.20', '15.00', '29.00', 44444, 1, NULL, 12),
(10812, 'Men\'s Sportswear Jersey Club Shorts', '36782', 'Men\'s jersey shorts', 'Apparel', '0.20', '12.00', '29.00', 44444, 1, NULL, 12),
(10813, 'Women\'s Dry 5\" French Terry Attack Shorts', '89523', 'Women\'s shorts', 'Apparel', '0.20', '15.00', '27.00', 44444, 1, NULL, 12),
(10814, 'Girl\'s Dry Tempo Printed Running Shorts', '25089', 'Girls\' printed running shorts', 'Apparel', '0.20', '16.00', '23.00', 44444, 1, NULL, 12),
(10815, 'Women\'s Pro 3\" Shorts', '35235', 'Women\'s shorts', 'Apparel', '0.20', '11.00', '28.00', 44444, 1, NULL, 12),
(10816, 'Left-Handed Men\'s Verbiage Basketball Shorts', '12512', 'Left handed men\'s shorts', 'Apparel', '0.20', '16.00', '29.00', 44444, 1, NULL, 12),
(10817, 'Boys\' Dry-FIT Elite Stripe Basketball Shorts', '51298', 'Men\'s running shorts', 'Apparel', '0.20', '18.00', '28.00', 44444, 1, NULL, 12),
(10818, 'Men\'s Dry Challenger 7\" 2-in-1 Running Shorts', '25378', 'Men\'s soccer shorts', 'Apparel', '0.20', '19.00', '25.00', 44444, 1, NULL, 12),
(10819, 'Men\'s Dry Academy Soccer Shorts', '35123', 'Girls\' shorts', 'Apparel', '0.20', '12.00', '27.00', 44444, 1, NULL, 12),
(10820, 'Girls\' Dry Shorts', '12482', 'Women\'s printed shorts', 'Apparel', '0.20', '15.00', '29.00', 44444, 1, NULL, 12),
(10821, 'Women\'s Dry Coral Printed Tempo Shorts', '51278', 'Men\'s Basketball Shorts', 'Apparel', '0.20', '16.00', '24.00', 44444, 1, NULL, 12),
(10822, 'Men\'s Dry Elite Block Basketball Shorts', '25122', 'Men\'s basketball shorts', 'Apparel', '0.20', '12.00', '27.00', 44444, 1, NULL, 12),
(10823, 'Women\'s 3\" Dry Running Shorts', '25412', 'Women\'s running shorts', 'Apparel', '0.20', '16.00', '27.00', 44444, 1, NULL, 12),
(10824, 'Men\'s Dry Hyper Training Shorts', '10293', 'Men\'s training shorts', 'Apparel', '0.20', '12.00', '29.00', 44444, 1, NULL, 12),
(10825, 'Men\'s Sportswear Club Fleece Sweatshorts', '25125', 'Men\'s sweatshorts', 'Apparel', '0.20', '16.00', '29.00', 44444, 1, NULL, 12),
(10826, 'Men\'s Spotlight Basketball Shorts', '25789', 'Men\'s basketball shorts', 'Apparel', '0.20', '18.00', '29.00', 44444, 1, NULL, 12),
(10827, 'Men\'s Elite Stripe Basketball Shorts', '54128', 'Men\'s basketball shorts', 'Apparel', '0.20', '12.00', '29.00', 44444, 1, NULL, 12),
(10828, 'Women\'s Pro 3\" Training Shorts', '24781', 'Women\'s training shorts', 'Apparel', '0.20', '16.00', '27.00', 44444, 1, NULL, 12),
(10829, 'Women\'s 5\" Attack Training Shorts', '51282', 'Women\'s training shorts', 'Apparel', '0.20', '10.00', '23.00', 44444, 1, NULL, 12),
(10830, 'Women\'s 5\" Intertwist Shorts', '25127', 'Women\'s shorts', 'Apparel', '0.20', '12.00', '26.00', 44444, 1, NULL, 12),
(10831, 'Girls\' Dri-FIT Elite Striped Shorts', '57753', 'Girl\'s shorts', 'Apparel', '0.20', '18.00', '27.00', 44444, 1, NULL, 12),
(10832, 'Women\'s Cool Dry Tempo Running Shorts', '57128', 'Women\'s running shorts', 'Apparel', '0.20', '12.00', '29.00', 44444, 1, NULL, 12),
(10833, 'Men\'s Dry Icon Basketball Shorts', '29822', 'Women\'s basketball shorts', 'Apparel', '0.20', '15.00', '28.00', 44444, 1, NULL, 12),
(10834, 'Women\'s Pro 3\" Printed Shorts', '58752', 'Women\'s printed shorts', 'Apparel', '0.20', '16.00', '27.00', 44444, 1, NULL, 12),
(10835, 'Nike Boys\' Dri-FIT Elite Printed Basketball Shorts', '25128', 'Boy\'s printed basketball shorts', 'Apparel', '0.20', '12.00', '24.00', 44444, 1, NULL, 12),
(10836, 'Boys\' Dry Kyrie Graphic Basketball Shorts', '35326', 'Boys\' graphic basketball shorts', 'Apparel', '0.20', '19.00', '29.00', 44444, 1, NULL, 12),
(10837, 'Women\'s Plus Size 3\" Dry Tempo Shorts', '47545', 'Women\'s plus size shorts', 'Apparel', '0.20', '16.00', '24.00', 44444, 1, NULL, 12),
(10838, 'Girls\' Dry Tempo Running Shorts', '36666', 'Girls\' running shorts', 'Apparel', '0.20', '12.00', '27.00', 44444, 1, NULL, 12),
(10839, 'Women\'s Pro Dri-FIT 5\" Training Shorts', '36236', 'Women\'s training shorts', 'Apparel', '0.20', '16.00', '29.00', 44444, 1, NULL, 12),
(10840, 'Boys\' Dry KD Graphic Basketball Shorts', '85645', 'Boys\' printed basketball shorts', 'Apparel', '0.20', '16.00', '40.00', 44444, 1, NULL, 12),
(10841, 'Women\'s Plus Size Flex Training Shorts', '32763', 'Women\'s plus size training shorts', 'Apparel', '0.20', '16.00', '20.00', 44444, 1, NULL, 12),
(10842, 'Women\'s Gym Vintage Shorts', '75347', 'Women\'s vintage gym shorts', 'Apparel', '0.20', '12.00', '22.00', 44444, 1, NULL, 12),
(10843, 'Men\'s NET 11\" Woven Tennis Shorts', '73455', 'Men\'s tennis shots', 'Apparel', '0.20', '19.00', '22.00', 44444, 1, NULL, 12),
(10844, 'Men\'s Flex Golf Shorts', '23788', 'Men\'s golf shorts', 'Apparel', '0.20', '18.00', '26.00', 44444, 1, NULL, 12),
(10845, 'Girls\' Dry Micro Mask Printed Tempo Shorts', '88244', 'Girls\' printed shorts', 'Apparel', '0.20', '17.00', '29.00', 44444, 1, NULL, 12),
(10846, 'Men\'s Court 9\" Tennis Shorts', '84553', 'Men\'s tennis shorts', 'Apparel', '0.20', '16.00', '29.00', 44444, 1, NULL, 12),
(10847, 'Men\'s Ultimate Performance Basketball Shorts', '23727', 'Men\'s basketball shorts', 'Apparel', '0.20', '12.00', '28.00', 44444, 1, NULL, 12),
(10848, 'Men\'s Sportswear Just Do IT training Shorts', '78853', 'Men\'s printed training shorts', 'Apparel', '0.20', '15.00', '25.00', 44444, 1, NULL, 12),
(10849, 'Girls\' Pro Printed Boy Shorts', '73453', 'Girls\' printed shorts', 'Apparel', '0.20', '16.00', '26.50', 44444, 1, NULL, 12),
(10850, 'Pro Boys\' Dri-FIT Core Compression Shorts', '34746', 'Boys\' shorts', 'Apparel', '0.20', '17.00', '26.00', 44444, 1, NULL, 12),
(10851, 'Men\'s Court Dry 9\" Tennis Shorts', '78543', 'Men\'s tennis shorts', 'Apparel', '0.20', '18.00', '27.00', 44444, 1, NULL, 12),
(10852, 'Boys\' Dry Elite Graphic Basketball Shorts', '23620', 'Boys\' basketball shorts', 'Apparel', '0.20', '19.00', '29.00', 44444, 1, NULL, 12),
(10853, 'Women\'s Dry High Cut Tempo Running Shorts', '27033', 'Women\'s running shorts', 'Apparel', '0.20', '19.00', '29.00', 44444, 1, NULL, 12),
(10854, 'Women\'s Dry Floral Printed 3\" Tempo Running', '26333', 'Women\'s printed running shorts', 'Apparel', '0.20', '16.00', '38.00', 44444, 1, NULL, 12),
(10855, 'Men\'s Hybrid Woven Golf Shorts', '52512', 'Men\'s golf shorts', 'Apparel', '0.20', '12.00', '29.00', 44444, 1, NULL, 12),
(10856, 'Women\'s Crew Running Shorts', '12512', 'Women\'s running shorts', 'Apparel', '0.20', '16.00', '23.00', 44444, 1, NULL, 12),
(10857, 'Boys\' Dry LBJ Graphic Basketball Shorts', '75775', 'Boys\' printed basketball shorts', 'Apparel', '0.20', '17.00', '26.00', 44444, 1, NULL, 12),
(10858, 'Women\'s Dry Tempo Americana Running Shorts', '32362', 'Women\'s printed running shorts', 'Apparel', '0.20', '19.00', '27.00', 44444, 1, NULL, 12),
(10859, 'Men\'s Flux Baseball Shorts', '36236', 'Men\'s basketball shorts', 'Apparel', '0.20', '12.00', '29.00', 44444, 1, NULL, 12),
(10860, 'Boys\' Graphic Fly Training Shorts', '36234', 'Boys\' printed training shorts', 'Apparel', '0.20', '19.00', '40.00', 44444, 1, NULL, 12),
(10861, 'Women\'s Sportswear Windrunner Jacket', '32519', 'Women\'s jacket', 'Apparel', '1.00', '50.00', '70.00', 44444, 1, NULL, 12),
(10862, 'Men\'s Windrunner Full Zip Jacket', '66868', 'Men\'s jacket', 'Apparel', '1.00', '58.00', '70.00', 44444, 1, NULL, 12),
(10863, 'Women\'s Essential Full Zip Running Jacket', '74743', 'Women\'s running jacket', 'Apparel', '1.00', '59.00', '70.00', 44444, 1, NULL, 12),
(10864, 'Men\'s Sportswear Windrunner Full-Zip Hoodie', '23333', 'Men\'s jacket', 'Apparel', '1.00', '58.00', '70.00', 44444, 1, NULL, 12),
(10865, 'Women\'s Essential Full Zip Running Vest', '12512', 'Women\'s running vest', 'Apparel', '1.00', '59.00', '80.00', 44444, 1, NULL, 12),
(10866, 'Men\'s Sportswear Windrunnder Down Jacket', '85685', 'Men\'s jacket', 'Apparel', '1.00', '52.00', '70.00', 44444, 1, NULL, 12),
(10867, 'Boys\' Sportswear Graphic Windrunner Jacket', '99444', 'Boys\' printed jacket', 'Apparel', '1.00', '51.00', '66.00', 44444, 1, NULL, 12),
(10868, 'Men\'s Sportswear 2019 Hooded Windrunner Jacket', '43563', 'Men\'s hooded jacket', 'Apparel', '1.00', '59.00', '67.00', 44444, 1, NULL, 12),
(10869, 'Women\'s Sportswear Sherpa Windrunner Jacket', '85455', 'Women\'s jacket', 'Apparel', '1.00', '51.00', '64.00', 44444, 1, NULL, 12),
(10870, 'Women\'s Sportswear Windrunner Reversible Jacket', '54654', 'Women\'s jacket', 'Apparel', '1.00', '59.00', '70.00', 44444, 1, NULL, 12),
(10871, 'Women\'s Therma Sherpa Full Zip Jacket', '15252', 'Women\'s full zip jacket', 'Apparel', '1.00', '60.00', '80.00', 44444, 1, NULL, 12),
(10872, 'Boy\'s Sportswear Sherpa Windrunner Jacket', '88444', 'Boys\' jacket', 'Apparel', '1.00', '53.00', '70.00', 44444, 1, NULL, 12),
(10873, 'Women\'s Essential Hooded Running Jacket', '23623', 'Women\'s running jacket', 'Apparel', '1.00', '59.00', '70.00', 44444, 1, NULL, 12),
(10874, 'Men\'s Sportswear Windrunner Down Vest', '34734', 'Men\'s jacket', 'Apparel', '1.00', '44.00', '55.00', 44444, 1, NULL, 12),
(10875, 'Girl\'s Sportswear Sherpa Unicorn Windrunner', '15222', 'Girls\' jacket', 'Apparel', '1.00', '46.60', '60.00', 44444, 1, NULL, 12),
(10876, 'Women\'s Repellent Golf Vest', '75432', 'Women\'s golf vest', 'Apparel', '1.00', '76.00', '90.00', 44444, 1, NULL, 12),
(10877, 'Men\'s Reversible Insulated Golf Vest', '34634', 'Men\'s golf vest', 'Apparel', '1.00', '50.00', '70.00', 44444, 1, NULL, 12),
(10878, 'Women\'s Sportswear Newsprint Half-Zip Jacket', '78323', 'Women\'s jacket', 'Apparel', '1.00', '33.00', '44.00', 44444, 1, NULL, 12),
(10879, 'Men\'s Hypershield Golf Rain Jacket', '23633', 'Men\'s golf jacket', 'Apparel', '1.00', '60.00', '76.40', 44444, 1, NULL, 12),
(10880, 'Nike Pitch Training Soccer Ball', '70000', 'Black / Red', 'Sports Equipment', '0.45', '10.99', '16.99', 44444, 1, '16 oz. Nike Soccer Ball', 6),
(10881, 'Nike Pitch Training Soccer Ball', '70001', 'Pink / Yellow', 'Sports Equipment', '0.45', '10.99', '16.99', 44444, 1, '16 oz. Nike Soccer Ball', 6),
(10882, 'Nike Pitch Training Soccer Ball', '70002', 'Yellow / Gray', 'Sports Equipment', '0.45', '10.99', '16.99', 44444, 1, '16 oz. Nike Soccer Ball', 6),
(10883, 'Nike Pitch Training Soccer Ball', '70003', 'Blue', 'Sports Equipment', '0.45', '10.99', '16.99', 44444, 1, '16 oz. Nike Soccer Ball', 6),
(10884, 'Nike Pitch Training Soccer Ball', '70004', 'Teal / Black', 'Sports Equipment', '0.45', '10.99', '16.99', 44444, 1, '16 oz. Nike Soccer Ball', 6),
(10885, 'Nike Pitch Training Soccer Ball', '70005', 'Magenta / Black', 'Sports Equipment', '0.45', '10.99', '16.99', 44444, 1, '16 oz. Nike Soccer Ball', 6),
(10886, 'Nike Superfly 6 Academy MG Soccer Cleats', '70006', 'Black', 'Sports Equipment', '0.27', '29.99', '54.99', 44444, 1, 'Black Soccer Cleats ( Size Varies )', 6),
(10887, 'Nike Kids\' Tiempo Legend 7 Club Indoor Soccer Shoes', '70007', 'Black / Red / White', 'Sports Equipment', '0.27', '14.99', '34.99', 44444, 1, 'Kids indoor soccer shoes ( Size Varies )', 6),
(10888, 'Nike BombaX Indoor Soccer Shoes', '70008', 'Black / Blue / White', 'Sports Equipment', '0.27', '29.99', '54.99', 44444, 1, 'Indoor Soccer Shoes ( Size Varies )', 6),
(10889, 'Nike Bravata II FG Soccer Cleats', '70009', 'PInk / Black', 'Sports Equipment', '0.27', '9.99', '24.99', 44444, 1, 'Pink Soccer Cleats ( Size Varies )', 6),
(10890, 'Nike Neymar Mercurial Superfly 6  Academy Soccer Cleats', '70010', 'Yellow / White', 'Sports Equipment', '0.27', '19.99', '44.99', 44444, 1, 'Yellow Soccer Cleats ( Size Varies )', 6),
(10891, 'Nike MercurialX Superfly 6 Club Indoor Soccer Shoes', '70011', 'Green / Black', 'Sports Equipment', '0.27', '34.99', '69.99', 44444, 1, 'Lime Green Soccer Cleats ( Size Varies )', 6),
(10892, 'Nike Kids\' Magista Obra 2 Club FG Soccer Cleats', '70012', 'Orange / Black', 'Sports Equipment', '0.27', '9.99', '19.99', 44444, 1, 'Kids Soccer cleats ( Size Varies )', 6),
(10893, 'Under Armour Men\'s ColdGear Armor Mock Compression', '70013', 'Black Male Shirt', 'Apparel', '0.13', '14.99', '49.99', 99999, 1, 'Black Shirt', 6),
(10894, 'Under Armour Men\'s ColdGear Armor Mock Compression', '70014', 'Grey Male Shirt', 'Apparel', '0.13', '14.99', '49.99', 99999, 1, 'Gray Shirt', 6),
(10895, 'Under Armour Men\'s ColdGear Armor Mock Compression', '70015', 'Navy Blue Male Shirt', 'Apparel', '0.13', '14.99', '49.99', 99999, 1, 'Navy Shirt', 6),
(10896, 'Under Armour Men\'s ColdGear Armor Mock Compression', '70016', 'White Male Shirt', 'Apparel', '0.13', '14.99', '49.99', 99999, 1, 'White Shirt', 6),
(10897, 'Under Armour Men\'s Challenger II T-Shirt', '70017', 'Grey T-Shirt', 'Apparel', '0.13', '5.99', '24.99', 99999, 1, 'Grey T-Shirt', 6),
(10898, 'Under Armour Men\'s Challenger II T-Shirt', '70018', 'Black T-Shirt', 'Apparel', '0.13', '5.99', '24.99', 99999, 1, 'Black T-Shirt', 6),
(10899, 'Under Armour Men\'s Challenger II T-Shirt', '70019', 'Black / Red T-Shirt', 'Apparel', '0.13', '5.99', '24.99', 99999, 1, 'Black / Red T-Shirt', 6),
(10900, 'Under Armour Men\'s ColdGear Fitted Crew', '70020', 'Black Crew Shirt', 'Apparel', '0.13', '14.99', '29.99', 99999, 1, 'Black Crew Shirt', 6),
(10901, 'Under Armour Men\'s ColdGear Fitted Crew', '70021', 'Grey Crew Shirt', 'Apparel', '0.13', '14.99', '29.99', 99999, 1, 'Grey Crew Shirt', 6),
(10902, 'Under Armour Men\'s ColdGear Fitted Crew', '70022', 'White Crew Shirt', 'Apparel', '0.13', '14.99', '29.99', 99999, 1, 'White Crew Shirt', 6),
(10903, 'Reebok Boys\' Solid Performance Graphic T-Shirt', '70023', 'Black T-Shirt', 'Apparel', '0.13', '2.99', '14.99', 10000, 1, 'Black T-Shirt', 6),
(10904, 'Reebok Boys\' Solid Performance Graphic T-Shirt', '70024', 'Grey T-Shirt', 'Apparel', '0.13', '2.99', '14.99', 10000, 1, 'Grey T-Shirt', 6),
(10905, 'Reebok Boys\' Solid Performance Graphic T-Shirt', '70025', 'Red T-Shirt', 'Apparel', '0.13', '2.99', '14.99', 10000, 1, 'Red T-Shirt', 6),
(10906, 'Reebok Boys\' Solid Performance Graphic T-Shirt', '70026', 'Brown T-Shirt', 'Apparel', '0.13', '2.99', '14.99', 10000, 1, 'Brown T-Shirt', 6),
(10907, 'Reebok Boys\' Solid Performance Graphic T-Shirt', '70027', 'Yellow T-Shirt', 'Apparel', '0.13', '2.99', '14.99', 10000, 1, 'Yellow T-Shirt', 6),
(10908, 'Reebok Boys\' Solid Performance Graphic T-Shirt', '70028', 'Green T-Shirt', 'Apparel', '0.13', '2.99', '14.99', 10000, 1, 'Green T-Shirt', 6),
(10909, 'Reebok Boys\' Solid Performance Graphic T-Shirt', '70029', 'Blue T-Shirt', 'Apparel', '0.13', '2.99', '14.99', 10000, 1, 'Blue T-Shirt', 6),
(10910, 'Reebok Boys\' Solid Performance Graphic T-Shirt', '70030', 'Teal T-Shirt', 'Apparel', '0.13', '2.99', '14.99', 10000, 1, 'Teal T-Shirt', 6),
(10911, 'Reebok Boys\' Solid Performance Graphic T-Shirt', '70031', 'Pink T-Shirt', 'Apparel', '0.13', '2.99', '14.99', 10000, 1, 'Pink T-Shirt', 6),
(10912, 'Reebok Boys\' Solid Performance Graphic T-Shirt', '70032', 'Purple T-Shirt', 'Apparel', '0.13', '2.99', '14.99', 10000, 1, 'Purple T-Shirt', 6),
(10913, 'Under Amour Girls\' Novelty ColdGear Leggings', '70033', 'Blue / Green / Black Leggings', 'Apparel', '0.13', '19.99', '39.99', 99999, 1, 'Blue / Green / Black Leggings', 6),
(10914, 'Under Amour Girls\' Novelty ColdGear Leggings', '70034', 'Magenta / Tan / Black Leggings', 'Apparel', '0.13', '19.99', '39.99', 99999, 1, 'Magenta / Tan / Black Leggings', 6),
(10915, 'Under Amour Girls\' Novelty ColdGear Leggings', '70035', 'Blue / Teal Leggings', 'Apparel', '0.13', '19.99', '39.99', 99999, 1, 'Blue / Teal Leggings', 6),
(10916, 'Under Amour Girls\' Novelty ColdGear Leggings', '70036', 'Magenta / Purple Leggings', 'Apparel', '0.13', '19.99', '39.99', 99999, 1, 'Magenta / Purple Leggings', 6),
(10917, 'Under Amour Girls\' Novelty ColdGear Leggings', '70037', 'Blue / White / Yellow Leggings', 'Apparel', '0.13', '19.99', '39.99', 99999, 1, 'Blue / White / Yellow Leggings', 6),
(10918, 'Under Amour Girls\' Novelty ColdGear Leggings', '70038', 'Black / Mesh Leggings', 'Apparel', '0.13', '19.99', '39.99', 99999, 1, 'Black / Mesh Leggings', 6),
(10919, 'Under Amour Girls\' Novelty ColdGear Leggings', '70039', 'Black / White Splatter Leggings', 'Apparel', '0.13', '19.99', '39.99', 99999, 1, 'Black / White Splatter Leggings', 6),
(10920, 'Under Armour Mens\' ColdGear Compression Leggings', '70040', 'Navy Compression Leggings', 'Apparel', '0.13', '19.99', '39.99', 99999, 1, 'Navy Compression Leggings', 6),
(10921, 'Under Armour Mens\' ColdGear Compression Leggings', '70041', 'Black Compression Leggings', 'Apparel', '0.13', '19.99', '39.99', 99999, 1, 'Black Compression Leggings', 6),
(10922, 'Under Armour Mens\' ColdGear Compression Leggings', '70042', 'Grey Compression Leggings', 'Apparel', '0.13', '19.99', '39.99', 99999, 1, 'Grey Compression Leggings', 6),
(10923, 'Under Armour Mens\' ColdGear Compression Leggings', '70043', 'White Compression Leggings', 'Apparel', '0.13', '19.99', '39.99', 99999, 1, 'White Compression Leggings', 6),
(10924, 'Under Armour Womens\' ColdGear Leggings', '70044', 'Grey Leggings', 'Apparel', '0.13', '19.99', '39.99', 99999, 1, 'Grey Leggings', 6),
(10925, 'Under Armour Womens\' ColdGear Leggings', '70045', 'Black Leggings', 'Apparel', '0.13', '19.99', '39.99', 99999, 1, 'Black Leggings', 6),
(10926, 'Under Armour Mens\' Challenger Tech Three Quarter Pants', '70046', 'Black Three Quarter Pants', 'Apparel', '0.13', '19.99', '39.99', 99999, 1, 'Black Three Quarter Pants', 6),
(10927, 'Reebok All Sport Athletic Over the Calf Socks', '70047', 'Red Socks', 'Apparel', '0.06', '1.00', '9.99', 10000, 1, 'Red Socks', 6),
(10928, 'Reebok All Sport Athletic Over the Calf Socks', '70048', 'Black Socks', 'Apparel', '0.06', '1.00', '9.99', 10000, 1, 'Black Socks', 6),
(10929, 'Reebok All Sport Athletic Over the Calf Socks', '70049', 'Forest Green Socks', 'Apparel', '0.06', '1.00', '9.99', 10000, 1, 'Forest Green Socks', 6),
(10930, 'Reebok All Sport Athletic Over the Calf Socks', '70050', 'Yellow Socks', 'Apparel', '0.06', '1.00', '9.99', 10000, 1, 'Yellow Socks', 6),
(10931, 'Reebok All Sport Athletic Over the Calf Socks', '70051', 'Grey Socks', 'Apparel', '0.06', '1.00', '9.99', 10000, 1, 'Grey Socks', 6),
(10932, 'Reebok All Sport Athletic Over the Calf Socks', '70052', 'Lime Green Socks', 'Apparel', '0.06', '1.00', '9.99', 10000, 1, 'Lime Green Socks', 6),
(10933, 'Reebok All Sport Athletic Over the Calf Socks', '70053', 'Green Socks', 'Apparel', '0.06', '1.00', '9.99', 10000, 1, 'Green Socks', 6),
(10934, 'Reebok All Sport Athletic Over the Calf Socks', '70054', 'Navy Socks', 'Apparel', '0.06', '1.00', '9.99', 10000, 1, 'Navy Socks', 6),
(10935, 'Reebok All Sport Athletic Over the Calf Socks', '70055', 'Orange Socks', 'Apparel', '0.06', '1.00', '9.99', 10000, 1, 'Orange Socks', 6),
(10936, 'Reebok All Sport Athletic Over the Calf Socks', '70056', 'Purple Socks', 'Apparel', '0.06', '1.00', '9.99', 10000, 1, 'Purple Socks', 6),
(10937, 'Reebok All Sport Athletic Over the Calf Socks', '70057', 'Dark Red Socks', 'Apparel', '0.06', '1.00', '9.99', 10000, 1, 'Dark Red Socks', 6),
(10938, 'Reebok All Sport Athletic Over the Calf Socks', '70058', 'Blue Socks', 'Apparel', '0.06', '1.00', '9.99', 10000, 1, 'Blue Socks', 6),
(10939, 'Reebok All Sport Athletic Over the Calf Socks', '70059', 'White Socks', 'Apparel', '0.06', '1.00', '9.99', 10000, 1, 'White Socks', 6),
(10940, 'Nike Classic Soccer Socks', '70060', 'White Socks', 'Apparel', '0.06', '1.00', '9.99', 44444, 1, 'White Socks', 6),
(10941, 'Nike Classic Soccer Socks', '70061', 'Black Socks', 'Apparel', '0.06', '1.00', '9.99', 44444, 1, 'Black Socks', 6),
(10942, 'Under Amour Youth Team OTC Socks', '70062', 'Grey Socks', 'Apparel', '0.06', '1.00', '9.99', 10000, 1, 'White Socks', 6),
(10943, 'Under Amour Youth Team OTC Socks', '70063', 'White Socks', 'Apparel', '0.06', '1.00', '9.99', 10000, 1, 'Black Socks', 6),
(10944, 'Nike Squad Unisex Soccer Snood', '70064', 'Black Snood', 'Apparel', '0.06', '9.99', '19.99', 44444, 1, 'Black Face Mask', 6),
(10945, 'Nike Boys\' Trophy Training Shorts', '70065', 'Blue / White Shorts', 'Apparel', '0.06', '9.99', '19.99', 44444, 1, 'Blue / White Shorts', 6),
(10946, 'Nike Boys\' Trophy Training Shorts', '70066', 'Black / Grey Shorts', 'Apparel', '0.06', '9.99', '19.99', 44444, 1, 'Black / Grey Shorts', 6),
(10947, 'Nike Boys\' Trophy Training Shorts', '70067', 'White / Black Shorts', 'Apparel', '0.06', '9.99', '19.99', 44444, 1, 'White / Black Shorts', 6),
(10948, 'Nike Boys\' Trophy Training Shorts', '70068', 'Black / White Shorts', 'Apparel', '0.06', '9.99', '19.99', 44444, 1, 'Black / White Shorts', 6),
(10949, 'Nike Boys\' Trophy Training Shorts', '70069', 'Blue / Black Shorts', 'Apparel', '0.06', '9.99', '19.99', 44444, 1, 'Blue / Black Shorts', 6),
(10950, 'Nike Boys\' Trophy Training Shorts', '70070', 'Red / Black Shorts', 'Apparel', '0.06', '9.99', '19.99', 44444, 1, 'Red / Black Shorts', 6),
(10951, 'Nike Boys\' Trophy Training Shorts', '70071', 'Green Shorts', 'Apparel', '0.06', '9.99', '19.99', 44444, 1, 'Green Shorts', 6),
(10952, 'Nike Girls\' Dry Micro Master Printed Shorts', '70072', 'Pink Shorts', 'Apparel', '0.06', '9.99', '19.99', 44444, 1, 'Pink Shorts', 6),
(10953, 'Nike Girls\' Dry Micro Master Printed Shorts', '70073', 'Black Shorts', 'Apparel', '0.06', '9.99', '19.99', 44444, 1, 'Black Shorts', 6),
(10954, 'Nike Girls\' Pro Allover Printed Shorts', '70074', 'Floral Print Slim Fit Shorts', 'Apparel', '0.06', '14.99', '29.99', 44444, 1, 'Floral Grey / Pink Shorts', 6),
(10955, 'Nike Womens\' Dry Academy Soccer Shorts', '70075', 'Black / Pink Shorts', 'Apparel', '0.06', '9.99', '19.99', 44444, 1, 'Black / Pink Shorts', 6),
(10956, 'Nike Womens\' Dry Academy Soccer Shorts', '70076', 'Pink / White Shorts', 'Apparel', '0.06', '9.99', '19.99', 44444, 1, 'Pink / White Shorts', 6),
(10957, 'Nike Womens\' Dry Academy Soccer Shorts', '70077', 'White / Black Shorts', 'Apparel', '0.06', '9.99', '19.99', 44444, 1, 'White / Black Shorts', 6),
(10958, 'Nike Womens\' Dry Academy Soccer Shorts', '70078', 'Black / White Shorts', 'Apparel', '0.06', '9.99', '19.99', 44444, 1, 'Black / White Shorts', 6),
(10959, 'Nike Mens\' Dry Academy Soccer Shorts', '70079', 'Teal / White Shorts', 'Apparel', '0.06', '9.99', '19.99', 44444, 1, 'Teal / White Shorts', 6),
(10960, 'Nike Mens\' Dry Academy Soccer Shorts', '70080', 'Blue / White Shorts', 'Apparel', '0.06', '9.99', '19.99', 44444, 1, 'Blue / White Shorts', 6),
(10961, 'Nike Mens\' Dry Academy Soccer Shorts', '70081', 'Black / White Shorts', 'Apparel', '0.06', '9.99', '19.99', 44444, 1, 'Black / White Shorts', 6),
(10962, 'Nike Mens\' Dry Academy Soccer Shorts', '70082', 'White / Black Shorts', 'Apparel', '0.06', '9.99', '19.99', 44444, 1, 'White / Black Shorts', 6),
(10963, 'Nike Mens\' Dry Academy Soccer Shorts', '70083', 'Navy / White Shorts', 'Apparel', '0.06', '9.99', '19.99', 44444, 1, 'Navy / White Shorts', 6),
(10964, 'Nike Basilia Medium Printed Duffle Bag', '70084', 'Grey Printed Duffle Bag', 'Sports Equipment', '0.90', '19.99', '49.99', 44444, 1, 'Grey Printed Duffle Bag', 6),
(10965, 'Nike Basilia Medium Printed Duffle Bag', '70085', 'Brown Printed Duffle Bag', 'Sports Equipment', '0.90', '19.99', '49.99', 44444, 1, 'Brown Printed Duffle Bag', 6),
(10966, 'Nike Basilia Medium Printed Duffle Bag', '70086', 'Blue Printed Duffle Bag', 'Sports Equipment', '0.90', '19.99', '49.99', 44444, 1, 'Blue Printed Duffle Bag', 6),
(10967, 'Nike Basilia Medium Printed Duffle Bag', '70087', 'Green Printed Duffle Bag', 'Sports Equipment', '0.90', '19.99', '49.99', 44444, 1, 'Green Printed Duffle Bag', 6),
(10968, 'Nike Basilia Medium Printed Duffle Bag', '70088', 'Pink Printed Duffle Bag', 'Sports Equipment', '0.90', '19.99', '49.99', 44444, 1, 'Pink Printed Duffle Bag', 6),
(10969, 'Nike Basilia Medium Printed Duffle Bag', '70089', 'Red Printed Duffle Bag', 'Sports Equipment', '0.90', '19.99', '49.99', 44444, 1, 'Red Printed Duffle Bag', 6),
(10970, 'Under Armour Undeniable 3.0 Medium Duffle Bag', '70090', 'White / Orange Duffle Bag', 'Sports Equipment', '0.90', '19.99', '49.99', 44444, 1, 'White / Orange Duffle Bag', 6),
(10971, 'Under Armour Undeniable 3.0 Medium Duffle Bag', '70091', 'Black / Pink Duffle Bag', 'Sports Equipment', '0.90', '19.99', '49.99', 44444, 1, 'Black / Pink Duffle Bag', 6),
(10972, 'Under Armour Undeniable 3.0 Medium Duffle Bag', '70092', 'Navy / Grey Duffle Bag', 'Sports Equipment', '0.90', '19.99', '49.99', 44444, 1, 'Navy / Grey Duffle Bag', 6),
(10973, 'Under Armour Undeniable 3.0 Medium Duffle Bag', '70093', 'Black / Grey Duffle Bag', 'Sports Equipment', '0.90', '19.99', '49.99', 44444, 1, 'Black / Grey Duffle Bag', 6),
(10974, 'Under Armour Undeniable 3.0 Medium Duffle Bag', '70094', 'Pink / Grey Duffle Bag', 'Sports Equipment', '0.90', '19.99', '49.99', 44444, 1, 'Pink / Grey Duffle Bag', 6),
(10975, 'Under Armour Undeniable 3.0 Medium Duffle Bag', '70095', 'Black / White Duffle Bag', 'Sports Equipment', '0.90', '19.99', '49.99', 44444, 1, 'Black / White Duffle Bag', 6),
(10976, 'Under Armour Undeniable 3.0 Medium Duffle Bag', '70096', 'Grey / Black Duffle Bag', 'Sports Equipment', '0.90', '19.99', '49.99', 44444, 1, 'Grey / Black Duffle Bag', 6),
(10977, 'Under Armour Undeniable 3.0 Medium Duffle Bag', '70097', 'Grey / White Duffle Bag', 'Sports Equipment', '0.90', '19.99', '49.99', 44444, 1, 'Grey / White Duffle Bag', 6),
(10978, 'Under Armour Undeniable 3.0 Medium Duffle Bag', '70098', 'Red / Grey Duffle Bag', 'Sports Equipment', '0.90', '19.99', '49.99', 44444, 1, 'Red / Grey Duffle Bag', 6),
(10979, 'Under Armour Undeniable 3.0 Medium Duffle Bag', '70099', 'Blue / Grey Duffle Bag', 'Sports Equipment', '0.90', '19.99', '49.99', 44444, 1, 'Blue / Grey Duffle Bag', 6),
(10980, 'Under Armour Undeniable 3.0 Medium Duffle Bag', '70100', 'Grey / Red Duffle Bag', 'Sports Equipment', '0.90', '19.99', '49.99', 44444, 1, 'Grey / Red Duffle Bag', 6),
(10981, 'Under Armour Undeniable 3.0 Medium Duffle Bag', '70101', 'Grey / Orange Duffle Bag', 'Sports Equipment', '0.90', '19.99', '49.99', 44444, 1, 'Grey / Orange Duffle Bag', 6),
(10982, 'Nike Neymar Soccer Backpack', '70102', 'Black Backpack', 'Sports Equipment', '0.90', '19.99', '49.99', 44444, 1, 'Black Backpack', 6),
(10983, 'Nike Essential Ball Pump', '70103', 'Ball Pump', 'Sports Equipment', '1.10', '4.99', '11.99', 44444, 1, 'Ball Pump', 6),
(10984, 'Nike Ball Pump 3', '70104', 'Ball Pump', 'Sports Equipment', '1.10', '4.99', '11.99', 44444, 1, 'Ball Pump', 6),
(10985, 'Nike Ball Pump', '70105', 'Ball Pump', 'Sports Equipment', '1.10', '4.99', '11.99', 44444, 1, 'Ball Pump', 6),
(10986, 'Nike Elite Ball Pump', '70106', 'Ball Pump', 'Sports Equipment', '1.10', '4.99', '11.99', 44444, 1, 'Ball Pump', 6),
(10987, 'Nike Hyperspeed Ball Pump', '70107', 'Ball Pump', 'Sports Equipment', '1.10', '4.99', '11.99', 44444, 1, 'Ball Pump', 6),
(10988, 'Under Armour Dual-Action Ball Pump', '70108', 'Ball Pump', 'Sports Equipment', '1.10', '4.99', '11.99', 99999, 1, 'Ball Pump', 6),
(10989, 'Nike Lanyard - Yellow / Black', '70109', 'Nike Lanyard - Yellow / Black', 'Sports Equipment', '0.01', '1.99', '9.99', 44444, 1, 'Nike Lanyard - Yellow / Black', 6),
(10990, 'Nike Lanyard - White / Black', '70110', 'Nike Lanyard - White / Black', 'Sports Equipment', '0.01', '1.99', '9.99', 44444, 1, 'Nike Lanyard - White / Black', 6),
(10991, 'Nike Lanyard - Orange / Black', '70111', 'Nike Lanyard - Orange / Black', 'Sports Equipment', '0.01', '1.99', '9.99', 44444, 1, 'Nike Lanyard - Orange / Black', 6),
(10992, 'Nike Lanyard - Red / White', '70112', 'Nike Lanyard - Red / White', 'Sports Equipment', '0.01', '1.99', '9.99', 44444, 1, 'Nike Lanyard - Red / White', 6),
(10993, 'Nike Lanyard - Pink / White', '70113', 'Nike Lanyard - Pink / White', 'Sports Equipment', '0.01', '1.99', '9.99', 44444, 1, 'Nike Lanyard - Pink / White', 6),
(10994, 'Nike Lanyard - Red / Grey', '70114', 'Nike Lanyard - Red / Grey', 'Sports Equipment', '0.01', '1.99', '9.99', 44444, 1, 'Nike Lanyard - Red / Grey', 6),
(10995, 'Nike Lanyard - Dark Purple / Pink', '70115', 'Nike Lanyard - Dark Purple / Pink', 'Sports Equipment', '0.01', '1.99', '9.99', 44444, 1, 'Nike Lanyard - Dark Purple / Pink', 6),
(10996, 'Nike Lanyard - Blue / Yellow', '70116', 'Nike Lanyard - Blue / Yellow', 'Sports Equipment', '0.01', '1.99', '9.99', 44444, 1, 'Nike Lanyard - Blue / Yellow', 6),
(10997, 'Nike Lanyard - Black / White', '70117', 'Nike Lanyard - Black / White', 'Sports Equipment', '0.01', '1.99', '9.99', 44444, 1, 'Nike Lanyard - Black / White', 6),
(10998, 'Nike Lanyard - Green / White', '70118', 'Nike Lanyard - Green / White', 'Sports Equipment', '0.01', '1.99', '9.99', 44444, 1, 'Nike Lanyard - Green / White', 6);

DROP TABLE IF EXISTS `inventory`;

CREATE TABLE `inventory` (
    `itemID` INT(11),
    `siteID` INT(11) DEFAULT NULL,
    `quantity` INT(11),
    `itemLocation` VARCHAR(20),
    `reorderThreshold` INT(11)
); 

-- Warehouse
insert into `inventory` (itemID) select itemID from item;
UPDATE `inventory`
SET siteID = 1, quantity = 25, itemLocation = 'Stock', reorderThreshold = 25
WHERE siteID is null;

-- Saint John
insert into `inventory` (itemID) select itemID from item;
UPDATE `inventory`
SET siteID = 4, quantity = 5, itemLocation = 'Shelf', reorderThreshold = 5
WHERE siteID is null;

-- Sussex
insert into `inventory` (itemID) select itemID from item;
UPDATE `inventory`
SET siteID = 5, quantity = 5, itemLocation = 'Shelf', reorderThreshold = 5
WHERE siteID is null;

-- Moncton
insert into `inventory` (itemID) select itemID from item;
UPDATE `inventory`
SET siteID = 6, quantity = 5, itemLocation = 'Shelf', reorderThreshold = 5
WHERE siteID is null;

-- Dieppe
insert into `inventory` (itemID) select itemID from item;
UPDATE `inventory`
SET siteID = 7, quantity = 5, itemLocation = 'Shelf', reorderThreshold = 5
WHERE siteID is null;

-- Oromocto
insert into `inventory` (itemID) select itemID from item;
UPDATE `inventory`
SET siteID = 8, quantity = 5, itemLocation = 'Shelf', reorderThreshold = 5
WHERE siteID is null;

-- Fredericton
insert into `inventory` (itemID) select itemID from item;
UPDATE `inventory`
SET siteID = 9, quantity = 5, itemLocation = 'Shelf', reorderThreshold = 5
WHERE siteID is null;

-- Miramichi
insert into `inventory` (itemID) select itemID from item;
UPDATE `inventory`
SET siteID = 10, quantity = 5, itemLocation = 'Shelf', reorderThreshold = 5
WHERE siteID is null;

ALTER TABLE `inventory` 
ADD FOREIGN KEY (siteID) REFERENCES `site` (`siteID`);

ALTER TABLE `inventory`
ADD FOREIGN KEY (itemID) REFERENCES `item` (`itemID`);

ALTER TABLE `inventory`
ADD PRIMARY KEY (itemID, siteID);

-- Clear out current permissions
DELETE FROM user_permission;

COMMIT;



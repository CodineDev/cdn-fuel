-- Create Table for Fuel Stations --
CREATE TABLE IF NOT EXISTS `fuel_stations` (
  `location` int(11) DEFAULT NULL,
  `owned` int(11) DEFAULT NULL,
  `owner` varchar(50) DEFAULT NULL,
  `fuel` int(11) DEFAULT NULL,
  `fuelprice` int(11) DEFAULT NULL,
  `balance` int(255) DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`location`)
) ENGINE=InnoDB;

-- Insert Default Information into the Table Created! --
INSERT INTO `fuel_stations` (`location`, `owned`, `owner`, `fuel`, `fuelprice`, `balance`, `label`) VALUES (1, 0, '0', 100000, 3, 0, 'Davis Avenue Ron');
INSERT INTO `fuel_stations` (`location`, `owned`, `owner`, `fuel`, `fuelprice`, `balance`, `label`) VALUES (2, 0, '0', 100000, 3, 0, 'Grove Street LTD');
INSERT INTO `fuel_stations` (`location`, `owned`, `owner`, `fuel`, `fuelprice`, `balance`, `label`) VALUES (3, 0, '0', 100000, 3, 0, 'Dutch London Xero');
INSERT INTO `fuel_stations` (`location`, `owned`, `owner`, `fuel`, `fuelprice`, `balance`, `label`) VALUES (4, 0, '0', 100000, 3, 0, 'Little Seoul LTD');
INSERT INTO `fuel_stations` (`location`, `owned`, `owner`, `fuel`, `fuelprice`, `balance`, `label`) VALUES (5, 0, '0', 100000, 3, 0, 'Strawberry Ave Xero');
INSERT INTO `fuel_stations` (`location`, `owned`, `owner`, `fuel`, `fuelprice`, `balance`, `label`) VALUES (6, 0, '0', 100000, 3, 0, 'Popular Street Ron');
INSERT INTO `fuel_stations` (`location`, `owned`, `owner`, `fuel`, `fuelprice`, `balance`, `label`) VALUES (7, 0, '0', 100000, 3, 0, 'Capital Blvd Ron');
INSERT INTO `fuel_stations` (`location`, `owned`, `owner`, `fuel`, `fuelprice`, `balance`, `label`) VALUES (8, 0, '0', 100000, 3, 0, 'Mirror Park LTD');
INSERT INTO `fuel_stations` (`location`, `owned`, `owner`, `fuel`, `fuelprice`, `balance`, `label`) VALUES (9, 0, '0', 100000, 3, 0, 'Clinton Ave Globe Oil');
INSERT INTO `fuel_stations` (`location`, `owned`, `owner`, `fuel`, `fuelprice`, `balance`, `label`) VALUES (10, 0, '0', 100000, 3, 0, 'North Rockford Ron');
INSERT INTO `fuel_stations` (`location`, `owned`, `owner`, `fuel`, `fuelprice`, `balance`, `label`) VALUES (11, 0, '0', 100000, 3, 0, 'Great Ocean Xero');
INSERT INTO `fuel_stations` (`location`, `owned`, `owner`, `fuel`, `fuelprice`, `balance`, `label`) VALUES (12, 0, '0', 100000, 3, 0, 'Paleto Blvd Xero');
INSERT INTO `fuel_stations` (`location`, `owned`, `owner`, `fuel`, `fuelprice`, `balance`, `label`) VALUES (13, 0, '0', 100000, 3, 0, 'Paleto Ron');
INSERT INTO `fuel_stations` (`location`, `owned`, `owner`, `fuel`, `fuelprice`, `balance`, `label`) VALUES (14, 0, '0', 100000, 3, 0, 'Paleto Globe Oil');
INSERT INTO `fuel_stations` (`location`, `owned`, `owner`, `fuel`, `fuelprice`, `balance`, `label`) VALUES (15, 0, '0', 100000, 3, 0, 'Grapeseed LTD');
INSERT INTO `fuel_stations` (`location`, `owned`, `owner`, `fuel`, `fuelprice`, `balance`, `label`) VALUES (16, 0, '0', 100000, 3, 0, 'Sandy Shores Xero');
INSERT INTO `fuel_stations` (`location`, `owned`, `owner`, `fuel`, `fuelprice`, `balance`, `label`) VALUES (17, 0, '0', 100000, 3, 0, 'Sandy Shores Globe Oil');
INSERT INTO `fuel_stations` (`location`, `owned`, `owner`, `fuel`, `fuelprice`, `balance`, `label`) VALUES (18, 0, '0', 100000, 3, 0, 'Senora Freeway Xero');
INSERT INTO `fuel_stations` (`location`, `owned`, `owner`, `fuel`, `fuelprice`, `balance`, `label`) VALUES (19, 0, '0', 100000, 3, 0, 'Harmony Globe Oil');
INSERT INTO `fuel_stations` (`location`, `owned`, `owner`, `fuel`, `fuelprice`, `balance`, `label`) VALUES (20, 0, '0', 100000, 3, 0, 'Route 68 Globe Oil');
INSERT INTO `fuel_stations` (`location`, `owned`, `owner`, `fuel`, `fuelprice`, `balance`, `label`) VALUES (21, 0, '0', 100000, 3, 0, 'Route 68 Workshop Globe O');
INSERT INTO `fuel_stations` (`location`, `owned`, `owner`, `fuel`, `fuelprice`, `balance`, `label`) VALUES (22, 0, '0', 100000, 3, 0, 'Route 68 Xero');
INSERT INTO `fuel_stations` (`location`, `owned`, `owner`, `fuel`, `fuelprice`, `balance`, `label`) VALUES (23, 0, '0', 100000, 3, 0, 'Route 68 Ron');
INSERT INTO `fuel_stations` (`location`, `owned`, `owner`, `fuel`, `fuelprice`, `balance`, `label`) VALUES (24, 0, '0', 100000, 3, 0, "Rex\'s Diner Globe Oil");
INSERT INTO `fuel_stations` (`location`, `owned`, `owner`, `fuel`, `fuelprice`, `balance`, `label`) VALUES (25, 0, '0', 100000, 3, 0, 'Palmino Freeway Ron');
INSERT INTO `fuel_stations` (`location`, `owned`, `owner`, `fuel`, `fuelprice`, `balance`, `label`) VALUES (26, 0, '0', 100000, 3, 0, 'North Rockford LTD');
INSERT INTO `fuel_stations` (`location`, `owned`, `owner`, `fuel`, `fuelprice`, `balance`, `label`) VALUES (27, 0, '0', 100000, 3, 0, 'Alta Street Globe Oil');

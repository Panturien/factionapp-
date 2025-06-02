CREATE TABLE IF NOT EXISTS `jobs` (
  `name` varchar(50) NOT NULL,
  `label` varchar(50) DEFAULT NULL,
  `motd` longtext DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
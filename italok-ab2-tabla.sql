create database italbolt
character set utf8
collate utf8_hungarian_ci;

use italbolt;

DROP TABLE IF EXISTS `italok`;
CREATE TABLE IF NOT EXISTS `italok` (
  `megnevezes` varchar(120) NOT NULL,
  `ar` int NOT NULL,
  `nev` varchar(80) NOT NULL,
  `tipus` varchar(40) NOT NULL,
  `kiszereles` varchar(40) NOT NULL,
  `mennyiseg` double NOT NULL,
  `alkohol` double NOT NULL,
  `keszlet` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

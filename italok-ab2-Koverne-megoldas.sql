-- 1.feladat
CREATE VIEW cider AS
	SELECT * FROM italok
		WHERE tipus = 'cider' AND ar BETWEEN 200 and 400;
SELECT * FROM cider;

-- 2.feladat
CREATE VIEW keszlethiany AS
	SELECT * FROM italok
		WHERE nev = 'Stella Artois' AND keszlet < 72;
SELECT * FROM keszlethiany;

-- 3.feladat
DELIMITER //
CREATE FUNCTION alkohol_formaz(alkohol DOUBLE)
RETURNS VARCHAR(5)
BEGIN
	RETURN concat(alkohol * 100, '%');
END //
DELIMITER ;


-- 4.feladat
SELECT megnevezes, tipus, alkohol_formaz(alkohol) AS alkohol FROM italok;

-- 5.feladat
CREATE TABLE IF NOT EXISTS `eladas` (
  `megnevezes` varchar(120) NOT NULL,
  `nev` varchar(80) NOT NULL,
  `eladva_db` int NOT NULL,
  `ido` datetime NOT NULL  
);

-- 6.feladat
DELIMITER //
CREATE TRIGGER sor
BEFORE INSERT
ON italok
FOR EACH ROW
BEGIN
	IF 0.2 < NEW.alkohol THEN
		SIGNAL SQLSTATE 'HY000'
        SET MESSAGE_TEXT = 'A sörben kevesebb alkohol lehet!';
	END IF;
END //
DELIMITER ;

-- 7.feladat
DELIMITER //
CREATE PROCEDURE eladas_rogzitese(in mit VARCHAR(120), in mennyit INT)
	BEGIN
		UPDATE italok SET keszlet = keszlet - mennyit
			WHERE megnevezes = mit;
		INSERT INTO eladas(megnevezes, nev, eladva_db, ido) VALUES
			(mit, (SELECT nev FROM italok WHERE megnevezes = mit), mennyit, now());
END //
DELIMITER ;

SET autocommit = 0;
START TRANSACTION;

	CALL eladas_rogzitese('Paulaner 5% 5l - Partyhordó', 5);

DELIMITER //
IF(autocommit != 0) THEN
	ROLLBACK;
ELSE
	RETURN;
END IF;
DELIMITER ;

-- 8.feladat
SELECT nev, SUM(eladva_db) AS eladva FROM eladas
	GROUP BY nev;

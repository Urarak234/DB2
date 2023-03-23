
#----Tab persoane
CREATE TABLE Persoane (
	idPersoana INT PRIMARY key,
	Nume VARCHAR(50),
	Varsta INT 
)

INSERT INTO Persoane (idPersoana, Nume, Varsta) VALUES 
(1,'Elvi',19),
(2,'Farouk',19),
(3,'Sam',19),
(4,'Tiany',19),
(5,'Nadia',14),
(6,'Chris',12),
(7,'kris',10),
(8,'Bethany',16),
(9,'Louis',17),
(10,'Austin',22),
(11,'Gabriel',21),
(12,'Jessica',20),
(13,'John',16),
(14,'Alfred',19),
(15,'Samantha',17),
(16,'Craig',17);

SELECT * FROM Persoane

#----------Tab rude

CREATE TABLE Rude (
	idPersoana1 INT REFERENCES persoane(idpersoana),
	idPersoana2 INT REFERENCES persoane (idpersoana) 
	)


INSERT INTO Rude (idPersoana1, idPersoana2) VALUES 
(4,6),
(2,4),
(9,7),
(7,8),
(11,9),
(13,10),
(14,5),
(12,13)

SELECT * FROM rude 


#----------Tab Amici

CREATE TABLE Amici (
	idPersoana1 INT REFERENCES persoane(idpersoana),
	idPersoana2 INT REFERENCES persoane (idpersoana) 
)


INSERT INTO Amici (idPersoana1, idPersoana2) VALUES
(1,2),
(1,3),
(2,4),
(2,6),
(3,9),
(4,9),
(7,5),
(5,8),
(6,10),
(13,6),
(7,6),
(8,7),
(9,11),
(12,9),
(10,15),
(12,11),
(12,15),
(13,16),
(15,13),
(16,14)


SELECT * FROM amici 


# Ex1 


 delimiter $$
 CREATE TRIGGER trig1
 AFTER INSERT 
 	ON persoane
 	FOR EACH row
 BEGIN
 INSERT INTO amici(idpersoana1, idpersoana2)
 	VALUES (NEW.idPersoana, (SELECT persoane.idPersoana 
 									FROM persoane 
 									WHERE persoane.Nume = "Elvi"));
 END $$
 delimiter ;



SELECT * FROM persoane

SELECT * FROM amici

INSERT INTO persoane VALUES (17, 'Dan', 21);





#Ex2 

DELIMITER $$
CREATE TRIGGER trig2
before INSERT ON persoane
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT * FROM persoane WHERE Nume = NEW.Nume
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Atenție! Așa persoană există!';
    END IF;
END $$
DELIMITER ;

INSERT INTO persoane VALUES (19, 'Dan', 21);

SELECT * FROM persoane


# Ex3

DELIMITER $$
CREATE TRIGGER trig3
BEFORE INSERT   
	ON rude 
	FOR EACH ROW
BEGIN
	IF EXISTS (
    SELECT *
    FROM rude r
    LEFT JOIN amici a ON (r.idPersoana1 = a.idPersoana1 AND r.idPersoana2 = a.idPersoana2) OR (r.idpersoana1=a.idPersoana2 AND r.idpersoana2=a.idPersoana1)
    WHERE (r.idPersoana1 = NEW.idPersoana1 AND r.idPersoana2 = NEW.idPersoana2)
       OR (r.idPersoana1 = NEW.idPersoana2 AND r.idPersoana2 = NEW.idPersoana1)
       OR (a.idPersoana1 = NEW.idPersoana1 AND a.idPersoana2 = NEW.idPersoana2)
       OR (a.idPersoana1 = NEW.idPersoana2 AND a.idPersoana2 = NEW.idPersoana1)) 
	 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Asa pereche exista.';
ELSE
    INSERT INTO amici (idPersoana1, idPersoana2) VALUES (NEW.idPersoana1, NEW.idPersoana2);
END IF;
END $$
DELIMITER;

SELECT * FROM rude;
SELECT * FROM amici;

INSERT INTO rude VALUES (9,9);


#Ex4

delimiter $$
CREATE TRIGGER trig4
AFTER DELETE 
ON rude
FOR EACH ROW
BEGIN
	DELETE FROM amici
	WHERE (amici.idpersoana1 = OLD.idpersoana1 AND amici.idpersoana2 = OLD.idpersoana1)
		OR (amici.idpersoana1 = OLD.idpersoana2 AND amici.idpersoana2 = OLD.idpersoana1);
END $$
delimiter ;

SELECT * FROM rude;
SELECT * FROM amici;

DELETE FROM rude WHERE idpersoana1 = 9 AND idpersoana2 = 9;



# Ex5 


delimiter $$
CREATE TRIGGER trig5
BEFORE DELETE
ON persoane
FOR EACH ROW
BEGIN
	DELETE FROM rude
	WHERE OLD.idPersoana = rude.idpersoana1 OR OLD.idPersoana = rude.idpersoana2;
	DELETE FROM amici
	WHERE OLD.idPersoana = amici.idpersoana1 OR OLD.idPersoana = amici.idpersoana2;
END $$
delimiter ;

SELECT * FROM persoane;

SELECT * FROM rude;

SELECT * FROM amici;

DELETE FROM persoane WHERE idPersoana = 10;

# Ex6

delimiter $$
CREATE TRIGGER trig6
BEFORE INSERT 
ON amici
FOR EACH ROW
BEGIN 
	if NOT EXISTS (SELECT * 
						FROM persoane
						INNER JOIN persoane p
						WHERE p.idPersoana = NEW.Idpersoana1 AND p.idPersoana = NEW.Idpersoana2)
	Then 		
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Una sau ambele persoane nu exista';
	END if;
END $$
delimiter;

SELECT * FROM persoane 

INSERT INTO  amici (idPersoana1, idPersoana2) VALUES (50,90);
 
# Ex7

delimiter $$
CREATE TRIGGER trig7
AFTER UPDATE 
ON persoane 
FOR EACH ROW
BEGIN
	UPDATE amici 
 		SET amici.idpersoana1 = NEW.idPersoana 
 		WHERE amici.idpersoana1 = OLD.idPersoana;
 	UPDATE amici 
 		SET amici.idpersoana2 = NEW.idPersoana 
 		WHERE amici.idpersoana2 = OLD.idPersoana;
END $$
delimiter;
 
 SELECT * FROM persoane 
 
 SELECT * FROM amici 
 
UPDATE persoane
SET persoane.idPersoana = 201 WHERE persoane.idPersoana = 1;


# Ex8

 delimiter $$
CREATE TRIGGER trig8
BEFORE DELETE 
ON persoane
FOR EACH ROW
BEGIN
	DELETE 
 	FROM amici 
 	WHERE amici.idpersoana1 = OLD.idPersoana 
		OR amici.idpersoana2 = OLD.idPersoana;
END $$
delimiter ;


 SELECT * FROM persoane 
 
 SELECT * FROM amici 
 
DELETE FROM persoane WHERE persoane.idPersoana = 16;

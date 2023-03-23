/* table 1 articole

create table articole
(
   idarticol INT,
   denarticol VARCHAR(50),
   PRIMARY KEY (idarticol)
)
insert into articole  (idarticol,denarticol)
	VALUES
 (1, 'Articol1'),
 (2, 'Articol2'),
 (3, 'Articol3'),
 (4, 'Articol4'),
 (5, 'Articol5');
*/

/* table 2 universitate
CREATE TABLE universitate (
      iduniversitate INT(11) NOT NULL,
      denuniversitate TINYTEXT NOT NULL,
   PRIMARY KEY (iduniversitate)
   )

 INSERT INTO universitate (iduniversitate, denuniversitate) 
VALUES 
   (5, 'ARB'),
   (6, 'UTM'),
   (7, 'Asem');

*/

/* table 3 cercetatori
CREATE TABLE cercetatori (
      idcercetator INT(11) NOT NULL,
      numecercetător TINYTEXT NOT NULL,
      iduniversitate INT(11) NOT NULL,
   PRIMARY KEY (idcercetator)  )
  
INSERT INTO cercetatori (idcercetator, numecercetător, iduniversitate) 
 VALUES 	
(1, 'Dodu Petru', 1),
(2, 'Lungu Vasile', 2),
(3, 'Vrabie Maria', 1),
(4, 'Ombun Bogdan', 3);
 
*/

/* table 4 autori
CREATE TABLE autori (
      IdCercetator INT(11) NOT NULL,
      IdArticol INT(11) NOT NULL  	  
   );

INSERT INTO autori
   (IdCercetator, IdArticol) 
   VALUES 
   (1, 1),
   (2, 2),
   (3, 3),
   (4, 4);
   
   
<--Proceduri si functii----
*/
/* proced 1
delimiter $$   
CREATE PROCEDURE proc_lista_articole1 (IN id_cerc_param INT)
BEGIN
SELECT denarticol
FROM articole INNER JOIN autori
ON articole.idarticol = autori.idarticol
WHERE idcercetator = id_cerc_param
order by articole.denarticol;
END;$$
delimiter ;

CALL proc_lista_articole1(4);

*/


/* proced 2 
delimiter $$ 
 CREATE PROCEDURE proc_lista_cercet (IN id_univ INT)
 BEGIN
 	select cercetatori.numecercetător, articole.denarticol
 	from cercetatori
 	inner  join autori on autori.IdCercetator = cercetatori.idcercetator
 	inner  join articole on articole.idarticol = autori.IdArticol
 	where cercetatori.iduniversitate = id_univ;
 END;$$
 delimiter ;   

CALL proc_lista_cercet(1);

*/




/* proced 3

delimiter $$ 
 CREATE PROCEDURE proc_cerc_art ( id_univ INT)
 BEGIN
 	select cercetatori.numecercetător, articole.denarticol
 	from articole
   	INNER join autori on articole.idarticol = autori.IdArticol
	   RIGHT join cercetatori on autori.IdCercetator = cercetatori.idcercetator
 	WHERE cercetatori.iduniversitate = id_univ;
 END;$$
 delimiter;   
 



CALL proc_cerc_art(2);

*/



/* procedure 4




delimiter $$   
CREATE PROCEDURE proc_raiting ()
BEGIN
    DECLARE num_articole INT DEFAULT 0;
    DECLARE num_articole_univ INT DEFAULT 0;
    DECLARE total_art INT DEFAULT 0;
    
    SELECT count(autori.IdArticol) INTO total_art FROM autori;
    
	 select cercetatori.numecercetător ,(count(idarticol) / total_art)*100 as 'reitingul general',
     count(autori.IdArticol) /temp.reiting *100 as 'reitingul pe universitate'
    from cercetatori
    left join autori on autori.IdCercetator = cercetatori.idcercetator
	    INNER JOIN (
        select iduniversitate, count(iduniversitate) as reiting
        from cercetatori
        inner join autori on autori.IdCercetator = cercetatori.idcercetator
        group by  cercetatori.iduniversitate
    ) as temp on temp.iduniversitate = cercetatori.iduniversitate
    group by cercetatori.idcercetator;
END;$$
delimiter;


CALL proc_raiting()


*/

  

/*
-- procd 5
alter table cercetatori
-- DROP COLUMN calificativ
add column Calificativ VARCHAR(30) default NULL;
delimiter $$   
CREATE PROCEDURE proc_calificativ ()
BEGIN
    Declare counter Int;
    Declare art_cercet Int;
    select count(idcercetator) into counter
    from cercetatori;
    While counter > 0 DO
    SELECT count(idcercetator) INTO art_cercet
    from autori
	 WHERE idcercetator = counter;
        if art_cercet > 25 then
            update cercetatori
            set cercetatori.Calificativ = 'foarte bine'
            where cercetatori.idcercetator = counter;
            set counter = counter-1;
        ELSEIF  art_cercet >= 15 and art_cercet <=25  then
            update cercetatori
            set cercetatori.Calificativ = 'bine'
            where cercetatori.idcercetator = counter;
            set counter = counter-1;
        ELSEIF  art_cercet >= 5 and art_cercet <15  then
            update cercetatori
            set cercetatori.Calificativ = 'suficient'
            where cercetatori.idcercetator = counter;
            set counter = counter-1;
        else
            update cercetatori
            set cercetatori.Calificativ = 'insuficient'
            where cercetatori.idcercetator = counter;
            set counter = counter-1;
        end if;
    End while; 

END;$$
delimiter ;

CALL proc_calificativ();

*/

  

/*
-- procd 5
alter table cercetatori
-- DROP COLUMN calificativ
add column Calificativ VARCHAR(30) default NULL;
delimiter $$   
CREATE PROCEDURE proc_calificativ ()
BEGIN
    Declare counter Int;
    Declare art_cercet Int;
    select count(idcercetator) into counter
    from cercetatori;
    While counter > 0 DO
    SELECT count(idcercetator) INTO art_cercet
    from autori
	 WHERE idcercetator = counter;
        if art_cercet > 25 then
            update cercetatori
            set cercetatori.Calificativ = 'foarte bine'
            where cercetatori.idcercetator = counter;
            set counter = counter-1;
        ELSEIF  art_cercet >= 15 and art_cercet <=25  then
            update cercetatori
            set cercetatori.Calificativ = 'bine'
            where cercetatori.idcercetator = counter;
            set counter = counter-1;
        ELSEIF  art_cercet >= 5 and art_cercet <15  then
            update cercetatori
            set cercetatori.Calificativ = 'suficient'
            where cercetatori.idcercetator = counter;
            set counter = counter-1;
        else
            update cercetatori
            set cercetatori.Calificativ = 'insuficient'
            where cercetatori.idcercetator = counter;
            set counter = counter-1;
        end if;
    End while; 

END;$$
delimiter ;

CALL proc_calificativ();

*/


/*
delimiter $$   
CREATE PROCEDURE proc_stergere(n_cerc VARCHAR(20))
BEGIN
    DECLARE v_rez VARCHAR(70);
     SELECT IF(EXISTS(
     SELECT numecercetător,idcercetator
     FROM cercetatori
     WHERE n_cerc = numecercetător AND idcercetator NOT IN (SELECT idcercetator FROM autori)  
	  ),true ,"Nu exista asa cercetator sau sunt articole legate cu el" ) INTO v_rez;
END;$$
delimiter;


CALL proc_stergere("Dodu Petru");

*/

/*
prod 6
    

delimiter $$   
CREATE FUNCTION func_c_in_univ(v_cercet VARCHAR(50), v_univ INT)
RETURNS BOOL
DETERMINISTIC
BEGIN
    DECLARE v_rez  BOOL DEFAULT FALSE;
    SELECT IF(EXISTS(
             SELECT *
             FROM universitate
             inner join cercetatori on cercetatori.iduniversitate = universitate.iduniversitate
             WHERE universitate.iduniversitate = v_univ and cercetatori.numecercetător = v_cercet), true, false) into v_rez;
    return v_rez;
END;$$
delimiter;

select func_c_in_univ("Dodu Petru",1);

    
*/



/* procedura incercare 
delimiter $$   
CREATE PROCEDURE prod_incerc ()
BEGIN
  Declare counter Int DEFAULT 0;
   count(idcercetator) into counter
    from cercetatori;
END;$$
delimiter;
 
 
CALL prod_incerc ();

 */

-- ---------------------------Functions-------------------------------

/* functia ex 7

delimiter $$   
CREATE FUNCTION func_un(
    p_idcercet INT
)
RETURNS VARCHAR(20)
DETERMINISTIC 
BEGIN 
DECLARE v_denumire VARCHAR(20);
	SELECT denuniversitate INTO v_denumire
	FROM universitate AS U INNER JOIN cercetatori AS C ON U.iduniversitate = C.idcercetator
	WHERE cercetatori.idcercetator = p_idcercet;
	RETURN v_denumire;
END; $$
delimiter;

SELECT func_un(1);
*/

/*
-- funct 8

DELIMITER $$
CREATE FUNCTION func_id_calif (p_id_cerc INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
	DECLARE v_calif VARCHAR(20);
	SELECT calificativ INTO v_calif
	FROM cercetatori
	WHERE idcercetator = p_id_cerc;
	RETURN v_calif;
END;$$
DELIMITER;

SELECT func_id_calif(1)
*/


/*
-- funct ex 9


DELIMITER $$
CREATE FUNCTION func_by_denuniversitate (p_denuniver VARCHAR(20))
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE v_totalCercet INT;
	SELECT COUNT(cercetatori.iduniversitate) AS num_cercetatori INTO v_totalCercet
	FROM cercetatori INNER JOIN universitate ON cercetatori.iduniversitate = universitate.iduniversitate
	WHERE denuniversitate = p_denuniver;
	RETURN v_totalCercet;
END;$$
DELIMITER;


SELECT func_by_denuniversitate("USARB")

	SELECT cercetatori.iduniversitate AS num_cercetatori , idcercetator
	FROM cercetatori INNER JOIN universitate ON cercetatori.iduniversitate = universitate.iduniversitate
	WHERE denuniversitate = "USARB"
*/
/*
-- funct ex 10



DELIMITER $$
CREATE FUNCTION func_total_articole(p_iduniver INT)
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE v_totalArticole INT;
	SELECT COUNT(autori.idarticol) AS num_articole INTO v_totalArticole
	FROM cercetatori INNER JOIN autori ON cercetatori.idcercetator = autori.idcercetator INNER JOIN universitate ON universitate.iduniversitate = cercetatori.iduniversitate
	WHERE universitate.iduniversitate = p_iduniver;
	RETURN v_totalArticole;
END;$$
DELIMITER;

SELECT func_total_articole(3);

*/

/*
-- funct ex 11
DELIMITER $$
CREATE FUNCTION func_articole_by_cercetator(p_numcercet VARCHAR(100))
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE v_totalArticole INT;
	SELECT COUNT(autori.idarticol) AS num_articole INTO v_totalArticole
	FROM cercetatori INNER JOIN autori ON cercetatori.idcercetator = autori.idcercetator
	WHERE cercetatori.numecercetător = p_numcercet;
	RETURN v_totalArticole;
END;$$
DELIMITER;

SELECT func_articole_by_cercetator("Dodu Petru");

*/

/*
-- func ex 12


delimiter $$   
CREATE FUNCTION func_c_in_univ(v_cercet VARCHAR(50), v_univ INT)
RETURNS BOOL
DETERMINISTIC
BEGIN
    DECLARE v_rez  BOOL DEFAULT FALSE;
    SELECT IF(EXISTS(
             SELECT *
             FROM universitate
             inner join cercetatori on cercetatori.iduniversitate = universitate.iduniversitate
             WHERE universitate.iduniversitate = v_univ and cercetatori.numecercetător = v_cercet), true, false) into v_rez;
    return v_rez;
END;$$
delimiter;

select func_c_in_univ("Dodu Petru",3);

*/
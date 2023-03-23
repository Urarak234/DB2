/*
CREATE TABLE cercetatori_copy LIKE cercetatori;
INSERT INTO cercetatori_copy SELECT * FROM cercetatori;
SELECT * FROM cercetatori_copy



delimiter $$ 
CREATE PROCEDURE p_cursor1 (p_iduniv INT) 
BEGIN  
 DECLARE finisare INT DEFAULT 0; 
 DECLARE v_idcerc INT ; 
 DECLARE contor INT DEFAULT 0; 
 DECLARE c_stergere CURSOR for 
  SELECT idcercetator  
  FROM cercetatori_copy 
  WHERE iduniversitate = p_iduniv; 
   
 DECLARE CONTINUE handler 
 FOR NOT FOUND SET finisare = 1; 
  
 OPEN c_stergere; 
 et1: loop  
  fetch c_stergere INTO v_idcerc; 
  if finisare  = 1 then 
   leave et1; 
  END if; 
  DELETE FROM cercetatori_copy  
   WHERE idcercetator = v_idcerc; 
  SET contor = contor + 1; 
 END loop et1; 
 close c_stergere; 
 SELECT contor; 
END;$$ 
delimiter; 

-- стираем cercetatori по параметру id universitate
call p_cursor1(1);
 */
 
 
 
 
/*

ex1

delimiter $$ 
CREATE PROCEDURE p_cursor1 (p_iduniv INT) 
BEGIN  
 DECLARE finisare INT DEFAULT 0; 
 DECLARE v_idcerc INT ; 
 DECLARE contor INT DEFAULT 0; 
 DECLARE c_stergere CURSOR for 
  SELECT idcercetator  
  FROM cercetatori_copy 
  WHERE iduniversitate = p_iduniv; 
   
 DECLARE CONTINUE handler 
 FOR NOT FOUND SET finisare = 1; 
  
 OPEN c_stergere; 
 et1: loop  
  fetch c_stergere INTO v_idcerc; 
  if finisare  = 1 then 
   leave et1; 
  END if; 
  DELETE FROM cercetatori_copy  
   WHERE idcercetator = v_idcerc; 
  SET contor = contor + 1; 
 END loop et1; 
 close c_stergere; 
 SELECT contor; 
END;$$ 
delimiter; 
 
CALL p_cursor1(1);
*/





/* создаём cursor_2

creem tabel temporar pentru datele ce vor 
CREATE TABLE tab_temp(
nume VARCHAR(50),
univers VARCHAR(50)
)

-- Инициируем курсор для cercetatorii каторый имеет минимум 2 артикля
DROP PROCEDURE IF EXISTS curs_2;

DELIMITER $$

CREATE PROCEDURE curs_2()
BEGIN
    DECLARE Nume VARCHAR(255);
    DECLARE Univers VARCHAR(255);
    DECLARE done bool DEFAULT FALSE;
    
    -- Инициируем курсор для cercetatorii, который имеет минимум 2 артикля
    DECLARE cursor_articole CURSOR FOR 
    SELECT c.`numecercetător`, u.denuniversitate
    FROM Cercetatori C
    left JOIN Autori A ON C.idcercetator = A.idcercetator
    LEFT JOIN Universitate U ON C.iduniversitate = U.iduniversitate
    GROUP BY C.`numecercetător`, U.denuniversitate
    HAVING COUNT(A.idarticol) >= 2;
    
    
    -- Инициируем курсор для cercetatorii, который имеет 1 артикль
    DECLARE cursor_un_articol CURSOR FOR 
    SELECT c.`numecercetător`, u.denuniversitate
    FROM Cercetatori C
    left JOIN Autori A ON C.idcercetator = A.idcercetator
    LEFT JOIN Universitate U ON C.iduniversitate = U.iduniversitate
    GROUP BY C.`numecercetător`, U.denuniversitate
    HAVING COUNT(A.idarticol) = 1;
    
    DECLARE CONTINUE handler 
    FOR NOT FOUND SET done = 1; 
    -- Afisam antetul pentru primul cursor
    INSERT INTO tab_temp SELECT 'Cercetatori ','cu cel putin doua articole:';
    
    -- Раскрываем первый курсор и выводим резуьтат
    
    OPEN cursor_articole;
    read_loop: LOOP
        FETCH cursor_articole INTO Nume, Univers;
        IF done THEN
            LEAVE read_loop;
        END IF;
		  INSERT INTO tab_temp SELECT Nume, Univers ;
    END LOOP;
    CLOSE cursor_articole;
    
    -- Линия между двумя задачами
    
   	INSERT INTO tab_temp SELECT '----------------------------','------------------------';
    
    -- Заголовок второго курсора
    
    	  INSERT INTO tab_temp SELECT 'Cercetatori',' cu un singur articol:';
    
    set done = FALSE;
    -- Выполняем второй курсор и выводим результат
    OPEN cursor_un_articol;
    read_loop: LOOP
        FETCH cursor_un_articol INTO Nume, Univers;
        IF done THEN
            LEAVE read_loop;
        END IF;
		  INSERT INTO tab_temp SELECT Nume, Univers ;
    END LOOP;
    CLOSE cursor_un_articol;
END;$$

DELIMITER ;

-- Выполнем процедуру
CALL curs_2;

-- Выводим данные из временной таблицы
SELECT * FROM tab_temp

-- Стираем данные из таблицы
DELETE FROM tab_temp

*/



/*
DROP PROCEDURE IF EXISTS curs_3;

DELIMITER $$
CREATE PROCEDURE curs_3()
BEGIN
    DECLARE nume1 VARCHAR(255) DEFAULT '';
    DECLARE nume2 VARCHAR(255) DEFAULT '';
    DECLARE nume3 VARCHAR(255) DEFAULT '';
    DECLARE done BOOL DEFAULT false;
    
    -- Инициируем курсор для первых полей nume предпринемателей, отсортированных по возрастанию
    DECLARE curs_cercetatori CURSOR FOR 
    SELECT `numecercetător` 
    FROM Cercetatori 
    ORDER BY `numecercetător` ASC 
    LIMIT 3;
    
    DECLARE CONTINUE HANDLER 
	 FOR NOT FOUND SET done = 1; 
    
    -- Выполняем курсор и выводим значения имени предпринимателя
    OPEN curs_cercetatori;
    read_loop: LOOP
        FETCH curs_cercetatori INTO nume1;
        IF done THEN
            LEAVE read_loop;
        END IF;
        FETCH curs_cercetatori INTO nume2;
        IF done THEN
            LEAVE read_loop;
        END IF;
        FETCH curs_cercetatori INTO nume3;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Выводим сообщение, привязанные к имени предпринимателей
        SELECT CONCAT('primul nume = ', nume1) union
        SELECT CONCAT('al doilea nume = ', nume2) union
        SELECT CONCAT('al treilea nume = ', nume3);
    END LOOP;
    CLOSE curs_cercetatori;
    
END$$
DELIMITER ;

CALL curs_3;

*/


/* cursor_4
creem tabel temporar pentru datele temp

CREATE TABLE tab_temp4(
nume VARCHAR(250)
)



DROP PROCEDURE IF EXISTS curs_4;

DELIMITER $$

CREATE PROCEDURE curs_4()
BEGIN
    DECLARE done BOOL DEFAULT false;
    DECLARE nume_cercetator VARCHAR(255);
    DECLARE prenume_cercetator VARCHAR(255);
    DECLARE numar_articole INT;
    DECLARE rezultat VARCHAR(255);
    
    -- Инициируем курсор для каждого предпринимателя
    DECLARE curs_cercetator CURSOR FOR 
    SELECT SUBSTRING_INDEX(`numecercetător`, ' ', 1),
       SUBSTRING_INDEX(`numecercetător`, ' ', -1),
       COUNT(autori.idarticol)
		FROM cercetatori
	 RIGHT JOIN autori ON autori.IdCercetator = cercetatori.idcercetator
	 GROUP BY numecercetător;           
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; 
    
    -- Выполняем курсор и выводим кол-во артиклей для каждого предпринимателя
    OPEN curs_cercetator;
    read_loop: LOOP
        FETCH curs_cercetator INTO nume_cercetator, prenume_cercetator, numar_articole;
        IF done THEN
            LEAVE read_loop;
        END IF;
        -- Afisam informatiile despre cercetator si numarul de articole
        INSERT INTO tab_temp4 SELECT CONCAT('Nume - ', nume_cercetator, ', prenume - ', prenume_cercetator, ', articole - ', numar_articole);
		  
    END LOOP;
    CLOSE curs_cercetator;
    
END$$

DELIMITER ;

-- Вызываем курсор
CALL curs_4;

-- Выводим данные из временной таблицы
SELECT * FROM tab_temp4

-- Стираем данные из временной таблицы 
DELETE FROM tab_temp4
	
*/


/*
cursor_5
Создаём временную таблицу temp

CREATE TABLE tab_temp5(
nume VARCHAR(250)
)

DROP PROCEDURE IF EXISTS curs_5;
DELIMITER $$

CREATE PROCEDURE curs_5()
BEGIN
    DECLARE done BOOL DEFAULT false;
    DECLARE nume_cercetator VARCHAR(255);
    DECLARE nume_articol VARCHAR(255);
    
    -- Инициируем курсор для каждого предпринимателя
    DECLARE curs_articole CURSOR FOR 
    SELECT denarticol, `numecercetător`
	 FROM autori
	 INNER JOIN articole ON articole.idarticol = autori.IdArticol
	 INNER JOIN cercetatori ON cercetatori.idcercetator = autori.IdCercetator;
         
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; 
    
    -- Выполняем курсор и выводим номер артиклядля каждого предпринимателя
    OPEN curs_articole;
    read_loop: LOOP
        FETCH curs_articole INTO nume_cercetator, nume_articol;
        IF done THEN
            LEAVE read_loop;
        END IF;
        -- Выводим инфу о каждом предпринимателе и номере артикля
        INSERT INTO tab_temp5 SELECT CONCAT('Denumirea articolului - ',  nume_cercetator  , ', autori - ', nume_articol);
		  
    END LOOP;
    CLOSE curs_articole;
    
END$$

DELIMITER ;

  
-- Вызываем курсор

CALL curs_5;

-- Выводим данные из временной таблицы

SELECT * FROM tab_temp5

-- Стираем данные из временной таблицы
DELETE FROM tab_temp5


*/

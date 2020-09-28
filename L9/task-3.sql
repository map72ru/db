-- Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
-- С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
-- с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
-- с 18:00 до 00:00 — "Добрый вечер", 
-- с 00:00 до 6:00 — "Доброй ночи".

drop function if exists hello$$

create function hello() returns varchar(30) deterministic
begin
	declare hours int default hour(now());
	case
		when hours >= 0 and hours < 6 then RETURN 'Доброй ночи!';
		when hours >= 6 and hours < 12 then RETURN 'Доброго утра!';
		when hours >= 12 and hours < 18 then RETURN 'Доброго дня!';
		when hours >= 18 and hours <= 23 then RETURN 'Доброго вечера!';
	end case;
end$$

select hello()$$
-- Результат

-- Доброй ночи!

-- В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
-- Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное 
-- значение NULL неприемлема. Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля 
-- были заполнены. При попытке присвоить полям NULL-значение необходимо отменить операцию.

drop procedure if exists check_products$$

create procedure check_products(name varchar(255), description text)
begin
	if (name is null and description is null) THEN 
	SIGNAL SQLSTATE '23000' SET 
      MYSQL_ERRNO = 1452,
      MESSAGE_TEXT = 'Название или описание товара должно быть задано!';
	END IF;
end$$

drop trigger if exists check_name_description_ins;

create trigger check_name_description_ins BEFORE INSERT ON products
  FOR EACH ROW
  BEGIN
	  call check_products(new.name, new.description);
  END$$
  
drop trigger if exists check_name_description_upd;

create trigger check_name_description_upd BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
	call check_products(new.name, new.description);
END$$

-- (по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи. 
-- Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел. 
-- Вызов функции FIBONACCI(10) должен возвращать число 55.

drop function if exists fibonacci$$

CREATE FUNCTION fibonacci(n int) RETURNS LONG DETERMINISTIC 
BEGIN 
	DECLARE prev_1 LONG DEFAULT 0;
	DECLARE prev_2 LONG DEFAULT 0;
	DECLARE prev_3 LONG DEFAULT 0;
	DECLARE i INT DEFAULT 0;
	if (n >= 2) THEN 
		WHILE i < n DO 
			if (i = 0) THEN SET prev_1 = 0;
			ELSEIF (i = 1) THEN SET prev_1 = 1;
			ELSE 
				SET prev_1 = prev_2 + prev_3; 
			END IF;	
			SET prev_3 = prev_2;
			SET prev_2 = prev_1;
			SET i = i + 1;
		end WHILE;
		RETURN prev_3 + prev_2;
	ELSEif (n <= -2) THEN
		WHILE i > n DO 
			IF (i = 0) THEN SET prev_1 = 0;
			ELSEIF (i = -1) THEN SET prev_1 = 1;
			ELSE 
				SET prev_1 = prev_2 - prev_3; 
			END IF;	
			SET prev_2 = prev_3;
			SET prev_3 = prev_1;
			SET i = i - 1;
		end WHILE;
		RETURN prev_2 - prev_3;
	ELSE 
		RETURN ABS(n);
	END IF;
END$$


SELECT fibonacci(10)$$
-- Результат
-- 55

SELECT fibonacci(-10)$$
-- Результат
-- -55


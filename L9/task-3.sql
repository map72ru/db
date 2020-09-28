-- �������� �������� ������� hello(), ������� ����� ���������� �����������, � ����������� �� �������� ������� �����. 
-- � 6:00 �� 12:00 ������� ������ ���������� ����� "������ ����", 
-- � 12:00 �� 18:00 ������� ������ ���������� ����� "������ ����", 
-- � 18:00 �� 00:00 � "������ �����", 
-- � 00:00 �� 6:00 � "������ ����".

drop function if exists hello$$

create function hello() returns varchar(30) deterministic
begin
	declare hours int default hour(now());
	case
		when hours >= 0 and hours < 6 then RETURN '������ ����!';
		when hours >= 6 and hours < 12 then RETURN '������� ����!';
		when hours >= 12 and hours < 18 then RETURN '������� ���!';
		when hours >= 18 and hours <= 23 then RETURN '������� ������!';
	end case;
end$$

select hello()$$
-- ���������

-- ������ ����!

-- � ������� products ���� ��� ��������� ����: name � ��������� ������ � description � ��� ���������. 
-- ��������� ����������� ����� ����� ��� ���� �� ���. ��������, ����� ��� ���� ��������� �������������� 
-- �������� NULL �����������. ��������� ��������, ��������� ����, ����� ���� �� ���� ����� ��� ��� ���� 
-- ���� ���������. ��� ������� ��������� ����� NULL-�������� ���������� �������� ��������.

drop procedure if exists check_products$$

create procedure check_products(name varchar(255), description text)
begin
	if (name is null and description is null) THEN 
	SIGNAL SQLSTATE '23000' SET 
      MYSQL_ERRNO = 1452,
      MESSAGE_TEXT = '�������� ��� �������� ������ ������ ���� ������!';
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

-- (�� �������) �������� �������� ������� ��� ���������� ������������� ����� ���������. 
-- ������� ��������� ���������� ������������������ � ������� ����� ����� ����� ���� ���������� �����. 
-- ����� ������� FIBONACCI(10) ������ ���������� ����� 55.

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
-- ���������
-- 55

SELECT fibonacci(-10)$$
-- ���������
-- -55


drop table if exists logs;

create table logs(
	id int auto_increment primary key,
	created_at datetime not null default current_timestamp,
	table_name varchar(30) not null,
	target_id int not null,
	target_name varchar(255) not null
) comment = 'Таблицa журнала' engine=Archive; 

DELIMITER $$

CREATE TRIGGER users_logs AFTER INSERT ON users FOR EACH ROW
BEGIN 
	INSERT INTO logs (table_name, target_id, target_name) values ('users', new.id, new.name);
END$$

INSERT INTO users (name, birthday_at) VALUES
  ('Евгений', '1962-11-07')$$
  
  select * from logs$$
  
  -- 1	2020-10-04 23:01:23.0	users	7	Евгений

CREATE TRIGGER producs_logs AFTER INSERT ON products FOR EACH ROW
BEGIN 
	INSERT INTO logs (table_name, target_id, target_name) values ('products', new.id, new.name);
END$$

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('Intel Core i9-9100', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 19999.00, 1)$$
  
Select * from logs$$
  
-- 2	2020-10-04 23:03:38.0	products	8	Intel Core i9-9100
  
  
CREATE TRIGGER catalogs_logs AFTER INSERT ON catalogs FOR EACH ROW
BEGIN 
	INSERT INTO logs (table_name, target_id, target_name) values ('catalogs', new.id, new.name);
END$$

INSERT INTO catalogs (name) VALUES ('Корпус')$$

Select * from logs$$

-- 3	2020-10-04 23:06:04.0	catalogs	6	Корпус


-- (по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей.

DROP TABLE IF EXISTS users$$

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели'$$

INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29')$$


drop temporary table if exists names$$

create table names (
	name varchar(25) 
)$$

drop table if exists birthdays$$
create table birthdays (
	birthday date 
)$$

insert into names values
('Василий'),
('Юрий'),
('Семен'),
('Андрей'),
('Петр'),
('Серафима'),
('Клавдия'),
('Надежла'),
('Марина'),
('Наталья'),
('Тимур'),
('Александр'),
('Федор'),
('Федот'),
('Прасковья'),
('Прохор'),
('Егор'),
('Евгений'),
('Любовь'),
('Вера'),
('Вероника'),
('Алексей'),
('Анатолий'),
('Станислав'),
('Григорий'),
('Ярослав'),
('Геннадий'),
('Оксана'),
('Павел'),
('Сергей'),
('Степан'),
('Юрий'),
('Ольга'),
('Патрик')$$

insert into birthdays values
('1987-06-21'),
('1999-02-04'),
('2001-11-25'),
('1985-02-14'),
('1986-06-30'),
('1985-12-27'),
('1978-03-06'),
('1975-07-03'),
('1965-04-30'),
('1995-12-10'),
('1983-09-30'),
('1984-05-06'),
('1978-04-25'),
('1969-06-08'),
('1972-05-19'),
('1968-02-09'),
('1974-11-16'),
('2002-10-18'),
('1987-08-14'),
('1992-07-15'),
('1993-11-24'),
('1881-05-07'),
('1974-12-18'),
('1973-01-01'),
('1984-10-28'),
('1986-11-30'),
('1969-10-23'),
('1972-12-07'),
('1952-04-28'),
('1962-05-05'),
('1978-11-01'),
('1979-08-04'),
('1968-07-25'),
('1998-06-21')$$

insert into users (name, birthday_at)
(select a1.* from (select * from names join birthdays) a1 join (select * from names join birthdays) a2)$$

select count(*) from users$$ 

-- 1336342




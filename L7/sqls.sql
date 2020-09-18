-- Сгенерируем данные о заказах (для большего кол-ва cross join с продуктами), исключая пользователя с ид = 2
insert into orders(user_id) (SELECT u.id from users u, products p where u.id != 2);
-- Проверяем
SELECT * from orders o;
-- Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
select * from users u where id in (select user_id from orders o);
-- либо
SELECT distinct u2.* from users u2 join orders o on u2.id = o.user_id;
-- Выведите список товаров products и разделов catalogs, который соответствует товару.
-- Результат
-- 1	Геннадий	1990-10-05	2020-09-18 22:47:02.0	2020-09-18 22:47:02.0
-- 3	Александр	1985-05-20	2020-09-18 22:47:02.0	2020-09-18 22:47:02.0
-- 4	Сергей		1988-02-14	2020-09-18 22:47:02.0	2020-09-18 22:47:02.0
-- 5	Иван		1998-01-12	2020-09-18 22:47:02.0	2020-09-18 22:47:02.0
-- 6	Мария		1992-08-29	2020-09-18 22:47:02.0	2020-09-18 22:47:02.0

SELECT p.name, p.description, p.price, c.name from products p join catalogs c on p.catalog_id = c.id;
-- Результат
-- Intel Core i3-8100		Процессор для настольных персональных компьютеров, основанных на платформе Intel.	7890.00		Процессоры
-- Intel Core i5-7400		Процессор для настольных персональных компьютеров, основанных на платформе Intel.	12700.00	Процессоры
-- AMD FX-8320E				Процессор для настольных персональных компьютеров, основанных на платформе AMD.		4780.00		Процессоры
-- AMD FX-8320				Процессор для настольных персональных компьютеров, основанных на платформе AMD.		7120.00		Процессоры
-- ASUS ROG MAXIMUS X HERO	Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX			19310.00	Материнские платы
-- Gigabyte H310M S2H		Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX				4790.00		Материнские платы
-- MSI B250M GAMING PRO		Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX				5060.00		Материнские платы

-- (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
-- Поля from, to и label содержат английские названия городов, поле name — русское. 
-- Выведите список рейсов flights с русскими названиями городов.
DROP TABLE IF EXISTS flights;
create table flights (
id serial primary key,
`from` varchar(10) not null,
`to` varchar(10) not null);

insert into flights (`from`, `to`) values 
('moscow', 'omsk'),
('novgorod', 'kazan'),
('irkutsk', 'moscow'),
('omsk', 'irkutsk'),
('moscow', 'kazan');


DROP TABLE IF EXISTS cities;
create table cities (
id serial primary key,
label varchar(10) not null,
name varchar(10) not null);

insert into cities (label, name) values 
('moscow', 'Москва'),
('novgorod', 'Новгород'),
('irkutsk', 'Иркутск'),
('omsk', 'Омск'),
('kazan', 'Казань');

SELECT c.name `from`, c2.name `to` from flights f join cities c on f.`from`= c.label join cities c2 on f.`to` = c2.label;
-- Результат
-- Иркутск	Москва
-- Омск		Иркутск
-- Москва	Омск
-- Новгород	Казань
-- Москва	Казань
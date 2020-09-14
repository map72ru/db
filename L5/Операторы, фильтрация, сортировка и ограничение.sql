-- Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем
update users set created_at = now(), updated_at = now();
-- Проверка
SELECT * from users;
-- Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них 
-- долгое время помещались значения в формате 20.10.2017 8:10. Необходимо преобразовать поля к типу DATETIME, 
-- сохранив введённые ранее значения.

-- Сделаем таблицу с "не правильными полями" (что бы не портить оригинальную таблицу)
create table users_1 as select id, name, birthday_at, DATE_FORMAT(created_at, '%d.%m.%Y %H:%i') as created_at, DATE_FORMAT(updated_at, '%d.%m.%Y %H:%i') as updated_at
from users;
-- смотрим новую таблицу users_1
desc users_1;

select * from users_1;
-- Обратное преобразорвание
 create table users_temp as select id, name, birthday_at, str_to_date(created_at, '%d.%m.%Y %H:%i') as created_at, str_to_date(updated_at, '%d.%m.%Y %H:%i') as updated_at
from users_1;
-- смотрим темповую таблицу
select * from users_temp;
-- Удаляем исходную таблицу с не правильными полями
drop table users_1;
-- переименовывем таблицу
rename table users_temp to users_1;
-- В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, 
-- если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, 
-- чтобы они выводились в порядке увеличения значения value. Однако нулевые запасы должны выводиться в конце, после всех

-- Данных нет, надо их сгененировать
insert into storehouses(name) values ("Основной склад");
insert into storehouses_products (storehouse_id, product_id, value) (select 1, id, floor(rand()*100) from products);
-- проставим 0 для позиций 3 и 5
update storehouses_products set value = 0 where id in (3,5);
-- Сортировка с нулями в конце
SELECT * from storehouses_products order by value = 0, value;
-- (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. 
-- Месяцы заданы в виде списка английских названий (may, august)
select * from users u where date_format(u.birthday_at, "%M") in ('may', 'august');
-- (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2); 
-- Отсортируйте записи в порядке, заданном в списке IN.
SELECT * FROM catalogs WHERE id IN (5, 1, 2) order by field(id, 5, 1, 2);







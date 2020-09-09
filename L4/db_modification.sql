-- справочник типов файлов
select * from vk.media_types;
-- Удалим "неподходящие" типы
delete from vk.media_types where name like 'text%' or name like 'application%';
-- Возмьмем за дату запуска 2016 год. Все что ранее - не правильно
select * from vk.media_types where YEAR(created_at) < 2016;
-- Исправим дату вставки записи
update vk.media_types set created_at = NOW() - interval FLOOR(RAND()*1000) day where YEAR(created_at) < 2016;
-- Дата вставки не может быть больше даты изменения
select * from vk.media_types where created_at > updated_at;
--Исправим дату изменения, что бы она была больше даты начала
update vk.media_types set updated_at = LEAST(created_at + interval FLOOR(RAND()*100) day, now()) where created_at > updated_at;
-- справочник сообществ
select * from vk.communities;
-- Исправим дату вставки записи
update vk.communities set created_at = NOW() - interval FLOOR(RAND()*1000) day where YEAR(created_at) < 2016;
-- Дата вставки не может быть больше даты изменения
select * from vk.communities where created_at > updated_at;
--Исправим дату изменения, что бы она была больше даты начала
update vk.communities set updated_at = LEAST(created_at + interval FLOOR(RAND()*100) day, now()) where created_at > updated_at;
-- таблицв users
select * from vk.users order by id;
-- Что бы почта была "похожа" на пользовательскую
SELECT CONCAT(first_name, '.' , last_name, SUBSTRING(email, LOCATE('@', email))) email FROM vk.users u;
-- Странная ошибка: Duplicate errorю Поэтому исключим эту строку
update vk.users SET email = CONCAT(first_name, '.' , last_name, SUBSTRING(email, LOCATE('@', email))) where first_name != 'Jazmyn' and last_name != 'Trantow';
-- Таких записей нет, поэтому не понятно, почему была ошибка
select * from vk.users u where u.email like 'Jazmyn.Trantow%';
-- Исправим дату вставки записи
update vk.users set created_at = NOW() - interval FLOOR(RAND()*1000) day where YEAR(created_at) < 2016;
-- Дата вставки не может быть больше даты изменения (нет таких)
select * from vk.users where created_at > updated_at;
-- Профиль пользователя
SELECT * from vk.profiles;
-- Таблица статусов пользователей
CREATE TABLE user_statuses (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  name VARCHAR(100) NOT NULL COMMENT "Название статуса (уникально)",
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Справочник стран";  

UPDATE profiles SET status = null;

SELECT * FROM user_statuses;

INSERT INTO user_statuses (name) VALUES
 ('Мы в том месте'),
 ('Я + ты'),
 ('Ты + Я'),
 ('Я всегда готов');

ALTER TABLE profiles RENAME COLUMN status TO user_status_id; 

ALTER TABLE profiles MODIFY COLUMN user_status_id INT UNSIGNED; 

-- Добавляем ссылки на статус пользователя
UPDATE vk.profiles SET user_status_id = FLOOR(1 + RAND() * 4);
-- Исправим дату вставки записи
update vk.profiles set created_at = NOW() - interval FLOOR(RAND()*1000) day where YEAR(created_at) < 2016;
-- Дата вставки не может быть больше даты изменения (нет таких)
select * from vk.communities where created_at > updated_at;
-- принадлежность пользователя группе
SELECT * from communities_users cu; 
-- Возмьмем за дату запуска 2016 год. Все что ранее - не правильно
select * from vk.communities_users where YEAR(created_at) < 2016;
-- Исправим дату вставки записи
update vk.communities_users set created_at = NOW() - interval FLOOR(RAND()*1000) day where YEAR(created_at) < 2016;
-- Справочник статусов отношений
SELECT * from vk.friendship_statuses fs; 
-- удалим лишнее
DELETE FROM vk.friendship_statuses where id > 5;
-- Сделаем вменяемые статусы
UPDATE vk.friendship_statuses set name = CASE 
	WHEN ID=1 THEN 'Дружим' 
	WHEN ID=2 THEN 'Очень сильно дружим' 
	WHEN ID=3 THEN 'Не можем друг без друга' 
	WHEN id=4 THEN 'Враги' 
	WHEN id=5 THEN 'Никто' 
	END;
-- Возмьмем за дату запуска 2016 год. Все что ранее - не правильно
select * from vk.friendship_statuses where YEAR(created_at) < 2016;	
-- Исправим дату вставки записи
update vk.friendship_statuses set created_at = NOW() - interval FLOOR(RAND()*1000) day where YEAR(created_at) < 2016;
-- Дата вставки не может быть больше даты изменения (нет таких)
select * from vk.communities where created_at > updated_at;
-- Переименуем таблицу отношений пользователей
RENAME TABLE vk.friendship TO vk.friendships;
-- Анализ таблицы отношений
SELECT * from vk.friendships;
-- Изменим статусы
UPDATE friendships SET status_id = FLOOR(1 + RAND() * 5);
-- Исправим дату отправки запроса на отношения
update vk.friendships set requested_at = NOW() - interval FLOOR(RAND()*1000) day where YEAR(requested_at) < 2016;
-- Исправим дату подтверждения запроса на отношения
update vk.friendships set confirmed_at = LEAST((requested_at + interval FLOOR(RAND()*10) day), now()) where confirmed_at < requested_at;
-- Возмьмем за дату запуска 2016 год. Все что ранее - не правильно
select * from vk.friendships where YEAR(created_at) < 2016;	
-- Исправим дату вставки записи
update vk.friendships set created_at = NOW() - interval FLOOR(RAND()*1000) day where YEAR(created_at) < 2016;
-- Сообщения пользователей (самому себе - 3 записи)
SELECT * from vk.messages where from_user_id = to_user_id;
-- нельзя отправить самому себе
UPDATE vk.messages m set to_user_id = (SELECT ID from vk.users u WHERE u.id != m.from_user_id ORDER BY RAND() LIMIT 1) where from_user_id = to_user_id;
--
SELECT * from vk.messages;
-- Исправим дату вставки записи
update vk.messages set created_at = NOW() - interval FLOOR(RAND()*1000) day where YEAR(created_at) < 2016;
-- Дата вставки не может быть больше даты изменения (нет таких)
select * from vk.messages where created_at > updated_at;
-- Исправим дату изменения, что бы она была больше даты начала
update vk.messages set updated_at = LEAST(created_at + interval FLOOR(RAND()*100) day, now()) where created_at > updated_at;
-- Медиа-файлы
SELECT * from vk.media m;
-- Исправим типы файлов
UPDATE vk.media m set media_type_id = (SELECT ID from vk.media_types u ORDER BY RAND() LIMIT 1);
-- Добавим клонку с расширениями файлов, похожими на mime тип
ALTER TABLE vk.media_types ADD COLUMN EXT VARCHAR(10);
UPDATE vk.media_types SET EXT = CASE 
	WHEN ID=3 THEN 'rfc'
	WHEN ID=5 THEN 'gpp'
	WHEN ID=24 THEN 'msv'
	WHEN ID=25 THEN 'pyv'
	WHEN ID=28 THEN 'ktx'
	WHEN ID=29 THEN 'jpeg'
	WHEN ID=31 THEN 'djvu'
	WHEN ID=34 THEN 'gtw'
	WHEN ID=38 THEN 'flac'
	WHEN ID=40 THEN 'qt'
	WHEN ID=42 THEN 'vrml'
	WHEN ID=50 THEN 'iges'
END;

-- Исправим названия файлов
UPDATE vk.media m set m.filename = CONCAT('/FST/USERS/', m.filename, '.', (SELECT EXT from vk.media_types where ID=m.media_type_id));
-- Удалим временную колонку
ALTER TABLE vk.media_types DROP COLUMN EXT;
-- Изменим тип колонки на правильный
ALTER TABLE vk.media MODIFY COLUMN metadata JSON;
-- Проставим значение
UPDATE vk.media m set m.metadata = CONCAT('{"owner":"',(SELECT CONCAT(first_name, ' ', last_name) from vk.users where id=m.user_id), '"}'); 
-- Исправим дату вставки записи
update vk.media set created_at = NOW() - interval FLOOR(RAND()*1000) day where YEAR(created_at) < 2016;
-- Исправим дату изменения, что бы она была больше даты начала
update vk.media set updated_at = LEAST(created_at + interval FLOOR(RAND()*100) day, now()) where created_at > updated_at;

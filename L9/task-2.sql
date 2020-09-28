-- —оздайте двух пользователей которые имеют доступ к базе данных shop. 
-- ѕервому пользователю shop_read должны быть доступны только запросы на 
-- чтение данных, второму пользователю shop Ч любые операции в пределах 
-- базы данных shop.

drop user if exists shop_read@localhost;

create user shop_read@localhost identified by 'readonly';

grant select on shop.* to shop_read@localhost;

drop user if exists shop_any@localhost;

create user shop_any@localhost identified by 'anyshop';

grant all on shop.* to shop_any@localhost;

flush privileges;

-- (по желанию) ѕусть имеетс€ таблица accounts содержаща€ три столбца id, name, password, 
-- содержащие первичный ключ, им€ пользовател€ и его пароль. —оздайте представление username 
-- таблицы accounts, предоставл€ющий доступ к столбца id и name. —оздайте пользовател€ user_read, 
-- который бы не имел доступа к таблице accounts, однако, мог бы извлекать записи из представлени€ username.

create table accounts(
	id serial primary key comment '»дентификатор объекта',
	name varchar(25) not null comment '»м€ пользовател€',
	password varchar(25) not null comment 'ѕароль польховател€'
);

create view username(id, name) as select id, name from accounts;

drop user if exists user_read@localhost;

create user user_read@localhost identified by 'user';

grant select on shop.username to user_read@localhost;





-- Если брать в рассчет внешние ключи

-- Удобен для возрастной аналитики 
CREATE INDEX profiles_birthday_idx on profiles(birthday);

-- Для определения лайков для заданной сущности
CREATE INDEX likes_target_id_idx on likes(target_id);

-- Состоит ли заданный пользователь в заданной группе (так себе) 
CREATE INDEX communities_users_user_id_community_id_idx on communities_users(user_id, community_id);

-- Состоит ли заданный пользователь в отношениях с другим пользователем (тоже достаточно натануто) 
CREATE INDEX friendships_user_id_friend_id_idx on frendships(user_id, friend_id);

-- Найти файл по названию
CREATE INDEX media_filename_idx on media(filename); 

-- Переписка между двумя заданными пользователями
CREATE INDEX messages_from_user_id_to_user_id_idx on messages(from_user_id, to_user_id);

-- Построить запрос, который будет выводить следующие столбцы:
-- - имя группы
-- - среднее количество пользователей в группах
-- - самый молодой пользователь в группе
-- - самый старший пользователь в группе
-- - общее количество пользователей в группе
-- - всего пользователей в системе
-- - отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100


select distinct c.name,
	count(cu.user_id) over (order by cu.user_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) / (select count(*) from communities) avg_comm,
	concat(FIRST_VALUE(u.first_name) OVER(PARTITION BY c.name ORDER BY p.birthday), ' ',
	FIRST_VALUE(u.last_name) OVER(PARTITION BY c.name ORDER BY p.birthday)) as YANG,
	concat(FIRST_VALUE(u.first_name) OVER(PARTITION BY c.name ORDER BY p.birthday DESC), ' ',
	FIRST_VALUE(u.last_name) OVER(PARTITION BY c.name ORDER BY p.birthday DESC)) as OLDEST,
	count(c.id) over (partition by c.id order by cu.user_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) cnt_group,
	count(cu.user_id) over (order by cu.user_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) cnt_all,
	(SELECT count(*) from users) as all_users,
	100 * count(c.id) over (partition by c.id order by cu.user_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) / (SELECT count(*) from users) AS PC
from communities c join communities_users cu on cu.community_id=c.id 
join profiles p on cu.user_id = p.user_id join users u on p.user_id = u.id
order by c.name;


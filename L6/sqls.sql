-- Определить кто больше поставил лайков (всего) - мужчины или женщины?
SELECT (select gender from profiles p2 where p2.user_id=l.user_id) gender, count(*) from likes l
group by gender;
-- Результат
-- F	2264
-- M	2246

-- Подсчитать общее количество лайков десяти самым молодым пользователям (сколько лайков получили 10 самых молодых пользователей).
select count(*) from likes l2 where l2.target_id in 
(select user_id from (select p.user_id from profiles p order by p.birthday desc limit 10) as t)
and l2.target_type_id = (select id from target_types tt where tt.name = 'users');
-- Результат
-- 6

-- Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети (критерии активности необходимо определить самостоятельно)

SELECT (select CONCAT(u2.first_name, ' ', u2.last_name) from users u2 where u2.id=p.user_id) as usr, p.gender, p.birthday, p.city, p.country,
(
	(select count(*) from posts p2 where p2.user_id = p.user_id) +
	(select count(*) from messages m2 where m2.from_user_id = p.user_id) +
	(select count(*) from media m where m.user_id = p.user_id) + 
	(select count(*) from likes l2 where l2.user_id = p.user_id) + 
	(select count(*) from friendships f2 where f2.user_id = p.user_id) + 
	(select count(*) from communities_users c2 where c2.user_id = p.user_id)
) as cnt
from profiles p
order by cnt limit 10;
-- результат
-- Erick Dickinson	M	1950-03-29	South Darylfort		Nauru												7
-- Amparo Medhurst	F	1967-05-15	East Mohammed		British Indian Ocean Territory (Chagos Archipelago)	7
-- Tamia Beahan		M	2009-10-23	West Jailyn			Macedonia											7
-- Lucy Schoen		M	1925-10-18	Ethanview			Bahrain												9
-- Pink Thompson	F	2018-11-02	East Maryse			Oman												10
-- Zakary Simonis	M	1931-01-15	Pricebury			Cyprus												10
-- Jesus Ruecker	F	1969-10-07	Simonismouth		Tanzania											10
-- Keenan Bartell	F	1946-07-27	North Waldochester	Jamaica												10
-- Alene Powlowski	F	2012-04-16	Brekkeshire			Niue												10
-- Marilou Kemmer	M	1937-04-07	South Daija			Georgia												10

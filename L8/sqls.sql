-- ���������� ��� ������ �������� ������ (�����) - ������� ��� �������?
-- SELECT (select gender from profiles p2 where p2.user_id=l.user_id) gender, count(*) from likes l
-- group by gender;
-- ���������
-- F	2264
-- M	2246
select gender, count(l.id) from profiles p2 join likes l on p2.user_id=l.user_id 
GROUP BY gender;
-- ���������
-- F	2264
-- M	2246

-- ���������� ����� ���������� ������ ������ ����� ������� ������������� (������� ������ �������� 10 ����� ������� �������������).
-- select count(*) from likes l2 where l2.target_id in 
-- (select user_id from (select p.user_id from profiles p order by p.birthday desc limit 10) as t)
-- and l2.target_type_id = (select id from target_types tt where tt.name = 'users');
-- ���������
-- 6

SELECT count(distinct l.target_id) from profiles p left join likes l on p.user_id = l.target_id join target_types tt on l.target_type_id = tt.id and tt.name = 'users'
where p.user_id in (select user_id from (select p.user_id from profiles p order by p.birthday desc limit 10) as t);

-- ���������
-- 6

-- ����� 10 �������������, ������� ��������� ���������� ���������� � ������������� ���������� ���� (�������� ���������� ���������� ���������� ��������������)

/*
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
*/

-- ��� ������ ���������������� ���������� ������. ������������� ������� �� ���� ���������

SELECT u2.id, CONCAT(u2.first_name, ' ', u2.last_name) as usr, p.gender, p.birthday, p.city, p.country,
(
	(select count(*) from posts p2 where p2.user_id = p.user_id) +
	(select count(*) from messages m2 where m2.from_user_id = p.user_id) +
	(select count(*) from media m where m.user_id = p.user_id) + 
	(select count(*) from likes l2 where l2.user_id = p.user_id) + 
	(select count(*) from friendships f2 where f2.user_id = p.user_id) + 
	(select count(*) from communities_users c2 where c2.user_id = p.user_id)
) as cnt
from users u2 join profiles p on u2.id=p.user_id
order by cnt
limit 10;





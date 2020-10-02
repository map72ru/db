-- ���� ����� � ������� ������� �����

-- ������ ��� ���������� ��������� 
CREATE INDEX profiles_birthday_idx on profiles(birthday);

-- ��� ����������� ������ ��� �������� ��������
CREATE INDEX likes_target_id_idx on likes(target_id);

-- ������� �� �������� ������������ � �������� ������ (��� ����) 
CREATE INDEX communities_users_user_id_community_id_idx on communities_users(user_id, community_id);

-- ������� �� �������� ������������ � ���������� � ������ ������������� (���� ���������� ��������) 
CREATE INDEX friendships_user_id_friend_id_idx on frendships(user_id, friend_id);

-- ����� ���� �� ��������
CREATE INDEX media_filename_idx on media(filename); 

-- ��������� ����� ����� ��������� ��������������
CREATE INDEX messages_from_user_id_to_user_id_idx on messages(from_user_id, to_user_id);

-- ��������� ������, ������� ����� �������� ��������� �������:
-- - ��� ������
-- - ������� ���������� ������������� � �������
-- - ����� ������� ������������ � ������
-- - ����� ������� ������������ � ������
-- - ����� ���������� ������������� � ������
-- - ����� ������������� � �������
-- - ��������� � ��������� (����� ���������� ������������� � ������ / ����� ������������� � �������) * 100
select distinct c.name,
	COUNT(*) OVER(PARTITION BY c.name) AS average,
	concat(FIRST_VALUE(u.first_name) OVER(PARTITION BY c.name ORDER BY p.birthday), ' ',
	FIRST_VALUE(u.last_name) OVER(PARTITION BY c.name ORDER BY p.birthday)) as YANG,
	concat(FIRST_VALUE(u.first_name) OVER(PARTITION BY c.name ORDER BY p.birthday DESC), ' ',
	FIRST_VALUE(u.last_name) OVER(PARTITION BY c.name ORDER BY p.birthday DESC)) as OLDEST,
	COUNT(c.name) OVER(PARTITION BY c.name) AS count,
	count(u.id) OVER(PARTITION BY c.name, u.id)
from communities c join communities_users cu on cu.community_id=c.id join profiles p on cu.user_id = p.user_id join users u on p.user_id = u.id
order by c.name;


select count(*) from users u;

SELECT DISTINCT media_types.name,
  AVG(media.size) OVER(PARTITION BY media.media_type_id) AS average,
  MIN(media.size) OVER(PARTITION BY media.media_type_id) AS min,
  MAX(media.size) OVER(PARTITION BY media.media_type_id) AS max,
  SUM(media.size) OVER(PARTITION BY media.media_type_id) AS total_by_type,
  SUM(media.size) OVER() AS total,
  SUM(media.size) OVER(PARTITION BY media.media_type_id) / SUM(media.size) OVER() * 100 AS "%%"
    FROM media
      JOIN media_types
        ON media.media_type_id = media_types.id;

-- ���������� ����� ������
select * from vk.media_types;
-- ������ "������������" ����
delete from vk.media_types where name like 'text%' or name like 'application%';
-- �������� �� ���� ������� 2016 ���. ��� ��� ����� - �� ���������
select * from vk.media_types where YEAR(created_at) < 2016;
-- �������� ���� ������� ������
update vk.media_types set created_at = NOW() - interval FLOOR(RAND()*1000) day where YEAR(created_at) < 2016;
-- ���� ������� �� ����� ���� ������ ���� ���������
select * from vk.media_types where created_at > updated_at;
--�������� ���� ���������, ��� �� ��� ���� ������ ���� ������
update vk.media_types set updated_at = LEAST(created_at + interval FLOOR(RAND()*100) day, now()) where created_at > updated_at;
-- ���������� ���������
select * from vk.communities;
-- �������� ���� ������� ������
update vk.communities set created_at = NOW() - interval FLOOR(RAND()*1000) day where YEAR(created_at) < 2016;
-- ���� ������� �� ����� ���� ������ ���� ���������
select * from vk.communities where created_at > updated_at;
--�������� ���� ���������, ��� �� ��� ���� ������ ���� ������
update vk.communities set updated_at = LEAST(created_at + interval FLOOR(RAND()*100) day, now()) where created_at > updated_at;
-- ������� users
select * from vk.users order by id;
-- ��� �� ����� ���� "������" �� ����������������
SELECT CONCAT(first_name, '.' , last_name, SUBSTRING(email, LOCATE('@', email))) email FROM vk.users u;
-- �������� ������: Duplicate error� ������� �������� ��� ������
update vk.users SET email = CONCAT(first_name, '.' , last_name, SUBSTRING(email, LOCATE('@', email))) where first_name != 'Jazmyn' and last_name != 'Trantow';
-- ����� ������� ���, ������� �� �������, ������ ���� ������
select * from vk.users u where u.email like 'Jazmyn.Trantow%';
-- �������� ���� ������� ������
update vk.users set created_at = NOW() - interval FLOOR(RAND()*1000) day where YEAR(created_at) < 2016;
-- ���� ������� �� ����� ���� ������ ���� ��������� (��� �����)
select * from vk.users where created_at > updated_at;
-- ������� ������������
SELECT * from vk.profiles;
-- ������� �������� �������������
CREATE TABLE user_statuses (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "������������� ������", 
  name VARCHAR(100) NOT NULL COMMENT "�������� ������� (���������)",
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������"
) COMMENT "���������� �����";  

UPDATE profiles SET status = null;

SELECT * FROM user_statuses;

INSERT INTO user_statuses (name) VALUES
 ('�� � ��� �����'),
 ('� + ��'),
 ('�� + �'),
 ('� ������ �����');

ALTER TABLE profiles RENAME COLUMN status TO user_status_id; 

ALTER TABLE profiles MODIFY COLUMN user_status_id INT UNSIGNED; 

-- ��������� ������ �� ������ ������������
UPDATE vk.profiles SET user_status_id = FLOOR(1 + RAND() * 4);
-- �������� ���� ������� ������
update vk.profiles set created_at = NOW() - interval FLOOR(RAND()*1000) day where YEAR(created_at) < 2016;
-- ���� ������� �� ����� ���� ������ ���� ��������� (��� �����)
select * from vk.communities where created_at > updated_at;
-- �������������� ������������ ������
SELECT * from communities_users cu; 
-- �������� �� ���� ������� 2016 ���. ��� ��� ����� - �� ���������
select * from vk.communities_users where YEAR(created_at) < 2016;
-- �������� ���� ������� ������
update vk.communities_users set created_at = NOW() - interval FLOOR(RAND()*1000) day where YEAR(created_at) < 2016;
-- ���������� �������� ���������
SELECT * from vk.friendship_statuses fs; 
-- ������ ������
DELETE FROM vk.friendship_statuses where id > 5;
-- ������� ��������� �������
UPDATE vk.friendship_statuses set name = CASE 
	WHEN ID=1 THEN '������' 
	WHEN ID=2 THEN '����� ������ ������' 
	WHEN ID=3 THEN '�� ����� ���� ��� �����' 
	WHEN id=4 THEN '�����' 
	WHEN id=5 THEN '�����' 
	END;
-- �������� �� ���� ������� 2016 ���. ��� ��� ����� - �� ���������
select * from vk.friendship_statuses where YEAR(created_at) < 2016;	
-- �������� ���� ������� ������
update vk.friendship_statuses set created_at = NOW() - interval FLOOR(RAND()*1000) day where YEAR(created_at) < 2016;
-- ���� ������� �� ����� ���� ������ ���� ��������� (��� �����)
select * from vk.communities where created_at > updated_at;
-- ����������� ������� ��������� �������������
RENAME TABLE vk.friendship TO vk.friendships;
-- ������ ������� ���������
SELECT * from vk.friendships;
-- ������� �������
UPDATE friendships SET status_id = FLOOR(1 + RAND() * 5);
-- �������� ���� �������� ������� �� ���������
update vk.friendships set requested_at = NOW() - interval FLOOR(RAND()*1000) day where YEAR(requested_at) < 2016;
-- �������� ���� ������������� ������� �� ���������
update vk.friendships set confirmed_at = LEAST((requested_at + interval FLOOR(RAND()*10) day), now()) where confirmed_at < requested_at;
-- �������� �� ���� ������� 2016 ���. ��� ��� ����� - �� ���������
select * from vk.friendships where YEAR(created_at) < 2016;	
-- �������� ���� ������� ������
update vk.friendships set created_at = NOW() - interval FLOOR(RAND()*1000) day where YEAR(created_at) < 2016;
-- ��������� ������������� (������ ���� - 3 ������)
SELECT * from vk.messages where from_user_id = to_user_id;
-- ������ ��������� ������ ����
UPDATE vk.messages m set to_user_id = (SELECT ID from vk.users u WHERE u.id != m.from_user_id ORDER BY RAND() LIMIT 1) where from_user_id = to_user_id;
--
SELECT * from vk.messages;
-- �������� ���� ������� ������
update vk.messages set created_at = NOW() - interval FLOOR(RAND()*1000) day where YEAR(created_at) < 2016;
-- ���� ������� �� ����� ���� ������ ���� ��������� (��� �����)
select * from vk.messages where created_at > updated_at;
-- �������� ���� ���������, ��� �� ��� ���� ������ ���� ������
update vk.messages set updated_at = LEAST(created_at + interval FLOOR(RAND()*100) day, now()) where created_at > updated_at;
-- �����-�����
SELECT * from vk.media m;
-- �������� ���� ������
UPDATE vk.media m set media_type_id = (SELECT ID from vk.media_types u ORDER BY RAND() LIMIT 1);
-- ������� ������ � ������������ ������, �������� �� mime ���
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

-- �������� �������� ������
UPDATE vk.media m set m.filename = CONCAT('/FST/USERS/', m.filename, '.', (SELECT EXT from vk.media_types where ID=m.media_type_id));
-- ������ ��������� �������
ALTER TABLE vk.media_types DROP COLUMN EXT;
-- ������� ��� ������� �� ����������
ALTER TABLE vk.media MODIFY COLUMN metadata JSON;
-- ��������� ��������
UPDATE vk.media m set m.metadata = CONCAT('{"owner":"',(SELECT CONCAT(first_name, ' ', last_name) from vk.users where id=m.user_id), '"}'); 
-- �������� ���� ������� ������
update vk.media set created_at = NOW() - interval FLOOR(RAND()*1000) day where YEAR(created_at) < 2016;
-- �������� ���� ���������, ��� �� ��� ���� ������ ���� ������
update vk.media set updated_at = LEAST(created_at + interval FLOOR(RAND()*100) day, now()) where created_at > updated_at;

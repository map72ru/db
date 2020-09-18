-- ����������� ������ � ������� (��� �������� ���-�� cross join � ����������), �������� ������������ � �� = 2
insert into orders(user_id) (SELECT u.id from users u, products p where u.id != 2);
-- ���������
SELECT * from orders o;
-- ��������� ������ ������������� users, ������� ����������� ���� �� ���� ����� orders � �������� ��������.
select * from users u where id in (select user_id from orders o);
-- ����
SELECT distinct u2.* from users u2 join orders o on u2.id = o.user_id;
-- �������� ������ ������� products � �������� catalogs, ������� ������������� ������.
-- ���������
-- 1	��������	1990-10-05	2020-09-18 22:47:02.0	2020-09-18 22:47:02.0
-- 3	���������	1985-05-20	2020-09-18 22:47:02.0	2020-09-18 22:47:02.0
-- 4	������		1988-02-14	2020-09-18 22:47:02.0	2020-09-18 22:47:02.0
-- 5	����		1998-01-12	2020-09-18 22:47:02.0	2020-09-18 22:47:02.0
-- 6	�����		1992-08-29	2020-09-18 22:47:02.0	2020-09-18 22:47:02.0

SELECT p.name, p.description, p.price, c.name from products p join catalogs c on p.catalog_id = c.id;
-- ���������
-- Intel Core i3-8100		��������� ��� ���������� ������������ �����������, ���������� �� ��������� Intel.	7890.00		����������
-- Intel Core i5-7400		��������� ��� ���������� ������������ �����������, ���������� �� ��������� Intel.	12700.00	����������
-- AMD FX-8320E				��������� ��� ���������� ������������ �����������, ���������� �� ��������� AMD.		4780.00		����������
-- AMD FX-8320				��������� ��� ���������� ������������ �����������, ���������� �� ��������� AMD.		7120.00		����������
-- ASUS ROG MAXIMUS X HERO	����������� ����� ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX			19310.00	����������� �����
-- Gigabyte H310M S2H		����������� ����� Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX				4790.00		����������� �����
-- MSI B250M GAMING PRO		����������� ����� MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX				5060.00		����������� �����

-- (�� �������) ����� ������� ������� ������ flights (id, from, to) � ������� ������� cities (label, name). 
-- ���� from, to � label �������� ���������� �������� �������, ���� name � �������. 
-- �������� ������ ������ flights � �������� ���������� �������.
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
('moscow', '������'),
('novgorod', '��������'),
('irkutsk', '�������'),
('omsk', '����'),
('kazan', '������');

SELECT c.name `from`, c2.name `to` from flights f join cities c on f.`from`= c.label join cities c2 on f.`to` = c2.label;
-- ���������
-- �������	������
-- ����		�������
-- ������	����
-- ��������	������
-- ������	������
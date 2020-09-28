-- � ���� ������ shop � sample ������������ ���� � �� �� �������, ������� ���� ������. 
-- ����������� ������ id = 1 �� ������� shop.users � ������� sample.users. ����������� ����������.

use sample;

drop table if exists users;

CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL COMMENT '��� ����������',
  `birthday_at` date DEFAULT NULL COMMENT '���� ��������',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='����������';

use shop;

start transaction;

insert into sample.users (select * from users where id=1);

commit;

-- ��������
select * from sample.users;

-- ���������
-- 1	��������	1990-10-05	2020-09-18 22:47:02.0	2020-09-18 22:47:02.0

-- �������� �������������, ������� ������� �������� name �������� ������� �� ������� products � ��������������� �������� 
-- �������� name �� ������� catalogs.

CREATE OR REPLACE VIEW product_catalog_view(product_name, catalog_name) as 
Select p.name, c.name from products p join catalogs c on p.catalog_id = c.id;

-- ��������

select * from product_catalog_view;

-- ���������
-- Intel Core i3-8100		����������
-- Intel Core i5-7400		����������
-- AMD FX-8320E				����������
-- AMD FX-8320				����������
-- ASUS ROG MAXIMUS X HERO	����������� �����
-- Gigabyte H310M S2H		����������� �����
-- MSI B250M GAMING PRO		����������� �����

-- (�� �������) ����� ������� ������� � ����������� ����� created_at. 
-- � ��� ��������� ���������� ����������� ������ �� ������ 2018 ���� '2018-08-01', '2016-08-04', '2018-08-16' � 2018-08-17. 
-- ��������� ������, ������� ������� ������ ������ ��� �� ������, ��������� � �������� ���� �������� 1, ���� ���� 
-- ������������ � �������� ������� � 0, ���� ��� �����������.

use sample;

create table task_3 (
	created_at DATE
);

-- ���� � ��������� ����� �������

insert into task_3 values (NULL), (NULL), (NULL), ('2018-08-01'), (NULL), (NULL), (NULL), (NULL), (NULL), (NULL), (NULL), (NULL), (NULL), (NULL), 
('2018-08-04'), (NULL), (NULL), (NULL), (NULL), (NULL), (NULL), (NULL), ('2018-08-16'), (NULL), (NULL), (NULL), (NULL), (NULL), (NULL), ('2018-08-01');

set @day=0;

SELECT @day := @day+1 as days, if (MONTH(created_at) = 8, 1, 0) from task_3; 

-- ���������
-- 1	0
-- 2	0
-- 3	0
-- 4	1
-- 5	0
-- 6	0
-- 7	0
-- 8	0
-- 9	0
-- 10	0
-- 11	0
-- 12	0
-- 13	0
-- 14	0
-- 15	1
-- 16	0
-- 17	0
-- 18	0
-- 19	0
-- 20	0
-- 21	0
-- 22	0
-- 23	1
-- 24	0
-- 25	0
-- 26	0
-- 27	0
-- 28	0
-- 29	0
-- 30	1

-- (�� �������) ����� ������� ����� ������� � ����������� ����� created_at. �������� ������, ������� ������� ���������� ������ �� �������, 
-- �������� ������ 5 ����� ������ �������.
TRUNCATE TABLE task_3;

insert into task_3 values ('2014-08-01'), ('2015-08-01'), ('2016-08-01'), ('2018-08-01'), ('2000-08-04'), ('2001-08-04'), ('2003-08-04'), ('2004-08-04'), ('2005-08-04'), ('2006-08-04'), 
('2007-08-04'), ('2008-08-04'), ('2009-08-04'), ('2010-08-04'), 
('2018-08-04'), ('2010-08-16'), ('2011-08-16'), ('2012-08-16'), ('2013-08-16'), ('2014-08-16'), ('2015-08-16'), ('2016-08-16'), ('2018-08-16'), 
('2010-08-01'), ('2011-08-01'), ('2012-08-01'), ('2013-08-01'), ('2014-08-01'), ('2015-08-01'), ('2018-08-01');


prepare dels from "delete from task_3 order by created_at limit ?";

set @cnt=(select count(*)-5 from task_3);

execute dels using @cnt;

SELECT * from task_3;

-- ���������

-- 2018-08-01
-- 2018-08-04
-- 2016-08-16
-- 2018-08-16
-- 2018-08-01

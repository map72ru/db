-- ����� � ������� users ���� created_at � updated_at ��������� ��������������. ��������� �� �������� ����� � ��������
update users set created_at = now(), updated_at = now();
-- ��������
SELECT * from users;
-- ������� users ���� �������� ��������������. ������ created_at � updated_at ���� ������ ����� VARCHAR � � ��� 
-- ������ ����� ���������� �������� � ������� 20.10.2017 8:10. ���������� ������������� ���� � ���� DATETIME, 
-- �������� �������� ����� ��������.

-- ������� ������� � "�� ����������� ������" (��� �� �� ������� ������������ �������)
create table users_1 as select id, name, birthday_at, DATE_FORMAT(created_at, '%d.%m.%Y %H:%i') as created_at, DATE_FORMAT(updated_at, '%d.%m.%Y %H:%i') as updated_at
from users;
-- ������� ����� ������� users_1
desc users_1;

select * from users_1;
-- �������� ���������������
 create table users_temp as select id, name, birthday_at, str_to_date(created_at, '%d.%m.%Y %H:%i') as created_at, str_to_date(updated_at, '%d.%m.%Y %H:%i') as updated_at
from users_1;
-- ������� �������� �������
select * from users_temp;
-- ������� �������� ������� � �� ����������� ������
drop table users_1;
-- �������������� �������
rename table users_temp to users_1;
-- � ������� ��������� ������� storehouses_products � ���� value ����� ����������� ����� ������ �����: 0, 
-- ���� ����� ���������� � ���� ����, ���� �� ������ ������� ������. ���������� ������������� ������ ����� �������, 
-- ����� ��� ���������� � ������� ���������� �������� value. ������ ������� ������ ������ ���������� � �����, ����� ����

-- ������ ���, ���� �� �������������
insert into storehouses(name) values ("�������� �����");
insert into storehouses_products (storehouse_id, product_id, value) (select 1, id, floor(rand()*100) from products);
-- ��������� 0 ��� ������� 3 � 5
update storehouses_products set value = 0 where id in (3,5);
-- ���������� � ������ � �����
SELECT * from storehouses_products order by value = 0, value;
-- (�� �������) �� ������� users ���������� ������� �������������, ���������� � ������� � ���. 
-- ������ ������ � ���� ������ ���������� �������� (may, august)
select * from users u where date_format(u.birthday_at, "%M") in ('may', 'august');
-- (�� �������) �� ������� catalogs ����������� ������ ��� ������ �������. SELECT * FROM catalogs WHERE id IN (5, 1, 2); 
-- ������������ ������ � �������, �������� � ������ IN.
SELECT * FROM catalogs WHERE id IN (5, 1, 2) order by field(id, 5, 1, 2);







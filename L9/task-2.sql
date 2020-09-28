-- �������� ���� ������������� ������� ����� ������ � ���� ������ shop. 
-- ������� ������������ shop_read ������ ���� �������� ������ ������� �� 
-- ������ ������, ������� ������������ shop � ����� �������� � �������� 
-- ���� ������ shop.

drop user if exists shop_read@localhost;

create user shop_read@localhost identified by 'readonly';

grant select on shop.* to shop_read@localhost;

drop user if exists shop_any@localhost;

create user shop_any@localhost identified by 'anyshop';

grant all on shop.* to shop_any@localhost;

flush privileges;

-- (�� �������) ����� ������� ������� accounts ���������� ��� ������� id, name, password, 
-- ���������� ��������� ����, ��� ������������ � ��� ������. �������� ������������� username 
-- ������� accounts, ��������������� ������ � ������� id � name. �������� ������������ user_read, 
-- ������� �� �� ���� ������� � ������� accounts, ������, ��� �� ��������� ������ �� ������������� username.

create table accounts(
	id serial primary key comment '������������� �������',
	name varchar(25) not null comment '��� ������������',
	password varchar(25) not null comment '������ ������������'
);

create view username(id, name) as select id, name from accounts;

drop user if exists user_read@localhost;

create user user_read@localhost identified by 'user';

grant select on shop.username to user_read@localhost;





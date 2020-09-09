CREATE TABLE likes (
	ID SERIAL PRIMARY KEY,
	CREATED_AT DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '����� ���������',
	LIKE_TYPE BOOLEAN NOT NULL DEFAULT true COMMENT '������� ���������/�� ���������',
	FROM_USER_ID INT NOT NULL COMMENT '������������, ����������� ����',
	TO_USER_ID INT COMMENT '���� ��� ������������',
	MESSAGE_ID INT COMMENT '���� ��� ���������',
	MEDIA_ID INT COMMENT '���� ��� �����'
) COMMENT '�����';

CREATE TABLE posts (
	ID SERIAL PRIMARY KEY,
	CREATED_AT DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '����� �������� �����',
	MODIFIED_AT DATETIME ON UPDATE CURRENT_TIMESTAMP COMMENT '����� ��������� �����',
	TEXT LONGTEXT NOT NULL COMMENT '����� �����',
	FROM_USER_ID INT NOT NULL COMMENT '������������, ���������� ����',
	TO_USER_ID INT COMMENT '��� ������ ������������'
) COMMENT '�����';
	
DROP DATABASE IF EXISTS seon;

CREATE DATABASE seon
/*!40100 DEFAULT CHARACTER SET utf8 */ 
/*!80016 DEFAULT ENCRYPTION='N' */;

/**
 * ��������� �������� 
 */
use seon;

DROP TABLE IF EXISTS parameters;

CREATE TABLE parameters(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '������������� �������',
	parameter_key VARCHAR(30) NOT NULL COMMENT '���� ���������',
	parameter_value VARCHAR(50) NOT NULL COMMENT '�������� ���������',
	description VARCHAR(150) COMMENT '�������� ���������',
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT '����� �������� ������',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '����� ���������� ������',
	UNIQUE KEY parameters_parameter_key_uk (parameter_key)
) COMMENT='��������� �������';

DROP TABLE IF EXISTS media_file_types;

CREATE TABLE media_file_types(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '������������� �������',
	mime VARCHAR(30) NOT NULL COMMENT 'Mime-��� �����',
	file_type INT NOT NULL DEFAULT 1 COMMENT '������� �������� �� ������ ��� ������������ (1) ��� �����(2)',
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT '����� �������� ������',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '����� ���������� ������',
	UNIQUE KEY media_file_types_mime_uk (mime)
) COMMENT='���������� ���� ������';

/*
 * �����, ������������������ � ������� (�����������, �����, ��������, ����, ������
 */
DROP TABLE IF EXISTS media_files;

CREATE TABLE media_files(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '������������� �������',
	type_id INT UNSIGNED NOT NULL COMMENT 'Mime-��� �����',
	filename VARCHAR(255) NOT NULL COMMENT '���� � ����� � ������� ��������',
	file_size INT NOT NULL COMMENT '������ �����',
	hash VARCHAR(255) NOT NULL COMMENT '��� ��� �����',
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT '����� �������� ������',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '����� ���������� ������',
	CONSTRAINT media_files_type_id_fk FOREIGN KEY (type_id) REFERENCES media_file_types(id),
	UNIQUE KEY media_file_hash_uk (hash)
) COMMENT='���������� ���� ������';

/*
 * �����������
 */
DROP TABLE IF EXISTS countries;

CREATE TABLE countries(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '������������� �������',
	name VARCHAR(100) NOT NULL COMMENT '�������� ������',
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT '����� �������� ������',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '����� ���������� ������',
	UNIQUE KEY media_file_types_mime_uk (name)
) COMMENT='������, � ������� ����� ���� ������������';

DROP TABLE IF EXISTS states;

CREATE TABLE states(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '������������� �������',
	name VARCHAR(100) NOT NULL COMMENT '�������� �������',
	country_id INT UNSIGNED NOT NULL COMMENT '������, ������� ����������� ������ ������',
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT '����� �������� ������',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '����� ���������� ������',
	UNIQUE KEY states_name_uk (name),
	CONSTRAINT states_country_id_fk FOREIGN KEY (country_id) REFERENCES countries(id)	
) COMMENT='������� �����, � ������� ����� ���� ������������';

DROP TABLE IF EXISTS locations;

CREATE TABLE locations(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '������������� �������',
	name VARCHAR(100) NOT NULL COMMENT '�������� ����������� ������',
	state_id INT UNSIGNED NOT NULL COMMENT '������ �������� ����������� ������ ���������� �����',
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT '����� �������� ������',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '����� ���������� ������',
	CONSTRAINT locations_state_id_fk FOREIGN KEY (state_id) REFERENCES states(id)
) COMMENT='����������� ������,� ������� ����� ���� ������������';

DROP TABLE IF EXISTS interaction_types;

CREATE TABLE interaction_types (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '������������� �������',
	name varchar(25) NOT NULL COMMENT '�������� ���� ��������������',
	code varchar(5) NOT NULL COMMENT '��� ��� ��������� � ���������� ��������',
	icon_id INT UNSIGNED NOT NULL COMMENT '������ �� ������',
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT '����� �������� ������',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '����� ���������� ������',
	UNIQUE KEY interaction_types_code_uk (code),
	CONSTRAINT interaction_types_icon_id_fk FOREIGN KEY (icon_id) REFERENCES media_files(id)
) COMMENT='���� ��������� �������������';

CREATE TABLE units (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '������������� �������',
	name VARCHAR(100) NOT NULL COMMENT '�������� ��. ���������',
	short_name VARCHAR(10) NOT NULL COMMENT '����������� ��. ���������',
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT '����� �������� ������',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '����� ���������� ������',
	UNIQUE KEY media_file_types_mime_uk (name)
) COMMENT='������� ��������� ������������� ������';

DROP TABLE IF EXISTS specifications;

CREATE TABLE specifications (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '������������� �������',
	name VARCHAR(100) NOT NULL COMMENT '�������� ��������������',
	unit_id INT UNSIGNED NOT NULL COMMENT '������� ���������',
	specification_type ENUM('DATE', 'STRING', 'NUMBER', 'BOOLEAN') NOT NULL COMMENT '��� �������� ���������',
	description VARCHAR(255) COMMENT '�������� ������� ���������',
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT '����� �������� ������',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '����� ���������� ������',
	UNIQUE KEY specifications_name_uk (name),
	CONSTRAINT specifications_unit_id_fk FOREIGN KEY (unit_id) REFERENCES units(id)
) COMMENT='�������������� �������';

/*
 * ������������ �������
 */

DROP TABLE IF EXISTS users;

CREATE TABLE users (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '������������� �������',
	first_name VARCHAR(100) NOT NULL COMMENT '��� ������������',
	last_name VARCHAR(100) NOT NULL COMMENT '������� ������������',
	thrid_name VARCHAR(100) COMMENT '�������� ������������',
	login VARCHAR(100) NOT NULL COMMENT '����� ��� �����',
	is_active BOOLEAN DEFAULT TRUE NOT NULL COMMENT '������������ ������������',
	location_id INT UNSIGNED NOT NULL COMMENT '���������� �����, � �������� ������� ���� ������������',
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT '����� �������� ������',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '����� ���������� ������',
	UNIQUE KEY users_login_uk (login),
	CONSTRAINT users_location_id_fk FOREIGN KEY (location_id) REFERENCES locations(id)
) COMMENT='������������ �������';

DROP TABLE IF EXISTS user_interactions;

CREATE TABLE user_interactions (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '������������� �������',
	user_id	INT UNSIGNED NOT NULL COMMENT '������������',
	type_id INT UNSIGNED NOT NULL COMMENT '��� ��������������',
	value VARCHAR(100) NOT NULL COMMENT '�������� ��������������',
	is_default BOOLEAN DEFAULT false NOT NULL COMMENT '������� ����, ��� ����� ��� �������������� �������� ����������������',
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT '����� �������� ������',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '����� ���������� ������',
	UNIQUE KEY user_interaction_user_id_type_id_uk (user_id, type_id),
	CONSTRAINT user_interactions_type_id_fk FOREIGN KEY (type_id) REFERENCES interaction_types(id),
	CONSTRAINT user_interactions_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) COMMENT='������� ������������� � �������������';

DROP TABLE IF EXISTS profiles;

CREATE TABLE profiles (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '������������� �������',
	user_id	INT UNSIGNED NOT NULL COMMENT '������������',
	gender VARCHAR(1) NOT NULL DEFAULT '�' COMMENT '��� ������������',
	avatar_id INT UNSIGNED COMMENT '���� �������/���� ������������',
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT '����� �������� ������',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '����� ���������� ������',
	UNIQUE KEY profiles_user_id_uk (user_id),
	CONSTRAINT profiles_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
	CONSTRAINT profiles_avatar_id_fk FOREIGN KEY (avatar_id) REFERENCES media_files(id) ON DELETE SET NULL
) COMMENT='������� ����������� ����';

DROP TABLE IF EXISTS enterprises;

CREATE TABLE enterprises (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '������������� �������',
	user_id	INT UNSIGNED NOT NULL COMMENT '������������',
	name VARCHAR(200) NOT NULL COMMENT '�������� �����������',
	avatar_id INT UNSIGNED COMMENT '��������� ���� �����������',
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT '����� �������� ������',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '����� ���������� ������',
	UNIQUE KEY enterprises_user_id_uk (user_id),
	CONSTRAINT enterprises_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
	CONSTRAINT enterprises_avatar_id_fk FOREIGN KEY (avatar_id) REFERENCES media_files(id) ON DELETE SET NULL
) COMMENT='������� ������������ ����';


DROP TABLE IF EXISTS comments;

CREATE TABLE comments (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '������������� �������',
	user_id	INT UNSIGNED NOT NULL COMMENT '������������, ���������� �����',
	to_user_id INT UNSIGNED NOT NULL COMMENT '������������, �� ���� �����',
	is_moderited BOOLEAN NOT NULL DEFAULT FALSE COMMENT '����� ��������������?',
	raiting INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '������ ������������ (�� 0 �� 5)',
	COMMENT TEXT NOT NULL COMMENT '����������� ������',
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT '����� �������� ������',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '����� ���������� ������'
) COMMENT='������ � �������������';

/*
 * ���������� �� �������
 */

DROP TABLE IF EXISTS categories;

CREATE TABLE categories (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '������������� �������',
	name VARCHAR(100) NOT NULL COMMENT '�������� ���������',
	parent_id INT UNSIGNED COMMENT '������������ ���������',
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT '����� �������� ������',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '����� ���������� ������',
	CONSTRAINT categories_parent_id_fk FOREIGN KEY (parent_id) REFERENCES categories(id)
) COMMENT='��������� �������';

DROP TABLE IF EXISTS categories_specifications;

CREATE TABLE categories_specifications (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '������������� �������',
	category_id INT UNSIGNED NOT NULL COMMENT '��������� �������',
	specification_id INT UNSIGNED NOT NULL COMMENT '�������������� �������',
	order_num INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '������� ����������',
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT '����� �������� ������',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '����� ���������� ������',
	UNIQUE KEY categories_specifications_category_id_specification_id_uk (category_id, specification_id),
	CONSTRAINT categories_specifications_category_id_fk FOREIGN KEY (category_id) REFERENCES categories(id),
	CONSTRAINT categories_specifications_specification_id_fk FOREIGN KEY (specification_id) REFERENCES specifications(id)
) COMMENT='�������������� ��� �������� ��������� �������';

DROP TABLE IF EXISTS advertisements;

CREATE TABLE advertisements (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '������������� �������',
	category_id INT UNSIGNED NOT NULL COMMENT '��������� �������',
	user_id INT UNSIGNED NOT NULL COMMENT '������������, ������������ ����������',
	title varchar(100) NOT NULL COMMENT '��������� ����������',
	description varchar(1024) COMMENT '�������� �������',
	price float(10,2) NOT NULL COMMENT '���� ������� (����� ���� 0 - ���������)',
	finished_at DATETIME NOT NULL COMMENT '����� ����������� ������ ����������',
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT '����� �������� ������',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '����� ���������� ������',
	CONSTRAINT advertisements_category_id_fk FOREIGN KEY (category_id) REFERENCES categories(id),
	CONSTRAINT advertisements_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) COMMENT='���������� � �������/�������� �������';

DROP TABLE IF EXISTS object_specifications;

CREATE TABLE object_specifications (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '������������� �������',
	specification_id INT UNSIGNED NOT NULL COMMENT '�������������� �������',
	ad_id INT UNSIGNED NOT NULL COMMENT '����������',
	value_string VARCHAR(100) COMMENT '��������� ��������',
	value_number DOUBLE COMMENT '�������� ��������',
	value_date datetime COMMENT '���� ������� (����� ���� 0 - ���������)',
	value_boolean BOOLEAN COMMENT '���������� ��������',
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT '����� �������� ������',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '����� ���������� ������',
	UNIQUE KEY object_specifications_ad_id_specification_id_uk (ad_id, specification_id),
	CONSTRAINT object_specifications_specification_id_fk FOREIGN KEY (specification_id) REFERENCES specifications(id),
	CONSTRAINT object_specifications_ad_id_fk FOREIGN KEY (ad_id) REFERENCES advertisements(id) ON DELETE CASCADE
) COMMENT='�������� ������������� �������';

DROP TABLE IF EXISTS object_media_files;

CREATE TABLE object_media_files (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '������������� �������',
	media_id INT UNSIGNED NOT NULL COMMENT '����������� �������',
	ad_id INT UNSIGNED NOT NULL COMMENT '����������',
	order_num INT UNSIGNED DEFAULT 0 NOT NULL COMMENT '������� ������',
	finished_at DATETIME NOT NULL COMMENT '����� ����������� �����������',
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT '����� �������� ������',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '����� ���������� ������',
	CONSTRAINT object_media_files_ad_id_fk FOREIGN KEY (ad_id) REFERENCES advertisements(id),
	CONSTRAINT object_media_files_media_id_fk FOREIGN KEY (media_id) REFERENCES media_files(id) ON DELETE CASCADE
) COMMENT='����������� �������';

DROP TABLE IF EXISTS object_offers;

CREATE TABLE object_offers (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '������������� �������',
	user_id INT UNSIGNED NOT NULL COMMENT '������������, ������� ������ �����������',
	ad_id INT UNSIGNED NOT NULL COMMENT '����������',
	offer varchar(255) NOT NULL COMMENT '����� �����������',
	replay varchar(255) NOT NULL COMMENT '����� ������ �� �����������',
	finished_at DATETIME COMMENT '����� ����������� �����������',
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT '����� �������� ������',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '����� ���������� ������',
	UNIQUE KEY object_offers_ad_id_user_id_uk (ad_id, user_id),
	CONSTRAINT object_offers_ad_id_fk FOREIGN KEY (ad_id) REFERENCES advertisements(id),
	CONSTRAINT object_offers_users_id_fk FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) COMMENT='����������� ������������� ����������� � �������';

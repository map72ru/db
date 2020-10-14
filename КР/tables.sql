DROP DATABASE IF EXISTS seon;

CREATE DATABASE seon
/*!40100 DEFAULT CHARACTER SET utf8 */ 
/*!80016 DEFAULT ENCRYPTION='N' */;

/**
 * Служебные сущности 
 */
use seon;

DROP TABLE IF EXISTS parameters;

CREATE TABLE parameters(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор объекта',
	parameter_key VARCHAR(30) NOT NULL COMMENT 'Ключ параметра',
	parameter_value VARCHAR(50) NOT NULL COMMENT 'Значение параметра',
	description VARCHAR(150) COMMENT 'Описание параметра',
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
	UNIQUE KEY parameters_parameter_key_uk (parameter_key)
) COMMENT='Параметры системы';

DROP TABLE IF EXISTS media_file_types;

CREATE TABLE media_file_types(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор объекта',
	mime VARCHAR(30) NOT NULL COMMENT 'Mime-тип файла',
	file_type INT NOT NULL DEFAULT 1 COMMENT 'Признак является ли данный тпи изображением (1) или видео(2)',
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
	UNIQUE KEY media_file_types_mime_uk (mime)
) COMMENT='Допустимые типы файлов';

/*
 * Файлы, зарегистрированные в системе (изображения, видео, аватарки, фото, иконки
 */
DROP TABLE IF EXISTS media_files;

CREATE TABLE media_files(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор объекта',
	type_id INT UNSIGNED NOT NULL COMMENT 'Mime-тип файла',
	filename VARCHAR(255) NOT NULL COMMENT 'Путь к файлу в системе хранения',
	file_size INT NOT NULL COMMENT 'Размер файла',
	hash VARCHAR(255) NOT NULL COMMENT 'Хеш код файла',
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
	CONSTRAINT media_files_type_id_fk FOREIGN KEY (type_id) REFERENCES media_file_types(id),
	UNIQUE KEY media_file_hash_uk (hash)
) COMMENT='Допустимые типы файлов';

/*
 * Справочники
 */
DROP TABLE IF EXISTS countries;

CREATE TABLE countries(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор объекта',
	name VARCHAR(100) NOT NULL COMMENT 'Название страны',
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
	UNIQUE KEY media_file_types_mime_uk (name)
) COMMENT='Страны, в которых могут быть пользователи';

DROP TABLE IF EXISTS states;

CREATE TABLE states(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор объекта',
	name VARCHAR(100) NOT NULL COMMENT 'Название региона',
	country_id INT UNSIGNED NOT NULL COMMENT 'Страна, которой принадлежит данный регион',
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
	UNIQUE KEY states_name_uk (name),
	CONSTRAINT states_country_id_fk FOREIGN KEY (country_id) REFERENCES countries(id)	
) COMMENT='Регионы стран, в которых могут быть пользователи';

DROP TABLE IF EXISTS locations;

CREATE TABLE locations(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор объекта',
	name VARCHAR(100) NOT NULL COMMENT 'Название населенного пункта',
	state_id INT UNSIGNED NOT NULL COMMENT 'Регион которому принадлежит данный населенный пункт',
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
	CONSTRAINT locations_state_id_fk FOREIGN KEY (state_id) REFERENCES states(id)
) COMMENT='Насенленные пункты,в которых могут быть пользователи';

DROP TABLE IF EXISTS interaction_types;

CREATE TABLE interaction_types (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор объекта',
	name varchar(25) NOT NULL COMMENT 'Название типа взаимодействия',
	code varchar(5) NOT NULL COMMENT 'Код для обращения к подсистеме отправки',
	icon_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на иконку',
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
	UNIQUE KEY interaction_types_code_uk (code),
	CONSTRAINT interaction_types_icon_id_fk FOREIGN KEY (icon_id) REFERENCES media_files(id)
) COMMENT='Типы контактов пользователей';

CREATE TABLE units (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор объекта',
	name VARCHAR(100) NOT NULL COMMENT 'Название ед. измерения',
	short_name VARCHAR(10) NOT NULL COMMENT 'Обозначение ед. измерения',
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
	UNIQUE KEY media_file_types_mime_uk (name)
) COMMENT='Единицы измерений характкристик товара';

DROP TABLE IF EXISTS specifications;

CREATE TABLE specifications (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор объекта',
	name VARCHAR(100) NOT NULL COMMENT 'Название характеристики',
	unit_id INT UNSIGNED NOT NULL COMMENT 'Единица измерения',
	specification_type ENUM('DATE', 'STRING', 'NUMBER', 'BOOLEAN') NOT NULL COMMENT 'Тип значения параметра',
	description VARCHAR(255) COMMENT 'Описание единицы измерения',
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
	UNIQUE KEY specifications_name_uk (name),
	CONSTRAINT specifications_unit_id_fk FOREIGN KEY (unit_id) REFERENCES units(id)
) COMMENT='Характеристика объекта';

/*
 * Пользователи системы
 */

DROP TABLE IF EXISTS users;

CREATE TABLE users (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор объекта',
	first_name VARCHAR(100) NOT NULL COMMENT 'Имя пользователя',
	last_name VARCHAR(100) NOT NULL COMMENT 'Фамилия пользователя',
	thrid_name VARCHAR(100) COMMENT 'Отчество пользователя',
	login VARCHAR(100) NOT NULL COMMENT 'Логин для входа',
	is_active BOOLEAN DEFAULT TRUE NOT NULL COMMENT 'Актуальность пользователя',
	location_id INT UNSIGNED NOT NULL COMMENT 'Населенный пункт, к которому относит себя пользователь',
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
	UNIQUE KEY users_login_uk (login),
	CONSTRAINT users_location_id_fk FOREIGN KEY (location_id) REFERENCES locations(id)
) COMMENT='Пользователи системы';

DROP TABLE IF EXISTS user_interactions;

CREATE TABLE user_interactions (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор объекта',
	user_id	INT UNSIGNED NOT NULL COMMENT 'Пользователь',
	type_id INT UNSIGNED NOT NULL COMMENT 'Тип взаимодействия',
	value VARCHAR(100) NOT NULL COMMENT 'Значение взаимодействия',
	is_default BOOLEAN DEFAULT false NOT NULL COMMENT 'Признак того, что даный тип взаимодействия является предпочтительным',
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
	UNIQUE KEY user_interaction_user_id_type_id_uk (user_id, type_id),
	CONSTRAINT user_interactions_type_id_fk FOREIGN KEY (type_id) REFERENCES interaction_types(id),
	CONSTRAINT user_interactions_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) COMMENT='Способы взимодействия с пользователем';

DROP TABLE IF EXISTS profiles;

CREATE TABLE profiles (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор объекта',
	user_id	INT UNSIGNED NOT NULL COMMENT 'Пользователь',
	gender VARCHAR(1) NOT NULL DEFAULT 'М' COMMENT 'Пол пользователя',
	avatar_id INT UNSIGNED COMMENT 'Файл аватара/фото пользователя',
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
	UNIQUE KEY profiles_user_id_uk (user_id),
	CONSTRAINT profiles_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
	CONSTRAINT profiles_avatar_id_fk FOREIGN KEY (avatar_id) REFERENCES media_files(id) ON DELETE SET NULL
) COMMENT='Профиль физического лица';

DROP TABLE IF EXISTS enterprises;

CREATE TABLE enterprises (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор объекта',
	user_id	INT UNSIGNED NOT NULL COMMENT 'Пользователь',
	name VARCHAR(200) NOT NULL COMMENT 'Название предприятия',
	avatar_id INT UNSIGNED COMMENT 'Фирменный знак предприятия',
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
	UNIQUE KEY enterprises_user_id_uk (user_id),
	CONSTRAINT enterprises_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
	CONSTRAINT enterprises_avatar_id_fk FOREIGN KEY (avatar_id) REFERENCES media_files(id) ON DELETE SET NULL
) COMMENT='Профиль юридического лица';


DROP TABLE IF EXISTS comments;

CREATE TABLE comments (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор объекта',
	user_id	INT UNSIGNED NOT NULL COMMENT 'Пользователь, оставивший отзыв',
	to_user_id INT UNSIGNED NOT NULL COMMENT 'Пользователь, на кого отзыв',
	is_moderited BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Отзыв промодерирован?',
	raiting INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Оценка пользователя (от 0 до 5)',
	COMMENT TEXT NOT NULL COMMENT 'Комментарий оценки',
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT='Отзывы о пользователях';

/*
 * Информация об объекте
 */

DROP TABLE IF EXISTS categories;

CREATE TABLE categories (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор объекта',
	name VARCHAR(100) NOT NULL COMMENT 'Название категории',
	parent_id INT UNSIGNED COMMENT 'Родительская категория',
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
	CONSTRAINT categories_parent_id_fk FOREIGN KEY (parent_id) REFERENCES categories(id)
) COMMENT='Категории объекта';

DROP TABLE IF EXISTS categories_specifications;

CREATE TABLE categories_specifications (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор объекта',
	category_id INT UNSIGNED NOT NULL COMMENT 'Категория объекта',
	specification_id INT UNSIGNED NOT NULL COMMENT 'Характеристика объекта',
	order_num INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Порядок следования',
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
	UNIQUE KEY categories_specifications_category_id_specification_id_uk (category_id, specification_id),
	CONSTRAINT categories_specifications_category_id_fk FOREIGN KEY (category_id) REFERENCES categories(id),
	CONSTRAINT categories_specifications_specification_id_fk FOREIGN KEY (specification_id) REFERENCES specifications(id)
) COMMENT='Характеристики для заданной категории объекта';

DROP TABLE IF EXISTS advertisements;

CREATE TABLE advertisements (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор объекта',
	category_id INT UNSIGNED NOT NULL COMMENT 'Категория объекта',
	user_id INT UNSIGNED NOT NULL COMMENT 'Пользователь, разместивший объявление',
	title varchar(100) NOT NULL COMMENT 'Заголовок объявления',
	description varchar(1024) COMMENT 'Описание объекта',
	price float(10,2) NOT NULL COMMENT 'Цена объекта (может быть 0 - бесплатно)',
	finished_at DATETIME NOT NULL COMMENT 'Время прекращения показа объявления',
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
	CONSTRAINT advertisements_category_id_fk FOREIGN KEY (category_id) REFERENCES categories(id),
	CONSTRAINT advertisements_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) COMMENT='Объявление о продаже/передаче объекта';

DROP TABLE IF EXISTS object_specifications;

CREATE TABLE object_specifications (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор объекта',
	specification_id INT UNSIGNED NOT NULL COMMENT 'Характеристика объекта',
	ad_id INT UNSIGNED NOT NULL COMMENT 'Объявление',
	value_string VARCHAR(100) COMMENT 'Строковое значение',
	value_number DOUBLE COMMENT 'Цифровое значение',
	value_date datetime COMMENT 'Цена объекта (может быть 0 - бесплатно)',
	value_boolean BOOLEAN COMMENT 'Логическое значение',
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
	UNIQUE KEY object_specifications_ad_id_specification_id_uk (ad_id, specification_id),
	CONSTRAINT object_specifications_specification_id_fk FOREIGN KEY (specification_id) REFERENCES specifications(id),
	CONSTRAINT object_specifications_ad_id_fk FOREIGN KEY (ad_id) REFERENCES advertisements(id) ON DELETE CASCADE
) COMMENT='Значение характеристик объекта';

DROP TABLE IF EXISTS object_media_files;

CREATE TABLE object_media_files (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор объекта',
	media_id INT UNSIGNED NOT NULL COMMENT 'Изображение объекта',
	ad_id INT UNSIGNED NOT NULL COMMENT 'Объявление',
	order_num INT UNSIGNED DEFAULT 0 NOT NULL COMMENT 'Порядок показа',
	finished_at DATETIME NOT NULL COMMENT 'Время прекращения предложения',
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
	CONSTRAINT object_media_files_ad_id_fk FOREIGN KEY (ad_id) REFERENCES advertisements(id),
	CONSTRAINT object_media_files_media_id_fk FOREIGN KEY (media_id) REFERENCES media_files(id) ON DELETE CASCADE
) COMMENT='Изображения объекта';

DROP TABLE IF EXISTS object_offers;

CREATE TABLE object_offers (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор объекта',
	user_id INT UNSIGNED NOT NULL COMMENT 'Пользователь, который вносит предложение',
	ad_id INT UNSIGNED NOT NULL COMMENT 'Объявление',
	offer varchar(255) NOT NULL COMMENT 'Текст предложения',
	replay varchar(255) NOT NULL COMMENT 'Текст ответа на предложение',
	finished_at DATETIME COMMENT 'Время прекращения предложения',
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
	UNIQUE KEY object_offers_ad_id_user_id_uk (ad_id, user_id),
	CONSTRAINT object_offers_ad_id_fk FOREIGN KEY (ad_id) REFERENCES advertisements(id),
	CONSTRAINT object_offers_users_id_fk FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) COMMENT='Предложения потенциальных покупателей к объекту';

DROP VIEW IF EXISTS object_specifications_view;
/*
 * Преобразует различные типы значений характеристик объекта к строке для вывода
 */
DROP VIEW object_specifications_view (id, ad_id, name, unit, object_value) AS
SELECT os.id, os.ad_id, s.name, u.short_name, 
	CASE 
		WHEN s.specification_type = 'STRING' THEN os.value_string 
		WHEN s.specification_type = 'DATE' THEN DATE_FORMAT(value_date, '%d.%m.%Y')
		WHEN s.specification_type = 'NUMBER' THEN FORMAT(value_number, 4)
		WHEN s.specification_type = 'BOOLEAN' THEN IF(value_boolean, 'Да', 'Нет')
		ELSE 'Неопределенный тип'
	END	
FROM object_specifications os 
	JOIN specifications s ON os.specification_id = s.id
	JOIN units u ON s.unit_id = u.id 

DROP VIEW IF EXISTS advertisements_view;
/*
 * Полная информация для формировании информации об объекте 
 */	
CREATE VIEW advertisements_view (id, title, description, price, full_name, user_id) AS
SELECT a.id, a.title, a.description, a.price, CONCAT(u.last_name, ' ', u.first_name, IF(LENGTH(TRIM(u.thrid_name)) > 0, CONCAT(' ', u.thrid_name), '')), u.id 
FROM advertisements a JOIN users u ON a.user_id=u.id
WHERE a.finished_at <= CURRENT_TIMESTAMP() AND u.is_active = TRUE;

DROP VIEW IF EXISTS user_profile;
/*
 * Полная информация о пользователе
 */
CREATE VIEW user_profile(id, user_type, full_name, gender, avatar_id) AS
SELECT u.id, 1, CONCAT(u.last_name, ' ', u.first_name, IF(LENGTH(TRIM(u.thrid_name)) > 0, CONCAT(' ', u.thrid_name), '')), p.gender,  p.avatar_id 
FROM users u JOIN profiles p on u.id = p.user_id 
UNION 
SELECT u.id, 2, e.name, '', e.avatar_id from users u JOIN enterprises e on u.id = e.id;



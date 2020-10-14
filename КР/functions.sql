DELIMITER $$

DROP FUNCTION IF EXISTS get_parameter_as_int$$

CREATE FUNCTION get_parameter_as_int(p_key varchar(30)) RETURNS INT READS SQL DATA
BEGIN
	DECLARE value_str VARCHAR(50);
	SELECT parameter_value FROM parameters where parameter_key=p_key INTO value_str;
	IF value_str IS NULL THEN
		SET @messageText = CONCAT("Ключ ", p_key, " не найден"); 
		SIGNAL SQLSTATE "45000"
    	SET MESSAGE_TEXT = @messageText;		
	END IF;
	RETURN CONVERT(value_str, SIGNED);
END$$

DROP FUNCTION IF EXISTS top_categories;

CREATE FUNCTION top_categories(pid int) RETURNS INT READS SQL DATA
BEGIN
	DECLARE prt_id INT;
	WHILE TRUE DO
		SELECT parent_id from categories c2 where id=pid INTO prt_id;
		IF prt_id is null THEN
			RETURN pid;
		END IF;
		SET pid = prt_id;
	END WHILE;
END$$


DELIMITER ;

SELECT id, name, top_categories(id) from categories c;


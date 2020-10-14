DELIMITER $$

DROP TRIGGER IF EXISTS advertisements_trg$$

/*
 * ������������� ������ ���� ���������� ������ ���������� �� ����������������
 * ����������
 */
CREATE TRIGGER adverisements_trg BEFORE INSERT ON advertisements
FOR EACH ROW BEGIN
	SET @days = get_parameter_as_int("advertisement.period.view");
	SET NEW.finished_at = DATE_ADD(Now(), INTERVAL @days DAY);
END;$$

DROP TRIGGER IF EXISTS object_media_files_trg$$
/**
 * ������������ ������� ������, �������� � ������������
 */
CREATE TRIGGER object_media_files_trg$$ BEFORE INSERT ON object_media_files
FOR EACH ROW BEGIN
	-- ��� ����� (1 - �����������, 2 - �����)
	DECLARE fileType INT;
	DECLARE fileCnt INT;
	DECLARE fileSize INT;
	DECLARE fileAddSize INT;
	DECLARE imageTypeCnt INT;
	DECLARE size INT;
	DECLARE videoTypeCnt INT;
	-- ����� ������ ������ 
	SET size = get_parameter_as_int("files.onuser.max.size");
	-- ���������� �����������
	SET imageTypeCnt = get_parameter_as_int("files.onuser.image.count");
	-- ���������� �����-������
	SET videoTypeCnt = get_parameter_as_int("files.onuser.video.count");
	-- ����� ��� � ������������ �����
	SELECT mft.file_type , mf.file_size FROM media_file_types mft JOIN media_files mf ON mf.type_id = mft.id WHERE mf.id = NEW.media_id INTO fileType, fileAddSize;
	SELECT count(*), sum(size) FROM media_files mf JOIN media_file_types mft ON mf.type_id = mft.id JOIN object_media_files omf ON omf.media_id = mf.id 
    -- ������� ��� ��������� �������������� �� ������������
	WHERE mft.file_type = 1 and omf.ad_id = NEW.ad_id INTO fileCnt, fileSize; 

	IF fileType = 1 THEN
		IF fileCnt > imageTypeCnt-1 OR fileSize + fileAddSize > size THEN 
			SIGNAL SQLSTATE "45000"
    			SET MESSAGE_TEXT = "����������� ������ ��������� � ����������. ��������� �����������";	
		END IF;
	ELSE
		IF fileCnt > 0 OR fileSize > size THEN 
			SIGNAL SQLSTATE "45000"
    			SET MESSAGE_TEXT = "����� ������ ��������� � ����������. ��������� �����������";	
		END IF;
	END IF;
END;$$

DROP TRIGGER IF EXISTS object_specifications_trg$$
/**
 * ��������� ������������ �������� �������������� ��� ����
 */
CREATE TRIGGER object_specifications_trg$$ BEFORE INSERT ON object_specifications
FOR EACH ROW BEGIN
	-- ��� �������������� (STRING, DATE, BOOLEAN, NUMBER)
	DECLARE specType varchar(10);
	SELECT s2.specification_type FROM specifications s2 where s2.id = NEW.specification_id INTO specType;
	CASE specType
		WHEN 'STRING' AND NEW.value_string is NULL THEN 
			SIGNAL SQLSTATE "45000"
    			SET MESSAGE_TEXT = "�������� �������� �������������� �������. ��������� ������";	
		WHEN 'DATE' AND NEW.value_date is NULL THEN 
			SIGNAL SQLSTATE "45000"
    			SET MESSAGE_TEXT = "�������� �������� �������������� �������. ��������� ����";	
		WHEN 'NUMBER' AND NEW.value_number is NULL THEN 
			SIGNAL SQLSTATE "45000"
    			SET MESSAGE_TEXT = "�������� �������� �������������� �������. ��������� �����";	
		WHEN 'BOOLEAV' AND NEW.value_boolean is NULL THEN 
			SIGNAL SQLSTATE "45000"
    			SET MESSAGE_TEXT = "�������� �������� �������������� �������. ��������� ���������� ��������";	
		ELSE
			SET @message = CONCAT('�� �������������� ��� ��������������; ', specType); 
			SIGNAL SQLSTATE "45000"
    			SET MESSAGE_TEXT = @message;	
		END CASE;
END;$$


DELIMITER ;




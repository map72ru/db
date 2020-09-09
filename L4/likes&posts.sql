CREATE TABLE likes (
	ID SERIAL PRIMARY KEY,
	CREATED_AT DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Время установки',
	LIKE_TYPE BOOLEAN NOT NULL DEFAULT true COMMENT 'Признак нравиться/не нравиться',
	FROM_USER_ID INT NOT NULL COMMENT 'Пользователь, поставивший лайк',
	TO_USER_ID INT COMMENT 'Лайк для пользователя',
	MESSAGE_ID INT COMMENT 'Лайк для сообщения',
	MEDIA_ID INT COMMENT 'Лайк для файла'
) COMMENT 'Лайки';

CREATE TABLE posts (
	ID SERIAL PRIMARY KEY,
	CREATED_AT DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания поста',
	MODIFIED_AT DATETIME ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время изменения поста',
	TEXT LONGTEXT NOT NULL COMMENT 'Текст поста',
	FROM_USER_ID INT NOT NULL COMMENT 'Пользователь, написавший пост',
	TO_USER_ID INT COMMENT 'Для какого пользователя'
) COMMENT 'Посты';
	
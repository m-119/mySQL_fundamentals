DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;

-- Делаем её текущей
USE vk;

-- Создаём таблицу пользователей
CREATE TABLE users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  first_name VARCHAR(100) NOT NULL COMMENT "Имя пользователя",
  last_name VARCHAR(100) NOT NULL COMMENT "Фамилия пользователя",
  email VARCHAR(100) NOT NULL UNIQUE COMMENT "Почта",
  phone VARCHAR(100) NOT NULL UNIQUE COMMENT "Телефон",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Пользователи";  

-- Таблица профилей
CREATE TABLE profiles (
  user_id INT UNSIGNED NOT NULL PRIMARY KEY COMMENT "Ссылка на пользователя", 
  gender CHAR(1) COMMENT "Пол",
  birthday DATE COMMENT "Дата рождения",
  photo_id INT UNSIGNED COMMENT "Ссылка на основную фотографию пользователя",
  status VARCHAR(30) COMMENT "Текущий статус",
  city VARCHAR(130) COMMENT "Город проживания",
  country VARCHAR(130) COMMENT "Страна проживания",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Профили"; 

-- Таблица сообщений
CREATE TABLE messages (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  from_user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на отправителя сообщения",
  to_user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на получателя сообщения",
  body TEXT NOT NULL COMMENT "Текст сообщения",
  is_important BOOLEAN COMMENT "Признак важности",
  is_delivered BOOLEAN COMMENT "Признак доставки",
  created_at DATETIME DEFAULT NOW() COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Сообщения";

-- Таблица дружбы
CREATE TABLE friendship (
  user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на инициатора дружеских отношений",
  friend_id INT UNSIGNED NOT NULL COMMENT "Ссылка на получателя приглашения дружить",
  status_id INT UNSIGNED NOT NULL COMMENT "Ссылка на статус (текущее состояние) отношений",
  requested_at DATETIME DEFAULT NOW() COMMENT "Время отправления приглашения дружить",
  confirmed_at DATETIME COMMENT "Время подтверждения приглашения",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",  
  PRIMARY KEY (user_id, friend_id) COMMENT "Составной первичный ключ"
) COMMENT "Таблица дружбы";

-- Таблица статусов дружеских отношений
CREATE TABLE friendship_statuses (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  name VARCHAR(150) NOT NULL UNIQUE COMMENT "Название статуса",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"  
) COMMENT "Статусы дружбы";

-- Таблица групп
CREATE TABLE communities (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор сроки",
  name VARCHAR(150) NOT NULL UNIQUE COMMENT "Название группы",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"  
) COMMENT "Группы";

-- Таблица связи пользователей и групп
CREATE TABLE communities_users (
  community_id INT UNSIGNED NOT NULL COMMENT "Ссылка на группу",
  user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки", 
  PRIMARY KEY (community_id, user_id) COMMENT "Составной первичный ключ"
) COMMENT "Участники групп, связь между пользователями и группами";

-- Таблица медиафайлов
CREATE TABLE media (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя, который загрузил файл",
  filename VARCHAR(255) NOT NULL COMMENT "Путь к файлу",
  size INT NOT NULL COMMENT "Размер файла",
  metadata JSON COMMENT "Метаданные файла",
  media_type_id INT UNSIGNED NOT NULL COMMENT "Ссылка на тип контента",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Медиафайлы";

-- Таблица типов медиафайлов
CREATE TABLE media_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  name VARCHAR(255) NOT NULL UNIQUE COMMENT "Название типа",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Типы медиафайлов";

-- Таблица постов
CREATE TABLE posts (
  id int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя", 
  txt varchar(4000) NOT NULL COMMENT 'Текст поста',
  created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  PRIMARY KEY (id)
) COMMENT='Посты пользователя';

-- Таблица лайков
CREATE TABLE likes (
  id int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  l_type VARCHAR(5) NOT NULL COMMENT "Тип лайка",
  l_id INT UNSIGNED NOT NULL COMMENT "Ссылка на объект лайка", 
  user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя",
  PRIMARY KEY (id)
) COMMENT='Лайки пользователя';

-- FK's
-- профиль
ALTER TABLE profiles
ADD CONSTRAINT FK_profiles_user_id
FOREIGN KEY (user_id) REFERENCES users(id);
-- посты
ALTER TABLE posts
ADD CONSTRAINT FK_posts_user_id
FOREIGN KEY (user_id) REFERENCES users(id);
-- сообщения:от
ALTER TABLE messages
ADD CONSTRAINT FK_messages_f_user_id
FOREIGN KEY (from_user_id) REFERENCES users(id);
-- сообщения:кому
ALTER TABLE messages
ADD CONSTRAINT FK_messages_t_user_id
FOREIGN KEY (to_user_id) REFERENCES users(id);
-- медиа:тип
ALTER TABLE media
ADD CONSTRAINT FK_media_types
FOREIGN KEY (media_type_id) REFERENCES media_types(id);
-- медиа:владелец
ALTER TABLE media
ADD CONSTRAINT FK_media_user_id
FOREIGN KEY (user_id) REFERENCES users(id);
-- дружба:пользователь
ALTER TABLE friendship
ADD CONSTRAINT FK_friendship_user_id
FOREIGN KEY (user_id) REFERENCES users(id);
-- дружба:друг
ALTER TABLE friendship
ADD CONSTRAINT FK_friendship_friend_id
FOREIGN KEY (friend_id) REFERENCES users(id);
-- дружба:статус
ALTER TABLE friendship
ADD CONSTRAINT FK_friendship_statuses
FOREIGN KEY (status_id) REFERENCES friendship_statuses(id);
-- группы:пользователь
ALTER TABLE communities_users
ADD CONSTRAINT FK_communities_users_user_id
FOREIGN KEY (user_id) REFERENCES users(id);
-- группы:группы
ALTER TABLE communities_users
ADD CONSTRAINT FK_communities_users_communities_id
FOREIGN KEY (community_id) REFERENCES communities(id);
-- Ограничение на типы лайков
ALTER TABLE likes
ADD CONSTRAINT like_types CHECK (l_type in ('media', 'post', 'user'));


DELIMITER $$

-- функция корректного инсерта случайных значений
CREATE FUNCTION RAND_ID_T(t VARCHAR(20)) RETURNS INT
    DETERMINISTIC
BEGIN
	DECLARE i int DEFAULT 1;
	IF t = 'communities'
		THEN SET i = (SELECT id FROM communities ORDER BY RAND() LIMIT 1);
	ELSEIF t = 'communities_users'
		THEN SET i = (SELECT id FROM communities_users ORDER BY RAND() LIMIT 1);
	ELSEIF t = 'friendship'
		THEN SET i = (SELECT id FROM friendship ORDER BY RAND() LIMIT 1);
	ELSEIF t = 'friendship_statuses'
		THEN SET i = (SELECT id FROM friendship_statuses ORDER BY RAND() LIMIT 1);
	ELSEIF t = 'likes'
		THEN SET i = (SELECT id FROM likes ORDER BY RAND() LIMIT 1);
	ELSEIF t = 'media'
		THEN SET i = (SELECT id FROM media ORDER BY RAND() LIMIT 1);
	ELSEIF t = 'media_types'
		THEN SET i = (SELECT id FROM media_types ORDER BY RAND() LIMIT 1);
	ELSEIF t = 'messages'
		THEN SET i = (SELECT id FROM messages ORDER BY RAND() LIMIT 1);
	ELSEIF t = 'posts'
		THEN SET i = (SELECT id FROM posts ORDER BY RAND() LIMIT 1);
	ELSEIF t = 'profiles'
		THEN SET i = (SELECT id FROM profiles ORDER BY RAND() LIMIT 1);
	ELSEIF t = 'users'
		THEN SET i = (SELECT id FROM users ORDER BY RAND() LIMIT 1);
	ELSE SET i = 1;
	END IF;

	RETURN i;
	
END$$

-- Обработчик инсерта лайков
CREATE TRIGGER likes_types_i BEFORE INSERT ON likes
    FOR EACH ROW BEGIN
	    DECLARE tp VARCHAR(5) default '';
		DECLARE nba INT default 0;

		SET tp = NEW.l_type;
       
		IF tp = 'media'
		THEN SET nba = (SELECT COUNT(id) FROM media WHERE media.id = NEW.l_id);
		ELSEIF tp = 'post'
		THEN SET nba = (SELECT COUNT(id) FROM user_post WHERE user_post.id = NEW.l_id);
		ELSEIF tp = 'user'
		THEN SET nba = (SELECT COUNT(id) FROM user WHERE user.id = NEW.l_id);
		END IF;
		
		IF tp = 1
		THEN INSERT INTO likes (l_type,l_id,user_id) VALUES (NEW.l_type,NEW.l_id,NEW.user_id);
		ELSE SIGNAL SQLSTATE '90909' set message_text = 'Некорректность';
		END IF;

    END$$

-- Обработчик апдейта лайков
CREATE TRIGGER likes_types_u BEFORE UPDATE ON likes
    FOR EACH ROW BEGIN
	    DECLARE tp VARCHAR(5) default '';
		DECLARE nba INT default 0;

		SET tp = NEW.l_type;
       
		IF tp = 'media'
		THEN SET nba = (SELECT COUNT(id) FROM media WHERE media.id = NEW.l_id);
		ELSEIF tp = 'post'
		THEN SET nba = (SELECT COUNT(id) FROM user_post WHERE user_post.id = NEW.l_id);
		ELSEIF tp = 'user'
		THEN SET nba = (SELECT COUNT(id) FROM user WHERE user.id = NEW.l_id);
		END IF;
		
		IF tp = 1
		THEN INSERT INTO likes (l_type,l_id,user_id) VALUES (NEW.l_type,NEW.l_id,NEW.user_id);
		ELSE SIGNAL SQLSTATE '90909' set message_text = 'Некорректность';
		END IF;

    END$$
	
-- Триггеры профиля
CREATE TRIGGER profiles_i
BEFORE INSERT ON profiles
	FOR EACH ROW
 
BEGIN
	DECLARE gndr VARCHAR(1) default '';
	DECLARE crt DATETIME default NOW();
	DECLARE upd DATETIME default NOW();
	DECLARE crt_n DATETIME  default NEW.created_at;
	DECLARE upd_n DATETIME  default NEW.updated_at;
	IF NEW.gender NOT IN ('m','f')
	THEN SET gndr = NULL;
	END IF;
	IF crt_n < upd_n
	THEN SET crt = NEW.created_at;
		SET upd = NEW.updated_at;
	END IF;
	
	SET NEW.gender = gndr;
	SET NEW.created_at = crt;
	SET NEW.updated_at = upd;
 
END$$

CREATE TRIGGER profiles_u
BEFORE UPDATE ON profiles
	FOR EACH ROW
 
BEGIN
	DECLARE gndr VARCHAR(1) default '';
	DECLARE crt DATETIME default NOW();
	DECLARE upd DATETIME default NOW();
	DECLARE crt_n DATETIME  default NEW.created_at;
	DECLARE upd_n DATETIME  default NEW.updated_at;
	IF NEW.gender NOT IN ('m','f')
	THEN SET gndr = NULL;
	END IF;
	IF crt_n < upd_n
	THEN SET crt = NEW.created_at;
		SET upd = NEW.updated_at;
	END IF;
	
	SET NEW.gender = gndr;
	SET NEW.created_at = crt;
	SET NEW.updated_at = upd;
 
END$$

-- триггеры на пользователе
CREATE TRIGGER users_i
BEFORE INSERT ON users
	FOR EACH ROW
 
BEGIN
	DECLARE crt DATETIME default NOW();
	DECLARE upd DATETIME default NOW();
	DECLARE crt_n DATETIME  default NEW.created_at;
	DECLARE upd_n DATETIME  default NEW.updated_at;
	IF crt_n < upd_n
	THEN SET crt = NEW.created_at;
		SET upd = NEW.updated_at;
	END IF;
	
	SET NEW.created_at = crt;
	SET NEW.updated_at = upd;
 
END$$

CREATE TRIGGER users_u
BEFORE UPDATE ON users
	FOR EACH ROW
 
BEGIN
	DECLARE crt DATETIME default NOW();
	DECLARE upd DATETIME default NOW();
	DECLARE crt_n DATETIME  default NEW.created_at;
	DECLARE upd_n DATETIME  default NEW.updated_at;
	IF crt_n < upd_n
	THEN SET crt = NEW.created_at;
		SET upd = NEW.updated_at;
	END IF;
	
	SET NEW.created_at = crt;
	SET NEW.updated_at = upd;
 
END$$

-- триггер постов
CREATE TRIGGER posts_i
BEFORE INSERT ON posts
	FOR EACH ROW
 
BEGIN
	DECLARE crt DATETIME default NOW();
	DECLARE upd DATETIME default NOW();
	DECLARE crt_n DATETIME  default NEW.created_at;
	DECLARE upd_n DATETIME  default NEW.updated_at;
	IF crt_n < upd_n
	THEN SET crt = NEW.created_at;
		SET upd = NEW.updated_at;
	END IF;
	
	SET NEW.created_at = crt;
	SET NEW.updated_at = upd;
 
END$$

CREATE TRIGGER posts_u
BEFORE UPDATE ON posts
	FOR EACH ROW
 
BEGIN
	DECLARE crt DATETIME default NOW();
	DECLARE upd DATETIME default NOW();
	DECLARE crt_n DATETIME  default NEW.created_at;
	DECLARE upd_n DATETIME  default NEW.updated_at;
	IF crt_n < upd_n
	THEN SET crt = NEW.created_at;
		SET upd = NEW.updated_at;
	END IF;
	
	SET NEW.created_at = crt;
	SET NEW.updated_at = upd;

END$$

-- триггер сообщений
CREATE TRIGGER messages_i
BEFORE INSERT ON messages
	FOR EACH ROW
 
BEGIN
	DECLARE crt DATETIME default NOW();
	DECLARE upd DATETIME default NOW();
	DECLARE crt_n DATETIME  default NEW.created_at;
	DECLARE upd_n DATETIME  default NEW.updated_at;
	DECLARE msg1 INT default NEW.from_user_id;
	DECLARE msg2 INT default NEW.to_user_id;
	IF crt_n < upd_n
	THEN SET crt = NEW.created_at;
		SET upd = NEW.updated_at;
	END IF;
	
	SET NEW.created_at = crt;
	SET NEW.updated_at = upd;
	
	IF msg1 = msg2
	THEN SIGNAL SQLSTATE '90906' set message_text = 'Сообщение себе';
	END IF;
 
END$$

CREATE TRIGGER messages_u
BEFORE UPDATE ON messages
	FOR EACH ROW
 
BEGIN
	DECLARE crt DATETIME default NOW();
	DECLARE upd DATETIME default NOW();
	DECLARE crt_n DATETIME  default NEW.created_at;
	DECLARE upd_n DATETIME  default NEW.updated_at;
	DECLARE msg1 INT default NEW.from_user_id;
	DECLARE msg2 INT default NEW.to_user_id;
	IF crt_n < upd_n
	THEN SET crt = NEW.created_at;
		SET upd = NEW.updated_at;
	END IF;
	
	SET NEW.created_at = crt;
	SET NEW.updated_at = upd;

	IF msg1 = msg2
	THEN SIGNAL SQLSTATE '90906' set message_text = 'Сообщение себе';
	END IF;

END$$

-- триггер дружбы
CREATE TRIGGER friendship_i
BEFORE INSERT ON friendship
	FOR EACH ROW
 
BEGIN
	DECLARE crt DATETIME default NOW();
	DECLARE upd DATETIME default NOW();
	DECLARE crt_n DATETIME  default NEW.created_at;
	DECLARE upd_n DATETIME  default NEW.updated_at;
	DECLARE st1 DATETIME default NEW.requested_at;
	DECLARE st2 DATETIME default NEW.confirmed_at;
	IF crt_n < upd_n
	THEN SET crt = NEW.created_at;
		SET upd = NEW.updated_at;
	END IF;
	
	IF st2 < st1
	THEN SET st1 = NOW();
		SET st2 = NOW();
	END IF;
	
	SET NEW.created_at = crt;
	SET NEW.updated_at = upd;
	SET NEW.requested_at = st1;
	SET NEW.confirmed_at = st2;
	
	IF NEW.user_id = NEW.friend_id
	THEN SIGNAL SQLSTATE '90905' set message_text = 'Самодружба';
	END IF;
 
END$$

CREATE TRIGGER friendship_u
BEFORE UPDATE ON friendship
	FOR EACH ROW
 
BEGIN
	DECLARE crt DATETIME default NOW();
	DECLARE upd DATETIME default NOW();
	DECLARE crt_n DATETIME  default NEW.created_at;
	DECLARE upd_n DATETIME  default NEW.updated_at;
	DECLARE st1 DATETIME default NEW.requested_at;
	DECLARE st2 DATETIME default NEW.confirmed_at;
	IF crt_n < upd_n
	THEN SET crt = NEW.created_at;
		SET upd = NEW.updated_at;
	END IF;
	
	IF st2 < st1
	THEN SET st1 = NOW();
		SET st2 = NOW();
	END IF;
	
	SET NEW.created_at = crt;
	SET NEW.updated_at = upd;
	SET NEW.requested_at = st1;
	SET NEW.confirmed_at = st2;
	
	IF NEW.user_id = NEW.friend_id
	THEN SIGNAL SQLSTATE '90905' set message_text = 'Самодружба';
	END IF;
 
END$$

DELIMITER ;

-- Рекомендуемый стиль написания кода SQL
-- https://www.sqlstyle.guide/ru/

-- Заполняем таблицы с учётом отношений 
-- на http://filldb.info

-- users
INSERT INTO users (first_name,last_name,email,phone) VALUES ('Oren','Oberbrunner','quigley.enos@example.org','603.727.9090'),('Jeromy','Feest','xlang@example.org','582.698.6972x2911'),('Cristina','Dibbert','leffler.deron@example.org','412-081-8531'),('Eunice','Kshlerin','judd93@example.net','1-085-923-1080x6875'),('Evans','Botsford','hweissnat@example.net','124.342.9789x21352'),('Minnie','Klocko','vmohr@example.com','668.878.5994x263'),('Nakia','Heller','antonio40@example.org','189.551.7482'),('Jaron','Eichmann','rylee43@example.org','573-143-8165'),('Henri','Green','astrid.koss@example.com','1-993-555-0757x734'),('Jaiden','Sawayn','little.sabrina@example.org','378.660.3765x6879'),('Brandy','Roob','rita.cruickshank@example.net','+88(0)2734486199'),('Sheila','Kreiger','nathaniel13@example.com','(307)846-1183'),('Dariana','Hoeger','jacobson.giovanny@example.org','(493)141-0047x444'),('Laury','Watsica','fay.roberts@example.com','(575)040-4787x5940'),('Myah','Mohr','beverly62@example.org','065-837-9478x215'),('Nat','Schumm','ewhite@example.net','090-184-5738x187'),('Constantin','Bayer','arvilla37@example.org','(262)345-2751'),('Clark','Kovacek','igottlieb@example.net','1-244-074-6496'),('Buddy','Raynor','toy.prosacco@example.net','1-677-139-4935x04468'),('Alicia','Olson','kaylah.will@example.com','303.551.3450x4500'),('Demarcus','Reinger','jonas.ortiz@example.net','(561)202-5387x333'),('Hattie','Lowe','maynard.stroman@example.org','1-332-740-4582'),('Tyrese','Kemmer','tcronin@example.com','332.778.9964'),('River','Paucek','gutkowski.leanna@example.com','+96(1)4369622450'),('Chase','Gislason','rmann@example.com','159.509.4817x178'),('Ned','Hermann','wiegand.wanda@example.net','+68(2)1000641522'),('Wallace','Weissnat','margot21@example.com','1-268-658-0833'),('Diana','Zieme','istanton@example.net','01869669352'),('Kaylin','Schinner','elyse.gerhold@example.net','(716)573-6034x624'),('Jody','Conn','olin.larson@example.com','060-549-5125'),('Frederik','Mertz','flavio.veum@example.org','(238)155-7340'),('Hildegard','Dibbert','gibson.ellsworth@example.net','444-226-2344x0747'),('Tate','Larson','denesik.chyna@example.net','1-519-198-8990x20777'),('Martine','Lueilwitz','kparisian@example.org','+70(4)5004991141'),('Jesse','Little','xavier70@example.org','(197)650-3964'),('Emie','Deckow','gsanford@example.org','574.883.7890x063'),('Haskell','Jenkins','tkrajcik@example.org','+18(4)3549186688'),('Isac','Kuhn','kailyn.swaniawski@example.com','051.863.1853'),('Delia','Goyette','kassandra91@example.org','513.129.8407'),('Darrel','Hackett','mossie.hayes@example.net','408-180-6998'),('Vella','Towne','xmertz@example.com','(789)331-1365'),('Elvera','Kunze','lisette.bechtelar@example.com','784-963-1133'),('Maverick','Ratke','joe94@example.com','862.405.6135x0523'),('Clement','Cormier','terdman@example.org','1-557-301-9975'),('Rosie','Gleason','pdurgan@example.org','981.972.4099'),('Eden','King','ona21@example.com','192.450.3542'),('Narciso','Bosco','glenna85@example.net','553-415-7313x390'),('Jarod','Sawayn','tpredovic@example.org','787-985-1912x62638'),('Judah','Kuhlman','conn.noe@example.com','436-005-8023'),('Kurt','Turcotte','ycruickshank@example.com','+38(9)3290685243'),('Elnora','Torp','agustin.stehr@example.org','1-562-255-1311x3610'),('Lucious','Emard','ressie75@example.org','1-559-944-0852'),('Lessie','Stracke','wyman.mallie@example.com','722.584.9867x9696'),('Leon','Zboncak','rkeebler@example.net','(292)533-3272x42893'),('Tia','Hilpert','stan.prosacco@example.org','103-239-2323'),('Lysanne','Beier','spouros@example.com','922.535.9674'),('Mertie','Predovic','ewisoky@example.com','06220586542'),('Manuela','Runte','stacey.weissnat@example.org','175.874.1364x9388'),('Gage','Pfeffer','gaylord84@example.com','378.385.4034x79752'),('Jerad','Hammes','aileen91@example.net','083-327-3479x013'),('Oran','Marvin','dayton03@example.com','(276)553-0857x35355'),('Zaria','Klocko','igaylord@example.org','03992240098'),('Osborne','Mante','sschaefer@example.org','1-129-145-2706x9895'),('Kadin','Buckridge','lamont28@example.com','960.239.1800x57978'),('Cortez','Nicolas','heller.lorna@example.com','(740)145-1362x36063'),('Dangelo','Gleichner','colleen.haag@example.org','(718)859-3111x57384'),('Anastasia','Harvey','dickens.norbert@example.org','1-043-815-2246'),('Keenan','Sawayn','jones.reinhold@example.org','873-899-1782x642'),('Eva','Hills','nbogisich@example.net','424-277-1769x380'),('Tommie','Greenholt','kuhic.david@example.net','03613096745'),('Nyah','Barrows','muller.lilyan@example.org','+93(2)1422753049'),('Shad','Okuneva','usenger@example.net','1-739-441-7720'),('Peggie','Durgan','rory24@example.com','269-059-7981x9250'),('Freda','Hagenes','josephine.bauch@example.org','524.142.2023x7647'),('Kiera','Sawayn','fanny.hane@example.org','07164782730'),('Elliott','Mayert','cesar.weimann@example.org','1-994-216-7205'),('Susana','Schiller','zfarrell@example.net','1-907-493-4002x79401'),('Rudolph','Halvorson','bernier.jose@example.org','595-090-1632x297'),('Adah','Feil','senger.alverta@example.net','1-867-329-2221x2583'),('Frederic','Pouros','dannie.abshire@example.com','1-131-828-9745'),('Annamae','Kuhlman','jamison.willms@example.org','(263)471-6141x12344'),('Alex','Jacobson','beverly04@example.com','(730)634-0257'),('Izabella','Gorczany','casper.felicity@example.net','(436)664-3483'),('Jesus','Parisian','freddie65@example.org','00967934814'),('Antonette','Rippin','makayla17@example.org','989.948.1088x70314'),('Ernestina','Russel','art.lebsack@example.net','+99(5)6239512112'),('Lera','Jones','barton14@example.org','1-796-992-7062x27755'),('Jailyn','Hills','elvera56@example.com','+38(6)9880894628'),('Tyra','Heaney','golden58@example.org','(160)503-0186x825'),('Conner','Durgan','owuckert@example.org','(150)208-2951'),('Shanna','Jast','cdavis@example.org','1-664-150-4081x89245'),('Arturo','Langosh','crooks.mortimer@example.org','1-702-507-7672x91495'),('Roxanne','Balistreri','evan.kautzer@example.net','821.116.6781'),('Alyce','Krajcik','jspencer@example.org','(645)902-8488x7572'),('Ismael','Blick','kristian32@example.com','1-895-308-0354x491'),('Korey','Herman','blanca.breitenberg@example.org','1-707-596-0875x2008'),('Beaulah','Metz','zullrich@example.net','+12(9)1606031383'),('Giovanni','Bartell','kaia.bogan@example.net','492.965.6005x6003'),('Tess','Mayer','miller.art@example.org','212-048-8973x629'),('Stevie','Glover','arvilla67@example.net','576.819.9249x0469');
-- типы медиа
INSERT INTO vk.media_types (name) VALUES('audio'),('image'),('video');
-- медиа
INSERT INTO media (user_id,filename,size,metadata,media_type_id) VALUES (1,'illo',93925118,NULL,1),(RAND_ID_T('users'),'et',12802,NULL,2),(RAND_ID_T('users'),'consequuntur',9738,NULL,3),(RAND_ID_T('users'),'rem',50207783,NULL,1),(RAND_ID_T('users'),'libero',407767,NULL,2),(RAND_ID_T('users'),'omnis',1748,NULL,3),(RAND_ID_T('users'),'pariatur',731915,NULL,1),(RAND_ID_T('users'),'asperiores',187876896,NULL,2),(RAND_ID_T('users'),'voluptatem',0,NULL,3),(RAND_ID_T('users'),'quis',64,NULL,1),(RAND_ID_T('users'),'aperiam',31557,NULL,2),(RAND_ID_T('users'),'nisi',75344113,NULL,3),(RAND_ID_T('users'),'aut',0,NULL,1),(RAND_ID_T('users'),'ut',6773500,NULL,2),(RAND_ID_T('users'),'ipsam',83184,NULL,3),(RAND_ID_T('users'),'nemo',5565612,NULL,1),(RAND_ID_T('users'),'dignissimos',580465513,NULL,2),(RAND_ID_T('users'),'adipisci',978530,NULL,3),(RAND_ID_T('users'),'totam',244,NULL,1),(RAND_ID_T('users'),'accusantium',1117,NULL,2),(RAND_ID_T('users'),'sed',6415,NULL,3),(RAND_ID_T('users'),'labore',6847461,NULL,1),(RAND_ID_T('users'),'quia',657,NULL,2),(RAND_ID_T('users'),'enim',161720,NULL,3),(RAND_ID_T('users'),'in',87732,NULL,1),(RAND_ID_T('users'),'architecto',223451,NULL,2),(RAND_ID_T('users'),'rerum',19654,NULL,3),(RAND_ID_T('users'),'tempore',483,NULL,1),(RAND_ID_T('users'),'sed',7025,NULL,2),(RAND_ID_T('users'),'quia',128172,NULL,3),(RAND_ID_T('users'),'voluptatem',0,NULL,1),(RAND_ID_T('users'),'inventore',0,NULL,2),(RAND_ID_T('users'),'consequatur',461965,NULL,3),(RAND_ID_T('users'),'enim',0,NULL,1),(RAND_ID_T('users'),'non',22,NULL,2),(RAND_ID_T('users'),'cupiditate',723,NULL,3),(RAND_ID_T('users'),'aperiam',556226,NULL,1),(RAND_ID_T('users'),'asperiores',968,NULL,2),(RAND_ID_T('users'),'quos',66,NULL,3),(RAND_ID_T('users'),'ducimus',55185,NULL,1),(RAND_ID_T('users'),'qui',955790,NULL,2),(RAND_ID_T('users'),'pariatur',65,NULL,3),(RAND_ID_T('users'),'eos',8583,NULL,1),(RAND_ID_T('users'),'amet',64,NULL,2),(RAND_ID_T('users'),'est',7,NULL,3),(RAND_ID_T('users'),'neque',30958,NULL,1),(RAND_ID_T('users'),'aut',64,NULL,2),(RAND_ID_T('users'),'dolorum',38222,NULL,3),(RAND_ID_T('users'),'incidunt',449454881,NULL,1),(RAND_ID_T('users'),'illum',7691,NULL,2),(RAND_ID_T('users'),'quia',541803,NULL,3),(RAND_ID_T('users'),'aut',96450,NULL,1),(RAND_ID_T('users'),'cupiditate',511,NULL,2),(RAND_ID_T('users'),'porro',103844,NULL,3),(RAND_ID_T('users'),'reprehenderit',98338043,NULL,1),(RAND_ID_T('users'),'in',744473,NULL,2),(RAND_ID_T('users'),'reprehenderit',7,NULL,3),(RAND_ID_T('users'),'voluptas',16679097,NULL,1),(RAND_ID_T('users'),'eos',30285,NULL,2),(RAND_ID_T('users'),'facere',5970445,NULL,3),(RAND_ID_T('users'),'saepe',42839,NULL,1),(RAND_ID_T('users'),'ratione',25160,NULL,2),(RAND_ID_T('users'),'eius',0,NULL,3),(RAND_ID_T('users'),'qui',0,NULL,1),(RAND_ID_T('users'),'voluptatem',296324670,NULL,2),(RAND_ID_T('users'),'hic',85824011,NULL,3),(RAND_ID_T('users'),'sit',686,NULL,1),(RAND_ID_T('users'),'veritatis',839243,NULL,2),(RAND_ID_T('users'),'et',162950,NULL,3),(RAND_ID_T('users'),'dolorem',348320072,NULL,1),(RAND_ID_T('users'),'sed',55,NULL,2),(RAND_ID_T('users'),'laboriosam',275890,NULL,3),(RAND_ID_T('users'),'doloremque',253,NULL,1),(RAND_ID_T('users'),'non',3779,NULL,2),(RAND_ID_T('users'),'in',96121,NULL,3),(RAND_ID_T('users'),'dolore',123544,NULL,1),(RAND_ID_T('users'),'exercitationem',3,NULL,2),(RAND_ID_T('users'),'et',20156,NULL,3),(RAND_ID_T('users'),'omnis',67093290,NULL,1),(RAND_ID_T('users'),'quisquam',33205902,NULL,2),(RAND_ID_T('users'),'adipisci',2716,NULL,3),(RAND_ID_T('users'),'voluptatem',884,NULL,1),(RAND_ID_T('users'),'ut',0,NULL,2),(RAND_ID_T('users'),'eveniet',9,NULL,3),(RAND_ID_T('users'),'odio',26383263,NULL,1),(RAND_ID_T('users'),'dicta',2592,NULL,2),(RAND_ID_T('users'),'odio',948833426,NULL,3),(RAND_ID_T('users'),'id',1,NULL,1),(RAND_ID_T('users'),'eius',772674521,NULL,2),(RAND_ID_T('users'),'laborum',5,NULL,3),(RAND_ID_T('users'),'deserunt',0,NULL,1),(RAND_ID_T('users'),'et',1539,NULL,2),(RAND_ID_T('users'),'sint',50407,NULL,3),(RAND_ID_T('users'),'libero',12078572,NULL,1),(RAND_ID_T('users'),'autem',75343977,NULL,2),(RAND_ID_T('users'),'est',59512,NULL,3),(RAND_ID_T('users'),'tenetur',99624,NULL,1),(RAND_ID_T('users'),'rerum',0,NULL,2),(RAND_ID_T('users'),'nisi',58,NULL,3),(RAND_ID_T('users'),'labore',91776,NULL,1);
-- файл как ссылка + мета
DROP TABLE IF EXISTS med_typ;
CREATE TEMPORARY TABLE med_typ
(type_m INT,
extn_m VARCHAR(20));
 
INSERT INTO med_typ
VALUES (1,'.mp3'),
        (1,'.mp2'),
        (1,'.wav'),
        (2,'.jpg'),
        (2,'.png'),
        (2,'.gif'),
        (3,'.mp4'),
        (3,'.flv');

UPDATE media SET metadata = CONCAT('{"owner":"', 
  (SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id = user_id),
  '","filename":"',
  (CONCAT(filename,(SELECT extn_m FROM med_typ WHERE type_m=media.media_type_id ORDER BY RAND() LIMIT 1))),
  '"}');
UPDATE media SET filename = CONCAT('https://dropbox.net/vk/',filename,(SELECT extn_m FROM med_typ WHERE type_m=media_type_id ORDER BY RAND() LIMIT 1));
DROP TABLE med_typ;

-- profiles
DROP TABLE IF EXISTS gender;
INSERT INTO profiles(user_id,gender,birthday,photo_id,status,city,country) VALUES (1,'','2016-03-27',null,'Qui id fugiat similique est do','Port Leomouth','50'),(2,'','1970-08-09',null,'Mollitia et saepe ullam volupt','Rickfort','87260151'),(3,'','1971-09-05',null,'Eum fugiat officia velit et eu','Port Rethaville','2105'),(4,'','1971-10-27',null,'Est sunt illo eligendi nobis q','Port Lily','81'),(5,'','1981-05-14',null,'Praesentium id omnis dolor pla','Schmidtbury',''),(6,'','1978-09-15',null,'Iure officia porro ipsam et. V','East Carlie','86'),(7,'','2009-08-26',null,'Ratione eveniet maxime quidem ','East Forestborough','648738542'),(8,'','1997-01-01',null,'Eum blanditiis eum numquam et ','Lake Soledad','6461'),(9,'','1996-06-02',null,'Nemo laudantium eveniet vel vo','Lake Titus','129887'),(10,'','1988-07-09',10,'Doloribus ut libero nulla erro','South Kurtisburgh','23268'),(11,'','1985-07-24',11,'Qui voluptas omnis eligendi et','Torpmouth','7097340'),(12,'','1974-08-22',12,'Dicta asperiores illo quisquam','Welchside','1192'),(13,'','1982-04-29',13,'Ut hic in sit repellat debitis','Marlenborough','5'),(14,'','1997-12-16',14,'Voluptatem quia quas voluptate','New Price','2125653'),(15,'','2000-12-02',15,'Alias maxime amet iste rerum r','New Gladysside','73730578'),(16,'','1986-04-29',16,'Nihil ducimus ratione esse min','Willmsport','16'),(17,'','1996-11-10',17,'Et et debitis voluptas et aut ','Laurieborough','951472197'),(18,'','1994-11-13',18,'Ut vel quia saepe sit nihil ar','Lake Nilschester','9497'),(19,'','2017-08-16',19,'Est non ab consectetur aut mol','West Savanah','41205682'),(20,'','1984-03-13',20,'Cupiditate non vel vitae volup','Windlerberg','544477'),(21,'','1970-11-15',21,'Assumenda inventore molestiae ','Kentonhaven','8168723'),(22,'','2014-03-07',22,'Illum nisi laudantium vel impe','Kuvalistown','40'),(23,'','1970-03-25',23,'Est magni quasi minima sint cu','Balistreristad','2421'),(24,'','1974-09-08',24,'Praesentium saepe quo asperior','North Leta','270176428'),(25,'','2007-07-21',25,'Mollitia asperiores asperiores','Ednachester','7'),(26,'','1980-08-26',26,'Illo minus nisi cumque ut veni','Port Bernhardfort','5'),(27,'','1991-02-28',27,'Laboriosam rem id quae totam c','North Hendersonshire','79573424'),(28,'','2019-11-29',28,'Eaque in incidunt autem doloru','Nicholaustown','83'),(29,'','1978-07-30',29,'Nesciunt sit vero enim eius es','Lake Maeveshire','393332'),(30,'','1986-09-29',30,'Illum consequuntur soluta ut. ','Rennerchester','141914'),(31,'','1990-07-07',31,'Autem voluptas voluptatem ab u','Luciusview',''),(32,'','1981-04-30',32,'Voluptas expedita esse sunt. E','New Chesley','85702985'),(33,'','1980-05-27',33,'Omnis vel quaerat minus eligen','Lake Valeriebury','4776'),(34,'','2011-04-29',34,'Et harum ut placeat qui quia. ','West Adalberto','585'),(35,'','1989-02-09',35,'Ea omnis saepe ad culpa accusa','Raubury','989829'),(36,'','1990-06-25',36,'Error voluptatem facilis nostr','North Stephenfurt','62208'),(37,'','1998-02-06',37,'Dolorem provident natus et vol','Erdmanton',''),(38,'','1977-04-29',38,'Ut est quam accusantium nulla ','East Melbaton','1193103'),(39,'','1978-07-23',39,'Doloremque velit ipsa ut. Cons','Trantowmouth','74432'),(40,'','2003-11-27',40,'Eveniet consequatur tempora et','Crooksfurt','964325607'),(41,'','2000-10-04',41,'Dolorem quidem odit voluptas a','East Anjali',''),(42,'','1992-03-23',42,'Nobis illo consequuntur aperia','Erynshire','81026'),(43,'','1988-07-10',43,'Deserunt autem et tempora vel.','New Zionfurt','490'),(44,'','1982-08-25',44,'Laboriosam at id in et. Aut ad','Greenholtville',''),(45,'','2010-09-19',45,'Architecto et ipsam autem quae','Hoytshire','974414'),(46,'','2006-07-09',46,'Ipsa facere similique ducimus ','East Theodoreburgh','187754893'),(47,'','2009-11-30',47,'Quidem harum rerum rem volupta','South Danielleberg','521126'),(48,'','1975-09-28',48,'Dolor dolorem in maxime cumque','Strosinborough',''),(49,'','2016-07-23',49,'Quia laboriosam id modi eligen','South Dejonton','69046'),(50,'','1990-03-05',50,'Officia totam ea cumque dolor ','New Jodie','8821954'),(51,'','1996-10-23',51,'Porro corrupti voluptas tempor','Hermannport','8728'),(52,'','1988-02-24',52,'Id impedit molestiae sapiente.','Mannberg','45526'),(53,'','2019-05-31',53,'Soluta voluptatem fugiat culpa','Bernierfort','91038471'),(54,'','1981-12-28',54,'Tempora at et culpa voluptatem','East Noreneland','30064173'),(55,'','2008-07-09',55,'Sequi in eos et officia. Volup','North Kali','18129496'),(56,'','2007-08-21',56,'Qui aut nostrum nulla ex nihil','Purdyberg','260232853'),(57,'','2010-10-31',57,'Sunt aliquid autem ipsum omnis','Padbergfurt','463'),(58,'','1994-01-23',58,'Soluta saepe architecto conseq','West Skye','4'),(59,'','1976-03-31',59,'Expedita voluptatibus architec','West Cara','228730064'),(60,'','2014-03-31',60,'Quidem tenetur ut quod. Ullam ','North Raphaelville',''),(61,'','1983-10-29',61,'Voluptatem assumenda magnam do','Casperfurt','1413445'),(62,'','1990-01-22',62,'Aut sapiente natus est vel sin','North Aidenhaven','9'),(63,'','2012-07-02',63,'Ea enim et porro suscipit volu','East Tiana','8896764'),(64,'','1975-08-26',64,'Accusantium at voluptatibus op','West Lilliana','621686'),(65,'','1997-03-21',65,'Cupiditate rem dolorem eaque r','Skilesstad','2439'),(66,'','2010-10-08',66,'Quaerat ut non ut quis. Volupt','West Prestonport','1435'),(67,'','1973-12-24',67,'Est temporibus sequi nisi. Qui','Mavismouth','44'),(68,'','1990-08-05',68,'Ut laboriosam id quasi corpori','Trantowbury','5940547'),(69,'','1992-08-20',69,'Eius corporis asperiores corpo','Port Jerrold','17'),(70,'','2011-08-10',70,'Sunt omnis et provident quis p','Leefurt','914'),(71,'','1980-02-01',71,'Ea corporis consectetur impedi','Ignacioville','2110'),(72,'','2006-10-13',72,'Excepturi ex eos distinctio qu','Carmelshire','47420039'),(73,'','2002-04-22',73,'Dolor eos aut accusamus numqua','New Kevinport',''),(74,'','1970-10-10',74,'Est ex veritatis qui et. Fugit','Port Margot','7349'),(75,'','2000-05-28',75,'Repudiandae ut ut ex necessita','West Stonebury','3'),(76,'','1988-09-01',76,'Autem voluptas dignissimos lib','Batztown','91412'),(77,'','2000-10-26',77,'Neque quas aut eveniet dolore.','Kutchmouth','54'),(78,'','2005-07-10',78,'Provident repellat numquam mai','Treverborough','56116414'),(79,'','2004-07-03',79,'Eos dolorem consectetur aut si','Port Rethaton',''),(80,'','1981-09-01',80,'Dolor quod quo consectetur. Qu','Schusterport','9859'),(81,'','1974-01-11',81,'Sit quia fuga est. Rerum nemo ','North Yasmeen','53162'),(82,'','1995-11-18',82,'Alias error ipsa voluptatum ne','West Maudebury',''),(83,'','2001-03-02',83,'Officiis consequatur magnam de','Gardnerport','4'),(84,'','2016-11-26',84,'Rem ipsum veritatis possimus e','East Antoniomouth','35382790'),(85,'','2019-08-14',85,'Occaecati deleniti omnis odio ','West Zackary','7'),(86,'','1982-07-14',86,'Aut incidunt fuga consequatur ','Wardberg','893769524'),(87,'','1977-08-26',87,'Occaecati accusamus est tempor','North Ferneside','68329'),(88,'','1982-01-30',88,'Quaerat porro omnis aliquam qu','Dickinsonburgh',''),(89,'','2000-09-26',89,'Earum ex sapiente similique re','Willton','4'),(90,'','1993-02-18',90,'Aut nobis sed aut repellat dol','Marksland','167584585'),(91,'','1998-10-09',91,'Iure aut officiis aut ut ducim','New Nicholestad','962584523'),(92,'','2007-11-13',92,'Recusandae et est eos praesent','Nealfurt','639850'),(93,'','1982-04-29',93,'Dolores qui dicta occaecati od','West Warrenberg','521'),(94,'','2016-12-18',94,'Tempore sit dolorem nostrum ve','West Minnie','2819'),(95,'','2003-03-29',95,'Sit architecto officia tempora','South Bria','3'),(96,'','1976-04-06',96,'Nesciunt non dolores fugit pos','Lake Lula','33853'),(97,'','1974-02-05',97,'Voluptas enim aut fugit et omn','Kielhaven','6'),(98,'','1978-12-06',98,'Dicta aut beatae dolor pariatu','Dixieborough','5942'),(99,'','1973-05-20',99,'Omnis magni qui et id libero. ','West Natalie','981851'),(100,'','1984-11-27',100,'Voluptatum omnis natus autem a','Port Antonettaborough','7');
CREATE TEMPORARY TABLE gender
(g VARCHAR(1));
INSERT INTO gender
VALUES ('m'),('f'),('');
UPDATE profiles SET gender = (SELECT g FROM gender ORDER BY RAND() LIMIT 1);
DROP TABLE gender;

-- friendship_statuses
INSERT INTO friendship_statuses(id,name) VALUES (1,'quia'),(2,'eveniet'),(3,'sed');

-- friendship
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2012-12-23 21:41:22', '2004-09-21 01:44:16'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2018-05-07 15:41:54', '2005-03-21 00:53:07'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2004-07-02 06:18:17', '1980-07-14 16:46:21'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2020-10-31 16:56:14', '1981-01-02 15:36:32'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2020-02-17 13:34:20', '1989-05-01 00:20:59'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1974-08-04 05:15:04', '2002-08-01 05:44:56'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1990-08-09 05:29:13', '2001-06-10 11:18:25'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2015-02-10 22:44:43', '2007-05-01 14:54:59'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1970-05-25 17:11:45', '2014-02-01 22:36:49'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1990-01-26 16:00:18', '2000-04-05 22:24:50'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2018-05-22 03:35:51', '1998-05-22 11:01:18'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1999-08-05 15:39:44', '1974-02-09 05:48:16'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1996-11-10 00:59:57', '2014-06-03 17:09:05'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1996-09-26 11:46:44', '2004-03-14 23:15:35'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2012-11-07 19:44:03', '2008-07-11 06:35:28'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1997-08-02 19:52:01', '2002-04-12 22:03:19'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2016-10-24 07:08:22', '1997-02-04 19:44:09'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2017-09-01 20:32:45', '1986-01-04 17:47:35'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2001-02-15 14:25:05', '1988-01-27 01:27:04'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2019-06-28 03:40:22', '1983-04-15 20:55:53'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1985-11-22 07:27:21', '2011-05-15 09:18:41'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2000-02-03 12:06:38', '2004-08-16 13:19:43'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1973-04-15 01:26:21', '1978-10-20 20:14:54'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1996-07-05 22:38:32', '1973-11-07 23:44:48'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1973-04-23 01:36:55', '1974-11-06 05:44:22'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2005-12-15 10:57:24', '2002-05-14 12:24:46'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2012-11-19 00:39:01', '1986-04-04 13:51:44'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1980-02-14 21:37:28', '1994-04-30 00:16:28'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2019-05-07 13:30:21', '2018-10-12 13:47:01'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1987-08-07 11:20:44', '1985-12-08 22:34:26'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2020-09-28 20:32:09', '1999-01-26 18:01:00'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2004-10-16 00:55:41', '1978-01-02 17:44:08'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1975-12-18 16:36:58', '2005-10-24 20:09:01'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2004-08-05 16:10:01', '2016-03-21 09:10:44'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2019-08-30 06:39:49', '1981-08-03 05:49:32'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1992-09-18 23:57:54', '1998-04-11 02:44:57'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1984-08-08 01:44:15', '2011-06-03 00:28:17'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2019-06-08 12:48:12', '1996-05-15 07:48:31'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1991-08-30 05:17:11', '1997-09-22 02:28:16'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2002-06-03 11:27:33', '1989-11-01 08:58:11'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2017-11-22 17:27:47', '2014-11-30 14:19:17'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2004-06-07 00:37:27', '2009-03-19 06:28:21'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1992-04-07 03:19:42', '2006-10-20 23:16:17'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2008-11-15 07:37:48', '2015-05-20 07:19:58'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2008-04-19 20:17:13', '2018-06-26 21:29:43'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2003-10-15 02:05:05', '1980-07-03 07:53:26'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2007-07-23 09:11:40', '1990-10-08 11:35:13'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1973-09-17 19:52:42', '1982-05-18 00:49:02'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2013-07-30 09:40:29', '2008-01-01 19:26:29'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2017-08-18 15:12:48', '2011-07-21 07:32:53'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1995-04-05 08:44:45', '1978-03-20 08:17:00'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1980-05-21 06:03:14', '2005-11-18 20:06:50'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2012-05-09 02:11:26', '1987-08-07 00:30:31'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2006-03-15 13:29:19', '2009-02-07 11:44:50'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1970-09-15 15:43:27', '1983-06-08 05:45:34'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1978-06-29 00:13:52', '1977-02-14 05:00:38'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1994-04-18 20:23:03', '2019-11-09 00:34:03'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2009-01-26 21:46:54', '1990-05-09 00:18:00'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1989-02-14 05:37:34', '1995-01-04 02:04:36'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2006-02-27 03:19:53', '1977-11-07 11:16:37'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1992-08-12 09:01:33', '1991-02-24 22:01:41'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1977-06-04 23:53:20', '1986-01-01 04:43:06'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1972-11-21 03:43:02', '1982-09-19 21:45:02'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2012-11-14 03:50:48', '1998-05-01 05:29:43'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2019-02-11 02:58:24', '1971-06-22 08:58:21'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2018-04-23 21:35:18', '2003-07-08 07:14:42'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2014-12-05 15:04:59', '2011-08-30 19:51:08'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2012-01-05 08:12:25', '2019-09-06 18:21:00'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1988-09-30 07:12:12', '1994-07-26 05:19:37'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2011-06-27 05:37:52', '2007-10-25 12:16:33'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2000-02-16 21:23:16', '1986-02-04 12:25:24'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2015-07-14 08:14:47', '2017-04-30 09:22:13'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1977-08-22 04:24:57', '1982-05-11 23:50:06'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1978-12-28 09:55:09', '1986-02-05 23:20:27'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1995-12-22 09:34:56', '1976-11-26 16:04:05'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2018-12-01 19:57:48', '1994-12-23 09:46:59'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1998-07-10 10:31:14', '1970-08-17 09:16:59'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1982-10-24 16:45:35', '1981-07-27 02:32:45'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1977-07-31 06:13:15', '1974-02-16 10:06:49'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1980-01-15 05:44:28', '1994-10-16 07:07:05'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1972-02-28 19:44:17', '2018-04-13 17:32:53'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1974-12-06 13:11:09', '1995-10-05 05:26:32'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1982-12-22 14:30:29', '1979-07-22 00:33:25'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1974-01-24 22:37:34', '1997-07-13 16:01:50'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2012-11-11 09:39:05', '2005-10-28 15:27:57'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2011-03-25 21:47:12', '2001-01-29 20:50:31'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1990-12-14 08:18:02', '1983-09-27 10:24:01'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1974-02-10 16:44:47', '2020-08-01 23:39:25'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1983-04-03 20:54:56', '2001-08-03 09:29:40'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2000-04-12 09:18:36', '1992-07-05 05:12:32'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2002-06-06 03:47:53', '1989-10-17 09:32:28'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2011-06-27 09:19:35', '2003-12-21 05:02:30'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2011-03-11 08:36:07', '2013-01-09 05:37:58'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1989-09-08 20:43:49', '1980-03-08 06:54:41'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1995-12-01 03:16:55', '1990-01-23 02:54:39'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2019-01-13 18:58:52', '1993-02-27 18:41:22'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1986-05-22 17:08:41', '2011-12-07 22:03:12'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2003-11-23 16:26:56', '1974-04-06 19:48:38'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '2018-01-02 12:16:29', '1978-05-10 15:57:37'); COMMIT;
INSERT INTO friendship (user_id, friend_id, status_id, requested_at, confirmed_at) VALUES (RAND_ID_T('users'), RAND_ID_T('users'), RAND_ID_T('friendship_statuses'), '1971-07-24 03:47:42', '2016-12-10 09:37:24'); COMMIT;

-- Документация
-- https://dev.mysql.com/doc/refman/8.0/en/
-- http://www.rldp.ru/mysql/mysql80/index.htm

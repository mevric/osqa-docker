-- Reference SQL from osqa site
-- http://wiki.osqa.net/display/docs/Ubuntu+with+Apache+and+MySQL
--
-- sudo mysql -u root -p

-- execute this from root 
CREATE USER 'osqa'@'10.211.55.17' IDENTIFIED BY 'osqa';
--CREATE USER 'osqa'@'localhost' IDENTIFIED BY 'osqa';
SELECT User FROM mysql.user;
GRANT ALL PRIVILEGES ON *.* TO 'osqa'@'%' IDENTIFIED BY 'osqa' WITH GRANT OPTION;
CREATE DATABASE `osqa` DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT ALL ON osqa.* to 'osqa'@'%';

--Создайте базу данных example, разместите в ней таблицу users, состоящую из двух столбцов, числового id и строкового name.
CREATE SCHEMA example;
CREATE TABLE example.user (
	id INT PRIMARY KEY,
	name VARCHAR(250)
);
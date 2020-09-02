/*
Создайте базу данных example, разместите в ней таблицу users, состоящую из двух столбцов, числового id и строкового name.
*/
create database if not exists example;
use example;
create table users (id int, name varchar(50));

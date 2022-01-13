-- 1
/*
USE master;
CREATE database KASPER_UNIVER;
*/

-- 2
USE KASPER_UNIVER;
CREATE table STUDENT 
( 
	Номер_зачетки int not null primary key,
	Фамилия nvarchar(20) not null,
	Группа int not null constraint groupCh check (Группа > 0)
)

Select *from STUDENT;

--3
ALTER table STUDENT ADD Дата_поступления date;
ALTER table STUDENT ADD constraint CK_Дата_поступления check (Дата_поступления >= '01:09:2016');

ALTER table STUDENT DROP CK_Дата_поступления;
ALTER table STUDENT DROP COLUMN Дата_поступления;

--4
INSERT into STUDENT (Номер_зачетки, Фамилия, Группа) values (1, 'Касперович', 11), (2, 'Литягин', 11);
INSERT into STUDENT values (3, 'Божко', 11), (4, 'Величко', 12);

-- 5
SELECT *FROM STUDENT;
SELECT Группа[группа челика], Фамилия[челик] FROM STUDENT;
SELECT count(*)[Число_строк] FROM STUDENT;
SELECT count(*) FROM STUDENT Where Номер_зачетки < 4;

INSERT into STUDENT values (6, 'Величко', 11); 
SELECT Distinct Top(3) Фамилия, Группа FROM STUDENT Order by Фамилия Desc;

-- 5.1
SELECT *FROM STUDENT;

UPDATE STUDENT Set Группа = 5;
DELETE FROM STUDENT Where Номер_зачетки = 6;
SELECT *FROM STUDENT;

--6
Select *from student where Группа in (5, 6) AND Номер_зачетки Between 2 and 4 AND Фамилия Like 'Л%';

DROP table STUDENT;

--7
USE KASPER_UNIVER;
CREATE table RESULTS 
(
	ID int primary key identity(1,1),
	Student_Surname varchar(20),
	OOP real not null,
	DB real not null,
	Math real not null,
	Alter_value as (OOP+DB+Math)/3
)
INSERT into RESULTS values ('Касперович', 6, 6, 8), ('Lityagin', 9, 9, 6), ('Bozhko', 7, 7, 7);
SELECT *FROM RESULTS;

DROP table RESULTS;

-- 9
USE KASPER_MyBase;
--Select *from СТУДЕНТЫ;
--Select *from ЗАЧЕТЫ;
INSERT into СТУДЕНТЫ (Номер_студенческого, Фамилия) values (000000, 'Knyazeva'), (666666, 'Pleshkova');
Select top(3) *from СТУДЕНТЫ;

--USE KASPER_MyBase;
DELETE FROM СТУДЕНТЫ where Фамилия = 'Knyazeva' or Фамилия = 'Pleshkova';
Select *from СТУДЕНТЫ;



-- 10
USE KASPER_UNIVER;
CREATE TABLE STUDENT
(
	Номер_зачетки int primary key identity (100000, 1),
	ФИО varchar(50) not null,
	Дата_рождения date not null,
	Gender varchar(1),
	Дата_поступления date
);
ALTER table STUDENT ALTER COLUMN Дата_поступления date not null;

INSERT into STUDENT values 
	('Сулимова Е.Е.', '01-05-1990', 'ж', '01-01-2019'),
	('Литягин А.А.', '19-10-1995', 'м', '01-09-2019'),
	('Касперович Е.Н.', '01-06-1999', 'ж', '01-09-2019'),
	('Малютка М.М.', '13-04-2005', 'ж', '01-09-2020');

SELECT *FROM STUDENT;
SELECT *FROM STUDENT where Gender = 'ж' and DATEDIFF(YEAR, Дата_Рождения, Дата_Поступления) > 18;

DROP table STUDENT;

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

-- 1
USE E_Univer;

--drop view преподаватель;
go
CREATE VIEW [Преподаватель]
	as SELECT 
		TEACHER.TEACHER [Код],
		TEACHER.TEACHER_NAME [Имя преподавателя],
		TEACHER.GENDER[Пол],
		TEACHER.PULPIT[Кафедра]
	FROM TEACHER;		
go

SELECT * FROM Преподаватель;


-- 2
USE E_Univer;

--drop view Pulpits;
go
CREATE VIEW [Pulpits]
	as SELECT 
		FACULTY.FACULTY_NAME,
		count(*) [Количество кафедр]
	FROM FACULTY join PULPIT on PULPIT.FACULTY = FACULTY.FACULTY		
	GROUP BY FACULTY.FACULTY_NAME;
go

SELECT * FROM Pulpits;
insert Pulpits values ('Лесохозяйственный факультет', 7);

-- 3
USE E_Univer;

-- drop view auditorium
go
CREATE VIEW [Auditoriums]
	as SELECT 
		AUDITORIUM.AUDITORIUM [Код],
		AUDITORIUM.AUDITORIUM_NAME [Наименование аудитории]
	FROM AUDITORIUM
	WHERE AUDITORIUM.AUDITORIUM_TYPE like 'ЛК%';
go
select * from Auditoriums;
insert Auditoriums values ('240-1', '207-1');


-- 4 
USE E_Univer;


-- drop view Auditoriums_LK
go
CREATE VIEW [Auditoriums_LK]
	as SELECT 
		AUDITORIUM.AUDITORIUM [Код],
		AUDITORIUM.AUDITORIUM_NAME [Наименование аудитории]
	FROM AUDITORIUM
	WHERE AUDITORIUM.AUDITORIUM_TYPE like 'ЛК%'
	WITH CHECK OPTION;
go

insert Auditoriums_LK values ('240-8', '207-1');


-- 5 

USE E_Univer;

-- drop view [Disciplines]
go
CREATE VIEW [Disciplines]
	as SELECT 
	TOP 150
		SUBJECT.SUBJECT [Код],
		SUBJECT.SUBJECT_NAME [Название предмета],
		SUBJECT.PULPIT [Код кафедры]
	FROM SUBJECT
	ORDER BY SUBJECT.SUBJECT_NAME;
go

SELECT * FROM Disciplines;

-- 6

go
ALTER VIEW Pulpits WITH SCHEMABINDING 
	as SELECT 
		FACULTY.FACULTY_NAME,
		count(*) [Количество кафедр]
	FROM dbo.FACULTY join dbo.PULPIT on PULPIT.FACULTY = FACULTY.FACULTY	
	GROUP BY FACULTY.FACULTY_NAME;
go

--8
go
create view [Расписание]
as select LESSON [Номер пары], SUBJECT [Пара], IDGROUP [Группа] from TIMETABLE
group by IDGROUP, LESSON, SUBJECT;
go

select * from [Расписание];

select [Группа], [1] as [8.00-9.35], [2] as [9.50-11.25], 
[3] as [11.40-13.15], [4] as [13.50-15.25]
from [Расписание]
pivot(count([Пара]) for [Номер пары] in([1], [2], [3], [4])) as pivottt


-- 7
Use KASPER_MyNewBase;
go 
create view [Marks]
as SELECT 
		min(CREDITS.credit_mark) [Минимальная оценка],  
		max(CREDITS.credit_mark) [Максимальная оценка],  
		avg(CREDITS.credit_mark) [Средняя оценка],
		sum(CREDITS.credit_mark) [Сумма всех],
		count(CREDITS.credit_mark) [Количество полученных зачетов]
	FROM CREDITS;
go 

select * from Marks;

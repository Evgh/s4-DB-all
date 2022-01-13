-- 1
USE E_Univer;

--drop view �������������;
go
CREATE VIEW [�������������]
	as SELECT 
		TEACHER.TEACHER [���],
		TEACHER.TEACHER_NAME [��� �������������],
		TEACHER.GENDER[���],
		TEACHER.PULPIT[�������]
	FROM TEACHER;		
go

SELECT * FROM �������������;


-- 2
USE E_Univer;

--drop view Pulpits;
go
CREATE VIEW [Pulpits]
	as SELECT 
		FACULTY.FACULTY_NAME,
		count(*) [���������� ������]
	FROM FACULTY join PULPIT on PULPIT.FACULTY = FACULTY.FACULTY		
	GROUP BY FACULTY.FACULTY_NAME;
go

SELECT * FROM Pulpits;
insert Pulpits values ('����������������� ���������', 7);

-- 3
USE E_Univer;

-- drop view auditorium
go
CREATE VIEW [Auditoriums]
	as SELECT 
		AUDITORIUM.AUDITORIUM [���],
		AUDITORIUM.AUDITORIUM_NAME [������������ ���������]
	FROM AUDITORIUM
	WHERE AUDITORIUM.AUDITORIUM_TYPE like '��%';
go
select * from Auditoriums;
insert Auditoriums values ('240-1', '207-1');


-- 4 
USE E_Univer;


-- drop view Auditoriums_LK
go
CREATE VIEW [Auditoriums_LK]
	as SELECT 
		AUDITORIUM.AUDITORIUM [���],
		AUDITORIUM.AUDITORIUM_NAME [������������ ���������]
	FROM AUDITORIUM
	WHERE AUDITORIUM.AUDITORIUM_TYPE like '��%'
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
		SUBJECT.SUBJECT [���],
		SUBJECT.SUBJECT_NAME [�������� ��������],
		SUBJECT.PULPIT [��� �������]
	FROM SUBJECT
	ORDER BY SUBJECT.SUBJECT_NAME;
go

SELECT * FROM Disciplines;

-- 6

go
ALTER VIEW Pulpits WITH SCHEMABINDING 
	as SELECT 
		FACULTY.FACULTY_NAME,
		count(*) [���������� ������]
	FROM dbo.FACULTY join dbo.PULPIT on PULPIT.FACULTY = FACULTY.FACULTY	
	GROUP BY FACULTY.FACULTY_NAME;
go

--8
go
create view [����������]
as select LESSON [����� ����], SUBJECT [����], IDGROUP [������] from TIMETABLE
group by IDGROUP, LESSON, SUBJECT;
go

select * from [����������];

select [������], [1] as [8.00-9.35], [2] as [9.50-11.25], 
[3] as [11.40-13.15], [4] as [13.50-15.25]
from [����������]
pivot(count([����]) for [����� ����] in([1], [2], [3], [4])) as pivottt


-- 7
Use KASPER_MyNewBase;
go 
create view [Marks]
as SELECT 
		min(CREDITS.credit_mark) [����������� ������],  
		max(CREDITS.credit_mark) [������������ ������],  
		avg(CREDITS.credit_mark) [������� ������],
		sum(CREDITS.credit_mark) [����� ����],
		count(CREDITS.credit_mark) [���������� ���������� �������]
	FROM CREDITS;
go 

select * from Marks;
